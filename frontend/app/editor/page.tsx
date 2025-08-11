"use client"

import * as React from "react"
import dynamic from "next/dynamic"
import { useTheme } from "next-themes"
import { useSearchParams } from "next/navigation"
import {
  Code,
  Save,
  Play,
  Download,
  Upload,
  FileText,
  Copy,
  RefreshCw,
  CheckCircle,
  AlertTriangle,
} from "lucide-react"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"
import {
  fetchTemplatesAndScripts,
  updateTemplate,
  createTemplate,
  simulateScript,
  type Template,
} from "@/lib/templates"
import { getScriptContent } from "@/lib/scripts"

const MonacoEditor = dynamic(() => import("@monaco-editor/react"), { ssr: false })

const defaultBashScript = `#!/bin/bash\n\n# Nouveau script`
const defaultTemplateJson = '{\n  "key": "value"\n}'


export default function CodeEditorPage() {
  const { theme } = useTheme()
  const searchParams = useSearchParams()
  const { toast } = useToast()

  const [scripts, setScripts] = React.useState<Template[]>([])
  const [templates, setTemplates] = React.useState<Template[]>([])
  const [selectedScript, setSelectedScript] = React.useState<Template | null>(null)
  const [selectedTemplate, setSelectedTemplate] = React.useState<Template | null>(null)
  const [scriptContent, setScriptContent] = React.useState("")
  const [scriptName, setScriptName] = React.useState("")
  const [isModified, setIsModified] = React.useState(false)
  const [isSaving, setIsSaving] = React.useState(false)
  const [syntaxErrors, setSyntaxErrors] = React.useState<string[]>([])
  const [scriptStatus, setScriptStatus] = React.useState<"idle" | "ok" | "error">("idle")
  const tabParam = searchParams.get("tab") || "scripts"
  const [activeTab, setActiveTab] = React.useState(tabParam)

  const [templateName, setTemplateName] = React.useState("")
  const [templateCategory, setTemplateCategory] = React.useState("")
  const [templateService, setTemplateService] = React.useState("")
  const [templateContent, setTemplateContent] = React.useState("")
  const [templateStatus, setTemplateStatus] = React.useState<"idle" | "ok" | "error">("idle")

  const itemId = searchParams.get("id")

  React.useEffect(() => {
    fetchTemplatesAndScripts()
      .then(({ templates: tpls, scripts: scr }) => {
        setTemplates(tpls)
        setScripts(scr as Template[])
        if (itemId) {
          const id = Number(itemId)
          const foundScript = scr.find((s) => s.id === id)
          const foundTemplate = tpls.find((t) => t.id === id)
          if (foundScript) {
            setSelectedScript(foundScript)
            setActiveTab("scripts")
          } else if (foundTemplate) {
            setSelectedTemplate(foundTemplate)
            setActiveTab("templates")
          } else {
            setSelectedScript(scr[0] || null)
          }
        } else {
          setSelectedScript(scr[0] || null)
        }
      })
      .catch(() => {
        setTemplates([])
        setScripts([])
      })
  }, [itemId])

  React.useEffect(() => {
    if (selectedScript) {
      setScriptName(selectedScript.name)
      setIsModified(false)
      setScriptStatus("idle")
      if (selectedScript.template_content && selectedScript.template_content.trim()) {
        setScriptContent(selectedScript.template_content)
      } else {
        getScriptContent(selectedScript.id)
          .then((content) => setScriptContent(content))
          .catch(() => setScriptContent(""))
      }
    }
  }, [selectedScript])

  React.useEffect(() => {
    if (selectedTemplate) {
      setTemplateName(selectedTemplate.name)
      setTemplateCategory(selectedTemplate.category)
      setTemplateService(selectedTemplate.service_type)
      try {
        setTemplateContent(
          JSON.stringify(
            JSON.parse(selectedTemplate.template_content),
            null,
            2
          )
        )
      } catch {
        setTemplateContent(selectedTemplate.template_content)
      }
      setTemplateStatus("idle")
    }
  }, [selectedTemplate])

  const handleContentChange = (value: string) => {
    setScriptContent(value)
    setIsModified(true)
    setScriptStatus("idle")

    const errors: string[] = []
    const lines = value.split("\n")
    lines.forEach((line, index) => {
      const trimmed = line.trim()
      if (trimmed.startsWith("if [") && !trimmed.includes("];")) {
        if (!lines[index + 1]?.trim().startsWith("then")) {
          errors.push(`Ligne ${index + 1}: 'if' sans 'then'`)
        }
      }
      if (trimmed === "fi" && !lines.slice(0, index).some((l) => l.trim().startsWith("if"))) {
        errors.push(`Ligne ${index + 1}: 'fi' sans 'if' correspondant`)
      }
    })
    setSyntaxErrors(errors)
  }

  const saveScript = async () => {
    if (!selectedScript) return
    setIsSaving(true)
    try {
      const updated = await updateTemplate(selectedScript.id, {
        name: scriptName,
        template_content: scriptContent,
      })
      setScripts((prev) => prev.map((t) => (t.id === updated.id ? updated : t)))
      setSelectedScript(updated)
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

  const createNewScript = async () => {
    try {
      const name = `script_${Date.now()}.sh`
      const tpl = await createTemplate({
        name,
        service_type: "custom",
        category: "general",
        description: "",
        template_content: defaultBashScript,
        fields_schema: { fields: [] },
      })
      setScripts((prev) => [...prev, tpl])
      setSelectedScript(tpl)
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Impossible de créer le script",
        variant: "destructive",
      })
    }
  }

  const testScript = async () => {
    try {
      await simulateScript(scriptContent)
      setScriptStatus("ok")
      toast({
        title: "Test réussi",
        description: "Le script est valide",
        variant: "success",
      })
    } catch (error) {
      setScriptStatus("error")
      toast({
        title: "Erreur de test",
        description: "Le script contient des erreurs",
        variant: "destructive",
      })
    }
  }

  const exportScript = (format: "sh" | "txt" | "json") => {
    let content = scriptContent
    let filename = scriptName || "script"
    let type = "text/plain"

    if (format === "json") {
      content = JSON.stringify({ name: filename, content: scriptContent }, null, 2)
      type = "application/json"
      filename = filename.endsWith(".json") ? filename : `${filename}.json`
    } else if (format === "txt") {
      type = "text/plain"
      filename = filename.endsWith(".txt") ? filename : `${filename}.txt`
    } else {
      type = "text/x-sh"
      filename = filename.endsWith(".sh") ? filename : `${filename}.sh`
    }

    const blob = new Blob([content], { type })
    const url = URL.createObjectURL(blob)
    const a = document.createElement("a")
    a.href = url
    a.download = filename
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)

    toast({
      title: "Script exporté",
      description: `${filename} a été téléchargé`,
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

  const copyTemplateToClipboard = () => {
    navigator.clipboard.writeText(templateContent)
    toast({
      title: "Copié !",
      description: "Template copié dans le presse-papiers",
      variant: "success",
    })
  }

  const simulateTemplate = async () => {
    try {
      await simulateScript(JSON.stringify(JSON.parse(templateContent)))
      setTemplateStatus("ok")
      toast({
        title: "Simulation réussie",
        description: "Le template semble valide",
        variant: "success",
      })
    } catch (error) {
      setTemplateStatus("error")
      toast({
        title: "Erreur",
        description: "Le template est invalide",
        variant: "destructive",
      })
    }
  }

  const saveTemplate = async () => {
    let parsed
    try {
      parsed = JSON.parse(templateContent)
    } catch {
      toast({
        title: "Erreur",
        description: "Template JSON invalide",
        variant: "destructive",
      })
      return
    }
    try {
      if (selectedTemplate) {
        const updated = await updateTemplate(selectedTemplate.id, {
          name: templateName,
          category: templateCategory || "general",
          service_type: templateService || "custom",
          description: "",
          template_content: JSON.stringify(parsed),
          fields_schema: { fields: [] },
        })
        setTemplates((prev) => prev.map((t) => (t.id === updated.id ? updated : t)))
        setSelectedTemplate(updated)
        toast({
          title: "Template sauvegardé",
          description: `${templateName} a été enregistré`,
          variant: "success",
        })
      } else {
        const created = await createTemplate({
          name: templateName,
          category: templateCategory || "general",
          service_type: templateService || "custom",
          description: "",
          template_content: JSON.stringify(parsed),
          fields_schema: { fields: [] },
        })
        setTemplates((prev) => [...prev, created])
        setSelectedTemplate(created)
        toast({
          title: "Template créé",
          description: `${templateName} a été enregistré`,
          variant: "success",
        })
      }
      setTemplateStatus("idle")
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Impossible de sauvegarder le template",
        variant: "destructive",
      })
    }
  }

  const createNewTemplate = async () => {
    try {
      const name = `template_${Date.now()}.json`
      const tpl = await createTemplate({
        name,
        service_type: "custom",
        category: "general",
        description: "",
        template_content: defaultTemplateJson,
        fields_schema: { fields: [] },
      })
      setTemplates((prev) => [...prev, tpl])
      setSelectedTemplate(tpl)
    } catch (error) {
      toast({
        title: "Erreur",
        description: "Impossible de créer le template",
        variant: "destructive",
      })
    }
  }

  return (
    <div className="space-y-6">
      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList className="w-full md:w-auto">
          <TabsTrigger value="scripts">Scripts</TabsTrigger>
          <TabsTrigger value="templates">Templates</TabsTrigger>
        </TabsList>
        <TabsContent value="scripts">
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
          <DropdownMenu>
            <DropdownMenuTrigger asChild>
              <Button variant="outline" className="rounded-xl">
                <Download className="mr-2 h-4 w-4" />
                Exporter
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent>
              <DropdownMenuItem onClick={() => exportScript("sh")}>Format .sh</DropdownMenuItem>
              <DropdownMenuItem onClick={() => exportScript("txt")}>Format .txt</DropdownMenuItem>
              <DropdownMenuItem onClick={() => exportScript("json")}>Format .json</DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
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
        <div className="lg:col-span-1">
          <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <FileText className="h-5 w-5" />
                Scripts
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-3 max-h-96 overflow-y-auto">
              {scripts.map((tpl) => (
                <div
                  key={tpl.id}
                  onClick={() => setSelectedScript(tpl)}
                  className={cn(
                    "p-3 rounded-xl border cursor-pointer transition-colors hover:bg-muted/50",
                    selectedScript?.id === tpl.id && "bg-primary/10 border-primary"
                  )}
                >
                  <div className="flex items-center justify-between mb-1">
                    <span className="font-medium text-sm">{tpl.name}</span>
                    <Badge variant="secondary" className="text-xs">
                      Script
                    </Badge>
                  </div>
                  <div className="text-xs text-muted-foreground">
                    bash
                  </div>
                </div>
              ))}

              <Button
                variant="outline"
                className="w-full rounded-xl"
                onClick={createNewScript}
              >
                <Code className="mr-2 h-4 w-4" />
                Nouveau script
              </Button>
            </CardContent>
          </Card>
        </div>

        <div className="lg:col-span-3 space-y-6">
          <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle className="text-lg flex items-center gap-2">
                  <Code className="h-5 w-5" />
                  {scriptName}
                  {isModified && (
                    <Badge variant="warning" className="text-xs">
                      Non sauvegardé
                    </Badge>
                  )}
                </CardTitle>
                <div className="flex items-center gap-2">
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={copyToClipboard}
                    className="rounded-xl"
                  >
                    <Copy className="h-4 w-4" />
                  </Button>
                  {scriptStatus === "ok" && (
                    <Badge variant="success" className="text-xs">
                      <CheckCircle className="h-3 w-3 mr-1" />
                      Syntaxe OK
                    </Badge>
                  )}
                  {scriptStatus === "error" && (
                    <Badge variant="destructive" className="text-xs">
                      <AlertTriangle className="h-3 w-3 mr-1" />
                      Erreur
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
                  <Select value="bash">
                    <SelectTrigger className="rounded-xl">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="bash">Bash</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              {syntaxErrors.length > 0 && (
                <div className="bg-destructive/10 border border-destructive/20 rounded-xl p-4">
                  <div className="flex items-center gap-2 mb-2">
                    <AlertTriangle className="h-4 w-4 text-destructive" />
                    <span className="font-medium text-destructive">
                      Erreurs de syntaxe
                    </span>
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

          <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
            <CardHeader>
              <CardTitle className="text-lg">Éditeur</CardTitle>
              <CardDescription>
                Éditez votre script avec coloration syntaxique et validation en temps
                réel
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="relative rounded-xl overflow-hidden">
                <MonacoEditor
                  value={scriptContent}
                  language="bash"
                  onChange={(value) => handleContentChange(value || "")}
                  height="500px"
                  theme={theme === "dark" ? "vs-dark" : "vs-light"}
                  options={{
                    minimap: { enabled: false },
                    fontSize: 14,
                    automaticLayout: true,
                    wordWrap: "on",
                    scrollBeyondLastLine: false,
                  }}
                />
                <div className="absolute top-2 right-2 text-xs text-muted-foreground bg-background/80 px-2 py-1 rounded">
                  {scriptContent.split("\n").length} lignes
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
      </div>
        </TabsContent>
        <TabsContent value="templates">
          <div className="space-y-6">
            <div className="flex justify-between items-center">
              <div>
                <h1 className="text-4xl font-semibold">Templates</h1>
                <p className="text-muted-foreground mt-1">
                  Gérez vos templates paramétrables
                </p>
              </div>
              <div className="flex gap-3">
                <Button onClick={simulateTemplate} variant="outline" className="rounded-xl">
                  <Play className="mr-2 h-4 w-4" /> Simuler
                </Button>
                <Button onClick={saveTemplate} className="rounded-xl">
                  <Save className="mr-2 h-4 w-4" /> Sauvegarder
                </Button>
              </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
              <div className="lg:col-span-1">
                <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
                  <CardHeader>
                    <CardTitle className="text-lg flex items-center gap-2">
                      <FileText className="h-5 w-5" /> Templates
                    </CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-3 max-h-96 overflow-y-auto">
                    {templates.map((tpl) => (
                      <div
                        key={tpl.id}
                        onClick={() => setSelectedTemplate(tpl)}
                        className={cn(
                          "p-3 rounded-xl border cursor-pointer transition-colors hover:bg-muted/50",
                          selectedTemplate?.id === tpl.id && "bg-primary/10 border-primary"
                        )}
                      >
                        <div className="flex items-center justify-between mb-1">
                          <span className="font-medium text-sm">{tpl.name}</span>
                          <Badge variant="secondary" className="text-xs">
                            Template
                          </Badge>
                        </div>
                        <div className="text-xs text-muted-foreground">
                          {tpl.category}
                        </div>
                      </div>
                    ))}

                    <Button
                      variant="outline"
                      className="w-full rounded-xl"
                      onClick={createNewTemplate}
                    >
                      <Code className="mr-2 h-4 w-4" />
                      Nouveau template
                    </Button>
                  </CardContent>
                </Card>
              </div>

              <div className="lg:col-span-3 space-y-6">
                <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
                  <CardHeader>
                    <CardTitle className="text-lg">Informations</CardTitle>
                  </CardHeader>
                  <CardContent className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div className="space-y-2">
                      <Label htmlFor="template-name">Nom</Label>
                      <Input
                        id="template-name"
                        value={templateName}
                        onChange={(e) => setTemplateName(e.target.value)}
                        className="rounded-xl"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="template-category">Catégorie</Label>
                      <Input
                        id="template-category"
                        value={templateCategory}
                        onChange={(e) => setTemplateCategory(e.target.value)}
                        className="rounded-xl"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="template-service">Service</Label>
                      <Input
                        id="template-service"
                        value={templateService}
                        onChange={(e) => setTemplateService(e.target.value)}
                        className="rounded-xl"
                      />
                    </div>
                  </CardContent>
                </Card>

                <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
                  <CardHeader>
                    <div className="flex items-center justify-between">
                      <CardTitle className="text-lg flex items-center gap-2">
                        <Code className="h-5 w-5" /> Contenu
                        {templateStatus === "ok" && (
                          <Badge variant="success" className="text-xs">
                            <CheckCircle className="h-3 w-3 mr-1" /> Valide
                          </Badge>
                        )}
                        {templateStatus === "error" && (
                          <Badge variant="destructive" className="text-xs">
                            <AlertTriangle className="h-3 w-3 mr-1" /> Erreur
                          </Badge>
                        )}
                      </CardTitle>
                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => copyTemplateToClipboard()}
                        className="rounded-xl"
                      >
                        <Copy className="h-4 w-4" />
                      </Button>
                    </div>
                  </CardHeader>
                  <CardContent>
                    <div className="relative rounded-xl overflow-hidden">
                      <MonacoEditor
                        value={templateContent}
                        language="json"
                        onChange={(value) => setTemplateContent(value || "")}
                        height="500px"
                        theme={theme === "dark" ? "vs-dark" : "vs-light"}
                        options={{
                          minimap: { enabled: true },
                          fontSize: 14,
                          automaticLayout: true,
                          wordWrap: "on",
                          scrollBeyondLastLine: false,
                        }}
                      />
                      <div className="absolute top-2 right-2 text-xs text-muted-foreground bg-background/80 px-2 py-1 rounded">
                        {templateContent.split("\n").length} lignes
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </div>
            </div>
          </div>
        </TabsContent>
      </Tabs>
    </div>
  )
}

