"use client"

import { useEffect, useState } from "react"
import { fetchDeploymentHistory } from "@/services/deployments"

export default function HistoryPage() {
  const [data, setData] = useState<any>(null)
  const [filters, setFilters] = useState({
    status: "",
    user: "",
    startDate: "",
    endDate: "",
    page: 1,
  })

  const load = async (f = filters) => {
    const res = await fetchDeploymentHistory(f)
    setData(res)
  }

  useEffect(() => {
    load()
  }, [])

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
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

  return (
    <div className="p-4 space-y-6">
      <h1 className="text-xl font-semibold">Historique des VM</h1>

      <div className="flex flex-wrap gap-2">
        <input
          type="text"
          name="user"
          placeholder="Utilisateur"
          value={filters.user}
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
        <button onClick={applyFilters} className="border px-2">Filtrer</button>
      </div>

      {data && (
        <div className="space-y-10">
          <div>
            <h2 className="font-medium">VM déployées</h2>
            <table className="w-full text-sm">
              <thead>
                <tr>
                  <th className="text-left">Nom</th>
                  <th>Date</th>
                  <th>Statut</th>
                  <th>Utilisateur</th>
                </tr>
              </thead>
              <tbody>
                {data.deployments.map((d: any) => (
                  <tr key={`dep-${d.id}`} className="border-t">
                    <td>{d.vm_name}</td>
                    <td>{new Date(d.started_at).toLocaleString()}</td>
                    <td>{d.status}</td>
                    <td>{d.user_email}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div>
            <h2 className="font-medium">VM détruites</h2>
            <table className="w-full text-sm">
              <thead>
                <tr>
                  <th className="text-left">Nom</th>
                  <th>Date de suppression</th>
                  <th>Utilisateur</th>
                </tr>
              </thead>
              <tbody>
                {data.deletes.map((d: any) => (
                  <tr key={`del-${d.id}`} className="border-t">
                    <td>{d.vm_name}</td>
                    <td>{new Date(d.deleted_at).toLocaleString()}</td>
                    <td>{d.user_email}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="flex gap-2">
            <button
              onClick={() => changePage(-1)}
              disabled={filters.page <= 1}
              className="border px-2"
            >
              Précédent
            </button>
            <button onClick={() => changePage(1)} className="border px-2">
              Suivant
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

