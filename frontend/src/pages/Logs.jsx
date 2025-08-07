import React, { useEffect, useState } from 'react';
import { getLogs } from '../api/logs';

export default function Logs() {
  const [logs, setLogs] = useState([]);
  const [query, setQuery] = useState('');
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState({ pages: 1 });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await getLogs({ page, q: query });
      const data = res.data || {};
      setLogs(data.data || []);
      setPagination(data.pagination || { page: 1, pages: 1 });
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur de chargement';
      setError(message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, query]);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Logs système</h1>
      <div className="mb-4 flex justify-between items-center">
        <input
          type="text"
          placeholder="Rechercher..."
          value={query}
          onChange={(e) => {
            setPage(1);
            setQuery(e.target.value);
          }}
          className="border p-2 rounded w-64"
        />
      </div>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {loading ? (
        <p>Chargement...</p>
      ) : (
        <div className="overflow-x-auto bg-white rounded shadow">
          <table className="min-w-full text-sm">
            <thead className="bg-gray-100">
              <tr>
                <th className="text-left p-2">Date</th>
                <th className="text-left p-2">Utilisateur</th>
                <th className="text-left p-2">Action</th>
                <th className="text-left p-2">Détails</th>
              </tr>
            </thead>
            <tbody>
              {logs.map((log) => (
                <tr key={log.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">
                    {new Date(log.created_at).toLocaleString()}
                  </td>
                  <td className="p-2">
                    {log.user
                      ? `${log.user.first_name || ''} ${
                          log.user.last_name || ''
                        }`
                      : '—'}
                  </td>
                  <td className="p-2">{log.action}</td>
                  <td className="p-2">{log.details}</td>
                </tr>
              ))}
              {logs.length === 0 && (
                <tr>
                  <td
                    colSpan="4"
                    className="p-2 text-center text-gray-500"
                  >
                    Aucun log
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}
      <div className="flex justify-between items-center mt-4">
        <button
          onClick={() => setPage((p) => Math.max(1, p - 1))}
          disabled={page <= 1}
          className="px-3 py-1 rounded border disabled:opacity-50"
        >
          Précédent
        </button>
        <span>
          Page {page} / {pagination.pages || 1}
        </span>
        <button
          onClick={() =>
            setPage((p) =>
              p < (pagination.pages || 1) ? p + 1 : p
            )
          }
          disabled={page >= (pagination.pages || 1)}
          className="px-3 py-1 rounded border disabled:opacity-50"
        >
          Suivant
        </button>
      </div>
    </div>
  );
}

