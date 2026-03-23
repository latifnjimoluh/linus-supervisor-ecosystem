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
import { useErrors } from "@/hooks/use-errors"
import { ErrorBanner } from "@/components/error-banner"
import { cn } from "@/lib/utils"
import { ErrorMessage } from "@/components/ui/error-message"
import { InlineBanner } from "@/components/ui/inline-banner"

import {
  fetchTemplatesAndScripts,
  updateTemplate,
  createTemplate,
  simulateScript,
  type Template,
} from "@/lib/templates"

import {
  getGeneratedScriptById,
  getScriptContent,
  updateScript,
  type Script as ScriptApiModel,
} from "@/lib/scripts"

const MonacoEditor = dynamic(() => import("@monaco-editor/react"), { ssr: false })

const defaultBashScript = `#!/bin/bash

# Nouveau script`
const defaultTemplateJson = '{\n  "key": "value"\n}'

// ----------------------------- Utils JSON & Type -----------------------------
function safeParseJson(input: string): { ok: true; value: any } | { ok: false; error: Error } {
  try {
    const trimmed = (input ?? "").trim()
    if (trimmed === "") return { ok: true, value: {} }
    return { ok: true, value: JSON.parse(trimmed) }
  } catch (e: any) {
    return { ok: false, error: e }
  }
}

function prettyJson(input: string): string {
  const parsed = safeParseJson(input)
  if (parsed.ok) return JSON.stringify(parsed.value, null, 2)
  return input
}

type TemplateKind = "json" | "text"

// heuristique simple : commence par { ou [
function detectTemplateKind(raw: string): TemplateKind {
  const t = (raw ?? "").trim()
  if (!t) return "json" // par défaut
  return t.startsWith("{") || t.startsWith("[") ? "json" : "text"
}

type ScriptListItem = Template & { type?: "script" }

export default function CodeEditorPage() {
  const { theme } = useTheme()
  const searchParams = useSearchParams()
  const { toast } = useToast()
  const { setError, clearError } = useErrors()

  const [scripts, setScripts] = React.useState<ScriptListItem[]>([])
  const [templates, setTemplates] = React.useState<Template[]>([])
  const [selectedScript, setSelectedScript] = React.useState<ScriptListItem | null>(null)
  const [selectedTemplate, setSelectedTemplate] = React.useState<Template | null>(null)

  const [scriptContent, setScriptContent] = React.useState<string>("")
  const [scriptName, setScriptName] = React.useState<string>("")
  const [isModified, setIsModified] = React.useState<boolean>(false)
  const [isSaving, setIsSaving] = React.useState<boolean>(false)
  const [syntaxErrors, setSyntaxErrors] = React.useState<string[]>([])
  const [scriptStatus, setScriptStatus] = React.useState<"idle" | "ok" | "error">("idle")

  const tabParam = (searchParams.get("tab") as "scripts" | "templates") || "scripts"
  const [activeTab, setActiveTab] = React.useState<"scripts" | "templates">(tabParam)
  const [scriptView, setScriptView] = React.useState<"code" | "json">("code")

  // ---- État template
  const [templateName, setTemplateName] = React.useState<string>("")
  const [templateCategory, setTemplateCategory] = React.useState<string>("")
  const [templateService, setTemplateService] = React.useState<string>("")
  const [templateContent, setTemplateContent] = React.useState<string>("")
  const [templateStatus, setTemplateStatus] = React.useState<"idle" | "ok" | "error">("idle")
  const [templateErrorMsg, setTemplateErrorMsg] = React.useState<string>("")
  const [templateView, setTemplateView] = React.useState<"code" | "json">("code")
  const [templateKind, setTemplateKind] = React.useState<TemplateKind>("json")
  const [isTemplateModified, setIsTemplateModified] = React.useState<boolean>(false)
  const [isTemplateSaving, setIsTemplateSaving] = React.useState<boolean>(false)

  const itemId = searchParams.get("id")

  const scriptJson = React.useMemo(
    () => JSON.stringify({ name: scriptName ?? "", content: scriptContent ?? "" }, null, 2),
    [scriptName, scriptContent]
  )

  const templateJson = React.useMemo(() => {
    // Aperçu du payload envoyé à l'API lors de la sauvegarde
    const base = {
      name: templateName ?? "",
      category: (templateCategory ?? "general") || "general",
      service_type: (templateService ?? "custom") || "custom",
    }
    if (templateKind === "json") {
      const parsed = safeParseJson(templateContent)
      const template_content = parsed.ok ? parsed.value : templateContent
      return JSON.stringify({ ...base, template_content }, null, 2)
    } else {
      return JSON.stringify({ ...base, template_content: templateContent }, null, 2)
    }
  }, [templateName, templateCategory, templateService, templateContent, templateKind])

  // ----------------------------- Chargement initial -----------------------------
  React.useEffect(() => {
    fetchTemplatesAndScripts()
      .then(({ templates: tpls, scripts: scr }) => {
        setTemplates(tpls ?? [])
        setScripts((scr as ScriptListItem[]) ?? [])
        if (itemId) {
          const id = Number(itemId)
          const foundScript = (scr ?? []).find((s: any) => s.id === id)
          const foundTemplate = (tpls ?? []).find((t) => t.id === id)
          if (foundScript) {
            setSelectedScript(foundScript)
            setActiveTab("scripts")
          } else if (foundTemplate) {
            setSelectedTemplate(foundTemplate)
            setActiveTab("templates")
          } else {
            setSelectedScript((scr ?? [])[0] || null)
          }
        } else {
          setSelectedScript((scr ?? [])[0] || null)
        }
      })
      .catch(() => {
        setTemplates([])
        setScripts([])
      })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [itemId])

  // ----------------------------- Sélection script -----------------------------
  React.useEffect(() => {
    if (!selectedScript) return
    setScriptName(selectedScript.name ?? "")
    setIsModified(false)
    setScriptStatus("idle")
    setScriptView("code")

    getGeneratedScriptById(selectedScript.id)
      .then((detail: { content?: string } & ScriptApiModel) => {
        const fromDetail = (detail?.content ?? "").trim()
        if (fromDetail) {
          setScriptContent(fromDetail)
          return
        }
        const inline = (selectedScript as any)?.template_content
        if (inline && String(inline).trim()) {
          setScriptContent(String(inline))
          return
        }
        return getScriptContent(selectedScript.id).then((c) => setScriptContent(c || ""))
      })
      .catch(async () => {
        const inline = (selectedScript as any)?.template_content
        if (inline && String(inline).trim()) {
          setScriptContent(String(inline))
        } else {
          const c = await getScriptContent(selectedScript.id).catch(() => "")
          setScriptContent(c || "")
        }
      })
  }, [selectedScript])

  // ----------------------------- Sélection template -----------------------------
  React.useEffect(() => {
    if (!selectedTemplate) {
      setIsTemplateModified(false)
      return
    }
    setTemplateName(selectedTemplate.name ?? "")
    setTemplateCategory(selectedTemplate.category ?? "")
    setTemplateService(selectedTemplate.service_type ?? "")
    setIsTemplateModified(false)

    const raw = selectedTemplate.template_content ?? ""
    const kind = detectTemplateKind(raw)
    setTemplateKind(kind)

    if (kind === "json") {
      setTemplateContent(prettyJson(raw))
      const parsed = safeParseJson(raw)
      setTemplateStatus(parsed.ok ? "idle" : "error")
      setTemplateErrorMsg(parsed.ok ? "" : parsed.error.message || "JSON invalide")
      setTemplateView("code")
    } else {
      setTemplateContent(raw) // on garde tel quel, c'est du script/texte
      setTemplateStatus("idle")
      setTemplateErrorMsg("")
      setTemplateView("code")
    }
  }, [selectedTemplate])

  // ----------------------------- Scripts handlers -----------------------------
  const handleContentChange = (value: string) => {
    const val = value ?? ""
    setScriptContent(val)
    setIsModified(true)
    setScriptStatus("idle")

    const errors: string[] = []
    const lines = val.split("\n")
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

  // ----------------------------- Templates handlers -----------------------------
  const handleTemplateChange = (value: string) => {
    const val = value ?? ""
    setTemplateContent(val)
    setIsTemplateModified(true)

    if (templateKind === "json") {
      const parsed = safeParseJson(val)
      if (parsed.ok) {
        setTemplateStatus("ok")
        setTemplateErrorMsg("")
      } else {
        setTemplateStatus("error")
        setTemplateErrorMsg(parsed.error.message || "JSON invalide")
      }
    } else {
      // Pas de validation JSON côté "texte"
      setTemplateStatus("idle")
      setTemplateErrorMsg("")
    }
  }

  const handleChangeTemplateKind = (kind: TemplateKind) => {
    setTemplateKind(kind)
    setIsTemplateModified(true)
    if (kind === "json") {
      // on tente de formater si déjà du json plausible
      if (detectTemplateKind(templateContent) === "json") {
        setTemplateContent(prettyJson(templateContent))
        const parsed = safeParseJson(templateContent)
        setTemplateStatus(parsed.ok ? "ok" : "error")
        setTemplateErrorMsg(parsed.ok ? "" : parsed.error.message || "JSON invalide")
      } else {
        // bascule en JSON vide si l’utilisateur veut passer en JSON
        setTemplateContent(prettyJson(templateContent || defaultTemplateJson))
        const parsed = safeParseJson(templateContent || defaultTemplateJson)
        setTemplateStatus(parsed.ok ? "ok" : "error")
        setTemplateErrorMsg(parsed.ok ? "" : parsed.error.message || "JSON invalide")
      }
    } else {
      // mode texte : aucune erreur
      setTemplateStatus("idle")
      setTemplateErrorMsg("")
    }
  }

  // ----------------------------- Script actions -----------------------------
  const saveScript = async () => {
    if (!selectedScript) return
    setIsSaving(true)
    try {
      const updated = await updateScript(selectedScript.id, {
        name: scriptName ?? "",
        content: scriptContent ?? "",
      })

      setScripts((prev) =>
        prev.map((t) => (t.id === updated.id ? { ...t, name: updated.name ?? t.name } : t))
      )
      setSelectedScript((prev) => (prev ? { ...prev, name: updated.name ?? prev.name } : prev))
      setIsModified(false)
      toast({
        title: "Script sauvegardé",
        description: `${scriptName || "Script"} a été enregistré avec succès`,
        variant: "success",
      })
    } catch {
      setError("editor", { message: "Impossible de sauvegarder le script" })
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
      setScripts((prev) => [...prev, tpl as any])
      setSelectedScript(tpl as any)
    } catch {
      setError("editor", { message: "Impossible de créer le script" })
    }
  }

  const testScript = async () => {
    try {
      await simulateScript(scriptContent ?? "")
      setScriptStatus("ok")
      toast({
        title: "Test réussi",
        description: "Le script est valide",
        variant: "success",
      })
    } catch {
      setScriptStatus("error")
      setError("editor", { message: "Le script contient des erreurs" })
    }
  }

  const exportScript = (format: "sh" | "txt" | "json") => {
    let content = scriptContent ?? ""
    let filename = scriptName || "script"
    let type = "text/plain"

    if (format === "json") {
      content = JSON.stringify({ name: filename, content: content }, null, 2)
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
      const content = (e.target?.result as string) ?? ""
      setScriptContent(content)
      setScriptName(file.name ?? "")
      setIsModified(true)
    }
    reader.readAsText(file)
  }

  const copyToClipboard = () => {
    navigator.clipboard.writeText(scriptContent ?? "")
    toast({
      title: "Copié !",
      description: "Script copié dans le presse-papiers",
      variant: "success",
    })
  }

  const copyTemplateToClipboard = () => {
    navigator.clipboard.writeText(templateContent ?? "")
    toast({
      title: "Copié !",
      description: "Template copié dans le presse-papiers",
      variant: "success",
    })
  }

  const simulateTemplate = async () => {
    try {
      if (templateKind === "json") {
        const parsed = safeParseJson(templateContent)
        if (!parsed.ok) {
          setTemplateStatus("error")
          setError("editor", { message: `Template JSON invalide: ${parsed.error.message}` })
          return
        }
        await simulateScript(JSON.stringify(parsed.value))
      } else {
        await simulateScript(templateContent ?? "")
      }
      setTemplateStatus("ok")
      toast({
        title: "Simulation réussie",
        description: "Le template semble valide",
        variant: "success",
      })
    } catch {
      setTemplateStatus("error")
      setError("editor", { message: "Le template est invalide" })
    }
  }

  const saveTemplate = async () => {
    setIsTemplateSaving(true)
    try {
      if (selectedTemplate) {
        const payload =
          templateKind === "json"
            ? (() => {
                const parsed = safeParseJson(templateContent)
                if (!parsed.ok) {
                  setTemplateStatus("error")
                  setTemplateErrorMsg(parsed.error.message || "JSON invalide")
                  setError("editor", { message: `Template JSON invalide: ${parsed.error.message}` })
                  throw new Error("invalid json")
                }
                return {
                  name: templateName ?? "",
                  category: (templateCategory ?? "general") || "general",
                  service_type: (templateService ?? "custom") || "custom",
                  description: "",
                  template_content: JSON.stringify(parsed.value, null, 2),
                  fields_schema: { fields: [] },
                }
              })()
            : {
                name: templateName ?? "",
                category: (templateCategory ?? "general") || "general",
                service_type: (templateService ?? "custom") || "custom",
                description: "",
                template_content: templateContent ?? "",
                fields_schema: { fields: [] },
              }

        const updated = await updateTemplate(selectedTemplate.id, payload as any)
        setTemplates((prev) => prev.map((t) => (t.id === updated.id ? updated : t)))
        setSelectedTemplate(updated)
        setTemplateStatus("idle")
        setTemplateErrorMsg("")
        toast({
          title: "Template sauvegardé",
          description: `${templateName || "Template"} a été enregistré`,
          variant: "success",
        })
        setIsTemplateModified(false)
      } else {
        const payload =
          templateKind === "json"
            ? (() => {
                const parsed = safeParseJson(templateContent || defaultTemplateJson)
                if (!parsed.ok) {
                  setTemplateStatus("error")
                  setTemplateErrorMsg(parsed.error.message || "JSON invalide")
                  setError("editor", { message: `Template JSON invalide: ${parsed.error.message}` })
                  throw new Error("invalid json")
                }
                return {
                  name: templateName || `template_${Date.now()}.json`,
                  category: (templateCategory ?? "general") || "general",
                  service_type: (templateService ?? "custom") || "custom",
                  description: "",
                  template_content: JSON.stringify(parsed.value, null, 2),
                  fields_schema: { fields: [] },
                }
              })()
            : {
                name: templateName || `template_${Date.now()}.txt`,
                category: (templateCategory ?? "general") || "general",
                service_type: (templateService ?? "custom") || "custom",
                description: "",
                template_content: templateContent || defaultBashScript,
                fields_schema: { fields: [] },
              }

        const created = await createTemplate(payload as any)
        setTemplates((prev) => [...prev, created])
        setSelectedTemplate(created)
        setTemplateStatus("idle")
        setTemplateErrorMsg("")
        toast({
          title: "Template créé",
          description: `${created.name} a été enregistré`,
          variant: "success",
        })
        setIsTemplateModified(false)
      }
    } catch {
      // déjà toasts au-dessus si JSON invalide
    } finally {
      setIsTemplateSaving(false)
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
      // init état
      setTemplateKind("json")
      setTemplateContent(prettyJson(defaultTemplateJson))
      setTemplateStatus("idle")
      setTemplateErrorMsg("")
      setIsTemplateModified(false)
    } catch {
      setError("editor", { message: "Impossible de créer le template" })
    }
  }

  // --------------------------------- UI ---------------------------------
  return (
    <div className="space-y-6">
      <ErrorBanner id="editor" />
      <Tabs value={activeTab} onValueChange={(v) => setActiveTab(v as any)} className="space-y-6">
        <TabsList className="w-full md:w-auto">
          <TabsTrigger value="scripts">Scripts</TabsTrigger>
          <TabsTrigger value="templates">Templates</TabsTrigger>
        </TabsList>

        {/* SCRIPTS */}
        <TabsContent value="scripts">
          <div className="space-y-6">
            <div className="flex justify-between items-center">
              <div>
                <h1 className="text-4xl font-semibold">Éditeur de code interactif</h1>
                <p className="text-muted-foreground mt-1">Créez et modifiez vos scripts avec assistance IA</p>
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
                  {isSaving ? <RefreshCw className="mr-2 h-4 w-4 animate-spin" /> : <Save className="mr-2 h-4 w-4" />}
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
                        <div className="text-xs text-muted-foreground">bash</div>
                      </div>
                    ))}

                    <Button variant="outline" className="w-full rounded-xl" onClick={createNewScript}>
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
                        {scriptName || "Sans nom"}
                        {isModified && (
                          <Badge variant="warning" className="text-xs">
                            Non sauvegardé
                          </Badge>
                        )}
                      </CardTitle>
                      <div className="flex items-center gap-2">
                        <Button variant="ghost" size="sm" onClick={copyToClipboard} className="rounded-xl">
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
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div className="space-y-2">
                        <Label htmlFor="script-name">Nom du script</Label>
                        <Input
                          id="script-name"
                          value={scriptName ?? ""}
                          onChange={(e) => {
                            setScriptName(e.target.value ?? "")
                            setIsModified(true)
                          }}
                          className="rounded-xl"
                        />
                      </div>
                      <div className="space-y-2">
                        <Label htmlFor="script-language">Langage</Label>
                        <Select value="bash" onValueChange={() => {}}>
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
                      <>
                        <InlineBanner kind="destructive" title="Erreurs de syntaxe" className="mb-2" />
                        <ul className="space-y-1">
                          {syntaxErrors.map((error, index) => (
                            <li key={index}>
                              <ErrorMessage>{error}</ErrorMessage>
                            </li>
                          ))}
                        </ul>
                      </>
                    )}
                  </CardContent>
                </Card>

                <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
                  <CardHeader>
                    <CardTitle className="text-lg">Éditeur</CardTitle>
                    <CardDescription>
                      Éditez votre script avec coloration syntaxique et validation en temps réel
                    </CardDescription>
                  </CardHeader>
                  <CardContent>
                    <Tabs value={scriptView} onValueChange={setScriptView} className="space-y-2">
                      <TabsList className="w-full md:w-auto">
                        <TabsTrigger value="code">Code</TabsTrigger>
                        <TabsTrigger value="json">JSON</TabsTrigger>
                      </TabsList>
                      <TabsContent value="code">
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
                            {(scriptContent || "").split("\n").length} lignes
                          </div>
                        </div>
                      </TabsContent>
                      <TabsContent value="json">
                        <div className="relative rounded-xl overflow-hidden">
                          <MonacoEditor
                            value={scriptJson}
                            language="json"
                            height="500px"
                            theme={theme === "dark" ? "vs-dark" : "vs-light"}
                            options={{
                              readOnly: true,
                              minimap: { enabled: false },
                              fontSize: 14,
                              automaticLayout: true,
                              wordWrap: "on",
                              scrollBeyondLastLine: false,
                            }}
                          />
                          <div className="absolute top-2 right-2 text-xs text-muted-foreground bg-background/80 px-2 py-1 rounded">
                            {(scriptJson || "").split("\n").length} lignes
                          </div>
                        </div>
                      </TabsContent>
                    </Tabs>
                  </CardContent>
                </Card>
              </div>
            </div>
          </div>
        </TabsContent>

        {/* TEMPLATES */}
        <TabsContent value="templates">
          <div className="space-y-6">
            <div className="flex justify-between items-center">
              <div>
                <h1 className="text-4xl font-semibold">Templates</h1>
                <p className="text-muted-foreground mt-1">Gérez vos templates paramétrables</p>
              </div>
              <div className="flex gap-3">
                <Button onClick={simulateTemplate} variant="outline" className="rounded-xl">
                  <Play className="mr-2 h-4 w-4" /> Simuler
                </Button>
                <Button
                  onClick={saveTemplate}
                  className="rounded-xl"
                  disabled={!isTemplateModified || isTemplateSaving}
                >
                  {isTemplateSaving ? (
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
                        <div className="text-xs text-muted-foreground">{tpl.category}</div>
                      </div>
                    ))}

                    <Button variant="outline" className="w-full rounded-xl" onClick={createNewTemplate}>
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
                  <CardContent className="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div className="space-y-2 md:col-span-2">
                      <Label htmlFor="template-name">Nom</Label>
                      <Input
                        id="template-name"
                        value={templateName ?? ""}
                        onChange={(e) => {
                          setTemplateName(e.target.value ?? "")
                          setIsTemplateModified(true)
                        }}
                        className="rounded-xl"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="template-category">Catégorie</Label>
                      <Input
                        id="template-category"
                        value={templateCategory ?? ""}
                        onChange={(e) => {
                          setTemplateCategory(e.target.value ?? "")
                          setIsTemplateModified(true)
                        }}
                        className="rounded-xl"
                      />
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="template-service">Service</Label>
                      <Input
                        id="template-service"
                        value={templateService ?? ""}
                        onChange={(e) => {
                          setTemplateService(e.target.value ?? "")
                          setIsTemplateModified(true)
                        }}
                        className="rounded-xl"
                      />
                    </div>
                    <div className="space-y-2 md:col-span-2">
                      <Label>Type de template</Label>
                      <Select value={templateKind} onValueChange={(v) => handleChangeTemplateKind(v as TemplateKind)}>
                        <SelectTrigger className="rounded-xl">
                          <SelectValue placeholder="Sélectionner" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="json">JSON</SelectItem>
                          <SelectItem value="text">Script / Texte</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </CardContent>
                </Card>

                <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
                  <CardHeader>
                    <div className="flex items-center justify-between">
                      <CardTitle className="text-lg flex items-center gap-2">
                        <Code className="h-5 w-5" />
                        {templateName || "Sans nom"}
                        {isTemplateModified && (
                          <Badge variant="warning" className="text-xs">
                            Non sauvegardé
                          </Badge>
                        )}
                        {templateKind === "json" && templateStatus === "ok" && (
                          <Badge variant="success" className="text-xs">
                            <CheckCircle className="h-3 w-3 mr-1" /> Valide
                          </Badge>
                        )}
                        {templateKind === "json" && templateStatus === "error" && (
                          <Badge variant="destructive" className="text-xs">
                            <AlertTriangle className="h-3 w-3 mr-1" /> Erreur
                          </Badge>
                        )}
                      </CardTitle>
                      <Button variant="ghost" size="sm" onClick={copyTemplateToClipboard} className="rounded-xl">
                        <Copy className="h-4 w-4" />
                      </Button>
                    </div>
                  </CardHeader>
                  <CardContent>
                    {templateKind === "json" && templateStatus === "error" && templateErrorMsg && (
                      <div className="mb-3">
                        <InlineBanner
                          kind="destructive"
                          title="Template JSON invalide"
                          description={templateErrorMsg}
                        />
                      </div>
                    )}

                    <Tabs
                      // si "text", un seul onglet "code"
                      value={templateView}
                      onValueChange={setTemplateView}
                      className="space-y-2"
                    >
                      <TabsList className="w-full md:w-auto">
                        <TabsTrigger value="code">Code</TabsTrigger>
                        {templateKind === "json" && <TabsTrigger value="json">JSON (payload)</TabsTrigger>}
                      </TabsList>

                      <TabsContent value="code">
                        <div className="relative rounded-xl overflow-hidden">
                          <MonacoEditor
                            value={templateContent}
                            language={templateKind === "json" ? "json" : "bash"}
                            onChange={(value) => handleTemplateChange(value || "")}
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
                            {(templateContent || "").split("\n").length} lignes
                          </div>
                        </div>
                      </TabsContent>

                      {templateKind === "json" && (
                        <TabsContent value="json">
                          <div className="relative rounded-xl overflow-hidden">
                            <MonacoEditor
                              value={templateJson}
                              language="json"
                              height="500px"
                              theme={theme === "dark" ? "vs-dark" : "vs-light"}
                              options={{
                                readOnly: true,
                                minimap: { enabled: true },
                                fontSize: 14,
                                automaticLayout: true,
                                wordWrap: "on",
                                scrollBeyondLastLine: false,
                              }}
                            />
                            <div className="absolute top-2 right-2 text-xs text-muted-foreground bg-background/80 px-2 py-1 rounded">
                              {(templateJson || "").split("\n").length} lignes
                            </div>
                          </div>
                        </TabsContent>
                      )}
                    </Tabs>
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
