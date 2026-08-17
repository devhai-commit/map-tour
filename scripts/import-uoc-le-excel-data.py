#!/usr/bin/env python3
"""Import the two approved Ước Lễ workbook sheets into the local dev database."""

from __future__ import annotations

import argparse
import os
import re
import subprocess
from pathlib import Path
from xml.etree import ElementTree as ET
from zipfile import ZipFile


REPO_ROOT = Path(__file__).resolve().parents[1]
WORKBOOK = REPO_ROOT.parent / "reference-data" / "lang-uoc-le.xlsx"
SHEETS = {"1.Giới thiệu về làng", "3. Lịch sử văn hóa"}
VILLAGE_NAME = "Làng Ước Lễ"
NS = {
    "m": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
}


def read_workbook() -> dict[str, dict[str, str]]:
    with ZipFile(WORKBOOK) as archive:
        shared: list[str] = []
        if "xl/sharedStrings.xml" in archive.namelist():
            root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
            shared = ["".join(node.text or "" for node in item.iterfind(".//m:t", NS)) for item in root.findall("m:si", NS)]

        workbook = ET.fromstring(archive.read("xl/workbook.xml"))
        relationships = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
        targets = {item.attrib["Id"]: item.attrib["Target"] for item in relationships}
        result: dict[str, dict[str, str]] = {}

        sheets_element = workbook.find("m:sheets", NS)
        if sheets_element is None:
            raise RuntimeError("Workbook has no sheets")
        for sheet in sheets_element:
            name = sheet.attrib["name"]
            if name not in SHEETS:
                continue
            relationship_id = sheet.attrib[f"{{{NS['r']}}}id"]
            target = targets[relationship_id]
            sheet_path = target if target.startswith("xl/") else f"xl/{target.lstrip('/')}"
            root = ET.fromstring(archive.read(sheet_path))
            fields: dict[str, str] = {}
            for row in root.findall(".//m:sheetData/m:row", NS):
                values: dict[str, str] = {}
                for cell in row.findall("m:c", NS):
                    reference = cell.attrib.get("r", "")
                    match = re.match(r"[A-Z]+", reference)
                    if not match or match.group(0) not in {"A", "B"}:
                        continue
                    column = match.group(0)
                    value = cell.find("m:v", NS)
                    inline = cell.find("m:is", NS)
                    if cell.attrib.get("t") == "s" and value is not None:
                        text = shared[int(value.text or "0")]
                    elif cell.attrib.get("t") == "inlineStr" and inline is not None:
                        text = "".join(node.text or "" for node in inline.iterfind(".//m:t", NS))
                    else:
                        text = value.text if value is not None and value.text else ""
                    values[column] = " ".join(text.split())
                if values.get("A") and values.get("B") and values["A"] != "Nội dung":
                    fields[values["A"]] = values["B"]
            result[name] = fields

    missing = SHEETS.difference(result)
    if missing:
        raise RuntimeError(f"Missing required sheets: {', '.join(sorted(missing))}")
    return result


def sentence_containing(text: str, phrase: str, include_next: int = 0) -> str:
    sentences = re.split(r"(?<=[.!?])\s+", text.strip())
    for index, sentence in enumerate(sentences):
        if phrase.casefold() in sentence.casefold():
            return " ".join(sentences[index : index + include_next + 1])
    raise RuntimeError(f"Expected phrase not found in workbook data: {phrase}")


def sql_literal(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def build_import_data(fields: dict[str, dict[str, str]]):
    village = fields["1.Giới thiệu về làng"]
    culture = fields["3. Lịch sử văn hóa"]
    history_overview = culture["Lịch sử làng"]
    events = culture["Sự kiện lịch sử đã diễn ra"]
    legends = culture["Truyền thuyết"]

    village_values = {
        "aliases": [village["Tên khác (nếu có)"].strip()],
        "admin_location": village["Hành chính"].strip(),
        "founded_period": "Thế kỷ XVI" if village["Thời điểm hình thành"].strip().casefold() == "tk 16" else village["Thời điểm hình thành"].strip(),
        "brand_identity": village["Định danh thương hiệu (nếu có)"].strip(),
        "name_meaning": village["Ý nghĩa của tên"].strip(),
        "main_occupations": [item.strip().capitalize() for item in village["Nghề nghiệp chính của người dân trong làng"].split(",") if item.strip()],
        "natural_features": village["Đặc điểm tự nhiên"].strip().capitalize(),
        "morphology_description": village["Sơ đồ khắc họa ý tưởng hình thái làng"].strip(),
    }

    stories = [
        ("lich_su", "Tổng quan Làng Ước Lễ", history_overview),
        ("lich_su", "Thế kỷ XVI — Làng Ước Lễ hình thành", "Theo tư liệu khảo sát, Làng Ước Lễ hình thành vào thế kỷ XVI."),
        ("lich_su", "Thời nhà Mạc — Nghề giò chả được truyền dạy", history_overview),
        ("su_kien", "Năm 1851 — Cổng làng được xây dựng", sentence_containing(events, "1851")),
        ("su_kien", "Thời kỳ chống Pháp — Cổng làng bị hư hại", sentence_containing(events, "thời chống Pháp")),
        ("su_kien", "Khoảng năm 2000 — Cổng làng được phục dựng", sentence_containing(events, "khoảng năm 2000")),
        ("su_kien", "Năm 1928 — Hương ước làng", sentence_containing(legends, "năm 1928", include_next=1)),
        ("phong_tuc", "Tết bù — nét riêng của người Ước Lễ", culture["Phong tục"].strip().capitalize()),
        ("su_kien", "Nghĩa thương và Mỹ tục khả phong", sentence_containing(legends, "Nghĩa thương", include_next=2)),
        (
            "truyen_thuyet",
            "Truyền thuyết về Thành hoàng Lữ Gia",
            "Theo truyền thuyết được ghi trong tư liệu khảo sát, sau một trận đánh, ông Lữ Gia về đến cây đa trước cổng làng rồi qua đời. Dân làng tôn ông làm Thành hoàng và thờ tại đình làng cho đến nay.",
        ),
    ]
    video_url = culture.get("Bộ sưu tập video nói về lịch sử và văn hóa làng", "").strip()
    if not re.fullmatch(r"https://www\.youtube\.com/watch\?v=[A-Za-z0-9_-]+", video_url):
        video_url = ""
    return village_values, stories, video_url


def build_sql(village_values, stories, video_url: str) -> str:
    aliases = "ARRAY[" + ",".join(sql_literal(value) for value in village_values["aliases"]) + "]::text[]"
    occupations = "ARRAY[" + ",".join(sql_literal(value) for value in village_values["main_occupations"]) + "]::text[]"
    statements = [
        "BEGIN;",
        "SELECT pg_advisory_xact_lock(hashtext('import-uoc-le-excel-data'));",
        "DO $$ BEGIN IF (SELECT count(*) FROM villages WHERE name = 'Làng Ước Lễ') <> 1 THEN RAISE EXCEPTION 'Expected exactly one Làng Ước Lễ village'; END IF; END $$;",
        f"UPDATE villages SET aliases={aliases}, admin_location={sql_literal(village_values['admin_location'])}, founded_period={sql_literal(village_values['founded_period'])}, brand_identity={sql_literal(village_values['brand_identity'])}, name_meaning={sql_literal(village_values['name_meaning'])}, main_occupations={occupations}, natural_features={sql_literal(village_values['natural_features'])}, morphology_description={sql_literal(village_values['morphology_description'])} WHERE name={sql_literal(VILLAGE_NAME)};",
    ]
    for story_type, title, body in stories:
        statements.extend(
            [
                f"UPDATE history_stories SET body_text={sql_literal(body)} WHERE village_id=(SELECT id FROM villages WHERE name={sql_literal(VILLAGE_NAME)}) AND type={sql_literal(story_type)} AND title={sql_literal(title)};",
                f"INSERT INTO history_stories (village_id, type, title, body_text) SELECT id, {sql_literal(story_type)}, {sql_literal(title)}, {sql_literal(body)} FROM villages v WHERE v.name={sql_literal(VILLAGE_NAME)} AND NOT EXISTS (SELECT 1 FROM history_stories h WHERE h.village_id=v.id AND h.type={sql_literal(story_type)} AND h.title={sql_literal(title)});",
            ]
        )
    if video_url:
        statements.extend(
            [
                f"UPDATE media SET caption='Video tư liệu lịch sử và văn hóa Làng Ước Lễ' WHERE owner_entity_type='villages' AND owner_entity_id=(SELECT id FROM villages WHERE name={sql_literal(VILLAGE_NAME)}) AND kind='video' AND url={sql_literal(video_url)};",
                f"INSERT INTO media (url, kind, caption, owner_entity_type, owner_entity_id) SELECT {sql_literal(video_url)}, 'video', 'Video tư liệu lịch sử và văn hóa Làng Ước Lễ', 'villages', id FROM villages v WHERE v.name={sql_literal(VILLAGE_NAME)} AND NOT EXISTS (SELECT 1 FROM media m WHERE m.owner_entity_type='villages' AND m.owner_entity_id=v.id AND m.kind='video' AND m.url={sql_literal(video_url)});",
            ]
        )
    statements.extend(["COMMIT;", ""])
    return "\n".join(statements)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true", help="validate and print planned record counts only")
    args = parser.parse_args()
    fields = read_workbook()
    village_values, stories, video_url = build_import_data(fields)
    print(f"Workbook: {WORKBOOK}")
    print("Target: slug lang-uoc-le -> Làng Ước Lễ")
    print(f"Planned village updates: 1")
    print(f"Planned history upserts: {len(stories)}")
    print(f"Planned video media upserts: {1 if video_url else 0}")
    if args.dry_run:
        return

    postgres_user = os.environ.get("POSTGRES_USER")
    postgres_db = os.environ.get("POSTGRES_DB")
    if not postgres_user or not postgres_db:
        raise RuntimeError("POSTGRES_USER and POSTGRES_DB must be supplied in the process environment")
    subprocess.run(
        ["docker", "compose", "exec", "-T", "postgres", "psql", "-U", postgres_user, "-d", postgres_db, "-v", "ON_ERROR_STOP=1"],
        cwd=REPO_ROOT,
        input=build_sql(village_values, stories, video_url),
        text=True,
        check=True,
    )


if __name__ == "__main__":
    main()
