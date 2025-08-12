"use client"

import * as React from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import {
  Activity,
  Code,
  Edit,
  FileText,
  Key,
  LayoutDashboard,
  Map,
  Server,
  Settings,
  Shield,
  Terminal,
  Users,
  X,
  ChevronDown,
  User,
  History,
  TrendingUp,
  Info,
  HelpCircle,
} from "lucide-react"
import type { LucideIcon } from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"

interface AppSidebarProps {
  isOpen: boolean
  onClose?: () => void
}

interface NavItem {
  label: string
  icon: LucideIcon
  href?: string
  children?: { label: string; href: string; icon: LucideIcon }[]
}

const navItems: NavItem[] = [
  {
    label: "Tableau de bord",
    icon: LayoutDashboard,
    children: [
      { href: "/dashboard", icon: LayoutDashboard, label: "Vue d'ensemble" },
      { href: "/dashboard/map", icon: Map, label: "Carte Infra" },
      { href: "/dashboard/stats", icon: TrendingUp, label: "Statistiques" },
    ],
  },
  {
    label: "Supervision",
    icon: Activity,
    children: [{ href: "/monitoring", icon: Activity, label: "Monitoring" }],
  },
  {
    label: "Déploiement",
    icon: Server,
    children: [
      { href: "/deploy", icon: Server, label: "Déployer" },
      { href: "/deploy/history", icon: History, label: "Historique des VM" },
    ],
  },
  {
    label: "Scripts & Templates",
    icon: Code,
    children: [
      { href: "/scripts-templates", icon: FileText, label: "Liste" },
      { href: "/scripts", icon: FileText, label: "Scripts" },
      { href: "/templates", icon: FileText, label: "Templates" },
    ],
  },
  {
    label: "Utilisateurs",
    icon: Users,
    children: [
      { href: "/users", icon: Users, label: "Utilisateurs" },
      { href: "/users/roles", icon: Shield, label: "Rôles" },
      { href: "/users/permissions", icon: Key, label: "Permissions" },
    ],
  },
  {
    label: "Logs",
    icon: FileText,
    children: [{ href: "/logs", icon: FileText, label: "Logs" }],
  },
  { label: "Terminal", icon: Terminal, href: "/terminal" },
  {
    label: "Éditeur de code",
    icon: Edit,
    href: "/editor",
  },
  {
    label: "Paramètres",
    icon: Settings,
    children: [
      { href: "/settings/account", icon: User, label: "Paramètres du Compte" },
      { href: "/settings/proxmox", icon: Server, label: "Connexion Proxmox" },
      { href: "/settings/templates", icon: FileText, label: "Templates de Provisionnement" },
    ],
  },
  { label: "À propos", icon: Info, href: "/about" },
  { label: "Politique de confidentialité", icon: Shield, href: "/privacy" },
  { label: "Aide", icon: HelpCircle, href: "/help" },
]
export function AppSidebar({ isOpen, onClose }: AppSidebarProps) {
  const pathname = usePathname()
  const [openItems, setOpenItems] = React.useState<Record<string, boolean>>(() => {
    const initial: Record<string, boolean> = {}
    navItems.forEach((item) => {
      if (item.children?.some((child) => child.href === pathname)) {
        initial[item.label] = true
      }
    })
    return initial
  })

  const toggleItem = (label: string) =>
    setOpenItems((prev) => ({ ...prev, [label]: !prev[label] }))

  return (
    <aside
      className={cn(
        "flex h-full flex-shrink-0 flex-col border-r bg-background transition-all duration-300",
        isOpen ? "w-64" : "w-0"
      )}
    >
      <div className="flex h-16 items-center justify-between border-b px-4">
        <Link href="/" className="flex items-center gap-2 text-lg font-semibold">
          LS
          <span className="sr-only">LinuSupervisor</span>
        </Link>
        <Button variant="ghost" size="icon" onClick={onClose}>
          <X className="h-4 w-4" />
          <span className="sr-only">Fermer la barre latérale</span>
        </Button>
      </div>
      <nav className="flex flex-1 flex-col gap-1 overflow-y-auto p-2">
        {navItems.map((item) => {
          const isOpenItem = openItems[item.label]
          if (item.children) {
            return (
              <div key={item.label} className="flex flex-col">
                <button
                  type="button"
                  onClick={() => toggleItem(item.label)}
                  className="flex items-center justify-between gap-3 px-3 py-2 text-sm font-medium text-muted-foreground"
                >
                  <span className="flex items-center gap-3">
                    <item.icon className="h-5 w-5" />
                    {item.label}
                  </span>
                  <ChevronDown
                    className={cn(
                      "h-4 w-4 transition-transform",
                      isOpenItem && "rotate-180"
                    )}
                  />
                </button>
                {isOpenItem && (
                  <div className="ml-6 flex flex-col gap-1">
                    {item.children.map((child) => (
                      <Link
                        key={child.href}
                        href={child.href}
                        className={cn(
                          "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:bg-accent hover:text-foreground",
                          pathname === child.href && "bg-accent text-accent-foreground"
                        )}
                      >
                        <child.icon className="h-5 w-5" />
                        <span>{child.label}</span>
                      </Link>
                    ))}
                  </div>
                )}
              </div>
            )
          }
          return (
            <Link
              key={item.label}
              href={item.href || "#"}
              className={cn(
                "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:bg-accent hover:text-foreground",
                pathname === item.href && "bg-accent text-accent-foreground"
              )}
            >
              <item.icon className="h-5 w-5" />
              <span>{item.label}</span>
            </Link>
          )
        })}
      </nav>
    </aside>
  )
}

