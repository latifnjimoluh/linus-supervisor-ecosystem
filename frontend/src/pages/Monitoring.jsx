import React, { useEffect, useState } from 'react';
import {
  listMonitoring,
  collectData,
  syncDeploymentIp,
} from '../api/monitoring';
import { useNavigate } from 'react-router-dom';

export default function Monitoring() {
  const [records, setRecords] = useState([]);
  const [vmIp, setVmIp] = useState('');
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState({ pages: 1 });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');

  const [collectForm, setCollectForm] = useState({ vm_ip: '', username: '' });
  const [syncForm, setSyncForm] = useState({ instance_id: '', vm_ip: '' });

  const navigate = useNavigate();

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await listMonitoring({ page, vm_ip: vmIp });
      const data = res.data || {};
      setRecords(data.data || []);
      setPagination(data.pagination || { page: 1, pages: 1 });
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de chargement';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, vmIp]);

  const handleCollect = async (e) => {
    e.preventDefault();
    setError('');
    setMessage('');
    try {
      await collectData(collectForm);
      setMessage('Collecte effectuée');
      setCollectForm({ vm_ip: '', username: '' });
      fetchData();
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de collecte';
      setError(msg);
    }
  };

  const handleSync = async (e) => {
    e.preventDefault();
    setError('');
    setMessage('');
    try {
      await syncDeploymentIp(syncForm);
      setMessage('Synchronisation effectuée');
      setSyncForm({ instance_id: '', vm_ip: '' });
      fetchData();
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de synchronisation';
      setError(msg);
    }
  };

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Monitoring</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {message && <p className="text-green-600 mb-2">{message}</p>}

      <div className="grid md:grid-cols-2 gap-4 mb-6">
        <form
          onSubmit={handleCollect}
          className="bg-white p-4 rounded shadow space-y-2"
        >
          <h2 className="font-semibold">Collecte de données</h2>
          <input
            className="border p-2 rounded w-full"
            placeholder="VM IP"
            value={collectForm.vm_ip}
            onChange={(e) =>
              setCollectForm({ ...collectForm, vm_ip: e.target.value })
            }
          />
          <input
            className="border p-2 rounded w-full"
            placeholder="Utilisateur SSH"
            value={collectForm.username}
            onChange={(e) =>
              setCollectForm({ ...collectForm, username: e.target.value })
            }
          />
          <button
            type="submit"
            className="bg-blue-600 text-white px-3 py-1 rounded"
          >
            Collecter
          </button>
        </form>

        <form
          onSubmit={handleSync}
          className="bg-white p-4 rounded shadow space-y-2"
        >
          <h2 className="font-semibold">Synchroniser IP</h2>
          <input
            className="border p-2 rounded w-full"
            placeholder="ID Instance"
            value={syncForm.instance_id}
            onChange={(e) =>
              setSyncForm({ ...syncForm, instance_id: e.target.value })
            }
          />
          <input
            className="border p-2 rounded w-full"
            placeholder="VM IP"
            value={syncForm.vm_ip}
            onChange={(e) => setSyncForm({ ...syncForm, vm_ip: e.target.value })}
          />
          <button
            type="submit"
            className="bg-blue-600 text-white px-3 py-1 rounded"
          >
            Synchroniser
          </button>
        </form>
      </div>

      <div className="mb-4 flex justify-between items-center">
        <input
          type="text"
          placeholder="Filtrer par IP VM..."
          value={vmIp}
          onChange={(e) => {
            setPage(1);
            setVmIp(e.target.value);
          }}
          className="border p-2 rounded w-64"
        />
      </div>

      {loading ? (
        <p>Chargement...</p>
      ) : (
        <div className="overflow-x-auto bg-white rounded shadow">
          <table className="min-w-full text-sm">
            <thead className="bg-gray-100">
              <tr>
                <th className="p-2 text-left">ID</th>
                <th className="p-2 text-left">VM IP</th>
                <th className="p-2 text-left">Charge</th>
                <th className="p-2 text-left">Mémoire (Mo)</th>
                <th className="p-2 text-left">Date</th>
                <th className="p-2" />
              </tr>
            </thead>
            <tbody>
              {records.map((rec) => (
                <tr key={rec.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{rec.id}</td>
                  <td className="p-2">{rec.vm_ip || rec.vmIp}</td>
                  <td className="p-2">{rec.system_status?.load_average}</td>
                  <td className="p-2">
                    {rec.system_status?.memory
                      ? (
                          (
                            (rec.system_status.memory.total_kb -
                              rec.system_status.memory.available_kb) /
                            1024
                          ).toFixed(1) +
                          ' / ' +
                          (rec.system_status.memory.total_kb / 1024).toFixed(1)
                        )
                      : ''}
                  </td>
                  <td className="p-2">
                    {rec.retrieved_at
                      ? new Date(rec.retrieved_at).toLocaleString()
                      : ''}
                  </td>
                  <td className="p-2">
                    <button
                      onClick={() => navigate(`/monitoring/${rec.id}`)}
                      className="text-blue-600 underline"
                    >
                      Voir
                    </button>
                  </td>
                </tr>
              ))}
              {records.length === 0 && (
                <tr>
                  <td
                    colSpan="6"
                    className="p-2 text-center text-gray-500"
                  >
                    Aucun enregistrement
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

