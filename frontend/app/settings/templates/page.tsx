"use client"

import * as React from "react"
import Link from "next/link"
import { Plus, MoreHorizontal } from 'lucide-react'
import { BackButton } from "@/components/back-button"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { listTemplates, type Template } from "@/services/api"
import { useToast } from "@/hooks/use-toast"

export default function SettingsTemplatesPage() {
  const [rows, setRows] = React.useState<Template[]>([])
  const { toast } = useToast()

  React.useEffect(() => {
    listTemplates()
      .then(setRows)
      .catch(() => {
        toast({
          title: "Erreur",
          description: "Impossible de charger les templates",
          variant: "destructive",
        })
        setRows([])
      })
  }, [toast])

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
          <Link href="/templates?new=1">
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
                  <TableCell className="capitalize">{t.type || "template"}</TableCell>
                  <TableCell className="text-muted-foreground">{t.description}</TableCell>
                  <TableCell className="text-right">
                    <Button variant="ghost" size="icon" aria-label={`Actions pour ${t.name}`}>
                      <MoreHorizontal className="h-4 w-4" />
                    </Button>
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
    </div>
  )
}
