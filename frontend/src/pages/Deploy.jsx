import React from 'react';
import { useParams } from '../lib/router';

export default function Deploy() {
  const { serverId } = useParams();
  return (
    <div>
      <h2>Deployment for server {serverId}</h2>
      <pre>Deployment logs will appear here.</pre>
    </div>
  );
}
