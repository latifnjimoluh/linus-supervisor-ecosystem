import React, { useEffect, useState } from 'react';
import { overview } from '../api/monitoring';
import { useNavigate } from '../lib/router';

export default function Monitoring() {
  const [summary, setSummary] = useState({});
  const [servers, setServers] = useState([]);
  const [zoneFilter, setZoneFilter] = useState('');
  const [statusFilter, setStatusFilter] = useState('');
  const [error, setError] = useState('');

  const navigate = useNavigate();

  useEffect(() => {
    const load = async () => {
      setError('');
      try {
        const res = await overview();
        setSummary(res.data.summary || {});
        setServers(res.data.servers || []);
      } catch (err) {
        const msg = err.response?.data?.message || 'Erreur de chargement';
        setError(msg);
      }
    };
    load();
  }, []);

  const zones = Array.from(new Set(servers.map((s) => s.zone).filter(Boolean)));

  const filtered = servers.filter(
    (s) => (!zoneFilter || s.zone === zoneFilter) && (!statusFilter || s.status === statusFilter)
  );

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Supervision</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}

      <div className="grid md:grid-cols-4 gap-4 mb-6">
        <div className="bg-white p-4 rounded shadow">
          <p className="text-sm text-gray-600">Total serveurs</p>
          <p className="text-2xl font-semibold">{summary.total || 0}</p>
        </div>
        <div className="bg-white p-4 rounded shadow">
          <p className="text-sm text-gray-600">Actifs</p>
          <p className="text-2xl font-semibold text-green-600">{summary.active || 0}</p>
        </div>
        <div className="bg-white p-4 rounded shadow">
          <p className="text-sm text-gray-600">En alerte</p>
          <p className="text-2xl font-semibold text-red-600">{summary.alert || 0}</p>
        </div>
        <div className="bg-white p-4 rounded shadow">
          <p className="text-sm text-gray-600">Non supervisés</p>
          <p className="text-2xl font-semibold text-yellow-600">{summary.unsupervised || 0}</p>
        </div>
      </div>

      <div className="flex gap-4 mb-4">
        <select
          value={zoneFilter}
          onChange={(e) => setZoneFilter(e.target.value)}
          className="border p-2 rounded"
        >
          <option value="">Toutes zones</option>
          {zones.map((z) => (
            <option key={z} value={z}>
              {z}
            </option>
          ))}
        </select>
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="border p-2 rounded"
        >
          <option value="">Tous statuts</option>
          <option value="active">Actif</option>
          <option value="alert">Alerte</option>
          <option value="unknown">Inactif</option>
        </select>
      </div>

      <div className="overflow-x-auto bg-white rounded shadow">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-100">
            <tr>
              <th className="p-2 text-left">Nom</th>
              <th className="p-2 text-left">IP</th>
              <th className="p-2 text-left">Zone</th>
              <th className="p-2 text-left">Services</th>
              <th className="p-2 text-left">Statut</th>
              <th className="p-2 text-left">Charge</th>
              <th className="p-2 text-left">Mémoire (Mo)</th>
              <th className="p-2" />
            </tr>
          </thead>
          <tbody>
            {filtered.map((srv) => {
              const mem = srv.system?.memory;
              const memUsed =
                mem && mem.total_kb != null && mem.available_kb != null
                  ? ((mem.total_kb - mem.available_kb) / 1024).toFixed(1) +
                    ' / ' +
                    (mem.total_kb / 1024).toFixed(1)
                  : '';
              return (
                <tr key={srv.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{srv.name || srv.ip}</td>
                  <td className="p-2">{srv.ip}</td>
                  <td className="p-2">{srv.zone || '-'}</td>
                  <td className="p-2">{srv.services.join(', ')}</td>
                  <td className="p-2 capitalize">{srv.status}</td>
                  <td className="p-2">{srv.system?.load_average}</td>
                  <td className="p-2">{memUsed}</td>
                  <td className="p-2 text-right">
                    <button
                      onClick={() => navigate(`/monitoring/${srv.id}`)}
                      className="text-blue-600 underline"
                    >
                      Détails
                    </button>
                  </td>
                </tr>
              );
            })}
            {filtered.length === 0 && (
              <tr>
                <td colSpan="8" className="p-2 text-center text-gray-500">
                  Aucun serveur
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
