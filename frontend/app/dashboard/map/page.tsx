"use client"

import * as React from "react"
import { Server, Globe, HardDrive, Network, AlertTriangle, CheckCircle, XCircle, Info, RefreshCw, Plus, Activity, Shield } from 'lucide-react'
import { motion } from "framer-motion"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"
import { cn } from "@/lib/utils" // Ensure cn is imported
import { getInfrastructureMap, type InfrastructureServer } from "@/services/dashboard"

export default function InfrastructureMapPage() {
  const [servers, setServers] = React.useState<InfrastructureServer[]>([])
  const [loading, setLoading] = React.useState(true)
  const [filterZone, setFilterZone] = React.useState<"all" | "LAN" | "WAN" | "DMZ">("all")

  const fetchServers = React.useCallback(() => {
    setLoading(true)
    getInfrastructureMap()
      .then(setServers)
      .catch(() => setServers([]))
      .finally(() => setLoading(false))
  }, [])

  React.useEffect(() => {
    fetchServers()
  }, [fetchServers])

  const filteredServers = servers.filter(server =>
    filterZone === "all" || server.zone === filterZone
  )

  const getStatusIcon = (status: InfrastructureServer['status']) => {
    switch (status) {
      case "ok": return <CheckCircle className="h-4 w-4 text-green-500" />
      case "alert": return <AlertTriangle className="h-4 w-4 text-red-500 animate-pulse" />
      case "unsupervised": return <Info className="h-4 w-4 text-yellow-500" />
      default: return null
    }
  }

  const getZoneColor = (zone: InfrastructureServer['zone']) => {
    switch (zone) {
      case "LAN": return "border-blue-500/50 bg-blue-500/10"
      case "WAN": return "border-purple-500/50 bg-purple-500/10"
      case "DMZ": return "border-orange-500/50 bg-orange-500/10"
      default: return "border-gray-500/50 bg-gray-500/10"
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

  return (
    <div className="space-y-6">
      <header className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 className="text-3xl md:text-4xl font-bold tracking-tight">Carte d'Infrastructure</h1>
          <p className="text-muted-foreground mt-2">
            Visualisation topologique de votre architecture réseau.
          </p>
        </div>
        <div className="flex gap-3">
          <Button onClick={fetchServers} variant="outline" className="rounded-xl">
            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
            Actualiser
          </Button>
          <Button className="rounded-xl">
            <Plus className="mr-2 h-4 w-4" /> Ajouter un serveur
          </Button>
        </div>
      </header>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="text-lg">Filtres</CardTitle>
        </CardHeader>
        <CardContent className="flex flex-wrap gap-3">
          <Button
            variant={filterZone === "all" ? "default" : "outline"}
            onClick={() => setFilterZone("all")}
            className="rounded-xl"
          >
            Toutes les zones
          </Button>
          <Button
            variant={filterZone === "LAN" ? "default" : "outline"}
            onClick={() => setFilterZone("LAN")}
            className="rounded-xl"
          >
            LAN
          </Button>
          <Button
            variant={filterZone === "WAN" ? "default" : "outline"}
            onClick={() => setFilterZone("WAN")}
            className="rounded-xl"
          >
            WAN
          </Button>
          <Button
            variant={filterZone === "DMZ" ? "default" : "outline"}
            onClick={() => setFilterZone("DMZ")}
            className="rounded-xl"
          >
            DMZ
          </Button>
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="text-lg flex items-center gap-2">
            <Network className="h-5 w-5" />
            Vue Cartographique
          </CardTitle>
          <CardDescription>
            Visualisation des serveurs par zone réseau.
          </CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <RefreshCw className="h-8 w-8 animate-spin" />
              <span className="ml-2">Chargement de la carte...</span>
            </div>
          ) : (
            <div className="relative w-full h-[600px] border rounded-xl overflow-hidden bg-gradient-to-br from-background to-muted/20">
              {/* Zone containers */}
              <div className={cn("absolute border-2 rounded-xl p-4", getZoneColor("LAN"))} style={{ top: '10%', left: '5%', width: '40%', height: '80%' }}>
                <h3 className="font-bold text-lg mb-4">LAN (Réseau Local)</h3>
                {filteredServers.filter(s => s.zone === "LAN").length === 0 && (
                  <p className="text-muted-foreground text-sm">Aucun serveur dans cette zone.</p>
                )}
              </div>
              <div className={cn("absolute border-2 rounded-xl p-4", getZoneColor("DMZ"))} style={{ top: '10%', left: '55%', width: '40%', height: '40%' }}>
                <h3 className="font-bold text-lg mb-4">DMZ (Zone Démilitarisée)</h3>
                {filteredServers.filter(s => s.zone === "DMZ").length === 0 && (
                  <p className="text-muted-foreground text-sm">Aucun serveur dans cette zone.</p>
                )}
              </div>
              <div className={cn("absolute border-2 rounded-xl p-4", getZoneColor("WAN"))} style={{ top: '55%', left: '55%', width: '40%', height: '35%' }}>
                <h3 className="font-bold text-lg mb-4">WAN (Réseau Étendu)</h3>
                {filteredServers.filter(s => s.zone === "WAN").length === 0 && (
                  <p className="text-muted-foreground text-sm">Aucun serveur dans cette zone.</p>
                )}
              </div>

              <TooltipProvider>
                {filteredServers.map((server) => (
                  <motion.div
                    key={server.id}
                    className={cn(
                      "absolute flex flex-col items-center justify-center p-2 rounded-lg shadow-md cursor-pointer transition-all duration-200",
                      "bg-card border",
                      server.status === "alert" ? "border-red-500 ring-2 ring-red-500 animate-pulse" : "border-border hover:border-primary"
                    )}
                    style={{
                      left: `${server.position.x * 100}%`,
                      top: `${server.position.y * 100}%`,
                      transform: 'translate(-50%, -50%)',
                      zIndex: 10,
                    }}
                    initial={{ opacity: 0, scale: 0.8 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ duration: 0.3 }}
                    whileHover={{ scale: 1.05, zIndex: 11 }}
                    onClick={() => alert(`Détails de ${server.name}`)} // Replace with actual navigation
                  >
                    <div className="flex items-center gap-1 mb-1">
                      {getRoleIcon(server.role)}
                      <span className="font-medium text-sm">{server.name}</span>
                    </div>
                    <div className="flex items-center gap-1 text-xs text-muted-foreground">
                      {getStatusIcon(server.status)}
                      <span>{server.ip}</span>
                    </div>
                    <Badge variant="secondary" className="mt-1 text-xs">{server.zone}</Badge>
                    <Tooltip>
                      <TooltipTrigger asChild>
                        <span className="absolute inset-0" />
                      </TooltipTrigger>
                      <TooltipContent>
                        <p className="font-semibold">{server.name}</p>
                        <p>IP: {server.ip}</p>
                        <p>Rôle: {server.role}</p>
                        <p>Statut: {server.status === "ok" ? "OK" : server.status === "alert" ? "Alerte" : "Hors supervision"}</p>
                        <p>Uptime: {server.uptime}</p>
                      </TooltipContent>
                    </Tooltip>
                  </motion.div>
                ))}
              </TooltipProvider>

              {servers.length === 0 && !loading && (
                <div className="absolute inset-0 flex flex-col items-center justify-center text-muted-foreground">
                  <Server className="h-12 w-12 mb-4" />
                  <h3 className="text-lg font-semibold mb-2">Aucun serveur à afficher</h3>
                  <p className="mb-4">Commencez par ajouter des serveurs pour les visualiser ici.</p>
                  <Button className="rounded-xl">
                    <Plus className="mr-2 h-4 w-4" /> Ajouter un serveur
                  </Button>
                </div>
              )}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Legend */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="text-lg">Légende</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 text-sm">
          <div className="flex items-center gap-2">
            <CheckCircle className="h-4 w-4 text-green-500" /> Statut OK
          </div>
          <div className="flex items-center gap-2">
            <AlertTriangle className="h-4 w-4 text-red-500" /> Statut Alerte
          </div>
          <div className="flex items-center gap-2">
            <Info className="h-4 w-4 text-yellow-500" /> Hors supervision
          </div>
          <div className="flex items-center gap-2">
            <div className="h-4 w-4 border-2 border-blue-500/50 bg-blue-500/10 rounded" /> Zone LAN
          </div>
          <div className="flex items-center gap-2">
            <div className="h-4 w-4 border-2 border-purple-500/50 bg-purple-500/10 rounded" /> Zone WAN
          </div>
          <div className="flex items-center gap-2">
            <div className="h-4 w-4 border-2 border-orange-500/50 bg-orange-500/10 rounded" /> Zone DMZ
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
