import React, { useEffect, useState } from 'react';
import { auth } from '../api';

export default function Account() {
  const [profile, setProfile] = useState(null);
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirm, setConfirm] = useState('');
  const [message, setMessage] = useState('');

  useEffect(() => {
    auth.me().then((res) => setProfile(res.data));
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage('');
    if (newPassword !== confirm) {
      setMessage('Les mots de passe ne correspondent pas');
      return;
    }
    try {
      await auth.changePassword(currentPassword, newPassword);
      setMessage('Mot de passe mis à jour');
      setCurrentPassword('');
      setNewPassword('');
      setConfirm('');
    } catch (err) {
      setMessage(err.response?.data?.message || 'Erreur de mise à jour');
    }
  };

  if (!profile) return <div>Chargement...</div>;

  return (
    <div className="max-w-xl mx-auto space-y-6">
      <div className="p-4 bg-white rounded shadow">
        <h2 className="text-xl font-bold mb-2">Informations personnelles</h2>
        <p>Nom: {profile.first_name} {profile.last_name}</p>
        <p>Email: {profile.email}</p>
        <p>Rôle: {profile.role}</p>
      </div>
      <div className="p-4 bg-white rounded shadow">
        <h2 className="text-xl font-bold mb-2">Modifier le mot de passe</h2>
        <form onSubmit={handleSubmit} className="space-y-2">
          <input
            type="password"
            placeholder="Mot de passe actuel"
            className="border p-2 w-full"
            value={currentPassword}
            onChange={(e) => setCurrentPassword(e.target.value)}
            required
          />
          <input
            type="password"
            placeholder="Nouveau mot de passe"
            className="border p-2 w-full"
            value={newPassword}
            onChange={(e) => setNewPassword(e.target.value)}
            required
          />
          <input
            type="password"
            placeholder="Confirmer le mot de passe"
            className="border p-2 w-full"
            value={confirm}
            onChange={(e) => setConfirm(e.target.value)}
            required
          />
          {message && <div className="text-sm text-red-500">{message}</div>}
          <button
            type="submit"
            className="bg-blue-600 text-white px-4 py-2 rounded"
            disabled={!currentPassword || !newPassword || !confirm}
          >
            Mettre à jour
          </button>
        </form>
      </div>
    </div>
  );
}
