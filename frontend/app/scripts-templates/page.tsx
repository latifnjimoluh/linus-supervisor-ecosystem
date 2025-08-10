"use client"

import * as React from "react"
import Link from "next/link"
import {
  fetchTemplatesAndScripts,
  type Template,
} from "@/lib/templates"
import type { Script } from "@/lib/scripts"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Button } from "@/components/ui/button"

export default function ScriptsTemplatesPage() {
  const [items, setItems] = React.useState<(Template | Script)[]>([])

  React.useEffect(() => {
    fetchTemplatesAndScripts()
      .then(({ scripts, templates }) => setItems([...scripts, ...templates]))
      .catch(() => setItems([]))
  }, [])

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">Scripts & Templates</h1>
      <Card>
        <CardHeader>
          <CardTitle>Liste</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Type</TableHead>
                <TableHead>Nom</TableHead>
                <TableHead>Catégorie</TableHead>
                <TableHead>Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {items.map((item) => (
                <TableRow key={`${item.type}-${item.id}`}>
                  <TableCell className="capitalize">{item.type}</TableCell>
                  <TableCell>{item.name}</TableCell>
                  <TableCell>{item.category}</TableCell>
                  <TableCell className="flex gap-2">
                    {item.type === "template" && (
                      <Button asChild size="sm">
                        <Link href={`/scripts/generate?template=${item.id}`}>Générer</Link>
                      </Button>
                    )}
                    <Button asChild size="sm" variant="outline">
                      <Link href={`/editor?id=${item.id}`}>Éditer</Link>
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}
