import { Link, Outlet, useParams } from 'react-router-dom';
import { VillageProvider, useVillage } from '../context/VillageContext';
import { SitesProvider } from '../context/SitesContext';
import { PanoramaProvider } from '../context/PanoramaContext';
import { NavBar } from './NavBar';

function VillageChrome() {
  const { village, isLoading, error } = useVillage();

  if (!isLoading && (error || !village)) {
    return (
      <main className="app__main">
        <div className="village-not-found">
          <p>Không tìm thấy làng này.</p>
          <Link to="/">← Về danh sách làng</Link>
        </div>
      </main>
    );
  }

  return (
    <>
      <NavBar />
      <main className="app__main">
        <Outlet />
      </main>
    </>
  );
}

export function VillageLayout() {
  const { villageSlug } = useParams<{ villageSlug: string }>();
  if (!villageSlug) return null;

  return (
    <VillageProvider villageSlug={villageSlug}>
      <SitesProvider villageSlug={villageSlug}>
        <PanoramaProvider>
          <VillageChrome />
        </PanoramaProvider>
      </SitesProvider>
    </VillageProvider>
  );
}
