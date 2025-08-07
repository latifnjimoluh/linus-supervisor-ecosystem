import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  listUsers,
  searchUsers,
  createUser,
  deleteUser,
} from '../api/users';

export default function Users() {
  const [users, setUsers] = useState([]);
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showCreate, setShowCreate] = useState(false);
  const [form, setForm] = useState({
    first_name: '',
    last_name: '',
    email: '',
    password: '',
    role_id: '',
  });

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const res = query ? await searchUsers(query) : await listUsers();
      const data = res.data?.data || res.data || [];
      setUsers(data);
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
  }, [query]);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Gestion des utilisateurs</h1>
      <div className="mb-4 flex justify-between items-center">
        <input
          type="text"
          placeholder="Rechercher..."
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          className="border p-2 rounded w-64"
        />
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
                <th className="text-left p-2">Prénom</th>
                <th className="text-left p-2">Nom</th>
                <th className="text-left p-2">Email</th>
                <th className="text-left p-2">Rôle</th>
                <th className="text-left p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.map((u) => (
                <tr key={u.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{u.first_name}</td>
                  <td className="p-2">{u.last_name}</td>
                  <td className="p-2">{u.email}</td>
                  <td className="p-2">{u.role_id}</td>
                  <td className="p-2 space-x-2">
                    <Link
                      to={`/users/${u.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Voir
                    </Link>
                    <button
                      onClick={async () => {
                        if (window.confirm('Supprimer cet utilisateur ?')) {
                          try {
                            await deleteUser(u.id);
                            fetchData();
                          } catch (err) {
                            const message =
                              err.response?.data?.message ||
                              'Erreur de suppression';
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
              {users.length === 0 && (
                <tr>
                  <td colSpan="5" className="p-2 text-center text-gray-500">
                    Aucun utilisateur
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
            <h2 className="text-lg font-semibold mb-4">Créer un utilisateur</h2>
            <form
              onSubmit={async (e) => {
                e.preventDefault();
                try {
                  await createUser({
                    ...form,
                    role_id: Number(form.role_id) || undefined,
                  });
                  setShowCreate(false);
                  setForm({
                    first_name: '',
                    last_name: '',
                    email: '',
                    password: '',
                    role_id: '',
                  });
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
                placeholder="Prénom"
                value={form.first_name}
                onChange={(e) =>
                  setForm({ ...form, first_name: e.target.value })
                }
                required
              />
              <input
                className="w-full border p-2 rounded"
                placeholder="Nom"
                value={form.last_name}
                onChange={(e) =>
                  setForm({ ...form, last_name: e.target.value })
                }
                required
              />
              <input
                type="email"
                className="w-full border p-2 rounded"
                placeholder="Email"
                value={form.email}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
                required
              />
              <input
                type="password"
                className="w-full border p-2 rounded"
                placeholder="Mot de passe"
                value={form.password}
                onChange={(e) =>
                  setForm({ ...form, password: e.target.value })
                }
                required
              />
              <input
                type="number"
                className="w-full border p-2 rounded"
                placeholder="ID du rôle"
                value={form.role_id}
                onChange={(e) =>
                  setForm({ ...form, role_id: e.target.value })
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
