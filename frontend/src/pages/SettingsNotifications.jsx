import React, { useEffect, useState } from 'react';
import { getSettings, updateSettings, testNotification } from '../api/notifications';

export default function SettingsNotifications() {
  const [form, setForm] = useState({
    channels: { email: true, webhook: '', slack: '', telegram: '', discord: '' },
    rules: [],
    retry: { interval: 5, max: 3, consolidate: false, silence: 10 }
  });
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    getSettings()
      .then((res) => setForm(res.data))
      .catch(() => {});
  }, []);

  const handleChange = (path, value) => {
    setForm((prev) => {
      const updated = { ...prev };
      const keys = path.split('.');
      let obj = updated;
      for (let i = 0; i < keys.length - 1; i++) obj = obj[keys[i]];
      obj[keys[keys.length - 1]] = value;
      return updated;
    });
  };

  return (
    <div className="space-y-4 max-w-4xl">
      <h1 className="text-2xl font-bold">Notifications</h1>
      {message && <p className="text-green-600">{message}</p>}
      {error && <p className="text-red-600">{error}</p>}

      <div className="space-y-2">
        <h2 className="font-semibold">Canaux</h2>
        <label className="block">Email
          <input
            type="checkbox"
            className="ml-2"
            checked={form.channels.email}
            onChange={(e) => handleChange('channels.email', e.target.checked)}
          />
        </label>
        <label className="block">Webhook
          <input
            type="text"
            className="border p-1 ml-2"
            value={form.channels.webhook}
            onChange={(e) => handleChange('channels.webhook', e.target.value)}
          />
        </label>
        <label className="block">Slack
          <input
            type="text"
            className="border p-1 ml-2"
            value={form.channels.slack}
            onChange={(e) => handleChange('channels.slack', e.target.value)}
          />
        </label>
        <label className="block">Telegram
          <input
            type="text"
            className="border p-1 ml-2"
            value={form.channels.telegram}
            onChange={(e) => handleChange('channels.telegram', e.target.value)}
          />
        </label>
        <label className="block">Discord
          <input
            type="text"
            className="border p-1 ml-2"
            value={form.channels.discord}
            onChange={(e) => handleChange('channels.discord', e.target.value)}
          />
        </label>
      </div>

      <div className="space-y-2">
        <h2 className="font-semibold">Relances</h2>
        <label className="block">Intervalle (min)
          <input
            type="number"
            className="border p-1 ml-2 w-24"
            value={form.retry.interval}
            onChange={(e) => handleChange('retry.interval', Number(e.target.value))}
          />
        </label>
        <label className="block">Max relances
          <input
            type="number"
            className="border p-1 ml-2 w-24"
            value={form.retry.max}
            onChange={(e) => handleChange('retry.max', Number(e.target.value))}
          />
        </label>
        <label className="block">Consolider alertes
          <input
            type="checkbox"
            className="ml-2"
            checked={form.retry.consolidate}
            onChange={(e) => handleChange('retry.consolidate', e.target.checked)}
          />
        </label>
        <label className="block">Silence après résolution (min)
          <input
            type="number"
            className="border p-1 ml-2 w-24"
            value={form.retry.silence}
            onChange={(e) => handleChange('retry.silence', Number(e.target.value))}
          />
        </label>
      </div>

      <div className="flex space-x-2 pt-4">
        <button
          onClick={async () => {
            setMessage('');
            setError('');
            try {
              await updateSettings(form);
              setMessage('Configuration sauvegardée');
            } catch (err) {
              setError(err.response?.data?.message || 'Erreur de sauvegarde');
            }
          }}
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Enregistrer
        </button>
        <button
          onClick={async () => {
            try {
              await testNotification();
              setMessage('Alerte test envoyée');
            } catch (err) {
              setError('Erreur lors du test');
            }
          }}
          className="px-4 py-2 bg-gray-600 text-white rounded"
        >
          Tester une alerte
        </button>
      </div>
    </div>
  );
}
