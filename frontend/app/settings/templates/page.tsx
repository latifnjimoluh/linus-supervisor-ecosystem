"use client"

import * as React from "react"
import Link from "next/link"
import {
  Plus,
  MoreHorizontal,
  Code,
  Edit,
  Trash,
  Copy,
  Check,
} from "lucide-react"
import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
  DropdownMenuSeparator,
} from "@/components/ui/dropdown-menu"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { useToast } from "@/hooks/use-toast"
import { listTemplates, deleteTemplate, type Template } from "@/lib/templates"

export default function SettingsTemplatesPage() {
  const [rows, setRows] = React.useState<Template[]>([])
  const [selectedTemplate, setSelectedTemplate] = React.useState<Template | null>(null)
  const [copied, setCopied] = React.useState(false)
  const { toast } = useToast()

  React.useEffect(() => {
    listTemplates().then(setRows).catch(() => setRows([]))
  }, [])

  const copyContent = (content: string) => {
    navigator.clipboard.writeText(content)
    setCopied(true)
    toast({ title: "Copié !", description: "Le contenu du template a été copié.", variant: "success" })
    setTimeout(() => setCopied(false), 1500)
  }

  const handleDelete = async (id: number) => {
    try {
      await deleteTemplate(id)
      setRows((prev) => prev.filter((t) => t.id !== id))
      toast({ title: "Supprimé", description: "Le template a été supprimé.", variant: "success" })
    } catch (e) {
      toast({ title: "Erreur", description: "La suppression a échoué.", variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <BackButton href="/settings" label="Retour" />
          <div>
            <h1 className="text-3xl font-bold tracking-tight">Gestion des Templates</h1>
            <p className="text-muted-foreground">
              Ajoutez, modifiez ou supprimez les templates de déploiement.
            </p>
          </div>
        </div>
        <Button asChild className="bg-blue-600 hover:bg-blue-700 text-white">
          <Link href="/templates/new">
            <Plus className="mr-2 h-4 w-4" />
            Ajouter un Template
          </Link>
        </Button>
      </div>

      <Card>
        <CardContent className="p-0">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nom</TableHead>
                <TableHead>Catégorie</TableHead>
                <TableHead>Type</TableHead>
                <TableHead>Description</TableHead>
                <TableHead className="w-12 text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {rows.map((t) => (
                <TableRow key={t.id}>
                  <TableCell className="font-medium">{t.name}</TableCell>
                  <TableCell>{t.category}</TableCell>
                  <TableCell className="capitalize">{t.type}</TableCell>
                  <TableCell className="text-muted-foreground">{t.description}</TableCell>
                  <TableCell className="text-right">
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button variant="ghost" size="icon" aria-label={`Actions pour ${t.name}`}>
                          <MoreHorizontal className="h-4 w-4" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => setSelectedTemplate(t)}>
                          <Code className="mr-2 h-4 w-4" /> Voir
                        </DropdownMenuItem>
                        <DropdownMenuItem asChild>
                          <Link href={`/editor?id=${t.id}`}>
                            <Edit className="mr-2 h-4 w-4" /> Éditer
                          </Link>
                        </DropdownMenuItem>
                        <DropdownMenuSeparator />
                        <DropdownMenuItem
                          onClick={() => handleDelete(t.id)}
                          className="text-destructive focus:text-destructive"
                        >
                          <Trash className="mr-2 h-4 w-4" /> Supprimer
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </TableCell>
                </TableRow>
              ))}
              {rows.length === 0 && (
                <TableRow>
                  <TableCell colSpan={5} className="text-center text-muted-foreground py-8">
                    Aucun template trouvé.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
      {selectedTemplate && (
        <Dialog open={!!selectedTemplate} onOpenChange={(open) => !open && setSelectedTemplate(null)}>
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
        </Dialog>
      )}
    </div>
  )
}
