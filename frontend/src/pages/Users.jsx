import React, { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { listUsers, searchUsers, deleteUser, patchUser } from '../api/users';

export default function Users() {
  const [users, setUsers] = useState([]);
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const navigate = useNavigate();

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
          onClick={() => navigate('/users/add')}
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
                <th className="text-left p-2">Statut</th>
                <th className="text-left p-2">Créé</th>
                <th className="text-left p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.map((u) => (
                <tr key={u.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{u.first_name}</td>
                  <td className="p-2">{u.last_name}</td>
                  <td className="p-2">{u.email}</td>
                  <td className="p-2">{u.role?.name || u.role_id}</td>
                  <td className="p-2">{u.status}</td>
                  <td className="p-2">{new Date(u.created_at).toLocaleDateString()}</td>
                  <td className="p-2 space-x-2">
                    <Link
                      to={`/users/${u.id}/edit`}
                      className="text-blue-600 hover:underline"
                    >
                      Modifier
                    </Link>
                    <button
                      onClick={async () => {
                        try {
                          const newStatus = u.status === 'active' ? 'inactif' : 'active';
                          await patchUser(u.id, { status: newStatus });
                          fetchData();
                        } catch (err) {
                          const message = err.response?.data?.message || 'Erreur de statut';
                          setError(message);
                        }
                      }}
                      className="text-yellow-600 hover:underline"
                    >
                      {u.status === 'active' ? 'Désactiver' : 'Réactiver'}
                    </button>
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
                  <td colSpan="7" className="p-2 text-center text-gray-500">
                    Aucun utilisateur
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}

      {/* Modal de création supprimé au profit d'une page dédiée */}
    </div>
  );
}
