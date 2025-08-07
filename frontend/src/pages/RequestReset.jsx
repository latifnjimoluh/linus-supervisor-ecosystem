import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { requestReset } from '../api/auth';

export default function RequestReset() {
  const [email, setEmail] = useState('');
  const [touched, setTouched] = useState(false);
  const [status, setStatus] = useState('idle'); // idle | loading | success | error
  const [message, setMessage] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const emailRegex = /^\S+@\S+\.\S+$/;
  const isValid = emailRegex.test(email);
  const showError = touched && (!email ? "L'adresse e-mail est requise" : !isValid ? "Format d'e-mail incorrect" : '');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setTouched(true);
    setError('');
    setMessage('');
    if (!isValid) return;

    setStatus('loading');
    try {
      const { data } = await requestReset(email);
      setMessage(data.message);
      setStatus('success');
    } catch (err) {
      const msg = err.response?.data?.message || 'Erreur d\u2019envoi. Veuillez r\u00e9essayer.';
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
          Demande de r\u00e9initialisation
        </h1>
        {message && <p className="text-green-600 text-sm">{message}</p>}
        {error && <p className="text-red-500 text-sm">{error}</p>}
        <div className="space-y-1">
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            onBlur={() => setTouched(true)}
            className={`w-full border p-2 rounded focus:outline-none focus:ring-2 focus:ring-indigo-500 ${
              showError ? 'border-red-500' : ''
            }`}
          />
          {showError && <p className="text-red-500 text-sm">{showError}</p>}
        </div>
        <button
          type="submit"
          disabled={!isValid || status === 'loading' || status === 'success'}
          className={`w-full text-white p-2 rounded ${
            !isValid || status === 'loading' || status === 'success'
              ? 'bg-gray-400 cursor-not-allowed'
              : 'bg-indigo-600 hover:bg-indigo-700'
          }`}
        >
          {status === 'loading'
            ? 'Envoi...'
            : status === 'success'
            ? 'Envoy\u00e9'
            : 'Envoyer le lien'}
        </button>
        <p className="text-sm text-center">
          <button
            type="button"
            onClick={() => navigate('/login')}
            className="text-indigo-600 underline"
          >
            Retour \u00e0 la connexion
          </button>
        </p>
      </form>
    </div>
  );
}
