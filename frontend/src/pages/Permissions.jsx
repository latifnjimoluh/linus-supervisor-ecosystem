import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import {
  listPermissions,
  createPermission,
  updatePermission,
  deletePermission,
} from '../api/permissions';
import ConfirmModal from '../components/ConfirmModal';
import { useToast } from '../components/ToastProvider';

export default function Permissions() {
  const [permissions, setPermissions] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showCreate, setShowCreate] = useState(false);
  const [editing, setEditing] = useState(null);
  const [confirmDelete, setConfirmDelete] = useState(null);
  const [confirmLoading, setConfirmLoading] = useState(false);
  const { addToast } = useToast();
  const [form, setForm] = useState({ name: '', description: '' });
  const [pagination, setPagination] = useState({ page: 1, pages: 1 });
  const [page, setPage] = useState(1);

  const fetchData = async (p = 1) => {
    setLoading(true);
    setError('');
    try {
      const res = await listPermissions({ page: p });
      const data = res.data?.data || res.data || [];
      setPermissions(data);
      setPagination(res.data?.pagination || { page: p, pages: 1 });
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur de chargement';
      setError(message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData(page);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page]);

  return (
    <div>
      <h1 className="text-2xl font-semibold mb-4 text-slate-900 dark:text-slate-100">Gestion des permissions</h1>
      <div className="mb-4 text-right">
        <button
          onClick={() => setShowCreate(true)}
          className="px-4 py-2 rounded-xl bg-blue-600 text-white hover:bg-blue-700 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 dark:bg-blue-500 dark:hover:bg-blue-400"
        >
          Ajouter
        </button>
      </div>
      {error && <p className="text-red-500 dark:text-red-400 mb-2">{error}</p>}
      {loading ? (
        <p>Chargement...</p>
      ) : (
        <div className="overflow-x-auto bg-white dark:bg-slate-800 rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <table className="min-w-full text-sm text-slate-900 dark:text-slate-100">
            <thead className="bg-gray-100 dark:bg-slate-700/50">
              <tr>
                <th className="text-left p-2">Nom</th>
                <th className="text-left p-2">Description</th>
                <th className="text-left p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {permissions.map((p) => (
                <tr
                  key={p.id}
                  className="border-t border-gray-200 dark:border-slate-700 hover:bg-gray-50 dark:hover:bg-slate-700/30"
                >
                  <td className="p-2">{p.name}</td>
                  <td className="p-2">{p.description}</td>
                  <td className="p-2 space-x-2">
                    <Link
                      to={`/permissions/${p.id}`}
                      className="text-blue-600 dark:text-blue-400 hover:underline"
                    >
                      Voir
                    </Link>
                    <button
                      onClick={() => {
                        setEditing(p);
                        setForm({ name: p.name, description: p.description });
                      }}
                      className="text-yellow-600 dark:text-yellow-400 hover:underline"
                    >
                      Modifier
                    </button>
                    <button
                      onClick={() => setConfirmDelete(p)}
                      className="text-red-600 dark:text-red-400 hover:underline"
                    >
                      Supprimer
                    </button>
                  </td>
                </tr>
              ))}
              {permissions.length === 0 && (
                <tr>
                  <td colSpan="3" className="p-2 text-center text-gray-500 dark:text-slate-400">
                    Aucune permission
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}

      {showCreate && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center">
          <div className="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40 w-full max-w-md">
            <h2 className="text-lg font-semibold mb-4 text-slate-900 dark:text-slate-100">Créer une permission</h2>
            <form
              onSubmit={async (e) => {
                e.preventDefault();
                try {
                  await createPermission(form);
                  addToast('success', 'Permission créée');
                  setShowCreate(false);
                  setForm({ name: '', description: '' });
                  fetchData(page);
                } catch (err) {
                  const message =
                    err.response?.data?.message || 'Erreur de création';
                  setError(message);
                  addToast('error', message);
                }
              }}
              className="space-y-2"
            >
              <input
                className="w-full border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 p-2 rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                placeholder="Nom"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
              <input
                className="w-full border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 p-2 rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
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
                  className="px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                >
                  Annuler
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-xl bg-blue-600 text-white hover:bg-blue-700 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 dark:bg-blue-500 dark:hover:bg-blue-400"
                >
                  Enregistrer
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {editing && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center">
          <div className="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40 w-full max-w-md">
            <h2 className="text-lg font-semibold mb-4 text-slate-900 dark:text-slate-100">Modifier la permission</h2>
            <form
              onSubmit={async (e) => {
                e.preventDefault();
                try {
                  await updatePermission(editing.id, form);
                  addToast('success', 'Permission mise à jour');
                  setEditing(null);
                  setForm({ name: '', description: '' });
                  fetchData(page);
                } catch (err) {
                  const message =
                    err.response?.data?.message || 'Erreur de mise à jour';
                  setError(message);
                  addToast('error', message);
                }
              }}
              className="space-y-2"
            >
              <input
                className="w-full border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 p-2 rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                placeholder="Nom"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
              <input
                className="w-full border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 p-2 rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
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
                  onClick={() => setEditing(null)}
                  className="px-4 py-2 rounded-xl border border-slate-300 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-700/30 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
                >
                  Annuler
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 rounded-xl bg-blue-600 text-white hover:bg-blue-700 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 dark:bg-blue-500 dark:hover:bg-blue-400"
                >
                  Enregistrer
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {!loading && (
        <div className="flex justify-center mt-4 space-x-2">
          <button
            className="px-3 py-1 border border-slate-300 dark:border-slate-700 rounded-xl disabled:opacity-50 hover:bg-slate-50 dark:hover:bg-slate-700/30"
            disabled={pagination.page <= 1}
            onClick={() => setPage(pagination.page - 1)}
          >
            Précédent
          </button>
          <span className="px-2 py-1">
            Page {pagination.page} / {pagination.pages}
          </span>
          <button
            className="px-3 py-1 border border-slate-300 dark:border-slate-700 rounded-xl disabled:opacity-50 hover:bg-slate-50 dark:hover:bg-slate-700/30"
            disabled={pagination.page >= pagination.pages}
            onClick={() => setPage(pagination.page + 1)}
          >
            Suivant
          </button>
        </div>
      )}

      <ConfirmModal
        open={!!confirmDelete}
        message={`Supprimer la permission "${confirmDelete?.name}" ?`}
        onCancel={() => setConfirmDelete(null)}
        loading={confirmLoading}
        onConfirm={async () => {
          if (!confirmDelete) return;
          setConfirmLoading(true);
          try {
            await deletePermission(confirmDelete.id);
            addToast('success', 'Permission supprimée');
            setConfirmDelete(null);
            fetchData(page);
          } catch (err) {
            const message = err.response?.data?.message || 'Erreur de suppression';
            addToast('error', message);
            setConfirmDelete(null);
          } finally {
            setConfirmLoading(false);
          }
        }}
      />
    </div>
  );
}
