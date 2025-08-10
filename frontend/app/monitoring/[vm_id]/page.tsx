"use client"

import * as React from "react"
import { useParams, useRouter } from "next/navigation"
import { ArrowLeft, Play, Square, Copy, RefreshCw, Activity, HardDrive, Cpu, MemoryStick, Clock, AlertTriangle, CheckCircle, XCircle, Settings, FileText, Loader2, Eye, BarChart3 } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { useToast } from "@/hooks/use-toast"
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { cn, formatKB } from "@/lib/utils"
import { fetchVmDetails, collectMonitoringData } from "@/services/monitoring"
import { startProxmoxVM, stopProxmoxVM } from "@/services/vms"

interface VMDetails {
  id: string
  name: string
  ip: string
  status: "running" | "stopped" | "error"
  created_at: string
  uptime: string
  os: string
  template: string
  vcpu: number
  memory: string
  disk: string
  metrics: {
    cpu_usage: number
    memory_usage: number // KB
    memory_total: number // KB
    disk_usage: number // used KB
    disk_total: number // total KB
    network_in: number // KB/s
    network_out: number // KB/s
    load_average: number
  }
  services: Array<{
    name: string
    status: "active" | "inactive" | "failed"
    port?: number
    description: string
  }>
  recent_logs: Array<{
    timestamp: string
    level: "info" | "warning" | "error"
    message: string
  }>
  last_monitoring: string
}

// Simulate AI analysis for VM performance
const simulateVMAnalysis = async (context: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 2500))
  
  const cpuMatch = context.match(/CPU: (\d+)%/)
  const memoryMatch = context.match(/Mémoire: (\d+)\/(\d+) MB/)
  const statusMatch = context.match(/Statut: (\w+)/)
  
  const cpuUsage = cpuMatch ? parseInt(cpuMatch[1]) : 0
  const memoryUsage = memoryMatch ? parseInt(memoryMatch[1]) : 0
  const memoryTotal = memoryMatch ? parseInt(memoryMatch[2]) : 8192
  const status = statusMatch ? statusMatch[1] : "unknown"
  
  const memoryPercent = Math.round((memoryUsage / memoryTotal) * 100)
  
  return `🤖 **Analyse IA de la VM**

**📊 État général:**
${status === "running" ? "✅ La VM fonctionne normalement" : status === "stopped" ? "⏹️ La VM est actuellement arrêtée" : "❌ La VM présente des dysfonctionnements"}

**🔍 Analyse des performances:**

**CPU (${cpuUsage}%):**
${cpuUsage > 80 ? 
  "🔴 **CRITIQUE** - Utilisation CPU très élevée. Causes possibles:\n- Processus gourmand en cours\n- Besoin d'augmenter les vCPUs\n- Optimisation du code nécessaire" :
  cpuUsage > 60 ? 
  "🟡 **ATTENTION** - Utilisation CPU modérée à surveiller" :
  "🟢 **NORMAL** - Utilisation CPU dans les limites acceptables"
}

**Mémoire (${memoryPercent}%):**
${memoryPercent > 85 ? 
  "🔴 **CRITIQUE** - Mémoire saturée. Actions recommandées:\n- Redémarrer les services gourmands\n- Augmenter la RAM allouée\n- Vérifier les fuites mémoire" :
  memoryPercent > 70 ? 
  "🟡 **ATTENTION** - Consommation mémoire élevée" :
  "🟢 **NORMAL** - Utilisation mémoire correcte"
}

**💡 Recommandations:**
${cpuUsage > 70 || memoryPercent > 70 ? 
  "1. Surveillez cette VM de près\n2. Envisagez une montée en charge\n3. Analysez les processus actifs\n4. Planifiez une maintenance" :
  "1. Performances optimales\n2. Continuez la surveillance régulière\n3. Planifiez les mises à jour de sécurité"
}

**🔧 Actions suggérées:**
- Collecte manuelle des métriques pour analyse approfondie
- Vérification des logs système récents
- Test de connectivité des services critiques

*Analyse générée le ${new Date().toLocaleString('fr-FR')}*`
}

export default function VMDetailsPage() {
  const params = useParams()
  const router = useRouter()
  const vmId = params.vm_id as string
  const { toast } = useToast()
  
  const [vmData, setVmData] = React.useState<VMDetails | null>(null)
  const [loading, setLoading] = React.useState(true)
  const [actionLoading, setActionLoading] = React.useState<string | null>(null)

  const fetchVMData = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await fetchVmDetails(vmId)
      const monitor = data.monitoring || {}
      const system = monitor.system_status || {}
      const services = monitor.services_status?.services || []
      const memoryTotalKb = data.memory_total || data.status?.maxmem / 1024 || 0
      const diskTotalKb = data.disk_total || data.status?.maxdisk / 1024 || 0

      const mapped: VMDetails = {
        id: data.id,
        name: data.name,
        ip: data.ip || '',
        status: data.proxmox?.status === 'running' ? 'running' : data.proxmox?.status === 'stopped' ? 'stopped' : 'error',
        created_at: data.created_at ? new Date(data.created_at).toLocaleString('fr-FR') : '',
        uptime: system.uptime || data.status?.uptime || '',
        os: system.os || system.hostname || '',
        template: data.template || '',
        vcpu: data.status?.cpus || 0,
        memory: formatKB(memoryTotalKb),
        disk: formatKB(diskTotalKb),
        metrics: {
          cpu_usage: data.cpu_usage || 0,
          memory_usage: data.memory_usage || 0,
          memory_total: memoryTotalKb,
          disk_usage: data.disk_usage || 0,
          disk_total: diskTotalKb,
          network_in: data.network_in || 0,
          network_out: data.network_out || 0,
          load_average: data.load_average || 0,
        },
        services: services.map((s: any) => ({
          name: s.name,
          status: s.active === 'active' ? 'active' : s.active === 'inactive' ? 'inactive' : 'failed',
          description: s.enabled,
        })),
        recent_logs: [],
        last_monitoring: monitor.retrieved_at || '',
      }
      setVmData(mapped)
    } catch (e) {
      console.error('Erreur de récupération du monitoring', e)
      setVmData(null)
    } finally {
      setLoading(false)
    }
  }, [vmId])

  React.useEffect(() => {
    fetchVMData()
    
    // Auto-refresh every 30 seconds
    const interval = setInterval(fetchVMData, 30000)
    return () => clearInterval(interval)
  }, [fetchVMData])

  const handleVMAction = async (action: string) => {
    setActionLoading(action)
    try {
      let message = ''
      switch (action) {
        case 'start':
          await startProxmoxVM(Number(vmId))
          message = `VM ${vmData?.name} démarrée avec succès`
          break
        case 'stop':
          await stopProxmoxVM(Number(vmId))
          message = `VM ${vmData?.name} arrêtée avec succès`
          break
        case 'collect':
          if (!vmData?.ip) throw new Error('VM IP inconnue')
          await collectMonitoringData(vmData.ip, 'nexus')
          await fetchVMData()
          message = 'Collecte des métriques effectuée avec succès'
          break
        default:
          message = 'Action non supportée'
      }
      toast({ title: 'Action', description: message, variant: 'success' })
    } catch (e) {
      toast({ title: 'Erreur', description: 'Action échouée', variant: 'destructive' })
    } finally {
      setActionLoading(null)
    }
  }

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text)
    toast({
      title: "Copié !",
      description: "Adresse IP copiée dans le presse-papiers",
      variant: "info",
    })
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case "running": return "success"
      case "stopped": return "warning"
      case "error": return "destructive"
      default: return "default"
    }
  }

  const getServiceStatusIcon = (status: string) => {
    switch (status) {
      case "active": return <CheckCircle className="h-4 w-4 text-success" />
      case "inactive": return <XCircle className="h-4 w-4 text-warning" />
      case "failed": return <AlertTriangle className="h-4 w-4 text-destructive" />
      default: return <Activity className="h-4 w-4" />
    }
  }

  const getLogLevelColor = (level: string) => {
    switch (level) {
      case "error": return "text-destructive"
      case "warning": return "text-warning"
      case "info": return "text-info"
      default: return "text-foreground"
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="text-center">
          <Loader2 className="h-8 w-8 animate-spin mx-auto mb-4" />
          <p>Chargement des détails de la VM...</p>
        </div>
      </div>
    )
  }

  if (!vmData) {
    return (
      <div className="space-y-6">
        <Alert variant="destructive" className="rounded-2xl">
          <XCircle className="h-4 w-4" />
          <AlertTitle>VM introuvable</AlertTitle>
          <AlertDescription>
            Cette machine virtuelle n'existe pas ou vous n'avez pas les permissions pour y accéder.
            <Button variant="link" onClick={() => router.push("/monitoring")} className="ml-2 p-0 h-auto">
              Retour à la liste
            </Button>
          </AlertDescription>
        </Alert>
      </div>
    )
  }

  const aiContext = `VM: ${vmData.name}, IP: ${vmData.ip}, Statut: ${vmData.status}, CPU: ${vmData.metrics.cpu_usage}%, Mémoire: ${Math.round(vmData.metrics.memory_usage / 1024)}/${Math.round(vmData.metrics.memory_total / 1024)} MB, Disque: ${Math.round(vmData.metrics.disk_usage / (1024 * 1024))}/${Math.round(vmData.metrics.disk_total / (1024 * 1024))} GB, Services actifs: ${vmData.services.filter(s => s.status === 'active').length}/${vmData.services.length}`

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Button variant="ghost" size="icon" onClick={() => router.push("/monitoring")}>
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <div>
            <h1 className="text-4xl font-semibold">{vmData.name}</h1>
            <div className="flex items-center gap-2 mt-1">
              <span className="text-muted-foreground">IP:</span>
              <code className="bg-muted px-2 py-1 rounded text-sm">{vmData.ip}</code>
              <Button variant="ghost" size="sm" onClick={() => copyToClipboard(vmData.ip)}>
                <Copy className="h-3 w-3" />
              </Button>
              <Badge variant={getStatusColor(vmData.status)}>
                {vmData.status === "running" ? "En marche" : 
                 vmData.status === "stopped" ? "Arrêtée" : "Erreur"}
              </Badge>
            </div>
          </div>
        </div>
        <Button onClick={fetchVMData} variant="outline" size="sm" className="rounded-xl">
          <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} />
          Actualiser
        </Button>
      </div>

      {/* Action Buttons */}
      <div className="flex flex-wrap gap-3">
        {vmData.status === "stopped" && (
          <Button 
            onClick={() => handleVMAction("start")} 
            disabled={actionLoading !== null}
            className="rounded-xl"
          >
            {actionLoading === "start" ? (
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
            ) : (
              <Play className="mr-2 h-4 w-4" />
            )}
            Démarrer
          </Button>
        )}
        
        {vmData.status === "running" && (
          <AlertDialog>
            <AlertDialogTrigger asChild>
              <Button variant="secondary" disabled={actionLoading !== null} className="rounded-xl">
                <Square className="mr-2 h-4 w-4" />
                Arrêter
              </Button>
            </AlertDialogTrigger>
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>Arrêter la VM</AlertDialogTitle>
                <AlertDialogDescription>
                  Êtes-vous sûr de vouloir arrêter la VM "{vmData.name}" ? 
                  Cette action interrompra tous les services en cours.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>Annuler</AlertDialogCancel>
                <AlertDialogAction onClick={() => handleVMAction("stop")}>
                  Arrêter
                </AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>
        )}

        <Button 
          onClick={() => handleVMAction("collect")} 
          variant="outline" 
          disabled={actionLoading !== null}
          className="rounded-xl"
        >
          {actionLoading === "collect" ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <RefreshCw className="mr-2 h-4 w-4" />
          )}
          Forcer collecte
        </Button>

        
      </div>

      {/* VM Info and Metrics */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* System Info */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Settings className="h-5 w-5" />
              Informations système
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            <div className="flex justify-between">
              <span className="text-muted-foreground">OS:</span>
              <span className="font-medium">{vmData.os}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Template:</span>
              <span className="font-medium">{vmData.template}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">vCPU:</span>
              <span className="font-medium">{vmData.vcpu} cores</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">RAM:</span>
              <span className="font-medium">{vmData.memory}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Disque:</span>
              <span className="font-medium">{vmData.disk}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Créée le:</span>
              <span className="font-medium">{vmData.created_at}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Uptime:</span>
              <span className="font-medium">{vmData.uptime}</span>
            </div>
          </CardContent>
        </Card>

        {/* CPU Metrics */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Cpu className="h-5 w-5" />
              CPU & Performance
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <div className="flex justify-between mb-2">
                <span>Utilisation CPU</span>
                <span className="font-medium">{vmData.metrics.cpu_usage}%</span>
              </div>
              <Progress value={vmData.metrics.cpu_usage} className="h-2" />
            </div>
            <div>
              <div className="flex justify-between mb-2">
                <span>Load Average</span>
                <span className="font-medium">{vmData.metrics.load_average.toFixed(2)}</span>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div>
                <span className="text-muted-foreground">Network In</span>
                <p className="font-medium">{formatKB(vmData.metrics.network_in)}/s</p>
              </div>
              <div>
                <span className="text-muted-foreground">Network Out</span>
                <p className="font-medium">{formatKB(vmData.metrics.network_out)}/s</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Memory & Disk */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <MemoryStick className="h-5 w-5" />
              Mémoire & Stockage
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div>
              <div className="flex justify-between mb-2">
                <span>RAM</span>
                <span className="font-medium">
                  {formatKB(vmData.metrics.memory_usage)} / {formatKB(vmData.metrics.memory_total)}
                </span>
              </div>
              <Progress 
                value={vmData.metrics.memory_total ? (vmData.metrics.memory_usage / vmData.metrics.memory_total) * 100 : 0}
                className="h-2" 
              />
            </div>
            <div>
              <div className="flex justify-between mb-2">
                <span>Disque</span>
                <span className="font-medium">
                  {formatKB(vmData.metrics.disk_usage)} / {formatKB(vmData.metrics.disk_total)}
                </span>
              </div>
              <Progress 
                value={vmData.metrics.disk_total ? (vmData.metrics.disk_usage / vmData.metrics.disk_total) * 100 : 0}
                className="h-2" 
              />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Services and Logs */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Services */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Activity className="h-5 w-5" />
              Services supervisés
            </CardTitle>
            <CardDescription>
              {vmData.services.filter(s => s.status === 'active').length} / {vmData.services.length} services actifs
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {vmData.services.map((service, index) => (
                <div key={index} className="flex items-center justify-between p-3 border rounded-xl">
                  <div className="flex items-center gap-3">
                    {getServiceStatusIcon(service.status)}
                    <div>
                      <p className="font-medium">{service.name}</p>
                      <p className="text-xs text-muted-foreground">{service.description}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    {service.port && (
                      <p className="text-sm font-mono">:{service.port}</p>
                    )}
                    <Badge variant={service.status === 'active' ? 'success' : service.status === 'inactive' ? 'warning' : 'destructive'} className="text-xs">
                      {service.status}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Recent Logs */}
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <FileText className="h-5 w-5" />
              Logs récents
            </CardTitle>
            <CardDescription>
              Dernières entrées du journal système
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-3 max-h-64 overflow-y-auto">
              {vmData.recent_logs.map((log, index) => (
                <div key={index} className="p-3 border rounded-xl">
                  <div className="flex items-start justify-between mb-1">
                    <span className="text-xs text-muted-foreground font-mono">
                      {log.timestamp}
                    </span>
                    <Badge variant={log.level === 'error' ? 'destructive' : log.level === 'warning' ? 'warning' : 'info'} className="text-xs">
                      {log.level}
                    </Badge>
                  </div>
                  <p className={cn("text-sm", getLogLevelColor(log.level))}>
                    {log.message}
                  </p>
                </div>
              ))}
            </div>
            <div className="mt-4 pt-4 border-t">
              <Button variant="outline" size="sm" className="w-full rounded-xl" asChild>
                <a href={`/logs/${vmData.id}`}>
                  <Eye className="mr-2 h-4 w-4" />
                  Voir tous les logs
                </a>
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* AI Analysis Block */}
      <AssistantAIBlock
        title={`Analyse IA de ${vmData.name}`}
        context={aiContext}
        onAnalyze={simulateVMAnalysis}
        className="w-full"
      />

      {/* Footer Info */}
      <div className="text-right text-sm text-muted-foreground">
        Dernière supervision: {vmData.last_monitoring}
      </div>
    </div>
  )
}
