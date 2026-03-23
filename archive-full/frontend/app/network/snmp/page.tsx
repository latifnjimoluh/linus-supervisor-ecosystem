"use client";

import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { getSnmpInterfaceStatus } from "@/services/network";
import { useToast } from "@/hooks/use-toast";

export default function SnmpPage() {
  const [host, setHost] = useState("");
  const [community, setCommunity] = useState("public");
  const [ifIndex, setIfIndex] = useState("");
  const [status, setStatus] = useState<number | null>(null);
  const [loading, setLoading] = useState(false);
  const { toast } = useToast();

  const handleCheck = async () => {
    if (!host || !ifIndex) return;
    setLoading(true);
    try {
      const s = await getSnmpInterfaceStatus(host, ifIndex, community);
      setStatus(s);
    } catch (err: any) {
      toast({ title: "Erreur", description: err.message || "Requête SNMP échouée", variant: "destructive" });
      setStatus(null);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold">SNMP</h1>
      <div className="flex flex-col sm:flex-row gap-2">
        <Input value={host} onChange={(e) => setHost(e.target.value)} placeholder="Hôte" />
        <Input value={community} onChange={(e) => setCommunity(e.target.value)} placeholder="Communauté" />
        <Input value={ifIndex} onChange={(e) => setIfIndex(e.target.value)} placeholder="ifIndex" />
        <Button onClick={handleCheck} disabled={!host || !ifIndex || loading}>{loading ? "En cours..." : "Vérifier"}</Button>
      </div>
      {status !== null && (
        <Card>
          <CardHeader>
            <CardTitle>Statut</CardTitle>
          </CardHeader>
          <CardContent>
            <p>
              Interface {ifIndex} : {status === 1 ? "up" : status}
            </p>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
