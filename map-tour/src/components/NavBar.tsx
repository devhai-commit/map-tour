import { NavLink } from 'react-router-dom';
import { useSites } from '../context/SitesContext';

const NAV_ITEMS: Array<{ to: string; label: string; end?: boolean }> = [
  { to: '/', label: 'Trang chủ', end: true },
  { to: '/map', label: 'Bản đồ' },
  { to: '/di-san', label: 'Danh sách di sản' },
  { to: '/360', label: 'Trải nghiệm 360°' },
];

export function NavBar() {
  const { sites } = useSites();

  return (
    <header className="nav-bar">
      <div className="nav-bar__inner">
        <NavLink to="/" className="nav-bar__brand">
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
