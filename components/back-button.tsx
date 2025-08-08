"use client"

import Link from "next/link"
import { ChevronLeft } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"

type BackButtonProps = {
  href?: string
  label?: string
  className?: string
}

export function BackButton({ href = "/dashboard", label = "Retour", className }: BackButtonProps) {
  return (
    <Button
      asChild
      variant="outline"
      size="sm"
      className={cn(
        // Make the back button visually distinct, especially in dark mode
        "gap-2 rounded-full border-blue-400/40 text-blue-600 hover:bg-blue-500/10 dark:text-blue-300",
        className
      )}
    >
      <Link href={href} aria-label={label}>
        <ChevronLeft className="h-4 w-4" />
        <span>{label}</span>
      </Link>
    </Button>
  )
}
