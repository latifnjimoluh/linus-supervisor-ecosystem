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
      className={cn(
        "gap-2 rounded-xl h-9 sm:h-10 px-3.5 sm:px-4",
        className
      )}
    >
      <Link href={href} aria-label={label}>
        <ChevronLeft className="h-4 w-4" />
        <span className="whitespace-nowrap">{label}</span>
      </Link>
    </Button>
  )
}
