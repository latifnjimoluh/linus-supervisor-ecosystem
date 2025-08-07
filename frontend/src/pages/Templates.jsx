import React, { useEffect, useState } from 'react';
import { Link } from '../lib/router';
import {
  listTemplates,
  createTemplate,
  deleteTemplate,
} from '../api/templates';

export default function Templates() {
  const [templates, setTemplates] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showCreate, setShowCreate] = useState(false);
  const [form, setForm] = useState({
    name: '',
    service_type: '',
    category: '',
    description: '',
    template_content: '',
    script_path: '',
    fields_schema: '{"fields":[]}',
  });

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const res = await listTemplates();
      const data = res.data?.data || res.data || [];
      setTemplates(data);
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
  }, []);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Templates de service</h1>
      <div className="mb-4 text-right">
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
                <th className="text-left p-2">Nom</th>
                <th className="text-left p-2">Service</th>
                <th className="text-left p-2">Catégorie</th>
                <th className="text-left p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {templates.map((t) => (
                <tr key={t.id} className="border-t hover:bg-gray-50">
                  <td className="p-2">{t.name}</td>
                  <td className="p-2">{t.service_type}</td>
                  <td className="p-2">{t.category}</td>
                  <td className="p-2 space-x-2">
                    <Link
                      to={`/templates/${t.id}`}
                      className="text-blue-600 hover:underline"
                    >
                      Voir
                    </Link>
                    <button
                      onClick={async () => {
                        if (window.confirm('Supprimer ce template ?')) {
                          try {
                            await deleteTemplate(t.id);
                            fetchData();
                          } catch (err) {
                            const message =
                              err.response?.data?.message || 'Erreur de suppression';
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
              {templates.length === 0 && (
                <tr>
                  <td colSpan="4" className="p-2 text-center text-gray-500">
                    Aucun template
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}

      {showCreate && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
          <div className="bg-white p-6 rounded shadow w-full max-w-2xl overflow-y-auto max-h-[90vh]">
            <h2 className="text-lg font-semibold mb-4">Créer un template</h2>
            <form
              onSubmit={async (e) => {
                e.preventDefault();
                try {
                  const payload = {
                    ...form,
                    fields_schema: JSON.parse(form.fields_schema || '{}'),
                  };
                  await createTemplate(payload);
                  setShowCreate(false);
                  setForm({
                    name: '',
                    service_type: '',
                    category: '',
                    description: '',
                    template_content: '',
                    script_path: '',
                    fields_schema: '{"fields":[]}',
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
                placeholder="Nom"
                value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                required
              />
              <input
                className="w-full border p-2 rounded"
                placeholder="Type de service"
                value={form.service_type}
                onChange={(e) =>
                  setForm({ ...form, service_type: e.target.value })
                }
                required
              />
              <input
                className="w-full border p-2 rounded"
                placeholder="Catégorie"
                value={form.category}
                onChange={(e) => setForm({ ...form, category: e.target.value })}
                required
              />
              <input
                className="w-full border p-2 rounded"
                placeholder="Description"
                value={form.description}
                onChange={(e) =>
                  setForm({ ...form, description: e.target.value })
                }
                required
              />
              <input
                className="w-full border p-2 rounded"
                placeholder="Chemin du script"
                value={form.script_path}
                onChange={(e) =>
                  setForm({ ...form, script_path: e.target.value })
                }
                required
              />
              <textarea
                className="w-full border p-2 rounded"
                placeholder="Contenu du template"
                rows="6"
                value={form.template_content}
                onChange={(e) =>
                  setForm({ ...form, template_content: e.target.value })
                }
                required
              />
              <textarea
                className="w-full border p-2 rounded"
                placeholder="Schema des champs (JSON)"
                rows="4"
                value={form.fields_schema}
                onChange={(e) =>
                  setForm({ ...form, fields_schema: e.target.value })
                }
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

