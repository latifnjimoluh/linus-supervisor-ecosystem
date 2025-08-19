"use client"

import * as React from "react"
import { useParams } from "next/navigation"
import { getAlert, markAlert, Alert } from "@/services/alerts"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Check } from "lucide-react"

export default function AlertDetailPage() {
  const params = useParams<{ id: string }>()
  const [alert, setAlert] = React.useState<Alert | null>(null)

  const fetchAlert = React.useCallback(async () => {
    if (!params?.id) return
    const data = await getAlert(params.id)
    setAlert(data)
  }, [params])

  React.useEffect(() => {
    fetchAlert()
  }, [fetchAlert])

  const handleMark = async () => {
    if (!alert) return
    await markAlert(alert.id)
    fetchAlert()
  }

  if (!alert) {
    return <div className="p-4">Chargement...</div>
  }

  return (
    <div className="p-4 space-y-2">
      <h1 className="text-2xl font-semibold">Alerte #{alert.id}</h1>
      <div>
        <span className="font-semibold">Source:&nbsp;</span>
        {alert.server}
        {alert.service ? ` - ${alert.service}` : ""}
      </div>
      <div>
        <span className="font-semibold">Sévérité:&nbsp;</span>
        <Badge>{alert.severity}</Badge>
      </div>
      <div>
        <span className="font-semibold">Statut:&nbsp;</span>
        {alert.status === 'open' ? 'Non traitée' : 'Traitée'}
      </div>
      <div>
        <span className="font-semibold">Date:&nbsp;</span>
        {new Date(alert.created_at).toLocaleString()}
      </div>
      {alert.description && (
        <div>
          <span className="font-semibold">Description:&nbsp;</span>
          {alert.description}
        </div>
      )}
      {alert.status === 'open' && (
        <Button onClick={handleMark}>
          <Check className="mr-2 h-4 w-4" /> Marquer comme traité
        </Button>
      )}
    </div>
  )
}
