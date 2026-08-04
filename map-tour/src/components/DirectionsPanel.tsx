import { useState } from 'react';
import { describeStep, formatDistance, formatDuration } from '../lib/routing';
import type { RouteResult } from '../lib/routing';
import type { TourSite } from '../types';

interface DirectionsPanelProps {
  sites: TourSite[];
  onSubmit: (fromId: string, toId: string) => void;
  isLoading: boolean;
  error: string | null;
  result: RouteResult | null;
}

export function DirectionsPanel({ sites, onSubmit, isLoading, error, result }: DirectionsPanelProps) {
  const [fromId, setFromId] = useState('');
  const [toId, setToId] = useState('');
  const canSubmit = fromId !== '' && toId !== '' && fromId !== toId && !isLoading;

  return (
    <div className="directions-panel">
      <h3 className="directions-panel__title">Chỉ đường</h3>
      <div className="directions-panel__row">
        <select
          className="directions-panel__select"
          aria-label="Điểm đi"
          value={fromId}
          onChange={(event) => setFromId(event.target.value)}
        >
          <option value="">Điểm đi...</option>
          {sites.map((site) => (
            <option key={site.id} value={site.id}>
              {site.name}
            </option>
          ))}
        </select>
        <select
          className="directions-panel__select"
          aria-label="Điểm đến"
          value={toId}
          onChange={(event) => setToId(event.target.value)}
        >
          <option value="">Điểm đến...</option>
          {sites.map((site) => (
            <option key={site.id} value={site.id}>
              {site.name}
            </option>
          ))}
        </select>
      </div>
      <button
        type="button"
        className="directions-panel__submit"
        disabled={!canSubmit}
        onClick={() => onSubmit(fromId, toId)}
      >
        {isLoading ? 'Đang tìm đường...' : 'Chỉ đường'}
      </button>

      {error && (
        <p className="directions-panel__status directions-panel__status--error" role="alert">
          {error}
        </p>
      )}

      {result && (
        <div className="directions-panel__result">
          <p className="directions-panel__summary">
            {formatDistance(result.distanceMeters)} · {formatDuration(result.durationSeconds)} đi bộ
          </p>
          <ol className="directions-panel__steps">
            {result.steps.map((step, index) => (
              <li className="directions-panel__step" key={index}>
                {describeStep(step)}
              </li>
            ))}
          </ol>
        </div>
      )}
    </div>
  );
}
