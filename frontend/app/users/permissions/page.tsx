"use client"

import * as React from "react"
import { Plus, Search, Edit, Trash2, Shield, Key, Check, X, Loader2, Bot } from 'lucide-react'
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
import {
  listPermissions,
  createPermission,
  deletePermission,
  assignPermissions,
  unassignPermissions,
  getPermissionsByRole,
  Permission as PermissionBase,
} from "@/services/permissions"
import { listRoles, Role as RoleBase } from "@/services/roles"

interface Permission extends PermissionBase {
  module: string
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
  const [moduleFilter, setModuleFilter] = React.useState<string>("all")
  const [selectedRole, setSelectedRole] = React.useState<string>("all")
  const [isCreateDialogOpen, setIsCreateDialogOpen] = React.useState(false)
  const [formData, setFormData] = React.useState({ name: "", description: "", module: "" })
  const [formLoading, setFormLoading] = React.useState(false)
  const [assignLoading, setAssignLoading] = React.useState(false)
  const { toast } = useToast()

  const fetchData = React.useCallback(async () => {
    setLoading(true)
    try {
      const [permData, roleData] = await Promise.all([listPermissions(), listRoles()])
      const mappedPerms = permData.map(p => ({
        ...p,
        module: 'general',
        is_active: p.status !== 'inactif',
      }))
      setPermissions(mappedPerms)
      const rolesWithPerms = await Promise.all(
        roleData.map(async r => {
          const perms = await getPermissionsByRole(r.id)
          return { ...r, permissions: perms.map((p: Permission) => p.id) }
        })
      )
      setRoles(rolesWithPerms)
    } catch (err) {
      console.error('fetchData error', err)
    } finally {
      setLoading(false)
    }
  }, [])

  React.useEffect(() => {
    fetchData()
  }, [fetchData])

  const filteredPermissions = permissions.filter(permission => {
    const matchesSearch = permission.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         permission.description.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesModule = moduleFilter === "all" || permission.module === moduleFilter
    return matchesSearch && matchesModule
  })

  const modules = Array.from(new Set(permissions.map(p => p.module)))

  const handleCreatePermission = async () => {
    if (!formData.name.trim() || !formData.description.trim() || !formData.module.trim()) {
      toast({
        title: "Erreur",
        description: "Veuillez remplir tous les champs",
        variant: "destructive",
      })
      return
    }

    // Validate permission name format
    if (!/^[a-z]+\.[a-z_]+$/.test(formData.name)) {
      toast({
        title: "Format invalide",
        description: "Le nom doit suivre le format 'module.action' (ex: vm.create)",
        variant: "destructive",
      })
      return
    }

    // Check if permission already exists
    if (permissions.some(p => p.name === formData.name)) {
      toast({
        title: "Erreur",
        description: "Cette permission existe déjà",
        variant: "destructive",
      })
      return
    }

    setFormLoading(true)

    try {
      const created = await createPermission({ name: formData.name, description: formData.description })
      const newPermission: Permission = {
        ...created,
        module: formData.module,
        is_active: true,
      }
      setPermissions(prev => [...prev, newPermission])
      setFormData({ name: "", description: "", module: "" })
      setIsCreateDialogOpen(false)

      toast({
        title: "Permission créée",
        description: `La permission "${formData.name}" a été créée avec succès`,
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Erreur lors de la création de la permission",
        variant: "destructive",
      })
    } finally {
      setFormLoading(false)
    }
  }

  const handleDeletePermission = async (permissionId: number, permissionName: string) => { // Changed permissionId to number
    // Check if permission is used by any role
    const isUsed = roles.some(role => role.permissions.includes(permissionId))
    
    if (isUsed) {
      toast({
        title: "Suppression impossible",
        description: "Cette permission est utilisée par un ou plusieurs rôles",
        variant: "destructive",
      })
      return
    }

    try {
      await deletePermission(permissionId)
      setPermissions(prev => prev.filter(p => p.id !== permissionId))

      toast({
        title: "Permission supprimée",
        description: `La permission "${permissionName}" a été supprimée avec succès`,
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Erreur lors de la suppression de la permission",
        variant: "destructive",
      })
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

      toast({
        title: isAssigned ? "Permission retirée" : "Permission attribuée",
        description: `Permission "${permission?.name}" ${isAssigned ? "retirée de" : "attribuée au"} rôle "${role?.name}"`,
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Erreur lors de la modification des permissions",
        variant: "destructive",
      })
    } finally {
      setAssignLoading(false)
    }
  }

  const selectedRoleData = roles.find(r => String(r.id) === selectedRole) // Compare with string value from select
  const stats = {
    total: permissions.length,
    active: permissions.filter(p => p.is_active).length,
    modules: modules.length,
  }

  const aiContext = `Total: ${stats.total} permissions, Actives: ${stats.active}, Modules: ${stats.modules}. Répartition par rôle: Admin (${roles.find(r => r.name === 'admin')?.permissions.length || 0}), Technicien (${roles.find(r => r.name === 'technicien')?.permissions.length || 0}), Auditeur (${roles.find(r => r.name === 'auditeur')?.permissions.length || 0}).`

  return (
    <div className="space-y-6">
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
                Définissez une nouvelle permission avec son module associé
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="name">Nom technique</Label>
                <Input
                  id="name"
                  value={formData.name}
                  onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
                  placeholder="ex: vm.create, template.analyze"
                  className="rounded-xl"
                />
                <p className="text-xs text-muted-foreground">
                  Format: module.action (lettres minuscules et points uniquement)
                </p>
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
              <div className="space-y-2">
                <Label htmlFor="module">Module</Label>
                <Select value={formData.module} onValueChange={(value) => setFormData(prev => ({ ...prev, module: value }))}>
                  <SelectTrigger className="rounded-xl">
                    <SelectValue placeholder="Sélectionner un module" />
                  </SelectTrigger>
                  <SelectContent>
                    {modules.map(module => (
                      <SelectItem key={module} value={module}>{module}</SelectItem>
                    ))}
                    <SelectItem value="new">Nouveau module...</SelectItem>
                  </SelectContent>
                </Select>
                {formData.module === "new" && (
                  <Input
                    placeholder="Nom du nouveau module"
                    onChange={(e) => setFormData(prev => ({ ...prev, module: e.target.value }))}
                    className="rounded-xl mt-2"
                  />
                )}
              </div>
              <div className="flex gap-2 pt-4">
                <Button
                  variant="outline"
                  onClick={() => {
                    setIsCreateDialogOpen(false)
                    setFormData({ name: "", description: "", module: "" })
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
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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
        <Card className="rounded-2xl">
          <CardContent className="p-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-muted-foreground">Modules</p>
                <p className="text-2xl font-bold text-blue-600">{stats.modules}</p>
              </div>
              <Shield className="h-8 w-8 text-blue-600" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex gap-4 flex-wrap">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher une permission..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="pl-10 rounded-xl"
          />
        </div>
        <Select value={moduleFilter} onValueChange={setModuleFilter}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Filtrer par module" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tous les modules</SelectItem>
            {modules.map(module => (
              <SelectItem key={module} value={module}>{module}</SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={selectedRole} onValueChange={setSelectedRole}>
          <SelectTrigger className="w-48 rounded-xl">
            <SelectValue placeholder="Gérer les permissions pour" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Voir toutes les permissions</SelectItem>
            {roles.map(role => (
              <SelectItem key={role.id} value={String(role.id)}>Rôle: {role.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* Permissions List */}
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Key className="h-5 w-5" />
            {selectedRole === "all" ? "Toutes les permissions" : `Permissions du rôle "${selectedRoleData?.name}"`}
          </CardTitle>
          <CardDescription>
            {filteredPermissions.length} permission(s) trouvée(s) sur {permissions.length} au total
          </CardDescription>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex items-center justify-center py-12">
              <Loader2 className="h-8 w-8 animate-spin" />
              <span className="ml-2">Chargement des permissions...</span>
            </div>
          ) : (
            <div className="space-y-4">
              {filteredPermissions.map((permission, index) => {
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
                          <h4 className="font-medium font-mono text-sm">{permission.name}</h4>
                          <Badge variant="outline" className="text-xs">
                            {permission.module}
                          </Badge>
                    {permission.is_active ? (
                            <Badge variant="success" className="text-xs">Actif</Badge>
                          ) : (
                            <Badge variant="warning" className="text-xs">Inactif</Badge>
                          )}
                        </div>
                        <p className="text-sm text-muted-foreground mt-1">{permission.description}</p>
                        <div className="flex items-center gap-4 text-xs text-muted-foreground mt-2">
                          <span>Créé le {new Date(permission.created_at).toLocaleDateString("fr-FR")}</span>
                          {isUsedByRoles.length > 0 && (
                            <span>Utilisé par: {isUsedByRoles.map(r => r.name).join(", ")}</span>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <Button variant="outline" size="sm" className="rounded-xl">
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
                              Êtes-vous sûr de vouloir supprimer la permission "{permission.name}" ? Cette action est irréversible.
                            </AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Annuler</AlertDialogCancel>
                            <AlertDialogAction
                              onClick={() => handleDeletePermission(permission.id, permission.name)}
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
          )}
        </CardContent>
      </Card>

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
