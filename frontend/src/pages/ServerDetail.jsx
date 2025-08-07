import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from '../lib/router';
import { servers } from '../api';

export default function ServerDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [data, setData] = useState(null);

  const load = () => servers.get(id).then((res) => setData(res.data));

  useEffect(() => {
    load();
  }, [id]);

  if (!data) return <div>Chargement...</div>;

  const handleDelete = async () => {
    if (!window.confirm('Supprimer ce serveur ?')) return;
    await servers.remove(id);
    navigate('/servers');
  };

  const services = data.services_status?.services || [];

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-bold">{data.name}</h1>
        <div className="space-x-2">
          <button
            onClick={() => navigate(`/servers/${id}/edit`)}
            className="px-3 py-1 border rounded"
          >
            Modifier
          </button>
          <button
            onClick={handleDelete}
            className="px-3 py-1 border rounded text-red-600"
          >
            Supprimer
          </button>
        </div>
      </div>
      <div className="bg-white p-4 rounded shadow space-y-1">
        <p>IP: {data.ip}</p>
        <p>Zone: {data.zone}</p>
        <p>Statut: {data.status}</p>
        <p>Supervision: {data.supervised ? 'Oui' : 'Non'}</p>
      </div>
      <div className="bg-white p-4 rounded shadow">
        <h2 className="font-bold mb-2">Ressources</h2>
        <p>CPU: {data.system.cpu_usage || 'N/A'}%</p>
        <p>Mémoire: {data.system.memory_usage || 'N/A'}%</p>
        <p>Disque: {data.system.disk_usage || 'N/A'}%</p>
      </div>
      <div className="bg-white p-4 rounded shadow">
        <h2 className="font-bold mb-2">Services</h2>
        <ul className="list-disc pl-5 space-y-1">
          {services.map((s, idx) => (
            <li key={idx}>{s.name} - {s.active}</li>
          ))}
        </ul>
      </div>
    </div>
  );
}
