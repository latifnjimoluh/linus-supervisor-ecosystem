import React from 'react';
import { useNavigate } from '../lib/router';

export default function NotFound() {
  const navigate = useNavigate();
  return (
    <div className="text-center mt-20 space-y-4">
      <h1 className="text-3xl font-bold">404 - Page introuvable</h1>
      <p>La page que vous recherchez n'existe pas.</p>
      <button
        onClick={() => navigate('/dashboard')}
        className="mt-4 px-4 py-2 bg-blue-600 text-white rounded"
      >
        Retour au tableau de bord
      </button>
    </div>
  );
}
