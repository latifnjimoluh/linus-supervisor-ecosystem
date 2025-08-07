import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { requestReset } from '../api/auth';

export default function RequestReset() {
  const [email, setEmail] = useState('');
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setMessage('');
    try {
      const { data } = await requestReset(email);
      setMessage(data.message || 'Code envoyé, vérifiez votre email.');
    } catch (err) {
      const msg = err.response?.data?.message || "Échec de l'envoi";
      setError(msg);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-r from-indigo-500 to-purple-600 p-4">
      <form
        onSubmit={handleSubmit}
        className="bg-white/90 backdrop-blur p-6 rounded shadow-md w-full max-w-sm space-y-4"
      >
        <h1 className="text-2xl font-bold text-center text-indigo-700">
          Demande de code
        </h1>
        {message && <p className="text-green-600 text-sm">{message}</p>}
        {error && <p className="text-red-500 text-sm">{error}</p>}
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full border p-2 rounded focus:outline-none focus:ring-2 focus:ring-indigo-500"
          required
        />
        <button
          type="submit"
          className="w-full bg-indigo-600 text-white p-2 rounded hover:bg-indigo-700"
        >
          Envoyer le code
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
