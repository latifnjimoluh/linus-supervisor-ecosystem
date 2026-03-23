import ScriptsTemplatesBrowser from "@/components/scripts-templates-browser"

export default function TemplatesPage({
  searchParams,
}: {
  searchParams: { highlight?: string }
}) {
  const id = searchParams.highlight ? Number(searchParams.highlight) : undefined
  return (
    <ScriptsTemplatesBrowser
      defaultTab="templates"
      highlightId={id}
      highlightType="template"
    />
  )
}

