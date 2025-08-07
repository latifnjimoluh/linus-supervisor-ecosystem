import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  getPermission,
  updatePermission,
  deletePermission,
  assignPermissions,
  unassignPermissions,
} from '../api/permissions';

export default function PermissionDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [form, setForm] = useState({ name: '', description: '' });
  const [roleId, setRoleId] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');

  const load = async () => {
    setError('');
    try {
      const res = await getPermission(id);
      const data = res.data;
      setForm({ name: data.name || '', description: data.description || '' });
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de chargement';
      setError(msg);
    } finally {
      setLoading(false);
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
      await updatePermission(id, form);
      setMessage('Permission mise à jour');
      load();
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de mise à jour';
      setError(msg);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('Supprimer cette permission ?')) return;
    try {
      await deletePermission(id);
      navigate('/permissions');
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de suppression';
      setError(msg);
    }
  };

  const handleAssign = async (action) => {
    if (!roleId) return;
    const payload = [{ role_id: Number(roleId), permission_ids: [Number(id)] }];
    try {
      if (action === 'assign') {
        await assignPermissions(payload);
        setMessage('Permission assignée');
      } else {
        await unassignPermissions(payload);
        setMessage('Permission retirée');
      }
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur lors de la mise à jour du rôle';
      setError(msg);
    }
  };

  if (loading) return <p>Chargement...</p>;

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Permission #{id}</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {message && <p className="text-green-600 mb-2">{message}</p>}
      <form onSubmit={handleUpdate} className="space-y-2 max-w-md">
        <input
          className="w-full border p-2 rounded"
          placeholder="Nom"
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
        />
        <input
          className="w-full border p-2 rounded"
          placeholder="Description"
          value={form.description}
          onChange={(e) => setForm({ ...form, description: e.target.value })}
        />
        <button
          type="submit"
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Mettre à jour
        </button>
      </form>

      <div className="mt-6 space-y-2 max-w-md">
        <input
          className="w-full border p-2 rounded"
          placeholder="ID du rôle"
          value={roleId}
          onChange={(e) => setRoleId(e.target.value)}
        />
        <div className="flex space-x-2">
          <button
            onClick={() => handleAssign('assign')}
            className="px-4 py-2 bg-green-600 text-white rounded"
          >
            Assigner au rôle
          </button>
          <button
            onClick={() => handleAssign('unassign')}
            className="px-4 py-2 bg-yellow-600 text-white rounded"
          >
            Retirer du rôle
          </button>
        </div>
      </div>

      <button
        onClick={handleDelete}
        className="mt-6 px-4 py-2 bg-red-600 text-white rounded"
      >
        Supprimer
      </button>
    </div>
  );
}
