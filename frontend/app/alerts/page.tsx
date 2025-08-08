"use client"

import * as React from "react"
import { RefreshCw, CheckCircle } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { useToast } from "@/hooks/use-toast"
import { listAlerts, updateAlert, AlertItem } from "@/services/api"
import { cn } from "@/lib/utils"

export default function AlertsPage() {
  const [alerts, setAlerts] = React.useState<AlertItem[]>([])
  const [loading, setLoading] = React.useState(true)
  const { toast } = useToast()

  const fetchAlerts = React.useCallback(() => {
    setLoading(true)
    listAlerts()
      .then((data) => setAlerts(data))
      .catch(() => {
        toast({ title: "Erreur", description: "Impossible de charger les alertes", variant: "destructive" })
      })
      .finally(() => setLoading(false))
  }, [toast])

  React.useEffect(() => {
    fetchAlerts()
  }, [fetchAlerts])

  const handleResolve = async (id: number) => {
    try {
      const updated = await updateAlert(id, { status: "resolved" })
      setAlerts(prev => prev.map(a => a.id === id ? updated : a))
      toast({ title: "Alerte mise à jour", description: "Statut mis à jour", variant: "success" })
    } catch (error: any) {
      toast({ title: "Erreur", description: error.response?.data?.message || "Mise à jour échouée", variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold tracking-tight">Alertes</h1>
        <Button onClick={fetchAlerts} variant="outline" className="rounded-xl">
          <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} /> Rafraîchir
        </Button>
      </div>
      <Card className="rounded-2xl shadow-sm">
        <CardHeader>
          <CardTitle>Liste des alertes</CardTitle>
        </CardHeader>
        <CardContent>
          {alerts.length === 0 ? (
            <p className="text-sm text-muted-foreground">Aucune alerte.</p>
          ) : (
            <ul className="space-y-2">
              {alerts.map(alert => (
                <li key={alert.id} className="flex items-center justify-between border rounded-xl p-3">
                  <div>
                    <p className="font-medium">{alert.message || `Alerte #${alert.id}`}</p>
                    <p className="text-xs text-muted-foreground">Statut: {alert.status}</p>
                  </div>
                  {alert.status !== 'resolved' && (
                    <Button size="sm" className="rounded-xl" onClick={() => handleResolve(alert.id)}>
                      <CheckCircle className="h-4 w-4 mr-2" /> Résoudre
                    </Button>
                  )}
                </li>
              ))}
            </ul>
          )}
        </CardContent>
      </Card>
    </div>
  )
}

