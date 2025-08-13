"use client"

import * as React from "react"
import {
  Server, Globe, HardDrive, Network, AlertTriangle, CheckCircle, Info,
  RefreshCw, Plus, Activity, Shield
} from "lucide-react"
import Link from "next/link"
import { motion } from "framer-motion"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { InlineBanner } from "@/components/ui/inline-banner"
import { cn } from "@/lib/utils"
import { getInfrastructureMap, type InfrastructureServer } from "@/services/dashboard"
import { useRouter } from "next/navigation"

const simulateMapAIAnalysis = async (context: string): Promise<string> => {
  await new Promise((r) => setTimeout(r, 2000))
  const prompt = `Tu es un assistant réseau. À partir des statistiques suivantes, résume l'état des zones et signale les priorités : ${context}`
  const m = context.match(/Serveurs affichés: (\d+), LAN: (\d+), WAN: (\d+), DMZ: (\d+), MGMT: (\d+), OK: (\d+), Alerte: (\d+), Hors supervision: (\d+)/)
  const total = m ? parseInt(m[1]) : 0
  const lan = m ? parseInt(m[2]) : 0
  const wan = m ? parseInt(m[3]) : 0
  const dmz = m ? parseInt(m[4]) : 0
  const mgmt = m ? parseInt(m[5]) : 0
  const ok = m ? parseInt(m[6]) : 0
  const alert = m ? parseInt(m[7]) : 0
  const unsupervised = m ? parseInt(m[8]) : 0

  return `🤖 **Analyse IA de la carte d'infrastructure**\n\n${total} serveurs : LAN ${lan}, WAN ${wan}, DMZ ${dmz}, MGMT ${mgmt}. Statuts — OK ${ok}, Alerte ${alert}, Hors supervision ${unsupervised}.\n\n**Actions recommandées :**\n- Inspecter les ${alert} serveur(s) en alerte\n- Vérifier la supervision de ${unsupervised} hôte(s)\n\n*Prompt utilisé :* ${prompt}`
}

export default function InfrastructureMapPage() {
  const [servers, setServers] = React.useState<InfrastructureServer[]>([])
  const [status, setStatus] = React.useState<"ok" | "degraded">("ok")
  const [errors, setErrors] = React.useState<string[]>([])
  const [loading, setLoading] = React.useState(true)
  const [filterZone, setFilterZone] = React.useState<"all" | "LAN" | "WAN" | "DMZ" | "MGMT">("all")
  const router = useRouter()

  const fetchServers = React.useCallback(() => {
    setLoading(true)
    getInfrastructureMap()
      .then((data) => {
        setServers(data.servers)
        setStatus(data.status)
        setErrors(data.errors || [])
      })
      .catch((err) => {
        setStatus("degraded")
        setErrors([err.message])
      })
      .finally(() => setLoading(false))
  }, [])

  React.useEffect(() => {
    fetchServers()
  }, [fetchServers])

  const filteredServers = servers.filter(
    (s) => !s.isTemplate && (filterZone === "all" || s.zone === filterZone)
  )

  const zoneSummary = { LAN: 0, WAN: 0, DMZ: 0, MGMT: 0 }
  const statusSummary = { ok: 0, alert: 0, unsupervised: 0 }
  filteredServers.forEach((s) => {
    zoneSummary[s.zone as keyof typeof zoneSummary]++
    statusSummary[s.status as keyof typeof statusSummary]++
  })

  const aiContext = `Serveurs affichés: ${filteredServers.length}, LAN: ${zoneSummary.LAN}, WAN: ${zoneSummary.WAN}, DMZ: ${zoneSummary.DMZ}, MGMT: ${zoneSummary.MGMT}, OK: ${statusSummary.ok}, Alerte: ${statusSummary.alert}, Hors supervision: ${statusSummary.unsupervised}`

  const getStatusIcon = (s: InfrastructureServer["status"]) => {
    switch (s) {
      case "ok": return <CheckCircle className="h-4 w-4 text-green-500 drop-shadow" />
      case "alert": return <AlertTriangle className="h-4 w-4 text-red-500 animate-pulse drop-shadow" />
      case "unsupervised": return <Info className="h-4 w-4 text-yellow-500 drop-shadow" />
      default: return null
    }
  }

  const zoneStyle = (z: InfrastructureServer["zone"]) => {
    switch (z) {
      case "LAN":
        return "border-blue-400/50 bg-blue-500/10 ring-1 ring-blue-400/30 shadow-[0_0_40px_-12px] shadow-blue-500/20"
      case "WAN":
        return "border-purple-400/50 bg-purple-500/10 ring-1 ring-purple-400/30 shadow-[0_0_40px_-12px] shadow-purple-500/20"
      case "DMZ":
        return "border-orange-400/50 bg-orange-500/10 ring-1 ring-orange-400/30 shadow-[0_0_40px_-12px] shadow-orange-500/20"
      case "MGMT":
        return "border-emerald-400/50 bg-emerald-500/10 ring-1 ring-emerald-400/30 shadow-[0_0_40px_-12px] shadow-emerald-500/20"
      default:
        return "border-slate-400/50 bg-slate-500/10 ring-1 ring-slate-400/30"
    }
  }

  const getRoleIcon = (role: string) => {
    switch (role) {
      case "Web Server": return <Globe className="h-4 w-4" />
      case "Database": return <HardDrive className="h-4 w-4" />
      case "API Gateway": return <Network className="h-4 w-4" />
      case "Monitoring": return <Activity className="h-4 w-4" />
      case "VPN Server": return <Shield className="h-4 w-4" />
      case "Proxy Server": return <Server className="h-4 w-4" />
      case "DNS Server": return <Network className="h-4 w-4" />
      default: return <Server className="h-4 w-4" />
    }
  }

  const statusBarColor = (s: InfrastructureServer["status"]) =>
    s === "ok" ? "bg-green-500/80" : s === "alert" ? "bg-red-500/80" : "bg-yellow-400/80"

  /** ---------- UI HELPERS ---------- */
  const Zone = ({
    zone,
    title,
    rect,
  }: {
    zone: InfrastructureServer["zone"],
    title: string,
    rect: React.CSSProperties
  }) => {
    const zoneServers = filteredServers.filter((s) => s.zone === zone)
    return (
      <div
        className={cn("absolute rounded-2xl p-4 md:p-5 border backdrop-blur-sm", zoneStyle(zone))}
        style={rect}
      >
        <h3 className="font-semibold text-base mb-2 tracking-wide">{title}</h3>
        {zoneServers.length === 0 ? (
          <p className="text-muted-foreground text-xs">Aucun serveur dans cette zone.</p>
        ) : (
          // Grille responsive: spacing automatique des cartes
          <div className="grid gap-3 pt-1 [grid-template-columns:repeat(auto-fill,minmax(180px,1fr))]">
            {zoneServers.map((server) => (
              <TooltipProvider key={server.id}>
                <Tooltip>
                  <TooltipTrigger asChild>
                    <motion.div
                      className={cn(
                        "flex flex-col items-start justify-start p-3 rounded-xl border bg-card/80 backdrop-blur-sm",
                        "shadow-lg hover:shadow-xl cursor-pointer transition-all",
                        server.status === "alert"
                          ? "border-red-500 ring-2 ring-red-500/60 animate-[pulse_1.8s_ease-in-out_infinite]"
                          : "border-border/60 hover:border-primary"
                      )}
                      initial={{ opacity: 0, scale: 0.95 }}
                      animate={{ opacity: 1, scale: 1 }}
                      transition={{ duration: 0.2 }}
                      whileHover={{ scale: 1.02 }}
                      onClick={() => router.push(`/monitoring/${server.id}`)}
                    >
                      <div className="flex items-center gap-1.5 mb-1">
                        {getRoleIcon(server.role)}
                        <span className="font-medium text-sm leading-none">{server.name}</span>
                        {server.isTemplate && <Badge variant="outline" className="text-[10px]">Template</Badge>}
                      </div>

                      <div className="flex items-center gap-1 text-[11px] text-muted-foreground">
                        {getStatusIcon(server.status)}
                        <span className="tabular-nums">{server.ip}</span>
                      </div>

                      <div className="mt-1 w-full flex items-center justify-between">
                        <Badge variant="secondary" className="text-[10px]">{server.zone}</Badge>
                        <div className={cn("h-1.5 w-24 rounded-full", statusBarColor(server.status))} />
                      </div>
                    </motion.div>
                  </TooltipTrigger>
                  <TooltipContent className="backdrop-blur-sm bg-popover/95">
                    <p className="font-semibold">{server.name}</p>
                    <p className="text-xs">IP : {server.ip}</p>
                    <p className="text-xs">Rôle : {server.role}</p>
                    <p className="text-xs">Type : {server.isTemplate ? "Template" : "VM"}</p>
                    <p className="text-xs">Statut : {server.status === "ok" ? "OK" : server.status === "alert" ? "Alerte" : "Hors supervision"}</p>
                    <p className="text-xs">Uptime : {server.uptime}</p>
                  </TooltipContent>
                </Tooltip>
              </TooltipProvider>
            ))}
          </div>
        )}
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <header className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div className="space-y-1">
          <h1 className="text-3xl md:text-4xl font-bold tracking-tight">Carte d&apos;Infrastructure</h1>
          <p className="text-muted-foreground">Visualisation topologique de votre architecture réseau.</p>
          <div className="flex gap-2 pt-1">
            <Badge variant="secondary" className="rounded-full">{filteredServers.length} serveurs</Badge>
            <Badge variant="outline" className="rounded-full hidden sm:inline-flex">
              OK {statusSummary.ok} • Alertes {statusSummary.alert} • HS {statusSummary.unsupervised}
            </Badge>
          </div>
        </div>
        <div className="flex gap-3">
          <Button onClick={fetchServers} variant="outline" className="rounded-xl">
            <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} />
            Actualiser
          </Button>
          <Button asChild className="rounded-xl">
              <Link href="/deploy">
                <Plus className="mr-2 h-4 w-4" /> Ajouter un serveur
              </Link>
            </Button>
        </div>
      </header>

      {/* Warnings */}
      {status === "degraded" && (
        <div className="space-y-2">
          <InlineBanner kind="warning" title="Données partielles (voir détails)" description={errors.join(" • ")} />
          <div className="flex gap-2">
            <Button onClick={fetchServers} size="sm" variant="outline" className="rounded-xl self-start">
              Réessayer
            </Button>
          </div>
        </div>
      )}

      {/* Filters */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="pb-2">
          <CardTitle className="text-lg">Filtres</CardTitle>
          <CardDescription>Affichez uniquement la zone souhaitée</CardDescription>
        </CardHeader>
        <CardContent className="flex gap-2 overflow-x-auto no-scrollbar py-2">
          {(["all", "LAN", "WAN", "DMZ", "MGMT"] as const).map((z) => (
            <Button
              key={z}
              variant={filterZone === z ? "default" : "outline"}
              onClick={() => setFilterZone(z)}
              className={cn(
                "rounded-full whitespace-nowrap",
                z === "LAN" && "border-blue-400/50",
                z === "WAN" && "border-purple-400/50",
                z === "DMZ" && "border-orange-400/50",
                z === "MGMT" && "border-emerald-400/50"
              )}
            >
              {z === "all" ? "Toutes les zones" : z}
            </Button>
          ))}
        </CardContent>
      </Card>

      {/* Map */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="text-lg flex items-center gap-2">
            <Network className="h-5 w-5" />
            Vue Cartographique
          </CardTitle>
          <CardDescription>Visualisation des serveurs par zone réseau.</CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <RefreshCw className="h-8 w-8 animate-spin" />
              <span className="ml-2">Chargement de la carte...</span>
            </div>
          ) : (
            <div
              className={cn(
                "relative w-full h-[680px] border rounded-2xl overflow-hidden",
                "shadow-2xl",
                status === "degraded" && "grayscale opacity-60"
              )}
              style={{
                backgroundImage:
                  "radial-gradient(rgba(255,255,255,0.06) 1px, transparent 1px), radial-gradient(rgba(255,255,255,0.04) 1px, transparent 1px), linear-gradient(120deg, rgba(59,130,246,0.08), rgba(168,85,247,0.08) 50%, rgba(249,115,22,0.08))",
                backgroundSize: "24px 24px, 48px 48px, cover",
                backgroundPosition: "0 0, 12px 12px, center",
              }}
            >
              {/* === Quadrillage 2×2 : 2 zones à gauche, 2 zones à droite === */}
              <Zone zone="MGMT" title="MGMT (Management)" rect={{ top: "4%", left: "5%", width: "40%", height: "42%" }} />
              <Zone zone="LAN"  title="LAN (Réseau Local)" rect={{ top: "54%", left: "5%", width: "40%", height: "42%" }} />
              <Zone zone="DMZ"  title="DMZ (Zone Démilitarisée)" rect={{ top: "4%", left: "55%", width: "40%", height: "42%" }} />
              <Zone zone="WAN"  title="WAN (Réseau Étendu)" rect={{ top: "54%", left: "55%", width: "40%", height: "42%" }} />
            </div>
          )}
        </CardContent>
      </Card>

      {/* Legend */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="pb-3">
          <CardTitle className="text-lg">Légende</CardTitle>
          <CardDescription>Codes visuels utilisés sur la carte</CardDescription>
        </CardHeader>
        <CardContent className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3 text-sm">
          <div className="flex items-center gap-2 rounded-xl bg-muted/40 p-2.5">
            <CheckCircle className="h-4 w-4 text-green-500" /> Statut OK
          </div>
          <div className="flex items-center gap-2 rounded-xl bg-muted/40 p-2.5">
            <AlertTriangle className="h-4 w-4 text-red-500" /> Statut Alerte
          </div>
          <div className="flex items-center gap-2 rounded-xl bg-muted/40 p-2.5">
            <Info className="h-4 w-4 text-yellow-500" /> Hors supervision
          </div>
          <div className="flex items-center gap-2 rounded-xl bg-muted/40 p-2.5">
            <div className="h-4 w-4 border-2 border-blue-400/50 bg-blue-500/10 rounded" /> Zone LAN
          </div>
          <div className="flex items-center gap-2 rounded-xl bg-muted/40 p-2.5">
            <div className="h-4 w-4 border-2 border-purple-400/50 bg-purple-500/10 rounded" /> Zone WAN
          </div>
          <div className="flex items-center gap-2 rounded-xl bg-muted/40 p-2.5">
            <div className="h-4 w-4 border-2 border-orange-400/50 bg-orange-500/10 rounded" /> Zone DMZ
          </div>
          <div className="flex items-center gap-2 rounded-xl bg-muted/40 p-2.5">
            <div className="h-4 w-4 border-2 border-emerald-400/50 bg-emerald-500/10 rounded" /> Zone MGMT
          </div>
        </CardContent>
      </Card>

      {/* AI Assistant */}
      <AssistantAIBlock
        title="Assistant IA de la carte"
        context={aiContext}
        onAnalyze={simulateMapAIAnalysis}
        className="w-full"
      />
    </div>
  )
}
