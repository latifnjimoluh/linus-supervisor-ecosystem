"use client"

import * as React from "react"

type Kind = "info" | "success" | "warning" | "destructive"

export function InlineBanner({
  kind = "info",
  title,
  description,
  onClose,
  className = "",
}: {
  kind?: Kind
  title: string
  description?: string
  onClose?: () => void
  className?: string
}) {
  const styles: Record<Kind, string> = {
    info: "border-blue-500/30 bg-blue-500/10 text-blue-300",
    success: "border-emerald-500/30 bg-emerald-500/10 text-emerald-300",
    warning: "border-amber-500/30 bg-amber-500/10 text-amber-300",
    destructive: "border-red-500/30 bg-red-500/10 text-red-300",
  }

  return (
    <div className={`w-full rounded-xl border px-4 py-3 ${styles[kind]} ${className}`}>
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0">
          <p className="font-medium truncate">{title}</p>
          {description ? (
            <p className="text-sm/6 opacity-90 break-words">{description}</p>
          ) : null}
        </div>
        {onClose ? (
          <button
            aria-label="Fermer"
            onClick={onClose}
            className="shrink-0 px-1 rounded hover:bg-white/5 transition"
          >
            ✕
          </button>
        ) : null}
      </div>
    </div>
  )
}
