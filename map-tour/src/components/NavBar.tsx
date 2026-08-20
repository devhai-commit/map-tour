import { NavLink } from 'react-router-dom';
import { useVillage } from '../context/VillageContext';

const NAV_ITEMS: Array<{ to: string; label: string; end?: boolean }> = [
  { to: '/', label: 'Trang chủ', end: true },
  { to: '.', label: 'Trang làng', end: true },
  { to: 'gioi-thieu', label: 'Giới thiệu' },
  { to: 'map', label: 'Bản đồ' },
  { to: 'di-san', label: 'Danh sách di sản' },
  { to: '360', label: 'Trải nghiệm 360°' },
];

// Ước Lễ's curated Google My Maps layer is more complete than the in-app
// map for this village, so its "Bản đồ" tab links straight out to it instead
// of the internal /map route. Other villages keep the internal map.
const UOC_LE_SLUG = 'lang-uoc-le';
const UOC_LE_GOOGLE_MAPS_URL =
  'https://www.google.com/maps/d/u/0/viewer?mid=1FSfpZVwnCOeQQ77lkjT_zfsOGrOTNps&ll=20.82282640394975%2C105.81270017822966&z=15';

export function NavBar() {
  const { village } = useVillage();

  return (
    <header className="nav-bar">
      <div className="nav-bar__inner">
        <NavLink to="." end className="nav-bar__brand">
          {village?.name ?? '...'}
        </NavLink>
        <nav className="nav-bar__links">
          {NAV_ITEMS.map((item) => {
            if (item.to === 'map' && village?.slug === UOC_LE_SLUG) {
              return (
                <a
                  key={item.to}
                  href={UOC_LE_GOOGLE_MAPS_URL}
                  target="_blank"
                  rel="noreferrer"
                  className="nav-bar__link"
                >
                  {item.label}
                </a>
              );
            }

            return (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.end}
                className={({ isActive }) => (isActive ? 'nav-bar__link nav-bar__link--active' : 'nav-bar__link')}
              >
                {item.label}
              </NavLink>
            );
          })}
        </nav>
      </div>
    </header>
  );
}
