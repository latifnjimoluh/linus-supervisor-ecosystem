import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { login } from '../api/auth';

const validateEmail = (value) => {
  if (!value) return 'Adresse e-mail requise';
  const regex = /[^\s@]+@[^\s@]+\.[^\s@]+/;
  if (!regex.test(value)) return 'Adresse invalide';
  return '';
};

const validatePassword = (value) => {
  if (!value) return 'Mot de passe requis';
  return '';
};

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [remember, setRemember] = useState(false);
  const [emailError, setEmailError] = useState('');
  const [passwordError, setPasswordError] = useState('');
  const [globalError, setGlobalError] = useState('');
  const [loading, setLoading] = useState(false);
  const [attempts, setAttempts] = useState(0);
  const [blockedUntil, setBlockedUntil] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    const token = localStorage.getItem('token');
    const expiry = localStorage.getItem('tokenExpiry');
    if (token && expiry && new Date(expiry) > new Date()) {
      navigate('/dashboard');
    }
  }, [navigate]);

  useEffect(() => {
    if (!blockedUntil) return;
    const timer = setInterval(() => {
      if (Date.now() > blockedUntil) {
        setBlockedUntil(null);
        clearInterval(timer);
      }
    }, 1000);
    return () => clearInterval(timer);
  }, [blockedUntil]);

  const isBlocked = blockedUntil && Date.now() < blockedUntil;
  const isEmailValid = !validateEmail(email);
  const isPasswordValid = !validatePassword(password);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const eErr = validateEmail(email);
    const pErr = validatePassword(password);
    setEmailError(eErr);
    setPasswordError(pErr);
    if (eErr || pErr || isBlocked) return;

    setLoading(true);
    setGlobalError('');
    try {
      const { data } = await login(email, password, remember);
      const expires = new Date(
        Date.now() + (remember ? 7 : 1) * 24 * 60 * 60 * 1000
      );
      localStorage.setItem('token', data.token);
      localStorage.setItem('tokenExpiry', expires.toISOString());
      navigate('/dashboard');
    } catch (err) {
      const message = err.response?.data?.message || 'Identifiants incorrects';
      setGlobalError(message);
      const newAttempts = attempts + 1;
      if (newAttempts >= 5) {
        setBlockedUntil(Date.now() + 30000);
        setAttempts(0);
      } else {
        setAttempts(newAttempts);
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-r from-indigo-500 to-purple-600 p-4">
      <form
        onSubmit={handleSubmit}
        className="bg-white/90 backdrop-blur p-6 rounded shadow-md w-full max-w-sm space-y-4"
      >
        <h1 className="text-2xl font-bold text-center text-indigo-700">Connexion</h1>
        {globalError && <p className="text-red-500 text-sm">{globalError}</p>}
        <div>
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className={`w-full border p-2 rounded focus:outline-none focus:ring-2 focus:ring-indigo-500 ${
              emailError ? 'border-red-500' : ''
            }`}
          />
          {emailError && <p className="text-red-500 text-xs mt-1">{emailError}</p>}
        </div>
        <div className="relative">
          <input
            type={showPassword ? 'text' : 'password'}
            placeholder="Mot de passe"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className={`w-full border p-2 rounded focus:outline-none focus:ring-2 focus:ring-indigo-500 pr-10 ${
              passwordError ? 'border-red-500' : ''
            }`}
          />
          <button
            type="button"
            onClick={() => setShowPassword((s) => !s)}
            className="absolute right-2 top-1/2 -translate-y-1/2 text-sm"
          >
            {showPassword ? '🙈' : '👁️'}
          </button>
          {passwordError && (
            <p className="text-red-500 text-xs mt-1">{passwordError}</p>
          )}
        </div>
        <div className="flex items-center justify-between">
          <label className="flex items-center text-sm">
            <input
              type="checkbox"
              checked={remember}
              onChange={(e) => setRemember(e.target.checked)}
              className="mr-2"
            />
            Se souvenir de moi
          </label>
          <button
            type="button"
            onClick={() => navigate('/forgot-password')}
            className="text-sm text-indigo-600 underline"
          >
            Mot de passe oublié ?
          </button>
        </div>
        {isBlocked && (
          <p className="text-red-500 text-xs">
            Trop de tentatives, réessayez plus tard.
          </p>
        )}
        <button
          type="submit"
          disabled={!isEmailValid || !isPasswordValid || loading || isBlocked}
          className={`w-full text-white p-2 rounded transition-colors ${
            !isEmailValid || !isPasswordValid || isBlocked
              ? 'bg-gray-400'
              : 'bg-indigo-600 hover:bg-indigo-700'
          }`}
        >
          {loading ? 'Chargement...' : 'Se connecter'}
        </button>
        <p className="text-sm text-center">
          Pas de compte?{' '}
          <button
            type="button"
            onClick={() => navigate('/register')}
            className="text-indigo-600 underline"
          >
            S'inscrire
          </button>
        </p>
      </form>
    </div>
  );
}

