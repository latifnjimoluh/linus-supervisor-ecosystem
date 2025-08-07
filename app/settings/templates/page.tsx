"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { MoreHorizontal, Pencil, PlusCircle, Trash2 } from 'lucide-react'
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuTrigger } from "@/components/ui/dropdown-menu"

const templates = [
  {
    name: "ubuntu-22.04-cloudinit",
    os: "Linux",
    cpu: 2,
    ram: 2,
    disk: 20,
    description: "Template Ubuntu Server 22.04 LTS avec Cloud-Init.",
  },
  {
    name: "debian-11-base",
    os: "Linux",
    cpu: 1,
    ram: 1,
    disk: 10,
    description: "Template Debian 11 minimal.",
  },
  {
    name: "windows-server-2019",
    os: "Windows",
    cpu: 4,
    ram: 8,
    disk: 40,
    description: "Template Windows Server 2019 Standard.",
  },
]

export default function TemplatesSettingsPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Gestion des Templates</h1>
          <p className="text-muted-foreground">
            Ajoutez, modifiez ou supprimez les templates de déploiement.
          </p>
        </div>
        <Button>
          <PlusCircle className="mr-2 h-4 w-4" /> Ajouter un Template
        </Button>
      </div>
      <Card>
        <CardContent className="pt-6">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Nom</TableHead>
                <TableHead className="hidden md:table-cell">OS</TableHead>
                <TableHead className="hidden md:table-cell">CPU</TableHead>
                <TableHead className="hidden md:table-cell">RAM (Go)</TableHead>
                <TableHead className="hidden md:table-cell">Disque (Go)</TableHead>
                <TableHead>Description</TableHead>
                <TableHead>
                  <span className="sr-only">Actions</span>
                </TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {templates.map((template) => (
                <TableRow key={template.name}>
                  <TableCell className="font-medium">{template.name}</TableCell>
                  <TableCell className="hidden md:table-cell">{template.os}</TableCell>
                  <TableCell className="hidden md:table-cell">{template.cpu}</TableCell>
                  <TableCell className="hidden md:table-cell">{template.ram}</TableCell>
                  <TableCell className="hidden md:table-cell">{template.disk}</TableCell>
                  <TableCell>{template.description}</TableCell>
                  <TableCell>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button aria-haspopup="true" size="icon" variant="ghost">
                          <MoreHorizontal className="h-4 w-4" />
                          <span className="sr-only">Toggle menu</span>
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuLabel>Actions</DropdownMenuLabel>
                        <DropdownMenuItem>
                          <Pencil className="mr-2 h-4 w-4" />
                          Modifier
                        </DropdownMenuItem>
                        <DropdownMenuItem className="text-destructive">
                          <Trash2 className="mr-2 h-4 w-4" />
                          Supprimer
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
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
