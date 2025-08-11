"use client";

import * as React from "react";
import { listProxmoxVMs, ProxmoxVM } from "@/services/vms";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { RefreshCw } from "lucide-react";
import { cn } from "@/lib/utils";

export default function VmsPage() {
  const [vms, setVms] = React.useState<ProxmoxVM[]>([]);
  const [templates, setTemplates] = React.useState<ProxmoxVM[]>([]);
  const [loading, setLoading] = React.useState(true);

  const fetchData = React.useCallback(async () => {
    setLoading(true);
    try {
      const data = await listProxmoxVMs();
      setVms(data.vms);
      setTemplates(data.templates);
    } catch (e) {
      console.error("Erreur récupération VMs", e);
    } finally {
      setLoading(false);
    }
  }, []);

  React.useEffect(() => {
    fetchData();
  }, [fetchData]);

  const renderList = (items: ProxmoxVM[]) => (
    items.length ? (
      <ul className="space-y-2">
        {items.map((vm) => (
          <li key={vm.vmid} className="p-2 border rounded-lg">
            {vm.name}
          </li>
        ))}
      </ul>
    ) : (
      <p className="text-sm text-muted-foreground">Aucune entrée</p>
    )
  );

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Proxmox</h1>
        <Button onClick={fetchData} variant="outline" className="rounded-xl">
          <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} />
          Rafraîchir
        </Button>
      </div>
      <div className="grid md:grid-cols-2 gap-6">
        <Card className="rounded-2xl">
          <CardHeader>
            <CardTitle>Machines virtuelles</CardTitle>
          </CardHeader>
          <CardContent>{renderList(vms)}</CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardHeader>
            <CardTitle>Templates</CardTitle>
          </CardHeader>
          <CardContent>{renderList(templates)}</CardContent>
        </Card>
      </div>
    </div>
  );
}

