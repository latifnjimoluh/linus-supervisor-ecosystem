"use client"

import Link from "next/link"
import { ChevronLeft } from 'lucide-react'
import { Button } from "@/components/ui/button"
import { cn } from "@/lib/utils"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"

type BackButtonProps = {
  href?: string
  label?: string
  className?: string
}

export function BackButton({ href = "/dashboard", label = "Retour", className }: BackButtonProps) {
  return (
    <TooltipProvider>
      <Tooltip>
        <TooltipTrigger asChild>
          <Button
            asChild
            variant="outline"
            className={cn(
              "rounded-xl h-10 w-10 md:w-auto md:px-4",
              className
            )}
          >
            <Link href={href} aria-label={label} className="flex items-center justify-center md:gap-2">
              <ChevronLeft className="h-4 w-4 md:mr-2" />
              <span className="hidden md:inline whitespace-nowrap">{label}</span>
            </Link>
          </Button>
        </TooltipTrigger>
        <TooltipContent>{label}</TooltipContent>
      </Tooltip>
    </TooltipProvider>
  )
}
