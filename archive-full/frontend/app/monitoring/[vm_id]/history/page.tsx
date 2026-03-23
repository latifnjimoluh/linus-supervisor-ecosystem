"use client"

import * as React from "react"
import { useParams } from "next/navigation"
import { Badge } from "@/components/ui/badge"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { formatDate, formatPercent } from "@/lib/utils"
import { fetchVmHistory, MonitoringRecord } from "@/services/monitoring"
import { BackButton } from "@/components/back-button"

export default function VmHistoryPage() {
  const params = useParams()
  const vmId = params.vm_id as string
  const [records, setRecords] = React.useState<MonitoringRecord[]>([])

  React.useEffect(() => {
    fetchVmHistory(vmId).then(setRecords).catch(console.error)
  }, [vmId])

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href={`/monitoring/${vmId}`} />
        <h1 className="text-2xl font-semibold">Historique de supervision</h1>
      </div>
      {records.map((rec) => {
        const sys = rec.system_status || {}
        let cpu = sys.cpu_usage ?? sys.cpu?.percent
        if (cpu == null && Array.isArray(sys.top_processes)) {
          cpu = sys.top_processes.reduce(
            (sum: number, p: any) => sum + Number(p.cpu || 0),
            0
          )
        }
        cpu = typeof cpu === "number" ? (cpu <= 1 ? cpu * 100 : cpu) : 0
        const mem = sys.memory || {}
        const total = mem.total_kb || mem.total || 0
        const used = total - (mem.available_kb || mem.free_kb || 0)
        const memPercent = total ? (used / total) * 100 : 0
        const errors = Array.isArray(rec.logs_status?.errors)
          ? rec.logs_status.errors
          : Array.isArray(rec.logs_status?.logs)
            ? rec.logs_status.logs
            : []
        const events = Array.isArray(rec.logs_status?.system_events)
          ? rec.logs_status.system_events
          : []
        const logs = [...errors, ...events].join("\n") || "Aucun log disponible"
        const state = rec.services_status?.state
        let variant: any = "secondary"
        let label = state
        switch (state) {
          case "running":
          case "success":
          case "ok":
            variant = "success"
            label = "En marche"
            break
          case "stopped":
            variant = "warning"
            label = "Arrêtée"
            break
          case "error":
          case "failed":
            variant = "destructive"
            label = "Erreur"
            break
          case "destroyed":
            variant = "secondary"
            label = "Détruite"
            break
          default:
            variant = "secondary"
        }

        return (
          <Card key={rec.id} className="rounded-2xl">
            <CardHeader className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
              <CardTitle className="text-lg font-semibold">
                {formatDate(rec.retrieved_at)}
              </CardTitle>
              {state && (
                <Badge variant={variant} className="text-xs">
                  {label}
                </Badge>
              )}
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                <div className="bg-muted rounded-xl p-4 space-y-2">
                  <h3 className="text-sm font-medium">Informations système</h3>
                  <div className="text-xs sm:text-sm font-mono whitespace-pre-wrap break-words break-all">
                    CPU : {formatPercent(cpu)}
                    {"\n"}
                    RAM : {formatPercent(memPercent)}
                  </div>
                </div>
                <div className="bg-muted/50 rounded-xl p-4 space-y-2">
                  <h3 className="text-sm font-medium">Logs récents</h3>
                  <pre className="text-xs sm:text-sm font-mono whitespace-pre-wrap break-words break-all max-h-48 overflow-y-auto">
                    {logs}
                  </pre>
                </div>
              </div>
            </CardContent>
          </Card>
        )
      })}
    </div>
  )
}
