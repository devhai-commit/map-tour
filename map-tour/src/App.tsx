import { lazy, Suspense } from 'react';
import { Route, Routes } from 'react-router-dom';
import { VillageLayout } from './components/VillageLayout';
import { VillagesPortalPage } from './pages/VillagesPortalPage';
import { HomePage } from './pages/HomePage';
import { HeritageListPage } from './pages/HeritageListPage';

const MapPage = lazy(() => import('./pages/MapPage').then((m) => ({ default: m.MapPage })));
const Experience3DPage = lazy(() =>
  import('./pages/Experience3DPage').then((m) => ({ default: m.Experience3DPage })),
);
const AdminImportPage = lazy(() =>
  import('./pages/AdminImportPage').then((m) => ({ default: m.AdminImportPage })),
);

export function App() {
  return (
    <div className="app">
      <Suspense fallback={<p className="app__route-loading">Đang tải...</p>}>
        <Routes>
          <Route path="/" element={<VillagesPortalPage />} />
          <Route path="/lang/:villageSlug" element={<VillageLayout />}>
            <Route index element={<HomePage />} />
            <Route path="map" element={<MapPage />} />
            <Route path="di-san" element={<HeritageListPage />} />
            <Route path="360" element={<Experience3DPage />} />
          </Route>
          <Route path="/admin/import" element={<AdminImportPage />} />
        </Routes>
      </Suspense>
    </div>
  );
}
