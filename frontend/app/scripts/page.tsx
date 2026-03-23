import ScriptsTemplatesBrowser from "@/components/scripts-templates-browser"

export default function ScriptsPage({
  searchParams,
}: {
  searchParams: { highlight?: string }
}) {
  const id = searchParams.highlight ? Number(searchParams.highlight) : undefined
  return (
    <ScriptsTemplatesBrowser
      defaultTab="scripts"
      highlightId={id}
      highlightType="script"
    />
  )
}

