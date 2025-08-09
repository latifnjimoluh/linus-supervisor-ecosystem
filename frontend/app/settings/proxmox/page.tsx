"use client"

import { useEffect, useState } from "react"

import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardFooter } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Eye, EyeOff } from "lucide-react"
import useAuth from "@/hooks/useAuth"
import { useToast } from "@/hooks/use-toast"
import {
  createMySettings,
  getMySettings,
  updateMySettings,
} from "@/services/settings"

export default function ProxmoxSettingsPage() {
  useAuth("/settings/proxmox")
  const { toast } = useToast()

  const [loading, setLoading] = useState(true)
  const [hasSettings, setHasSettings] = useState(false)
  const [proxmoxUrl, setProxmoxUrl] = useState("")
  const [apiTokenId, setApiTokenId] = useState("")
  const [apiTokenSecret, setApiTokenSecret] = useState("")
  const [showSecret, setShowSecret] = useState(false)
  const [proxmoxNode, setProxmoxNode] = useState("")

  useEffect(() => {
    const fetchSettings = async () => {
      setLoading(true)
      const data = await getMySettings()
      if (data) {
        setHasSettings(true)
        setProxmoxUrl(data.proxmox_api_url || "")
        const tokenCombined = data.proxmox_api_token_id && data.proxmox_api_token_name
          ? `${data.proxmox_api_token_id}!${data.proxmox_api_token_name}`
          : ""
        setApiTokenId(tokenCombined)
        setApiTokenSecret(data.proxmox_api_token_secret || "")
        setProxmoxNode(data.proxmox_node || "")
      } else {
        setHasSettings(false)
      }
      setLoading(false)
    }
    fetchSettings()
  }, [])

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    const [tokenId, tokenName] = apiTokenId.split("!")
    const payload = {
      proxmox_api_url: proxmoxUrl,
      proxmox_api_token_id: tokenId,
      proxmox_api_token_name: tokenName,
      proxmox_api_token_secret: apiTokenSecret,
      proxmox_node: proxmoxNode,
    }
    try {
      if (hasSettings) {
        await updateMySettings(payload)
        toast({ title: "Paramètres mis à jour", variant: "success" })
      } else {
        await createMySettings(payload)
        setHasSettings(true)
        toast({ title: "Paramètres enregistrés", variant: "success" })
      }
    } catch (err: any) {
      toast({
        title: "Erreur",
        description: err.message || "Impossible d'enregistrer les paramètres",
        variant: "destructive",
      })
    }
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
        <form onSubmit={handleSubmit}>
          <CardContent className="pt-6 space-y-4">
            <div className="space-y-2">
              <Label htmlFor="proxmox-url">URL de l&apos;API Proxmox</Label>
              <Input
                id="proxmox-url"
                placeholder="https://192.168.1.100:8006/api2/json"
                value={proxmoxUrl}
                onChange={(e) => setProxmoxUrl(e.target.value)}
                disabled={loading}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="api-token-id">Identifiant du Token API (ex: root@pam!terraform)</Label>
              <Input
                id="api-token-id"
                placeholder="root@pam!mytoken"
                value={apiTokenId}
                onChange={(e) => setApiTokenId(e.target.value)}
                disabled={loading}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="api-token-secret">Clé secrète du Token API</Label>
              <div className="relative">
                <Input
                  id="api-token-secret"
                  type={showSecret ? "text" : "password"}
                  value={apiTokenSecret}
                  onChange={(e) => setApiTokenSecret(e.target.value)}
                  disabled={loading}
                />
                <Button
                  type="button"
                  variant="ghost"
                  size="sm"
                  className="absolute top-1/2 right-2 -translate-y-1/2 h-6 w-6 p-0"
                  onClick={() => setShowSecret(!showSecret)}
                  disabled={loading}
                >
                  {showSecret ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </Button>
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="proxmox-node">Nom du nœud Proxmox cible</Label>
              <Input
                id="proxmox-node"
                placeholder="pve"
                value={proxmoxNode}
                onChange={(e) => setProxmoxNode(e.target.value)}
                disabled={loading}
              />
            </div>
          </CardContent>
          <CardFooter className="border-t px-6 py-4 justify-end gap-2">
            <Button
              type="button"
              variant="secondary"
              className="border border-muted-foreground/30"
              disabled={loading}
              onClick={() => {
                // Reset fields to original values
                setProxmoxUrl("")
                setApiTokenId("")
                setApiTokenSecret("")
                setProxmoxNode("")
              }}
            >
              Annuler
            </Button>
            <Button
              type="submit"
              className="bg-blue-600 hover:bg-blue-700 text-white"
              disabled={loading}
            >
              Enregistrer
            </Button>
          </CardFooter>
        </form>
      </Card>
    </div>
  )
}
