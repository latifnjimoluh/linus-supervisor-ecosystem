"use client"

import * as React from "react"
import { Plus, Search, Edit, Trash2, Key, Check, Loader2, ArrowUpDown } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Badge } from "@/components/ui/badge"
import { Checkbox } from "@/components/ui/checkbox"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { useToast } from "@/hooks/use-toast"
import { useErrors } from "@/hooks/use-errors"
import { ErrorBanner } from "@/components/error-banner"
import {
  listPermissions,
  createPermission,
  updatePermission,
  deletePermission,
  assignPermissions,
  unassignPermissions,
  getPermissionsByRole,
  Permission as PermissionBase,
} from "@/services/permissions"
import { listRoles, Role as RoleBase } from "@/services/roles"
import { capitalize } from "@/lib/utils"

interface Permission extends PermissionBase {
  is_active: boolean
}

interface Role extends RoleBase {
  permissions: number[]
}

// Simulate AI analysis for permissions
const simulatePermissionsAIAnalysis = async (context: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 2500))
  
  const totalPermissions = (context.match(/Total: (\d+)/)?.[1]) || "0"
  const activePermissions = (context.match(/Actives: (\d+)/)?.[1]) || "0"
  
  return `🤖 **Analyse IA du système de permissions**

**📊 Vue d'ensemble:**
Votre système compte ${totalPermissions} permissions dont ${activePermissions} sont actives.

**🔍 Analyse de sécurité:**
✅ **Structure modulaire** - Les permissions sont bien organisées par modules (VM Management, Templates, Logs, User Management, System)

✅ **Principe du moindre privilège** - La répartition des permissions par rôle respecte les bonnes pratiques :
- **Admin** : Accès complet (${Math.round((15/15)*100)}% des permissions)
- **Technicien** : Accès opérationnel (${Math.round((7/15)*100)}% des permissions)
- **Auditeur** : Accès consultation (${Math.round((3/15)*100)}% des permissions)

**🎯 Recommandations de sécurité:**

1. **Audit régulier** : Vérifiez périodiquement que les permissions attribuées correspondent aux besoins réels
2. **Permissions granulaires** : Considérez diviser certaines permissions larges (ex: vm.manage → vm.start, vm.stop)
3. **Traçabilité** : Toute modification de permissions devrait être loggée
4. **Révision des accès** : Planifiez une revue trimestrielle des permissions par rôle

**⚠️ Points d'attention:**
- Permission "permissions.manage" très sensible - à réserver aux super-admins
- Permission "system.config" critique pour la sécurité globale
- Vérifier que les permissions de suppression (delete) sont bien contrôlées

**🔧 Actions suggérées:**
- Implémenter un système d'approbation pour les permissions critiques
- Ajouter des permissions temporaires avec expiration automatique
- Créer des rôles métier plus spécialisés si nécessaire

*Analyse générée le ${new Date().toLocaleString('fr-FR')}*`
}

export default function PermissionsPage() {
  const [permissions, setPermissions] = React.useState<Permission[]>([])
  const [roles, setRoles] = React.useState<Role[]>([])
  const [loading, setLoading] = React.useState(true)
  const [searchTerm, setSearchTerm] = React.useState("")
  const [sortField, setSortField] = React.useState("key")
  const [sortOrder, setSortOrder] = React.useState<"asc" | "desc">("asc")
  const [selectedRole, setSelectedRole] = React.useState<string>("all")
  const [isCreateDialogOpen, setIsCreateDialogOpen] = React.useState(false)
  const [editingPermission, setEditingPermission] = React.useState<Permission | null>(null)
  const [formData, setFormData] = React.useState({ key: "", name: "", description: "" })
  const [editData, setEditData] = React.useState({ key: "", name: "", description: "" })
  const [formLoading, setFormLoading] = React.useState(false)
  const [editLoading, setEditLoading] = React.useState(false)
  const [assignLoading, setAssignLoading] = React.useState(false)
  const [pagination, setPagination] = React.useState({ page: 1, pages: 1, total: 0, limit: 10 })
  const { toast } = useToast()
  const { setError, clearError } = useErrors()

  const fetchData = React.useCallback(async () => {
    setLoading(true)
    try {
      const permRes = await listPermissions(pagination.page, pagination.limit, searchTerm, sortField, sortOrder)
      const roleData = await listRoles()
      const rolesWithPerms = await Promise.all(
        roleData.map(async r => {
          const perms = await getPermissionsByRole(r.id)
          return { ...r, permissions: perms.map((p: Permission) => p.id) }
        })
      )
      setRoles(rolesWithPerms)
      const mappedPerms = permRes.data.map(p => ({
        ...p,
        is_active: p.status !== 'inactif',
      }))
      setPermissions(mappedPerms)
      setPagination(permRes.pagination)
    } catch (err) {
      console.error('fetchData error', err)
    } finally {
      setLoading(false)
    }
  }, [pagination.page, pagination.limit, searchTerm, sortField, sortOrder])

  React.useEffect(() => {
    fetchData()
  }, [fetchData])

  const handleCreatePermission = async () => {
    if (!formData.key.trim() || !formData.name.trim() || !formData.description.trim()) {
      setError("permissions", { message: "Veuillez remplir tous les champs", ttlMs: 5000 })
      return
    }

    // Validate permission key format
    if (!/^[a-z]+\.[a-z_]+$/.test(formData.key)) {
      setError("permissions", { message: "La clé doit suivre le format 'module.action' (ex: vm.create)", ttlMs: 5000 })
      return
    }

    setFormLoading(true)

    try {
      await createPermission({ key: formData.key, name: formData.name, description: formData.description })
      setFormData({ key: "", name: "", description: "" })
      setIsCreateDialogOpen(false)
      clearError("permissions")
      toast({
        title: "Permission créée",
        description: `La permission "${formData.key}" a été créée avec succès`,
        variant: "success",
      })
      fetchData()
    } catch (error) {
      setError("permissions", { message: "Erreur lors de la création de la permission" })
    } finally {
      setFormLoading(false)
    }
  }

  const handleEditPermission = async () => {
    if (!editingPermission) return
    if (!editData.key.trim() || !editData.name.trim() || !editData.description.trim()) {
      setError("permissions", { message: "Veuillez remplir tous les champs", ttlMs: 5000 })
      return
    }
    setEditLoading(true)
    try {
      await updatePermission(editingPermission.id, editData)
      clearError("permissions")
      toast({
        title: "Permission mise à jour",
        description: `La permission "${editData.key}" a été mise à jour avec succès`,
        variant: "success",
      })
      setEditingPermission(null)
      fetchData()
    } catch (error) {
      setError("permissions", { message: "Erreur lors de la mise à jour de la permission" })
    } finally {
      setEditLoading(false)
    }
  }

  const handleDeletePermission = async (permissionId: number, permissionName: string) => { // Changed permissionId to number
    // Check if permission is used by any role
    const isUsed = roles.some(role => role.permissions.includes(permissionId))
    
    if (isUsed) {
      setError("permissions", { message: "Cette permission est utilisée par un ou plusieurs rôles", ttlMs: 5000 })
      return
    }

    try {
      await deletePermission(permissionId)
      fetchData()

      clearError("permissions")
      toast({
        title: "Permission supprimée",
        description: `La permission "${permissionName}" a été supprimée avec succès`,
        variant: "success",
      })
    } catch (error) {
      setError("permissions", { message: "Erreur lors de la suppression de la permission" })
    }
  }

  const handlePermissionToggle = async (roleId: number, permissionId: number, isAssigned: boolean) => { // Changed IDs to number
    setAssignLoading(true)

    try {
      if (isAssigned) {
        await unassignPermissions(roleId, [permissionId])
      } else {
        await assignPermissions(roleId, [permissionId])
      }

      setRoles(prev => prev.map(role => {
        if (role.id === roleId) {
          const newPermissions = isAssigned
            ? role.permissions.filter(p => p !== permissionId)
            : [...role.permissions, permissionId]
          return { ...role, permissions: newPermissions }
        }
        return role
      }))

      const permission = permissions.find(p => p.id === permissionId)
      const role = roles.find(r => r.id === roleId)

      clearError("permissions")
      toast({
        title: isAssigned ? "Permission retirée" : "Permission attribuée",
        description: `Permission "${permission?.name}" ${isAssigned ? "retirée de" : "attribuée au"} rôle "${role?.name}"`,
        variant: "success",
      })
    } catch (error) {
      setError("permissions", { message: "Erreur lors de la modification des permissions" })
    } finally {
      setAssignLoading(false)
    }
  }

  const selectedRoleData = roles.find(r => String(r.id) === selectedRole)
  const stats = {
    total: pagination.total,
    active: permissions.filter(p => p.is_active).length,
  }

const aiContext = `Total: ${stats.total} permissions, Actives: ${stats.active}. Répartition par rôle: Admin (${roles.find(r => r.name === 'admin')?.permissions.length || 0}), Technicien (${roles.find(r => r.name === 'technicien')?.permissions.length || 0}), Auditeur (${roles.find(r => r.name === 'auditeur')?.permissions.length || 0}).`;

  return (
    <div className="space-y-6">
      <ErrorBanner id="permissions" />
      {/* Header */}
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Gestion des permissions</h1>
        <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
          <DialogTrigger asChild>
            <Button className="rounded-xl">
              <Plus className="mr-2 h-4 w-4" />
              Nouvelle permission
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Créer une nouvelle permission</DialogTitle>
              <DialogDescription>
                Définissez une nouvelle permission
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="key">Clé</Label>
                <Input
                  id="key"
                  value={formData.key}
                  onChange={(e) => setFormData(prev => ({ ...prev, key: e.target.value }))}
                  placeholder="ex: vm.create"
                  className="rounded-xl"
                />
                <p className="text-xs text-muted-foreground">
                  Format: module.action (lettres minuscules et points uniquement)
                </p>
              </div>
              <div className="space-y-2">
                <Label htmlFor="name">Nom</Label>
                <Input
                  id="name"
                  value={formData.name}
                  onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
                  placeholder="Nom lisible"
                  className="rounded-xl"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="description">Description</Label>
                <Input
                  id="description"
                  value={formData.description}
                  onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
                  placeholder="Description de la permission"
                  className="rounded-xl"
                />
              </div>
              <div className="flex gap-2 pt-4">
                <Button
                  variant="outline"
                  onClick={() => {
                    setIsCreateDialogOpen(false)
                    setFormData({ key: "", name: "", description: "" })
                  }}
                  className="rounded-xl"
                >
                  Annuler
                </Button>
                <Button
                  onClick={handleCreatePermission}
                  disabled={formLoading}
                  className="rounded-xl flex-1"
                >
                  {formLoading ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Création...
                    </>
                  ) : (
                    "Créer la permission"
                  )}
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Total</p>
                <p className="text-2xl font-bold">{stats.total}</p>
              </div>
              <Key className="h-8 w-8 text-muted-foreground" />
            </div>
          </CardContent>
        </Card>
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Actives</p>
                <p className="text-2xl font-bold text-green-600">{stats.active}</p>
              </div>
              <Check className="h-8 w-8 text-green-600" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex gap-4 flex-wrap items-center">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher une permission..."
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value)
              setPagination(p => ({ ...p, page: 1 }))
            }}
            className="pl-10 rounded-xl"
          />
        </div>
        <Select value={sortField} onValueChange={(v) => { setSortField(v); setPagination(p => ({...p, page:1})) }}>
          <SelectTrigger className="w-40 rounded-xl">
            <SelectValue placeholder="Trier par" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="key">Clé</SelectItem>
            <SelectItem value="name">Nom</SelectItem>
          </SelectContent>
        </Select>
        <Button variant="outline" size="icon" className="rounded-xl" onClick={() => setSortOrder(o => o === 'asc' ? 'desc' : 'asc')}>
          <ArrowUpDown className="h-4 w-4" />
        </Button>
        <Select value={selectedRole} onValueChange={setSelectedRole}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Gérer les permissions pour" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Voir toutes les permissions</SelectItem>
            {roles.map(role => (
              <SelectItem key={role.id} value={String(role.id)}>Rôle: {capitalize(role.name)}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* Permissions List */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Key className="h-5 w-5" />
            {selectedRole === "all" ? "Toutes les permissions" : `Permissions du rôle "${capitalize(selectedRoleData?.name ?? "" )}"`}
          </CardTitle>
          <CardDescription>
            {permissions.length} permission(s) trouvée(s) sur {pagination.total} au total
          </CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <Loader2 className="h-8 w-8 animate-spin" />
              <span className="ml-2">Chargement des permissions...</span>
            </div>
          ) : (
            <>
            <div className="space-y-4">
              {permissions.map((permission, index) => {
                const isAssigned = selectedRoleData?.permissions.includes(permission.id) || false
                const isUsedByRoles = roles.filter(role => role.permissions.includes(permission.id))

                return (
                  <motion.div
                    key={permission.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.3, delay: index * 0.05 }}
                    className="flex items-center justify-between p-4 border rounded-xl hover:bg-muted/50 transition-colors"
                  >
                    <div className="flex items-center gap-4">
                      {selectedRole !== "all" && (
                        <Checkbox
                          checked={isAssigned}
                          onCheckedChange={(checked) =>
                            handlePermissionToggle(parseInt(selectedRole), permission.id, isAssigned)
                          }
                          disabled={assignLoading}
                        />
                      )}
                      <div>
                        <div className="flex items-center gap-2">
                          <h4 className="font-medium font-mono text-sm">{permission.key}</h4>
                          {permission.is_active ? (
                            <Badge variant="success" className="text-xs">Actif</Badge>
                          ) : (
                            <Badge variant="warning" className="text-xs">Inactif</Badge>
                          )}
                        </div>
                        <p className="text-sm">{permission.name}</p>
                        <p className="text-sm text-muted-foreground mt-1">{permission.description}</p>
                        <div className="flex items-center gap-4 text-xs text-muted-foreground mt-2">
                          <span>
                            Créé le{' '}
                            {permission.createdAt
                              ? new Date(permission.createdAt).toLocaleDateString("fr-FR")
                              : '—'}
                          </span>
                          {isUsedByRoles.length > 0 && (
                            <span>Utilisé par: {isUsedByRoles.map(r => capitalize(r.name)).join(", ")}</span>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Button variant="outline" size="sm" className="rounded-xl" onClick={() => {
                        setEditingPermission(permission)
                        setEditData({ key: permission.key, name: permission.name, description: permission.description })
                      }}>
                        <Edit className="h-4 w-4" />
                      </Button>
                      <AlertDialog>
                        <AlertDialogTrigger asChild>
                          <Button
                            variant="destructive"
                            size="sm"
                            className="rounded-xl"
                            disabled={isUsedByRoles.length > 0}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </AlertDialogTrigger>
                        <AlertDialogContent>
                          <AlertDialogHeader>
                            <AlertDialogTitle>Supprimer la permission</AlertDialogTitle>
                            <AlertDialogDescription>
                              Êtes-vous sûr de vouloir supprimer la permission "{permission.key}" ? Cette action est irréversible.
                            </AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Annuler</AlertDialogCancel>
                            <AlertDialogAction
                              onClick={() => handleDeletePermission(permission.id, permission.key)}
                              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                            >
                              Supprimer
                            </AlertDialogAction>
                          </AlertDialogFooter>
                        </AlertDialogContent>
                      </AlertDialog>
                    </div>
                  </motion.div>
                )
              })}
            </div>
            <div className="flex items-center justify-between pt-4">
              <span className="text-sm text-muted-foreground">
                Page {pagination.page} sur {pagination.pages}
              </span>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  disabled={pagination.page <= 1}
                  onClick={() =>
                    setPagination(p => ({ ...p, page: p.page - 1 }))
                  }
                >
                  Précédent
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  disabled={pagination.page >= pagination.pages}
                  onClick={() =>
                    setPagination(p => ({ ...p, page: p.page + 1 }))
                  }
                >
                  Suivant
                </Button>
              </div>
            </div>
            </>
          )}
        </CardContent>
      </Card>

      {/* Edit Permission Dialog */}
      <Dialog open={!!editingPermission} onOpenChange={() => setEditingPermission(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Modifier la permission</DialogTitle>
            <DialogDescription>Mettre à jour les détails de la permission.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="edit-key">Clé</Label>
              <Input
                id="edit-key"
                value={editData.key}
                onChange={(e) => setEditData(prev => ({ ...prev, key: e.target.value }))}
                className="rounded-xl"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-name">Nom</Label>
              <Input
                id="edit-name"
                value={editData.name}
                onChange={(e) => setEditData(prev => ({ ...prev, name: e.target.value }))}
                className="rounded-xl"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-description">Description</Label>
              <Input
                id="edit-description"
                value={editData.description}
                onChange={(e) => setEditData(prev => ({ ...prev, description: e.target.value }))}
                className="rounded-xl"
              />
            </div>
            <div className="flex gap-2 pt-4">
              <Button
                variant="outline"
                onClick={() => setEditingPermission(null)}
                className="rounded-xl"
              >
                Annuler
              </Button>
              <Button
                onClick={handleEditPermission}
                disabled={editLoading}
                className="rounded-xl flex-1"
              >
                {editLoading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Mise à jour...
                  </>
                ) : (
                  "Mettre à jour"
                )}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* AI Analysis Block */}
      <AssistantAIBlock
        title="Analyse IA du système de permissions"
        context={aiContext}
        onAnalyze={simulatePermissionsAIAnalysis}
        className="w-full"
      />
    </div>
  )
}
