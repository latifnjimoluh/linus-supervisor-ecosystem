"use client"

import { useEffect, useState } from "react"
import { BackButton } from "@/components/back-button"
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Button } from "@/components/ui/button"
import { useToast } from "@/hooks/use-toast"
import useAuth from "@/hooks/useAuth"
import {
  listProxmoxNodes,
  listProxmoxStoragesByNode,
  getNodeSystemInfo,
  ProxmoxNode,
  ProxmoxStorage,
  NodeSystemInfo,
} from "@/services/vms"
import { getMySettings, updateStoragePreferences } from "@/services/settings"

export default function StorageSettingsPage() {
  useAuth("/settings/storage")
  const { toast } = useToast()

  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [nodes, setNodes] = useState<ProxmoxNode[]>([])
  const [storages, setStorages] = useState<ProxmoxStorage[]>([])
  const [system, setSystem] = useState<NodeSystemInfo | null>(null)
  const [selectedNode, setSelectedNode] = useState("")
  const [selectedStorage, setSelectedStorage] = useState("")

  useEffect(() => {
    const init = async () => {
      try {
        setLoading(true)
        const [settings, nodesList] = await Promise.all([
          getMySettings(),
          listProxmoxNodes(),
        ])
        setNodes(nodesList)
        const node = settings?.proxmox_node || nodesList[0]?.node || ""
        const storage = settings?.vm_storage || ""
        setSelectedNode(node)
        setSelectedStorage(storage)
        await refreshNode(node)
      } catch (err: any) {
        toast({ title: "Erreur", description: err.message || "Chargement impossible", variant: "destructive" })
      } finally {
        setLoading(false)
      }
    }
    init()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const refreshNode = async (node: string) => {
    try {
      const [sys, stor] = await Promise.all([
        getNodeSystemInfo(node),
        listProxmoxStoragesByNode(node),
      ])
      setSystem(sys)
      setStorages(stor)
    } catch (err: any) {
      toast({ title: "Erreur", description: err.message || "Impossible de récupérer les données", variant: "destructive" })
    }
  }

  const onNodeChange = async (node: string) => {
    setSelectedNode(node)
    setSelectedStorage("")
    await refreshNode(node)
  }

  const handleSave = async () => {
    try {
      setSaving(true)
      await updateStoragePreferences({ proxmox_node: selectedNode, vm_storage: selectedStorage })
      toast({ title: "Préférences de stockage mises à jour", variant: "success" })
    } catch (err: any) {
      toast({ title: "Erreur", description: err.message || "Sauvegarde impossible", variant: "destructive" })
    } finally {
      setSaving(false)
    }
  }

  const currentStorage = storages.find((s) => s.storage === selectedStorage)
  const bytesToGb = (n?: number) => (n ? Math.floor(n / 1024 ** 3) : 0)

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href="/settings" label="Retour" />
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Gestion du Stockage</h1>
          <p className="text-muted-foreground">Configurez le stockage par défaut et consultez l'état du nœud.</p>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Système</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            {loading && !system ? (
              <p>Chargement...</p>
            ) : system ? (
              <div className="space-y-1 text-sm">
                <p>
                  RAM : {bytesToGb(system.memory.used)} GB utilisés / {bytesToGb(system.memory.total)} GB (libre {bytesToGb(system.memory.free)} GB)
                </p>
                <p>
                  Disque : {bytesToGb(system.disk.used)} GB utilisés / {bytesToGb(system.disk.total)} GB (libre {bytesToGb(system.disk.free)} GB)
                </p>
                <p>CPU : {system.cpu.cores} cœurs / {system.cpu.sockets} sockets</p>
              </div>
            ) : (
              <p>Impossible de charger les informations système.</p>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Stockage</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>Nœud</Label>
              <Select value={selectedNode} onValueChange={onNodeChange} disabled={loading}>
                <SelectTrigger>
                  <SelectValue placeholder="Sélectionnez un nœud" />
                </SelectTrigger>
                <SelectContent>
                  {nodes.map((n) => (
                    <SelectItem key={n.node} value={n.node}>
                      {n.node}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Stockage</Label>
              <Select
                value={selectedStorage}
                onValueChange={setSelectedStorage}
                disabled={loading || storages.length === 0}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Sélectionnez un stockage" />
                </SelectTrigger>
                <SelectContent>
                  {storages.map((s) => (
                    <SelectItem key={s.storage} value={s.storage}>
                      {s.storage}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            {currentStorage && (
              <div className="text-sm space-y-1">
                <p>Total : {bytesToGb(currentStorage.maxdisk)} GB</p>
                <p>Utilisé : {bytesToGb(currentStorage.disk)} GB</p>
                <p>Libre : {bytesToGb(currentStorage.maxdisk - currentStorage.disk)} GB</p>
              </div>
            )}
          </CardContent>
          <CardFooter>
            <Button
              onClick={handleSave}
              disabled={saving || !selectedStorage || !selectedNode}
              className="w-full"
            >
              {saving ? "Enregistrement..." : "Enregistrer"}
            </Button>
          </CardFooter>
        </Card>
      </div>
    </div>
  )
}

