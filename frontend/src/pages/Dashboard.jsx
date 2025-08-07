import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { getDashboardSummary, listServers } from '../api/dashboard';

export default function Dashboard() {
  const [summary, setSummary] = useState({
    totalServers: 0,
    totalServices: 0,
    serversInAlert: 0,
    supervisedPercentage: 0,
  });
  const [servers, setServers] = useState([]);

  useEffect(() => {
    async function fetchData() {
      try {
        const [s, srv] = await Promise.all([
          getDashboardSummary(),
          listServers(),
        ]);
        setSummary(s.data);
        setServers(srv.data);
      } catch (err) {
        // eslint-disable-next-line no-console
        console.error(err);
      }
    }
    fetchData();
  }, []);

  const alertServers = servers.filter((s) => s.status === 'alert');

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Tableau de bord</h1>

      <div className="grid gap-4 mb-8 sm:grid-cols-2 lg:grid-cols-4">
        <div className="p-4 bg-white rounded shadow">
          <p className="text-sm text-gray-500">Serveurs</p>
          <p className="text-2xl font-semibold">{summary.totalServers}</p>
        </div>
        <div className="p-4 bg-white rounded shadow">
          <p className="text-sm text-gray-500">Services déployés</p>
          <p className="text-2xl font-semibold">{summary.totalServices}</p>
        </div>
        <div className="p-4 bg-white rounded shadow">
          <p className="text-sm text-gray-500">Serveurs en alerte</p>
          <p className="text-2xl font-semibold">{summary.serversInAlert}</p>
        </div>
        <div className="p-4 bg-white rounded shadow">
          <p className="text-sm text-gray-500">Supervision active</p>
          <p className="text-2xl font-semibold">{summary.supervisedPercentage}%</p>
        </div>
      </div>

      <div className="mb-8">
        <h2 className="text-xl font-semibold mb-4">Serveurs</h2>
        {servers.length === 0 ? (
          <div className="p-6 bg-white rounded shadow text-center">
            <p className="mb-4">Aucun serveur enregistré</p>
            <Link className="text-blue-600" to="/terraform">Créer un premier serveur</Link>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full bg-white rounded shadow">
              <thead>
                <tr className="text-left">
                  <th className="p-2">Nom</th>
                  <th className="p-2">IP</th>
                  <th className="p-2">Zone</th>
                  <th className="p-2">Services</th>
                  <th className="p-2">Supervision</th>
                  <th className="p-2">Statut</th>
                  <th className="p-2">Actions</th>
                </tr>
              </thead>
              <tbody>
                {servers.map((s) => (
                  <tr key={s.id} className="border-t">
                    <td className="p-2 text-blue-600 underline">
                      <Link to={`/monitoring?vm_ip=${s.ip}`}>{s.name}</Link>
                    </td>
                    <td className="p-2">{s.ip}</td>
                    <td className="p-2">{s.zone || '-'}</td>
                    <td className="p-2">{s.services.join(', ')}</td>
                    <td className="p-2">{s.supervised ? '🟢 oui' : '🔴 non'}</td>
                    <td className="p-2">
                      {s.status === 'active' && <span className="text-green-600">🟢 Actif</span>}
                      {s.status === 'alert' && <span className="text-red-600">🔴 Alerte</span>}
                      {s.status === 'unknown' && <span className="text-gray-600">🟡 Inconnu</span>}
                    </td>
                    <td className="p-2 space-x-2">
                      <Link to={`/monitoring?vm_ip=${s.ip}`} title="Voir">🔍</Link>
                      <Link to={`/configure/${s.id}`} title="Configurer">⚙️</Link>
                      <Link to={`/deploy/${s.id}`} title="Déployer">🚀</Link>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {alertServers.length > 0 && (
        <div className="mb-8">
          <h2 className="text-xl font-semibold mb-4">Alertes récentes</h2>
          <ul className="bg-white rounded shadow">
            {alertServers.map((s) => (
              <li key={s.id} className="p-2 border-t first:border-t-0">
                <Link to={`/monitoring?vm_ip=${s.ip}`} className="text-red-600">
                  {s.name} - {s.ip}
                </Link>
              </li>
            ))}
          </ul>
        </div>
      )}

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <Link to="/vms" className="p-4 bg-white rounded shadow text-center">
          ➕ Ajouter un serveur
        </Link>
        <Link to="/templates" className="p-4 bg-white rounded shadow text-center">
          ⚙️ Configurer un service
        </Link>
        <Link to="/terraform" className="p-4 bg-white rounded shadow text-center">
          🚀 Lancer un déploiement
        </Link>
        <Link to="/monitoring" className="p-4 bg-white rounded shadow text-center">
          📊 Voir supervision globale
        </Link>
        <Link to="/dashboard/map" className="p-4 bg-white rounded shadow text-center">
          🌐 Vue carte
        </Link>
      </div>
    </div>
  );
}
