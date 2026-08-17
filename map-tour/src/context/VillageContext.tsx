import { createContext, useContext, useEffect, useState, type ReactNode } from 'react';
import { fetchVillage } from '../lib/api';
import type { Village } from '../types';

interface VillageContextValue {
  village: Village | null;
  isLoading: boolean;
  error: string | null;
}

const VillageContext = createContext<VillageContextValue | null>(null);

export function VillageProvider({ villageSlug, children }: { villageSlug: string; children: ReactNode }) {
  const [village, setVillage] = useState<Village | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const controller = new AbortController();
    setIsLoading(true);

    async function load() {
      try {
        const data = await fetchVillage(villageSlug);
        if (!controller.signal.aborted) {
          setVillage(data);
          setError(null);
        }
      } catch (cause: unknown) {
        if (!controller.signal.aborted) {
          setVillage(null);
          setError(cause instanceof Error ? cause.message : 'Không tải được thông tin làng.');
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

  return <VillageContext.Provider value={{ village, isLoading, error }}>{children}</VillageContext.Provider>;
}

export function useVillage(): VillageContextValue {
  const context = useContext(VillageContext);
  if (!context) throw new Error('useVillage must be used within a VillageProvider');
  return context;
}
