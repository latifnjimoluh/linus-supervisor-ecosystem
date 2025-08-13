"use client"

import * as React from "react"
import Link from "next/link"
import { listAlerts, ackAlert, Alert } from "@/services/alerts"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"

export default function AlertsPage() {
  const [alerts, setAlerts] = React.useState<Alert[]>([])

  const fetchAlerts = React.useCallback(async () => {
    const res = await listAlerts()
    setAlerts(res.data)
  }, [])

  React.useEffect(() => {
    fetchAlerts()
  }, [fetchAlerts])

  const handleAck = async (id: number) => {
    await ackAlert(id)
    fetchAlerts()
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
            <th className="py-2" />
          </tr>
        </thead>
        <tbody>
          {alerts.map((alert) => (
            <tr key={alert.id} className="border-b">
              <td className="py-2">
                <Link href={`/alerts/${alert.id}`} className="hover:underline">
                  {alert.server}
                  {alert.service ? ` - ${alert.service}` : ""}
                </Link>
              </td>
              <td className="py-2"><Badge>{alert.severity}</Badge></td>
              <td className="py-2">{alert.status}</td>
              <td className="py-2">
                {new Date(alert.created_at).toLocaleString()}
              </td>
              <td className="py-2 text-right">
                <Button size="sm" variant="secondary" onClick={() => handleAck(alert.id)}>
                  Acquitter
                </Button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
