"use client"

import * as React from "react"
import dynamic from "next/dynamic"
import { useTheme } from "next-themes"
import { Code, Save, Play, Download, Upload, FileText, Copy, RefreshCw, CheckCircle, AlertTriangle } from 'lucide-react'

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { useToast } from "@/hooks/use-toast"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { cn } from "@/lib/utils"

const MonacoEditor = dynamic(() => import("@monaco-editor/react"), { ssr: false })

interface Script {
  id: string
  name: string
  content: string
  language: "bash" | "python" | "javascript"
  lastModified: Date
  isTemplate: boolean
}

const defaultBashScript = `#!/bin/bash
# Script de monitoring VM
# Auteur: LinuSupervisor
# Date: $(date)

VM_NAME="$1"
LOG_FILE="/var/log/vm-monitoring.log"

# Fonction de logging
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Vérification des paramètres
if [ -z "$VM_NAME" ]; then
    log_message "ERREUR: Nom de VM requis"
    echo "Usage: $0 <vm_name>"
    exit 1
fi

# Vérification du statut de la VM
log_message "Vérification du statut de $VM_NAME"
STATUS=$(qm status "$VM_NAME" 2>/dev/null)

if [ $? -eq 0 ]; then
    log_message "Status de $VM_NAME: $STATUS"
    
    # Collecte des métriques si la VM est en cours d'exécution
    if echo "$STATUS" | grep -q "running"; then
        log_message "Collecte des métriques pour $VM_NAME"
        
        # CPU et mémoire
        CPU_USAGE=$(qm monitor "$VM_NAME" info cpus 2>/dev/null || echo "N/A")
        MEMORY_INFO=$(qm monitor "$VM_NAME" info memory 2>/dev/null || echo "N/A")
        
        log_message "CPU: $CPU_USAGE"
        log_message "Mémoire: $MEMORY_INFO"
        
        echo "✅ Monitoring terminé avec succès"
    else
        log_message "ATTENTION: VM $VM_NAME n'est pas en cours d'exécution"
        echo "⚠️  VM arrêtée"
    fi
else
    log_message "ERREUR: VM $VM_NAME introuvable"
    echo "❌ VM non trouvée"
    exit 1
fi`

const mockScripts: Script[] = [
  {
    id: "script-1",
    name: "vm-monitoring.sh",
    content: defaultBashScript,
    language: "bash",
    lastModified: new Date(),
    isTemplate: true
  },
  {
    id: "script-2",
    name: "backup-vm.sh",
    content: `#!/bin/bash
# Script de sauvegarde VM
VM_ID="$1"
BACKUP_DIR="/var/backups/vms"

if [ -z "$VM_ID" ]; then
    echo "Usage: $0 <vm_id>"
    exit 1
fi

echo "Démarrage de la sauvegarde de la VM $VM_ID..."
vzdump "$VM_ID" --storage local --compress gzip --mode snapshot
echo "Sauvegarde terminée"`,
    language: "bash",
    lastModified: new Date(Date.now() - 86400000),
    isTemplate: false
  }
]

// Simulate AI analysis for scripts
const simulateScriptAIAnalysis = async (context: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 2000))
  
  const hasErrorHandling = context.includes("if [") && context.includes("exit")
  const hasLogging = context.includes("log") || context.includes("echo")
  const hasVariables = context.includes("$")
  const lineCount = context.split('\n').length
  
  return `🤖 **Analyse IA du script**

**📊 Analyse structurelle :**
• **Lignes de code :** ${lineCount}
• **Gestion d'erreurs :** ${hasErrorHandling ? "✅ Présente" : "❌ Manquante"}
• **Logging :** ${hasLogging ? "✅ Implémenté" : "❌ Absent"}
• **Variables :** ${hasVariables ? "✅ Utilisées" : "❌ Aucune"}

**🔍 Recommandations d'amélioration :**

${!hasErrorHandling ? "⚠️ **Gestion d'erreurs manquante**\n```bash\nif [ $? -ne 0 ]; then\n    echo \"Erreur détectée\"\n    exit 1\nfi\n```\n" : ""}

${!hasLogging ? "📝 **Ajouter du logging**\n```bash\nLOG_FILE=\"/var/log/script.log\"\necho \"$(date): Message\" >> \"$LOG_FILE\"\n```\n" : ""}

**🛡️ Sécurité :**
• Validez toujours les paramètres d'entrée
• Utilisez des guillemets pour les variables : \`"$VAR"\`
• Vérifiez les permissions avant l'exécution

**⚡ Performance :**
• Évitez les boucles infinies
• Utilisez \`set -e\` pour arrêter sur erreur
• Optimisez les appels système répétitifs

**🎯 Score qualité :** ${hasErrorHandling && hasLogging ? "8/10" : hasErrorHandling || hasLogging ? "6/10" : "4/10"}

*Analyse générée le ${new Date().toLocaleString('fr-FR')}*`
}

export default function CodeEditorPage() {
  const { theme } = useTheme()
  const [selectedScript, setSelectedScript] = React.useState<Script | null>(mockScripts[0])
  const [scriptContent, setScriptContent] = React.useState(mockScripts[0].content)
  const [scriptName, setScriptName] = React.useState(mockScripts[0].name)
  const [isModified, setIsModified] = React.useState(false)
  const [isSaving, setIsSaving] = React.useState(false)
  const [syntaxErrors, setSyntaxErrors] = React.useState<string[]>([])
  const { toast } = useToast()

  React.useEffect(() => {
    if (selectedScript) {
      setScriptContent(selectedScript.content)
      setScriptName(selectedScript.name)
      setIsModified(false)
    }
  }, [selectedScript])

  const handleContentChange = (value: string) => {
    setScriptContent(value)
    setIsModified(true)
    
    // Simple syntax validation for bash
    const errors: string[] = []
    const lines = value.split('\n')
    
    lines.forEach((line, index) => {
      const trimmed = line.trim()
      if (trimmed.startsWith('if [') && !trimmed.includes('];')) {
        if (!lines[index + 1]?.trim().startsWith('then')) {
          errors.push(`Ligne ${index + 1}: 'if' sans 'then'`)
        }
      }
      if (trimmed === 'fi' && !lines.slice(0, index).some(l => l.trim().startsWith('if'))) {
        errors.push(`Ligne ${index + 1}: 'fi' sans 'if' correspondant`)
      }
    })
    
    setSyntaxErrors(errors)
  }

  const saveScript = async () => {
    setIsSaving(true)
    
    try {
      // Simulate save operation
      await new Promise(resolve => setTimeout(resolve, 1000))
      
      if (selectedScript) {
        selectedScript.content = scriptContent
        selectedScript.name = scriptName
        selectedScript.lastModified = new Date()
      }
      
      setIsModified(false)
      toast({
        title: "Script sauvegardé",
        description: `${scriptName} a été enregistré avec succès`,
        variant: "success",
      })
    } catch (error) {
      toast({
        title: "Erreur de sauvegarde",
        description: "Impossible de sauvegarder le script",
        variant: "destructive",
      })
    } finally {
      setIsSaving(false)
    }
  }

  const testScript = async () => {
    if (syntaxErrors.length > 0) {
      toast({
        title: "Erreurs de syntaxe",
        description: "Corrigez les erreurs avant de tester",
        variant: "destructive",
      })
      return
    }

    toast({
      title: "Test en cours",
      description: "Validation de la syntaxe du script...",
      variant: "info",
    })

    // Simulate script testing
    await new Promise(resolve => setTimeout(resolve, 2000))

    toast({
      title: "Test réussi",
      description: "Le script est syntaxiquement correct",
      variant: "success",
    })
  }

  const exportScript = () => {
    const blob = new Blob([scriptContent], { type: 'text/plain' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = scriptName
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)

    toast({
      title: "Script exporté",
      description: `${scriptName} a été téléchargé`,
      variant: "success",
    })
  }

  const importScript = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      const content = e.target?.result as string
      setScriptContent(content)
      setScriptName(file.name)
      setIsModified(true)
    }
    reader.readAsText(file)
  }

  const copyToClipboard = () => {
    navigator.clipboard.writeText(scriptContent)
    toast({
      title: "Copié !",
      description: "Script copié dans le presse-papiers",
      variant: "success",
    })
  }

  const aiContext = `Script: ${scriptName}, Lignes: ${scriptContent.split('\n').length}, Langage: ${selectedScript?.language || 'bash'}, Erreurs: ${syntaxErrors.length}`

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-4xl font-semibold">Éditeur de code interactif</h1>
          <p className="text-muted-foreground mt-1">
            Créez et modifiez vos scripts avec assistance IA
          </p>
        </div>
        <div className="flex gap-3">
          <input
            type="file"
            accept=".sh,.py,.js,.txt"
            onChange={importScript}
            className="hidden"
            id="import-script"
          />
          <Button asChild variant="outline" className="rounded-xl">
            <label htmlFor="import-script" className="cursor-pointer">
              <Upload className="mr-2 h-4 w-4" />
              Importer
            </label>
          </Button>
          <Button onClick={exportScript} variant="outline" className="rounded-xl">
            <Download className="mr-2 h-4 w-4" />
            Exporter
          </Button>
          <Button onClick={testScript} variant="outline" className="rounded-xl">
            <Play className="mr-2 h-4 w-4" />
            Tester
          </Button>
          <Button onClick={saveScript} disabled={!isModified || isSaving} className="rounded-xl">
            {isSaving ? (
              <RefreshCw className="mr-2 h-4 w-4 animate-spin" />
            ) : (
              <Save className="mr-2 h-4 w-4" />
            )}
            Sauvegarder
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Script Selection Sidebar */}
        <div className="lg:col-span-1">
          <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <FileText className="h-5 w-5" />
                Scripts
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              {mockScripts.map((script) => (
                <div
                  key={script.id}
                  onClick={() => setSelectedScript(script)}
                  className={cn(
                    "p-3 rounded-xl border cursor-pointer transition-colors hover:bg-muted/50",
                    selectedScript?.id === script.id && "bg-primary/10 border-primary"
                  )}
                >
                  <div className="flex items-center justify-between mb-1">
                    <span className="font-medium text-sm">{script.name}</span>
                    {script.isTemplate && (
                      <Badge variant="secondary" className="text-xs">Template</Badge>
                    )}
                  </div>
                  <div className="text-xs text-muted-foreground">
                    {script.language} • {script.lastModified.toLocaleDateString("fr-FR")}
                  </div>
                </div>
              ))}
              
              <Button variant="outline" className="w-full rounded-xl">
                <Code className="mr-2 h-4 w-4" />
                Nouveau script
              </Button>
            </CardContent>
          </Card>
        </div>

        {/* Main Editor */}
        <div className="lg:col-span-3 space-y-6">
          {/* Script Info */}
          <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle className="text-lg flex items-center gap-2">
                  <Code className="h-5 w-5" />
                  {scriptName}
                  {isModified && <Badge variant="warning" className="text-xs">Non sauvegardé</Badge>}
                </CardTitle>
                <div className="flex items-center gap-2">
                  <Button variant="ghost" size="sm" onClick={copyToClipboard} className="rounded-xl">
                    <Copy className="h-4 w-4" />
                  </Button>
                  {syntaxErrors.length === 0 ? (
                    <Badge variant="success" className="text-xs">
                      <CheckCircle className="h-3 w-3 mr-1" />
                      Syntaxe OK
                    </Badge>
                  ) : (
                    <Badge variant="destructive" className="text-xs">
                      <AlertTriangle className="h-3 w-3 mr-1" />
                      {syntaxErrors.length} erreur(s)
                    </Badge>
                  )}
                </div>
              </div>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="script-name">Nom du script</Label>
                  <Input
                    id="script-name"
                    value={scriptName}
                    onChange={(e) => {
                      setScriptName(e.target.value)
                      setIsModified(true)
                    }}
                    className="rounded-xl"
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="script-language">Langage</Label>
                  <Select value={selectedScript?.language || "bash"}>
                    <SelectTrigger className="rounded-xl">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="bash">Bash</SelectItem>
                      <SelectItem value="python">Python</SelectItem>
                      <SelectItem value="javascript">JavaScript</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              {/* Syntax Errors */}
              {syntaxErrors.length > 0 && (
                <div className="bg-destructive/10 border border-destructive/20 rounded-xl p-4">
                  <div className="flex items-center gap-2 mb-2">
                    <AlertTriangle className="h-4 w-4 text-destructive" />
                    <span className="font-medium text-destructive">Erreurs de syntaxe</span>
                  </div>
                  <ul className="text-sm text-destructive space-y-1">
                    {syntaxErrors.map((error, index) => (
                      <li key={index}>• {error}</li>
                    ))}
                  </ul>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Code Editor */}
          <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
            <CardHeader>
              <CardTitle className="text-lg">Éditeur</CardTitle>
              <CardDescription>
                Éditez votre script avec coloration syntaxique et validation en temps réel
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="relative rounded-xl overflow-hidden">
                <MonacoEditor
                  value={scriptContent}
                  language={selectedScript?.language || "bash"}
                  onChange={(value) => handleContentChange(value || "")}
                  height="400px"
                  theme={theme === "dark" ? "vs-dark" : "vs-light"}
                  options={{ minimap: { enabled: false }, fontSize: 14, automaticLayout: true }}
                />
                <div className="absolute top-2 right-2 text-xs text-muted-foreground bg-background/80 px-2 py-1 rounded">
                  {scriptContent.split('\n').length} lignes
                </div>
              </div>
            </CardContent>
          </Card>

          {/* AI Assistant */}
          <AssistantAIBlock
            title="Assistant IA pour l'édition de code"
            context={aiContext}
            onAnalyze={simulateScriptAIAnalysis}
            className="w-full"
          />
        </div>
      </div>
    </div>
  )
}
