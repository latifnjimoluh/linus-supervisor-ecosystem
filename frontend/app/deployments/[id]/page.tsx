"use client"

import * as React from "react"
import { useParams, useRouter } from "next/navigation"
import { XCircle, Loader2, Clock, Server, FileText, ChevronLeft, Copy } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ScrollArea } from "@/components/ui/scroll-area"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"
import { fetchDeployment, DeploymentDetail } from "@/services/deployments"

export default function DeploymentDetailsPage() {
  const params = useParams()
  const router = useRouter()
  const deploymentId = params.id as string
  const { toast } = useToast()
  const [deployment, setDeployment] = React.useState<DeploymentDetail | null>(null)
  const [loading, setLoading] = React.useState(true)
  const scrollAreaRef = React.useRef<HTMLDivElement>(null)

  const fetchDeploymentDetails = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await fetchDeployment(deploymentId)
      setDeployment(data)
    } catch (e) {
      console.error('Erreur de récupération du déploiement', e)
    } finally {
      setLoading(false)
    }
  }, [deploymentId])

  React.useEffect(() => {
    fetchDeploymentDetails()
  }, [fetchDeploymentDetails])

  React.useEffect(() => {
    if (scrollAreaRef.current) {
      scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight
    }
  }, [deployment?.log])

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "in_progress":
        return <Badge variant="secondary" className="bg-yellow-500/20 text-yellow-600 animate-pulse">En cours..</Badge>
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

  if (loading) {
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
    <div className="space-y-6">
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
          <CardDescription>
            ID: {deployment.id}
          </CardDescription>
        </CardHeader>
        <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <p className="text-sm text-muted-foreground">Statut actuel</p>
            {getStatusBadge(deployment.status)}
          </div>
          <div className="space-y-2">
            <p className="text-sm text-muted-foreground">Template utilisé</p>
            <p className="font-medium">{deployment.template}</p>
          </div>
          <div className="space-y-2">
            <p className="text-sm text-muted-foreground">Début du déploiement</p>
            <div className="flex items-center gap-2">
              <Clock className="h-4 w-4 text-muted-foreground" />
              <span>{deployment.started_at ? new Date(deployment.started_at).toLocaleString('fr-FR') : 'N/A'}</span>
            </div>
          </div>
          {deployment.ended_at && (
            <div className="space-y-2">
              <p className="text-sm text-muted-foreground">Fin du déploiement</p>
              <div className="flex items-center gap-2">
                <Clock className="h-4 w-4 text-muted-foreground" />
                <span>{new Date(deployment.ended_at).toLocaleString('fr-FR')}</span>
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Logs du déploiement
          </CardTitle>
          <Button variant="outline" size="sm" onClick={copyLogs} className="rounded-xl">
            <Copy className="h-4 w-4 mr-2" />Copier
          </Button>
        </CardHeader>
        <CardContent>
          <ScrollArea className="h-96 rounded-xl border" ref={scrollAreaRef}>
            <pre className="p-4 text-sm whitespace-pre-wrap">
              {deployment.log}
            </pre>
          </ScrollArea>
        </CardContent>
      </Card>
    </div>
  )
}
