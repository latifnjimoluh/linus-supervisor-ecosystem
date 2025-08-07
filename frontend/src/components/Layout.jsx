'use client';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import ChatbotLauncher from './ChatbotLauncher';

export default function Layout({ children }) {
  const router = useRouter();
  const pathname = usePathname();
  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('tokenExpiry');
    router.push('/login');
  };

  const linkClass = (path) =>
    `px-3 py-2 rounded hover:bg-blue-700 transition-colors ${
      pathname === path ? 'bg-blue-700' : ''
    }`;

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-blue-600 text-white px-4 py-3 flex justify-between items-center">
        <div className="space-x-2">
          <Link href="/dashboard" className={linkClass('/dashboard')}>Dashboard</Link>
          <Link href="/dashboard/alerts" className={linkClass('/dashboard/alerts')}>Alertes</Link>
          <Link href="/users" className={linkClass('/users')}>Utilisateurs</Link>
          <Link href="/roles" className={linkClass('/roles')}>Rôles</Link>
          <Link href="/permissions" className={linkClass('/permissions')}>Permissions</Link>
          <Link href="/reset-history" className={linkClass('/reset-history')}>Réinitialisations</Link>
          <Link href="/logs" className={linkClass('/logs')}>Logs</Link>
          <Link href="/settings" className={linkClass('/settings')}>Paramètres</Link>
          <Link href="/settings/notifications" className={linkClass('/settings/notifications')}>Notifications</Link>
          <Link href="/templates" className={linkClass('/templates')}>Templates</Link>
          <Link href="/monitoring" className={linkClass('/monitoring')}>Monitoring</Link>
          <Link href="/servers" className={linkClass('/servers')}>Serveurs</Link>
          <Link href="/vms" className={linkClass('/vms')}>VMs</Link>
          <Link href="/terraform" className={linkClass('/terraform')}>Terraform</Link>
          <Link href="/ai-tools" className={linkClass('/ai-tools')}>Outils IA</Link>
          <Link href="/ai-cache" className={linkClass('/ai-cache')}>AI Cache</Link>
          <Link href="/assistant" className={linkClass('/assistant')}>Assistant</Link>
          <Link href="/account" className={linkClass('/account')}>Mon Profil</Link>
        </div>
        <button
          onClick={handleLogout}
          className="bg-blue-800 px-3 py-1 rounded hover:bg-blue-900"
        >
          Déconnexion
        </button>
      </nav>
      <main className="p-4">{children}</main>
      <ChatbotLauncher />
    </div>
  );
}
