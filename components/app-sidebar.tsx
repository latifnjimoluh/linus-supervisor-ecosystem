"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import { Home, Server, LayoutDashboard, Users, FileText, Settings, Code, Map, Terminal, Edit, Activity, Shield, Key } from 'lucide-react'
import { cn } from "@/lib/utils"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"

interface AppSidebarProps {
  isOpen: boolean
  onClose?: () => void
}

export function AppSidebar({ isOpen }: AppSidebarProps) {
  const pathname = usePathname()

  const navItems = [
    { href: "/dashboard", icon: LayoutDashboard, label: "Tableau de bord" },
    { href: "/dashboard/map", icon: Map, label: "Carte Infra" }, // Added new link
    { href: "/monitoring", icon: Activity, label: "Supervision" },
    { href: "/deploy", icon: Server, label: "Déploiement" },
    { href: "/templates", icon: Code, label: "Scripts & Templates" },
    { href: "/users", icon: Users, label: "Utilisateurs" },
    { href: "/users/roles", icon: Shield, label: "Rôles" },
    { href: "/users/permissions", icon: Key, label: "Permissions" },
    { href: "/logs", icon: FileText, label: "Logs" },
    { href: "/terminal", icon: Terminal, label: "Terminal" },
    { href: "/editor", icon: Edit, label: "Éditeur de code" },
    { href: "/settings", icon: Settings, label: "Paramètres" },
  ]

  return (
    <aside
      className={cn(
        "fixed inset-y-0 left-0 z-40 w-16 flex-col border-r bg-background transition-transform duration-300",
        isOpen ? "translate-x-0" : "-translate-x-full"
      )}
    >
      <nav className="flex flex-col items-center gap-4 px-2 py-5">
        <Link
          href="#"
          className="group flex h-9 w-9 shrink-0 items-center justify-center gap-2 rounded-full bg-primary text-lg font-semibold text-primary-foreground md:h-8 md:w-8 md:text-base"
        >
          LS
          <span className="sr-only">LinuSupervisor</span>
        </Link>
        <TooltipProvider>
          {navItems.map((item) => (
            <Tooltip key={item.href}>
              <TooltipTrigger asChild>
                <Link
                  href={item.href}
                  className={cn(
                    "flex h-9 w-9 items-center justify-center rounded-lg text-muted-foreground transition-colors hover:text-foreground md:h-8 md:w-8",
                    pathname === item.href && "bg-accent text-accent-foreground"
                  )}
                >
                  <item.icon className="h-5 w-5" />
                  <span className="sr-only">{item.label}</span>
                </Link>
              </TooltipTrigger>
              <TooltipContent side="right">{item.label}</TooltipContent>
            </Tooltip>
          ))}
        </TooltipProvider>
      </nav>
    </aside>
  )
}
