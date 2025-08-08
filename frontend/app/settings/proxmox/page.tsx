"use client"

import * as React from "react"
import { useRouter } from "next/navigation"

import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { useToast } from "@/hooks/use-toast"
import {
  getMySettings,
  createMySettings,
  updateMySettings,
  type UserSettings,
} from "@/services/api"

const fields: { name: keyof UserSettings; label: string; type?: string }[] = [
  { name: "cloudinit_user", label: "Utilisateur Cloud-init" },
  { name: "cloudinit_password", label: "Mot de passe Cloud-init", type: "password" },
  { name: "proxmox_api_url", label: "URL de l'API Proxmox" },
  { name: "proxmox_api_token_id", label: "Identifiant du Token API" },
  { name: "proxmox_api_token_name", label: "Nom du Token API" },
  { name: "proxmox_api_token_secret", label: "Clé secrète du Token API", type: "password" },
  { name: "pm_user", label: "Utilisateur Proxmox" },
  { name: "pm_password", label: "Mot de passe Proxmox", type: "password" },
  { name: "proxmox_node", label: "Nœud Proxmox" },
  { name: "vm_storage", label: "Stockage VM" },
  { name: "vm_bridge", label: "Bridge VM" },
  { name: "ssh_public_key_path", label: "Chemin clé publique SSH" },
  { name: "ssh_private_key_path", label: "Chemin clé privée SSH" },
  { name: "statuspath", label: "Chemin du statut" },
  { name: "servicespath", label: "Chemin des services" },
  { name: "instanceinfopath", label: "Chemin des informations d'instance" },
  { name: "proxmox_host", label: "Hôte Proxmox" },
  { name: "proxmox_ssh_user", label: "Utilisateur SSH Proxmox" },
]

const emptySettings: UserSettings = {
  cloudinit_user: "",
  cloudinit_password: "",
  proxmox_api_url: "",
  proxmox_api_token_id: "",
  proxmox_api_token_name: "",
  proxmox_api_token_secret: "",
  pm_user: "",
  pm_password: "",
  proxmox_node: "",
  vm_storage: "",
  vm_bridge: "",
  ssh_public_key_path: "",
  ssh_private_key_path: "",
  statuspath: "",
  servicespath: "",
  instanceinfopath: "",
  proxmox_host: "",
  proxmox_ssh_user: "",
}

export default function ProxmoxSettingsPage() {
  const { toast } = useToast()
  const router = useRouter()
  const [formData, setFormData] = React.useState<UserSettings>(emptySettings)
  const [exists, setExists] = React.useState(false)
  const [loading, setLoading] = React.useState(true)
  const [saving, setSaving] = React.useState(false)

  React.useEffect(() => {
    getMySettings()
      .then((data) => {
        setFormData({ ...emptySettings, ...data })
        setExists(true)
      })
      .catch((error: any) => {
        if (error.response?.status !== 404) {
          toast({
            title: "Erreur",
            description: error.response?.data?.message ||
              "Impossible de charger les paramètres",
            variant: "destructive",
          })
        }
      })
      .finally(() => setLoading(false))
  }, [toast])

  const handleChange = (
    field: keyof UserSettings,
    value: string
  ) => {
    setFormData((prev) => ({ ...prev, [field]: value }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setSaving(true)
    try {
      if (exists) {
        await updateMySettings(formData)
        toast({ title: "Paramètres mis à jour", variant: "success" })
      } else {
        await createMySettings(formData)
        toast({ title: "Paramètres enregistrés", variant: "success" })
        setExists(true)
      }
      router.refresh()
    } catch (error: any) {
      toast({
        title: "Erreur",
        description: error.response?.data?.message ||
          "Échec de l'enregistrement",
        variant: "destructive",
      })
    } finally {
      setSaving(false)
    }
  }

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center gap-3">
          <BackButton href="/settings" label="Retour" />
          <h1 className="text-3xl font-bold tracking-tight">Connexion Proxmox</h1>
        </div>
        <p className="text-muted-foreground">Chargement...</p>
      </div>
    )
  }

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
        <CardContent className="pt-6">
          <form
            onSubmit={handleSubmit}
            className="grid gap-4 md:grid-cols-2"
          >
            {fields.map((field) => (
              <div key={field.name} className="space-y-2">
                <Label htmlFor={field.name}>{field.label}</Label>
                <Input
                  id={field.name}
                  type={field.type || "text"}
                  value={formData[field.name] || ""}
                  onChange={(e) => handleChange(field.name, e.target.value)}
                />
              </div>
            ))}
            <div className="md:col-span-2" />
            <CardFooter className="md:col-span-2 flex justify-end gap-2 px-0">
              <Button
                type="button"
                variant="secondary"
                className="border border-muted-foreground/30"
                onClick={() => setFormData(emptySettings)}
                disabled={saving}
              >
                Réinitialiser
              </Button>
              <Button type="submit" disabled={saving} className="bg-blue-600 hover:bg-blue-700 text-white">
                {saving ? "Enregistrement..." : "Enregistrer"}
              </Button>
            </CardFooter>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}

