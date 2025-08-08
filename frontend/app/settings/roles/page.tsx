"use client"

import * as React from "react"
import { Shield, Plus, Trash2, Eye } from 'lucide-react'

import { Button } from "@/components/ui/button"
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/components/ui/table"
import { useToast } from "@/hooks/use-toast"
import { getRoles, createRole, deleteRole, getPermissionsByRole } from "@/services/api"

interface Role { id: number; name: string; description?: string }
interface Permission { id: number; name: string; description?: string }

export default function RolesPage() {
  const [roles, setRoles] = React.useState<Role[]>([])
  const [loading, setLoading] = React.useState(true)
  const [form, setForm] = React.useState({ name: '', description: '' })
  const [expanded, setExpanded] = React.useState<number | null>(null)
  const [permissions, setPermissions] = React.useState<Record<number, Permission[]>>({})
  const { toast } = useToast()

  const fetchRoles = React.useCallback(async () => {
    setLoading(true)
    try {
      const data = await getRoles()
      setRoles(data.data || data || [])
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    } finally {
      setLoading(false)
    }
  }, [toast])

  React.useEffect(() => { fetchRoles() }, [fetchRoles])

  const handleCreate = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      const res = await createRole(form)
      toast({ title: 'Rôle créé', description: `Rôle ${res.role?.name || res.name} créé`, variant: 'success' })
      setForm({ name: '', description: '' })
      fetchRoles()
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    }
  }

  const handleDelete = async (id: number) => {
    try {
      await deleteRole(id)
      toast({ title: 'Rôle supprimé', variant: 'success' })
      setRoles(prev => prev.filter(r => r.id !== id))
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    }
  }

  const togglePermissions = async (id: number) => {
    if (expanded === id) {
      setExpanded(null)
      return
    }
    try {
      if (!permissions[id]) {
        const data = await getPermissionsByRole(id)
        setPermissions(prev => ({ ...prev, [id]: data }))
      }
      setExpanded(id)
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <Shield className="h-8 w-8 text-primary" />
        <h1 className="text-3xl font-bold">Gestion des rôles</h1>
      </div>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Nouveau rôle</CardTitle>
          <CardDescription>Ajouter un rôle pour organiser les utilisateurs</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleCreate} className="flex flex-col md:flex-row gap-4">
            <Input
              placeholder="Nom du rôle"
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
          <CardTitle>Rôles existants</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Nom</TableHead>
                <TableHead>Description</TableHead>
                <TableHead className="w-24"></TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {roles.map(role => (
                <React.Fragment key={role.id}>
                  <TableRow>
                    <TableCell>{role.id}</TableCell>
                    <TableCell>{role.name}</TableCell>
                    <TableCell>{role.description}</TableCell>
                    <TableCell className="flex gap-2">
                      <Button variant="ghost" size="icon" onClick={() => togglePermissions(role.id)}>
                        <Eye className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="icon" onClick={() => handleDelete(role.id)}>
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </TableCell>
                  </TableRow>
                  {expanded === role.id && (
                    <TableRow>
                      <TableCell colSpan={4}>
                        <ul className="list-disc ml-4">
                          {(permissions[role.id] || []).map(p => (
                            <li key={p.id}>{p.name}</li>
                          ))}
                          {!permissions[role.id]?.length && <li>Aucune permission</li>}
                        </ul>
                      </TableCell>
                    </TableRow>
                  )}
                </React.Fragment>
              ))}
              {!roles.length && !loading && (
                <TableRow>
                  <TableCell colSpan={4} className="text-center">
                    Aucun rôle
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
