import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { fetchVillages } from '../lib/api';
import type { Village } from '../types';

function buildVillageBlurb(village: Village): string | null {
  if (village.mainOccupations.length > 0) {
    return `Nổi tiếng với ${village.mainOccupations.join(', ')}.`;
  }
  if (village.foundedPeriod) {
    return `Hình thành từ ${village.foundedPeriod}, còn gìn giữ nhiều giá trị di sản truyền thống.`;
  }
  return null;
}

export function VillagesPortalPage() {
  const [villages, setVillages] = useState<Village[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();

    async function load() {
      try {
        const data = await fetchVillages();
        if (!controller.signal.aborted) {
          setVillages(data);
          setError(null);
        }
      } catch (cause: unknown) {
        if (!controller.signal.aborted) {
          setError(cause instanceof Error ? cause.message : 'Không tải được danh sách làng.');
        }
      } finally {
        if (!controller.signal.aborted) {
          setIsLoading(false);
        }
      }
    }

    load();
    return () => controller.abort();
  }, []);

  return (
    <div className="portal">
      <header className="portal__header">
        <Link to="/" className="portal__brand">
          Làng nghề di sản Việt Nam
        </Link>
      </header>

      <section
        className="portal__hero"
        style={{
          backgroundImage:
            'linear-gradient(180deg, rgba(20, 6, 2, 0.55), rgba(20, 6, 2, 0.75)), url(/lang-que-8.jpg)',
        }}
      >
        <div className="portal__hero-content">
          <h1>Hành Trình Khám Phá Di Sản</h1>
          <p className="portal__hero-lead">
            Chạm vào linh hồn của làng quê Việt. Trải nghiệm kiến trúc cổ kính, nghệ thuật thủ công tinh xảo và câu
            chuyện văn hoá ngàn năm qua lăng kính kỹ thuật số.
          </p>
          <a className="portal__hero-cta" href="#portal-villages">
            Bắt đầu hành trình
          </a>
        </div>
      </section>

      <section className="portal__villages" id="portal-villages">
        <div className="portal__villages-heading">
          <h2>Làng Di Sản Tiêu Biểu</h2>
          <p>Những điểm đến gìn giữ trọn vẹn tinh hoa nghề truyền thống và kiến trúc cổ.</p>
        </div>

        {isLoading && (
          <p className="portal__status" role="status">
            Đang tải danh sách làng...
          </p>
        )}
        {error && (
          <p className="portal__status portal__status--error" role="alert">
            {error}
          </p>
        )}
        {!isLoading && !error && villages.length === 0 && (
          <p className="portal__status">Chưa có làng nào được thêm vào hệ thống.</p>
        )}
        <div className="portal__village-grid">
          {villages.map((village) => {
            const blurb = buildVillageBlurb(village);
            return (
              <Link key={village.id} to={`/lang/${village.slug}/gioi-thieu`} className="portal__village-card">
                {village.coverUrl ? (
                  <img
                    className="portal__village-image"
                    src={village.coverUrl}
                    alt={village.name}
                    loading="lazy"
                    decoding="async"
                    width={800}
                    height={600}
                  />
                ) : (
                  <div className="portal__village-image portal__village-image--placeholder" aria-hidden="true">
                    {village.name.charAt(0)}
                  </div>
                )}
                <div className="portal__village-body">
                  <h3>{village.name}</h3>
                  {village.adminLocation && (
                    <p className="portal__village-location">
                      <svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor" aria-hidden="true">
                        <path d="M12 2C7.58 2 4 5.58 4 10c0 5.25 6.72 11.19 7 11.44a1.5 1.5 0 0 0 2 0C13.28 21.19 20 15.25 20 10c0-4.42-3.58-8-8-8zm0 11a3 3 0 1 1 0-6 3 3 0 0 1 0 6z" />
                      </svg>
                      {village.adminLocation}
                    </p>
                  )}
                  {blurb && <p className="portal__village-blurb">{blurb}</p>}
                  <span className="portal__village-link">
                    Khám phá <span aria-hidden="true">→</span>
                  </span>
                </div>
              </Link>
            );
          })}
        </div>
      </section>
    </div>
  );
}
