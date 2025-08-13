"use client"

import * as React from "react"
import Link from "next/link"
import { LayoutDashboard, Server, AlertTriangle, Plus, Eye, Code, RefreshCw, Info, XCircle, TrendingUp, TrendingDown, Activity, UserPlus, CheckCircle, Trash2, Rocket } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Progress } from "@/components/ui/progress"
import { cn } from "@/lib/utils"
import { getDashboard, getDashboardInsights, type DashboardData } from "@/services/dashboard"
import { listProxmoxVMs, type ProxmoxVM } from "@/services/vms"

const emptyData: DashboardData = {
  totalVms: 0,
  activeServices: 0,
  alerts: { critical: 0, major: 0, minor: 0 },
  systemHealth: 0,
  networkTraffic: { incoming: 0, outgoing: 0 },
  recentActivity: [],
  lastUpdated: null,
  apiError: false,
  deploymentStats: { total: 0, success: 0, failed: 0, deleted: 0 },
}

const analyzeDashboardAI = async (): Promise<string> => {
  return await getDashboardInsights()
}

export default function DashboardPage() {
  const [data, setData] = React.useState<DashboardData | null>(null)
  const [loading, setLoading] = React.useState(true)
  const [vms, setVms] = React.useState<ProxmoxVM[]>([])
  const [templates, setTemplates] = React.useState<ProxmoxVM[]>([])

  const fetchData = React.useCallback(() => {
    setLoading(true)
    Promise.all([getDashboard(), listProxmoxVMs()])
      .then(([newData, proxmox]) => {
        setData({ ...newData, apiError: false })
        setVms(proxmox.vms)
        setTemplates(proxmox.templates)
      })
      .catch(() => {
        setData({ ...emptyData, apiError: true })
        setVms([])
        setTemplates([])
      })
      .finally(() => setLoading(false))
  }, [])

  React.useEffect(() => {
    fetchData() // Initial fetch only
  }, [fetchData])

  const getAlertVariant = (count: number, type: 'critical' | 'major' | 'minor') => {
    if (type === 'critical' && count > 0) return "destructive"
    if (type === 'major' && count > 2) return "warning"
    if (type === 'minor' && count > 5) return "info"
    return "success"
  }

  const getActivityIcon = (type: string) => {
    switch (type) {
      case "deployment":
      case "vm_created":
        return <Plus className="h-4 w-4 text-success" />
      case "deletion":
      case "vm_stopped":
        return <XCircle className="h-4 w-4 text-warning" />
      case "restart":
      case "alert_resolved":
        return <RefreshCw className="h-4 w-4 text-info" />
      case "script_executed":
        return <Code className="h-4 w-4 text-primary" />
      case "user_creation":
        return <UserPlus className="h-4 w-4 text-primary" />
      case "role_change":
        return <Info className="h-4 w-4 text-warning" />
      default:
        return <Activity className="h-4 w-4" />
    }
  }

  const aiContext = data ?
    `VMs: ${data.totalVms}, Services actifs: ${data.activeServices}, Alertes critiques: ${data.alerts.critical}, majeures: ${data.alerts.major}, mineures: ${data.alerts.minor}, Santé système: ${data.systemHealth}%, Déploiements: ${data.deploymentStats.total}, Succès: ${data.deploymentStats.success}, Échecs: ${data.deploymentStats.failed}, Suppressions: ${data.deploymentStats.deleted}.` :
    "Données du tableau de bord non disponibles."

  const formattedLastUpdated = React.useMemo(() => {
    if (!data?.lastUpdated) return "—"
    return new Date(data.lastUpdated).toLocaleString(undefined, {
      day: "numeric",
      month: "long",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
      hour12: false,
    })
  }, [data?.lastUpdated])

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Tableau de bord général</h1>
        <Button onClick={fetchData} variant="outline" size="sm" className="rounded-xl">
          <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} />
          Actualiser
        </Button>
      </div>

      {data?.apiError && (
        <Alert variant="destructive" className="rounded-2xl">
          <XCircle className="h-4 w-4" />
          <AlertTitle>Erreur de l'API</AlertTitle>
          <AlertDescription>
            Impossible de récupérer les données du tableau de bord. Veuillez réessayer.
            <Button variant="link" onClick={fetchData} className="ml-2 p-0 h-auto">
              <RefreshCw className="mr-1 h-4 w-4" /> Rafraîchir
            </Button>
          </AlertDescription>
        </Alert>
      )}

      {/* Main Stats Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {/* Widget: Nombre de VMs */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">VMs Actives</CardTitle>
            <Server className="h-5 w-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`totalVms-${data?.totalVms}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold"
              >
                {data?.totalVms}
              </motion.div>
            )}
            <p className="text-xs text-muted-foreground flex items-center mt-1">
              <TrendingUp className="h-3 w-3 mr-1 text-success" />
              +2 cette semaine
            </p>
          </CardContent>
        </Card>

        {/* Widget: Services actifs */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">Services</CardTitle>
            <LayoutDashboard className="h-5 w-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`activeServices-${data?.activeServices}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold"
              >
                {data?.activeServices}
              </motion.div>
            )}
            <p className="text-xs text-muted-foreground flex items-center mt-1">
              <Activity className="h-3 w-3 mr-1 text-info" />
              Fonctionnels
            </p>
          </CardContent>
        </Card>

        {/* Widget: Alertes */}
        <Card className={cn(
          "rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40",
          data && data.alerts.critical > 0 && "border-destructive",
          data && data.alerts.major > 2 && data.alerts.critical === 0 && "border-warning"
        )}>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">Alertes</CardTitle>
            <AlertTriangle className={cn(
              "h-5 w-5",
              data && data.alerts.critical > 0 && "text-destructive",
              data && data.alerts.major > 2 && data.alerts.critical === 0 && "text-warning",
              (!data || (data.alerts.critical === 0 && data.alerts.major <= 2)) && "text-success"
            )} />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`alerts-${data?.alerts.critical}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold"
              >
                {data?.alerts.critical || 0}
              </motion.div>
            )}
            <p className="text-xs text-muted-foreground">Critiques</p>
            <div className="flex gap-1 mt-2 text-xs">
              <Badge variant={getAlertVariant(data?.alerts.major || 0, 'major')} className="text-xs">
                {data?.alerts.major || 0} maj.
              </Badge>
              <Badge variant={getAlertVariant(data?.alerts.minor || 0, 'minor')} className="text-xs">
                {data?.alerts.minor || 0} min.
              </Badge>
            </div>
          </CardContent>
        </Card>

        {/* Widget: System Health */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">Santé Système</CardTitle>
            <Activity className="h-5 w-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`systemHealth-${data?.systemHealth}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold"
              >
                {data?.systemHealth}%
              </motion.div>
            )}
            <Progress 
              value={data?.systemHealth || 0} 
              className="mt-2 h-2" 
            />
            <p className="text-xs text-muted-foreground mt-1">
              {(data?.systemHealth || 0) > 90 ? "Excellent" : 
               (data?.systemHealth || 0) > 75 ? "Bon" : "À surveiller"}
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Deployment Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">Déploiements</CardTitle>
            <Rocket className="h-5 w-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`deploy-total-${data?.deploymentStats.total}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold"
              >
                {data?.deploymentStats.total}
              </motion.div>
            )}
          </CardContent>
        </Card>

        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">Succès</CardTitle>
            <CheckCircle className="h-5 w-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`deploy-success-${data?.deploymentStats.success}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold text-success"
              >
                {data?.deploymentStats.success}
              </motion.div>
            )}
          </CardContent>
        </Card>

        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">Échecs</CardTitle>
            <XCircle className="h-5 w-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`deploy-failed-${data?.deploymentStats.failed}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold text-destructive"
              >
                {data?.deploymentStats.failed}
              </motion.div>
            )}
          </CardContent>
        </Card>

        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-semibold">Supprimées</CardTitle>
            <Trash2 className="h-5 w-5 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            {loading ? (
              <div className="h-8 w-1/2 bg-muted animate-pulse rounded-md" />
            ) : (
              <motion.div
                key={`deploy-deleted-${data?.deploymentStats.deleted}`}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.3 }}
                className="text-4xl font-bold"
              >
                {data?.deploymentStats.deleted}
              </motion.div>
            )}
          </CardContent>
        </Card>
      </div>

      <div className="grid md:grid-cols-2 gap-6">
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle>Machines virtuelles</CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <p className="text-sm text-muted-foreground">Chargement...</p>
            ) : vms.length ? (
              <ul className="space-y-2">
                {vms.map((vm) => (
                  <li key={vm.vmid} className="p-2 border rounded-lg">
                    {vm.name}
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-sm text-muted-foreground">Aucune VM</p>
            )}
          </CardContent>
        </Card>
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle>Templates</CardTitle>
          </CardHeader>
          <CardContent>
            {loading ? (
              <p className="text-sm text-muted-foreground">Chargement...</p>
            ) : templates.length ? (
              <ul className="space-y-2">
                {templates.map((tpl) => (
                  <li key={tpl.vmid} className="p-2 border rounded-lg">
                    {tpl.name}
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-sm text-muted-foreground">Aucun template</p>
            )}
          </CardContent>
        </Card>
      </div>

      {/* Actions and AI Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Quick Actions */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg">Actions rapides</CardTitle>
            <CardDescription>Accès direct aux fonctionnalités principales</CardDescription>
          </CardHeader>
          <CardContent className="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <Button asChild className="rounded-xl">
              <Link href="/deploy">
                <Plus className="mr-2 h-4 w-4" /> Créer VM
              </Link>
            </Button>
            <Button asChild variant="secondary" className="rounded-xl">
              <Link href="/monitoring">
                <Eye className="mr-2 h-4 w-4" /> Superviser
              </Link>
            </Button>
            <Button asChild variant="secondary" className="rounded-xl">
              <Link href="/templates">
                <Code className="mr-2 h-4 w-4" /> Scripts
              </Link>
            </Button>
          </CardContent>
        </Card>

        {/* Recent Activity */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg">Activité récente</CardTitle>
            <CardDescription>Dernières actions sur la plateforme</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {data?.recentActivity.map((activity) => (
                <div key={activity.id} className="flex items-start gap-3 text-sm">
                  {getActivityIcon(activity.type)}
                  <div className="flex-1">
                    <p className="font-medium">{activity.message}</p>
                    <p className="text-xs text-muted-foreground">{new Date(activity.timestamp).toLocaleString('fr-FR')}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* AI Assistant Block */}
      <AssistantAIBlock
        title="Assistant IA du tableau de bord"
        context={aiContext}
        onAnalyze={() => analyzeDashboardAI()}
        className="w-full"
      />

      <div className="text-right text-sm text-muted-foreground">
        Dernière mise à jour: {formattedLastUpdated}
        {loading && <span className="ml-2 animate-pulse">• Actualisation...</span>}
      </div>
    </div>
  )
}
