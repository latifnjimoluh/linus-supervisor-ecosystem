import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { listUsers } from '../api/users';
import { listRoles } from '../api/roles';
import { listPermissions } from '../api/permissions';
import { getLogs } from '../api/logs';
import { listTemplates } from '../api/templates';
import { listVms } from '../api/vms';
import { listMonitoring } from '../api/monitoring';

export default function Dashboard() {
  const [stats, setStats] = useState({
    users: 0,
    roles: 0,
    permissions: 0,
    logs: 0,
    templates: 0,
    vms: 0,
    monitoring: 0,
  });

  useEffect(() => {
    async function fetchStats() {
      try {
        const [u, r, p, l, t, v, m] = await Promise.all([
          listUsers(),
          listRoles(),
          listPermissions(),
          getLogs(),
          listTemplates(),
          listVms(),
          listMonitoring(),
        ]);

        const extractCount = (res) => {
          const data = res.data;
          if (Array.isArray(data)) return data.length;
          if (Array.isArray(data?.data)) return data.data.length;
          return 0;
        };

        setStats({
          users: extractCount(u),
          roles: extractCount(r),
          permissions: extractCount(p),
          logs: extractCount(l),
          templates: extractCount(t),
          vms: extractCount(v),
          monitoring: extractCount(m),
        });
      } catch (err) {
        // eslint-disable-next-line no-console
        console.error(err);
      }
    }

    fetchStats();
  }, []);

  const statItems = [
    { label: 'Utilisateurs', value: stats.users },
    { label: 'Rôles', value: stats.roles },
    { label: 'Permissions', value: stats.permissions },
    { label: 'Logs', value: stats.logs },
    { label: 'Templates', value: stats.templates },
    { label: 'VMs', value: stats.vms },
    { label: 'Monitoring', value: stats.monitoring },
  ];

  const links = [
    {
      to: '/users',
      title: 'Utilisateurs',
      desc: 'Créer, rechercher et modifier les comptes.',
    },
    {
      to: '/roles',
      title: 'Rôles',
      desc: 'Définir les rôles et leurs permissions.',
    },
    {
      to: '/permissions',
      title: 'Permissions',
      desc: 'Attribuer ou retirer les accès.',
    },
    { to: '/vms', title: 'Machines virtuelles', desc: 'Contrôler les VMs Proxmox.' },
    { to: '/templates', title: 'Templates', desc: 'Générer ou auditer des scripts.' },
    {
      to: '/monitoring',
      title: 'Monitoring',
      desc: 'Collecter et consulter les métriques.',
    },
    { to: '/logs', title: 'Logs', desc: "Analyser l'activité du système." },
    {
      to: '/terraform',
      title: 'Terraform',
      desc: 'Déployer des infrastructures.',
    },
    { to: '/ai-tools', title: 'Outils IA', desc: 'Expliquer, analyser et simuler.' },
    { to: '/ai-cache', title: 'Cache IA', desc: 'Gérer les réponses générées.' },
    { to: '/settings', title: 'Paramètres', desc: 'Configurer vos informations Proxmox.' },
  ];

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Tableau de bord</h1>

      <div className="grid gap-4 mb-8 sm:grid-cols-2 lg:grid-cols-4">
        {statItems.map((s) => (
          <div key={s.label} className="p-4 bg-white rounded shadow">
            <p className="text-sm text-gray-500">{s.label}</p>
            <p className="text-2xl font-semibold">{s.value}</p>
          </div>
        ))}
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {links.map((link) => (
          <Link
            key={link.to}
            to={link.to}
            className="p-6 bg-white rounded shadow hover:shadow-md transition-shadow"
          >
            <h2 className="text-xl font-semibold mb-2">{link.title}</h2>
            <p className="text-gray-600">{link.desc}</p>
          </Link>
        ))}
      </div>
    </div>
  );
}
