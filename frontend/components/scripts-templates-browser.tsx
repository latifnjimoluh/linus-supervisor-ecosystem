"use client"

import * as React from "react"
import { Search, Plus, Code, Sparkles, Filter, Copy, Check, Edit } from "lucide-react"
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
import { fetchTemplatesAndScripts, type Template } from "@/lib/templates"
import type { Script } from "@/lib/scripts"
import { getScriptContent } from "@/lib/scripts"

export type ScriptOrTemplate = Template | Script

interface ScriptsTemplatesBrowserProps {
  defaultTab?: "scripts" | "templates"
}

export default function ScriptsTemplatesBrowser({
  defaultTab = "templates",
}: ScriptsTemplatesBrowserProps) {
  const [searchTerm, setSearchTerm] = React.useState("")
  const [selectedItem, setSelectedItem] = React.useState<ScriptOrTemplate | null>(null)
  const [itemContent, setItemContent] = React.useState("")
  const [loading, setLoading] = React.useState(false)
  const [tab, setTab] = React.useState<"scripts" | "templates">(defaultTab)
  const [copied, setCopied] = React.useState(false)
  const [items, setItems] = React.useState<ScriptOrTemplate[]>([])
  const [categoryFilter, setCategoryFilter] = React.useState("")
  const { toast } = useToast()

  React.useEffect(() => {
    fetchTemplatesAndScripts()
      .then(({ templates, scripts }) => setItems([...scripts, ...templates]))
      .catch(() => setItems([]))
  }, [])

  const categories = React.useMemo(
    () => Array.from(new Set(items.map((i) => i.category))),
    [items]
  )

  const filtered = items
    .filter((t) =>
      t.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      (t.description ?? "").toLowerCase().includes(searchTerm.toLowerCase())
    )
    .filter((t) => (categoryFilter ? t.category === categoryFilter : true))
  const filteredScripts = filtered.filter((t) => t.type === "script")
  const filteredTemplates = filtered.filter((t) => t.type === "template")

  const copyContent = (content: string) => {
    navigator.clipboard.writeText(content)
    setCopied(true)
    toast({ title: "Copié !", description: "Le contenu du script a été copié.", variant: "success" })
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

  const renderGrid = (items: ScriptOrTemplate[]) => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <AnimatePresence>
        {items.map((item) => (
          <motion.div
            key={`${item.type}-${item.id}`}
            layout
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
          >
            <Card className="h-full flex flex-col hover:shadow-lg transition-shadow rounded-2xl">
              <CardHeader>
                <CardTitle className="text-lg">{item.name}</CardTitle>
                <div className="flex flex-wrap gap-2 pt-2">
                  <Badge variant="secondary">{item.category}</Badge>
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
                  {selectedItem && (
                    <DialogContent className="max-w-3xl">
                      <DialogHeader>
                        <DialogTitle>{selectedItem.name}</DialogTitle>
                        <DialogDescription>
                          {selectedItem.type === "script"
                            ? "Aperçu du contenu du script."
                            : "Aperçu du contenu du template et de ses champs."}
                        </DialogDescription>
                      </DialogHeader>
                      <div className="relative bg-muted rounded-lg p-4 mt-4">
                        <Button
                          size="sm"
                          variant="ghost"
                          className="absolute top-2 right-2 h-7 w-7 p-0"
                          onClick={() => copyContent(itemContent)}
                          aria-label="Copier"
                        >
                          {copied ? <Check className="h-4 w-4 text-green-500" /> : <Copy className="h-4 w-4" />}
                        </Button>
                        <pre className="text-sm whitespace-pre-wrap overflow-auto max-h-[60vh] break-words break-all">
                          <code className="font-mono">{loading ? "Chargement..." : itemContent}</code>
                        </pre>
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
                <Button variant="outline" size="sm">
                  <Sparkles className="mr-2 h-4 w-4" /> Analyser (IA)
                </Button>
              </div>
            </Card>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  )

  const renderSection = (items: ScriptOrTemplate[]) => (
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
        <Select value={categoryFilter} onValueChange={setCategoryFilter}>
          <SelectTrigger className="w-full md:w-[200px]">
            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4" />
              <SelectValue placeholder="Toutes les catégories" />
            </div>
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="">Toutes les catégories</SelectItem>
            {categories.map((cat) => (
              <SelectItem key={cat} value={cat}>
                {cat}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
      {renderGrid(items)}
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

      <Tabs value={tab} onValueChange={(v) => setTab(v as any)} className="space-y-6">
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

