"use client"

import * as React from "react"
import Link from "next/link"
import { Plus, Search, RefreshCw, Server, Activity, AlertTriangle, CheckCircle, XCircle, Eye, BarChart3, Loader2, Copy, Play, Square, Trash2 } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { cn, formatPercent, formatDate } from "@/lib/utils"
import { fetchMonitoringOverview, MonitoringVm } from "@/services/monitoring"
import { startProxmoxVM, stopProxmoxVM, deleteProxmoxVM } from "@/services/vms"
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader,
  AlertDialogTitle, AlertDialogTrigger,
} from "@/components/ui/alert-dialog"
import { useToast } from "@/hooks/use-toast"

const simulateMonitoringAIAnalysis = async (context: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 2000))
  const prompt = `Tu es un assistant de supervision. Analyse ces statistiques et donne une vue d'ensemble ainsi que deux actions prioritaires : ${context}`
  const match = context.match(/Total VMs: (\d+), en marche: (\d+), arrêtées: (\d+), en erreur: (\d+)/)
  const total = match ? parseInt(match[1]) : 0
  const running = match ? parseInt(match[2]) : 0
  const stopped = match ? parseInt(match[3]) : 0
  const error = match ? parseInt(match[4]) : 0
  return `🤖 **Analyse IA de la supervision des VMs**\n\n${total} VMs : ${running} en marche, ${stopped} arrêtées, ${error} en erreur.\n\n**Priorités :**\n- Examiner les ${error} VM(s) en erreur\n- Considérer l'arrêt des VMs inactives (${stopped})\n\n*Prompt utilisé :* ${prompt}`
}

export default function MonitoringPage() {
  const [vms, setVms] = React.useState<MonitoringVm[]>([])
  const [templates, setTemplates] = React.useState<MonitoringVm[]>([])
  const [stats, setStats] = React.useState({ total: 0, running: 0, stopped: 0, error: 0 })
  const [loading, setLoading] = React.useState(true)
  const [searchTerm, setSearchTerm] = React.useState("")
  const [statusFilter, setStatusFilter] = React.useState<string>("all")
  const [actionLoading, setActionLoading] = React.useState<string | null>(null)
  const { toast } = useToast()

  const fetchVMs = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await fetchMonitoringOverview()
      setVms(data.vms)
      setTemplates(data.templates)
      setStats(data.summary)
    } catch (e) {
      console.error("Erreur de récupération du monitoring", e)
    } finally {
      setLoading(false)
    }
  }, [])

  React.useEffect(() => { fetchVMs() }, [fetchVMs])

  const filteredVMs = vms.filter(vm => {
    const matchesSearch = vm.name.toLowerCase().includes(searchTerm.toLowerCase()) || vm.ip.includes(searchTerm)
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

  const handleVMAction = async (vm: MonitoringVm, action: 'start' | 'stop') => {
    setActionLoading(vm.id)
    try {
      if (action === 'start') await startProxmoxVM(Number(vm.id))
      else await stopProxmoxVM(Number(vm.id))
      toast({ title: 'Action', description: `VM ${vm.name} ${action === 'start' ? 'démarrée' : 'arrêtée'} avec succès`, variant: 'success' })
      fetchVMs()
    } catch {
      toast({ title: 'Erreur', description: `Impossible de ${action === 'start' ? 'démarrer' : 'arrêter'} la VM`, variant: 'destructive' })
    } finally {
      setActionLoading(null)
    }
  }

  const handleVMDelete = async (vm: MonitoringVm) => {
    setActionLoading(vm.id)
    try {
      await deleteProxmoxVM({ vm_id: Number(vm.id), instance_id: vm.instance_id || '' })
      toast({ title: 'Suppression', description: `VM ${vm.name} supprimée avec succès`, variant: 'success' })
      fetchVMs()
    } catch {
      toast({ title: 'Erreur', description: "Impossible de supprimer la VM", variant: 'destructive' })
    } finally {
      setActionLoading(null)
    }
  }

  const aiContext = `Total VMs: ${stats.total}, en marche: ${stats.running}, arrêtées: ${stats.stopped}, en erreur: ${stats.error}.`

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl sm:text-4xl font-semibold">Supervision des VMs</h1>
        <div className="flex flex-wrap gap-3">
          <Button onClick={fetchVMs} variant="outline" size="sm" className="rounded-xl whitespace-nowrap">
            <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} />
            <span className="truncate">Actualiser</span>
          </Button>
          <Button asChild className="rounded-xl whitespace-nowrap">
            <Link href="/deploy">
              <Plus className="mr-2 h-4 w-4" />
              <span className="truncate">Créer VM</span>
            </Link>
          </Button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-4">
        <Card className="rounded-2xl overflow-hidden">
          <CardContent className="p-4">
            <div className="flex items-center justify-between min-w-0">
              <div className="min-w-0">
                <p className="text-sm text-muted-foreground truncate">Total VMs</p>
                <p className="text-2xl font-bold">{stats.total}</p>
              </div>
              <Server className="h-8 w-8 text-muted-foreground shrink-0" />
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-2xl overflow-hidden">
          <CardContent className="p-4">
            <div className="flex items-center justify-between min-w-0">
              <div className="min-w-0">
                <p className="text-sm text-muted-foreground truncate">En marche</p>
                <p className="text-2xl font-bold text-success">{stats.running}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-success shrink-0" />
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-2xl overflow-hidden">
          <CardContent className="p-4">
            <div className="flex items-center justify-between min-w-0">
              <div className="min-w-0">
                <p className="text-sm text-muted-foreground truncate">Arrêtées</p>
                <p className="text-2xl font-bold text-warning">{stats.stopped}</p>
              </div>
              <XCircle className="h-8 w-8 text-warning shrink-0" />
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-2xl overflow-hidden">
          <CardContent className="p-4">
            <div className="flex items-center justify-between min-w-0">
              <div className="min-w-0">
                <p className="text-sm text-muted-foreground truncate">En erreur</p>
                <p className="text-2xl font-bold text-destructive">{stats.error}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-destructive shrink-0" />
            </div>
          </CardContent>
        </Card>

        <Card className="rounded-2xl overflow-hidden">
          <CardContent className="p-4">
            <div className="flex items-center justify-between min-w-0">
              <div className="min-w-0">
                <p className="text-sm text-muted-foreground truncate">Templates</p>
                <p className="text-2xl font-bold">{templates.length}</p>
              </div>
              <Copy className="h-8 w-8 text-muted-foreground shrink-0" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-col sm:flex-row gap-4">
        <div className="relative flex-1 min-w-0">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher par nom ou IP..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10 rounded-xl w-full"
          />
        </div>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-full sm:w-48 rounded-xl">
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
        <>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredVMs.map((vm, index) => {
              const memPct = vm.memory_total ? Math.min(100, Math.max(0, (vm.memory_usage / vm.memory_total) * 100)) : 0
              return (
                <motion.div
                  key={vm.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.3, delay: index * 0.1 }}
                >
                  <Card data-vm-card data-status={vm.status} className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40 hover:shadow-lg transition-shadow overflow-hidden">
                    <CardHeader className="pb-3">
                      <div className="flex items-center justify-between gap-2 min-w-0">
                        <CardTitle className="text-lg truncate">{vm.name}</CardTitle>
                        <div className="flex items-center gap-2 flex-shrink-0">
                          {getStatusIcon(vm.status)}
                          <Badge variant={getStatusColor(vm.status)} className="text-xs whitespace-nowrap">
                            {vm.status === "running" ? "En marche" : vm.status === "stopped" ? "Arrêtée" : "Erreur"}
                          </Badge>
                        </div>
                      </div>
                      <CardDescription className="min-w-0">
                        <code className="text-xs bg-muted px-2 py-1 rounded break-all">{vm.ip}</code>
                        <span className="ml-2 text-xs truncate inline-block max-w-[55%] align-bottom">{vm.hostname}</span>
                      </CardDescription>
                    </CardHeader>

                    <CardContent className="space-y-4">
                      {/* CPU */}
                      <div>
                        <div className="flex justify-between text-sm mb-1">
                          <span className="truncate">CPU</span>
                          <span className="truncate">{formatPercent(vm.cpu_usage)}</span>
                        </div>
                        <Progress value={vm.cpu_usage} className="h-2" />
                      </div>

                      {/* RAM */}
                      <div>
                        <div className="flex justify-between text-sm mb-1">
                          <span className="truncate">RAM</span>
                          <span className="truncate">{Math.round(memPct)}%</span>
                        </div>
                        <Progress value={memPct} className="h-2" />
                      </div>

                      {/* Services */}
                      <div className="flex justify-between text-sm">
                        <span className="truncate">Services</span>
                        <span className="truncate">{vm.active_services}/{vm.services_count} actifs</span>
                      </div>

                      {/* Uptime */}
                      <div className="flex justify-between text-sm">
                        <span className="truncate">Uptime</span>
                        <span className="truncate">{vm.uptime}</span>
                      </div>

                      {/* Actions */}
                      <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 pt-2">
                        {vm.status === 'running' ? (
                          <AlertDialog>
                            <AlertDialogTrigger asChild>
                              <Button
                                variant="secondary"
                                size="sm"
                                disabled={actionLoading === vm.id}
                                className="rounded-xl w-full"
                              >
                                {actionLoading === vm.id ? (
                                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                ) : (
                                  <Square className="mr-2 h-4 w-4" />
                                )}
                                <span className="truncate">Arrêter</span>
                              </Button>
                            </AlertDialogTrigger>
                            <AlertDialogContent>
                              <AlertDialogHeader>
                                <AlertDialogTitle>Arrêter la VM</AlertDialogTitle>
                                <AlertDialogDescription>Êtes-vous sûr de vouloir arrêter "{vm.name}" ?</AlertDialogDescription>
                              </AlertDialogHeader>
                              <AlertDialogFooter>
                                <AlertDialogCancel>Annuler</AlertDialogCancel>
                                <AlertDialogAction onClick={() => handleVMAction(vm, 'stop')}>Arrêter</AlertDialogAction>
                              </AlertDialogFooter>
                            </AlertDialogContent>
                          </AlertDialog>
                        ) : (
                          <Button
                            onClick={() => handleVMAction(vm, 'start')}
                            disabled={actionLoading === vm.id}
                            size="sm"
                            className="rounded-xl w-full"
                          >
                            {actionLoading === vm.id ? (
                              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                            ) : (
                              <Play className="mr-2 h-4 w-4" />
                            )}
                            <span className="truncate">Démarrer</span>
                          </Button>
                        )}

                        <Button asChild size="sm" className="rounded-xl w-full">
                          <Link href={`/monitoring/${vm.id}`}>
                            <Eye className="mr-2 h-4 w-4" />
                            <span className="truncate">Détails</span>
                          </Link>
                        </Button>

                        <Button asChild variant="outline" size="sm" className="rounded-xl w-full">
                          <Link href={`/monitoring/${vm.id}/history`}>
                            <BarChart3 className="h-4 w-4" />
                            <span className="sr-only">Historique</span>
                          </Link>
                        </Button>

                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <Button
                              variant="destructive"
                              size="sm"
                              disabled={actionLoading === vm.id}
                              className="rounded-xl w-full"
                            >
                              {actionLoading === vm.id ? (
                                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                              ) : (
                                <Trash2 className="mr-2 h-4 w-4" />
                              )}
                              <span className="truncate">Supprimer</span>
                            </Button>
                          </AlertDialogTrigger>
                          <AlertDialogContent>
                            <AlertDialogHeader>
                              <AlertDialogTitle>Supprimer la VM</AlertDialogTitle>
                              <AlertDialogDescription>Êtes-vous sûr de vouloir supprimer "{vm.name}" ?</AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel>Annuler</AlertDialogCancel>
                              <AlertDialogAction onClick={() => handleVMDelete(vm)}>Supprimer</AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      </div>

                      <div className="text-xs text-muted-foreground pt-2 border-t">
                        <span className="truncate block">
                          Dernière supervision: {formatDate(vm.last_monitoring)}
                        </span>
                      </div>
                    </CardContent>
                  </Card>
                </motion.div>
              )
            })}
          </div>

          {templates.length > 0 && (
            <div className="mt-8 space-y-4">
              <h2 className="text-xl sm:text-2xl font-semibold">Templates</h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {templates.map((tpl, index) => (
                  <motion.div key={tpl.id} initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.3, delay: index * 0.1 }}>
                    <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40 overflow-hidden">
                      <CardHeader className="pb-3">
                        <div className="flex items-center justify-between min-w-0">
                          <CardTitle className="text-lg truncate">{tpl.name}</CardTitle>
                          <Badge variant="outline" className="text-xs whitespace-nowrap">Template</Badge>
                        </div>
                      </CardHeader>
                      <CardContent>
                        <p className="text-sm text-muted-foreground truncate">Non supervisé</p>
                      </CardContent>
                    </Card>
                  </motion.div>
                ))}
              </div>
            </div>
          )}
        </>
      )}

      {filteredVMs.length === 0 && !loading && (
        <div className="text-center py-12">
          <Server className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">Aucune VM trouvée</h3>
          <p className="text-muted-foreground mb-4">
            {searchTerm || statusFilter !== "all" ? "Aucune VM ne correspond à vos critères de recherche." : "Aucune machine virtuelle n'est configurée."}
          </p>
          <Button asChild className="rounded-xl whitespace-nowrap">
            <Link href="/deploy"><Plus className="mr-2 h-4 w-4" />Créer votre première VM</Link>
          </Button>
        </div>
      )}

      <AssistantAIBlock title="Assistant IA de la supervision" context={aiContext} onAnalyze={simulateMonitoringAIAnalysis} className="w-full" />
    </div>
  )
}
