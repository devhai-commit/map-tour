import { useNavigate } from 'react-router-dom';
import { useSites } from '../context/SitesContext';
import { usePanorama } from '../context/PanoramaContext';
import { useVillage } from '../context/VillageContext';

interface ValueCard {
  title: string;
  description: string;
}

function buildValueCards(village: ReturnType<typeof useVillage>['village']): ValueCard[] {
  if (!village) return [];
  const cards: ValueCard[] = [];
  if (village.mainOccupations.length > 0) {
    cards.push({ title: 'Nghề truyền thống', description: village.mainOccupations.join(', ') });
  }
  if (village.foundedPeriod) {
    cards.push({ title: 'Hình thành', description: village.foundedPeriod });
  }
  if (village.adminLocation) {
    cards.push({ title: 'Vị trí', description: village.adminLocation });
  }
  return cards;
}

export function HomePage() {
  const navigate = useNavigate();
  const { openPanorama } = usePanorama();
  const { sites, isLoading, error } = useSites();
  const { village } = useVillage();
  const values = buildValueCards(village);

  return (
    <div className="home">
      <section className="home__hero">
        <p className="home__hero-eyebrow">Du lịch làng nghề số</p>
        <h1>{village?.name ?? '...'}</h1>
        <p className="home__hero-lead">
          Bản đồ số các di tích và khu vực di sản trong làng — điểm thí điểm của đề tài nghiên cứu du lịch thông
          minh làng truyền thống vùng đồng bằng sông Hồng.
        </p>
        <div className="home__hero-actions">
          <button type="button" className="home__cta home__cta--primary" onClick={() => navigate('map')}>
            Khám phá bản đồ
          </button>
          <button type="button" className="home__cta home__cta--ghost" onClick={() => navigate('360')}>
            Xem trải nghiệm 360°
          </button>
        </div>
      </section>

      {values.length > 0 && (
        <section className="home__values">
          <h2 className="home__values-heading">Giá trị nổi bật</h2>
          <div className="home__values-grid">
            {values.map((value) => (
              <div key={value.title} className="home__value">
                <h3>{value.title}</h3>
                <p>{value.description}</p>
              </div>
            ))}
          </div>
        </section>
      )}

      <section className="home__featured">
        <div className="home__featured-heading">
          <div>
            <span className="home__section-eyebrow">Di sản tiêu biểu</span>
            <h2>Điểm tham quan trong làng</h2>
          </div>
          <button type="button" className="home__link" onClick={() => navigate('di-san')}>
            Xem danh sách đầy đủ →
          </button>
        </div>
        {isLoading && (
          <p className="home__status" role="status">
            Đang tải dữ liệu điểm tham quan...
          </p>
        )}
        {error && (
          <p className="home__status home__status--error" role="alert">
            {error}
          </p>
        )}
        <div className="home__featured-grid">
          {sites.map((site) => (
            <article key={site.id} className="home__featured-card">
              {site.cover && (
                <img
                  className="home__featured-image"
                  src={site.cover.url}
                  alt={site.name}
                  loading="lazy"
                  decoding="async"
                  width={800}
                  height={600}
                />
              )}
              <div className="home__featured-body">
                <span className={`home__featured-badge home__featured-badge--${site.kind}`}>
                  {site.kind === 'point' ? 'Điểm di tích' : 'Khu vực'}
                </span>
                <h3>{site.name}</h3>
                <p>{site.description}</p>
                <div className="home__featured-actions">
                  <button type="button" onClick={() => navigate(`map?site=${site.id}`)}>
                    Xem trên bản đồ
                  </button>
                  {site.panorama && (
                    <button type="button" className="home__featured-panorama" onClick={() => openPanorama(site.id)}>
                      Xem 360°
                    </button>
                  )}
                </div>
              </div>
            </article>
          ))}
        </div>
      </section>

      <footer className="home__footer-note">
        Dữ liệu toạ độ hiện là minh hoạ cho mục đích nghiên cứu, chưa phải kết quả khảo sát thực địa.
      </footer>
    </div>
  );
}
