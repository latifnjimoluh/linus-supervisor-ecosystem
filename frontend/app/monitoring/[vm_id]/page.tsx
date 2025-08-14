"use client"

import * as React from "react"
import { useParams, useRouter } from "next/navigation"
import {
  Play, Square, Copy, RefreshCw, Activity,
  Cpu, MemoryStick, AlertTriangle, CheckCircle, XCircle,
  Settings, FileText, Loader2, Eye, Trash2, BarChart3
} from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Progress } from "@/components/ui/progress"
import { Input } from "@/components/ui/input"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { useToast } from "@/hooks/use-toast"
import { useErrors } from "@/hooks/use-errors"
import { ErrorBanner } from "@/components/error-banner"
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
import { cn, formatKB, formatPercent, formatDate } from "@/lib/utils"
import { fetchVmDetails, collectMonitoringData } from "@/services/monitoring"
import { startProxmoxVM, stopProxmoxVM, deleteProxmoxVM } from "@/services/vms"
import { BackButton } from "@/components/back-button"

interface VMDetails {
  id: string
  name: string
  ip: string
  status: "running" | "stopped" | "error"
  created_at: string
  uptime: string
  hostname: string
  template: string
  vcpu: number
  memory: string
  disk: string
  instance_id: string
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
  open_ports: number[]
  top_processes: Array<{ pid: number; cmd: string; cpu: number }>
  last_monitoring: string
}

// --- Analyse IA (inchangé) ---
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
${cpuUsage > 80
    ? "🔴 **CRITIQUE** - Utilisation CPU très élevée. Causes possibles:\n- Processus gourmand en cours\n- Besoin d'augmenter les vCPUs\n- Optimisation du code nécessaire"
    : cpuUsage > 60
      ? "🟡 **ATTENTION** - Utilisation CPU modérée à surveiller"
      : "🟢 **NORMAL** - Utilisation CPU dans les limites acceptables"
  }

**Mémoire (${memoryPercent}%):**
${memoryPercent > 85
    ? "🔴 **CRITIQUE** - Mémoire saturée. Actions recommandées:\n- Redémarrer les services gourmands\n- Augmenter la RAM allouée\n- Vérifier les fuites mémoire"
    : memoryPercent > 70
      ? "🟡 **ATTENTION** - Consommation mémoire élevée"
      : "🟢 **NORMAL** - Utilisation mémoire correcte"
  }

**💡 Recommandations:**
${cpuUsage > 70 || memoryPercent > 70
    ? "1. Surveillez cette VM de près\n2. Envisagez une montée en charge\n3. Analysez les processus actifs\n4. Planifiez une maintenance"
    : "1. Performances optimales\n2. Continuez la surveillance régulière\n3. Planifiez les mises à jour de sécurité"
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
  const { setError, clearError } = useErrors()

  const [vmData, setVmData] = React.useState<VMDetails | null>(null)
  const [loading, setLoading] = React.useState(true)
  const [actionLoading, setActionLoading] = React.useState<string | null>(null)
  const [collectUsername, setCollectUsername] = React.useState("")

  // --- Helper d'explication d'erreurs de collecte ---
  function explainCollectError(raw?: unknown) {
    const msg =
      (raw as any)?.response?.data?.error ||
      (raw as any)?.response?.data?.message ||
      (raw as any)?.message ||
      String(raw ?? "")

    const lower = (msg || "").toLowerCase()
    if (lower.includes("no such file")) {
      return {
        title: "Fichier de métriques introuvable sur la VM",
        description:
          "Le chemin indiqué n’existe pas (ex: /opt/monitoring/status.json). Vérifiez l’agent et les chemins configurés.",
      }
    }
    if (lower.includes("permission denied") || lower.includes("publickey")) {
      return {
        title: "Authentification SSH refusée",
        description:
          "Clé privée/utilisateur incorrects ou droits insuffisants. Vérifiez la clé, l’utilisateur et les permissions (~/.ssh).",
      }
    }
    if (lower.includes("timed out") || lower.includes("timeout")) {
      return {
        title: "Délai de connexion SSH dépassé",
        description:
          "La VM est peut-être injoignable (réseau/pare-feu). Vérifiez l’IP, le port 22 et la connectivité.",
      }
    }
    if (lower.includes("econnrefused")) {
      return {
        title: "Connexion SSH refusée",
        description:
          "Le service sshd ne répond pas sur la VM. Assurez-vous qu’il est démarré et écoute.",
      }
    }
    return {
      title: "Erreur lors de la collecte des données de monitoring",
      description: msg,
    }
  }

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
        status:
          data.proxmox?.status === 'running'
            ? 'running'
            : data.proxmox?.status === 'stopped'
              ? 'stopped'
              : 'error',
        created_at: data.created_at ? new Date(data.created_at).toLocaleString('fr-FR') : '',
        uptime: system.uptime || data.status?.uptime || '',
        hostname: system.hostname || '',
        template: data.template || '',
        vcpu: data.status?.cpus || 0,
        memory: formatKB(memoryTotalKb),
        disk: formatKB(diskTotalKb),
        instance_id: data.instance_id || '',
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
        recent_logs: Array.isArray(system.recent_logs) ? system.recent_logs : [],
        open_ports: Array.isArray(system.open_ports) ? system.open_ports : [],
        top_processes: Array.isArray(system.top_processes) ? system.top_processes : [],
        last_monitoring: monitor.retrieved_at ? formatDate(monitor.retrieved_at) : '',
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
        case 'delete':
          await deleteProxmoxVM({ vm_id: Number(vmId), instance_id: vmData?.instance_id || '' })
          message = `VM ${vmData?.name} supprimée avec succès`
          router.push('/monitoring')
          break
        case 'collect':
          if (!vmData?.ip) throw new Error('VM IP inconnue')
          if (!collectUsername) throw new Error('Username requis')
          await collectMonitoringData(vmData.ip, collectUsername)
          await fetchVMData()
          message = 'Collecte des métriques effectuée avec succès'
          break
        default:
          message = 'Action non supportée'
      }
      clearError('vm-actions')
      toast({ title: 'Action', description: message, variant: 'success' })
    } catch (e: any) {
      if (action === "collect") {
        const exp = explainCollectError(e)
        setError("vm-actions", {
          message: `${exp.title}${exp.description ? " – " + exp.description : ""}`,
          ttlMs: 8000,
        })
      } else {
        setError("vm-actions", { message: 'Action échouée', ttlMs: 5000 })
      }
    } finally {
      setActionLoading(null)
    }
  }

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text)
    toast({ title: "Copié !", description: "Adresse IP copiée dans le presse-papiers", variant: "info" })
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

  const aiContext =
    `VM: ${vmData.name}, IP: ${vmData.ip}, Statut: ${vmData.status}, ` +
    `CPU: ${Math.round(vmData.metrics.cpu_usage)}%, ` +
    `Mémoire: ${Math.round(vmData.metrics.memory_usage / 1024)}/${Math.round(vmData.metrics.memory_total / 1024)} MB, ` +
    `Disque: ${Math.round(vmData.metrics.disk_usage / (1024 * 1024))}/${Math.round(vmData.metrics.disk_total / (1024 * 1024))} GB, ` +
    `Services actifs: ${vmData.services.filter(s => s.status === 'active').length}/${vmData.services.length}`

  return (
    <div className="space-y-6">
      <ErrorBanner id="vm-actions" />
      {/* Header */}
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <BackButton href="/monitoring" />
          <h1 className="text-4xl font-semibold whitespace-normal break-words">{vmData.name}</h1>
        </div>
        <Button
          onClick={fetchVMData}
          variant="outline"
          className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4 whitespace-nowrap"
        >
          <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} />
          Actualiser
        </Button>
      </div>
      <div className="flex flex-wrap items-center gap-2">
        <span className="text-muted-foreground">IP:</span>
        <code className="bg-muted px-2 py-1 rounded font-mono text-xs sm:text-sm whitespace-normal break-words break-all">{vmData.ip}</code>
        <Button variant="ghost" size="sm" onClick={() => copyToClipboard(vmData.ip)}>
          <Copy className="h-3 w-3" />
        </Button>
        <Badge
          variant={getStatusColor(vmData.status)}
          className="inline-flex items-center px-2.5 py-1 rounded-md font-mono text-xs sm:text-[13px] max-w-full break-all"
        >
          {vmData.status === "running" ? "En marche" :
           vmData.status === "stopped" ? "Arrêtée" : "Erreur"}
        </Badge>
      </div>

      {/* Action Buttons */}
      <div className="flex flex-wrap gap-3">
        {vmData.status === "stopped" && (
          <Button
            onClick={() => handleVMAction("start")}
            disabled={actionLoading !== null}
            className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4"
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
              <Button
                variant="secondary"
                disabled={actionLoading !== null}
                className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4"
              >
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
                <AlertDialogAction onClick={() => handleVMAction("stop")}>Arrêter</AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>
        )}

        <Input
          placeholder="username"
          value={collectUsername}
          onChange={(e) => setCollectUsername(e.target.value)}
          className="w-full sm:w-48"
        />
        <Button
          onClick={() => handleVMAction("collect")}
          variant="outline"
          disabled={actionLoading !== null || !collectUsername}
          className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4"
        >
          {actionLoading === "collect" ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <RefreshCw className="mr-2 h-4 w-4" />
          )}
          Forcer collecte
        </Button>

        <AlertDialog>
          <AlertDialogTrigger asChild>
            <Button
              variant="destructive"
              disabled={actionLoading !== null}
              className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4"
            >
              {actionLoading === "delete" ? (
                <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              ) : (
                <Trash2 className="mr-2 h-4 w-4" />
              )}
              Supprimer
            </Button>
          </AlertDialogTrigger>
          <AlertDialogContent>
            <AlertDialogHeader>
              <AlertDialogTitle>Supprimer la VM</AlertDialogTitle>
              <AlertDialogDescription>
                Cette action est irréversible. Supprimer la VM "{vmData.name}" ?
              </AlertDialogDescription>
            </AlertDialogHeader>
            <AlertDialogFooter>
              <AlertDialogCancel>Annuler</AlertDialogCancel>
              <AlertDialogAction onClick={() => handleVMAction('delete')}>Supprimer</AlertDialogAction>
            </AlertDialogFooter>
          </AlertDialogContent>
        </AlertDialog>
      </div>

      {/* VM Info and Metrics */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4 auto-rows-fr">
        {/* System Info */}
        <Card className="h-full flex flex-col rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="p-4 sm:p-5">
            <CardTitle className="text-lg sm:text-xl font-semibold flex items-center gap-2">
              <Settings className="h-5 w-5" />
              Informations système
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4 sm:p-5 flex-1 flex flex-col space-y-3">
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">Nom serveur:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.hostname}</span></div>
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">Template:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.template}</span></div>
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">vCPU:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.vcpu} cores</span></div>
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">RAM:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.memory}</span></div>
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">Disque:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.disk}</span></div>
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">Créée le:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.created_at}</span></div>
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">Uptime:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.uptime}</span></div>
          </CardContent>
        </Card>

        {/* CPU Metrics */}
        <Card className="h-full flex flex-col rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="p-4 sm:p-5">
            <CardTitle className="text-lg sm:text-xl font-semibold flex items-center gap-2">
              <Cpu className="h-5 w-5" />
              CPU & Performance
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4 sm:p-5 flex-1 flex flex-col space-y-4">
            <div>
              <div className="flex justify-between mb-2 gap-3">
                <span className="text-muted-foreground text-sm">Utilisation CPU</span>
                <span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{formatPercent(vmData.metrics.cpu_usage)}</span>
              </div>
              <Progress value={vmData.metrics.cpu_usage} className="h-2 sm:h-2.5 rounded-full" />
            </div>
            <div>
              <div className="flex justify-between mb-2 gap-3">
                <span className="text-muted-foreground text-sm">Load Average</span>
                <span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.metrics.load_average.toFixed(2)}</span>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div>
                <span className="text-muted-foreground">Network In</span>
                <p className="font-medium break-all">{formatKB(vmData.metrics.network_in)}/s</p>
              </div>
              <div>
                <span className="text-muted-foreground">Network Out</span>
                <p className="font-medium break-all">{formatKB(vmData.metrics.network_out)}/s</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Memory & Disk */}
        <Card className="h-full flex flex-col rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="p-4 sm:p-5">
            <CardTitle className="text-lg sm:text-xl font-semibold flex items-center gap-2">
              <MemoryStick className="h-5 w-5" />
              Mémoire & Stockage
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4 sm:p-5 flex-1 flex flex-col space-y-4">
            <div>
              <div className="flex justify-between mb-2 gap-3">
                <span className="text-muted-foreground text-sm">RAM</span>
                <span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">
                  {formatKB(vmData.metrics.memory_usage)} / {formatKB(vmData.metrics.memory_total)}
                </span>
              </div>
              <Progress
                value={vmData.metrics.memory_total ? (vmData.metrics.memory_usage / vmData.metrics.memory_total) * 100 : 0}
                className="h-2 sm:h-2.5 rounded-full"
              />
            </div>
            <div>
              <div className="flex justify-between mb-2 gap-3">
                <span className="text-muted-foreground text-sm">Disque</span>
                <span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">
                  {formatKB(vmData.metrics.disk_usage)} / {formatKB(vmData.metrics.disk_total)}
                </span>
              </div>
              <Progress
                value={vmData.metrics.disk_total ? (vmData.metrics.disk_usage / vmData.metrics.disk_total) * 100 : 0}
                className="h-2 sm:h-2.5 rounded-full"
              />
            </div>
          </CardContent>
        </Card>

        {/* Détails monitoring */}
        <Card className="h-full flex flex-col rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="p-4 sm:p-5">
            <CardTitle className="text-lg sm:text-xl font-semibold flex items-center gap-2">
              <BarChart3 className="h-5 w-5" />
              Détails monitoring
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4 sm:p-5 flex-1 flex flex-col space-y-3">
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">Instance ID:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.instance_id}</span></div>
            <div className="flex justify-between gap-3"><span className="text-muted-foreground text-sm">Hostname:</span><span className="font-medium text-sm sm:text-base text-right break-all whitespace-normal">{vmData.hostname}</span></div>
            <div>
              <span className="text-muted-foreground text-sm">Ports ouverts:</span>
              <div className="mt-1 flex flex-wrap gap-1">
                {vmData.open_ports.map((p, i) => (
                  <Badge
                    key={i}
                    variant="outline"
                    className="inline-flex items-center px-2.5 py-1 rounded-md font-mono text-xs sm:text-[13px] max-w-full break-all"
                  >
                    {p}
                  </Badge>
                ))}
              </div>
            </div>
            <div>
              <span className="text-muted-foreground text-sm">Top processus:</span>
              <div className="mt-1 space-y-1">
                {vmData.top_processes.map((proc, i) => (
                  <div key={i} className="flex justify-between text-sm font-mono gap-2">
                    <span className="break-all whitespace-normal">{proc.cmd} ({proc.pid})</span>
                    <span className="whitespace-nowrap">{proc.cpu}%</span>
                  </div>
                ))}
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Services and Logs */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2 auto-rows-fr">
        {/* Services */}
        <Card className="h-full flex flex-col rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="p-4 sm:p-5">
            <CardTitle className="text-lg sm:text-xl font-semibold flex items-center gap-2">
              <Activity className="h-5 w-5" />
              Services supervisés
            </CardTitle>
            <CardDescription>
              {vmData.services.filter(s => s.status === 'active').length} / {vmData.services.length} services actifs
            </CardDescription>
          </CardHeader>
          <CardContent className="p-4 sm:p-5 flex-1 flex flex-col">
            <div className="flex-1 space-y-3 overflow-y-auto">
              {vmData.services.map((service, index) => (
                <div key={index} className="flex flex-wrap items-start justify-between p-3 sm:p-3.5 border rounded-xl gap-3">
                  <div className="flex flex-wrap items-start gap-3">
                    {getServiceStatusIcon(service.status)}
                    <div>
                      <p className="font-medium break-words whitespace-normal break-all">{service.name}</p>
                      <p className="text-xs text-muted-foreground break-words whitespace-normal break-all">{service.description}</p>
                    </div>
                  </div>
                  <div className="flex flex-col items-end gap-1 text-right flex-shrink-0">
                    {service.port ? (
                      <p className="font-mono text-xs sm:text-sm break-all">:{service.port}</p>
                    ) : null}
                    <Badge
                      variant={
                        service.status === 'active'
                          ? 'success'
                          : service.status === 'inactive'
                            ? 'warning'
                            : 'destructive'
                      }
                      className="inline-flex items-center px-2.5 py-1 rounded-md font-mono text-xs sm:text-[13px] max-w-full break-all"
                    >
                      {service.status}
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Recent Logs */}
        <Card className="h-full flex flex-col rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="p-4 sm:p-5">
            <CardTitle className="text-lg sm:text-xl font-semibold flex items-center gap-2">
              <FileText className="h-5 w-5" />
              Logs récents
            </CardTitle>
            <CardDescription>Dernières entrées du journal système</CardDescription>
          </CardHeader>
          <CardContent className="p-4 sm:p-5 flex-1 flex flex-col">
            <div className="flex-1 space-y-3 max-h-64 sm:max-h-72 overflow-y-auto">
              {vmData.recent_logs.map((log, index) => (
                <div key={index} className="p-3 sm:p-3.5 border rounded-xl">
                  <div className="flex flex-wrap items-start justify-between mb-1 gap-2">
                    <span className="font-mono text-xs sm:text-sm text-muted-foreground break-all">{log.timestamp}</span>
                    <Badge
                      variant={
                        log.level === 'error' ? 'destructive' : log.level === 'warning' ? 'warning' : 'info'
                      }
                      className="inline-flex items-center px-2.5 py-1 rounded-md font-mono text-xs sm:text-[13px] max-w-full break-all"
                    >
                      {log.level}
                    </Badge>
                  </div>
                  <p className={cn("text-sm whitespace-normal break-words break-all", getLogLevelColor(log.level))}>{log.message}</p>
                </div>
              ))}
            </div>
            <div className="mt-4 pt-4 border-t">
              <Button
                variant="outline"
                className="w-full rounded-xl h-9 sm:h-10 px-3.5 sm:px-4"
                asChild
              >
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
      <div className="text-right text-sm text-muted-foreground whitespace-normal break-words break-all">
        Dernière supervision: {vmData.last_monitoring}
      </div>
    </div>
  )
}
