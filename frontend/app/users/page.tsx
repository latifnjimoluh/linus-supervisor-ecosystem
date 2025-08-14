"use client"

import * as React from "react"
import Link from "next/link"
import { Plus, Search, RefreshCw, User, CheckCircle, XCircle, Shield, Loader2 } from 'lucide-react'

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { useToast } from "@/hooks/use-toast"
import { useErrors } from "@/hooks/use-errors"
import { ErrorBanner } from "@/components/error-banner"
import { listUsers, patchUser, deleteUser, getUser, User as UserAccount } from "@/services/users"
import { listRoles, Role } from "@/services/roles"
import { capitalize } from "@/lib/utils"
import UserCard from "@/components/user-card"
import UserDetailsDialog from "@/components/user-details-dialog"

export default function UsersPage() {
  const [users, setUsers] = React.useState<UserAccount[]>([])
  const [roles, setRoles] = React.useState<Role[]>([])
  const [loading, setLoading] = React.useState(true)
  const [searchTerm, setSearchTerm] = React.useState("")
  const [roleFilter, setRoleFilter] = React.useState<string>("all")
  const [statusFilter, setStatusFilter] = React.useState<string>("all")
  const [actionLoading, setActionLoading] = React.useState<string | null>(null)
  const [detailOpen, setDetailOpen] = React.useState(false)
  const [detailUser, setDetailUser] = React.useState<UserAccount | null>(null)
  const { toast } = useToast()
  const { setError, clearError } = useErrors()

  // juste sous les imports
  type ApiUser = UserAccount & {
    createdAt?: string | null
    updatedAt?: string | null
    created_at?: string | null
    updated_at?: string | null
    last_login?: string | null
  }

  const normalizeUser = (u: ApiUser): UserAccount & {
    created_at?: string | null
    updated_at?: string | null
  } => ({
    ...u,
    created_at: u.created_at ?? u.createdAt ?? null,
    updated_at: u.updated_at ?? u.updatedAt ?? null,
  })

  const fetchUsers = React.useCallback(async () => {
    setLoading(true)
    try {
      const [usersData, rolesData] = await Promise.all([listUsers(), listRoles()])
      const mappedUsers = usersData.map((u: ApiUser) => normalizeUser(u))
      setUsers(mappedUsers)
      setRoles(rolesData)
    } catch (err) {
      console.error('fetchUsers error', err)
    } finally {
      setLoading(false)
    }
  }, [])


  React.useEffect(() => {
    fetchUsers()
  }, [fetchUsers])

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.first_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.last_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         user.email.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesRole = roleFilter === "all" || user.role_id === parseInt(roleFilter)
    const matchesStatus = statusFilter === "all" || user.status === statusFilter
    return matchesSearch && matchesRole && matchesStatus
  })

  const handleUserAction = async (action: string, userId: number, userEmail: string) => {
    setActionLoading(`${action}-${userId}`)

    let message = ""
    let variant: "success" | "destructive" | "info" = "success"
    try {
      switch (action) {
        case "deactivate":
          await patchUser(userId, { status: "inactif" })
          setUsers(prev => prev.map(u => u.id === userId ? { ...u, status: "inactif" as const } : u))
          message = `Utilisateur ${userEmail} désactivé avec succès`
          break
        case "activate":
          await patchUser(userId, { status: "actif" })
          setUsers(prev => prev.map(u => u.id === userId ? { ...u, status: "actif" as const } : u))
          message = `Utilisateur ${userEmail} activé avec succès`
          break
        case "reset-password":
          message = `Lien de réinitialisation envoyé à ${userEmail}`
          variant = "info"
          break
        case "delete":
          await deleteUser(userId)
          setUsers(prev => prev.filter(u => u.id !== userId))
          message = `Utilisateur ${userEmail} supprimé avec succès`
          break
        default:
          message = "Action effectuée avec succès"
      }

      clearError("users-actions")
      toast({
        title: "Action réussie",
        description: message,
        variant,
      })
    } catch (error) {
      setError("users-actions", { message: "Une erreur est survenue" })
    } finally {
      setActionLoading(null)
    }
  }

  const handleViewUser = async (userId: number) => {
    try {
      const data: ApiUser = await getUser(userId)
      const mapped = normalizeUser(data)
      setDetailUser(mapped)
      setDetailOpen(true)
    } catch (err) {
      console.error('handleViewUser error', err)
    }
  }


  const getRoleLabel = (roleId: number) => {
    const role = roles.find(r => r.id === roleId)
    return role ? capitalize(role.name) : "Inconnu"
  }

  const getRoleDescription = (roleId: number) => {
    const role = roles.find(r => r.id === roleId)
    return role ? role.description ?? "" : ""
  }

  const stats = {
    total: users.length,
    active: users.filter(user => user.status === "actif").length,
    inactive: users.filter(user => user.status === "inactif").length,
    admins: users.filter(user => user.role_id === 1).length, // Filter by role_id 1 for admin
  }

  return (
    <div className="space-y-6">
      <ErrorBanner id="users-actions" />
      {/* Header */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="text-2xl sm:text-4xl font-semibold">Gestion des utilisateurs</h1>
        <div className="flex flex-wrap gap-3">
          <Button
            onClick={fetchUsers}
            variant="outline"
            className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4"
          >
            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
            <span>Actualiser</span>
          </Button>
          <Button
            asChild
            className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4"
          >
            <Link href="/users/create">
              <Plus className="mr-2 h-4 w-4" />
              <span>Créer un utilisateur</span>
            </Link>
          </Button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Total</p>
                <p className="text-2xl font-bold">{stats.total}</p>
              </div>
              <User className="h-8 w-8 text-muted-foreground" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Actifs</p>
                <p className="text-2xl font-bold text-success">{stats.active}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-success" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Inactifs</p>
                <p className="text-2xl font-bold text-warning">{stats.inactive}</p>
              </div>
              <XCircle className="h-8 w-8 text-warning" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Admins</p>
                <p className="text-2xl font-bold text-secondary">{stats.admins}</p>
              </div>
              <Shield className="h-8 w-8 text-secondary" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher par nom ou email..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10 rounded-xl"
          />
        </div>
        <Select value={roleFilter} onValueChange={setRoleFilter}>
          <SelectTrigger className="w-full rounded-xl">
            <SelectValue placeholder="Filtrer par rôle" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les rôles</SelectItem>
            {roles.map(role => (
              <SelectItem key={role.id} value={String(role.id)}>
                <div className="flex flex-col">
                  <span className="capitalize">{capitalize(role.name)}</span>
                  {role.description && (
                    <span className="text-xs text-muted-foreground">{role.description}</span>
                  )}
                </div>
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-full rounded-xl">
            <SelectValue placeholder="Filtrer par statut" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les statuts</SelectItem>
            <SelectItem value="actif">Actifs</SelectItem>
            <SelectItem value="inactif">Inactifs</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Users List */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <User className="h-5 w-5" />
            Liste des utilisateurs
          </CardTitle>
          <CardDescription>
            {filteredUsers.length} utilisateur(s) trouvé(s) sur {users.length} au total
          </CardDescription>
        </CardHeader>
        <CardContent className="p-5">
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <Loader2 className="h-8 w-8 animate-spin" />
              <span className="ml-2">Chargement des utilisateurs...</span>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
              {filteredUsers.map((user, index) => (
                <UserCard
                  key={user.id}
                  user={user}
                  roleLabel={getRoleLabel(user.role_id)}
                  onView={handleViewUser}
                  onAction={handleUserAction}
                  actionLoading={actionLoading}
                  index={index}
                />
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {filteredUsers.length === 0 && !loading && (
        <div className="text-center py-12">
          <User className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">Aucun utilisateur trouvé</h3>
          <p className="text-muted-foreground mb-4">
            {searchTerm || roleFilter !== "all" || statusFilter !== "all"
              ? "Aucun utilisateur ne correspond à vos critères de recherche."
              : "Aucun utilisateur n'est configuré."}
          </p>
          <Button asChild className="rounded-xl">
            <Link href="/users/create">
              <Plus className="mr-2 h-4 w-4" />
              Créer le premier utilisateur
            </Link>
          </Button>
        </div>
      )}

      <UserDetailsDialog
        user={detailUser}
        open={detailOpen}
        onOpenChange={setDetailOpen}
        roleLabel={detailUser ? getRoleLabel(detailUser.role_id) : ""}
        roleDescription={detailUser ? getRoleDescription(detailUser.role_id) : ""}
      />
    </div>
  )
}
