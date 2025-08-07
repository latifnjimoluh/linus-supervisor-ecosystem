import React from 'react';
import { useParams } from 'react-router-dom';

export default function Deploy() {
  const { serverId } = useParams();
  return (
    <div>
      <h2>Deployment for server {serverId}</h2>
      <pre>Deployment logs will appear here.</pre>
    </div>
  );
}
