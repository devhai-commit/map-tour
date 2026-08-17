import { createContext, useContext, useEffect, useState, type ReactNode } from 'react';
import { fetchSites } from '../lib/api';
import type { TourSite } from '../types';

interface SitesContextValue {
  sites: TourSite[];
  isLoading: boolean;
  error: string | null;
}

const SitesContext = createContext<SitesContextValue | null>(null);

export function SitesProvider({ villageSlug, children }: { villageSlug: string; children: ReactNode }) {
  const [sites, setSites] = useState<TourSite[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();
    setIsLoading(true);

    async function load() {
      try {
        const data = await fetchSites(villageSlug);
        if (!controller.signal.aborted) {
          setSites(data);
          setError(null);
        }
      } catch (cause: unknown) {
        if (!controller.signal.aborted) {
          setError(cause instanceof Error ? cause.message : 'Không tải được dữ liệu điểm tham quan.');
        }
      } finally {
        if (!controller.signal.aborted) {
          setIsLoading(false);
        }
      }
    }

    load();
    return () => controller.abort();
  }, [villageSlug]);

  return <SitesContext.Provider value={{ sites, isLoading, error }}>{children}</SitesContext.Provider>;
}

export function useSites(): SitesContextValue {
  const context = useContext(SitesContext);
  if (!context) throw new Error('useSites must be used within a SitesProvider');
  return context;
}
