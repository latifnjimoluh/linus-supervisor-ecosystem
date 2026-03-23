"use client"

import * as React from "react"
import { listTemplates, Template, generateScript } from "@/lib/templates"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Textarea } from "@/components/ui/textarea"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import Link from "next/link"
import dynamic from "next/dynamic"
import { useTheme } from "next-themes"
import { useRouter } from "next/navigation"
import { useToast } from "@/hooks/use-toast"
import { ToastAction } from "@/components/ui/toast"

const MonacoEditor = dynamic(() => import("@monaco-editor/react"), { ssr: false })

export default function GenerateScriptPage({
  searchParams,
}: {
  searchParams: { template?: string }
}) {
  const params = React.use(searchParams)
  const { theme } = useTheme()
  const router = useRouter()
  const { toast } = useToast()
  const [templates, setTemplates] = React.useState<Template[]>([])
  const [templateId, setTemplateId] = React.useState<number | null>(null)
  const [formData, setFormData] = React.useState<Record<string, string>>({})
  const [result, setResult] = React.useState("")
  const redirectTimeout = React.useRef<NodeJS.Timeout | null>(null)

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
    const detailUrl = `/editor?id=${res.id}&tab=scripts`
    const listUrl = `/scripts?highlight=${res.id}`
    redirectTimeout.current = setTimeout(() => {
      router.push(listUrl)
    }, 2500)
    toast({
      title: "Génération effectuée avec succès.",
      duration: 3000,
      action: (
        <ToastAction
          altText="Voir le détail maintenant"
          onClick={() => {
            if (redirectTimeout.current) clearTimeout(redirectTimeout.current)
            router.push(detailUrl)
          }}
        >
          Voir le détail maintenant
        </ToastAction>
      ),
    })
  }

  React.useEffect(() => {
    return () => {
      if (redirectTimeout.current) clearTimeout(redirectTimeout.current)
    }
  }, [])

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
              <div className="rounded-md border overflow-hidden">
                <MonacoEditor
                  value={jsonPreview}
                  language="json"
                  theme={theme === "dark" ? "vs-dark" : "vs-light"}
                  height="200px"
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
          )}

          {result && (
            <Textarea value={result} readOnly className="mt-4 h-60" />
          )}
        </CardContent>
      </Card>
    </div>
  )
}
