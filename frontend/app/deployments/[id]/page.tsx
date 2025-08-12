"use client"

import * as React from "react"
import { useParams, useRouter } from "next/navigation"
import { XCircle, Loader2, Clock, Server, FileText, ChevronLeft, Copy } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ScrollArea } from "@/components/ui/scroll-area"
import { useToast } from "@/hooks/use-toast"
import { fetchDeployment, DeploymentDetail } from "@/services/deployments"

// --- Helpers d'affichage de log (clean & normalise) ---
const stripAnsi = (s: string) => s.replace(/\x1B\[[0-?]*[ -/]*[@-~]/g, "")
const normalizeForUI = (s: string) => stripAnsi(s).replace(/\r/g, "\n")

export default function DeploymentDetailsPage() {
  const params = useParams()
  const router = useRouter()
  const deploymentId = params.id as string
  const { toast } = useToast()

  const [deployment, setDeployment] = React.useState<DeploymentDetail | null>(null)
  const [loading, setLoading] = React.useState(true)
  const [streaming, setStreaming] = React.useState(false)
  const [friendlyError, setFriendlyError] = React.useState<string | null>(null)

  const scrollAreaRef = React.useRef<HTMLDivElement>(null)
  const pollRef = React.useRef<ReturnType<typeof setInterval> | null>(null)

  // Merge helper: ne JAMAIS réduire/vider le log en cours
  const safeMerge = React.useCallback((incoming: DeploymentDetail) => {
    setDeployment(prev => {
      if (!prev) return {
        ...incoming,
        log: incoming.log ? normalizeForUI(incoming.log) : null,
      }

      const merged: DeploymentDetail = { ...prev, ...incoming }
      const prevLog = prev.log || ""
      const incomingLog = normalizeForUI(incoming.log || "")

      // Si le serveur renvoie un log vide (ou plus court) pendant l’exécution, on garde l’ancien
      if (incomingLog.length === 0 || incomingLog.length < prevLog.length) {
        merged.log = prevLog
      } else {
        merged.log = incomingLog
      }
      return merged
    })
  }, [])

  const fetchDeploymentDetails = React.useCallback(async () => {
    try {
      const data = await fetchDeployment(deploymentId)
      safeMerge(data)
    } catch (e) {
      console.error("Erreur de récupération du déploiement", e)
    } finally {
      setLoading(false)
    }
  }, [deploymentId, safeMerge])

  // Chargement initial
  React.useEffect(() => {
    setLoading(true)
    fetchDeploymentDetails()
  }, [fetchDeploymentDetails])

  // Auto-scroll
  React.useEffect(() => {
    if (scrollAreaRef.current) {
      scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight
    }
  }, [deployment?.log])

  // SSE + Poll fallback (sans écraser les logs)
  React.useEffect(() => {
    if (!deploymentId) return

    // Poll fallback (démarre au début, s’arrête dès que le SSE s’ouvre)
    pollRef.current = setInterval(fetchDeploymentDetails, 5000)

    const baseUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000"
    const url = `${baseUrl}/deployments/${deploymentId}/stream`
    const es = new EventSource(url)

    es.onopen = () => {
      setStreaming(true)
      if (pollRef.current) { clearInterval(pollRef.current); pollRef.current = null }
    }

    es.addEventListener("status", (e: MessageEvent) => {
      const { status } = JSON.parse(e.data)
      setDeployment(d => (d ? { ...d, status } : d))
    })

    es.addEventListener("log", (e: MessageEvent) => {
      const { chunk } = JSON.parse(e.data)
      const clean = normalizeForUI(chunk)
      setDeployment(d => (d ? { ...d, log: (d.log || "") + clean } : d))
    })

    // message d’erreur “friendly” envoyé par le backend (ex: STORAGE_FULL)
    es.addEventListener("error", (e: MessageEvent) => {
      try {
        const { message } = JSON.parse(e.data)
        setFriendlyError(message || "Le déploiement a échoué.")
      } catch {
        setFriendlyError("Le déploiement a échoué.")
      }
    })

    es.addEventListener("done", () => {
      setStreaming(false)
      es.close()
      // Dernier fetch pour figer dates et statut
      fetchDeploymentDetails()
    })

    es.onerror = () => {
      // Si le SSE casse, on garde/relance le polling de secours
      setStreaming(false)
      if (!pollRef.current) pollRef.current = setInterval(fetchDeploymentDetails, 5000)
    }

    return () => {
      es.close()
      if (pollRef.current) { clearInterval(pollRef.current); pollRef.current = null }
    }
  }, [deploymentId, fetchDeploymentDetails])

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "in_progress":
        return <Badge variant="secondary" className="bg-yellow-500/20 text-yellow-600 animate-pulse">En cours…</Badge>
      case "completed":
      case "deployed":
        return <Badge variant="success">Terminé</Badge>
      case "failed":
        return <Badge variant="destructive">Échec</Badge>
      default:
        return <Badge variant="secondary">Inconnu</Badge>
    }
  }

  const copyLogs = () => {
    if (deployment?.log) {
      navigator.clipboard.writeText(deployment.log)
      toast({ title: "Copié !", description: "Contenu du log copié.", variant: "success" })
    }
  }

  if (loading && !deployment) {
    return (
      <div className="flex items-center justify-center min-h-[calc(100vh-150px)]">
        <Loader2 className="h-10 w-10 animate-spin text-primary" />
        <span className="ml-3 text-lg">Chargement des détails du déploiement...</span>
      </div>
    )
  }

  if (!deployment) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[calc(100vh-150px)] text-muted-foreground">
        <XCircle className="h-12 w-12 mb-4" />
        <h2 className="text-xl font-semibold mb-2">Déploiement introuvable</h2>
        <p className="mb-4">L'identifiant de déploiement "{deploymentId}" n'existe pas.</p>
        <Button onClick={() => router.push("/deploy")} className="rounded-xl">
          <ChevronLeft className="mr-2 h-4 w-4" /> Retour au déploiement
        </Button>
      </div>
    )
  }

  return (
    <div className="container mx-auto max-w-5xl px-4 py-4 space-y-6">
      <header className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.push("/deploy")} className="rounded-xl">
          <ChevronLeft className="h-5 w-5" />
          <span className="sr-only">Retour</span>
        </Button>
        <h1 className="text-3xl md:text-4xl font-bold tracking-tight">Suivi du Déploiement</h1>
      </header>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Server className="h-5 w-5" />
            Déploiement: {deployment.vm_name}
          </CardTitle>
          <CardDescription>ID: {deployment.id}</CardDescription>
        </CardHeader>
        <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <p className="text-sm text-muted-foreground">Statut actuel</p>
            <div className="flex items-center gap-2">
              {getStatusBadge(deployment.status)}
              {streaming && <span className="text-xs text-muted-foreground">(live)</span>}
            </div>
          </div>
          <div className="space-y-2">
            <p className="text-sm text-muted-foreground">Template utilisé</p>
            <p className="font-medium">{deployment.template}</p>
          </div>
          <div className="space-y-2">
            <p className="text-sm text-muted-foreground">Début du déploiement</p>
            <div className="flex items-center gap-2">
              <Clock className="h-4 w-4 text-muted-foreground" />
              <span>{deployment.started_at ? new Date(deployment.started_at).toLocaleString("fr-FR") : "N/A"}</span>
            </div>
          </div>
          {deployment.ended_at && (
            <div className="space-y-2">
              <p className="text-sm text-muted-foreground">Fin du déploiement</p>
              <div className="flex items-center gap-2">
                <Clock className="h-4 w-4 text-muted-foreground" />
                <span>{new Date(deployment.ended_at).toLocaleString("fr-FR")}</span>
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Bandeau d'alerte si erreur "friendly" */}
      {friendlyError && (
        <div className="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700 dark:border-red-900/40 dark:bg-red-900/20 dark:text-red-300">
          {friendlyError}
        </div>
      )}

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Logs du déploiement
          </CardTitle>
          <Button variant="outline" size="sm" onClick={copyLogs} className="rounded-xl">
            <Copy className="h-4 w-4 mr-2" />
            Copier
          </Button>
        </CardHeader>
        <CardContent>
          <ScrollArea className="h-96 rounded-xl border bg-slate-50/70 dark:bg-slate-900/40" ref={scrollAreaRef}>
            <pre
              className={[
                "p-4 whitespace-pre-wrap [overflow-wrap:anywhere]",
                // Police plus lisible (arbitrary value Tailwind)
                "[font-family:ui-monospace,Menlo,Consolas,Monaco,'Liberation Mono','Courier New',monospace]",
                "text-[13px] md:text-[14px] leading-relaxed tracking-[0.01em]",
                "text-slate-800 dark:text-slate-200",
              ].join(" ")}
            >
              {deployment.log}
            </pre>
          </ScrollArea>
        </CardContent>
      </Card>
    </div>
  )
}
