import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { get } from '../api/servers';

export default function MonitoringDetail() {
  const { id } = useParams();
  const [record, setRecord] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const load = async () => {
      setError('');
      try {
        const res = await get(id);
        setRecord(res.data);
      } catch (err) {
        const msg = err.response?.data?.message || 'Erreur de chargement';
        setError(msg);
      }
    };
    load();
  }, [id]);

  if (!record && !error) {
    return <p>Chargement...</p>;
  }

  const system = record?.system || {};
  const services = record?.services_status?.services || record?.services || [];

  const memTotal = system.memory?.total_kb;
  const memAvail = system.memory?.available_kb;
  const memUsed =
    memTotal != null && memAvail != null ? memTotal - memAvail : null;

  const disk = system.disk || {};
  const network = system.network || {};
  const processes = system.top_processes || [];

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">
        Monitoring {record?.name ? `(${record.name})` : `#${id}`}
      </h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {record && (
        <div className="space-y-6">
          <section className="bg-white p-4 rounded shadow">
            <h2 className="font-semibold mb-2">Système</h2>
            <p>
              <strong>IP :</strong> {system.ip_address || record.ip}
            </p>
            <p>
              <strong>Charge :</strong> {system.load_average}
            </p>
            <p>
              <strong>Mémoire :</strong>{' '}
              {memUsed != null && memTotal != null
                ? `${(memUsed / 1024).toFixed(1)} / ${(memTotal / 1024).toFixed(1)} Mo`
                : 'N/A'}
            </p>
            <p>
              <strong>Disque :</strong>{' '}
              {disk.used_bytes != null && disk.total_bytes != null
                ? `${(disk.used_bytes / 1024 / 1024 / 1024).toFixed(1)} / ${(
                    disk.total_bytes /
                    1024 /
                    1024 /
                    1024
                  ).toFixed(1)} Go`
                : 'N/A'}
            </p>
            <p>
              <strong>Réseau :</strong>{' '}
              {network.interface
                ? `${network.interface} RX ${(network.rx_bytes / 1024 / 1024).toFixed(
                    1
                  )} Mo TX ${(network.tx_bytes / 1024 / 1024).toFixed(1)} Mo`
                : 'N/A'}
            </p>
            {system.open_ports && (
              <p>
                <strong>Ports ouverts :</strong> {system.open_ports.join(', ')}
              </p>
            )}
          </section>

          {processes.length > 0 && (
            <section className="bg-white p-4 rounded shadow">
              <h2 className="font-semibold mb-2">Top processus</h2>
              <table className="min-w-full text-sm">
                <thead>
                  <tr className="bg-gray-100">
                    <th className="text-left p-2">PID</th>
                    <th className="text-left p-2">Commande</th>
                    <th className="text-left p-2">CPU %</th>
                  </tr>
                </thead>
                <tbody>
                  {processes.map((p) => (
                    <tr key={p.pid} className="border-t">
                      <td className="p-2">{p.pid}</td>
                      <td className="p-2">{p.cmd}</td>
                      <td className="p-2">{p.cpu}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </section>
          )}

          {services.length > 0 && (
            <section className="bg-white p-4 rounded shadow">
              <h2 className="font-semibold mb-2">Services</h2>
              <table className="min-w-full text-sm">
                <thead>
                  <tr className="bg-gray-100">
                    <th className="text-left p-2">Service</th>
                    <th className="text-left p-2">Actif</th>
                    <th className="text-left p-2">Activé</th>
                  </tr>
                </thead>
                <tbody>
                  {services.map((s) => (
                    <tr key={s.name} className="border-t">
                      <td className="p-2">{s.name}</td>
                      <td className="p-2">{s.active}</td>
                      <td className="p-2">{s.enabled}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </section>
          )}
        </div>
      )}
    </div>
  );
}
