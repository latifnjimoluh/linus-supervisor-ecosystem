"use client"

import * as React from "react"
import { BackButton } from "@/components/back-button"
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Button } from "@/components/ui/button"
import { useToast } from "@/hooks/use-toast"
import { UserSettings, getMySettings, createMySettings, updateMySettings } from "@/services/api"

const fields: { key: keyof UserSettings; label: string }[] = [
  { key: 'cloudinit_user', label: 'Cloudinit User' },
  { key: 'cloudinit_password', label: 'Cloudinit Password' },
  { key: 'proxmox_api_url', label: 'Proxmox API URL' },
  { key: 'proxmox_api_token_id', label: 'Proxmox API Token ID' },
  { key: 'proxmox_api_token_name', label: 'Proxmox API Token Name' },
  { key: 'proxmox_api_token_secret', label: 'Proxmox API Token Secret' },
  { key: 'pm_user', label: 'PM User' },
  { key: 'pm_password', label: 'PM Password' },
  { key: 'proxmox_node', label: 'Proxmox Node' },
  { key: 'vm_storage', label: 'VM Storage' },
  { key: 'vm_bridge', label: 'VM Bridge' },
  { key: 'ssh_public_key_path', label: 'SSH Public Key Path' },
  { key: 'ssh_private_key_path', label: 'SSH Private Key Path' },
  { key: 'statuspath', label: 'Status Path' },
  { key: 'servicespath', label: 'Services Path' },
  { key: 'instanceinfopath', label: 'Instance Info Path' },
  { key: 'proxmox_host', label: 'Proxmox Host' },
  { key: 'proxmox_ssh_user', label: 'Proxmox SSH User' },
]

export default function ProxmoxSettingsPage() {
  const [form, setForm] = React.useState<UserSettings>({
    cloudinit_user: '',
    cloudinit_password: '',
    proxmox_api_url: '',
    proxmox_api_token_id: '',
    proxmox_api_token_name: '',
    proxmox_api_token_secret: '',
    pm_user: '',
    pm_password: '',
    proxmox_node: '',
    vm_storage: '',
    vm_bridge: '',
    ssh_public_key_path: '',
    ssh_private_key_path: '',
    statuspath: '',
    servicespath: '',
    instanceinfopath: '',
    proxmox_host: '',
    proxmox_ssh_user: '',
  })
  const [exists, setExists] = React.useState(false)
  const { toast } = useToast()

  React.useEffect(() => {
    getMySettings()
      .then((data) => {
        if (data) {
          setForm(data)
          setExists(true)
        }
      })
      .catch(() => {})
  }, [])

  const handleChange = (key: keyof UserSettings) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm({ ...form, [key]: e.target.value })
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      if (exists) {
        await updateMySettings(form)
      } else {
        await createMySettings(form)
        setExists(true)
      }
      toast({ title: 'Succès', description: 'Paramètres enregistrés' })
    } catch (e: any) {
      toast({ title: 'Erreur', description: e.message, variant: 'destructive' })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href="/settings" label="Retour" />
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Connexion Proxmox</h1>
          <p className="text-muted-foreground">Configurez vos paramètres de connexion.</p>
        </div>
      </div>
      <Card>
        <form onSubmit={handleSubmit}>
          <CardHeader>
            <CardTitle>Paramètres Proxmox</CardTitle>
            <CardDescription>Définissez vos informations de connexion.</CardDescription>
          </CardHeader>
          <CardContent className="grid gap-4 md:grid-cols-2">
            {fields.map((f) => (
              <div key={f.key} className="space-y-2">
                <Label htmlFor={f.key}>{f.label}</Label>
                <Input id={f.key} value={form[f.key]} onChange={handleChange(f.key)} />
              </div>
            ))}
          </CardContent>
          <CardFooter className="flex justify-end">
            <Button type="submit">Sauvegarder</Button>
          </CardFooter>
        </form>
      </Card>
    </div>
  )
}
