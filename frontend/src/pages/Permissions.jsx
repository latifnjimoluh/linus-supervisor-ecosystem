import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  listPermissions,
  createPermission,
  updatePermission,
  deletePermission,
} from '../api/permissions';

export default function Permissions() {
  const [permissions, setPermissions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showCreate, setShowCreate] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form, setForm] = useState({ name: '', description: '' });
  const [pagination, setPagination] = useState({ page: 1, pages: 1 });
  const [page, setPage] = useState(1);

  const fetchData = async (p = 1) => {
    setLoading(true);
    setError('');
    try {
      const res = await listPermissions({ page: p });
      const data = res.data?.data || res.data || [];
      setPermissions(data);
      setPagination(res.data?.pagination || { page: p, pages: 1 });
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur de chargement';
      setError(message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData(page);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page]);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Gestion des permissions</h1>
      <div className="mb-4 text-right">
        <button
          onClick={() => setShowCreate(true)}
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          Ajouter
        </button>
      </div>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {loading ? (
        <p>Chargement...</p>
      ) : (
        <div className="overflow-x-auto bg-white rounded shadow">
          <table className="min-w-full text-sm">
            <thead className="bg-gray-100">
              <tr>
                <th className="text-left p-2">Nom</th>
                <th className="text-left p-2">Description</th>
                <th className="text-left p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {permissions.map((p) => (
                <tr key={p.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{p.name}</td>
                  <td className="p-2">{p.description}</td>
                  <td className="p-2 space-x-2">
                    <Link
                      to={`/permissions/${p.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Voir
                    </Link>
                    <button
                      onClick={() => {
                        setEditing(p);
                        setForm({ name: p.name, description: p.description });
                      }}
                      className="text-yellow-600 hover:underline"
                    >
                      Modifier
                    </button>
                    <button
                      onClick={async () => {
                        if (window.confirm('Supprimer cette permission ?')) {
                          try {
                            await deletePermission(p.id);
                            fetchData(page);
                          } catch (err) {
                            const message =
                              err.response?.data?.message || 'Erreur de suppression';
                            setError(message);
                          }
                        }
                      }}
                      className="text-red-600 hover:underline"
                    >
                      Supprimer
                    </button>
                  </td>
                </tr>
              ))}
              {permissions.length === 0 && (
                <tr>
                  <td colSpan="3" className="p-2 text-center text-gray-500">
                    Aucune permission
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}

      {showCreate && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div className="bg-white p-6 rounded shadow w-full max-w-md">
            <h2 className="text-lg font-semibold mb-4">Créer une permission</h2>
            <form
              onSubmit={async (e) => {
                e.preventDefault();
                try {
                  await createPermission(form);
                  setShowCreate(false);
                  setForm({ name: '', description: '' });
                  fetchData(page);
                } catch (err) {
                  const message =
                    err.response?.data?.message || 'Erreur de création';
                  setError(message);
                }
              }}
              className="space-y-2"
            >
              <input
                className="w-full border p-2 rounded"
                placeholder="Nom"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
              <input
                className="w-full border p-2 rounded"
                placeholder="Description"
                value={form.description}
                onChange={(e) =>
                  setForm({ ...form, description: e.target.value })
                }
                required
              />
              <div className="flex justify-end space-x-2 pt-2">
                <button
                  type="button"
                  onClick={() => setShowCreate(false)}
                  className="px-4 py-2 rounded border"
                >
                  Annuler
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded bg-blue-600 text-white"
                >
                  Enregistrer
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {editing && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div className="bg-white p-6 rounded shadow w-full max-w-md">
            <h2 className="text-lg font-semibold mb-4">Modifier la permission</h2>
            <form
              onSubmit={async (e) => {
                e.preventDefault();
                try {
                  await updatePermission(editing.id, form);
                  setEditing(null);
                  setForm({ name: '', description: '' });
                  fetchData(page);
                } catch (err) {
                  const message =
                    err.response?.data?.message || 'Erreur de mise à jour';
                  setError(message);
                }
              }}
              className="space-y-2"
            >
              <input
                className="w-full border p-2 rounded"
                placeholder="Nom"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
              <input
                className="w-full border p-2 rounded"
                placeholder="Description"
                value={form.description}
                onChange={(e) =>
                  setForm({ ...form, description: e.target.value })
                }
                required
              />
              <div className="flex justify-end space-x-2 pt-2">
                <button
                  type="button"
                  onClick={() => setEditing(null)}
                  className="px-4 py-2 rounded border"
                >
                  Annuler
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded bg-blue-600 text-white"
                >
                  Enregistrer
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {!loading && (
        <div className="flex justify-center mt-4 space-x-2">
          <button
            className="px-3 py-1 border rounded disabled:opacity-50"
            disabled={pagination.page <= 1}
            onClick={() => setPage(pagination.page - 1)}
          >
            Précédent
          </button>
          <span className="px-2 py-1">
            Page {pagination.page} / {pagination.pages}
          </span>
          <button
            className="px-3 py-1 border rounded disabled:opacity-50"
            disabled={pagination.page >= pagination.pages}
            onClick={() => setPage(pagination.page + 1)}
          >
            Suivant
          </button>
        </div>
      )}
    </div>
  );
}
