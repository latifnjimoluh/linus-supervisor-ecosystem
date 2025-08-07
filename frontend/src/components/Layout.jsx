import React from 'react';
import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import ChatbotLauncher from './ChatbotLauncher';

export default function Layout() {
  const navigate = useNavigate();
  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('tokenExpiry');
    navigate('/login');
  };

  const linkClass = ({ isActive }) =>
    `px-3 py-2 rounded hover:bg-blue-700 transition-colors ${
      isActive ? 'bg-blue-700' : ''
    }`;

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-blue-600 text-white px-4 py-3 flex justify-between items-center">
        <div className="space-x-2">
          <NavLink to="/dashboard" className={linkClass}>
            Dashboard
          </NavLink>
          <NavLink to="/dashboard/alerts" className={linkClass}>
            Alertes
          </NavLink>
          <NavLink to="/users" className={linkClass}>
            Utilisateurs
          </NavLink>
          <NavLink to="/roles" className={linkClass}>
            Rôles
          </NavLink>
          <NavLink to="/permissions" className={linkClass}>
            Permissions
          </NavLink>
          <NavLink to="/reset-history" className={linkClass}>
            Réinitialisations
          </NavLink>
          <NavLink to="/logs" className={linkClass}>
            Logs
          </NavLink>
          <NavLink to="/settings" className={linkClass}>
            Paramètres
          </NavLink>
          <NavLink to="/settings/notifications" className={linkClass}>
            Notifications
          </NavLink>
          <NavLink to="/templates" className={linkClass}>
            Templates
          </NavLink>
          <NavLink to="/monitoring" className={linkClass}>
            Monitoring
          </NavLink>
          <NavLink to="/servers" className={linkClass}>
            Serveurs
          </NavLink>
          <NavLink to="/vms" className={linkClass}>
            VMs
          </NavLink>
          <NavLink to="/terraform" className={linkClass}>
            Terraform
          </NavLink>
          <NavLink to="/ai-tools" className={linkClass}>
            Outils IA
          </NavLink>
          <NavLink to="/ai-cache" className={linkClass}>
            AI Cache
          </NavLink>
          <NavLink to="/assistant" className={linkClass}>
            Assistant
          </NavLink>
          <NavLink to="/account" className={linkClass}>
            Mon Profil
          </NavLink>
        </div>
        <button
          onClick={handleLogout}
          className="bg-blue-800 px-3 py-1 rounded hover:bg-blue-900"
        >
          Déconnexion
        </button>
      </nav>
      <main className="p-4">
        <Outlet />
      </main>
      <ChatbotLauncher />
    </div>
  );
}
