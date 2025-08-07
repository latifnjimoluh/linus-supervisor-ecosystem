import React from 'react';
import { useNavigate } from 'react-router-dom';

export default function Forbidden() {
  const navigate = useNavigate();
  const role = localStorage.getItem('userRole') || 'inconnu';
  return (
    <div className="text-center mt-20 space-y-4">
      <h1 className="text-3xl font-bold">⛔ Accès interdit (403)</h1>
      <p>Vous ne disposez pas des autorisations nécessaires pour accéder à cette page.</p>
      <p>Votre rôle : {role}</p>
      <button
        onClick={() => navigate('/dashboard')}
        className="mt-4 px-4 py-2 bg-blue-600 text-white rounded"
      >
        Retour au tableau de bord
      </button>
    </div>
  );
}
