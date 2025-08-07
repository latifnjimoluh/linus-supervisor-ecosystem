import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { createUser } from '../api/users';
import { listRoles } from '../api/roles';

export default function UserAdd() {
  const [roles, setRoles] = useState([]);
  const [form, setForm] = useState({
    first_name: '',
    last_name: '',
    email: '',
    password: '',
    confirm: '',
    role_id: '',
  });
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    listRoles().then((r) => setRoles(r.data || []));
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (form.password !== form.confirm) {
      setError('Les mots de passe ne correspondent pas');
      return;
    }
    try {
      await createUser({
        first_name: form.first_name,
        last_name: form.last_name,
        email: form.email,
        password: form.password,
        role_id: Number(form.role_id),
      });
      navigate('/users');
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur de création';
      setError(message);
    }
  };

  return (
    <div className="max-w-xl mx-auto">
      <h1 className="text-2xl font-bold mb-4">Ajouter un utilisateur</h1>
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
        <input
          type="password"
          className="w-full border p-2 rounded"
          placeholder="Mot de passe"
          value={form.password}
          onChange={(e) => setForm({ ...form, password: e.target.value })}
          required
        />
        <input
          type="password"
          className="w-full border p-2 rounded"
          placeholder="Confirmer le mot de passe"
          value={form.confirm}
          onChange={(e) => setForm({ ...form, confirm: e.target.value })}
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
            Créer le compte
          </button>
        </div>
      </form>
    </div>
  );
}
