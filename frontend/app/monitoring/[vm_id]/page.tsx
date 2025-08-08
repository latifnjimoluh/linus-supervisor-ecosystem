"use client"

import * as React from "react"
import { useParams } from "next/navigation"
import { BackButton } from "@/components/back-button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { useToast } from "@/hooks/use-toast"
import { listMonitoringRecords } from "@/services/api"
import { Loader2 } from "lucide-react"

export default function MonitoringDetailsPage() {
  const params = useParams()
  const vmIp = decodeURIComponent(params.vm_id as string)
  const { toast } = useToast()
  const [record, setRecord] = React.useState<any | null>(null)
  const [loading, setLoading] = React.useState(true)

  React.useEffect(() => {
    listMonitoringRecords({ vm_ip: vmIp, limit: 1 })
      .then((res) => setRecord(res.data[0]))
      .catch(() => {
        toast({
          title: "Erreur",
          description: "Impossible de charger le monitoring",
          variant: "destructive",
        })
      })
      .finally(() => setLoading(false))
  }, [vmIp, toast])

  if (loading)
    return (
      <div className="flex justify-center p-10">
        <Loader2 className="h-6 w-6 animate-spin" />
      </div>
    )

  if (!record)
    return <div className="p-10 text-center text-muted-foreground">Aucune donnée</div>

  return (
    <div className="space-y-6">
      <BackButton href="/monitoring" label="Retour" />
      <Card>
        <CardHeader>
          <CardTitle>Détails Monitoring – {record.vm_ip}</CardTitle>
        </CardHeader>
        <CardContent>
          <pre className="text-sm overflow-auto">
            {JSON.stringify(record, null, 2)}
          </pre>
        </CardContent>
      </Card>
    </div>
  )
}
