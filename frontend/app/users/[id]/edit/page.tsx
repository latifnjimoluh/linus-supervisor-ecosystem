"use client"

import * as React from "react"
import { useRouter, useParams } from "next/navigation"
import { ArrowLeft, User, Mail, Shield, Loader2 } from 'lucide-react'
import { capitalize } from "@/lib/utils"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { useToast } from "@/hooks/use-toast"
import { getUser, updateUser } from "@/services/users"
import { listRoles, Role } from "@/services/roles"

interface EditUserForm {
  first_name: string
  last_name: string
  email: string
  phone: string
  role_id: number
  status: string
  created_at?: string
}

export default function EditUserPage() {
  const router = useRouter()
  const params = useParams()
  const id = Number(params.id)
  const { toast } = useToast()
  const [loading, setLoading] = React.useState(false)
  const [roles, setRoles] = React.useState<Role[]>([])
  const [formData, setFormData] = React.useState<EditUserForm>({
    first_name: "",
    last_name: "",
    email: "",
    phone: "",
    role_id: 0,
    status: "actif",
    created_at: "",
  })
  const [errors, setErrors] = React.useState<Partial<EditUserForm>>({})

  React.useEffect(() => {
    const fetchData = async () => {
      try {
        const [userData, rolesData] = await Promise.all([getUser(id), listRoles()])
        setFormData({
          first_name: userData.first_name,
          last_name: userData.last_name,
          email: userData.email,
          phone: userData.phone || "",
          role_id: userData.role_id,
          status: userData.status,
          created_at: userData.created_at,
        })
        setRoles(rolesData)
      } catch (err) {
        console.error('fetchData error', err)
      }
    }
    if (id) {
      fetchData()
    }
  }, [id])

  const handleInputChange = (field: keyof EditUserForm, value: string | number) => {
    setFormData(prev => ({ ...prev, [field]: value }))
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: undefined }))
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    try {
      await updateUser(id, {
        first_name: formData.first_name,
        last_name: formData.last_name,
        phone: formData.phone,
        status: formData.status,
        role_id: formData.role_id,
      })
      toast({
        title: "Utilisateur mis à jour",
        description: `Le compte de ${formData.first_name} ${formData.last_name} a été mis à jour`,
        variant: "success",
      })
      router.push("/users")
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Erreur lors de la mise à jour de l'utilisateur",
        variant: "destructive",
      })
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.push("/users")}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <h1 className="text-4xl font-semibold">Modifier un utilisateur</h1>
      </div>

      <div className="max-w-2xl">
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <User className="h-5 w-5" />
              {formData.first_name} {formData.last_name}
            </CardTitle>
            <CardDescription>
              Compte créé le {formData.created_at ? new Date(formData.created_at).toLocaleDateString("fr-FR") : ""}
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="first_name">Prénom</Label>
                  <Input
                    id="first_name"
                    value={formData.first_name}
                    onChange={(e) => handleInputChange("first_name", e.target.value)}
                    className="rounded-xl"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="last_name">Nom</Label>
                  <Input
                    id="last_name"
                    value={formData.last_name}
                    onChange={(e) => handleInputChange("last_name", e.target.value)}
                    className="rounded-xl"
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="email"
                    type="email"
                    value={formData.email}
                    disabled
                    className="pl-10 rounded-xl"
                  />
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="phone">Téléphone</Label>
                <Input
                  id="phone"
                  value={formData.phone}
                  onChange={(e) => handleInputChange("phone", e.target.value)}
                  className="rounded-xl"
                  placeholder="0600000000"
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="role">Rôle</Label>
                  <Select value={String(formData.role_id)} onValueChange={(value) => handleInputChange("role_id", parseInt(value))}>
                    <SelectTrigger className="rounded-xl">
                      <div className="flex items-center gap-2">
                        <Shield className="h-4 w-4 text-muted-foreground" />
                        <SelectValue placeholder="Sélectionner un rôle" />
                      </div>
                    </SelectTrigger>
                    <SelectContent>
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
                </div>
                <div className="space-y-2">
                  <Label htmlFor="status">Statut</Label>
                  <Select value={formData.status} onValueChange={(value) => handleInputChange("status", value)}>
                    <SelectTrigger className="rounded-xl">
                      <SelectValue placeholder="Sélectionner un statut" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="actif">Actif</SelectItem>
                      <SelectItem value="inactif">Inactif</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="flex gap-4 pt-6 border-t">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => router.push("/users")}
                  className="rounded-xl"
                >
                  Annuler
                </Button>
                <Button
                  type="submit"
                  disabled={loading}
                  className="rounded-xl flex-1"
                >
                  {loading ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Sauvegarde...
                    </>
                  ) : (
                    <>
                      <User className="mr-2 h-4 w-4" />
                      Mettre à jour
                    </>
                  )}
                </Button>
              </div>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
