import React, { useEffect, useState } from 'react';
import { listConversions } from '../api/vms';

export default function VmConversions() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    async function fetchData() {
      setLoading(true);
      setError('');
      try {
        const res = await listConversions();
        const data = res.data || {};
        setItems(data.data || data || []);
      } catch (err) {
        const message = err.response?.data?.message || 'Erreur de chargement';
        setError(message);
      } finally {
        setLoading(false);
      }
    }
    fetchData();
  }, []);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Historique des conversions</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {loading ? (
        <p>Chargement...</p>
      ) : (
        <div className="overflow-x-auto bg-white rounded shadow">
          <table className="min-w-full text-sm">
            <thead className="bg-gray-100">
              <tr>
                <th className="text-left p-2">VM ID</th>
                <th className="text-left p-2">Statut</th>
                <th className="text-left p-2">Date</th>
              </tr>
            </thead>
            <tbody>
              {items.map((c) => (
                <tr key={c.id || c.vm_id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{c.vm_id || '—'}</td>
                  <td className="p-2">{c.status || c.state || '—'}</td>
                  <td className="p-2">
                    {c.created_at
                      ? new Date(c.created_at).toLocaleString()
                      : '—'}
                  </td>
                </tr>
              ))}
              {items.length === 0 && (
                <tr>
                  <td colSpan="3" className="p-2 text-center text-gray-500">
                    Aucun enregistrement
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

