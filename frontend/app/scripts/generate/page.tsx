"use client"

import * as React from "react"
import { listTemplates, Template, generateScript } from "@/lib/templates"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Textarea } from "@/components/ui/textarea"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import Link from "next/link"

export default function GenerateScriptPage({
  searchParams,
}: {
  searchParams: { template?: string }
}) {
  const params = React.use(searchParams)
  const [templates, setTemplates] = React.useState<Template[]>([])
  const [templateId, setTemplateId] = React.useState<number | null>(null)
  const [formData, setFormData] = React.useState<Record<string, string>>({})
  const [result, setResult] = React.useState("")

  React.useEffect(() => {
    listTemplates().then((t) => {
      setTemplates(t)
      const initial = params?.template
      if (initial) setTemplateId(Number(initial))
    })
  }, [params])

  const selected = templates.find((t) => t.id === templateId)

  React.useEffect(() => {
    if (selected?.fields_schema?.fields) {
      const initial: Record<string, string> = {}
      selected.fields_schema.fields.forEach((f) => {
        if (f.default !== undefined) initial[f.name] = String(f.default)
      })
      setFormData(initial)
    }
  }, [selected])

  const handleChange = (name: string, value: string) => {
    setFormData((prev) => ({ ...prev, [name]: value }))
  }

  const handleGenerate = async () => {
    if (!templateId) return
    const res = await generateScript(templateId, formData)
    setResult(res.script)
  }

  const jsonPreview = JSON.stringify(
    { template_id: templateId, config_data: formData },
    null,
    2
  )

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-3xl font-bold">Générer un script</h1>
        <Button asChild variant="outline">
          <Link href="/scripts">Retour</Link>
        </Button>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Template</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <Select value={templateId ? String(templateId) : ""} onValueChange={(v) => setTemplateId(Number(v))}>
            <SelectTrigger>
              <SelectValue placeholder="Sélectionner un template" />
            </SelectTrigger>
            <SelectContent>
              {templates.map((t) => (
                <SelectItem key={t.id} value={String(t.id)}>
                  {t.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          {selected?.fields_schema?.fields && (
            <div className="space-y-4">
              {selected.fields_schema.fields.map((field) => (
                <div key={field.name} className="space-y-2">
                  <label className="text-sm font-medium" htmlFor={field.name}>
                    {field.label}
                  </label>
                  <Input
                    id={field.name}
                    value={formData[field.name] || ""}
                    onChange={(e) => handleChange(field.name, e.target.value)}
                  />
                </div>
              ))}
              <Button type="button" onClick={handleGenerate}>
                Générer
              </Button>
              <pre className="bg-muted p-4 rounded-md text-xs overflow-x-auto">
                {jsonPreview}
              </pre>
            </div>
          )}

          {result && (
            <Textarea value={result} readOnly className="mt-4 h-60" />
          )}
        </CardContent>
      </Card>
    </div>
  )
}
