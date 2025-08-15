"use client"

import * as React from "react";
import Link from "next/link";
import { fetchDeploymentHistory, HistoryResponse } from "@/services/deployments";

export default function DeploymentLogsPage() {
  const [history, setHistory] = React.useState<HistoryResponse | null>(null);

  React.useEffect(() => {
    fetchDeploymentHistory({ limit: 50 })
      .then(setHistory)
      .catch(() => setHistory(null));
  }, []);

  if (!history) {
    return <div>Chargement...</div>;
  }

  return (
    <div className="space-y-8">
      <h1 className="text-4xl font-semibold">Logs de déploiement</h1>

      <section className="space-y-4">
        <h2 className="text-2xl font-semibold">Déploiements</h2>
        <ul className="space-y-2">
          {history.deployments.map((d) => (
            <li key={d.id} className="flex items-center justify-between rounded-md border p-4">
              <div>
                <div className="font-medium">{d.vm_name}</div>
                <div className="text-sm text-muted-foreground">{new Date(d.started_at).toLocaleString()}</div>
              </div>
              <Link href={`/deployments/${d.instance_id || d.id}`} className="text-primary hover:underline">
                Voir log
              </Link>
            </li>
          ))}
        </ul>
      </section>

      <section className="space-y-4">
        <h2 className="text-2xl font-semibold">Suppressions</h2>
        <ul className="space-y-2">
          {history.deletes.map((d) => (
            <li key={d.id} className="flex items-center justify-between rounded-md border p-4">
              <div>
                <div className="font-medium">{d.vm_name}</div>
                <div className="text-sm text-muted-foreground">{new Date(d.deleted_at).toLocaleString()}</div>
              </div>
              <Link href={`/deployments/${d.instance_id || d.id}`} className="text-primary hover:underline">
                Voir log
              </Link>
            </li>
          ))}
        </ul>
      </section>
    </div>
  );
}
