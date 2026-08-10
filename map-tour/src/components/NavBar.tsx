import { NavLink } from 'react-router-dom';
import { useSites } from '../context/SitesContext';
import { APP_ROUTES } from '../routes';

const NAV_ITEMS: Array<{ to: string; label: string; end?: boolean }> = [
  { to: APP_ROUTES.home, label: 'Trang chủ', end: true },
  { to: APP_ROUTES.villageIntroduction, label: 'Giới thiệu' },
  { to: APP_ROUTES.map, label: 'Bản đồ' },
  { to: APP_ROUTES.heritage, label: 'Danh sách di sản' },
  { to: APP_ROUTES.panorama, label: 'Trải nghiệm 360°' },
];

export function NavBar() {
  const { sites } = useSites();

  return (
    <header className="nav-bar">
      <div className="nav-bar__inner">
        <NavLink to={APP_ROUTES.home} className="nav-bar__brand">
          {sites[0]?.village ?? 'Làng Ước Lễ'}
        </NavLink>
        <nav className="nav-bar__links">
          {NAV_ITEMS.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) => (isActive ? 'nav-bar__link nav-bar__link--active' : 'nav-bar__link')}
            >
              {item.label}
            </NavLink>
          ))}
        </nav>
      </div>
    </header>
  );
}
