import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  listVms,
  startVm,
  stopVm,
  deleteVm,
  checkStatus,
  convertVm,
} from '../api/vms';

export default function Vms() {
  const [vms, setVms] = useState([]);
  const [page, setPage] = useState(1);
  const [pagination, setPagination] = useState({ pages: 1 });
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await listVms({ page, q: query });
      const data = res.data || {};
      setVms(data.data || []);
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

  const handleAction = async (fn) => {
    try {
      await fn();
      fetchData();
    } catch (err) {
      const message = err.response?.data?.message || 'Action impossible';
      setError(message);
    }
  };

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Gestion des VMs</h1>
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
        <Link
          to="/vms/conversions"
          className="text-blue-600 hover:underline"
        >
          Historique des conversions
        </Link>
      </div>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {loading ? (
        <p>Chargement...</p>
      ) : (
        <div className="overflow-x-auto bg-white rounded shadow">
          <table className="min-w-full text-sm">
            <thead className="bg-gray-100">
              <tr>
                <th className="text-left p-2">ID</th>
                <th className="text-left p-2">Nom</th>
                <th className="text-left p-2">Statut</th>
                <th className="text-left p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {vms.map((vm) => (
                <tr key={vm.id || vm.vm_id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{vm.id || vm.vm_id}</td>
                  <td className="p-2">{vm.name || vm.vm_name}</td>
                  <td className="p-2">{vm.status || vm.state}</td>
                  <td className="p-2 space-x-2">
                    <button
                      onClick={() => handleAction(() => startVm(vm.id || vm.vm_id))}
                      className="text-green-600 hover:underline"
                    >
                      Démarrer
                    </button>
                    <button
                      onClick={() => handleAction(() => stopVm(vm.id || vm.vm_id))}
                      className="text-yellow-600 hover:underline"
                    >
                      Arrêter
                    </button>
                    <button
                      onClick={() => {
                        const instance = window.prompt('Instance ID?');
                        if (instance) {
                          handleAction(() =>
                            deleteVm({ vm_id: vm.id || vm.vm_id, instance_id: instance })
                          );
                        }
                      }}
                      className="text-red-600 hover:underline"
                    >
                      Supprimer
                    </button>
                    <button
                      onClick={() => {
                        const ip = window.prompt('Adresse IP ?');
                        if (ip) {
                          handleAction(() =>
                            checkStatus({ vm_id: vm.id || vm.vm_id, ip_address: ip })
                          );
                        }
                      }}
                      className="text-blue-600 hover:underline"
                    >
                      Vérifier
                    </button>
                    <button
                      onClick={() =>
                        handleAction(() => convertVm({ vm_id: vm.id || vm.vm_id }))
                      }
                      className="text-purple-600 hover:underline"
                    >
                      Convertir
                    </button>
                  </td>
                </tr>
              ))}
              {vms.length === 0 && (
                <tr>
                  <td colSpan="4" className="p-2 text-center text-gray-500">
                    Aucune VM
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
            setPage((p) => (p < (pagination.pages || 1) ? p + 1 : p))
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

