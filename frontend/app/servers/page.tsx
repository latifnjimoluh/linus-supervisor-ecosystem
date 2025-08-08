"use client"

import * as React from "react"
import { Server as ServerIcon, Plus, Trash2, Pencil } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/components/ui/table"
import { useToast } from "@/hooks/use-toast"
import { getServers, createServer, updateServer, deleteServer } from "@/services/api"

interface ServerItem {
  id: number
  ip: string
  name: string
  zone: string
}

export default function ServersPage() {
  const [servers, setServers] = React.useState<ServerItem[]>([])
  const [loading, setLoading] = React.useState(true)
  const [form, setForm] = React.useState({ ip: "", name: "", zone: "" })
  const [editingId, setEditingId] = React.useState<number | null>(null)
  const { toast } = useToast()

  const fetchServers = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await getServers()
      setServers(data.data || data || [])
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    } finally {
      setLoading(false)
    }
  }, [toast])

  React.useEffect(() => {
    fetchServers()
  }, [fetchServers])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      if (editingId) {
        await updateServer(editingId, form)
        toast({ title: "Serveur mis à jour", variant: "success" })
      } else {
        await createServer(form)
        toast({ title: "Serveur créé", variant: "success" })
      }
      setForm({ ip: "", name: "", zone: "" })
      setEditingId(null)
      fetchServers()
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  const handleEdit = (srv: ServerItem) => {
    setForm({ ip: srv.ip, name: srv.name, zone: srv.zone })
    setEditingId(srv.id)
  }

  const handleDelete = async (id: number) => {
    try {
      await deleteServer(id)
      setServers(prev => prev.filter(s => s.id !== id))
      toast({ title: "Serveur supprimé", variant: "success" })
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <ServerIcon className="h-8 w-8 text-primary" />
        <h1 className="text-3xl font-bold">Gestion des serveurs</h1>
      </div>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>{editingId ? "Modifier le serveur" : "Nouveau serveur"}</CardTitle>
          <CardDescription>Ajouter ou modifier un serveur de l'infrastructure</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="flex flex-col md:flex-row gap-4">
            <Input
              placeholder="Adresse IP"
              value={form.ip}
              onChange={e => setForm({ ...form, ip: e.target.value })}
              className="rounded-xl"
            />
            <Input
              placeholder="Nom"
              value={form.name}
              onChange={e => setForm({ ...form, name: e.target.value })}
              className="rounded-xl"
            />
            <Input
              placeholder="Zone"
              value={form.zone}
              onChange={e => setForm({ ...form, zone: e.target.value })}
              className="rounded-xl"
            />
            <Button type="submit" className="rounded-xl whitespace-nowrap">
              <Plus className="mr-2 h-4 w-4" /> {editingId ? "Mettre à jour" : "Ajouter"}
            </Button>
          </form>
        </CardContent>
      </Card>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Serveurs existants</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>IP</TableHead>
                <TableHead>Nom</TableHead>
                <TableHead>Zone</TableHead>
                <TableHead className="w-24" />
              </TableRow>
            </TableHeader>
            <TableBody>
              {servers.map((srv) => (
                <TableRow key={srv.id}>
                  <TableCell>{srv.id}</TableCell>
                  <TableCell>{srv.ip}</TableCell>
                  <TableCell>{srv.name}</TableCell>
                  <TableCell>{srv.zone}</TableCell>
                  <TableCell className="flex gap-2">
                    <Button variant="ghost" size="icon" onClick={() => handleEdit(srv)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(srv.id)}>
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
              {!servers.length && !loading && (
                <TableRow>
                  <TableCell colSpan={5} className="text-center">
                    Aucun serveur
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}

