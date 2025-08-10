"use client"

import * as React from "react"
import { useRouter } from "next/navigation"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { FieldSchemaField, createTemplate } from "@/lib/templates"
import Link from "next/link"

export default function NewTemplatePage() {
  const router = useRouter()
  const [name, setName] = React.useState("")
  const [serviceType, setServiceType] = React.useState("")
  const [category, setCategory] = React.useState("")
  const [description, setDescription] = React.useState("")
  const [templateContent, setTemplateContent] = React.useState("")
  const [fields, setFields] = React.useState<FieldSchemaField[]>([])

  const slugify = (str: string) =>
    str
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, "-")
  const scriptPath = React.useMemo(
    () => (name ? `/scripts/${slugify(name)}.sh` : ""),
    [name]
  )

  const addField = () =>
    setFields([...fields, { name: "", label: "", type: "text", required: false }])
  const updateField = (
    index: number,
    key: keyof FieldSchemaField,
    value: any,
  ) => {
    setFields((prev) => prev.map((f, i) => (i === index ? { ...f, [key]: value } : f)))
  }
  const removeField = (index: number) => setFields((prev) => prev.filter((_, i) => i !== index))

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    const payload = {
      name,
      service_type: serviceType,
      category,
      description,
      template_content: templateContent,
      script_path: scriptPath,
      fields_schema: { fields },
    }
    await createTemplate(payload)
    router.push("/templates")
  }

  const jsonPreview = JSON.stringify(
    {
      name,
      service_type: serviceType,
      category,
      description,
      template_content: templateContent,
      script_path: scriptPath,
      fields_schema: { fields },
    },
    null,
    2
  )

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold">Nouveau template</h1>
        <Button asChild variant="outline">
          <Link href="/templates">Retour</Link>
        </Button>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Informations</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid gap-4 md:grid-cols-2">
            <div className="space-y-2">
              <Label htmlFor="name">Nom</Label>
              <Input id="name" value={name} onChange={(e) => setName(e.target.value)} required />
            </div>
            <div className="space-y-2">
              <Label htmlFor="service">Type de service</Label>
              <Input id="service" value={serviceType} onChange={(e) => setServiceType(e.target.value)} required />
            </div>
            <div className="space-y-2">
              <Label htmlFor="category">Catégorie</Label>
              <Input id="category" value={category} onChange={(e) => setCategory(e.target.value)} />
            </div>
          </div>
          <div className="space-y-2">
            <Label htmlFor="description">Description</Label>
            <Textarea id="description" value={description} onChange={(e) => setDescription(e.target.value)} />
          </div>
          <div className="space-y-2">
            <Label htmlFor="content">Contenu du template</Label>
            <Textarea
              id="content"
              value={templateContent}
              onChange={(e) => setTemplateContent(e.target.value)}
              className="h-60 font-mono"
            />
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Champs</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {fields.map((field, index) => (
            <div key={index} className="grid gap-2 md:grid-cols-5 items-end">
              <Input
                placeholder="name"
                value={field.name}
                onChange={(e) => updateField(index, "name", e.target.value)}
                required
              />
              <Input
                placeholder="label"
                value={field.label}
                onChange={(e) => updateField(index, "label", e.target.value)}
              />
              <Select
                value={field.type}
                onValueChange={(v) => updateField(index, "type", v as any)}
              >
                <SelectTrigger>
                  <SelectValue placeholder="type" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="text">text</SelectItem>
                  <SelectItem value="number">number</SelectItem>
                  <SelectItem value="boolean">boolean</SelectItem>
                  <SelectItem value="select">select</SelectItem>
                </SelectContent>
              </Select>
              <Select
                value={field.required ? "true" : "false"}
                onValueChange={(v) => updateField(index, "required", v === "true")}
              >
                <SelectTrigger>
                  <SelectValue placeholder="requis" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="true">requis</SelectItem>
                  <SelectItem value="false">optionnel</SelectItem>
                </SelectContent>
              </Select>
              <Input
                placeholder="default"
                value={field.default?.toString() || ""}
                onChange={(e) => updateField(index, "default", e.target.value)}
              />
              <Button type="button" variant="destructive" onClick={() => removeField(index)}>Supprimer</Button>
            </div>
          ))}
          <Button type="button" onClick={addField}>Ajouter un champ</Button>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Aperçu JSON</CardTitle>
        </CardHeader>
        <CardContent>
          <pre className="bg-muted p-4 rounded-md text-xs overflow-x-auto">{jsonPreview}</pre>
        </CardContent>
      </Card>

      <Button type="submit">Enregistrer</Button>
    </form>
  )
}
