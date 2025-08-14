"use client"

import * as React from "react"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { getDeploymentStats, getDashboardInsights, type DeploymentStatsResponse } from "@/services/dashboard"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { Badge } from "@/components/ui/badge"
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip"
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip as RechartsTooltip,
  Legend,
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
} from "recharts"

export default function DashboardStatsPage() {
  const [stats, setStats] = React.useState<DeploymentStatsResponse | null>(null)
  const [period, setPeriod] = React.useState<"day" | "week" | "month">("day")

  React.useEffect(() => {
    getDeploymentStats(period).then(setStats)
  }, [period])

  const analyzeStatsAI = React.useCallback((_ctx: string) => getDashboardInsights(period), [period])
  const aiContext = stats ? JSON.stringify(stats) : "Statistiques indisponibles"

  const formatSeconds = (sec: number) => {
    if (!sec) return '0s'
    const minutes = Math.floor(sec / 60)
    const seconds = Math.round(sec % 60)
    return minutes ? `${minutes}m ${seconds}s` : `${seconds}s`
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-semibold">Statistiques</h1>
        <Select value={period} onValueChange={(v) => setPeriod(v as any)}>
          <SelectTrigger className="w-32">
            <SelectValue placeholder="Période" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="day">Jour</SelectItem>
            <SelectItem value="week">Semaine</SelectItem>
            <SelectItem value="month">Mois</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Indicateurs clés</CardTitle>
        </CardHeader>
        <CardContent className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-sm">
          <div>Taux de réussite 7j : {((stats?.successRate7d || 0) * 100).toFixed(1)}%</div>
          <div>Taux de réussite 30j : {((stats?.successRate30d || 0) * 100).toFixed(1)}%</div>
          <div>Temps médian de déploiement : {formatSeconds(stats?.medianDeploymentTimeSec || 0)}</div>
          <div>Temps moyen jusqu'à destroy : {formatSeconds(stats?.avgDestroyTimeSec || 0)}</div>
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Évolution des déploiements / suppressions</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={stats?.timeline || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="period" />
              <YAxis allowDecimals={false} />
              <RechartsTooltip />
              <Legend />
              <Line type="monotone" dataKey="deployed" name="Déployés" stroke="#16a34a" />
              <Line type="monotone" dataKey="deleted" name="Supprimés" stroke="#dc2626" />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Succès vs échecs</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={stats?.timeline || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="period" />
              <YAxis allowDecimals={false} />
              <RechartsTooltip />
              <Legend />
              <Bar dataKey="success" name="Succès" stackId="a" fill="#16a34a" />
              <Bar dataKey="failed" name="Échecs" stackId="a" fill="#dc2626" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Déploiements par zone</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={Object.entries(stats?.deploymentsByZone || {}).map(([zone, count]) => ({ zone, count }))}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="zone" />
              <YAxis allowDecimals={false} />
              <RechartsTooltip />
              <Bar dataKey="count" name="Déploiements" fill="#3b82f6" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Top causes d'échec</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={stats?.topFailureCauses || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="cause" />
              <YAxis allowDecimals={false} />
              <RechartsTooltip />
              <Bar dataKey="count" name="Échecs" fill="#dc2626" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Capacité de stockage restante</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {stats?.storageCapacity?.map((s) => {
            const freeBytes = s.total_bytes - s.used_bytes
            const freeGb = Math.round(freeBytes / (1024 ** 3))
            const totalGb = Math.round(s.total_bytes / (1024 ** 3))
            const usedGb = Math.round(s.used_bytes / (1024 ** 3))
            const freePct = s.total_bytes ? Math.round((freeBytes / s.total_bytes) * 100) : 0
            const usedPct = s.total_bytes ? Math.round((s.used_bytes / s.total_bytes) * 100) : 0
            let badgeVariant: "success" | "warning" | "destructive" | "secondary"
            let badgeText = ""
            if (!s.total_bytes) {
              badgeVariant = "secondary"
              badgeText = "N/A"
            } else if (freePct >= 30) {
              badgeVariant = "success"
              badgeText = "OK"
            } else if (freePct >= 10) {
              badgeVariant = "warning"
              badgeText = "Attention"
            } else {
              badgeVariant = "destructive"
              badgeText = "Critique"
            }
            const summary = s.total_bytes
              ? `${freeGb} GB • ${freePct}% restants`
              : "N/A"
            return (
              <TooltipProvider key={s.datastore}>
                <Tooltip>
                  <TooltipTrigger asChild>
                    <div
                      className="space-y-1"
                      aria-label={`${s.datastore} : ${summary}${s.total_bytes ? ` sur ${totalGb} GB` : ""}`}
                    >
                      <div className="flex items-center justify-between">
                        <span className="font-medium">{s.datastore}</span>
                        <Badge variant={badgeVariant}>{badgeText}</Badge>
                      </div>
                      <div className="flex items-center gap-2">
                        <div className="h-2 flex-1 rounded-full bg-neutral-200 dark:bg-neutral-700 overflow-hidden">
                          <div
                            className="h-full bg-neutral-500 dark:bg-neutral-400"
                            style={{ width: `${usedPct}%` }}
                          />
                        </div>
                        <span className="text-sm text-muted-foreground">{summary}</span>
                      </div>
                    </div>
                  </TooltipTrigger>
                  <TooltipContent>
                    {s.total_bytes ? (
                      <div className="space-y-1">
                        <p>Total : {totalGb} GB</p>
                        <p>Utilisé : {usedGb} GB ({usedPct}%)</p>
                        <p>Restant : {freeGb} GB ({freePct}%)</p>
                      </div>
                    ) : (
                      <p>Données de capacité indisponibles</p>
                    )}
                  </TooltipContent>
                </Tooltip>
              </TooltipProvider>
            )
          })}
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Répartition succès / échec</CardTitle>
        </CardHeader>
        <CardContent className="flex justify-center">
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={[
                  { name: "Succès", value: stats?.totals.success || 0 },
                  { name: "Échecs", value: stats?.totals.failed || 0 },
                ]}
                dataKey="value"
                nameKey="name"
                outerRadius={100}
                label
              >
                <Cell fill="#16a34a" />
                <Cell fill="#dc2626" />
              </Pie>
              <RechartsTooltip />
            </PieChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <AssistantAIBlock
        title="Assistant IA des statistiques"
        context={aiContext}
        onAnalyze={analyzeStatsAI}
        className="w-full"
      />
    </div>
  )
}

