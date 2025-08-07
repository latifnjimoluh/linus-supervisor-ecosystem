"use client"

import * as React from "react"
import { Save, TestTube, Eye, EyeOff, CheckCircle, AlertTriangle, Loader2, RefreshCw } from 'lucide-react'
import { motion } from "framer-motion"
import Link from 'next/link'
import { Card, CardHeader, CardTitle, CardDescription, CardContent, CardFooter } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { User, FileText, Plug, Database, Server, HardDrive } from 'lucide-react'
import { Input, Label, Separator, Badge } from '@/components/ui/input'
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { cn } from "@/lib/utils"
import { useToast } from "@/hooks/use-toast"

interface UserSettings {
  // Proxmox API
  proxmox_host: string
  proxmox_user: string
  proxmox_password: string
  proxmox_token_id: string
  proxmox_token_secret: string
  
  // SSH Configuration
  ssh_private_key_path: string
  ssh_public_key_path: string
  ssh_user: string
  
  // Cloud-Init
  cloudinit_user: string
  cloudinit_password: string
  
  // Terraform
  terraform_workspace: string
  terraform_vars_path: string
  
  // Monitoring
  monitoring_status_path: string
  monitoring_logs_path: string
  
  // Network
  default_network: string
  default_storage: string
}

const defaultSettings: UserSettings = {
  proxmox_host: "",
  proxmox_user: "",
  proxmox_password: "",
  proxmox_token_id: "",
  proxmox_token_secret: "",
  ssh_private_key_path: "/home/user/.ssh/id_rsa",
  ssh_public_key_path: "/home/user/.ssh/id_rsa.pub",
  ssh_user: "root",
  cloudinit_user: "ubuntu",
  cloudinit_password: "",
  terraform_workspace: "/opt/terraform",
  terraform_vars_path: "/opt/terraform/terraform.tfvars.json",
  monitoring_status_path: "/opt/monitoring/status.json",
  monitoring_logs_path: "/var/log/linusupervisor",
  default_network: "vmbr0",
  default_storage: "local-lvm"
}

// Mock function to simulate settings API
const mockSettingsAPI = {
  async getSettings(): Promise<UserSettings> {
    await new Promise(resolve => setTimeout(resolve, 1000))
    return { ...defaultSettings, proxmox_host: "192.168.1.100:8006" }
  },
  
  async saveSettings(settings: UserSettings): Promise<void> {
    await new Promise(resolve => setTimeout(resolve, 1500))
    if (Math.random() < 0.1) {
      throw new Error("Erreur de sauvegarde")
    }
  },
  
  async testConfiguration(settings: UserSettings): Promise<{
    success: boolean
    results: Array<{ test: string; status: "success" | "error" | "warning"; message: string }>
  }> {
    await new Promise(resolve => setTimeout(resolve, 3000))
    
    return {
      success: Math.random() > 0.3,
      results: [
        {
          test: "Connexion API Proxmox",
          status: settings.proxmox_host ? "success" : "error",
          message: settings.proxmox_host ? "Connexion réussie" : "Host Proxmox non configuré"
        },
        {
          test: "Authentification SSH",
          status: settings.ssh_private_key_path ? "success" : "warning",
          message: settings.ssh_private_key_path ? "Clé SSH trouvée" : "Chemin de clé SSH manquant"
        },
        {
          test: "Accès Terraform",
          status: settings.terraform_workspace ? "success" : "error",
          message: settings.terraform_workspace ? "Workspace accessible" : "Workspace non configuré"
        },
        {
          test: "Fichiers de monitoring",
          status: Math.random() > 0.5 ? "success" : "warning",
          message: Math.random() > 0.5 ? "Fichiers accessibles" : "Certains fichiers introuvables"
        }
      ]
    }
  }
}

// Simulate AI analysis for settings
const simulateSettingsAIAnalysis = async (context: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 2000))
  
  return `🤖 **Analyse IA de votre configuration**

**📊 État de la configuration:**
${context.includes("proxmox_host") ? "✅ Configuration Proxmox détectée" : "❌ Configuration Proxmox manquante"}

**🔍 Recommandations:**

**Sécurité:**
• Utilisez des tokens API plutôt que des mots de passe
• Vérifiez que vos clés SSH sont protégées (chmod 600)
• Évitez de stocker des mots de passe en clair

**Performance:**
• Configurez un workspace Terraform dédié
• Utilisez le stockage local-lvm pour de meilleures performances
• Définissez un réseau par défaut adapté à votre infrastructure

**Monitoring:**
• Assurez-vous que les chemins de logs sont accessibles
• Configurez la rotation des logs pour éviter la saturation
• Testez régulièrement la connectivité

**🎯 Actions recommandées:**
1. Testez votre configuration avec le bouton "Tester"
2. Vérifiez les permissions des fichiers SSH
3. Documentez vos paramètres pour l'équipe

*Analyse générée le ${new Date().toLocaleString('fr-FR')}*`
}

const settingsCards = [
  {
    title: 'Paramètres du Compte',
    description: 'Gérez votre profil, la sécurité de votre compte et vos préférences.',
    icon: <User className="h-8 w-8 text-primary" />,
    href: '/settings/account',
    cta: 'Accéder',
  },
  {
    title: 'Templates de Provisionnement',
    description: 'Configurez et gérez les templates de machines virtuelles pour le déploiement.',
    icon: <FileText className="h-8 w-8 text-primary" />,
    href: '/settings/templates',
    cta: 'Gérer',
  },
  {
    title: 'Connexion Proxmox',
    description: 'Configurez les informations de connexion à votre hyperviseur Proxmox.',
    icon: <Server className="h-8 w-8 text-primary" />,
    href: '/settings/proxmox',
    cta: 'Configurer',
  },
  {
    title: 'Gestion du Stockage',
    description: 'Visualisez et gérez les stockages disponibles sur vos hyperviseurs.',
    icon: <HardDrive className="h-8 w-8 text-primary" />,
    href: '#',
    cta: 'Bientôt disponible',
    disabled: true,
  },
]

export default function SettingsPage() {
  const [settings, setSettings] = React.useState<UserSettings>(defaultSettings)
  const [loading, setLoading] = React.useState(true)
  const [saving, setSaving] = React.useState(false)
  const [testing, setTesting] = React.useState(false)
  const [testResults, setTestResults] = React.useState<any>(null)
  const [showPasswords, setShowPasswords] = React.useState<Record<string, boolean>>({})
  const { toast } = useToast()

  React.useEffect(() => {
    loadSettings()
  }, [])

  const loadSettings = async () => {
    try {
      const data = await mockSettingsAPI.getSettings()
      setSettings(data)
    } catch (error) {
      toast({
        title: "Erreur de chargement",
        description: "Impossible de charger les paramètres",
        variant: "destructive",
      })
    } finally {
      setLoading(false)
    }
  }

  const handleSave = async () => {
    setSaving(true)
    try {
      await mockSettingsAPI.saveSettings(settings)
      toast({
        title: "Paramètres enregistrés",
        description: "Vos paramètres ont été sauvegardés avec succès",
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur de sauvegarde",
        description: "Impossible de sauvegarder les paramètres",
        variant: "destructive",
      })
    } finally {
      setSaving(false)
    }
  }

  const handleTest = async () => {
    setTesting(true)
    try {
      const results = await mockSettingsAPI.testConfiguration(settings)
      setTestResults(results)
      
      toast({
        title: results.success ? "Test réussi" : "Problèmes détectés",
        description: results.success ? "Configuration validée" : "Vérifiez les détails ci-dessous",
        variant: results.success ? "success" : "warning",
      })
    } catch (error) {
      toast({
        title: "Erreur de test",
        description: "Impossible de tester la configuration",
        variant: "destructive",
      })
    } finally {
      setTesting(false)
    }
  }

  const updateSetting = (key: keyof UserSettings, value: string) => {
    setSettings(prev => ({ ...prev, [key]: value }))
  }

  const togglePasswordVisibility = (field: string) => {
    setShowPasswords(prev => ({ ...prev, [field]: !prev[field] }))
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "success": return <CheckCircle className="h-4 w-4 text-success" />
      case "error": return <AlertTriangle className="h-4 w-4 text-destructive" />
      case "warning": return <AlertTriangle className="h-4 w-4 text-warning" />
      default: return null
    }
  }

  const aiContext = `Configuration: proxmox_host=${settings.proxmox_host}, ssh_user=${settings.ssh_user}, terraform_workspace=${settings.terraform_workspace}, monitoring configuré=${!!settings.monitoring_status_path}`

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Paramètres</h1>
        <p className="text-muted-foreground">
          Gérez les paramètres généraux de l'application et de votre infrastructure.
        </p>
      </div>
      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-2">
        {settingsCards.map((card) => (
          <Card key={card.title}>
            <CardHeader>
              <div className="flex items-start justify-between">
                <div className="space-y-1.5">
                  <CardTitle>{card.title}</CardTitle>
                  <CardDescription>{card.description}</CardDescription>
                </div>
                {card.icon}
              </div>
            </CardHeader>
            <CardFooter>
              <Button asChild className="w-full" disabled={card.disabled}>
                <Link href={card.href}>{card.cta}</Link>
              </Button>
            </CardFooter>
          </Card>
        ))}
      </div>

      {loading ? (
        <div className="flex items-center justify-center min-h-[400px]">
          <div className="text-center">
            <Loader2 className="h-8 w-8 animate-spin mx-auto mb-4" />
            <p>Chargement des paramètres...</p>
          </div>
        </div>
      ) : (
        <div className="space-y-6">
          <div className="flex justify-between items-center">
            <div>
              <h1 className="text-4xl font-semibold">Paramètres personnels</h1>
              <p className="text-muted-foreground mt-1">
                Configurez votre environnement Proxmox, SSH et Terraform
              </p>
            </div>
            <div className="flex gap-3">
              <Button onClick={handleTest} variant="outline" disabled={testing} className="rounded-xl">
                {testing ? (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                ) : (
                  <TestTube className="mr-2 h-4 w-4" />
                )}
                Tester la configuration
              </Button>
              <Button onClick={handleSave} disabled={saving} className="rounded-xl">
                {saving ? (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                ) : (
                  <Save className="mr-2 h-4 w-4" />
                )}
                Enregistrer
              </Button>
            </div>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
            {/* Proxmox API Configuration */}
            <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
              <CardHeader>
                <CardTitle className="text-lg">Configuration API Proxmox</CardTitle>
                <CardDescription>
                  Paramètres de connexion à votre serveur Proxmox
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="proxmox_host">Host Proxmox (IP:Port)</Label>
                  <Input
                    id="proxmox_host"
                    value={settings.proxmox_host}
                    onChange={(e) => updateSetting("proxmox_host", e.target.value)}
                    placeholder="192.168.1.100:8006"
                  />
                </div>
                
                <div className="space-y-2">
                  <Label htmlFor="proxmox_user">Utilisateur</Label>
                  <Input
                    id="proxmox_user"
                    value={settings.proxmox_user}
                    onChange={(e) => updateSetting("proxmox_user", e.target.value)}
                    placeholder="root@pam"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="proxmox_password">Mot de passe</Label>
                  <div className="relative">
                    <Input
                      id="proxmox_password"
                      type={showPasswords.proxmox_password ? "text" : "password"}
                      value={settings.proxmox_password}
                      onChange={(e) => updateSetting("proxmox_password", e.target.value)}
                      placeholder="••••••••"
                    />
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="absolute right-0 top-0 h-full px-3"
                      onClick={() => togglePasswordVisibility("proxmox_password")}
                    >
                      {showPasswords.proxmox_password ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </Button>
                  </div>
                </div>

                <Separator />

                <div className="space-y-2">
                  <Label htmlFor="proxmox_token_id">Token ID (recommandé)</Label>
                  <Input
                    id="proxmox_token_id"
                    value={settings.proxmox_token_id}
                    onChange={(e) => updateSetting("proxmox_token_id", e.target.value)}
                    placeholder="user@pam!token_name"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="proxmox_token_secret">Token Secret</Label>
                  <div className="relative">
                    <Input
                      id="proxmox_token_secret"
                      type={showPasswords.proxmox_token_secret ? "text" : "password"}
                      value={settings.proxmox_token_secret}
                      onChange={(e) => updateSetting("proxmox_token_secret", e.target.value)}
                      placeholder="••••••••-••••-••••-••••-••••••••••••"
                    />
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="absolute right-0 top-0 h-full px-3"
                      onClick={() => togglePasswordVisibility("proxmox_token_secret")}
                    >
                      {showPasswords.proxmox_token_secret ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* SSH Configuration */}
            <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
              <CardHeader>
                <CardTitle className="text-lg">Configuration SSH</CardTitle>
                <CardDescription>
                  Clés et paramètres d'accès SSH aux VMs
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="ssh_user">Utilisateur SSH</Label>
                  <Input
                    id="ssh_user"
                    value={settings.ssh_user}
                    onChange={(e) => updateSetting("ssh_user", e.target.value)}
                    placeholder="root"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="ssh_private_key_path">Chemin clé privée</Label>
                  <Input
                    id="ssh_private_key_path"
                    value={settings.ssh_private_key_path}
                    onChange={(e) => updateSetting("ssh_private_key_path", e.target.value)}
                    placeholder="/home/user/.ssh/id_rsa"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="ssh_public_key_path">Chemin clé publique</Label>
                  <Input
                    id="ssh_public_key_path"
                    value={settings.ssh_public_key_path}
                    onChange={(e) => updateSetting("ssh_public_key_path", e.target.value)}
                    placeholder="/home/user/.ssh/id_rsa.pub"
                  />
                </div>

                <Separator />

                <div className="space-y-2">
                  <Label htmlFor="cloudinit_user">Utilisateur Cloud-Init</Label>
                  <Input
                    id="cloudinit_user"
                    value={settings.cloudinit_user}
                    onChange={(e) => updateSetting("cloudinit_user", e.target.value)}
                    placeholder="ubuntu"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="cloudinit_password">Mot de passe Cloud-Init</Label>
                  <div className="relative">
                    <Input
                      id="cloudinit_password"
                      type={showPasswords.cloudinit_password ? "text" : "password"}
                      value={settings.cloudinit_password}
                      onChange={(e) => updateSetting("cloudinit_password", e.target.value)}
                      placeholder="••••••••"
                    />
                    <Button
                      type="button"
                      variant="ghost"
                      size="sm"
                      className="absolute right-0 top-0 h-full px-3"
                      onClick={() => togglePasswordVisibility("cloudinit_password")}
                    >
                      {showPasswords.cloudinit_password ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Terraform Configuration */}
            <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
              <CardHeader>
                <CardTitle className="text-lg">Configuration Terraform</CardTitle>
                <CardDescription>
                  Chemins et workspace pour les déploiements
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="terraform_workspace">Workspace Terraform</Label>
                  <Input
                    id="terraform_workspace"
                    value={settings.terraform_workspace}
                    onChange={(e) => updateSetting("terraform_workspace", e.target.value)}
                    placeholder="/opt/terraform"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="terraform_vars_path">Fichier variables (.tfvars.json)</Label>
                  <Input
                    id="terraform_vars_path"
                    value={settings.terraform_vars_path}
                    onChange={(e) => updateSetting("terraform_vars_path", e.target.value)}
                    placeholder="/opt/terraform/terraform.tfvars.json"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="default_network">Réseau par défaut</Label>
                  <Input
                    id="default_network"
                    value={settings.default_network}
                    onChange={(e) => updateSetting("default_network", e.target.value)}
                    placeholder="vmbr0"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="default_storage">Stockage par défaut</Label>
                  <Input
                    id="default_storage"
                    value={settings.default_storage}
                    onChange={(e) => updateSetting("default_storage", e.target.value)}
                    placeholder="local-lvm"
                  />
                </div>
              </CardContent>
            </Card>

            {/* Monitoring Configuration */}
            <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
              <CardHeader>
                <CardTitle className="text-lg">Configuration Monitoring</CardTitle>
                <CardDescription>
                  Chemins des fichiers de supervision et logs
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  <Label htmlFor="monitoring_status_path">Fichier status.json</Label>
                  <Input
                    id="monitoring_status_path"
                    value={settings.monitoring_status_path}
                    onChange={(e) => updateSetting("monitoring_status_path", e.target.value)}
                    placeholder="/opt/monitoring/status.json"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="monitoring_logs_path">Répertoire des logs</Label>
                  <Input
                    id="monitoring_logs_path"
                    value={settings.monitoring_logs_path}
                    onChange={(e) => updateSetting("monitoring_logs_path", e.target.value)}
                    placeholder="/var/log/linusupervisor"
                  />
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Test Results */}
          {testResults && (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="space-y-4"
            >
              <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <TestTube className="h-5 w-5" />
                    Résultats du test de configuration
                  </CardTitle>
                  <CardDescription>
                    {testResults.success ? "✅ Configuration validée" : "⚠️ Problèmes détectés"}
                  </CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {testResults.results.map((result: any, index: number) => (
                      <div key={index} className="flex items-center justify-between p-3 border rounded-xl">
                        <div className="flex items-center gap-3">
                          {getStatusIcon(result.status)}
                          <div>
                            <p className="font-medium">{result.test}</p>
                            <p className="text-sm text-muted-foreground">{result.message}</p>
                          </div>
                        </div>
                        <Badge variant={result.status === 'success' ? 'success' : result.status === 'error' ? 'destructive' : 'warning'}>
                          {result.status}
                        </Badge>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </motion.div>
          )}

          {/* AI Assistant Block */}
          <AssistantAIBlock
            title="Assistant IA pour la configuration"
            context={aiContext}
            onAnalyze={simulateSettingsAIAnalysis}
            className="w-full"
          />
        </div>
      )}
    </div>
  )
}
