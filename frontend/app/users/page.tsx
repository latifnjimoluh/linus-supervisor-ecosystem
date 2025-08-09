"use client"

import * as React from "react"
import Link from "next/link"
import { Plus, Search, Filter, RefreshCw, User, Edit, Trash2, Lock, CheckCircle, XCircle, Mail, Shield, Loader2, Eye } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog"
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet"
import { useToast } from "@/hooks/use-toast"
import { listUsers, patchUser, deleteUser, getUser, User as UserAccount } from "@/services/users"
import { listRoles, Role } from "@/services/roles"

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

  const fetchUsers = React.useCallback(async () => {
    setLoading(true)
    try {
      const [usersData, rolesData] = await Promise.all([listUsers(), listRoles()])
      const mappedUsers = usersData.map(u => ({
        ...u,
        status: u.status === 'actif' ? 'active' : u.status === 'inactif' ? 'inactive' : u.status,
      }))
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
          setUsers(prev => prev.map(u => u.id === userId ? { ...u, status: "inactive" as const } : u))
          message = `Utilisateur ${userEmail} désactivé avec succès`
          break
        case "activate":
          await patchUser(userId, { status: "actif" })
          setUsers(prev => prev.map(u => u.id === userId ? { ...u, status: "active" as const } : u))
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

      toast({
        title: "Action réussie",
        description: message,
        variant,
      })
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Une erreur est survenue",
        variant: "destructive",
      })
    } finally {
      setActionLoading(null)
    }
  }

  const handleViewUser = async (userId: number) => {
    try {
      const data = await getUser(userId)
      const mapped = {
        ...data,
        status: data.status === 'actif' ? 'active' : data.status === 'inactif' ? 'inactive' : data.status,
      }
      setDetailUser(mapped)
      setDetailOpen(true)
    } catch (err) {
      console.error('handleViewUser error', err)
    }
  }

  const getRoleBadgeVariant = (roleId: number) => {
    return "default"
  }

  const getRoleLabel = (roleId: number) => {
    const role = roles.find(r => r.id === roleId)
    return role ? role.name : "Inconnu"
  }

  const stats = {
    total: users.length,
    active: users.filter(user => user.status === "active").length,
    inactive: users.filter(user => user.status === "inactive").length,
    admins: users.filter(user => user.role_id === 1).length, // Filter by role_id 1 for admin
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Gestion des utilisateurs</h1>
        <div className="flex gap-3">
          <Button onClick={fetchUsers} variant="outline" size="sm" className="rounded-xl">
            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? "animate-spin" : ""}`} />
            Actualiser
          </Button>
          <Button asChild className="rounded-xl">
            <Link href="/users/create">
              <Plus className="mr-2 h-4 w-4" />
              Créer un utilisateur
            </Link>
          </Button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="rounded-2xl">
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
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Actifs</p>
                <p className="text-2xl font-bold text-green-600">{stats.active}</p>
              </div>
              <CheckCircle className="h-8 w-8 text-green-600" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Inactifs</p>
                <p className="text-2xl font-bold text-yellow-600">{stats.inactive}</p>
              </div>
              <XCircle className="h-8 w-8 text-yellow-600" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Admins</p>
                <p className="text-2xl font-bold text-red-600">{stats.admins}</p>
              </div>
              <Shield className="h-8 w-8 text-red-600" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex gap-4 flex-wrap">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher par nom ou email..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10 rounded-xl"
          />
        </div>
        <Select value={roleFilter} onValueChange={setRoleFilter}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Filtrer par rôle" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les rôles</SelectItem>
            {roles.map(role => (
              <SelectItem key={role.id} value={String(role.id)}>{role.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Filtrer par statut" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les statuts</SelectItem>
            <SelectItem value="active">Actifs</SelectItem>
            <SelectItem value="inactive">Inactifs</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Users Table */}
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
        <CardContent>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <Loader2 className="h-8 w-8 animate-spin" />
              <span className="ml-2">Chargement des utilisateurs...</span>
            </div>
          ) : (
            <div className="space-y-4">
              {filteredUsers.map((user, index) => (
                <motion.div
                  key={user.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.3, delay: index * 0.05 }}
                  className="flex items-center justify-between p-4 border rounded-xl hover:bg-muted/50 transition-colors"
                >
                  <div className="flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-muted flex items-center justify-center">
                      <span className="text-sm font-medium">
                        {user.first_name[0]}{user.last_name[0]}
                      </span>
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <h4 className="font-medium">{user.first_name} {user.last_name}</h4>
                        <Badge variant={user.status === "active" ? "success" : "warning"} className="text-xs">
                          {user.status === "active" ? "Actif" : "Inactif"}
                        </Badge>
                      </div>
                      <div className="flex items-center gap-4 text-sm text-muted-foreground">
                        <span className="flex items-center gap-1">
                          <Mail className="h-3 w-3" />
                          {user.email}
                        </span>
                        <Badge variant={getRoleBadgeVariant(user.role_id)} className="text-xs">
                          {getRoleLabel(user.role_id)}
                        </Badge>
                      </div>
                      <div className="text-xs text-muted-foreground mt-1">
                        Créé le {new Date(user.created_at).toLocaleDateString("fr-FR")}
                        {user.last_login && (
                          <span className="ml-4">
                            Dernière connexion: {new Date(user.last_login).toLocaleDateString("fr-FR")}
                          </span>
                        )}
                      </div>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      className="rounded-xl"
                      onClick={() => handleViewUser(user.id)}
                    >
                      <Eye className="h-4 w-4" />
                    </Button>
                    <Button asChild variant="outline" size="sm" className="rounded-xl">
                      <Link href={`/users/${user.id}/edit`}>
                        <Edit className="h-4 w-4" />
                      </Link>
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      className="rounded-xl"
                      onClick={() => handleUserAction("reset-password", user.id, user.email)}
                      disabled={actionLoading === `reset-password-${user.id}`}
                    >
                      {actionLoading === `reset-password-${user.id}` ? (
                        <Loader2 className="h-4 w-4 animate-spin" />
                      ) : (
                        <Lock className="h-4 w-4" />
                      )}
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      className="rounded-xl"
                      onClick={() => handleUserAction(user.status === "active" ? "deactivate" : "activate", user.id, user.email)}
                      disabled={actionLoading === `${user.status === "active" ? "deactivate" : "activate"}-${user.id}`}
                    >
                      {actionLoading === `${user.status === "active" ? "deactivate" : "activate"}-${user.id}` ? (
                        <Loader2 className="h-4 w-4 animate-spin" />
                      ) : user.status === "active" ? (
                        <XCircle className="h-4 w-4" />
                      ) : (
                        <CheckCircle className="h-4 w-4" />
                      )}
                    </Button>
                    <AlertDialog>
                      <AlertDialogTrigger asChild>
                        <Button variant="destructive" size="sm" className="rounded-xl">
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </AlertDialogTrigger>
                      <AlertDialogContent>
                        <AlertDialogHeader>
                          <AlertDialogTitle>Supprimer l'utilisateur</AlertDialogTitle>
                          <AlertDialogDescription>
                            ⚠️ Cette action est irréversible ! L'utilisateur "{user.first_name} {user.last_name}" ({user.email}) sera définitivement supprimé.
                          </AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                          <AlertDialogCancel>Annuler</AlertDialogCancel>
                          <AlertDialogAction 
                            onClick={() => handleUserAction("delete", user.id, user.email)}
                            className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                          >
                            Supprimer définitivement
                          </AlertDialogAction>
                        </AlertDialogFooter>
                      </AlertDialogContent>
                    </AlertDialog>
                  </div>
                </motion.div>
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

      <Sheet open={detailOpen} onOpenChange={setDetailOpen}>
        <SheetContent>
          <SheetHeader>
            <SheetTitle>
              {detailUser ? `${detailUser.first_name} ${detailUser.last_name}` : "Utilisateur"}
            </SheetTitle>
            {detailUser && (
              <SheetDescription>{detailUser.email}</SheetDescription>
            )}
          </SheetHeader>
          {detailUser && (
            <div className="space-y-2 mt-4 text-sm">
              <p><strong>Rôle :</strong> {getRoleLabel(detailUser.role_id)}</p>
              <p><strong>Statut :</strong> {detailUser.status === "active" ? "Actif" : "Inactif"}</p>
              <p><strong>Téléphone :</strong> {detailUser.phone || "—"}</p>
              <p><strong>Créé le :</strong> {new Date(detailUser.created_at).toLocaleDateString("fr-FR")}</p>
              {detailUser.last_login && (
                <p><strong>Dernière connexion :</strong> {new Date(detailUser.last_login).toLocaleDateString("fr-FR")}</p>
              )}
            </div>
          )}
        </SheetContent>
      </Sheet>
    </div>
  )
}
