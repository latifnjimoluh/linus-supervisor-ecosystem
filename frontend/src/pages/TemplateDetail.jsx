import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from '../lib/router';
import {
  getTemplate,
  updateTemplate,
  deleteTemplate,
  generateScript,
} from '../api/templates';
import {
  analyzeScript,
  auditScript,
  assistantHelp,
} from '../api/ai';

export default function TemplateDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [form, setForm] = useState(null);
  const [error, setError] = useState('');
  const [analysis, setAnalysis] = useState('');
  const [audit, setAudit] = useState('');
  const [assistant, setAssistant] = useState('');
  const [config, setConfig] = useState('{}');
  const [scriptResult, setScriptResult] = useState('');

  const fetchData = async () => {
    setError('');
    try {
      const res = await getTemplate(id);
      const data = res.data?.data || res.data;
      setForm({
        name: data.name || '',
        service_type: data.service_type || '',
        category: data.category || '',
        description: data.description || '',
        template_content: data.template_content || '',
        script_path: data.script_path || '',
        fields_schema: JSON.stringify(data.fields_schema || { fields: [] }),
      });
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur de chargement';
      setError(message);
    }
  };

  useEffect(() => {
    fetchData();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  if (!form) return <p>Chargement...</p>;

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Template: {form.name}</h1>
      {error && <p className="text-red-500">{error}</p>}
      <form
        onSubmit={async (e) => {
          e.preventDefault();
          try {
            const payload = {
              ...form,
              fields_schema: JSON.parse(form.fields_schema || '{}'),
            };
            await updateTemplate(id, payload);
            alert('Mise à jour réussie');
          } catch (err) {
            const message =
              err.response?.data?.message || 'Erreur de mise à jour';
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
        />
        <input
          className="w-full border p-2 rounded"
          placeholder="Type de service"
          value={form.service_type}
          onChange={(e) => setForm({ ...form, service_type: e.target.value })}
        />
        <input
          className="w-full border p-2 rounded"
          placeholder="Catégorie"
          value={form.category}
          onChange={(e) => setForm({ ...form, category: e.target.value })}
        />
        <input
          className="w-full border p-2 rounded"
          placeholder="Description"
          value={form.description}
          onChange={(e) => setForm({ ...form, description: e.target.value })}
        />
        <input
          className="w-full border p-2 rounded"
          placeholder="Chemin du script"
          value={form.script_path}
          onChange={(e) => setForm({ ...form, script_path: e.target.value })}
        />
        <textarea
          className="w-full border p-2 rounded"
          placeholder="Contenu du template"
          rows="6"
          value={form.template_content}
          onChange={(e) =>
            setForm({ ...form, template_content: e.target.value })
          }
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
        <div className="flex space-x-2 pt-2">
          <button
            type="submit"
            className="px-4 py-2 bg-blue-600 text-white rounded"
          >
            Enregistrer
          </button>
          <button
            type="button"
            onClick={async () => {
              if (window.confirm('Supprimer ce template ?')) {
                try {
                  await deleteTemplate(id);
                  navigate('/templates');
                } catch (err) {
                  const message =
                    err.response?.data?.message || 'Erreur de suppression';
                  setError(message);
                }
              }
            }}
            className="px-4 py-2 bg-red-600 text-white rounded"
          >
            Supprimer
          </button>
        </div>
      </form>

      <div className="space-y-2">
        <div className="flex space-x-2">
          <button
            onClick={async () => {
              try {
                const res = await analyzeScript(form.template_content);
                const data = res.data?.data || res.data;
                setAnalysis(data);
              } catch (err) {
                const message =
                  err.response?.data?.message || 'Erreur analyse';
                setError(message);
              }
            }}
            className="px-4 py-2 bg-gray-200 rounded"
          >
            Analyse IA
          </button>
          <button
            onClick={async () => {
              try {
                const res = await auditScript(form.template_content);
                const data = res.data?.data || res.data;
                setAudit(data);
              } catch (err) {
                const message = err.response?.data?.message || 'Erreur audit';
                setError(message);
              }
            }}
            className="px-4 py-2 bg-gray-200 rounded"
          >
            Audit IA
          </button>
          <button
            onClick={async () => {
              try {
                const res = await assistantHelp(id);
                const data = res.data?.data || res.data;
                setAssistant(data);
              } catch (err) {
                const message =
                  err.response?.data?.message || 'Erreur assistant';
                setError(message);
              }
            }}
            className="px-4 py-2 bg-gray-200 rounded"
          >
            Assistant IA
          </button>
        </div>
        {analysis && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">
            {analysis}
          </pre>
        )}
        {audit && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">
            {audit}
          </pre>
        )}
        {assistant && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">
            {assistant}
          </pre>
        )}
      </div>

      <div className="space-y-2">
        <h2 className="text-lg font-semibold">Générer un script</h2>
        <textarea
          className="w-full border p-2 rounded"
          rows="4"
          value={config}
          onChange={(e) => setConfig(e.target.value)}
          placeholder="Configuration JSON"
        />
        <button
          onClick={async () => {
            try {
              const payload = {
                template_id: Number(id),
                config_data: JSON.parse(config || '{}'),
              };
              const res = await generateScript(payload);
              const data = res.data?.data || res.data;
              setScriptResult(data?.script || data);
            } catch (err) {
              const message =
                err.response?.data?.message || 'Erreur de génération';
              setError(message);
            }
          }}
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Générer
        </button>
        {scriptResult && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">
            {scriptResult}
          </pre>
        )}
      </div>
    </div>
  );
}

