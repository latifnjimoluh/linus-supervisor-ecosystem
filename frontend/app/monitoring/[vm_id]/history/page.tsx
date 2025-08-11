"use client"

import * as React from "react"
import { useParams, useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { formatDate, formatPercent } from "@/lib/utils"
import { fetchVmHistory, MonitoringRecord } from "@/services/monitoring"

export default function VmHistoryPage() {
  const params = useParams()
  const router = useRouter()
  const vmId = params.vm_id as string
  const [records, setRecords] = React.useState<MonitoringRecord[]>([])

  React.useEffect(() => {
    fetchVmHistory(vmId).then(setRecords).catch(console.error)
  }, [vmId])

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Historique de supervision</h1>
        <Button variant="outline" onClick={() => router.back()}>
          Retour
        </Button>
      </div>
      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Métriques collectées</CardTitle>
        </CardHeader>
        <CardContent>
          <table className="w-full text-sm">
            <thead>
              <tr>
                <th className="text-left p-2">Date</th>
                <th className="text-left p-2">CPU</th>
                <th className="text-left p-2">RAM</th>
              </tr>
            </thead>
            <tbody>
              {records.map(rec => {
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
                return (
                  <tr key={rec.id} className="border-t">
                    <td className="p-2">{formatDate(rec.retrieved_at)}</td>
                    <td className="p-2">{formatPercent(cpu)}</td>
                    <td className="p-2">{formatPercent(memPercent)}</td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </div>
  )
}
