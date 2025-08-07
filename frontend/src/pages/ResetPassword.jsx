import React, { useState } from 'react';
import { useNavigate } from '../lib/router';
import { resetPassword } from '../api/auth';

export default function ResetPassword() {
  const [code, setCode] = useState('');
  const [password, setPassword] = useState('');
  const [status, setStatus] = useState('idle');
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const canSubmit = code.trim() && password && status !== 'loading';

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setMessage('');
    if (!code.trim() || !password) return;

    setStatus('loading');
    try {
      const { data } = await resetPassword(code, password);
      setMessage(data.message || 'Mot de passe modifié');
      setStatus('success');
      setTimeout(() => navigate('/login'), 1500);
    } catch (err) {
      const msg = err.response?.data?.message || 'Réinitialisation échouée';
      setError(msg);
      setStatus('error');
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-r from-indigo-500 to-purple-600 p-4">
      <form
        onSubmit={handleSubmit}
        className="bg-white/90 backdrop-blur p-6 rounded shadow-md w-full max-w-sm space-y-4"
      >
        <h1 className="text-2xl font-bold text-center text-indigo-700">
          Nouveau mot de passe
        </h1>
        {message && <p className="text-green-600 text-sm">{message}</p>}
        {error && <p className="text-red-500 text-sm">{error}</p>}
        <input
          type="text"
          placeholder="Code reçu"
          value={code}
          onChange={(e) => setCode(e.target.value)}
          className="w-full border p-2 rounded focus:outline-none focus:ring-2 focus:ring-indigo-500"
          required
        />
        <input
          type="password"
          placeholder="Nouveau mot de passe"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full border p-2 rounded focus:outline-none focus:ring-2 focus:ring-indigo-500"
          required
        />
        <button
          type="submit"
          disabled={!canSubmit}
          className={`w-full text-white p-2 rounded ${
            !canSubmit
              ? 'bg-gray-400 cursor-not-allowed'
              : 'bg-indigo-600 hover:bg-indigo-700'
          }`}
        >
          {status === 'loading' ? 'Envoi...' : 'Réinitialiser'}
        </button>
        <p className="text-sm text-center">
          <button
            type="button"
            onClick={() => navigate('/login')}
            className="text-indigo-600 underline"
          >
            Retour à la connexion
          </button>
        </p>
      </form>
    </div>
  );
}
