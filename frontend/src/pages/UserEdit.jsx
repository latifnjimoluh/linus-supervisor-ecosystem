import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { getUser, updateUser, patchUser } from '../api/users';
import { listRoles } from '../api/roles';

export default function UserEdit() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [roles, setRoles] = useState([]);
  const [form, setForm] = useState({
    first_name: '',
    last_name: '',
    email: '',
    role_id: '',
    status: 'active',
  });
  const [error, setError] = useState('');

  useEffect(() => {
    listRoles().then((r) => setRoles(r.data || []));
    getUser(id)
      .then((r) => {
        const u = r.data;
        setForm({
          first_name: u.first_name || '',
          last_name: u.last_name || '',
          email: u.email || '',
          role_id: u.role_id || '',
          status: u.status || 'active',
        });
      })
      .catch((err) => {
        const message = err.response?.data?.message || 'Erreur de chargement';
        setError(message);
      });
  }, [id]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await updateUser(id, {
        first_name: form.first_name,
        last_name: form.last_name,
        email: form.email,
        role_id: form.role_id,
        status: form.status,
      });
      navigate('/users');
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur de mise à jour';
      setError(message);
    }
  };

  const toggleStatus = async () => {
    try {
      const newStatus = form.status === 'active' ? 'inactif' : 'active';
      await patchUser(id, { status: newStatus });
      setForm({ ...form, status: newStatus });
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur statut';
      setError(message);
    }
  };

  return (
    <div className="max-w-xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Modifier l'utilisateur</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      <form onSubmit={handleSubmit} className="space-y-3">
        <input
          className="w-full border p-2 rounded"
          placeholder="Prénom"
          value={form.first_name}
          onChange={(e) => setForm({ ...form, first_name: e.target.value })}
          required
        />
        <input
          className="w-full border p-2 rounded"
          placeholder="Nom"
          value={form.last_name}
          onChange={(e) => setForm({ ...form, last_name: e.target.value })}
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
        <select
          className="w-full border p-2 rounded"
          value={form.role_id}
          onChange={(e) => setForm({ ...form, role_id: e.target.value })}
          required
        >
          <option value="">Sélectionner un rôle</option>
          {roles.map((r) => (
            <option key={r.id} value={r.id}>
              {r.name}
            </option>
          ))}
        </select>
        <div className="flex items-center space-x-2">
          <span>Statut: {form.status}</span>
          <button
            type="button"
            onClick={toggleStatus}
            className="px-3 py-1 border rounded"
          >
            {form.status === 'active' ? 'Désactiver' : 'Réactiver'}
          </button>
        </div>
        <div className="flex justify-end space-x-2">
          <button
            type="button"
            className="px-4 py-2 border rounded"
            onClick={() => navigate('/users')}
          >
            Annuler
          </button>
          <button
            type="submit"
            className="px-4 py-2 bg-blue-600 text-white rounded"
          >
            Enregistrer
          </button>
        </div>
      </form>
    </div>
  );
}
