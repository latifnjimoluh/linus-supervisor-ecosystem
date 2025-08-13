"use client"

import * as React from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"

// ========= Types =========
type StorageItem = {
  storage: string
  content: string
  plugintype: string
  node: string
  shared: boolean
  total_bytes: number
  used_bytes: number
  free_bytes: number
}

type SystemInfo = {
  ram_used_bytes: number
  ram_total_bytes: number
  disk_used_bytes: number
  disk_total_bytes: number
  cpu_cores: number
  cpu_sockets: number
}

// ========= Helpers =========
const formatGB = (bytes?: number) => {
  if (bytes == null) return "0 GB"
  const gb = bytes / (1024 ** 3)
  return `${gb >= 10 ? Math.round(gb) : gb.toFixed(1)} GB`
}

const percent = (used?: number, total?: number) => {
  if (!used || !total || total === 0) return "0%"
  return `${Math.round((used / total) * 100)}%`
}

// ========= API (remplace ces stubs par tes vrais appels si tu les as) =========
async function fetchNodeStorages(): Promise<StorageItem[]> {
  // ↙️ Remplace par ton fetch réel (le JSON que tu as montré)
  // return (await fetch("/api/storages")).json()
  return [
    {
      storage: "local",
      content: "backup,iso,vztmpl",
      plugintype: "dir",
      node: "pve",
      shared: false,
      total_bytes: 28747837440,
      used_bytes: 3313754112,
      free_bytes: 25434083328,
    },
    {
      storage: "local-lvm",
      content: "rootdir,images",
      plugintype: "lvmthin",
      node: "pve",
      shared: false,
      total_bytes: 66706210816,
      used_bytes: 16156244259,
      free_bytes: 50549966557,
    },
  ]
}

async function fetchSystemInfo(): Promise<SystemInfo> {
  // ↙️ Stub d’exemple; branche-le à ton endpoint si tu en as un
  return {
    ram_used_bytes: 4 * 1024 ** 3,
    ram_total_bytes: 27 * 1024 ** 3,
    disk_used_bytes: 3 * 1024 ** 3,
    disk_total_bytes: 26 * 1024 ** 3,
    cpu_cores: 16,
    cpu_sockets: 4,
  }
}

// ========= Page =========
export default function StorageSettingsPage() {
  const [loading, setLoading] = React.useState(true)
  const [storages, setStorages] = React.useState<StorageItem[]>([])
  const [node, setNode] = React.useState<string>("")
  const [storage, setStorage] = React.useState<string>("")
  const [sys, setSys] = React.useState<SystemInfo | null>(null)

  React.useEffect(() => {
    const load = async () => {
      setLoading(true)
      try {
        const [sItems, sInfo] = await Promise.all([
          fetchNodeStorages(),
          fetchSystemInfo(),
        ])
        setStorages(sItems)
        setSys(sInfo)
        // valeurs par défaut cohérentes
        if (sItems.length) {
          const firstNode = sItems[0].node
          setNode(firstNode)
          const firstStorageOnNode = sItems.find(i => i.node === firstNode)?.storage ?? sItems[0].storage
          setStorage(firstStorageOnNode)
        }
      } finally {
        setLoading(false)
      }
    }
    load()
  }, [])

  // Liste des nœuds uniques
  const nodes = React.useMemo(
    () => Array.from(new Set(storages.map(s => s.node))),
    [storages]
  )

  // Stockages filtrés par nœud
  const storagesForNode = React.useMemo(
    () => storages.filter(s => s.node === node),
    [storages, node]
  )

  // Élément sélectionné
  const current = React.useMemo(
    () => storagesForNode.find(s => s.storage === storage),
    [storagesForNode, storage]
  )

  const handleSave = () => {
    // ici tu peux enregistrer la préférence (node + storage) côté backend si besoin
    // await saveDefaultStorage(node, storage)
    // toast.success("Enregistré")
    console.log("Saving default storage:", { node, storage })
  }

  return (
    <div className="mx-auto w-full max-w-[1200px] p-4 sm:p-6 space-y-6">
      <div className="flex items-center gap-3">
        <Button variant="outline" onClick={() => history.back()} className="rounded-xl px-3">
          ← Retour
        </Button>
        <h1 className="text-3xl font-bold">Gestion du Stockage</h1>
      </div>
      <p className="text-muted-foreground">
        Configurez le stockage par défaut et consultez l’état du nœud.
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Système */}
        <Card className="rounded-2xl">
          <CardHeader>
            <CardTitle>Système</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3 text-sm">
            <div>
              <span className="font-medium">RAM : </span>
              {formatGB(sys?.ram_used_bytes)} / {formatGB(sys?.ram_total_bytes)}{" "}
              <span className="text-muted-foreground">
                (libre {formatGB(
                  (sys?.ram_total_bytes ?? 0) - (sys?.ram_used_bytes ?? 0)
                )})
              </span>{" "}
              <span className="text-muted-foreground">
                {percent(sys?.ram_used_bytes, sys?.ram_total_bytes)}
              </span>
            </div>

            <div>
              <span className="font-medium">Disque : </span>
              {formatGB(sys?.disk_used_bytes)} / {formatGB(sys?.disk_total_bytes)}{" "}
              <span className="text-muted-foreground">
                (libre {formatGB(
                  (sys?.disk_total_bytes ?? 0) - (sys?.disk_used_bytes ?? 0)
                )})
              </span>{" "}
              <span className="text-muted-foreground">
                {percent(sys?.disk_used_bytes, sys?.disk_total_bytes)}
              </span>
            </div>

            <div>
              <span className="font-medium">CPU : </span>
              {sys?.cpu_cores ?? 0} cœurs / {sys?.cpu_sockets ?? 0} sockets
            </div>
          </CardContent>
        </Card>

        {/* Stockage */}
        <Card className="rounded-2xl">
          <CardHeader>
            <CardTitle>Stockage</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {/* Nœud */}
            <div>
              <div className="mb-1 text-sm">Nœud</div>
              <Select
                value={node}
                onValueChange={(val) => {
                  setNode(val)
                  // auto-sélectionner un stockage valide du nœud
                  const first = storages.find(s => s.node === val)
                  setStorage(first?.storage ?? "")
                }}
                disabled={loading || nodes.length === 0}
              >
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Sélectionner un nœud" />
                </SelectTrigger>
                <SelectContent>
                  {nodes.map(n => (
                    <SelectItem key={n} value={n}>
                      {n}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Stockage */}
            <div>
              <div className="mb-1 text-sm">Stockage</div>
              <Select
                value={storage}
                onValueChange={setStorage}
                disabled={loading || storagesForNode.length === 0}
              >
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Sélectionner un stockage" />
                </SelectTrigger>
                <SelectContent>
                  {storagesForNode.map(s => (
                    <SelectItem key={s.storage} value={s.storage}>
                      {s.storage}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Chiffres — 🌟 on utilise bien *_bytes du JSON */}
            <div className="mt-2 space-y-1 text-sm">
              <div>Total : {formatGB(current?.total_bytes)}</div>
              <div>Utilisé : {formatGB(current?.used_bytes)}</div>
              <div>Libre : {formatGB(current?.free_bytes)}</div>
            </div>

            <div className="pt-2">
              <Button className="w-full rounded-xl" onClick={handleSave} disabled={loading || !current}>
                Enregistrer
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
