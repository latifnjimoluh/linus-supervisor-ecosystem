"use client"

import * as React from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import {
  Activity,
  Bell,
  Code,
  Edit,
  FileText,
  Key,
  LayoutDashboard,
  Map,
  Route,
  Radio,
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
  Book,
  HelpCircle,
  AlertTriangle,
} from "lucide-react"
import type { LucideIcon } from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { useLanguage } from "@/hooks/use-language"

interface AppSidebarProps {
  isOpen: boolean
  onClose?: () => void
}

interface NavChild {
  label: string
  href: string
  icon: LucideIcon
}

interface NavItem {
  label: string
  icon: LucideIcon
  href?: string
  children?: NavChild[]
}

const navItems: NavItem[] = [
  {
    label: "dashboard",
    icon: LayoutDashboard,
    children: [
      { href: "/dashboard", icon: LayoutDashboard, label: "overview" },
      { href: "/dashboard/map", icon: Map, label: "infraMap" },
      { href: "/dashboard/stats", icon: TrendingUp, label: "stats" },
    ],
  },
  {
    label: "supervision",
    icon: Activity,
    children: [
      { href: "/monitoring", icon: Activity, label: "monitoring" },
      { href: "/logs", icon: FileText, label: "logAction" },
      { href: "/logs/deployments", icon: History, label: "deployLogs" },
      { href: "/alerts", icon: Bell, label: "alerts" },
      { href: "/network/traceroute", icon: Route, label: "traceroute" },
      { href: "/network/snmp", icon: Radio, label: "snmp" },
    ],
  },
  {
    label: "deployment",
    icon: Server,
    children: [
      { href: "/deploy", icon: Server, label: "deploy" },
      { href: "/deploy/history", icon: History, label: "vmHistory" },
    ],
  },
  {
    label: "scriptsTemplates",
    icon: Code,
    children: [
      { href: "/scripts-templates", icon: FileText, label: "list" },
      { href: "/scripts", icon: FileText, label: "scripts" },
      { href: "/templates", icon: FileText, label: "templates" },
    ],
  },
  {
    label: "users",
    icon: Users,
    children: [
      { href: "/users", icon: Users, label: "usersList" },
      { href: "/users/roles", icon: Shield, label: "roles" },
      { href: "/users/permissions", icon: Key, label: "permissions" },
    ],
  },
  { label: "terminal", icon: Terminal, href: "/terminal" },
  { label: "codeEditor", icon: Edit, href: "/editor" },
  {
    label: "settings",
    icon: Settings,
    href: "/settings",
    children: [
      { href: "/settings/account", icon: User, label: "accountSettings" },
      { href: "/settings/proxmox", icon: Server, label: "proxmoxConnection" },
      { href: "/settings/templates", icon: FileText, label: "provisioningTemplates" },
      { href: "/settings/storage", icon: Server, label: "storage" },
      { href: "/settings/alerts", icon: AlertTriangle, label: "alertThresholds" },
    ],
  },
  { label: "about", icon: Info, href: "/about" },
  { label: "privacyPolicy", icon: Shield, href: "/privacy" },
  { label: "guide", icon: Book, href: "/guide" },
  { label: "help", icon: HelpCircle, href: "/help" },
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

  const { t } = useLanguage()

  const isActive = (href?: string) => !!href && pathname === href

  return (
    <>
      {/* mobile overlay */}
      <div
        className={cn(
          "fixed inset-0 z-40 bg-black/50 transition-opacity lg:hidden",
          isOpen ? "opacity-100" : "pointer-events-none opacity-0"
        )}
        onClick={onClose}
      />
      <aside
        className={cn(
          "fixed inset-y-0 left-0 z-50 flex w-64 flex-shrink-0 flex-col border-r bg-background transition-transform duration-300 lg:static lg:translate-x-0",
          isOpen ? "translate-x-0" : "-translate-x-full"
        )}
      >
        <div className="flex h-16 items-center justify-between border-b px-4">
          <Link href="/" className="flex items-center gap-2 text-lg font-semibold" onClick={onClose}>
            <span className={cn(isOpen ? "hidden" : "block", "lg:hidden")}>LS</span>
            <span className={cn(isOpen ? "block" : "hidden", "lg:block")}>LinuSupervisor</span>
          </Link>
          <Button variant="ghost" size="icon" onClick={onClose}>
            <X className="h-4 w-4" />
            <span className="sr-only">{t("closeSidebar")}</span>
          </Button>
        </div>

        <nav className="flex flex-1 flex-col gap-1 overflow-y-auto p-2">
          {navItems.map((item) => {
            const isOpenItem = openItems[item.label]

            // ========= CAS PARTICULIER: "settings" =========
            if (item.label === "settings" && item.children) {
              return (
                <div key={item.label} className="flex flex-col">
                  <div className="flex items-center justify-between gap-2 px-2">
                    {/* Lien cliquable uniquement sur le libellé + icône */}
                    <Link
                      href={item.href!}
                      className={cn(
                        "flex flex-1 items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
                        "text-muted-foreground hover:bg-accent hover:text-foreground",
                        (isActive(item.href) || item.children.some(c => c.href === pathname)) &&
                          "bg-accent text-accent-foreground"
                      )}
                      onClick={onClose}
                    >
                      <item.icon className="h-5 w-5" />
                      <span>{t(item.label)}</span>
                    </Link>

                    {/* Chevron séparé qui ne navigue pas, ouvre/ferme le sous-menu */}
                    <button
                      type="button"
                      aria-label={t("expand")}
                      onClick={() => toggleItem(item.label)}
                      className={cn(
                        "ml-1 rounded-md p-1.5 text-muted-foreground hover:bg-accent hover:text-foreground"
                      )}
                    >
                      <ChevronDown
                        className={cn(
                          "h-4 w-4 transition-transform",
                          isOpenItem && "rotate-180"
                        )}
                      />
                    </button>
                  </div>

                  {isOpenItem && (
                    <div className="ml-6 mt-1 flex flex-col gap-1">
                      {item.children.map((child) => (
                        <Link
                          key={child.href}
                          href={child.href}
                          className={cn(
                            "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:bg-accent hover:text-foreground",
                            pathname === child.href && "bg-accent text-accent-foreground"
                          )}
                          onClick={onClose}
                        >
                          <child.icon className="h-5 w-5" />
                          <span>{t(child.label)}</span>
                        </Link>
                      ))}
                    </div>
                  )}
                </div>
              )
            }

            // ========= Autres groupes avec sous-menus (comportement inchangé : clic sur la ligne pour ouvrir/fermer) =========
            if (item.children) {
              return (
                <div key={item.label} className="flex flex-col">
                  <button
                    type="button"
                    onClick={() => toggleItem(item.label)}
                    className="flex items-center justify-between gap-3 px-3 py-2 text-sm font-medium text-muted-foreground"
                    aria-expanded={isOpenItem}
                  >
                    <span className="flex items-center gap-3">
                      <item.icon className="h-5 w-5" />
                      {t(item.label)}
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
                          onClick={onClose}
                        >
                          <child.icon className="h-5 w-5" />
                          <span>{t(child.label)}</span>
                        </Link>
                      ))}
                    </div>
                  )}
                </div>
              )
            }

            // ========= Liens simples =========
            return (
              <Link
                key={item.label}
                href={item.href || "#"}
                className={cn(
                  "flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:bg-accent hover:text-foreground",
                  isActive(item.href) && "bg-accent text-accent-foreground"
                )}
                onClick={onClose}
              >
                <item.icon className="h-5 w-5" />
                <span>{t(item.label)}</span>
              </Link>
            )
          })}
        </nav>
      </aside>
    </>
  )
}
