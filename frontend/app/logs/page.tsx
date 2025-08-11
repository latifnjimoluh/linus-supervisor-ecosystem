"use client"

import * as React from "react"
import { Search, Filter, Download, RefreshCw, Eye, Calendar, User, Settings, Trash2, Server, AlertTriangle, CheckCircle, XCircle, FileText, Loader2, Bot } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { useToast } from "@/hooks/use-toast"
import { listLogs, exportLogs as fetchLogsExport, LogEntry } from "@/services/logs"

// Simulate AI analysis for logs
const simulateLogsAIAnalysis = async (context: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 2500))
  
  const errorCount = (context.match(/erreurs: (\d+)/)?.[1]) || "0"
  const totalLogs = (context.match(/Total: (\d+)/)?.[1]) || "0"
  
  return `🤖 **Analyse IA des logs système**

**📊 Vue d'ensemble:**
Analyse de ${totalLogs} entrées de logs sur les 7 derniers jours.

**🔍 Détection d'anomalies:**
${parseInt(errorCount) > 5 ? 
  `⚠️ **ATTENTION** - ${errorCount} erreurs détectées, ce qui est supérieur à la normale.\n\n**Erreurs principales identifiées:**\n- Timeouts de connexion réseau\n- Échecs de déploiement VM\n- Erreurs de scripts automatisés\n\n**Actions recommandées:**\n1. Vérifier la configuration réseau\n2. Analyser les logs de déploiement en détail\n3. Revoir les scripts en échec` :
  `✅ **NORMAL** - Niveau d'erreurs acceptable (${errorCount} erreurs).`
}

**📈 Tendances observées:**
- Pic d'activité de déploiement entre 14h-16h
- Redémarrages programmés principalement le weekend
- Activité utilisateur concentrée en journée

**🎯 Recommandations:**
1. **Surveillance proactive** : Mettre en place des alertes pour les erreurs critiques
2. **Optimisation** : Planifier les déploiements en dehors des heures de pointe
3. **Maintenance** : Programmer les redémarrages pendant les créneaux de faible activité

**🔧 Actions suggérées:**
- Exporter les logs d'erreur pour analyse approfondie
- Configurer des notifications automatiques
- Planifier une revue hebdomadaire des tendances

*Analyse générée le ${new Date().toLocaleString('fr-FR')}*`
}

export default function LogsPage() {
  const [logs, setLogs] = React.useState<LogEntry[]>([])
  const [loading, setLoading] = React.useState(true)
  const [searchTerm, setSearchTerm] = React.useState("")
  const [typeFilter, setTypeFilter] = React.useState<string>("all")
  const [statusFilter, setStatusFilter] = React.useState<string>("all")
  const [selectedLog, setSelectedLog] = React.useState<LogEntry | null>(null)
  const [page, setPage] = React.useState(1)
  const [pageSize, setPageSize] = React.useState(10)
  const [total, setTotal] = React.useState(0)
  const [exportFormat, setExportFormat] = React.useState<"csv" | "json" | "">("")
  const { toast } = useToast()

  const fetchLogs = React.useCallback(async () => {
    try {
      setLoading(true)
      const res = await listLogs({ q: searchTerm || undefined, page, pageSize })
      setLogs(res.results)
      setTotal(res.total)
    } catch (err) {
      console.error('Erreur chargement logs', err)
    } finally {
      setLoading(false)
    }
  }, [searchTerm, page, pageSize])

  React.useEffect(() => {
    const timeout = setTimeout(() => {
      fetchLogs()
    }, 300)
    return () => {
      clearTimeout(timeout)
    }
  }, [fetchLogs])

  const filteredLogs = logs.filter(log => {
    const matchesType = typeFilter === "all" || log.type === typeFilter
    const matchesStatus = statusFilter === "all" || log.status === statusFilter
    return matchesType && matchesStatus
  })

  const getActionIcon = (type: string) => {
    switch (type) {
      case "deployment": return <Settings className="h-4 w-4 text-primary" />
      case "deletion": return <Trash2 className="h-4 w-4 text-destructive" />
      case "error": return <AlertTriangle className="h-4 w-4 text-destructive" />
      case "restart": return <RefreshCw className="h-4 w-4 text-warning" />
      case "user_creation": return <User className="h-4 w-4 text-success" />
      case "role_change": return <User className="h-4 w-4 text-info" />
      case "vm_action": return <Server className="h-4 w-4 text-primary" />
      case "script_execution": return <FileText className="h-4 w-4 text-info" />
      default: return <FileText className="h-4 w-4" />
    }
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "success": return <CheckCircle className="h-4 w-4 text-success" />
      case "error": return <XCircle className="h-4 w-4 text-destructive" />
      case "warning": return <AlertTriangle className="h-4 w-4 text-warning" />
      default: return <FileText className="h-4 w-4" />
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case "success": return "success"
      case "error": return "destructive"
      case "warning": return "warning"
      default: return "default"
    }
  }

  const handleExport = async () => {
    if (!exportFormat) return
    try {
      const blob = await fetchLogsExport(exportFormat)
      const url = URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      a.download = `logs_export_${new Date().toISOString().split('T')[0]}.${exportFormat}`
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
      toast({
        title: "Export réussi",
        description: `Les logs ont été exportés en ${exportFormat.toUpperCase()}`,
        variant: "success",
      })
    } catch (err) {
      toast({
        title: "Erreur export",
        description: "Impossible d'exporter les logs",
        variant: "destructive",
      })
    }
  }

  const stats = {
    total,
    success: logs.filter(log => log.status === "success").length,
    error: logs.filter(log => log.status === "error").length,
    warning: logs.filter(log => log.status === "warning").length,
  }

  const aiContext = `Total: ${stats.total} logs, Succès: ${stats.success}, Erreurs: ${stats.error}, Avertissements: ${stats.warning}. Types d'actions: déploiements, suppressions, redémarrages, gestion utilisateurs.`

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Historique global des actions</h1>
        <div className="flex gap-3 items-center">
          <Button onClick={fetchLogs} variant="outline" size="sm" className="rounded-xl">
            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
            Actualiser
          </Button>
          <div className="flex items-center gap-2">
            <Select value={exportFormat} onValueChange={(v) => setExportFormat(v as "csv" | "json")}>
              <SelectTrigger className="w-32 rounded-xl">
                <Download className="mr-2 h-4 w-4" />
                <SelectValue placeholder="Format" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="csv">CSV</SelectItem>
                <SelectItem value="json">JSON</SelectItem>
              </SelectContent>
            </Select>
            {exportFormat && (
              <Button onClick={handleExport} variant="outline" size="sm" className="rounded-xl">
                Télécharger
              </Button>
            )}
          </div>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
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

      {/* Filters */}
      <div className="flex gap-4 flex-wrap">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher dans les logs..."
            value={searchTerm}
            onChange={(e) => { setSearchTerm(e.target.value); setPage(1); }}
            className="pl-10 rounded-xl"
          />
        </div>
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

      {/* Logs Timeline */}
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
                        <Badge variant={getStatusColor(log.status)} className="text-xs">
                          {log.status}
                        </Badge>
                        <span className="text-xs text-muted-foreground">
                          {new Date(log.timestamp).toLocaleString("fr-FR")}
                        </span>
                      </div>
                    </div>
                    <p className="text-sm text-muted-foreground mb-1">{log.description}</p>
                    <div className="flex items-center gap-4 text-xs text-muted-foreground">
                      <span>👤 {log.user}</span>
                      <span>🎯 {log.entity}</span>
                      {log.ip_address && <span>🌐 {log.ip_address}</span>}
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

      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPage(p => Math.max(1, p - 1))}
            disabled={page === 1}
            className="rounded-xl"
          >
            Précédent
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPage(p => p + 1)}
            disabled={page >= Math.ceil(total / pageSize)}
            className="rounded-xl"
          >
            Suivant
          </Button>
        </div>
        <div className="flex items-center gap-2">
          <span>
            Page {page} / {Math.max(1, Math.ceil(total / pageSize))}
          </span>
          <Select value={String(pageSize)} onValueChange={(v) => { setPageSize(Number(v)); setPage(1); }}>
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

      {/* Log Detail Dialog */}
      <Dialog open={!!selectedLog} onOpenChange={() => setSelectedLog(null)}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              {selectedLog && getActionIcon(selectedLog.type)}
              Détails du log
            </DialogTitle>
            <DialogDescription>
              Informations complètes sur l'événement sélectionné
            </DialogDescription>
          </DialogHeader>
          {selectedLog && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="text-sm font-medium">Action</label>
                  <p className="text-sm text-muted-foreground">{selectedLog.action}</p>
                </div>
                <div>
                  <label className="text-sm font-medium">Statut</label>
                  <Badge variant={getStatusColor(selectedLog.status)} className="text-xs ml-2">
                    {selectedLog.status}
                  </Badge>
                </div>
                <div>
                  <label className="text-sm font-medium">Utilisateur</label>
                  <p className="text-sm text-muted-foreground">{selectedLog.user}</p>
                </div>
                <div>
                  <label className="text-sm font-medium">Entité</label>
                  <p className="text-sm text-muted-foreground">{selectedLog.entity}</p>
                </div>
                <div>
                  <label className="text-sm font-medium">Horodatage</label>
                  <p className="text-sm text-muted-foreground">
                    {new Date(selectedLog.timestamp).toLocaleString("fr-FR")}
                  </p>
                </div>
                {selectedLog.ip_address && (
                  <div>
                    <label className="text-sm font-medium">Adresse IP</label>
                    <p className="text-sm text-muted-foreground">{selectedLog.ip_address}</p>
                  </div>
                )}
              </div>
              <div>
                <label className="text-sm font-medium">Description</label>
                <p className="text-sm text-muted-foreground mt-1">{selectedLog.description}</p>
              </div>
              {selectedLog.details && (
                <div>
                  <label className="text-sm font-medium">Détails techniques</label>
                  <div className="mt-1 p-3 bg-muted rounded-lg">
                    <code className="text-xs">{selectedLog.details}</code>
                  </div>
                </div>
              )}
              <div className="flex gap-2 pt-4 border-t">
                <Button variant="outline" size="sm" className="rounded-xl">
                  <Download className="mr-2 h-4 w-4" />
                  Télécharger log
                </Button>
                {selectedLog.vm_id && (
                  <Button variant="outline" size="sm" className="rounded-xl" asChild>
                    <a href={`/monitoring/${selectedLog.vm_id}`}>
                      <Server className="mr-2 h-4 w-4" />
                      Voir la VM
                    </a>
                  </Button>
                )}
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* AI Analysis Block */}
      <AssistantAIBlock
        title="Analyse IA des logs système"
        context={aiContext}
        onAnalyze={simulateLogsAIAnalysis}
        className="w-full"
      />
    </div>
  )
}
