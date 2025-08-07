import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { servers } from '../api';

export default function ServerAdd() {
  const [form, setForm] = useState({ ip: '', name: '', zone: '' });
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      await servers.create(form);
      navigate('/servers');
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur lors de l\'ajout';
      setError(msg);
    }
  };

  return (
    <div className="max-w-lg mx-auto">
      <h1 className="text-2xl font-bold mb-4">Ajouter un serveur</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      <form onSubmit={handleSubmit} className="space-y-3">
        <input
          className="border p-2 w-full rounded"
          placeholder="Adresse IP"
          value={form.ip}
          onChange={(e) => setForm({ ...form, ip: e.target.value })}
          required
        />
        <input
          className="border p-2 w-full rounded"
          placeholder="Nom du serveur"
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
        />
        <input
          className="border p-2 w-full rounded"
          placeholder="Zone réseau"
          value={form.zone}
          onChange={(e) => setForm({ ...form, zone: e.target.value })}
        />
        <div className="flex justify-end space-x-2">
          <button
            type="button"
            className="px-4 py-2 border rounded"
            onClick={() => navigate('/servers')}
          >
            Annuler
          </button>
          <button
            type="submit"
            className="px-4 py-2 bg-blue-600 text-white rounded"
          >
            Ajouter le serveur
          </button>
        </div>
      </form>
    </div>
  );
}
