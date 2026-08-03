import ReactDOM from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import 'maplibre-gl/dist/maplibre-gl.css';
import './index.css';
import { App } from './App';

// No <React.StrictMode> here: its deliberate double-invoke of mount effects
// breaks @photo-sphere-viewer/core — the first Viewer's destroy() cancels an
// in-flight panorama load mid-fetch, and the second Viewer then hangs on
// "Loading..." forever because the aborted load never resolves or rejects.
ReactDOM.createRoot(document.getElementById('root')!).render(
  <BrowserRouter>
    <App />
  </BrowserRouter>,
);
