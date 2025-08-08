"use client"

import * as React from "react"
import Link from "next/link"
import { LayoutDashboard, Server, AlertTriangle, Plus, Eye, Code, RefreshCw, Info, XCircle, TrendingUp, TrendingDown, Activity } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Progress } from "@/components/ui/progress"
import { cn } from "@/lib/utils"

interface DashboardData {
  totalVms: number
  activeServices: number
  alerts: {
    critical: number
    major: number
    minor: number
  }
  systemHealth: number
  networkTraffic: {
    incoming: number
    outgoing: number
  }
  recentActivity: Array<{
    id: string
    type: "vm_created" | "vm_stopped" | "alert_resolved" | "script_executed"
    message: string
    timestamp: string
  }>
  lastUpdated: string
  apiError: boolean
}

const mockDashboardData = (): DashboardData => {
  const now = new Date()
  const randomVms = Math.floor(Math.random() * 20) + 15
  const randomServices = Math.floor(Math.random() * 50) + 80
  const randomCritical = Math.floor(Math.random() * 3)
  const randomMajor = Math.floor(Math.random() * 5) + 1
  const randomMinor = Math.floor(Math.random() * 8) + 2

  return {
    totalVms: randomVms,
    activeServices: randomServices,
    alerts: {
      critical: randomCritical,
      major: randomMajor,
      minor: randomMinor,
    },
    systemHealth: Math.floor(Math.random() * 30) + 70, // 70-100%
    networkTraffic: {
      incoming: Math.floor(Math.random() * 1000) + 500, // MB/s
      outgoing: Math.floor(Math.random() * 800) + 300,
    },
    recentActivity: [
      {
        id: "1",
        type: "vm_created",
        message: "VM 'web-server-03' créée avec succès",
        timestamp: "Il y a 5 minutes"
      },
      {
        id: "2", 
        type: "alert_resolved",
        message: "Alerte CPU résolue sur 'db-server-01'",
        timestamp: "Il y a 12 minutes"
      },
      {
        id: "3",
        type: "script_executed",
        message: "Script de monitoring exécuté sur 5 VMs",
        timestamp: "Il y a 18 minutes"
      },
      {
        id: "4",
        type: "vm_stopped",
        message: "VM 'test-env-02' arrêtée pour maintenance",
        timestamp: "Il y a 25 minutes"
      }
    ],
    lastUpdated: now.toLocaleTimeString("fr-FR"),
    apiError: Math.random() < 0.05, // 5% chance of error
  }
}

// Simulate AI analysis for dashboard
const simulateDashboardAIAnalysis = async (context: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 2000))
  
  const criticalCount = parseInt(context.match(/critiques: (\d+)/)?.[1] || "0")
  const majorCount = parseInt(context.match(/majeures: (\d+)/)?.[1] || "0")
  const vmCount = parseInt(context.match(/VMs: (\d+)/)?.[1] || "0")
  
  return `🤖 **Analyse IA du tableau de bord**

**📊 Résumé:**
Votre infrastructure supervise actuellement ${vmCount} machines virtuelles avec un niveau d'alerte ${criticalCount > 0 ? 'critique' : majorCount > 2 ? 'modéré' : 'faible'}.

**🔍 Analyse technique:**
${criticalCount > 0 ? 
  `⚠️ ATTENTION: ${criticalCount} alerte(s) critique(s) détectée(s). Ces alertes nécessitent une intervention immédiate car elles peuvent affecter la disponibilité des services.` : 
  '✅ Aucune alerte critique détectée. Le système fonctionne dans les paramètres normaux.'
}

${majorCount > 3 ? 
  `🟡 ${majorCount} alertes majeures sont présentes. Bien qu'elles ne soient pas critiques, elles méritent votre attention pour éviter une escalade.` : 
  `🟢 Nombre d'alertes majeures acceptable (${majorCount}).`
}

**💡 Conseils et recommandations:**
${criticalCount > 0 ? 
  '1. Consultez immédiatement les détails des alertes critiques via le bouton "Superviser"\n2. Vérifiez les logs des VMs concernées\n3. Envisagez une collecte manuelle des métriques' :
  '1. Continuez la surveillance régulière\n2. Planifiez une maintenance préventive\n3. Optimisez les ressources sous-utilisées'
}

**🎯 Actions recommandées:**
- Supervision en temps réel des VMs critiques
- Analyse des tendances de performance
- Mise à jour des scripts de monitoring si nécessaire

*Analyse générée le ${new Date().toLocaleString('fr-FR')}*`
}

export default function DashboardPage() {
  const [data, setData] = React.useState<DashboardData | null>(null)
  const [loading, setLoading] = React.useState(true)

  const fetchData = React.useCallback(() => {
    setLoading(true)
    // Simulate API call
    setTimeout(() => {
      const newData = mockDashboardData()
      setData(newData)
      setLoading(false)
    }, 800)
  }, [])

  React.useEffect(() => {
    fetchData() // Initial fetch

    const interval = setInterval(() => {
      fetchData()
    }, 10000) // Refresh every 10 seconds as per UC04

    return () => clearInterval(interval)
  }, [fetchData])

  const getAlertVariant = (count: number, type: 'critical' | 'major' | 'minor') => {
    if (type === 'critical' && count > 0) return "destructive"
    if (type === 'major' && count > 2) return "warning"
    if (type === 'minor' && count > 5) return "info"
    return "success"
  }

  const getActivityIcon = (type: string) => {
    switch (type) {
      case "vm_created": return <Plus className="h-4 w-4 text-success" />
      case "vm_stopped": return <XCircle className="h-4 w-4 text-warning" />
      case "alert_resolved": return <RefreshCw className="h-4 w-4 text-info" />
      case "script_executed": return <Code className="h-4 w-4 text-primary" />
      default: return <Activity className="h-4 w-4" />
    }
  }

  const aiContext = data ? 
    `Nombre de VMs: ${data.totalVms}, Services actifs: ${data.activeServices}, Alertes critiques: ${data.alerts.critical}, majeures: ${data.alerts.major}, mineures: ${data.alerts.minor}, Santé système: ${data.systemHealth}%.` : 
    "Données du tableau de bord non disponibles."

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
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
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
                    <p className="text-xs text-muted-foreground">{activity.timestamp}</p>
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
        onAnalyze={simulateDashboardAIAnalysis}
        className="w-full"
      />

      <div className="text-right text-sm text-muted-foreground">
        Dernière mise à jour: {data?.lastUpdated || "N/A"}
        {loading && <span className="ml-2 animate-pulse">• Actualisation...</span>}
      </div>
    </div>
  )
}
