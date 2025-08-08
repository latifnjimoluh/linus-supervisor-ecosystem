"use client"

import * as React from "react"
import { Bell, CheckCircle2 } from "lucide-react"

import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/components/ui/table"
import { Button } from "@/components/ui/button"
import { useToast } from "@/hooks/use-toast"
import { getAlerts, updateAlert } from "@/services/api"

interface AlertItem {
  id: number
  server: string
  service: string
  severity: string
  status: string
  description: string
  started_at: string
}

export default function AlertsPage() {
  const [alerts, setAlerts] = React.useState<AlertItem[]>([])
  const [loading, setLoading] = React.useState(true)
  const { toast } = useToast()

  const fetchAlerts = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await getAlerts()
      setAlerts(data.data || data || [])
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    } finally {
      setLoading(false)
    }
  }, [toast])

  React.useEffect(() => {
    fetchAlerts()
  }, [fetchAlerts])

  const handleResolve = async (id: number) => {
    try {
      await updateAlert(id, { status: "resolved" })
      setAlerts(prev => prev.map(a => (a.id === id ? { ...a, status: "resolved" } : a)))
      toast({ title: "Alerte résolue", variant: "success" })
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <Bell className="h-8 w-8 text-primary" />
        <h1 className="text-3xl font-bold">Alertes</h1>
      </div>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Liste des alertes</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Serveur</TableHead>
                <TableHead>Service</TableHead>
                <TableHead>Gravité</TableHead>
                <TableHead>Statut</TableHead>
                <TableHead>Description</TableHead>
                <TableHead className="w-24" />
              </TableRow>
            </TableHeader>
            <TableBody>
              {alerts.map((alert) => (
                <TableRow key={alert.id}>
                  <TableCell>{alert.server}</TableCell>
                  <TableCell>{alert.service}</TableCell>
                  <TableCell>{alert.severity}</TableCell>
                  <TableCell>{alert.status}</TableCell>
                  <TableCell>{alert.description}</TableCell>
                  <TableCell className="text-right">
                    {alert.status !== "resolved" && (
                      <Button variant="ghost" size="icon" onClick={() => handleResolve(alert.id)}>
                        <CheckCircle2 className="h-4 w-4" />
                      </Button>
                    )}
                  </TableCell>
                </TableRow>
              ))}
              {!alerts.length && !loading && (
                <TableRow>
                  <TableCell colSpan={6} className="text-center">
                    Aucune alerte
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}

