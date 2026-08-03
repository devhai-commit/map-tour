import { Route, Routes } from 'react-router-dom';
import { NavBar } from './components/NavBar';
import { SitesProvider } from './context/SitesContext';
import { PanoramaProvider } from './context/PanoramaContext';
import { HomePage } from './pages/HomePage';
import { MapPage } from './pages/MapPage';
import { HeritageListPage } from './pages/HeritageListPage';
import { Experience3DPage } from './pages/Experience3DPage';

export function App() {
  return (
    <SitesProvider>
      <PanoramaProvider>
        <div className="app">
          <NavBar />
          <main className="app__main">
            <Routes>
              <Route path="/" element={<HomePage />} />
              <Route path="/map" element={<MapPage />} />
              <Route path="/di-san" element={<HeritageListPage />} />
              <Route path="/360" element={<Experience3DPage />} />
            </Routes>
          </main>
        </div>
      </PanoramaProvider>
    </SitesProvider>
  );
}
