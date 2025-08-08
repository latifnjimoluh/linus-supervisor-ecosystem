"use client"

import * as React from "react"
import { Search, Plus, Code, Sparkles, Filter, Copy, Check, Edit } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"
import Link from "next/link"

import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs"
import { useToast } from "@/hooks/use-toast"
import { listTemplates, type Template } from "@/services/api"

export default function TemplatesPage() {
  const [searchTerm, setSearchTerm] = React.useState("")
  const [selectedTemplate, setSelectedTemplate] = React.useState<Template | null>(null)
  const [copied, setCopied] = React.useState(false)
  const [templates, setTemplates] = React.useState<Template[]>([])
  const { toast } = useToast()

  React.useEffect(() => {
    listTemplates()
      .then((data) => setTemplates(data.data || data || []))
      .catch(() => setTemplates([]))
  }, [])

  const filtered = templates.filter(
    (t) =>
      t.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      t.description.toLowerCase().includes(searchTerm.toLowerCase())
  )
  const filteredScripts = filtered.filter((t) => t.type === "script")
  const filteredTemplateList = filtered.filter((t) => t.type === "template")

  const copyContent = (content: string) => {
    navigator.clipboard.writeText(content)
    setCopied(true)
    toast({ title: "Copié !", description: "Le contenu du script a été copié.", variant: "success" })
    setTimeout(() => setCopied(false), 1500)
  }

  const renderGrid = (items: Template[]) => (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <AnimatePresence>
        {items.map((template) => (
          <motion.div
            key={template.id}
            layout
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.95 }}
          >
            <Card className="h-full flex flex-col hover:shadow-lg transition-shadow rounded-2xl">
              <CardHeader>
                <CardTitle className="text-lg">{template.name}</CardTitle>
                <div className="flex flex-wrap gap-2 pt-2">
                  <Badge variant="secondary">{template.category}</Badge>
                  <Badge variant={template.type === "template" ? "default" : "outline"}>
                    {template.type === "template" ? "Paramétrable" : "Script simple"}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent className="flex-1">
                <p className="text-sm text-muted-foreground">{template.description}</p>
              </CardContent>
              <div className="p-4 border-t flex flex-wrap gap-2">
                <Dialog>
                  <DialogTrigger asChild>
                    <Button variant="secondary" size="sm" onClick={() => setSelectedTemplate(template)}>
                      <Code className="mr-2 h-4 w-4" /> Voir le code
                    </Button>
                  </DialogTrigger>
                  {selectedTemplate && (
                    <DialogContent className="max-w-3xl">
                      <DialogHeader>
                        <DialogTitle>{selectedTemplate.name}</DialogTitle>
                        <DialogDescription>Aperçu du contenu du template et de ses champs.</DialogDescription>
                      </DialogHeader>
                      <div className="relative bg-muted rounded-lg p-4 mt-4">
                        <Button
                          size="sm"
                          variant="ghost"
                          className="absolute top-2 right-2 h-7 w-7 p-0"
                          onClick={() => copyContent(selectedTemplate.template_content)}
                          aria-label="Copier"
                        >
                          {copied ? <Check className="h-4 w-4 text-green-500" /> : <Copy className="h-4 w-4" />}
                        </Button>
                        <pre className="text-sm whitespace-pre-wrap overflow-auto max-h-[60vh] break-words break-all">
                          <code className="font-mono">{selectedTemplate.template_content}</code>
                        </pre>
                      </div>
                      {selectedTemplate.fields_schema && (
                        <div className="mt-4">
                          <h3 className="font-semibold mb-2">Champs de configuration :</h3>
                          <ul className="list-disc pl-5 text-sm text-muted-foreground">
                            {selectedTemplate.fields_schema.fields.map((field, index) => (
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
                  <Link href={`/editor?id=${template.id}`}>
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

  const renderSection = (items: Template[]) => (
    <Card>
      <CardHeader>
        <div className="flex flex-col md:flex-row gap-4">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Rechercher un script..."
              className="pl-10"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>
          <Button variant="outline">
            <Filter className="mr-2 h-4 w-4" /> Filtrer par catégorie
          </Button>
        </div>
      </CardHeader>
      <CardContent>
        {renderGrid(items)}
        {items.length === 0 && (
          <div className="text-center py-12 text-muted-foreground">
            <p>Aucun script ou template ne correspond à votre recherche.</p>
          </div>
        )}
      </CardContent>
    </Card>
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
        <Button className="w-full md:w-auto bg-blue-600 hover:bg-blue-700 text-white">
          <Plus className="mr-2 h-4 w-4" /> Créer un nouveau template
        </Button>
      </header>

      <Tabs defaultValue="templates" className="space-y-6">
        <TabsList className="w-full md:w-auto">
          <TabsTrigger value="scripts">Scripts</TabsTrigger>
          <TabsTrigger value="templates">Templates</TabsTrigger>
        </TabsList>
        <TabsContent value="scripts">{renderSection(filteredScripts)}</TabsContent>
        <TabsContent value="templates">{renderSection(filteredTemplateList)}</TabsContent>
      </Tabs>
    </div>
  )
}
