import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function ErrorPage() {
  const navigate = useNavigate();
  const message = localStorage.getItem('lastError') || 'Une erreur inconnue est survenue';
  return (
    <div className="text-center mt-20 space-y-4">
      <h1 className="text-3xl font-bold">Erreur technique</h1>
      <p>{message}</p>
      <button
        onClick={() => navigate(-1)}
        className="mt-4 px-4 py-2 bg-blue-600 text-white rounded"
      >
        Retour
      </button>
    </div>
  );
}
