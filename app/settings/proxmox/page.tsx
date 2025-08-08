"use client"

import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

export default function ProxmoxSettingsPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href="/settings" label="Retour" />
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Connexion Proxmox</h1>
          <p className="text-muted-foreground">
            Configurez les informations de connexion à votre hyperviseur Proxmox.
          </p>
        </div>
      </div>

      <Card>
        <CardContent className="pt-6 space-y-4">
          <div className="space-y-2">
            <Label htmlFor="proxmox-url">URL de l&apos;API Proxmox</Label>
            <Input id="proxmox-url" placeholder="https://192.168.1.100:8006/api2/json" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="api-token-id">Identifiant du Token API (ex: root@pam!terraform)</Label>
            <Input id="api-token-id" placeholder="root@pam!mytoken" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="api-token-secret">Clé secrète du Token API</Label>
            <Input id="api-token-secret" type="password" />
          </div>
          <div className="space-y-2">
            <Label htmlFor="proxmox-node">Nom du nœud Proxmox cible</Label>
            <Input id="proxmox-node" placeholder="pve" />
          </div>
        </CardContent>
        <CardFooter className="border-t px-6 py-4 justify-end gap-2">
          <Button variant="secondary" className="border border-muted-foreground/30">Annuler</Button>
          <Button className="bg-blue-600 hover:bg-blue-700 text-white">Enregistrer</Button>
        </CardFooter>
      </Card>
    </div>
  )
}
