// components/ui/error-banner.tsx
"use client"

import * as React from "react"
import { X } from "lucide-react"
import { useErrors } from "@/hooks/use-errors"
import { cn } from "@/lib/utils"

interface Props {
  id: string
  className?: string
}

/** Affiche l'erreur avec l'id donné si présente dans le store. */
export function ErrorBanner({ id, className }: Props) {
  const err = useErrors((s) => s.errors[id])
  const clear = useErrors((s) => s.clearError)

  if (!err) return null

  return (
    <div
      className={cn(
        "mx-3 my-3 rounded-md border border-red-500/40 bg-red-900/20 text-red-300",
        "px-4 py-3 text-sm relative",
        className
      )}
      role="alert"
      aria-live="polite"
    >
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <div className="font-medium">Erreur :</div>
          <div className="mt-0.5 break-words">{err.message}</div>
          {err.detailsUrl && (
            <a
              className="mt-1 inline-block text-xs underline opacity-80 hover:opacity-100"
              href={err.detailsUrl}
              target="_blank"
              rel="noreferrer"
            >
              Détails / logs
            </a>
          )}
        </div>

        <button
          className="shrink-0 rounded p-1 hover:bg-red-900/40"
          aria-label="Fermer"
          onClick={() => clear(id)}
        >
          <X className="h-4 w-4" />
        </button>
      </div>
    </div>
  )
}
