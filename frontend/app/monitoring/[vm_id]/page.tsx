"use client"

import * as React from "react"
import { useParams, useRouter } from "next/navigation"
import { ArrowLeft, Play, Square, Trash2, Copy, RefreshCw, Download, Activity, HardDrive, Cpu, MemoryStick, Network, Clock, AlertTriangle, CheckCircle, XCircle, Settings, FileText, Loader2, Eye, BarChart3 } from 'lucide-react'
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
import { cn } from "@/lib/utils"

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
  memory_mb: number
  disk_gb: number
  metrics: {
    cpu_usage: number
    memory_usage: number
    memory_total: number
    disk_usage: number
    disk_total: number
    network_in: number
    network_out: number
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

// Mock data generator for VM details
const generateVMDetails = (vmId: string): VMDetails => {
  const vmNames = ["web-server-01", "db-server-02", "cache-redis-03", "api-gateway-04", "monitoring-05"]
  const randomName = vmNames[Math.floor(Math.random() * vmNames.length)]
  
  const statuses: Array<"running" | "stopped" | "error"> = ["running", "running", "running", "stopped", "error"]
  const randomStatus = statuses[Math.floor(Math.random() * statuses.length)]
  
  const services = [
    { name: "SSH", status: "active" as const, port: 22, description: "Secure Shell" },
    { name: "HTTP", status: "active" as const, port: 80, description: "Web Server" },
    { name: "HTTPS", status: "active" as const, port: 443, description: "Secure Web Server" },
    { name: "MySQL", status: Math.random() > 0.3 ? "active" as const : "inactive" as const, port: 3306, description: "Database Server" },
    { name: "Redis", status: Math.random() > 0.2 ? "active" as const : "failed" as const, port: 6379, description: "Cache Server" },
    { name: "Docker", status: "active" as const, description: "Container Runtime" },
  ]

  const logs = [
    { timestamp: "2025-01-07 14:30:15", level: "info" as const, message: "Service HTTP started successfully" },
    { timestamp: "2025-01-07 14:25:42", level: "warning" as const, message: "High CPU usage detected (85%)" },
    { timestamp: "2025-01-07 14:20:18", level: "error" as const, message: "Failed to connect to database" },
    { timestamp: "2025-01-07 14:15:33", level: "info" as const, message: "System backup completed" },
    { timestamp: "2025-01-07 14:10:07", level: "info" as const, message: "Monitoring agent updated" },
  ]

  return {
    id: vmId,
    name: randomName,
    ip: `192.168.1.${Math.floor(Math.random() * 200) + 10}`,
    status: randomStatus,
    created_at: "2025-01-05 10:30:00",
    uptime: randomStatus === "running" ? "2 jours, 4 heures" : "0 minutes",
    os: "Ubuntu 22.04 LTS",
    template: "ubuntu-template",
    vcpu: Math.floor(Math.random() * 4) + 2,
    memory_mb: (Math.floor(Math.random() * 6) + 2) * 1024,
    disk_gb: (Math.floor(Math.random() * 8) + 2) * 10,
    metrics: {
      cpu_usage: Math.floor(Math.random() * 80) + 10,
      memory_usage: Math.floor(Math.random() * 6000) + 1000,
      memory_total: 8192,
      disk_usage: Math.floor(Math.random() * 60) + 20,
      disk_total: 100,
      network_in: Math.floor(Math.random() * 1000) + 100,
      network_out: Math.floor(Math.random() * 800) + 50,
      load_average: Math.random() * 3 + 0.5,
    },
    services: services.slice(0, Math.floor(Math.random() * 3) + 3),
    recent_logs: logs.slice(0, Math.floor(Math.random() * 3) + 2),
    last_monitoring: new Date().toLocaleString("fr-FR"),
  }
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

  const fetchVMData = React.useCallback(() => {
    setLoading(true)
    // Simulate API call
    setTimeout(() => {
      const data = generateVMDetails(vmId)
      setVmData(data)
      setLoading(false)
    }, 1000)
  }, [vmId])

  React.useEffect(() => {
    fetchVMData()
    
    // Auto-refresh every 30 seconds
    const interval = setInterval(fetchVMData, 30000)
    return () => clearInterval(interval)
  }, [fetchVMData])

  const handleVMAction = async (action: string) => {
    setActionLoading(action)
    
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000))
    
    let message = ""
    let variant: "success" | "destructive" = "success"
    
    switch (action) {
      case "start":
        message = `VM ${vmData?.name} démarrée avec succès`
        if (vmData) {
          setVmData({ ...vmData, status: "running" })
        }
        break
      case "stop":
        message = `VM ${vmData?.name} arrêtée avec succès`
        if (vmData) {
          setVmData({ ...vmData, status: "stopped", uptime: "0 minutes" })
        }
        break
      case "delete":
        message = `VM ${vmData?.name} supprimée avec succès`
        setTimeout(() => router.push("/monitoring"), 2000)
        break
      case "convert":
        message = `VM ${vmData?.name} convertie en template avec succès`
        break
      case "collect":
        message = "Collecte des métriques effectuée avec succès"
        fetchVMData() // Refresh data
        break
      case "sync-ip":
        message = "Synchronisation IP effectuée avec succès"
        break
      default:
        message = "Action effectuée avec succès"
    }
    
    toast({
      title: "Action réussie",
      description: message,
      variant,
    })
    
    setActionLoading(null)
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

  const aiContext = `VM: ${vmData.name}, IP: ${vmData.ip}, Statut: ${vmData.status}, CPU: ${vmData.metrics.cpu_usage}%, Mémoire: ${vmData.metrics.memory_usage}/${vmData.metrics.memory_total} MB, Disque: ${vmData.metrics.disk_usage}/${vmData.metrics.disk_total} GB, Services actifs: ${vmData.services.filter(s => s.status === 'active').length}/${vmData.services.length}`

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

        <Button 
          onClick={() => handleVMAction("sync-ip")} 
          variant="outline" 
          disabled={actionLoading !== null}
          className="rounded-xl"
        >
          {actionLoading === "sync-ip" ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Network className="mr-2 h-4 w-4" />
          )}
          Sync IP
        </Button>

        <AlertDialog>
          <AlertDialogTrigger asChild>
            <Button 
              variant="outline" 
              disabled={actionLoading !== null || vmData.status === "running"}
              className="rounded-xl"
            >
              <Settings className="mr-2 h-4 w-4" />
              Convertir en Template
            </Button>
          </AlertDialogTrigger>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Convertir en Template</AlertDialogTitle>
              <AlertDialogDescription>
                Cette action convertira la VM "{vmData.name}" en template Proxmox. 
                La VM ne sera plus modifiable ni supervisée après conversion.
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter>
              <AlertDialogCancel>Annuler</AlertDialogCancel>
              <AlertDialogAction onClick={() => handleVMAction("convert")}>
                Convertir
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>

        <AlertDialog>
          <AlertDialogTrigger asChild>
            <Button 
              variant="destructive" 
              disabled={actionLoading !== null}
              className="rounded-xl"
            >
              <Trash2 className="mr-2 h-4 w-4" />
              Supprimer
            </Button>
          </AlertDialogTrigger>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Supprimer la VM</AlertDialogTitle>
              <AlertDialogDescription>
                ⚠️ Cette action est irréversible ! La VM "{vmData.name}" et toutes ses données seront définitivement supprimées.
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter>
              <AlertDialogCancel>Annuler</AlertDialogCancel>
              <AlertDialogAction 
                onClick={() => handleVMAction("delete")}
                className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
              >
                Supprimer définitivement
              </AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
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
              <span className="font-medium">{vmData.memory_mb} MB</span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Disque:</span>
              <span className="font-medium">{vmData.disk_gb} GB</span>
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
                <p className="font-medium">{vmData.metrics.network_in} KB/s</p>
              </div>
              <div>
                <span className="text-muted-foreground">Network Out</span>
                <p className="font-medium">{vmData.metrics.network_out} KB/s</p>
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
                  {vmData.metrics.memory_usage} / {vmData.metrics.memory_total} MB
                </span>
              </div>
              <Progress 
                value={(vmData.metrics.memory_usage / vmData.metrics.memory_total) * 100} 
                className="h-2" 
              />
            </div>
            <div>
              <div className="flex justify-between mb-2">
                <span>Disque</span>
                <span className="font-medium">
                  {vmData.metrics.disk_usage} / {vmData.metrics.disk_total} GB
                </span>
              </div>
              <Progress 
                value={(vmData.metrics.disk_usage / vmData.metrics.disk_total) * 100} 
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
