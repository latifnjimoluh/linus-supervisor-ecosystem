"use client"

import * as React from "react"
import { Plus, RefreshCw, Trash2 } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription, DialogTrigger } from "@/components/ui/dialog"
import { useToast } from "@/hooks/use-toast"
import { listServers, createServer, deleteServer, InfrastructureServer } from "@/services/api"
import { cn } from "@/lib/utils"

export default function ServersPage() {
  const [servers, setServers] = React.useState<InfrastructureServer[]>([])
  const [loading, setLoading] = React.useState(true)
  const [isDialogOpen, setIsDialogOpen] = React.useState(false)
  const [formData, setFormData] = React.useState({ name: "", ip: "", zone: "LAN" })
  const { toast } = useToast()

  const fetchServers = React.useCallback(() => {
    setLoading(true)
    listServers()
      .then((data) => setServers(data))
      .catch(() => {
        toast({ title: "Erreur", description: "Impossible de charger les serveurs", variant: "destructive" })
      })
      .finally(() => setLoading(false))
  }, [toast])

  React.useEffect(() => {
    fetchServers()
  }, [fetchServers])

  const handleCreate = async () => {
    if (!formData.name || !formData.ip) {
      toast({ title: "Erreur", description: "Veuillez remplir tous les champs", variant: "destructive" })
      return
    }
    try {
      const newServer = await createServer(formData)
      setServers(prev => [...prev, newServer])
      setFormData({ name: "", ip: "", zone: "LAN" })
      setIsDialogOpen(false)
      toast({ title: "Serveur créé", description: `Le serveur ${newServer.name} a été ajouté`, variant: "success" })
    } catch (error: any) {
      toast({ title: "Erreur", description: error.response?.data?.message || "Création échouée", variant: "destructive" })
    }
  }

  const handleDelete = async (id: number) => {
    try {
      await deleteServer(id)
      setServers(prev => prev.filter(s => s.id !== id))
      toast({ title: "Serveur supprimé", description: "Suppression réalisée", variant: "success" })
    } catch (error: any) {
      toast({ title: "Erreur", description: error.response?.data?.message || "Suppression échouée", variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold tracking-tight">Serveurs</h1>
        <Button onClick={fetchServers} variant="outline" className="rounded-xl">
          <RefreshCw className={cn("mr-2 h-4 w-4", loading && "animate-spin")} /> Rafraîchir
        </Button>
      </div>
      <Card className="rounded-2xl shadow-sm">
        <CardHeader className="flex flex-row justify-between items-center">
          <CardTitle>Liste des serveurs</CardTitle>
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button size="sm" className="rounded-xl"><Plus className="mr-2 h-4 w-4" />Ajouter</Button>
            </DialogTrigger>
            <DialogContent className="rounded-2xl">
              <DialogHeader>
                <DialogTitle>Ajouter un serveur</DialogTitle>
                <DialogDescription>Renseignez les informations du serveur</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label htmlFor="name">Nom</Label>
                  <Input id="name" value={formData.name} onChange={e => setFormData({ ...formData, name: e.target.value })} />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="ip">Adresse IP</Label>
                  <Input id="ip" value={formData.ip} onChange={e => setFormData({ ...formData, ip: e.target.value })} />
                </div>
                <div className="space-y-2">
                  <Label>Zone</Label>
                  <select
                    className="w-full rounded-md border px-3 py-2 text-sm"
                    value={formData.zone}
                    onChange={e => setFormData({ ...formData, zone: e.target.value })}
                  >
                    <option value="LAN">LAN</option>
                    <option value="WAN">WAN</option>
                    <option value="DMZ">DMZ</option>
                  </select>
                </div>
              </div>
              <div className="flex justify-end gap-2">
                <Button variant="outline" onClick={() => setIsDialogOpen(false)} className="rounded-xl">Annuler</Button>
                <Button onClick={handleCreate} className="rounded-xl">Enregistrer</Button>
              </div>
            </DialogContent>
          </Dialog>
        </CardHeader>
        <CardContent>
          {servers.length === 0 ? (
            <p className="text-sm text-muted-foreground">Aucun serveur.</p>
          ) : (
            <ul className="space-y-2">
              {servers.map(server => (
                <li key={server.id} className="flex items-center justify-between border rounded-xl p-3">
                  <div>
                    <p className="font-medium">{server.name} <span className="text-sm text-muted-foreground">({server.ip})</span></p>
                    <p className="text-xs text-muted-foreground">{server.zone}</p>
                  </div>
                  <Button variant="destructive" size="icon" className="rounded-xl" onClick={() => handleDelete(server.id)}>
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </li>
              ))}
            </ul>
          )}
        </CardContent>
      </Card>
    </div>
  )
}

