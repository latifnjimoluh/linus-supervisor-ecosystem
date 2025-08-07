import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { register } from '../api/auth';

export default function Register() {
  const navigate = useNavigate();
  const [form, setForm] = useState({
    first_name: '',
    last_name: '',
    email: '',
    password: '',
    role_id: 1,
  });
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      await register(form);
      setSuccess('Utilisateur créé, vous pouvez vous connecter.');
      setTimeout(() => navigate('/login'), 1500);
    } catch (err) {
      const message = err.response?.data?.message || 'Inscription échouée';
      setError(message);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-r from-purple-500 to-indigo-600 p-4">
      <form
        onSubmit={handleSubmit}
        className="bg-white/90 backdrop-blur p-6 rounded shadow-md w-full max-w-md space-y-4"
      >
        <h1 className="text-2xl font-bold text-center text-indigo-700">
          Inscription administrateur
        </h1>
        {error && <p className="text-red-500 text-sm">{error}</p>}
        {success && <p className="text-green-600 text-sm">{success}</p>}
        <div className="flex gap-4">
          <input
            name="first_name"
            type="text"
            placeholder="Prénom"
            value={form.first_name}
            onChange={handleChange}
            className="w-full border p-2 rounded"
            required
          />
          <input
            name="last_name"
            type="text"
            placeholder="Nom"
            value={form.last_name}
            onChange={handleChange}
            className="w-full border p-2 rounded"
            required
          />
        </div>
        <input
          name="email"
          type="email"
          placeholder="Email"
          value={form.email}
          onChange={handleChange}
          className="w-full border p-2 rounded"
          required
        />
        <input
          name="password"
          type="password"
          placeholder="Mot de passe"
          value={form.password}
          onChange={handleChange}
          className="w-full border p-2 rounded"
          required
        />
        <select
          name="role_id"
          value={form.role_id}
          onChange={handleChange}
          className="w-full border p-2 rounded"
        >
          <option value={1}>Super Admin</option>
          <option value={2}>Admin</option>
        </select>
        <button
          type="submit"
          className="w-full bg-indigo-600 text-white p-2 rounded hover:bg-indigo-700"
        >
          Créer le compte
        </button>
        <p className="text-sm text-center">
          Déjà inscrit?{' '}
          <button
            type="button"
            onClick={() => navigate('/login')}
            className="text-indigo-600 underline"
          >
            Se connecter
          </button>
        </p>
      </form>
    </div>
  );
}
