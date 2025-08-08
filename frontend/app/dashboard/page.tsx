"use client"

import * as React from "react"
import { RefreshCw } from 'lucide-react'

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { getDashboardSummary, getDashboardServers } from "@/services/api"

interface DashboardSummary {
  totalServers: number
  totalServices: number
  serversInAlert: number
  supervisedPercentage: number
}

export default function DashboardPage() {
  const [summary, setSummary] = React.useState<DashboardSummary | null>(null)
  const [servers, setServers] = React.useState<any[]>([])
  const [loading, setLoading] = React.useState(true)

  const fetchData = React.useCallback(async () => {
    setLoading(true)
    try {
      const [s, sv] = await Promise.all([getDashboardSummary(), getDashboardServers()])
      setSummary(s)
      setServers(sv)
    } catch (e) {
      console.error(e)
    } finally {
      setLoading(false)
    }
  }, [])

  React.useEffect(() => {
    fetchData()
  }, [fetchData])

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Tableau de bord</h1>
        <Button onClick={fetchData} variant="outline" size="sm" className="rounded-xl">
          <RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
          Actualiser
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">Serveurs</p>
            <p className="text-2xl font-bold">{summary?.totalServers ?? 0}</p>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">Services</p>
            <p className="text-2xl font-bold">{summary?.totalServices ?? 0}</p>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">Serveurs en alerte</p>
            <p className="text-2xl font-bold text-destructive">{summary?.serversInAlert ?? 0}</p>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">% supervisés</p>
            <p className="text-2xl font-bold">{summary?.supervisedPercentage ?? 0}%</p>
          </CardContent>
        </Card>
      </div>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Serveurs</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {servers.map((s) => (
            <div key={s.id} className="flex justify-between items-center">
              <div>
                <p className="font-semibold">{s.name} ({s.ip})</p>
                <p className="text-sm text-muted-foreground">{s.zone}</p>
              </div>
              <Badge variant={s.status === "active" ? "success" : s.status === "alert" ? "destructive" : "secondary"}>
                {s.status}
              </Badge>
            </div>
          ))}
          {!loading && servers.length === 0 && (
            <p className="text-muted-foreground">Aucun serveur trouvé.</p>
          )}
        </CardContent>
      </Card>
    </div>
  )
}

