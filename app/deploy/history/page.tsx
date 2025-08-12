"use client"

import { useEffect, useState, useMemo } from "react"
import {
  fetchDeploymentHistory,
  fetchDeployment,
} from "@/services/deployments"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from "@/components/ui/dialog"

export default function HistoryPage() {
  const [data, setData] = useState<any>(null)
  const [filters, setFilters] = useState({
    status: "",
    user: "",
    template: "",
    startDate: "",
    endDate: "",
    page: 1,
  })
  const [sortBy, setSortBy] = useState("date")
  const [selected, setSelected] = useState<any>(null)
  const [detail, setDetail] = useState<any>(null)

  const load = async (f = filters) => {
    const res = await fetchDeploymentHistory(f)
    setData(res)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>
  ) => {
    setFilters({ ...filters, [e.target.name]: e.target.value })
  }

  const applyFilters = () => {
    const f = { ...filters, page: 1 }
    setFilters(f)
    load(f)
  }

  const changePage = (delta: number) => {
    const newPage = filters.page + delta
    if (newPage < 1) return
    const f = { ...filters, page: newPage }
    setFilters(f)
    load(f)
  }

  const openDetail = async (ev: any) => {
    setSelected(ev)
    if (ev.type === "deployment") {
      const d = await fetchDeployment(String(ev.id))
      const duration =
        d.started_at && d.ended_at
          ? `${Math.round(
              (new Date(d.ended_at).getTime() -
                new Date(d.started_at).getTime()) /
                1000
            )}s`
          : undefined
      setDetail({ ...d, duration })
    } else {
      setDetail(ev)
    }
  }

  const closeDetail = () => {
    setSelected(null)
    setDetail(null)
  }

  const grouped = useMemo(() => {
    if (!data) return {}
    const all = [
      ...data.deployments.map((d: any) => ({
        ...d,
        type: "deployment",
        date: d.started_at,
      })),
      ...data.deletes.map((d: any) => ({
        ...d,
        type: "delete",
        status: "deleted",
        date: d.deleted_at,
      })),
    ]
    const sorted = all.sort((a: any, b: any) => {
      if (sortBy === "status") return a.status.localeCompare(b.status)
      if (sortBy === "duration")
        return (parseFloat(a.duration) || 0) - (parseFloat(b.duration) || 0)
      return new Date(b.date).getTime() - new Date(a.date).getTime()
    })
    return sorted.reduce((acc: any, ev: any) => {
      const day = new Date(ev.date).toLocaleDateString()
      ;(acc[day] = acc[day] || []).push(ev)
      return acc
    }, {})
  }, [data, sortBy])

  const renderBadge = (ev: any) => {
    if (ev.type === "delete") return <Badge variant="warning">détruite</Badge>
    return (
      <Badge variant={ev.status === "success" ? "success" : "destructive"}>
        {ev.status}
      </Badge>
    )
  }

  return (
    <div className="p-4 space-y-6">
      <h1 className="text-xl font-semibold">Historique des VM</h1>

      <div className="flex flex-wrap gap-2 items-end">
        <input
          type="text"
          name="user"
          placeholder="Utilisateur"
          value={filters.user}
          onChange={handleChange}
          className="border p-1"
        />
        <input
          type="text"
          name="template"
          placeholder="Template"
          value={filters.template}
          onChange={handleChange}
          className="border p-1"
        />
        <select
          name="status"
          value={filters.status}
          onChange={handleChange}
          className="border p-1"
        >
          <option value="">Statut</option>
          <option value="success">Succès</option>
          <option value="failed">Échec</option>
        </select>
        <input
          type="date"
          name="startDate"
          value={filters.startDate}
          onChange={handleChange}
          className="border p-1"
        />
        <input
          type="date"
          name="endDate"
          value={filters.endDate}
          onChange={handleChange}
          className="border p-1"
        />
        <Button variant="outline" onClick={applyFilters}>
          Filtrer
        </Button>
        <select
          value={sortBy}
          onChange={(e) => setSortBy(e.target.value)}
          className="border p-1"
        >
          <option value="date">Tri par date</option>
          <option value="duration">Tri par durée</option>
          <option value="status">Tri par statut</option>
        </select>
      </div>

      {Object.keys(grouped).length > 0 && (
        <div className="space-y-4">
          {Object.entries(grouped).map(([day, events]: any) => (
            <div key={day} className="space-y-2">
              <h2 className="font-medium mt-4">{day}</h2>
              {events.map((ev: any) => (
                <Card
                  key={`${ev.type}-${ev.id}`}
                  onClick={() => openDetail(ev)}
                  className="cursor-pointer"
                >
                  <CardContent className="flex items-center justify-between p-4">
                    <div>
                      <div className="font-medium">{ev.vm_name}</div>
                      {ev.template && (
                        <div className="text-sm text-muted-foreground">
                          {ev.template}
                        </div>
                      )}
                      <div className="text-xs text-muted-foreground">
                        {new Date(ev.date).toLocaleTimeString()}
                      </div>
                    </div>
                    {renderBadge(ev)}
                  </CardContent>
                </Card>
              ))}
            </div>
          ))}

          <div className="flex gap-2 pt-4">
            <Button
              variant="outline"
              onClick={() => changePage(-1)}
              disabled={filters.page <= 1}
            >
              Précédent
            </Button>
            <Button variant="outline" onClick={() => changePage(1)}>
              Suivant
            </Button>
          </div>
        </div>
      )}

      <Dialog open={!!selected} onOpenChange={closeDetail}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{detail?.vm_name || selected?.vm_name}</DialogTitle>
            <DialogDescription>
              {selected?.type === "delete" ? "VM détruite" : detail?.status}
            </DialogDescription>
          </DialogHeader>
          {detail ? (
            <div className="space-y-2 text-sm">
              {detail.template && <p>Template : {detail.template}</p>}
              {detail.started_at && (
                <p>Démarré : {new Date(detail.started_at).toLocaleString()}</p>
              )}
              {detail.ended_at && (
                <p>Terminé : {new Date(detail.ended_at).toLocaleString()}</p>
              )}
              {detail.duration && <p>Durée : {detail.duration}</p>}
              {detail.log && (
                <pre className="max-h-60 overflow-auto rounded bg-muted p-2 text-xs whitespace-pre-wrap">
                  {detail.log}
                </pre>
              )}
            </div>
          ) : (
            <p>Chargement...</p>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}

