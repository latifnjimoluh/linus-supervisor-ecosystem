"use client"

import * as React from "react"
import { Search, Plus, Code, Filter, Copy, Check, Edit, Sparkles } from "lucide-react"
import { motion, AnimatePresence } from "framer-motion"
import Link from "next/link"

import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs"
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from "@/components/ui/select"
import { useToast } from "@/hooks/use-toast"
import {
  fetchTemplatesAndScripts,
  deleteTemplate,
  restoreTemplate,
  analyzeTemplate,
  type Template,
} from "@/lib/templates"
import {
  getScriptContent,
  deleteScript,
  restoreScript,
  analyzeScript,
  type Script,
} from "@/lib/scripts"
import dynamic from "next/dynamic"
import { useTheme } from "next-themes"
import { AssistantAIBlock } from "@/components/assistant-ai-block"

const MonacoEditor = dynamic(() => import("@monaco-editor/react"), { ssr: false })

export type ScriptOrTemplate = Template | Script

interface ScriptsTemplatesBrowserProps {
  defaultTab?: "scripts" | "templates"
}

type TabKey = "scripts" | "templates"
type CategoryFilter = "ALL" | string

export default function ScriptsTemplatesBrowser({
  defaultTab = "templates",
}: ScriptsTemplatesBrowserProps) {
  const [searchTerm, setSearchTerm] = React.useState("")
  const [selectedItem, setSelectedItem] = React.useState<ScriptOrTemplate | null>(null)
  const [itemContent, setItemContent] = React.useState("")
  const [loading, setLoading] = React.useState(false)
  const [tab, setTab] = React.useState<TabKey>(defaultTab)
  const [copied, setCopied] = React.useState(false)
  const [items, setItems] = React.useState<ScriptOrTemplate[]>([])
  const [categoryFilter, setCategoryFilter] = React.useState<CategoryFilter>("ALL")
  const [statusFilter, setStatusFilter] = React.useState<'actif' | 'supprime' | 'all'>('actif')
  const { toast } = useToast()
  const { theme } = useTheme()

  const refreshItems = React.useCallback(() => {
    fetchTemplatesAndScripts(statusFilter)
      .then(({ templates, scripts }) => setItems([...(scripts ?? []), ...(templates ?? [])]))
      .catch(() => setItems([]))
  }, [statusFilter])

  React.useEffect(() => {
    refreshItems()
  }, [refreshItems])

  const categories = React.useMemo(
    () =>
      Array.from(
        new Set(
          items
            .map((i) => i.category)
            .filter((c): c is string => Boolean(c && String(c).trim().length > 0))
        )
      ),
    [items]
  )

  const filteredBase = items.filter((t) => {
    const q = searchTerm.toLowerCase()
    const inText =
      t.name.toLowerCase().includes(q) ||
      (t.description ?? "").toLowerCase().includes(q)
    const inCategory = categoryFilter === "ALL" ? true : t.category === categoryFilter
    return inText && inCategory
  })

  const filteredScripts = filteredBase.filter((t) => t.type === "script")
  const filteredTemplates = filteredBase.filter((t) => t.type === "template")

  const copyContent = (content: string) => {
    navigator.clipboard.writeText(content)
    setCopied(true)
    toast({
      title: "Copié !",
      description: "Le contenu a été copié dans le presse-papiers.",
      variant: "success",
    })
    setTimeout(() => setCopied(false), 1500)
  }

  const handleViewCode = (item: ScriptOrTemplate) => {
    setSelectedItem(item)
    if (item.type === "script") {
      setLoading(true)
      setItemContent("")
      getScriptContent(item.id)
        .then((content) => setItemContent(content))
        .finally(() => setLoading(false))
    } else {
      setItemContent(item.template_content)
    }
  }

  const analyzeItem = async (item: ScriptOrTemplate): Promise<string> => {
    const content =
      item.type === 'template' ? item.template_content : await getScriptContent(item.id)
    const res =
      item.type === 'template'
        ? await analyzeTemplate(content, item.id)
        : await analyzeScript(content, item.id)
    return res.analysis
  }

  const handleDelete = async (item: ScriptOrTemplate) => {
    try {
      if (item.type === 'template') await deleteTemplate(item.id)
      else await deleteScript(item.id)
      toast({ title: 'Élément supprimé', variant: 'success' })
      refreshItems()
    } catch {
      toast({ title: 'Erreur', description: 'Suppression impossible', variant: 'destructive' })
    }
  }

  const handleRestore = async (item: ScriptOrTemplate) => {
    try {
      if (item.type === 'template') await restoreTemplate(item.id)
      else await restoreScript(item.id)
      toast({ title: 'Élément réactivé', variant: 'success' })
      refreshItems()
    } catch {
      toast({ title: 'Erreur', description: 'Réactivation impossible', variant: 'destructive' })
    }
  }

  const renderGrid = (itemsToShow: ScriptOrTemplate[]) => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <AnimatePresence>
        {itemsToShow.map((item) => (
          <motion.div
            key={`${item.type}-${item.id}`}
            layout
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
          >
            <Card data-item-type={item.type} className="h-full flex flex-col hover:shadow-lg transition-shadow rounded-2xl">
              <CardHeader>
                <CardTitle className="text-lg">{item.name}</CardTitle>
                <div className="flex flex-wrap gap-2 pt-2">
                  <Badge variant="secondary">{item.category || "Non catégorisé"}</Badge>
                  <Badge variant={item.type === "template" ? "default" : "outline"}>
                    {item.type === "template" ? "Paramétrable" : "Script simple"}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent className="flex-1">
                <p className="text-sm text-muted-foreground">{item.description}</p>
              </CardContent>
              <div className="p-4 border-t flex flex-wrap gap-2">
                <Dialog>
                  <DialogTrigger asChild>
                    <Button variant="secondary" size="sm" onClick={() => handleViewCode(item)}>
                      <Code className="mr-2 h-4 w-4" /> Voir le code
                    </Button>
                  </DialogTrigger>
                  {selectedItem?.id === item.id && (
                    <DialogContent className="max-w-3xl max-h-[80vh] overflow-y-auto">
                      <DialogHeader>
                        <DialogTitle>{selectedItem.name}</DialogTitle>
                        <DialogDescription>
                          {selectedItem.type === "script"
                            ? "Aperçu du contenu du script."
                            : "Aperçu du contenu du template et de ses champs."}
                        </DialogDescription>
                      </DialogHeader>
                      <div className="relative mt-4">
                        <Button
                          size="sm"
                          variant="ghost"
                          className="absolute top-2 right-2 h-7 w-7 p-0"
                          onClick={() => copyContent(itemContent)}
                          aria-label="Copier"
                        >
                          {copied ? <Check className="h-4 w-4 text-green-500" /> : <Copy className="h-4 w-4" />}
                        </Button>
                        <div className="rounded-lg border overflow-hidden">
                          <MonacoEditor
                            value={loading ? "Chargement..." : itemContent}
                            language={selectedItem.type === "template" ? "json" : "bash"}
                            theme={theme === "dark" ? "vs-dark" : "vs-light"}
                            height="400px"
                            options={{
                              readOnly: true,
                              minimap: { enabled: true },
                              fontSize: 12,
                              automaticLayout: true,
                              wordWrap: "on",
                              scrollBeyondLastLine: false,
                            }}
                          />
                        </div>
                      </div>
                      {selectedItem.type === "template" &&
                        "fields_schema" in selectedItem &&
                        selectedItem.fields_schema && (
                          <div className="mt-4">
                            <h3 className="font-semibold mb-2">Champs de configuration :</h3>
                            <ul className="list-disc pl-5 text-sm text-muted-foreground">
                              {selectedItem.fields_schema.fields.map((field, index) => (
                                <li key={index}>
                                  <strong>{field.label}</strong> ({field.name}): {field.type}{" "}
                                  {field.required ? "(Requis)" : "(Optionnel)"}{" "}
                                  {field.default !== undefined && `(Défaut: ${String(field.default)})`}
                                </li>
                              ))}
                            </ul>
                          </div>
                        )}
                    </DialogContent>
                  )}
                </Dialog>
                <Button asChild variant="outline" size="sm">
                  <Link href={`/editor?id=${item.id}`}>
                    <Edit className="mr-2 h-4 w-4" /> Éditer
                  </Link>
                </Button>
                <Dialog>
                  <DialogTrigger asChild>
                    <Button variant="outline" size="sm">
                      <Sparkles className="mr-2 h-4 w-4" /> Analyse IA
                    </Button>
                  </DialogTrigger>
                  <DialogContent className="max-w-md">
                    <AssistantAIBlock
                      title={`Analyse IA de ${item.name}`}
                      context={`${item.type}:${item.id}`}
                      onAnalyze={() => analyzeItem(item)}
                      className="w-full"
                    />
                  </DialogContent>
                </Dialog>
                {item.status === 'actif' ? (
                  <Button variant="destructive" size="sm" onClick={() => handleDelete(item)}>
                    Supprimer
                  </Button>
                ) : (
                  <Button variant="secondary" size="sm" onClick={() => handleRestore(item)}>
                    Réactiver
                  </Button>
                )}
              </div>
            </Card>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  )

  const renderSection = (itemsToShow: ScriptOrTemplate[]) => (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row items-center gap-3">
        <div className="relative w-full md:max-w-sm">
          <Search className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Rechercher..."
            className="pl-8"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>

        <Select
          value={categoryFilter}
          onValueChange={(v) => setCategoryFilter(v as CategoryFilter)}
        >
          <SelectTrigger className="w-full md:w-[220px]">
            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4" />
              <SelectValue placeholder="Toutes les catégories" />
            </div>
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="ALL">Toutes les catégories</SelectItem>
            {categories.map((cat) => (
              <SelectItem key={cat} value={cat}>
                {cat}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={(v) => setStatusFilter(v as any)}>
          <SelectTrigger className="w-full md:w-[180px]">
            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4" />
              <SelectValue placeholder="Statut" />
            </div>
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="actif">Actif</SelectItem>
            <SelectItem value="supprime">Supprimé</SelectItem>
            <SelectItem value="all">Tous</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {renderGrid(itemsToShow)}
    </div>
  )

  return (
    <div className="space-y-6">
      <header className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div className="flex items-center gap-3">
          <BackButton href="/dashboard" label="Retour" />
          <div>
            <h1 className="text-3xl md:text-4xl font-bold tracking-tight">Scripts & Templates</h1>
            <p className="text-muted-foreground mt-2">
              Parcourez, analysez et utilisez des scripts pour automatiser vos déploiements.
            </p>
          </div>
        </div>
        <Button
          asChild
          className="w-full md:w-auto bg-blue-600 hover:bg-blue-700 text-white"
        >
          <Link href={tab === "scripts" ? "/scripts/generate" : "/templates/new"}>
            <Plus className="mr-2 h-4 w-4" />
            {tab === "scripts" ? "Créer un nouveau script" : "Créer un nouveau template"}
          </Link>
        </Button>
      </header>

      <Tabs value={tab} onValueChange={(v) => setTab(v as TabKey)} className="space-y-6">
        <TabsList className="w-full md:w-auto">
          <TabsTrigger value="scripts">Scripts</TabsTrigger>
          <TabsTrigger value="templates">Templates</TabsTrigger>
        </TabsList>
        <TabsContent value="scripts">{renderSection(filteredScripts)}</TabsContent>
        <TabsContent value="templates">{renderSection(filteredTemplates)}</TabsContent>
      </Tabs>
    </div>
  )
}
