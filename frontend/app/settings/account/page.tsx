"use client"

import * as React from "react"
import { BackButton } from "@/components/back-button"
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import { useToast } from "@/hooks/use-toast"
import { getMyProfile, updateMyProfile } from "@/services/api"

export default function AccountSettingsPage() {
  const [form, setForm] = React.useState({ first_name: "", last_name: "", email: "" })
  const [userId, setUserId] = React.useState<number | null>(null)
  const { toast } = useToast()

  React.useEffect(() => {
    getMyProfile()
      .then((data) => {
        setForm({
          first_name: data.first_name || "",
          last_name: data.last_name || "",
          email: data.email || "",
        })
        setUserId(data.id)
      })
      .catch((e: any) => {
        toast({ title: "Erreur", description: e.message, variant: "destructive" })
      })
  }, [toast])

  const handleChange = (key: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [key]: e.target.value })
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!userId) return
    try {
      await updateMyProfile(userId, form)
      toast({ title: "Succès", description: "Profil mis à jour" })
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href="/settings" label="Retour" />
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Paramètres du Compte</h1>
          <p className="text-muted-foreground">Gérez vos informations personnelles.</p>
        </div>
      </div>
      <Card>
        <form onSubmit={handleSubmit}>
          <CardHeader>
            <CardTitle>Informations personnelles</CardTitle>
            <CardDescription>Mettez à jour les détails de votre compte.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="first_name">Prénom</Label>
              <Input id="first_name" value={form.first_name} onChange={handleChange("first_name")} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="last_name">Nom</Label>
              <Input id="last_name" value={form.last_name} onChange={handleChange("last_name")} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" value={form.email} onChange={handleChange("email")} />
            </div>
          </CardContent>
          <CardFooter className="flex justify-end gap-2">
            <Button type="submit">Sauvegarder</Button>
          </CardFooter>
        </form>
      </Card>
    </div>
  )
}
