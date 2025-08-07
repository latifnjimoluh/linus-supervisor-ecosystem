import React, { useEffect, useState } from 'react';
import { servers } from '../api';
import { Link, useNavigate } from '../lib/router';

export default function Servers() {
  const [list, setList] = useState([]);
  const [search, setSearch] = useState('');
  const navigate = useNavigate();

  const load = () => servers.list().then((res) => setList(res.data));

  useEffect(() => {
    load();
  }, []);

  const handleDelete = async (id) => {
    if (!window.confirm('Supprimer ce serveur ?')) return;
    await servers.remove(id);
    load();
  };

  const filtered = list.filter((s) =>
    s.name.toLowerCase().includes(search.toLowerCase()) ||
    s.ip.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-bold">Serveurs</h1>
        <div className="space-x-2">
          <input
            type="text"
            placeholder="Rechercher"
            className="border p-2"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
          <button
            className="px-3 py-1 bg-blue-600 text-white rounded"
            onClick={() => navigate('/servers/add')}
          >
            Ajouter
          </button>
        </div>
      </div>
      <table className="min-w-full bg-white">
        <thead>
          <tr>
            <th className="p-2 text-left">Nom</th>
            <th className="p-2 text-left">IP</th>
            <th className="p-2 text-left">Zone</th>
            <th className="p-2 text-left">Statut</th>
            <th className="p-2 text-left">Supervision</th>
            <th className="p-2" />
          </tr>
        </thead>
        <tbody>
          {filtered.map((s) => (
            <tr key={s.id} className="border-t">
              <td className="p-2 text-blue-600 underline">
                <Link to={`/servers/${s.id}`}>{s.name}</Link>
              </td>
              <td className="p-2">{s.ip}</td>
              <td className="p-2">{s.zone}</td>
              <td className="p-2">{s.status}</td>
              <td className="p-2">{s.supervised ? 'Oui' : 'Non'}</td>
              <td className="p-2 space-x-2">
                <button
                  onClick={() => navigate(`/servers/${s.id}/edit`)}
                  className="text-blue-600 underline"
                >
                  Modifier
                </button>
                <button
                  onClick={() => handleDelete(s.id)}
                  className="text-red-600 underline"
                >
                  Supprimer
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
