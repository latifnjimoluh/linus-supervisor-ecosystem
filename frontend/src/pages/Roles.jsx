import React, { useEffect, useState } from 'react';
import { Link } from '../lib/router';
import { listRoles, createRole, deleteRole } from '../api/roles';

export default function Roles() {
  const [roles, setRoles] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showCreate, setShowCreate] = useState(false);
  const [form, setForm] = useState({ name: '', description: '' });

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await listRoles();
      const data = res.data?.data || res.data || [];
      setRoles(data);
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
  }, []);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Gestion des rôles</h1>
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
              {roles.map((r) => (
                <tr key={r.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{r.name}</td>
                  <td className="p-2">{r.description}</td>
                  <td className="p-2 space-x-2">
                    <Link
                      to={`/roles/${r.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Voir
                    </Link>
                    <button
                      onClick={async () => {
                        if (window.confirm('Supprimer ce rôle ?')) {
                          try {
                            await deleteRole(r.id);
                            fetchData();
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
              {roles.length === 0 && (
                <tr>
                  <td colSpan="3" className="p-2 text-center text-gray-500">
                    Aucun rôle
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
            <h2 className="text-lg font-semibold mb-4">Créer un rôle</h2>
            <form
              onSubmit={async (e) => {
                e.preventDefault();
                try {
                  await createRole(form);
                  setShowCreate(false);
                  setForm({ name: '', description: '' });
                  fetchData();
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
    </div>
  );
}

