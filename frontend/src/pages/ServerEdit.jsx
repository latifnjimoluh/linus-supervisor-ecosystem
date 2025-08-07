import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from '../lib/router';
import { servers } from '../api';

export default function ServerEdit() {
  const { id } = useParams();
  const [form, setForm] = useState({ ip: '', name: '', zone: '', tags: '', notes: '' });
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    servers.get(id).then((res) => {
      const data = res.data;
      setForm({
        ip: data.ip || '',
        name: data.name || '',
        zone: data.zone || '',
        tags: (data.tags || []).join(', '),
        notes: data.notes || '',
      });
    });
  }, [id]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      await servers.update(id, {
        ip: form.ip,
        name: form.name,
        zone: form.zone,
        tags: form.tags.split(',').map((t) => t.trim()).filter(Boolean),
        notes: form.notes,
      });
      navigate(`/servers/${id}`);
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur lors de la mise à jour';
      setError(msg);
    }
  };

  return (
    <div className="max-w-lg mx-auto">
      <h1 className="text-2xl font-bold mb-4">Modifier le serveur</h1>
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
        <input
          className="border p-2 w-full rounded"
          placeholder="Tags (séparés par des virgules)"
          value={form.tags}
          onChange={(e) => setForm({ ...form, tags: e.target.value })}
        />
        <textarea
          className="border p-2 w-full rounded"
          placeholder="Notes internes"
          value={form.notes}
          onChange={(e) => setForm({ ...form, notes: e.target.value })}
          rows={4}
        />
        <div className="flex justify-end space-x-2">
          <button
            type="button"
            className="px-4 py-2 border rounded"
            onClick={() => navigate(`/servers/${id}`)}
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
