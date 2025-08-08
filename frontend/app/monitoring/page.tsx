"use client"

import * as React from "react"
import Link from "next/link"
import { RefreshCw, Plus, Server, CheckCircle, AlertTriangle, XCircle } from 'lucide-react'

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { getMonitoringOverview, MonitoringServer } from "@/services/api"

interface MonitoringOverview {
  summary: {
    total: number
    active: number
    alert: number
    unsupervised: number
  }
  servers: MonitoringServer[]
}

export default function MonitoringPage() {
  const [data, setData] = React.useState<MonitoringOverview | null>(null)
  const [loading, setLoading] = React.useState(true)

  const fetchData = React.useCallback(async () => {
    setLoading(true)
    try {
      const res = await getMonitoringOverview()
      setData(res)
    } catch (e) {
      console.error(e)
    } finally {
      setLoading(false)
    }
  }, [])

  React.useEffect(() => {
    fetchData()
  }, [fetchData])

  const stats = data?.summary || { total: 0, active: 0, alert: 0, unsupervised: 0 }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Supervision des VMs</h1>
        <div className="flex gap-3">
          <Button onClick={fetchData} variant="outline" size="sm" className="rounded-xl">
            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
            Actualiser
          </Button>
          <Button asChild className="rounded-xl">
            <Link href="/deploy">
              <Plus className="mr-2 h-4 w-4" />
              Créer VM
            </Link>
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Total VMs</p>
                <p className="text-2xl font-bold">{stats.total}</p>
              </div>
              <Server className="h-8 w-8 text-muted-foreground" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Actives</p>
                <p className="text-2xl font-bold text-success">{stats.active}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-success" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Alertes</p>
                <p className="text-2xl font-bold text-destructive">{stats.alert}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-destructive" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Non supervisées</p>
                <p className="text-2xl font-bold text-warning">{stats.unsupervised}</p>
              </div>
              <XCircle className="h-8 w-8 text-warning" />
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-4">
        {data?.servers?.map((server) => (
          <Card key={server.id} className="rounded-2xl">
            <CardContent className="p-4 flex justify-between items-center">
              <div>
                <p className="font-semibold">{server.name} ({server.ip})</p>
                <p className="text-sm text-muted-foreground">{server.zone}</p>
              </div>
              <Badge variant={server.status === "active" ? "success" : server.status === "alert" ? "destructive" : "secondary"}>
                {server.status}
              </Badge>
            </CardContent>
          </Card>
        ))}
        {!loading && data?.servers?.length === 0 && (
          <p className="text-center text-muted-foreground">Aucun serveur supervisé.</p>
        )}
      </div>
    </div>
  )
}

