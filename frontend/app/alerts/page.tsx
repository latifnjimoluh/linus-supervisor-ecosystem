"use client"

import * as React from "react"
import { listAlerts, markAlert, getAlert, resendAlert, Alert } from "@/services/alerts"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Check } from "lucide-react"
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
  const [filter, setFilter] = React.useState<'all' | 'open' | 'acknowledged'>('open')
  const { toast } = useToast()

  const fetchAlerts = React.useCallback(async () => {
    const params = filter === 'all' ? {} : { status: filter }
    const res = await listAlerts(params)
    setAlerts(res.data)
  }, [filter])

  React.useEffect(() => {
    fetchAlerts()
  }, [fetchAlerts])

  const handleMark = async (id: number) => {
    await markAlert(id)
    toast({ title: "Alerte marquée comme traitée", variant: "success" })
    setOpen(false)
    fetchAlerts()
  }

  const handleView = async (id: number) => {
    const data = await getAlert(id)
    setSelected(data)
    setOpen(true)
  }

  const handleResend = async (id: number) => {
    await resendAlert(id)
    toast({ title: "Notification reprogrammée", variant: "success" })
    fetchAlerts()
  }

  return (
    <div className="p-4">
      <h1 className="mb-4 text-2xl font-semibold">Alertes</h1>
      <div className="mb-4 flex gap-2">
        {[
          { key: 'all', label: 'Toutes' },
          { key: 'open', label: 'Non traitées' },
          { key: 'acknowledged', label: 'Traitées' },
        ].map((f) => (
          <Button
            key={f.key}
            variant={filter === f.key ? 'default' : 'outline'}
            onClick={() => setFilter(f.key as any)}
          >
            {f.label}
          </Button>
        ))}
      </div>
      <table className="min-w-full text-sm">
        <thead>
          <tr className="text-left">
            <th className="py-2">Source</th>
            <th className="py-2">Sévérité</th>
            <th className="py-2">Statut</th>
            <th className="py-2">Acheminement</th>
            <th className="py-2">Date</th>
            <th className="py-2 text-right">Actions</th>
          </tr>
        </thead>
        <tbody>
          {alerts.map((alert) => (
            <tr
              key={alert.id}
              className={`border-b ${alert.status === 'open' ? 'border-l-4 border-l-red-500' : ''}`}
            >
              <td className="py-2">
                {alert.server}
                {alert.service ? ` - ${alert.service}` : ""}
              </td>
              <td className="py-2"><Badge>{alert.severity}</Badge></td>
              <td className="py-2">
                <Badge variant={alert.status === 'open' ? 'destructive' : 'secondary'}>
                  {alert.status === 'open' ? 'Non traitée' : 'Traitée'}
                </Badge>
              </td>
              <td className="py-2">{alert.notification_status || "inconnu"}</td>
              <td className="py-2">
                {new Date(alert.created_at).toLocaleString()}
              </td>
              <td className="py-2 text-right">
                <div className="flex justify-end gap-2">
                  <Button size="sm" variant="outline" onClick={() => handleView(alert.id)}>
                    Voir
                  </Button>
                  {alert.status === 'open' && (
                    <Button size="sm" variant="secondary" onClick={() => handleMark(alert.id)}>
                      <Check className="mr-2 h-4 w-4" />
                      Marquer comme traité
                    </Button>
                  )}
                  {alert.notification_status === "failed" && (
                    <Button size="sm" variant="destructive" onClick={() => handleResend(alert.id)}>
                      Renvoyer
                    </Button>
                  )}
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
                {selected.status === 'open' ? 'Non traitée' : 'Traitée'}
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
              {selected.status === 'open' && (
                <Button onClick={() => handleMark(selected.id)}>
                  <Check className="mr-2 h-4 w-4" /> Marquer comme traité
                </Button>
              )}
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}
