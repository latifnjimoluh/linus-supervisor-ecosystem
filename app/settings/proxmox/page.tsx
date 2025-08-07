"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"

export default function ProxmoxSettingsPage() {
  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Connexion Proxmox</h1>
        <p className="text-muted-foreground">
          Configurez les informations de connexion à votre hyperviseur Proxmox.
        </p>
      </div>
      <Card>
        <CardContent className="pt-6 space-y-4">
          <div className="space-y-2">
            <Label htmlFor="proxmox-url">URL de l'API Proxmox</Label>
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
        <CardFooter className="border-t px-6 py-4 justify-end">
          <Button>Enregistrer les informations</Button>
        </CardFooter>
      </Card>
    </div>
  )
}
