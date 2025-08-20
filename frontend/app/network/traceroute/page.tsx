"use client";

import { useState } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { runTraceroute } from "@/services/network";
import { useToast } from "@/hooks/use-toast";

export default function TraceroutePage() {
  const [target, setTarget] = useState("");
  const [output, setOutput] = useState("");
  const [loading, setLoading] = useState(false);
  const { toast } = useToast();

  const handleRun = async () => {
    if (!target) return;
    setLoading(true);
    try {
      const res = await runTraceroute(target);
      setOutput(res.output);
    } catch (err: any) {
      toast({ title: "Erreur", description: err.message || "Traceroute échoué", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-semibold">Traceroute</h1>
      <div className="flex flex-col sm:flex-row gap-2">
        <Input value={target} onChange={(e) => setTarget(e.target.value)} placeholder="Cible (ex: 8.8.8.8)" />
        <Button onClick={handleRun} disabled={!target || loading}>{loading ? "En cours..." : "Exécuter"}</Button>
      </div>
      {output && (
        <Card>
          <CardHeader>
            <CardTitle>Résultat</CardTitle>
          </CardHeader>
          <CardContent>
            <pre className="whitespace-pre-wrap text-sm">{output}</pre>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
