"use client"

import * as React from "react"
import { Key, Plus, Trash2 } from 'lucide-react'

import { Button } from "@/components/ui/button"
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/components/ui/table"
import { useToast } from "@/hooks/use-toast"
import { getPermissions, createPermission, deletePermission } from "@/services/api"

interface Permission { id: number; name: string; description?: string }

export default function PermissionsPage() {
  const [permissions, setPermissions] = React.useState<Permission[]>([])
  const [loading, setLoading] = React.useState(true)
  const [form, setForm] = React.useState({ name: '', description: '' })
  const { toast } = useToast()

  const fetchPermissions = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await getPermissions()
      setPermissions(data.data || data || [])
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    } finally {
      setLoading(false)
    }
  }, [toast])

  React.useEffect(() => { fetchPermissions() }, [fetchPermissions])

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      const res = await createPermission(form)
      const created = res.permission || res
      toast({ title: 'Permission créée', description: `Permission ${created.name} créée`, variant: 'success' })
      setForm({ name: '', description: '' })
      fetchPermissions()
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    }
  }

  const handleDelete = async (id: number) => {
    try {
      await deletePermission(id)
      toast({ title: 'Permission supprimée', variant: 'success' })
      setPermissions(prev => prev.filter(p => p.id !== id))
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <Key className="h-8 w-8 text-primary" />
        <h1 className="text-3xl font-bold">Gestion des permissions</h1>
      </div>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Nouvelle permission</CardTitle>
          <CardDescription>Ajouter une permission pour affiner les rôles</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleCreate} className="flex flex-col md:flex-row gap-4">
            <Input
              placeholder="Nom de la permission"
              value={form.name}
              onChange={e => setForm({ ...form, name: e.target.value })}
              className="rounded-xl"
            />
            <Input
              placeholder="Description"
              value={form.description}
              onChange={e => setForm({ ...form, description: e.target.value })}
              className="rounded-xl"
            />
            <Button type="submit" className="rounded-xl whitespace-nowrap">
              <Plus className="mr-2 h-4 w-4" />Créer
            </Button>
          </form>
        </CardContent>
      </Card>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Permissions existantes</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Nom</TableHead>
                <TableHead>Description</TableHead>
                <TableHead className="w-12"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {permissions.map(p => (
                <TableRow key={p.id}>
                  <TableCell>{p.id}</TableCell>
                  <TableCell>{p.name}</TableCell>
                  <TableCell>{p.description}</TableCell>
                  <TableCell>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(p.id)}>
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
              {!permissions.length && !loading && (
                <TableRow>
                  <TableCell colSpan={4} className="text-center">
                    Aucune permission
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
