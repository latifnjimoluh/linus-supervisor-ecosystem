"use client"

import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

export default function ProfilePage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Mon Profil</h1>
        <p className="text-muted-foreground">
          Mettez à jour les informations de votre profil personnel.
        </p>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Informations du Profil</CardTitle>
          <CardDescription>Modifiez les détails de votre compte.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center gap-4">
            <Avatar className="h-20 w-20">
              <AvatarImage src="/placeholder-user.jpg" alt="Avatar utilisateur" />
              <AvatarFallback>LS</AvatarFallback>
            </Avatar>
            <Button variant="outline">Changer l'avatar</Button>
          </div>
          <div className="space-y-2">
            <Label htmlFor="first-name">Prénom</Label>
            <Input id="first-name" defaultValue="Jean" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="last-name">Nom</Label>
            <Input id="last-name" defaultValue="Dupont" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="email">Adresse e-mail</Label>
            <Input id="email" type="email" defaultValue="admin@example.com" />
          </div>
        </CardContent>
        <CardFooter className="border-t px-6 py-4 justify-end gap-2">
          <Button variant="outline">Réinitialiser</Button>
          <Button>Sauvegarder</Button>
        </CardFooter>
      </Card>
    </div>
  )
}

