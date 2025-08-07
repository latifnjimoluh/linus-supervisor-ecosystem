import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { getMonitoring } from '../api/monitoring';

export default function MonitoringDetail() {
  const { id } = useParams();
  const [record, setRecord] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const load = async () => {
      setError('');
      try {
        const res = await getMonitoring(id);
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

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">Monitoring #{id}</h1>
      {error && <p className="text-red-500 mb-2">{error}</p>}
      {record && (
        <pre className="bg-white p-4 rounded shadow overflow-auto text-sm">
          {JSON.stringify(record, null, 2)}
        </pre>
      )}
    </div>
  );
}

