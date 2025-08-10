"use client"

import * as React from "react"
import { listScripts, deleteScript, type Script } from "@/lib/scripts"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import Link from "next/link"

export default function ScriptsPage() {
  const [scripts, setScripts] = React.useState<Script[]>([])
  const [selected, setSelected] = React.useState<Script | null>(null)
  const [page, setPage] = React.useState(1)

  const PAGE_SIZE = 5
  const totalPages = Math.ceil(scripts.length / PAGE_SIZE)
  const paginated = scripts.slice((page - 1) * PAGE_SIZE, page * PAGE_SIZE)

  React.useEffect(() => {
    listScripts().then(setScripts).catch(() => setScripts([]))
  }, [])

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold">Scripts</h1>
        <Button asChild>
          <Link href="/scripts/generate">Créer un script</Link>
        </Button>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Liste des scripts</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nom</TableHead>
                <TableHead>Catégorie</TableHead>
                <TableHead>Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {paginated.map((s) => (
                <TableRow key={`script-${s.id}`}>
                  <TableCell>{s.name}</TableCell>
                  <TableCell>{s.category}</TableCell>
                  <TableCell className="flex gap-2">
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => setSelected(s)}
                    >
                      Voir
                    </Button>
                    <Button asChild size="sm" variant="outline">
                      <Link href={`/editor?id=${s.id}`}>Éditer</Link>
                    </Button>
                    <Button
                      size="sm"
                      variant="destructive"
                      onClick={async () => {
                        await deleteScript(s.id)
                        setScripts((prev) => prev.filter((x) => x.id !== s.id))
                      }}
                    >
                      Supprimer
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>

          {totalPages > 1 && (
            <div className="flex justify-end gap-2">
              <Button
                size="sm"
                disabled={page === 1}
                onClick={() => setPage((p) => Math.max(1, p - 1))}
              >
                Précédent
              </Button>
              <Button
                size="sm"
                disabled={page === totalPages}
                onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
              >
                Suivant
              </Button>
            </div>
          )}
        </CardContent>
      </Card>

      <Dialog open={!!selected} onOpenChange={() => setSelected(null)}>
        <DialogContent className="max-w-3xl">
          <DialogHeader>
            <DialogTitle>{selected?.name}</DialogTitle>
          </DialogHeader>
          <pre className="bg-muted p-4 rounded-md text-sm overflow-auto whitespace-pre-wrap">
            {selected?.template_content}
          </pre>
        </DialogContent>
      </Dialog>
    </div>
  )
}
