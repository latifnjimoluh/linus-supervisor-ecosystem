import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { scripts } from '../api';

export default function ScriptPreview() {
  const { serverId, service } = useParams();
  const [format, setFormat] = useState('bash');
  const [code, setCode] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    scripts
      .getScript(serverId, service, format)
      .then((res) => setCode(res.data.script))
      .catch(() => setCode(''));
  }, [serverId, service, format]);

  const exportScript = () => {
    const blob = new Blob([code], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${service}.${format === 'ansible' ? 'yml' : 'sh'}`;
    a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div>
      <h2>Preview Script for {service}</h2>
      <div>
        <button disabled={format === 'bash'} onClick={() => setFormat('bash')}>
          Bash
        </button>
        <button disabled={format === 'ansible'} onClick={() => setFormat('ansible')}>
          Ansible
        </button>
      </div>
      <pre>
        <code>{code}</code>
      </pre>
      <div>
        <button onClick={exportScript}>Exporter</button>
        <button onClick={() => navigate(`/configure/${serverId}/${service}`)}>Modifier</button>
        <button onClick={() => navigate(`/deploy/${serverId}`)}>Déployer</button>
      </div>
    </div>
  );
}
