"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { useTheme } from "next-themes"

export default function AccountSettingsPage() {
  const { setTheme } = useTheme()

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Paramètres du Compte</h1>
        <p className="text-muted-foreground">
          Gérez les paramètres de votre profil, sécurité, notifications et intégrations.
        </p>
      </div>
      <Tabs defaultValue="general" className="w-full">
        <TabsList className="grid w-full grid-cols-2 md:grid-cols-5">
          <TabsTrigger value="general">Général</TabsTrigger>
          <TabsTrigger value="appearance">Apparence</TabsTrigger>
          <TabsTrigger value="security">Sécurité</TabsTrigger>
          <TabsTrigger value="notifications">Notifications</TabsTrigger>
          <TabsTrigger value="integrations">Intégrations</TabsTrigger>
        </TabsList>
        
        <TabsContent value="general">
          <Card>
            <CardHeader>
              <CardTitle>Général</CardTitle>
              <CardDescription>Mettez à jour les informations de votre profil et vos préférences générales.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="username">Nom d'utilisateur</Label>
                <Input id="username" defaultValue="admin" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="email">Adresse e-mail</Label>
                <Input id="email" type="email" defaultValue="admin@example.com" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="language">Langue</Label>
                <Select defaultValue="fr">
                  <SelectTrigger>
                    <SelectValue placeholder="Sélectionner une langue" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="fr">Français</SelectItem>
                    <SelectItem value="en">English</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </CardContent>
            <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="outline">Réinitialiser</Button>
              <Button>Sauvegarder</Button>
            </CardFooter>
          </Card>
        </TabsContent>

        <TabsContent value="appearance">
          <Card>
            <CardHeader>
              <CardTitle>Apparence</CardTitle>
              <CardDescription>Personnalisez l'apparence de l'application.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <Label>Thème</Label>
              <RadioGroup defaultValue="system" className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <RadioGroupItem value="light" id="light" className="peer sr-only" onClick={() => setTheme('light')} />
                  <Label htmlFor="light" className="flex flex-col items-center justify-between rounded-md border-2 border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary [&:has([data-state=checked])]:border-primary">
                    Clair
                  </Label>
                </div>
                <div>
                  <RadioGroupItem value="dark" id="dark" className="peer sr-only" onClick={() => setTheme('dark')} />
                  <Label htmlFor="dark" className="flex flex-col items-center justify-between rounded-md border-2 border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary [&:has([data-state=checked])]:border-primary">
                    Sombre
                  </Label>
                </div>
                <div>
                  <RadioGroupItem value="system" id="system" className="peer sr-only" onClick={() => setTheme('system')} />
                  <Label htmlFor="system" className="flex flex-col items-center justify-between rounded-md border-2 border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary [&:has([data-state=checked])]:border-primary">
                    Système
                  </Label>
                </div>
              </RadioGroup>
            </CardContent>
             <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="outline">Réinitialiser</Button>
              <Button>Sauvegarder</Button>
            </CardFooter>
          </Card>
        </TabsContent>

        <TabsContent value="security">
          <Card>
            <CardHeader>
              <CardTitle>Sécurité</CardTitle>
              <CardDescription>Gérez votre mot de passe et les paramètres de sécurité du compte.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
                <div className="space-y-4">
                    <h3 className="font-medium">Changer le mot de passe</h3>
                    <div className="space-y-2">
                        <Label htmlFor="current-password">Mot de passe actuel</Label>
                        <Input id="current-password" type="password" />
                    </div>
                    <div className="space-y-2">
                        <Label htmlFor="new-password">Nouveau mot de passe</Label>
                        <Input id="new-password" type="password" />
                    </div>
                    <div className="space-y-2">
                        <Label htmlFor="confirm-password">Confirmer le nouveau mot de passe</Label>
                        <Input id="confirm-password" type="password" />
                    </div>
                </div>
                 <div className="space-y-4">
                    <h3 className="font-medium">Authentification à deux facteurs (2FA)</h3>
                    <div className="flex items-center justify-between rounded-lg border p-4">
                        <div>
                            <Label htmlFor="2fa">Activer la 2FA</Label>
                            <p className="text-xs text-muted-foreground">Ajoutez une couche de sécurité supplémentaire à votre compte.</p>
                        </div>
                        <Switch id="2fa" />
                    </div>
                </div>
            </CardContent>
            <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="outline">Réinitialiser les paramètres</Button>
              <Button>Changer le mot de passe</Button>
            </CardFooter>
          </Card>
        </TabsContent>

        <TabsContent value="notifications">
          <Card>
            <CardHeader>
              <CardTitle>Notifications</CardTitle>
              <CardDescription>Configurez comment vous souhaitez recevoir les alertes et les mises à jour.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
                <div className="flex items-center justify-between rounded-lg border p-4">
                    <Label htmlFor="email-notifications">Notifications par e-mail</Label>
                    <Switch id="email-notifications" defaultChecked />
                </div>
                <div className="flex items-center justify-between rounded-lg border p-4">
                    <Label htmlFor="sms-notifications">Notifications par SMS</Label>
                    <Switch id="sms-notifications" />
                </div>
                <div className="flex items-center justify-between rounded-lg border p-4">
                    <div>
                        <Label htmlFor="critical-alerts">Alertes critiques uniquement</Label>
                        <p className="text-xs text-muted-foreground">Si activé, vous ne recevrez des notifications que pour les alertes de sévérité "critique".</p>
                    </div>
                    <Switch id="critical-alerts" />
                </div>
            </CardContent>
            <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="outline">Réinitialiser</Button>
              <Button>Sauvegarder</Button>
            </CardFooter>
          </Card>
        </TabsContent>
        
        <TabsContent value="integrations">
            <Card>
                <CardHeader>
                    <CardTitle>Intégrations</CardTitle>
                    <CardDescription>Connectez des services tiers pour étendre les fonctionnalités.</CardDescription>
                </CardHeader>
                <CardContent>
                    <div className="flex flex-col items-center justify-center text-center p-8 border-2 border-dashed rounded-lg">
                        <p className="text-muted-foreground">Aucune intégration disponible pour le moment.</p>
                    </div>
                </CardContent>
            </Card>
        </TabsContent>
      </Tabs>
    </div>
  )
}
