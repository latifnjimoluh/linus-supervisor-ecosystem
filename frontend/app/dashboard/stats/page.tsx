"use client"

import * as React from "react"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { getDeploymentStats, getDashboardInsights, type DeploymentStatsResponse } from "@/services/dashboard"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  BarChart,
  Bar,
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
              <Tooltip />
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
              <Tooltip />
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
              <Tooltip />
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
              <Tooltip />
              <Bar dataKey="count" name="Échecs" fill="#dc2626" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Capacité stockage restante</CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart data={stats?.storageCapacity.map(s => ({ datastore: s.datastore, free: Math.round(s.free / (1024**3)) })) || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="datastore" />
              <YAxis allowDecimals={false} />
              <Tooltip />
              <Bar dataKey="free" name="Go libres" fill="#10b981" />
            </BarChart>
          </ResponsiveContainer>
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
              <Tooltip />
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

