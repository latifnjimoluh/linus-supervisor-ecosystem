"use client"

import * as React from "react"
import Link from "next/link"
import { RefreshCw, Eye } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { useToast } from "@/hooks/use-toast"
import { getMonitoringOverview } from "@/services/api"
import { Loader2 } from "lucide-react"

export default function MonitoringPage() {
  const { toast } = useToast()
  const [overview, setOverview] = React.useState<{
    summary: { total: number; active: number; alert: number; unsupervised: number }
    servers: any[]
  } | null>(null)
  const [loading, setLoading] = React.useState(true)

  const fetchData = React.useCallback(() => {
    setLoading(true)
    getMonitoringOverview()
      .then(setOverview)
      .catch(() => {
        toast({
          title: "Erreur",
          description: "Impossible de récupérer les données de monitoring",
          variant: "destructive",
        })
        setOverview(null)
      })
      .finally(() => setLoading(false))
  }, [toast])

  React.useEffect(() => {
    fetchData()
  }, [fetchData])

  if (loading)
    return (
      <div className="flex justify-center p-10">
        <Loader2 className="h-6 w-6 animate-spin" />
      </div>
    )

  if (!overview)
    return <div className="p-10 text-center text-muted-foreground">Aucune donnée</div>

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Supervision des VMs</h1>
        <Button onClick={fetchData} variant="outline" size="sm" className="rounded-xl">
          <RefreshCw className="mr-2 h-4 w-4" /> Actualiser
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">Total VMs</p>
            <p className="text-2xl font-bold">{overview.summary.total}</p>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">Actives</p>
            <p className="text-2xl font-bold text-success">{overview.summary.active}</p>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">Alertes</p>
            <p className="text-2xl font-bold text-destructive">{overview.summary.alert}</p>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <p className="text-sm text-muted-foreground">Non supervisées</p>
            <p className="text-2xl font-bold">{overview.summary.unsupervised}</p>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Serveurs</CardTitle>
        </CardHeader>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nom</TableHead>
                <TableHead>IP</TableHead>
                <TableHead>Statut</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {overview.servers.map((s) => (
                <TableRow key={s.id}>
                  <TableCell className="font-medium">{s.name || s.id}</TableCell>
                  <TableCell>{s.ip}</TableCell>
                  <TableCell className="capitalize">{s.status}</TableCell>
                  <TableCell className="text-right">
                    <Button asChild variant="ghost" size="icon">
                      <Link href={`/monitoring/${encodeURIComponent(s.ip)}`}>
                        <Eye className="h-4 w-4" />
                      </Link>
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
              {overview.servers.length === 0 && (
                <TableRow>
                  <TableCell colSpan={4} className="text-center text-muted-foreground py-8">
                    Aucun serveur
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
