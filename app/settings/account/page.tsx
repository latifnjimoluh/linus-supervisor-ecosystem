"use client"

import { useTheme } from "next-themes"
import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function AccountSettingsPage() {
  const { setTheme } = useTheme()

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href="/settings" label="Retour" />
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Paramètres du Compte</h1>
          <p className="text-muted-foreground">
            Gérez les paramètres de votre profil, sécurité, notifications et intégrations.
          </p>
        </div>
      </div>

      {/* Tabs with clearer active/inactive states */}
      <Tabs defaultValue="general" className="w-full space-y-6">
        <TabsList className="grid w-full grid-cols-2 md:grid-cols-5 gap-2">
          {[
            { value: "general", label: "Général" },
            { value: "appearance", label: "Apparence" },
            { value: "security", label: "Sécurité" },
            { value: "notifications", label: "Notifications" },
            { value: "integrations", label: "Intégrations" },
          ].map((tab) => (
            <TabsTrigger
              key={tab.value}
              value={tab.value}
              className="rounded-md border border-transparent data-[state=active]:border-primary data-[state=active]:bg-primary/10 data-[state=active]:text-primary"
            >
              {tab.label}
            </TabsTrigger>
          ))}
        </TabsList>

        {/* Général */}
        <TabsContent value="general" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Informations de profil</CardTitle>
              <CardDescription>Mettez à jour votre nom d’utilisateur, e-mail et langue.</CardDescription>
            </CardHeader>
            <CardContent className="grid gap-4 md:grid-cols-2">
              <div className="space-y-2">
                <Label htmlFor="username">Nom d’utilisateur</Label>
                <Input id="username" defaultValue="admin" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="email">Adresse e-mail</Label>
                <Input id="email" type="email" defaultValue="admin@example.com" />
              </div>
              <div className="space-y-2 md:col-span-2">
                <Label htmlFor="language">Langue</Label>
                <Select defaultValue="fr">
                  <SelectTrigger id="language">
                    <SelectValue placeholder="Sélectionner une langue" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="fr">Français</SelectItem>
                    <SelectItem value="en">English</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </CardContent>
            {/* Buttons styled to be visibly distinct */}
            <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="secondary" className="border border-muted-foreground/30">Réinitialiser</Button>
              <Button className="bg-blue-600 hover:bg-blue-700 text-white">Enregistrer</Button>
            </CardFooter>
          </Card>
        </TabsContent>

        {/* Apparence */}
        <TabsContent value="appearance">
          <Card>
            <CardHeader>
              <CardTitle>Apparence</CardTitle>
              <CardDescription>Personnalisez l’apparence de l’application.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <Label>Thème</Label>
              <RadioGroup defaultValue="system" className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <RadioGroupItem value="light" id="light" className="peer sr-only" onClick={() => setTheme("light")} />
                  <Label
                    htmlFor="light"
                    className="flex items-center justify-center rounded-md border-2 border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary"
                  >
                    Clair
                  </Label>
                </div>
                <div>
                  <RadioGroupItem value="dark" id="dark" className="peer sr-only" onClick={() => setTheme("dark")} />
                  <Label
                    htmlFor="dark"
                    className="flex items-center justify-center rounded-md border-2 border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary"
                  >
                    Sombre
                  </Label>
                </div>
                <div>
                  <RadioGroupItem value="system" id="system" className="peer sr-only" onClick={() => setTheme("system")} />
                  <Label
                    htmlFor="system"
                    className="flex items-center justify-center rounded-md border-2 border-muted bg-popover p-4 hover:bg-accent hover:text-accent-foreground peer-data-[state=checked]:border-primary"
                  >
                    Système
                  </Label>
                </div>
              </RadioGroup>
            </CardContent>
            <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="secondary" className="border border-muted-foreground/30">Réinitialiser</Button>
              <Button className="bg-blue-600 hover:bg-blue-700 text-white">Enregistrer</Button>
            </CardFooter>
          </Card>
        </TabsContent>

        {/* Sécurité */}
        <TabsContent value="security" className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Sécurité</CardTitle>
              <CardDescription>Gérez votre mot de passe et la 2FA.</CardDescription>
            </CardHeader>
            <CardContent className="grid gap-6 md:grid-cols-2">
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
                    <p className="text-xs text-muted-foreground">
                      Ajoutez une couche de sécurité supplémentaire à votre compte.
                    </p>
                  </div>
                  <Switch id="2fa" />
                </div>
              </div>
            </CardContent>
            <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="secondary" className="border border-muted-foreground/30">Réinitialiser</Button>
              <Button className="bg-blue-600 hover:bg-blue-700 text-white">Mettre à jour</Button>
            </CardFooter>
          </Card>
        </TabsContent>

        {/* Notifications */}
        <TabsContent value="notifications">
          <Card>
            <CardHeader>
              <CardTitle>Notifications</CardTitle>
              <CardDescription>Choisissez comment recevoir les alertes.</CardDescription>
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
                  <p className="text-xs text-muted-foreground">
                    Si activé, vous ne recevrez des notifications que pour les alertes de sévérité « critique ».
                  </p>
                </div>
                <Switch id="critical-alerts" />
              </div>
            </CardContent>
            <CardFooter className="border-t px-6 py-4 justify-end gap-2">
              <Button variant="secondary" className="border border-muted-foreground/30">Réinitialiser</Button>
              <Button className="bg-blue-600 hover:bg-blue-700 text-white">Enregistrer</Button>
            </CardFooter>
          </Card>
        </TabsContent>

        {/* Intégrations */}
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
