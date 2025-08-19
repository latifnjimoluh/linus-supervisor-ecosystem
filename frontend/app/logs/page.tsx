"use client"

import * as React from "react"
import {
  Search,
  Download,
  RefreshCw,
  Eye,
  User,
  Settings,
  Trash2,
  Server,
  AlertTriangle,
  CheckCircle,
  XCircle,
  FileText,
  Loader2,
  ArrowUpDown,
  Globe,
  Hash,
} from "lucide-react"
import { motion } from "framer-motion"
import { VisuallyHidden } from "@radix-ui/react-visually-hidden"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogClose,
} from "@/components/ui/dialog"
import { Separator } from "@/components/ui/separator"

import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { useToast } from "@/hooks/use-toast"
import { useErrors } from "@/hooks/use-errors"
import { ErrorBanner } from "@/components/error-banner"

import {
  listLogs,
  exportLogs as fetchLogsExport,
  estimateLogsExportSize,
  downloadLog as fetchLogFile,
  LogEntry,
} from "@/services/logs"

// --- petite IA factice pour la démo ---
const simulateLogsAIAnalysis = async (context: string): Promise<string> => {
  await new Promise((resolve) => setTimeout(resolve, 2500))
  const errorCount = context.match(/Erreurs:\s*(\d+)/)?.[1] || "0"
  const totalLogs = context.match(/Total:\s*(\d+)/)?.[1] || "0"
  return `🤖 **Analyse IA des logs système**

**📊 Vue d'ensemble :**
Analyse de ${totalLogs} entrées de logs sur les 7 derniers jours.

**🔍 Détection d'anomalies :**
${
  parseInt(errorCount) > 5
    ? `⚠️ **ATTENTION** - ${errorCount} erreurs détectées, au-dessus de la normale.`
    : `✅ **NORMAL** - Niveau d'erreurs acceptable (${errorCount} erreurs).`
}

*Analyse générée le ${new Date().toLocaleString("fr-FR")}*`
}

export default function LogsPage() {
  const [logs, setLogs] = React.useState<LogEntry[]>([])
  const [loading, setLoading] = React.useState(true)
  const [searchTerm, setSearchTerm] = React.useState("")
  const [typeFilter, setTypeFilter] = React.useState<string>("all")
  const [statusFilter, setStatusFilter] = React.useState<string>("all")
  const [selectedLog, setSelectedLog] = React.useState<LogEntry | null>(null)
  const [page, setPage] = React.useState(1)
  const [limit, setLimit] = React.useState(10)
  const [total, setTotal] = React.useState(0)
  const [sortField, setSortField] = React.useState("timestamp")
  const [order, setOrder] = React.useState<"asc" | "desc">("desc")
  const [exportSize, setExportSize] = React.useState<number | null>(null)
  const [exporting, setExporting] = React.useState(false)
  const [downloadingOne, setDownloadingOne] = React.useState(false)
  const { toast } = useToast()
  const { setError, clearError } = useErrors()

  const fetchLogs = React.useCallback(async () => {
    try {
      setLoading(true)
      const res = await listLogs({
        search: searchTerm || undefined,
        sort: sortField,
        order,
        page,
        limit,
      })
      setLogs(res.items)
      setTotal(res.total_after_filter)
      clearError("logs")
    } catch (err) {
      setError("logs", { message: "Impossible de charger les logs", detailsUrl: "/logs" })
    } finally {
      setLoading(false)
    }
  }, [searchTerm, sortField, order, page, limit, clearError, setError])

  React.useEffect(() => {
    const timeout = setTimeout(() => {
      fetchLogs()
    }, 300)
    return () => clearTimeout(timeout)
  }, [fetchLogs])

  React.useEffect(() => {
    estimateLogsExportSize({
      search: searchTerm || undefined,
      sort: sortField,
      order,
      type: typeFilter !== "all" ? typeFilter : undefined,
      status: statusFilter !== "all" ? statusFilter : undefined,
    })
      .then((size) => setExportSize(size))
      .catch(() => setExportSize(null))
  }, [searchTerm, sortField, order, typeFilter, statusFilter])

  const filteredLogs = logs.filter((log) => {
    const matchesType = typeFilter === "all" || log.type === typeFilter
    const matchesStatus = statusFilter === "all" || log.status === statusFilter
    return matchesType && matchesStatus
  })

  const getActionIcon = (type: string) => {
    switch (type) {
      case "deployment":
        return <Settings className="h-4 w-4 text-primary" />
      case "deletion":
        return <Trash2 className="h-4 w-4 text-destructive" />
      case "error":
        return <AlertTriangle className="h-4 w-4 text-destructive" />
      case "restart":
        return <RefreshCw className="h-4 w-4 text-warning" />
      case "user_creation":
        return <User className="h-4 w-4 text-success" />
      case "role_change":
        return <User className="h-4 w-4 text-info" />
      case "vm_action":
        return <Server className="h-4 w-4 text-primary" />
      case "script_execution":
        return <FileText className="h-4 w-4 text-info" />
      default:
        return <FileText className="h-4 w-4" />
    }
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "success":
        return <CheckCircle className="h-4 w-4 text-success" />
      case "error":
        return <XCircle className="h-4 w-4 text-destructive" />
      case "warning":
        return <AlertTriangle className="h-4 w-4 text-warning" />
      default:
        return <FileText className="h-4 w-4" />
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case "success":
        return "success"
      case "error":
        return "destructive"
      case "warning":
        return "warning"
      default:
        return "default"
    }
  }

  const handleExport = async () => {
    try {
      setExporting(true)
      const res = await fetchLogsExport({
        search: searchTerm || undefined,
        sort: sortField,
        order,
        type: typeFilter !== "all" ? typeFilter : undefined,
        status: statusFilter !== "all" ? statusFilter : undefined,
      })
      const url = URL.createObjectURL(res)
      const a = document.createElement("a")
      a.href = url
      a.download = `logs_export_${new Date().toISOString().split("T")[0]}.ndjson`
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
      toast({ title: "Export réussi", description: "Les logs filtrés ont été exportés", variant: "success" })
    } catch (err) {
      setError("logs", { message: "Impossible d'exporter les logs", detailsUrl: "/logs" })
    } finally {
      setExporting(false)
    }
  }

  const handleDownloadSelectedLog = async () => {
    if (!selectedLog) return
    try {
      setDownloadingOne(true)
      const { blob, filename } = await fetchLogFile(selectedLog.id)
      const url = URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      const fallback =
        `${(selectedLog.action || "log")}`.toLowerCase().replace(/\s+/g, "_").replace(/[^a-z0-9._-]/g, "") +
        `_${new Date(selectedLog.timestamp).toISOString().replace(/[:.]/g, "-")}` +
        `.log`
      a.download = filename || fallback
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
      toast({ title: "Téléchargement lancé", description: "Le log a été téléchargé.", variant: "success" })
    } catch (err) {
      setError("logs", { message: "Impossible de télécharger ce log", detailsUrl: "/logs" })
    } finally {
      setDownloadingOne(false)
    }
  }

  const formatBytes = (bytes: number) => {
    if (!bytes) return "0 B"
    const sizes = ["B", "KB", "MB", "GB", "TB"]
    const i = Math.floor(Math.log(bytes) / Math.log(1024))
    return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`
  }

  const stats = {
    total,
    success: logs.filter((log) => log.status === "success").length,
    error: logs.filter((log) => log.status === "error").length,
    warning: logs.filter((log) => log.status === "warning").length,
  }

  const aiContext = `Total: ${stats.total} logs, Succès: ${stats.success}, Erreurs: ${stats.error}, Avertissements: ${stats.warning}. Types d'actions: déploiements, suppressions, redémarrages, gestion utilisateurs.`

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Logs action</h1>
        <div className="flex gap-3 items-center">
          <Button onClick={fetchLogs} variant="outline" size="sm" className="rounded-xl">
            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
            Actualiser
          </Button>
          <Button onClick={handleExport} variant="outline" size="sm" className="rounded-xl" disabled={exporting}>
            {exporting ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Download className="mr-2 h-4 w-4" />}
            {exporting ? "Export en cours..." : `Télécharger${exportSize !== null ? ` (${formatBytes(exportSize)})` : ""}`}
          </Button>
        </div>
      </div>

      <ErrorBanner id="logs" />

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Total</p>
                <p className="text-2xl font-bold">{stats.total}</p>
              </div>
              <FileText className="h-8 w-8 text-muted-foreground" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Succès</p>
                <p className="text-2xl font-bold text-success">{stats.success}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-success" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Erreurs</p>
                <p className="text-2xl font-bold text-destructive">{stats.error}</p>
              </div>
              <XCircle className="h-8 w-8 text-destructive" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Avertissements</p>
                <p className="text-2xl font-bold text-warning">{stats.warning}</p>
              </div>
              <AlertTriangle className="h-8 w-8 text-warning" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filtres */}
      <div className="flex gap-4 flex-wrap">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher dans les logs..."
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value)
              setPage(1)
            }}
            className="pl-10 rounded-xl"
          />
        </div>
        <Select
          value={sortField}
          onValueChange={(v) => {
            setSortField(v)
            setPage(1)
          }}
        >
          <SelectTrigger className="w-40 rounded-xl">
            <SelectValue placeholder="Trier par" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="timestamp">Date</SelectItem>
            <SelectItem value="host">Hôte</SelectItem>
            <SelectItem value="level">Niveau</SelectItem>
            <SelectItem value="source">Source</SelectItem>
          </SelectContent>
        </Select>
        <Button
          variant="outline"
          size="icon"
          onClick={() => {
            setOrder(order === "asc" ? "desc" : "asc")
            setPage(1)
          }}
          className="rounded-xl"
        >
          <ArrowUpDown className="h-4 w-4" />
        </Button>
        <Select value={typeFilter} onValueChange={setTypeFilter}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Type d'action" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les types</SelectItem>
            <SelectItem value="deployment">Déploiements</SelectItem>
            <SelectItem value="deletion">Suppressions</SelectItem>
            <SelectItem value="error">Erreurs</SelectItem>
            <SelectItem value="restart">Redémarrages</SelectItem>
            <SelectItem value="user_creation">Création utilisateur</SelectItem>
            <SelectItem value="role_change">Changement rôle</SelectItem>
            <SelectItem value="vm_action">Actions VM</SelectItem>
            <SelectItem value="script_execution">Scripts</SelectItem>
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Statut" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les statuts</SelectItem>
            <SelectItem value="success">Succès</SelectItem>
            <SelectItem value="error">Erreurs</SelectItem>
            <SelectItem value="warning">Avertissements</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Timeline */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Timeline des événements
          </CardTitle>
          <CardDescription>
            {filteredLogs.length} entrée(s) trouvée(s) sur {total} au total
          </CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <Loader2 className="h-8 w-8 animate-spin" />
              <span className="ml-2">Chargement des logs...</span>
            </div>
          ) : (
            <div className="space-y-4 max-h-96 overflow-y-auto">
              {filteredLogs.map((log, index) => (
                <motion.div
                  key={log.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ duration: 0.3, delay: index * 0.05 }}
                  className="flex items-start gap-4 p-4 border rounded-xl hover:bg-muted/50 transition-colors cursor-pointer"
                  onClick={() => setSelectedLog(log)}
                >
                  <div className="flex items-center gap-2 mt-1">
                    {getActionIcon(log.type)}
                    {getStatusIcon(log.status)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between mb-1">
                      <h4 className="font-medium">{log.action}</h4>
                      <div className="flex items-center gap-2">
                        <Badge variant={getStatusColor(log.status)} className="text-xs capitalize">
                          {log.status}
                        </Badge>
                        <span className="text-xs text-muted-foreground">
                          {new Date(log.timestamp).toLocaleString("fr-FR")}
                        </span>
                      </div>
                    </div>
                    <p className="text-sm text-muted-foreground mb-1 line-clamp-1">{log.description}</p>
                    <div className="flex items-center gap-4 text-xs text-muted-foreground">
                      <span>👤 {log.user}</span>
                      {log.entity && <span>🎯 {log.entity}</span>}
                      {log.ip_address && (
                        <span className="inline-flex items-center gap-1">
                          <Globe className="h-3 w-3" />
                          {log.ip_address}
                        </span>
                      )}
                    </div>
                  </div>
                  <Button variant="ghost" size="sm" className="rounded-xl">
                    <Eye className="h-4 w-4" />
                  </Button>
                </motion.div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Pagination */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPage((p) => Math.max(1, p - 1))}
            disabled={page === 1}
            className="rounded-xl"
          >
            Précédent
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPage((p) => p + 1)}
            disabled={page >= Math.ceil(total / limit)}
            className="rounded-xl"
          >
            Suivant
          </Button>
        </div>
        <div className="flex items-center gap-2">
          <span>
            Page {page} / {Math.max(1, Math.ceil(total / limit))}
          </span>
          <Select
            value={String(limit)}
            onValueChange={(v) => {
              setLimit(Number(v))
              setPage(1)
            }}
          >
            <SelectTrigger className="w-20 rounded-xl">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="10">10</SelectItem>
              <SelectItem value="25">25</SelectItem>
              <SelectItem value="50">50</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>

      {/* Modal Détail Log */}
      <Dialog open={!!selectedLog} onOpenChange={(open) => !open && setSelectedLog(null)}>
        <DialogContent className="max-w-2xl">
          {/* titres requis par Radix, masqués visuellement */}
          <DialogHeader>
            <VisuallyHidden>
              <DialogTitle>Détails du log {selectedLog ? `#${selectedLog.id}` : ""}</DialogTitle>
            </VisuallyHidden>
            <VisuallyHidden>
              <DialogDescription>Consulter et télécharger le log sélectionné.</DialogDescription>
            </VisuallyHidden>
          </DialogHeader>

          {/* CONTENU VISUEL RÉEL DU MODAL */}
          {selectedLog && (
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  {getActionIcon(selectedLog.type)}
                  <h3 className="text-lg font-semibold">{selectedLog.action || "Action inconnue"}</h3>
                </div>
                <Badge variant={getStatusColor(selectedLog.status)} className="capitalize">
                  {selectedLog.status}
                </Badge>
              </div>

              <div className="grid sm:grid-cols-2 gap-3 text-sm">
                <div className="flex items-center gap-2 text-muted-foreground">
                  <Hash className="h-4 w-4" />
                  <span>ID :</span>
                  <span className="font-medium text-foreground truncate">{selectedLog.id}</span>
                </div>
                <div className="flex items-center gap-2 text-muted-foreground">
                  <FileText className="h-4 w-4" />
                  <span>Date :</span>
                  <span className="font-medium text-foreground">
                    {new Date(selectedLog.timestamp).toLocaleString("fr-FR")}
                  </span>
                </div>
                <div className="flex items-center gap-2 text-muted-foreground">
                  <User className="h-4 w-4" />
                  <span>Utilisateur :</span>
                  <span className="font-medium text-foreground">{selectedLog.user || "—"}</span>
                </div>
                <div className="flex items-center gap-2 text-muted-foreground">
                  <Server className="h-4 w-4" />
                  <span>Entité :</span>
                  <span className="font-medium text-foreground">{selectedLog.entity || "—"}</span>
                </div>
                {selectedLog.ip_address && (
                  <div className="flex items-center gap-2 text-muted-foreground sm:col-span-2">
                    <Globe className="h-4 w-4" />
                    <span>Adresse IP :</span>
                    <span className="font-medium text-foreground">{selectedLog.ip_address}</span>
                  </div>
                )}
              </div>

              {selectedLog.description && (
                <>
                  <Separator />
                  <div>
                    <p className="text-xs uppercase tracking-wide text-muted-foreground mb-1">Description</p>
                    <p className="text-sm">{selectedLog.description}</p>
                  </div>
                </>
              )}

              {/* Affiche les "détails techniques" si présents dans l'objet log */}
              {"details" in selectedLog && (selectedLog as any).details && (
                <>
                  <Separator />
                  <div>
                    <p className="text-xs uppercase tracking-wide text-muted-foreground mb-1">
                      Détails techniques
                    </p>
                    <pre className="text-xs max-h-60 overflow-auto rounded-md bg-muted p-3">
                      {typeof (selectedLog as any).details === "string"
                        ? (selectedLog as any).details
                        : JSON.stringify((selectedLog as any).details, null, 2)}
                    </pre>
                  </div>
                </>
              )}

              {/* Affiche un éventuel "query" (comme sur tes captures) */}
              {"query" in selectedLog && (selectedLog as any).query && (
                <>
                  <Separator />
                  <div>
                    <p className="text-xs uppercase tracking-wide text-muted-foreground mb-1">Requête</p>
                    <pre className="text-xs max-h-60 overflow-auto rounded-md bg-muted p-3">
                      {typeof (selectedLog as any).query === "string"
                        ? (selectedLog as any).query
                        : JSON.stringify((selectedLog as any).query, null, 2)}
                    </pre>
                  </div>
                </>
              )}
            </div>
          )}

          <DialogFooter className="pt-4">
            {selectedLog?.vm_id && (
              <Button variant="outline" size="sm" className="rounded-xl" asChild>
                <a href={`/monitoring/${selectedLog.vm_id}`}>
                  <Server className="mr-2 h-4 w-4" />
                  Voir la VM
                </a>
              </Button>
            )}
            <Button
              variant="outline"
              size="sm"
              className="rounded-xl"
              onClick={handleDownloadSelectedLog}
              disabled={downloadingOne}
            >
              {downloadingOne ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : <Download className="mr-2 h-4 w-4" />}
              {downloadingOne ? "Téléchargement..." : "Télécharger log"}
            </Button>
            <DialogClose asChild>
              <Button size="sm" className="rounded-xl">
                Fermer
              </Button>
            </DialogClose>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Bloc IA */}
      <AssistantAIBlock title="Analyse IA des logs système" context={aiContext} onAnalyze={simulateLogsAIAnalysis} />
    </div>
  )
}
