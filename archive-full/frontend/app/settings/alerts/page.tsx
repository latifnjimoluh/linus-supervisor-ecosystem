"use client"

import * as React from "react"
import { AlertTriangle } from "lucide-react"

import { BackButton } from "@/components/back-button"
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import { useToast } from "@/hooks/use-toast"
import { useAlertThresholds } from "@/hooks/use-alert-thresholds"

export default function AlertSettingsPage() {
  const { cpu, ram, save } = useAlertThresholds()
  const [localCpu, setLocalCpu] = React.useState(cpu)
  const [localRam, setLocalRam] = React.useState(ram)
  const { toast } = useToast()

  React.useEffect(() => {
    setLocalCpu(cpu)
    setLocalRam(ram)
  }, [cpu, ram])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      await save(localCpu, localRam)
      toast({ title: "Modification bien effectuée", variant: "success" })
    } catch {
      toast({ title: "Erreur lors de la modification", variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href="/settings" label="Retour" />
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Seuils d'alertes</h1>
          <p className="text-muted-foreground">Définissez les seuils CPU et RAM pour les notifications.</p>
        </div>
      </div>

      <Card className="max-w-md">
        <CardHeader>
          <div className="flex items-center gap-2">
            <AlertTriangle className="h-5 w-5 text-primary" />
            <div>
              <CardTitle>Mode test</CardTitle>
              <CardDescription>Valeur par défaut : 10%. Ajustez pour la production.</CardDescription>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="cpu">Seuil CPU (%)</Label>
              <Input id="cpu" type="number" min={0} max={100} value={localCpu} onChange={(e)=>setLocalCpu(Number(e.target.value))} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="ram">Seuil RAM (%)</Label>
              <Input id="ram" type="number" min={0} max={100} value={localRam} onChange={(e)=>setLocalRam(Number(e.target.value))} />
            </div>
            <Button type="submit" className="w-full">Enregistrer</Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
