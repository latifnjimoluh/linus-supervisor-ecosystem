"use client"

import * as React from "react"
import { useParams, useRouter } from "next/navigation"
import { CheckCircle, XCircle, Loader2, Clock, Server, FileText, ChevronLeft, Copy, Check } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ScrollArea } from "@/components/ui/scroll-area"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"

interface DeploymentLog {
  timestamp: string
  level: "INFO" | "WARN" | "ERROR" | "SUCCESS"
  message: string
}

interface DeploymentStatus {
  id: string
  vmName: string
  template: string
  status: "pending" | "in_progress" | "completed" | "failed"
  startTime: Date
  endTime?: Date
  logs: DeploymentLog[]
}

const mockDeploymentData = (id: string): DeploymentStatus => {
  const startTime = new Date(Date.now() - Math.random() * 3600 * 1000) // Up to 1 hour ago
  const statusOptions = ["pending", "in_progress", "completed", "failed"]
  const randomStatus = statusOptions[Math.floor(Math.random() * statusOptions.length)]

  const logs: DeploymentLog[] = [
    { timestamp: new Date(startTime.getTime() + 1000).toISOString(), level: "INFO", message: `[${id}] Démarrage du déploiement pour Web-Prod-01...` },
    { timestamp: new Date(startTime.getTime() + 5000).toISOString(), level: "INFO", message: `[${id}] Initialisation du template ubuntu-22.04-template.` },
    { timestamp: new Date(startTime.getTime() + 10000).toISOString(), level: "INFO", message: `[${id}] Allocation des ressources (RAM: 2048MB, CPU: 2 coeurs, Disque: 20GB).` },
    { timestamp: new Date(startTime.getTime() + 15000).toISOString(), level: "INFO", message: `[${id}] Configuration réseau: IP dynamique attribuée.` },
  ]

  if (randomStatus === "in_progress") {
    logs.push(
      { timestamp: new Date(startTime.getTime() + 20000).toISOString(), level: "INFO", message: `[${id}] Exécution du script 'Initialisation SSH'.` },
      { timestamp: new Date(startTime.getTime() + 25000).toISOString(), level: "INFO", message: `[${id}] Exécution du script 'Mise à jour système'.` },
      { timestamp: new Date(startTime.getTime() + 30000).toISOString(), level: "WARN", message: `[${id}] Avertissement: Paquet 'unzip' non trouvé, installation ignorée.` },
    )
  } else if (randomStatus === "completed") {
    logs.push(
      { timestamp: new Date(startTime.getTime() + 20000).toISOString(), level: "INFO", message: `[${id}] Exécution du script 'Initialisation SSH'.` },
      { timestamp: new Date(startTime.getTime() + 25000).toISOString(), level: "INFO", message: `[${id}] Exécution du script 'Mise à jour système'.` },
      { timestamp: new Date(startTime.getTime() + 30000).toISOString(), level: "INFO", message: `[${id}] Exécution du script 'Configuration Nginx'.` },
      { timestamp: new Date(startTime.getTime() + 35000).toISOString(), level: "SUCCESS", message: `[${id}] Déploiement de Web-Prod-01 terminé avec succès.` },
    )
  } else if (randomStatus === "failed") {
    logs.push(
      { timestamp: new Date(startTime.getTime() + 20000).toISOString(), level: "INFO", message: `[${id}] Exécution du script 'Initialisation SSH'.` },
      { timestamp: new Date(startTime.getTime() + 25000).toISOString(), level: "ERROR", message: `[${id}] Erreur critique: Échec de l'installation de Nginx. Code de sortie 1.` },
      { timestamp: new Date(startTime.getTime() + 26000).toISOString(), level: "ERROR", message: `[${id}] Déploiement de Web-Prod-01 a échoué.` },
    )
  }

  return {
    id: id,
    vmName: "Web-Prod-01",
    template: "ubuntu-22.04-template",
    status: randomStatus as DeploymentStatus['status'],
    startTime: startTime,
    endTime: randomStatus !== "in_progress" ? new Date(startTime.getTime() + logs.length * 5000) : undefined,
    logs: logs,
  }
}

export default function DeploymentDetailsPage() {
  const params = useParams()
  const router = useRouter()
  const deploymentId = params.id as string
  const [deployment, setDeployment] = React.useState<DeploymentStatus | null>(null)
  const [loading, setLoading] = React.useState(true)
  const [copiedLog, setCopiedLog] = React.useState<string | null>(null)
  const { toast } = useToast()
  const scrollAreaRef = React.useRef<HTMLDivElement>(null)

  const fetchDeploymentDetails = React.useCallback(() => {
    setLoading(true)
    // Simulate fetching data
    setTimeout(() => {
      setDeployment(mockDeploymentData(deploymentId))
      setLoading(false)
    }, 1000)
  }, [deploymentId])

  React.useEffect(() => {
    fetchDeploymentDetails()
  }, [fetchDeploymentDetails])

  // Auto-scroll to bottom of logs
  React.useEffect(() => {
    if (scrollAreaRef.current) {
      scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight
    }
  }, [deployment?.logs])

  const getStatusBadge = (status: DeploymentStatus['status']) => {
    switch (status) {
      case "pending": return <Badge variant="secondary" className="bg-blue-500/20 text-blue-600">En attente</Badge>
      case "in_progress": return <Badge variant="secondary" className="bg-yellow-500/20 text-yellow-600 animate-pulse">En cours...</Badge>
      case "completed": return <Badge variant="success">Terminé</Badge>
      case "failed": return <Badge variant="destructive">Échec</Badge>
      default: return <Badge variant="secondary">Inconnu</Badge>
    }
  }

  const getLogLevelColor = (level: DeploymentLog['level']) => {
    switch (level) {
      case "INFO": return "text-blue-400"
      case "WARN": return "text-yellow-400"
      case "ERROR": return "text-red-500"
      case "SUCCESS": return "text-green-500"
      default: return "text-muted-foreground"
    }
  }

  const copyLogContent = (content: string) => {
    navigator.clipboard.writeText(content)
    setCopiedLog(content)
    toast({ title: "Copié !", description: "Contenu du log copié.", variant: "success" })
    setTimeout(() => setCopiedLog(null), 2000)
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
            Déploiement: {deployment.vmName}
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
              <span>{new Date(deployment.startTime).toLocaleString('fr-FR')}</span>
            </div>
          </div>
          {deployment.endTime && (
            <div className="space-y-2">
              <p className="text-sm text-muted-foreground">Fin du déploiement</p>
              <div className="flex items-center gap-2">
                <Clock className="h-4 w-4 text-muted-foreground" />
                <span>{new Date(deployment.endTime).toLocaleString('fr-FR')}</span>
              </div>
            </div>
          )}
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Journaux de déploiement
          </CardTitle>
          <CardDescription>
            Suivi en temps réel des étapes du déploiement.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <ScrollArea className="h-[400px] border rounded-xl p-4 bg-muted/20 font-mono text-sm relative" ref={scrollAreaRef}>
            <AnimatePresence initial={false}>
              {deployment.logs.map((log, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.2, delay: index * 0.05 }}
                  className="flex items-start gap-2 py-1 group"
                >
                  <span className="text-muted-foreground shrink-0">
                    [{new Date(log.timestamp).toLocaleTimeString('fr-FR')}]
                  </span>
                  <span className={cn("flex-1", getLogLevelColor(log.level))}>
                    {log.message}
                  </span>
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => copyLogContent(log.message)}
                    className="h-6 w-6 opacity-0 group-hover:opacity-100 transition-opacity"
                  >
                    {copiedLog === log.message ? <Check className="h-3 w-3 text-green-500" /> : <Copy className="h-3 w-3" />}
                  </Button>
                </motion.div>
              ))}
            </AnimatePresence>
            {deployment.status === "in_progress" && (
              <div className="flex items-center gap-2 text-muted-foreground mt-4">
                <Loader2 className="h-4 w-4 animate-spin" />
                <span>Déploiement en cours...</span>
              </div>
            )}
          </ScrollArea>
        </CardContent>
      </Card>

      <div className="flex justify-end gap-4">
        <Button variant="outline" onClick={() => router.push("/deploy")} className="rounded-xl">
          Fermer
        </Button>
        {deployment.status === "failed" && (
          <Button variant="destructive" className="rounded-xl">
            Retenter le déploiement
          </Button>
        )}
        {deployment.status === "completed" && (
          <Button className="rounded-xl">
            Accéder à la VM
          </Button>
        )}
      </div>
    </div>
  )
}
