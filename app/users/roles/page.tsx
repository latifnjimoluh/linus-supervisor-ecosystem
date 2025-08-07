"use client"

import * as React from "react"
import { Plus, Search, Edit, Trash2, Shield, Users, Lock, Loader2 } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Badge } from "@/components/ui/badge"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle, AlertDialogTrigger } from "@/components/ui/alert-dialog"
import { useToast } from "@/hooks/use-toast"

interface Role {
  id: number // Changed to number
  name: string
  description: string
  userCount: number
  isSystem: boolean
  createdAt: string
}

// Mock data for roles
const generateMockRoles = (): Role[] => {
  return [
    {
      id: 1, // Numeric ID
      name: "admin",
      description: "Accès complet à toutes les fonctionnalités de la plateforme",
      userCount: 2,
      isSystem: true,
      createdAt: "2024-01-01T00:00:00Z",
    },
    {
      id: 2, // Numeric ID
      name: "technicien",
      description: "Gestion des VMs, déploiements et supervision technique",
      userCount: 4,
      isSystem: true,
      createdAt: "2024-01-01T00:00:00Z",
    },
    {
      id: 3, // Numeric ID
      name: "auditeur",
      description: "Consultation des logs, rapports et données de supervision",
      userCount: 3,
      isSystem: true,
      createdAt: "2024-01-01T00:00:00Z",
    },
    {
      id: 4, // Numeric ID
      name: "visiteur",
      description: "Accès en lecture seule aux tableaux de bord",
      userCount: 0,
      isSystem: false,
      createdAt: "2024-06-15T10:30:00Z",
    },
  ]
}

export default function RolesPage() {
  const [roles, setRoles] = React.useState<Role[]>([])
  const [loading, setLoading] = React.useState(true)
  const [searchTerm, setSearchTerm] = React.useState("")
  const [isCreateDialogOpen, setIsCreateDialogOpen] = React.useState(false)
  const [editingRole, setEditingRole] = React.useState<Role | null>(null)
  const [formData, setFormData] = React.useState({ name: "", description: "" })
  const [formLoading, setFormLoading] = React.useState(false)
  const { toast } = useToast()

  const fetchRoles = React.useCallback(() => {
    setLoading(true)
    setTimeout(() => {
      setRoles(generateMockRoles())
      setLoading(false)
    }, 1000)
  }, [])

  React.useEffect(() => {
    fetchRoles()
  }, [fetchRoles])

  const filteredRoles = roles.filter(role =>
    role.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    role.description.toLowerCase().includes(searchTerm.toLowerCase())
  )

  const handleCreateRole = async () => {
    if (!formData.name.trim() || !formData.description.trim()) {
      toast({
        title: "Erreur",
        description: "Veuillez remplir tous les champs",
        variant: "destructive",
      })
      return
    }

    // Check if role name already exists
    if (roles.some(role => role.name.toLowerCase() === formData.name.toLowerCase())) {
      toast({
        title: "Erreur",
        description: "Un rôle avec ce nom existe déjà",
        variant: "destructive",
      })
      return
    }

    setFormLoading(true)

    try {
      await new Promise(resolve => setTimeout(resolve, 1500))

      const newRole: Role = {
        id: roles.length > 0 ? Math.max(...roles.map(r => r.id)) + 1 : 1, // Generate new numeric ID
        name: formData.name,
        description: formData.description,
        userCount: 0,
        isSystem: false,
        createdAt: new Date().toISOString(),
      }

      setRoles(prev => [...prev, newRole])
      setFormData({ name: "", description: "" })
      setIsCreateDialogOpen(false)

      toast({
        title: "Rôle créé",
        description: `Le rôle "${formData.name}" a été créé avec succès`,
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Erreur lors de la création du rôle",
        variant: "destructive",
      })
    } finally {
      setFormLoading(false)
    }
  }

  const handleEditRole = async () => {
    if (!editingRole || !formData.name.trim() || !formData.description.trim()) {
      return
    }

    setFormLoading(true)

    try {
      await new Promise(resolve => setTimeout(resolve, 1500))

      setRoles(prev => prev.map(role => 
        role.id === editingRole.id 
          ? { ...role, name: formData.name, description: formData.description }
          : role
      ))

      setEditingRole(null)
      setFormData({ name: "", description: "" })

      toast({
        title: "Rôle modifié",
        description: `Le rôle a été mis à jour avec succès`,
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Erreur lors de la modification du rôle",
        variant: "destructive",
      })
    } finally {
      setFormLoading(false)
    }
  }

  const handleDeleteRole = async (roleId: number, roleName: string) => { // Changed roleId to number
    try {
      await new Promise(resolve => setTimeout(resolve, 1000))

      setRoles(prev => prev.filter(role => role.id !== roleId))

      toast({
        title: "Rôle supprimé",
        description: `Le rôle "${roleName}" a été supprimé avec succès`,
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Erreur lors de la suppression du rôle",
        variant: "destructive",
      })
    }
  }

  const openEditDialog = (role: Role) => {
    setEditingRole(role)
    setFormData({ name: role.name, description: role.description })
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Gestion des rôles</h1>
        <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
          <DialogTrigger asChild>
            <Button className="rounded-xl">
              <Plus className="mr-2 h-4 w-4" />
              Créer un rôle
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>Créer un nouveau rôle</DialogTitle>
              <DialogDescription>
                Définissez un nouveau rôle avec ses permissions associées
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="name">Nom du rôle</Label>
                <Input
                  id="name"
                  value={formData.name}
                  onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
                  placeholder="ex: manager"
                  className="rounded-xl"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="description">Description</Label>
                <Input
                  id="description"
                  value={formData.description}
                  onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
                  placeholder="Description des permissions de ce rôle"
                  className="rounded-xl"
                />
              </div>
              <div className="flex gap-2 pt-4">
                <Button
                  variant="outline"
                  onClick={() => {
                    setIsCreateDialogOpen(false)
                    setFormData({ name: "", description: "" })
                  }}
                  className="rounded-xl"
                >
                  Annuler
                </Button>
                <Button
                  onClick={handleCreateRole}
                  disabled={formLoading}
                  className="rounded-xl flex-1"
                >
                  {formLoading ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Création...
                    </>
                  ) : (
                    "Créer le rôle"
                  )}
                </Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Search */}
      <div className="relative max-w-sm">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
        <Input
          placeholder="Rechercher un rôle..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="pl-10 rounded-xl"
        />
      </div>

      {/* Roles List */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {loading ? (
          Array.from({ length: 4 }).map((_, index) => (
            <Card key={index} className="rounded-2xl">
              <CardContent className="p-6">
                <div className="space-y-3">
                  <div className="h-4 bg-muted animate-pulse rounded" />
                  <div className="h-3 bg-muted animate-pulse rounded w-3/4" />
                  <div className="h-3 bg-muted animate-pulse rounded w-1/2" />
                </div>
              </CardContent>
            </Card>
          ))
        ) : (
          filteredRoles.map((role, index) => (
            <motion.div
              key={role.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.3, delay: index * 0.1 }}
            >
              <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40 hover:shadow-lg transition-shadow">
                <CardHeader className="pb-3">
                  <div className="flex items-center justify-between">
                    <CardTitle className="flex items-center gap-2">
                      <Shield className="h-5 w-5" />
                      {role.name}
                    </CardTitle>
                    <div className="flex items-center gap-2">
                      {role.isSystem && (
                        <Badge variant="outline" className="text-xs">
                          <Lock className="mr-1 h-3 w-3" />
                          Système
                        </Badge>
                      )}
                      <Badge variant="secondary" className="text-xs">
                        <Users className="mr-1 h-3 w-3" />
                        {role.userCount}
                      </Badge>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="space-y-4">
                  <p className="text-sm text-muted-foreground">{role.description}</p>
                  
                  <div className="text-xs text-muted-foreground">
                    Créé le {new Date(role.createdAt).toLocaleDateString("fr-FR")}
                  </div>

                  <div className="flex gap-2 pt-2 border-t">
                    <Button
                      variant="outline"
                      size="sm"
                      className="flex-1 rounded-xl"
                      onClick={() => openEditDialog(role)}
                      disabled={role.isSystem}
                    >
                      <Edit className="mr-2 h-4 w-4" />
                      Modifier
                    </Button>
                    <AlertDialog>
                      <AlertDialogTrigger asChild>
                        <Button
                          variant="destructive"
                          size="sm"
                          className="rounded-xl"
                          disabled={role.isSystem || role.userCount > 0}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </AlertDialogTrigger>
                      <AlertDialogContent>
                        <AlertDialogHeader>
                          <AlertDialogTitle>Supprimer le rôle</AlertDialogTitle>
                          <AlertDialogDescription>
                            Êtes-vous sûr de vouloir supprimer le rôle "{role.name}" ? Cette action est irréversible.
                          </AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                          <AlertDialogCancel>Annuler</AlertDialogCancel>
                          <AlertDialogAction 
                            onClick={() => handleDeleteRole(role.id, role.name)}
                            className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                          >
                            Supprimer
                          </AlertDialogAction>
                        </AlertDialogFooter>
                      </AlertDialogContent>
                    </AlertDialog>
                  </div>

                  {role.userCount > 0 && (
                    <p className="text-xs text-muted-foreground">
                      ⚠️ Ce rôle ne peut pas être supprimé car il est utilisé par {role.userCount} utilisateur(s)
                    </p>
                  )}
                </CardContent>
              </Card>
            </motion.div>
          ))
        )}
      </div>

      {/* Edit Role Dialog */}
      <Dialog open={!!editingRole} onOpenChange={() => setEditingRole(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Modifier le rôle</DialogTitle>
            <DialogDescription>
              Modifiez les informations du rôle sélectionné
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="edit-name">Nom du rôle</Label>
              <Input
                id="edit-name"
                value={formData.name}
                onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
                className="rounded-xl"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-description">Description</Label>
              <Input
                id="edit-description"
                value={formData.description}
                onChange={(e) => setFormData(prev => ({ ...prev, description: e.target.value }))}
                className="rounded-xl"
              />
            </div>
            <div className="flex gap-2 pt-4">
              <Button
                variant="outline"
                onClick={() => {
                  setEditingRole(null)
                  setFormData({ name: "", description: "" })
                }}
                className="rounded-xl"
              >
                Annuler
              </Button>
              <Button
                onClick={handleEditRole}
                disabled={formLoading}
                className="rounded-xl flex-1"
              >
                {formLoading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Modification...
                  </>
                ) : (
                  "Mettre à jour"
                )}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {filteredRoles.length === 0 && !loading && (
        <div className="text-center py-12">
          <Shield className="h-12 w-12 mx-auto text-muted-foreground mb-4" />
          <h3 className="text-lg font-semibold mb-2">Aucun rôle trouvé</h3>
          <p className="text-muted-foreground mb-4">
            {searchTerm
              ? "Aucun rôle ne correspond à votre recherche."
              : "Aucun rôle n'est configuré."}
          </p>
          <Button onClick={() => setIsCreateDialogOpen(true)} className="rounded-xl">
            <Plus className="mr-2 h-4 w-4" />
            Créer le premier rôle
          </Button>
        </div>
      )}
    </div>
  )
}
