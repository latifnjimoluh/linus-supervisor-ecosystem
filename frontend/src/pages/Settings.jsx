import React, { useEffect, useState } from 'react';
import {
  getMySettings,
  createMySettings,
  updateMySettings,
  listSettings,
} from '../api/settings';

const fields = [
  { name: 'cloudinit_user', label: 'Cloudinit User' },
  { name: 'cloudinit_password', label: 'Cloudinit Password' },
  { name: 'proxmox_api_url', label: 'Proxmox API URL' },
  { name: 'proxmox_api_token_id', label: 'Proxmox API Token ID' },
  { name: 'proxmox_api_token_name', label: 'Proxmox API Token Name' },
  { name: 'proxmox_api_token_secret', label: 'Proxmox API Token Secret' },
  { name: 'pm_user', label: 'PM User' },
  { name: 'pm_password', label: 'PM Password' },
  { name: 'proxmox_node', label: 'Proxmox Node' },
  { name: 'vm_storage', label: 'VM Storage' },
  { name: 'vm_bridge', label: 'VM Bridge' },
  { name: 'ssh_public_key_path', label: 'SSH Public Key Path' },
  { name: 'ssh_private_key_path', label: 'SSH Private Key Path' },
  { name: 'statuspath', label: 'Status Path' },
  { name: 'servicespath', label: 'Services Path' },
  { name: 'instanceinfopath', label: 'Instance Info Path' },
  { name: 'proxmox_host', label: 'Proxmox Host' },
  { name: 'proxmox_ssh_user', label: 'Proxmox SSH User' },
];

export default function Settings() {
  const initialForm = fields.reduce((acc, f) => ({ ...acc, [f.name]: '' }), {});
  const [form, setForm] = useState(initialForm);
  const [exists, setExists] = useState(false);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const [all, setAll] = useState([]);

  useEffect(() => {
    async function fetchMine() {
      try {
        const res = await getMySettings();
        if (res.data) {
          setForm({ ...initialForm, ...res.data });
          setExists(true);
        }
      } catch (err) {
        // ignore if not found
      }
    }
    async function fetchAll() {
      try {
        const res = await listSettings();
        const data = res.data?.data || res.data || [];
        setAll(data);
      } catch (err) {
        // ignore if unauthorized
      }
    }
    fetchMine();
    fetchAll();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    setMessage('');
    try {
      if (exists) {
        await updateMySettings(form);
        setMessage('Paramètres mis à jour.');
      } else {
        await createMySettings(form);
        setMessage('Paramètres enregistrés.');
        setExists(true);
      }
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur de sauvegarde';
      setError(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Mes paramètres</h1>
      {message && <p className="text-green-600 mb-2">{message}</p>}
      {error && <p className="text-red-600 mb-2">{error}</p>}
      <form onSubmit={handleSubmit} className="grid gap-4 max-w-3xl">
        {fields.map((f) => (
          <div key={f.name} className="flex flex-col">
            <label className="text-sm mb-1" htmlFor={f.name}>
              {f.label}
            </label>
            <input
              id={f.name}
              className="border p-2 rounded"
              value={form[f.name]}
              onChange={(e) =>
                setForm({ ...form, [f.name]: e.target.value })
              }
            />
          </div>
        ))}
        <button
          type="submit"
          disabled={loading}
          className="self-start px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
        >
          {exists ? 'Mettre à jour' : 'Enregistrer'}
        </button>
      </form>

      {all.length > 0 && (
        <div className="mt-8">
          <h2 className="text-xl font-semibold mb-2">
            Tous les paramètres utilisateurs
          </h2>
          <div className="overflow-x-auto bg-white rounded shadow">
            <table className="min-w-full text-sm">
              <thead className="bg-gray-100">
                <tr>
                  <th className="text-left p-2">Utilisateur</th>
                  <th className="text-left p-2">Proxmox API URL</th>
                  <th className="text-left p-2">Proxmox Node</th>
                </tr>
              </thead>
              <tbody>
                {all.map((s) => (
                  <tr key={s.id} className="border-t hover:bg-gray-50">
                    <td className="p-2">{s.user_id}</td>
                    <td className="p-2">{s.proxmox_api_url}</td>
                    <td className="p-2">{s.proxmox_node}</td>
                  </tr>
                ))}
                {all.length === 0 && (
                  <tr>
                    <td
                      colSpan="3"
                      className="p-2 text-center text-gray-500"
                    >
                      Aucun paramètre
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}

