"use client"

import * as React from "react"
import Link from "next/link"
import { Plus, Search, Filter, RefreshCw, Server, Activity, AlertTriangle, CheckCircle, XCircle, Eye, BarChart3, Loader2 } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { cn, formatPercent } from "@/lib/utils"
import { fetchMonitoringOverview } from "@/services/monitoring"

interface VM {
  id: string
  name: string
  ip: string
  status: "running" | "stopped" | "error"
  os: string
  cpu_usage: number
  memory_usage: number
  memory_total: number
  disk_usage: number
  uptime: string
  services_count: number
  active_services: number
  last_monitoring: string | null
}

export default function MonitoringPage() {
  const [vms, setVms] = React.useState<VM[]>([])
  const [stats, setStats] = React.useState({ total: 0, running: 0, stopped: 0, error: 0 })
  const [loading, setLoading] = React.useState(true)
  const [searchTerm, setSearchTerm] = React.useState("")
  const [statusFilter, setStatusFilter] = React.useState<string>("all")

  const fetchVMs = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await fetchMonitoringOverview()
      setVms(data.vms)
      setStats(data.summary)
    } catch (e) {
      console.error("Erreur de récupération du monitoring", e)
    } finally {
      setLoading(false)
    }
  }, [])

  React.useEffect(() => {
    fetchVMs()
    const interval = setInterval(fetchVMs, 30000) // Refresh every 30 seconds
    return () => clearInterval(interval)
  }, [fetchVMs])

  const filteredVMs = vms.filter(vm => {
    const matchesSearch = vm.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         vm.ip.includes(searchTerm)
    const matchesStatus = statusFilter === "all" || vm.status === statusFilter
    return matchesSearch && matchesStatus
  })

  const getStatusColor = (status: string) => {
    switch (status) {
      case "running": return "success"
      case "stopped": return "warning"
      case "error": return "destructive"
      default: return "default"
    }
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "running": return <CheckCircle className="h-4 w-4 text-success" />
      case "stopped": return <XCircle className="h-4 w-4 text-warning" />
      case "error": return <AlertTriangle className="h-4 w-4 text-destructive" />
      default: return <Activity className="h-4 w-4" />
    }
  }

  // stats are provided by the backend in the summary response

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Supervision des VMs</h1>
        <div className="flex gap-3">
          <Button onClick={fetchVMs} variant="outline" size="sm" className="rounded-xl">
            <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} />
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

      {/* Stats Cards */}
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
                <p className="text-sm text-muted-foreground">En marche</p>
                <p className="text-2xl font-bold text-success">{stats.running}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-success" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Arrêtées</p>
                <p className="text-2xl font-bold text-warning">{stats.stopped}</p>
              </div>
              <XCircle className="h-8 w-8 text-warning" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">En erreur</p>
                <p className="text-2xl font-bold text-destructive">{stats.error}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-destructive" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher par nom ou IP..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10 rounded-xl"
          />
        </div>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Filtrer par statut" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les statuts</SelectItem>
            <SelectItem value="running">En marche</SelectItem>
            <SelectItem value="stopped">Arrêtées</SelectItem>
            <SelectItem value="error">En erreur</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* VMs Grid */}
      {loading ? (
        <div className="flex items-center justify-center py-12">
          <Loader2 className="h-8 w-8 animate-spin" />
          <span className="ml-2">Chargement des VMs...</span>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredVMs.map((vm, index) => (
            <motion.div
              key={vm.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.3, delay: index * 0.1 }}
            >
              <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40 hover:shadow-lg transition-shadow">
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <CardTitle className="text-lg">{vm.name}</CardTitle>
                    <div className="flex items-center gap-2">
                      {getStatusIcon(vm.status)}
                      <Badge variant={getStatusColor(vm.status)} className="text-xs">
                        {vm.status === "running" ? "En marche" : 
                         vm.status === "stopped" ? "Arrêtée" : "Erreur"}
                      </Badge>
                    </div>
                  </div>
                  <CardDescription>
                    <code className="text-xs bg-muted px-2 py-1 rounded">{vm.ip}</code>
                    <span className="ml-2 text-xs">{vm.os}</span>
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* CPU Usage */}
                  <div>
                    <div className="flex justify-between text-sm mb-1">
                      <span>CPU</span>
                      <span>{formatPercent(vm.cpu_usage)}</span>
                    </div>
                    <Progress value={vm.cpu_usage} className="h-2" />
                  </div>

                  {/* Memory Usage */}
                  <div>
                    <div className="flex justify-between text-sm mb-1">
                      <span>RAM</span>
                      <span>{Math.round((vm.memory_usage / vm.memory_total) * 100)}%</span>
                    </div>
                    <Progress value={(vm.memory_usage / vm.memory_total) * 100} className="h-2" />
                  </div>

                  {/* Services */}
                  <div className="flex justify-between text-sm">
                    <span>Services</span>
                    <span>{vm.active_services}/{vm.services_count} actifs</span>
                  </div>

                  {/* Uptime */}
                  <div className="flex justify-between text-sm">
                    <span>Uptime</span>
                    <span>{vm.uptime}</span>
                  </div>

                  {/* Actions */}
                  <div className="flex gap-2 pt-2">
                    <Button asChild size="sm" className="flex-1 rounded-xl">
                      <Link href={`/monitoring/${vm.id}`}>
                        <Eye className="mr-2 h-4 w-4" />
                        Détails
                      </Link>
                    </Button>
                    <Button asChild variant="outline" size="sm" className="rounded-xl">
                      <Link href={`/monitoring/${vm.id}/history`}>
                        <BarChart3 className="h-4 w-4" />
                      </Link>
                    </Button>
                  </div>

                  <div className="text-xs text-muted-foreground pt-2 border-t">
                    Dernière supervision: {vm.last_monitoring}
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          ))}
        </div>
      )}

      {filteredVMs.length === 0 && !loading && (
        <div className="text-center py-12">
          <Server className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">Aucune VM trouvée</h3>
          <p className="text-muted-foreground mb-4">
            {searchTerm || statusFilter !== "all" 
              ? "Aucune VM ne correspond à vos critères de recherche."
              : "Aucune machine virtuelle n'est configurée."}
          </p>
          <Button asChild className="rounded-xl">
            <Link href="/deploy">
              <Plus className="mr-2 h-4 w-4" />
              Créer votre première VM
            </Link>
          </Button>
        </div>
      )}
    </div>
  )
}
