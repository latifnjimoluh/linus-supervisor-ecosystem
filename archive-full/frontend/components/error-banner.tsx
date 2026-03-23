"use client"

import Link from "next/link"
import { AlertTriangle } from "lucide-react"
import { Button } from "@/components/ui/button"
import { useErrors } from "@/hooks/use-errors"

interface Props {
  id: string
  actions?: React.ReactNode
}

export function ErrorBanner({ id, actions }: Props) {
  const { errors, clearError } = useErrors()
  const error = errors[id]
  if (!error) return null
  return (
    <div className="flex items-start gap-3 bg-destructive/10 border border-destructive text-destructive rounded-md p-3 mb-4 text-sm">
      <AlertTriangle className="h-4 w-4 mt-0.5" />
      <div className="flex-1">
        <p>{error.message}</p>
        {error.detailsUrl && (
          <Link href={error.detailsUrl} className="underline text-xs">
            Détails / logs
          </Link>
        )}
        {actions && <div className="mt-2 flex gap-2">{actions}</div>}
      </div>
      <Button size="icon" variant="ghost" className="h-4 w-4 ml-2" onClick={() => clearError(id)}>
        ×
      </Button>
    </div>
  )
}
