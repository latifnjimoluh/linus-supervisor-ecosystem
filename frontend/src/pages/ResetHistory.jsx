import React, { useEffect, useState } from 'react';
import { resetHistory } from '../api/auth';

export default function ResetHistory() {
  const [history, setHistory] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    const load = async () => {
      try {
        const { data } = await resetHistory();
        setHistory(data);
      } catch (err) {
        const msg = err.response?.data?.message || 'Erreur de chargement';
        setError(msg);
      }
    };
    load();
  }, []);

  if (error) {
    return <p className="text-red-500">{error}</p>;
  }

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Historique des réinitialisations</h1>
      {history.length === 0 ? (
        <p>Aucun enregistrement.</p>
      ) : (
        <div className="overflow-x-auto">
          <table className="min-w-full bg-white shadow rounded">
            <thead>
              <tr>
                <th className="px-4 py-2 border">Email</th>
                <th className="px-4 py-2 border">Date</th>
              </tr>
            </thead>
            <tbody>
              {history.map((item, idx) => (
                <tr key={idx} className="odd:bg-gray-50">
                  <td className="px-4 py-2 border">
                    {item.email || item.user?.email || ''}
                  </td>
                  <td className="px-4 py-2 border">
                    {new Date(
                      item.updated_at || item.created_at || item.date || Date.now()
                    ).toLocaleString()}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
