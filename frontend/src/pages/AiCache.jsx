import React, { useEffect, useState } from 'react';
import {
  listCache,
  createCache,
  updateCache,
  deleteCache,
} from '../api/ai';

export default function AiCache() {
  const [items, setItems] = useState([]);
  const [form, setForm] = useState({
    type: '',
    hash: '',
    input_text: '',
    response_text: '',
  });
  const [error, setError] = useState('');

  const fetchData = async () => {
    setError('');
    try {
      const res = await listCache();
      const data = res.data?.data || res.data;
      setItems(data);
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur chargement';
      setError(message);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">AI Cache</h1>
      {error && <p className="text-red-500">{error}</p>}

      <form
        onSubmit={async (e) => {
          e.preventDefault();
          try {
            await createCache(form);
            setForm({ type: '', hash: '', input_text: '', response_text: '' });
            fetchData();
          } catch (err) {
            const message = err.response?.data?.message || 'Erreur création';
            setError(message);
          }
        }}
        className="space-y-2"
      >
        <div className="grid grid-cols-2 gap-2">
          <input
            className="border p-2 rounded"
            placeholder="Type"
            value={form.type}
            onChange={(e) => setForm({ ...form, type: e.target.value })}
          />
          <input
            className="border p-2 rounded"
            placeholder="Hash"
            value={form.hash}
            onChange={(e) => setForm({ ...form, hash: e.target.value })}
          />
        </div>
        <textarea
          className="w-full border p-2 rounded"
          rows="2"
          placeholder="Texte d'entrée"
          value={form.input_text}
          onChange={(e) => setForm({ ...form, input_text: e.target.value })}
        />
        <textarea
          className="w-full border p-2 rounded"
          rows="2"
          placeholder="Texte de réponse"
          value={form.response_text}
          onChange={(e) => setForm({ ...form, response_text: e.target.value })}
        />
        <button
          type="submit"
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Ajouter
        </button>
      </form>

      <table className="w-full bg-white border">
        <thead>
          <tr className="bg-gray-100 text-left">
            <th className="p-2 border">ID</th>
            <th className="p-2 border">Type</th>
            <th className="p-2 border">Hash</th>
            <th className="p-2 border">Actions</th>
          </tr>
        </thead>
        <tbody>
          {items.map((item) => (
            <tr key={item.id} className="border-b">
              <td className="p-2 border">{item.id}</td>
              <td className="p-2 border">{item.type}</td>
              <td className="p-2 border">{item.hash}</td>
              <td className="p-2 border space-x-2">
                <button
                  className="px-2 py-1 bg-blue-600 text-white rounded"
                  onClick={async () => {
                    const text = prompt('Nouvelle réponse', item.response_text || '');
                    if (text !== null) {
                      try {
                        await updateCache(item.id, { response_text: text });
                        fetchData();
                      } catch (err) {
                        const message = err.response?.data?.message || 'Erreur mise à jour';
                        setError(message);
                      }
                    }
                  }}
                >
                  Éditer
                </button>
                <button
                  className="px-2 py-1 bg-red-600 text-white rounded"
                  onClick={async () => {
                    if (window.confirm('Supprimer cette entrée ?')) {
                      try {
                        await deleteCache(item.id);
                        fetchData();
                      } catch (err) {
                        const message = err.response?.data?.message || 'Erreur suppression';
                        setError(message);
                      }
                    }
                  }}
                >
                  Supprimer
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

