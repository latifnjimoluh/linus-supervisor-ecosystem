import React, { useEffect, useState } from 'react';
import { Link } from '../lib/router';
import { listServers } from '../api/dashboard';

export default function DashboardMap() {
  const [zones, setZones] = useState({});

  useEffect(() => {
    async function fetch() {
      try {
        const res = await listServers();
        const grouped = res.data.reduce((acc, srv) => {
          const zone = srv.zone || 'Zone inconnue';
          if (!acc[zone]) acc[zone] = [];
          acc[zone].push(srv);
          return acc;
        }, {});
        setZones(grouped);
      } catch (err) {
        // eslint-disable-next-line no-console
        console.error(err);
      }
    }
    fetch();
  }, []);

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">Carte infrastructure</h1>
      <div className="flex flex-wrap gap-4">
        {Object.entries(zones).map(([zone, srvs]) => (
          <div key={zone} className="flex-1 min-w-[200px] p-4 bg-white rounded shadow">
            <h2 className="font-semibold mb-2">{zone}</h2>
            <ul>
              {srvs.map((s) => (
                <li key={s.id} className="mb-1">
                  <Link
                    to={`/monitoring?vm_ip=${s.ip}`}
                    title={`IP: ${s.ip}\\nServices: ${s.services.join(', ')}`}
                    className="inline-block px-2 py-1 rounded text-white"
                    style={{
                      backgroundColor:
                        s.status === 'alert'
                          ? '#dc2626'
                          : s.status === 'active'
                          ? '#16a34a'
                          : '#facc15',
                    }}
                  >
                    {s.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
      <div className="mt-6 p-4 bg-white rounded shadow max-w-sm">
        <h3 className="font-semibold mb-2">Légende</h3>
        <p className="mb-1"><span className="text-green-600">🟢</span> OK</p>
        <p className="mb-1"><span className="text-red-600">🔴</span> Alerte</p>
        <p><span className="text-yellow-500">🟡</span> Hors supervision</p>
      </div>
    </div>
  );
}
