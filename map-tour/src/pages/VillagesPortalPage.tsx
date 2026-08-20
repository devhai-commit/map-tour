import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { fetchVillages } from '../lib/api';
import type { Village } from '../types';

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

      <section className="portal__hero">
        <p className="portal__hero-eyebrow">Du lịch làng nghề số</p>
        <h1>Khám phá các làng nghề di sản</h1>
        <p className="portal__hero-lead">
          Bản đồ số và tư liệu di sản của nhiều làng nghề truyền thống — mỗi làng một câu chuyện, một bản đồ,
          một trải nghiệm 360° riêng.
        </p>
      </section>

      <section className="portal__villages">
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
          {villages.map((village) => (
            <Link key={village.id} to={`/lang/${village.slug}/gioi-thieu`} className="portal__village-card">
              {village.coverUrl && (
                <img
                  className="portal__village-image"
                  src={village.coverUrl}
                  alt={village.name}
                  loading="lazy"
                  decoding="async"
                  width={800}
                  height={600}
                />
              )}
              <div className="portal__village-body">
                <h2>{village.name}</h2>
                {village.adminLocation && <p className="portal__village-location">{village.adminLocation}</p>}
                {village.mainOccupations.length > 0 && (
                  <p className="portal__village-occupations">{village.mainOccupations.join(', ')}</p>
                )}
              </div>
            </Link>
          ))}
        </div>
      </section>
    </div>
  );
}
