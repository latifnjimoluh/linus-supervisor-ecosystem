"use client"

import * as React from "react"
import { listAlerts, ackAlert, getAlert, Alert } from "@/services/alerts"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/dialog"
import { useToast } from "@/hooks/use-toast"

export default function AlertsPage() {
  const [alerts, setAlerts] = React.useState<Alert[]>([])
  const [selected, setSelected] = React.useState<Alert | null>(null)
  const [open, setOpen] = React.useState(false)
  const { toast } = useToast()

  const fetchAlerts = React.useCallback(async () => {
    const res = await listAlerts()
    setAlerts(res.data)
  }, [])

  React.useEffect(() => {
    fetchAlerts()
  }, [fetchAlerts])

  const handleAck = async (id: number) => {
    await ackAlert(id)
    toast({ title: "Alerte acquittée", variant: "success" })
    setOpen(false)
    fetchAlerts()
  }

  const handleView = async (id: number) => {
    const data = await getAlert(id)
    setSelected(data)
    setOpen(true)
  }

  return (
    <div className="p-4">
      <h1 className="mb-4 text-2xl font-semibold">Alertes</h1>
      <table className="min-w-full text-sm">
        <thead>
          <tr className="text-left">
            <th className="py-2">Source</th>
            <th className="py-2">Sévérité</th>
            <th className="py-2">Statut</th>
            <th className="py-2">Date</th>
            <th className="py-2 text-right">Actions</th>
          </tr>
        </thead>
        <tbody>
          {alerts.map((alert) => (
            <tr key={alert.id} className="border-b">
              <td className="py-2">
                {alert.server}
                {alert.service ? ` - ${alert.service}` : ""}
              </td>
              <td className="py-2"><Badge>{alert.severity}</Badge></td>
              <td className="py-2">{alert.status}</td>
              <td className="py-2">
                {new Date(alert.created_at).toLocaleString()}
              </td>
              <td className="py-2 text-right">
                <div className="flex justify-end gap-2">
                  <Button size="sm" variant="outline" onClick={() => handleView(alert.id)}>
                    Voir
                  </Button>
                  <Button size="sm" variant="secondary" onClick={() => handleAck(alert.id)}>
                    Acquitter
                  </Button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="space-y-2">
          {selected && (
            <>
              <DialogHeader>
                <DialogTitle>Alerte #{selected.id}</DialogTitle>
                <DialogDescription>
                  {selected.server}
                  {selected.service ? ` - ${selected.service}` : ""}
                </DialogDescription>
              </DialogHeader>
              <div>
                <span className="font-semibold">Sévérité:&nbsp;</span>
                <Badge>{selected.severity}</Badge>
              </div>
              <div>
                <span className="font-semibold">Statut:&nbsp;</span>
                {selected.status}
              </div>
              <div>
                <span className="font-semibold">Date:&nbsp;</span>
                {new Date(selected.created_at).toLocaleString()}
              </div>
              {selected.description && (
                <div>
                  <span className="font-semibold">Description:&nbsp;</span>
                  {selected.description}
                </div>
              )}
              <Button onClick={() => handleAck(selected.id)}>Acquitter</Button>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}
