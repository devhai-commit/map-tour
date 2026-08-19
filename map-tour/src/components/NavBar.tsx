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

export function NavBar() {
  const { village } = useVillage();

  return (
    <header className="nav-bar">
      <div className="nav-bar__inner">
        <NavLink to="." end className="nav-bar__brand">
          {village?.name ?? '...'}
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
