import React, { useEffect, useState } from 'react';
import { listAlerts, updateAlert } from '../api/alerts';

const severityColors = {
  critique: 'bg-red-600',
  majeure: 'bg-yellow-500',
  mineure: 'bg-green-500',
};

export default function Alerts() {
  const [alerts, setAlerts] = useState([]);
  const [severity, setSeverity] = useState('');
  const [error, setError] = useState('');

  const fetchData = async () => {
    try {
      const res = await listAlerts(severity ? { severity } : undefined);
      setAlerts(res.data.data || []);
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur de chargement';
      setError(message);
    }
  };

  useEffect(() => {
    fetchData();
    const id = setInterval(fetchData, 30000);
    return () => clearInterval(id);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [severity]);

  const markResolved = async (id) => {
    try {
      await updateAlert(id, { status: 'resolu' });
      fetchData();
    } catch (err) {
      const message = err.response?.data?.message || "Erreur lors de l'update";
      setError(message);
    }
  };

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Alertes en temps réel</h1>
      <div className="mb-4 space-x-2">
        <select
          value={severity}
          onChange={(e) => setSeverity(e.target.value)}
          className="border p-2 rounded"
        >
          <option value="">Toutes les sévérités</option>
          <option value="critique">Critique</option>
          <option value="majeure">Majeure</option>
          <option value="mineure">Mineure</option>
        </select>
      </div>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      <div className="overflow-x-auto bg-white rounded shadow">
        <table className="min-w-full text-sm">
          <thead className="bg-gray-100">
            <tr>
              <th className="p-2 text-left">Gravité</th>
              <th className="p-2 text-left">Heure</th>
              <th className="p-2 text-left">Serveur</th>
              <th className="p-2 text-left">Service</th>
              <th className="p-2 text-left">Description</th>
              <th className="p-2 text-left">Statut</th>
              <th className="p-2 text-left">Actions</th>
            </tr>
          </thead>
          <tbody>
            {alerts.map((a) => (
              <tr key={a.id} className="border-t hover:bg-gray-50">
                <td className="p-2">
                  <span className={`text-white px-2 py-1 rounded ${severityColors[a.severity] || 'bg-gray-500'}`}>
                    {a.severity}
                  </span>
                </td>
                <td className="p-2">{new Date(a.created_at).toLocaleString()}</td>
                <td className="p-2">{a.server}</td>
                <td className="p-2">{a.service}</td>
                <td className="p-2">{a.description}</td>
                <td className="p-2">{a.status}</td>
                <td className="p-2">
                  {a.status !== 'resolu' && (
                    <button
                      onClick={() => markResolved(a.id)}
                      className="text-blue-600 hover:underline"
                    >
                      Résoudre
                    </button>
                  )}
                </td>
              </tr>
            ))}
            {alerts.length === 0 && (
              <tr>
                <td colSpan="7" className="p-2 text-center text-gray-500">
                  Aucune alerte à afficher
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
