import { lazy, Suspense } from 'react';
import { Route, Routes } from 'react-router-dom';
import { NavBar } from './components/NavBar';
import { SitesProvider } from './context/SitesContext';
import { PanoramaProvider } from './context/PanoramaContext';
import { HomePage } from './pages/HomePage';
import { HeritageListPage } from './pages/HeritageListPage';
import { APP_ROUTES } from './routes';

const MapPage = lazy(() => import('./pages/MapPage').then((m) => ({ default: m.MapPage })));
const Experience3DPage = lazy(() =>
  import('./pages/Experience3DPage').then((m) => ({ default: m.Experience3DPage })),
);
const VillageIntroductionPage = lazy(() =>
  import('./pages/VillageIntroductionPage').then((m) => ({ default: m.VillageIntroductionPage })),
);

export function App() {
  return (
    <SitesProvider>
      <PanoramaProvider>
        <div className="app">
          <NavBar />
          <main className="app__main">
            <Suspense fallback={<p className="app__route-loading">Đang tải...</p>}>
              <Routes>
                <Route path={APP_ROUTES.home} element={<HomePage />} />
                <Route path={APP_ROUTES.villageIntroduction} element={<VillageIntroductionPage />} />
                <Route path={APP_ROUTES.map} element={<MapPage />} />
                <Route path={APP_ROUTES.heritage} element={<HeritageListPage />} />
                <Route path={APP_ROUTES.panorama} element={<Experience3DPage />} />
              </Routes>
            </Suspense>
          </main>
        </div>
      </PanoramaProvider>
    </SitesProvider>
  );
}
