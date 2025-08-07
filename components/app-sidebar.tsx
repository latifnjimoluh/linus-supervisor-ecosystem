"use client"

import Link from "next/link"
import { usePathname } from "next/navigation"
import { Home, Server, LayoutDashboard, Users, FileText, Settings, Code, Map, Terminal, Edit, Activity, Shield, Key, X } from 'lucide-react'
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"

interface AppSidebarProps {
  isOpen: boolean
  onClose?: () => void
}

export function AppSidebar({ isOpen, onClose }: AppSidebarProps) {
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
        "fixed inset-y-0 left-0 z-40 flex w-64 flex-col border-r bg-background transition-transform duration-300",
        isOpen ? "translate-x-0" : "-translate-x-full"
      )}
    >
      <div className="flex h-16 items-center justify-between border-b px-4">
        <Link
          href="#"
          className="flex items-center gap-2 text-lg font-semibold"
        >
          LS
          <span className="sr-only">LinuSupervisor</span>
        </Link>
        <Button variant="ghost" size="icon" onClick={onClose}>
          <X className="h-4 w-4" />
          <span className="sr-only">Fermer la barre latérale</span>
        </Button>
      </div>
      <nav className="flex flex-1 flex-col gap-1 overflow-y-auto p-2">
        {navItems.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className={cn(
              "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:bg-accent hover:text-foreground",
              pathname === item.href && "bg-accent text-accent-foreground"
            )}
          >
            <item.icon className="h-5 w-5" />
            <span>{item.label}</span>
          </Link>
        ))}
      </nav>
    </aside>
  )
}
