import { lazy, Suspense } from 'react';
import { Route, Routes } from 'react-router-dom';
import { NavBar } from './components/NavBar';
import { SitesProvider } from './context/SitesContext';
import { PanoramaProvider } from './context/PanoramaContext';
import { HomePage } from './pages/HomePage';
import { HeritageListPage } from './pages/HeritageListPage';

const MapPage = lazy(() => import('./pages/MapPage').then((m) => ({ default: m.MapPage })));
const Experience3DPage = lazy(() =>
  import('./pages/Experience3DPage').then((m) => ({ default: m.Experience3DPage })),
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
                <Route path="/" element={<HomePage />} />
                <Route path="/map" element={<MapPage />} />
                <Route path="/di-san" element={<HeritageListPage />} />
                <Route path="/360" element={<Experience3DPage />} />
              </Routes>
            </Suspense>
          </main>
        </div>
      </PanoramaProvider>
    </SitesProvider>
  );
}
