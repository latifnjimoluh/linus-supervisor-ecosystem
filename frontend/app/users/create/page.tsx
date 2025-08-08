"use client"

import * as React from "react"
import { useRouter } from "next/navigation"
import { ArrowLeft, User, Mail, Lock, Shield, Loader2 } from 'lucide-react'

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { useToast } from "@/hooks/use-toast"
import { createUser, getRoles } from "@/services/api"

interface CreateUserForm {
  first_name: string
  last_name: string
  email: string
  password: string
  role_id: number
}

export default function CreateUserPage() {
  const router = useRouter()
  const { toast } = useToast()
  const [loading, setLoading] = React.useState(false)
  const [formData, setFormData] = React.useState<CreateUserForm>({
    first_name: "",
    last_name: "",
    email: "",
    password: "",
    role_id: 0,
  })
  const [errors, setErrors] = React.useState<Partial<CreateUserForm>>({})
  const [roles, setRoles] = React.useState<{ id: number; name: string }[]>([])

  React.useEffect(() => {
    getRoles()
      .then(setRoles)
      .catch(() => {
        toast({ title: "Erreur", description: "Impossible de charger les rôles", variant: "destructive" })
      })
  }, [toast])

  const validateForm = (): boolean => {
    const newErrors: Partial<CreateUserForm> = {}

    if (!formData.first_name.trim()) {
      newErrors.first_name = "Le prénom est requis"
    }
    if (!formData.last_name.trim()) {
      newErrors.last_name = "Le nom est requis"
    }
    if (!formData.email.trim()) {
      newErrors.email = "L'email est requis"
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      newErrors.email = "Format email invalide"
    }
    if (!formData.password.trim()) {
      newErrors.password = "Le mot de passe est requis"
    } else if (formData.password.length < 8) {
      newErrors.password = "Le mot de passe doit contenir au moins 8 caractères"
    }
    if (!formData.role_id) {
      newErrors.role_id = "Le rôle est requis"
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    
    if (!validateForm()) {
      return
    }

    setLoading(true)

    try {
      await createUser(formData)
      toast({
        title: "Utilisateur créé",
        description: `Le compte de ${formData.first_name} ${formData.last_name} a été créé avec succès`,
        variant: "success",
      })
      router.push("/users")
    } catch (error: any) {
      const message = error.response?.data?.message || "Erreur lors de la création du compte"
      if (message.includes("existe")) {
        setErrors({ email: message })
      }
      toast({ title: "Erreur", description: message, variant: "destructive" })
    } finally {
      setLoading(false)
    }
  }

  const handleInputChange = (field: keyof CreateUserForm, value: string | number) => {
    setFormData(prev => ({ ...prev, [field]: value }))
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: undefined }))
    }
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.push("/users")}>
          <ArrowLeft className="h-4 w-4" />
        </Button>
        <h1 className="text-4xl font-semibold">Créer un utilisateur</h1>
      </div>

      {/* Form */}
      <div className="max-w-2xl">
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <User className="h-5 w-5" />
              Informations utilisateur
            </CardTitle>
            <CardDescription>
              Saisissez les informations du nouveau compte utilisateur
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="first_name">Prénom *</Label>
                  <Input
                    id="first_name"
                    value={formData.first_name}
                    onChange={(e) => handleInputChange("first_name", e.target.value)}
                    className={`rounded-xl ${errors.first_name ? "border-destructive" : ""}`}
                    placeholder="Jean"
                  />
                  {errors.first_name && (
                    <p className="text-sm text-destructive">{errors.first_name}</p>
                  )}
                </div>
                <div className="space-y-2">
                  <Label htmlFor="last_name">Nom *</Label>
                  <Input
                    id="last_name"
                    value={formData.last_name}
                    onChange={(e) => handleInputChange("last_name", e.target.value)}
                    className={`rounded-xl ${errors.last_name ? "border-destructive" : ""}`}
                    placeholder="Dupont"
                  />
                  {errors.last_name && (
                    <p className="text-sm text-destructive">{errors.last_name}</p>
                  )}
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="email">Email *</Label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="email"
                    type="email"
                    value={formData.email}
                    onChange={(e) => handleInputChange("email", e.target.value)}
                    className={`pl-10 rounded-xl ${errors.email ? "border-destructive" : ""}`}
                    placeholder="jean.dupont@example.com"
                  />
                </div>
                {errors.email && (
                  <p className="text-sm text-destructive">{errors.email}</p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="password">Mot de passe initial *</Label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="password"
                    type="password"
                    value={formData.password}
                    onChange={(e) => handleInputChange("password", e.target.value)}
                    className={`pl-10 rounded-xl ${errors.password ? "border-destructive" : ""}`}
                    placeholder="Mot de passe sécurisé"
                  />
                </div>
                {errors.password && (
                  <p className="text-sm text-destructive">{errors.password}</p>
                )}
                <p className="text-xs text-muted-foreground">
                  Le mot de passe doit contenir au moins 8 caractères
                </p>
              </div>

              <div className="space-y-2">
                <Label htmlFor="role">Rôle *</Label>
                <Select value={String(formData.role_id)} onValueChange={(value) => handleInputChange("role_id", parseInt(value))}>
                  <SelectTrigger className={`rounded-xl ${errors.role_id ? "border-destructive" : ""}`}>
                    <div className="flex items-center gap-2">
                      <Shield className="h-4 w-4 text-muted-foreground" />
                      <SelectValue placeholder="Sélectionner un rôle" />
                    </div>
                  </SelectTrigger>
                  <SelectContent>
                    {roles.map(role => (
                      <SelectItem key={role.id} value={String(role.id)}>{role.name}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                {errors.role_id && (
                  <p className="text-sm text-destructive">{errors.role_id}</p>
                )}
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
                      Création en cours...
                    </>
                  ) : (
                    <>
                      <User className="mr-2 h-4 w-4" />
                      Créer l'utilisateur
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
