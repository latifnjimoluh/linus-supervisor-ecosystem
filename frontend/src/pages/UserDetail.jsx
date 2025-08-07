import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getUser, updateUser, patchUser, deleteUser } from '../api/users';

export default function UserDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [form, setForm] = useState({
    first_name: '',
    last_name: '',
    email: '',
    role_id: '',
  });
  const [patchLast, setPatchLast] = useState('');
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');

  const load = async () => {
    setError('');
    try {
      const res = await getUser(id);
      const data = res.data;
      setUser(data);
      setForm({
        first_name: data.first_name || '',
        last_name: data.last_name || '',
        email: data.email || '',
        role_id: data.role_id || '',
      });
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de chargement';
      setError(msg);
    }
  };

  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  const handleUpdate = async (e) => {
    e.preventDefault();
    setError('');
    setMessage('');
    try {
      await updateUser(id, { ...form, role_id: Number(form.role_id) });
      setMessage('Utilisateur mis à jour');
      load();
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de mise à jour';
      setError(msg);
    }
  };

  const handlePatch = async (e) => {
    e.preventDefault();
    setError('');
    setMessage('');
    try {
      await patchUser(id, { last_name: patchLast });
      setMessage('Nom mis à jour');
      setPatchLast('');
      load();
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de mise à jour';
      setError(msg);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('Supprimer cet utilisateur ?')) return;
    try {
      await deleteUser(id);
      navigate('/users');
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de suppression';
      setError(msg);
    }
  };

  if (!user && !error) {
    return <p>Chargement...</p>;
  }

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Utilisateur #{id}</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {message && <p className="text-green-600 mb-2">{message}</p>}
      {user && (
        <div className="space-y-6">
          <form onSubmit={handleUpdate} className="space-y-2 max-w-md">
            <input
              className="w-full border p-2 rounded"
              placeholder="Prénom"
              value={form.first_name}
              onChange={(e) => setForm({ ...form, first_name: e.target.value })}
            />
            <input
              className="w-full border p-2 rounded"
              placeholder="Nom"
              value={form.last_name}
              onChange={(e) => setForm({ ...form, last_name: e.target.value })}
            />
            <input
              type="email"
              className="w-full border p-2 rounded"
              placeholder="Email"
              value={form.email}
              onChange={(e) => setForm({ ...form, email: e.target.value })}
            />
            <input
              type="number"
              className="w-full border p-2 rounded"
              placeholder="ID du rôle"
              value={form.role_id}
              onChange={(e) => setForm({ ...form, role_id: e.target.value })}
            />
            <button
              type="submit"
              className="px-4 py-2 bg-blue-600 text-white rounded"
            >
              Mettre à jour
            </button>
          </form>

          <form onSubmit={handlePatch} className="space-y-2 max-w-md">
            <input
              className="w-full border p-2 rounded"
              placeholder="Nouveau nom"
              value={patchLast}
              onChange={(e) => setPatchLast(e.target.value)}
            />
            <button
              type="submit"
              className="px-4 py-2 bg-yellow-600 text-white rounded"
            >
              Patch nom
            </button>
          </form>

          <button
            onClick={handleDelete}
            className="px-4 py-2 bg-red-600 text-white rounded"
          >
            Supprimer
          </button>
        </div>
      )}
    </div>
  );
}

