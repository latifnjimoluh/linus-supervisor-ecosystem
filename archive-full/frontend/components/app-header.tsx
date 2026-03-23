"use client"

import * as React from "react"
import Link from "next/link"
import { Button } from "@/components/ui/button"
import { DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuItem } from "@/components/ui/dropdown-menu"
import { ModeToggle } from "@/components/mode-toggle"
import { LanguageSwitcher } from "@/components/language-switcher"
import { Menu, Bell, User, Settings, LogOut, HelpCircle } from 'lucide-react'
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { fetchDeployment, fetchLastDeployment } from "@/services/deployments"
import { getAuthToken, refreshAuthToken, logoutUser } from "@/services/api"
import { listAlerts } from "@/services/alerts"
import { getStatusBadge } from "@/components/status-badge"
import { useErrors } from "@/hooks/use-errors"
import { ErrorBanner } from "./error-banner"
import { useLanguage } from "@/hooks/use-language"

interface AppHeaderProps {
  title?: string
  onToggleSidebar?: () => void
}

export function AppHeader({ title, onToggleSidebar }: AppHeaderProps) {
  const { t } = useLanguage()
  const [last, setLast] = React.useState<null | { instance_id: string; status: string; updatedAt: number }>(null)
  const esRef = React.useRef<EventSource | null>(null)
  const retryRef = React.useRef(false)
  const { setError } = useErrors()
  const [alertCount, setAlertCount] = React.useState(0)

  const loadAlertsCount = React.useCallback(async () => {
    try {
      const res = await listAlerts()
      const count = res.data.filter(a => a.status !== "acknowledged").length
      setAlertCount(count)
    } catch (e) {
      console.error("Failed to fetch alerts", e)
    }
  }, [])

  React.useEffect(() => {
    loadAlertsCount()
    const interval = setInterval(loadAlertsCount, 30000)
    return () => clearInterval(interval)
  }, [loadAlertsCount])

  const subscribe = React.useCallback(async (id: string) => {
    if (esRef.current) esRef.current.close()
    const baseUrl = process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000"

    let token = getAuthToken()
    if (!token) {
      token = await refreshAuthToken()
    }
    if (!token) {
      setError('session', { message: "Session expirée", detailsUrl: "/login" })
      logoutUser("Session expirée")
      return
    }

    const es = new EventSource(`${baseUrl}/deployments/${id}/stream?access_token=${encodeURIComponent(token)}`)
    es.onopen = () => {
      retryRef.current = false
    }
    es.addEventListener("status", (e: MessageEvent) => {
      const { status } = JSON.parse(e.data)
      setLast({ instance_id: id, status, updatedAt: Date.now() })
    })
    es.onerror = async () => {
      es.close()
      if (!retryRef.current) {
        retryRef.current = true
        const newToken = await refreshAuthToken()
        if (newToken) {
          subscribe(id)
        } else {
          setError('session', { message: "Session expirée", detailsUrl: "/login" })
          logoutUser("Session expirée")
        }
      }
    }
    esRef.current = es
  }, [setError])

  React.useEffect(() => {
    const load = async () => {
      try {
        const id = typeof window !== "undefined" ? localStorage.getItem("last_instance_id") : null
        if (id) {
          const dep = await fetchDeployment(id)
          setLast({ instance_id: id, status: dep.status, updatedAt: Date.now() })
          subscribe(id)
        } else {
          const dep = await fetchLastDeployment()
          localStorage.setItem("last_instance_id", dep.instance_id)
          setLast({ instance_id: dep.instance_id, status: dep.status, updatedAt: Date.now() })
          subscribe(dep.instance_id)
        }
      } catch (e) {
        console.error("No last deployment", e)
      }
    }
    load()

    const onStorage = (e: StorageEvent) => {
      if (e.key === "last_instance_id" && e.newValue) {
        fetchDeployment(e.newValue)
          .then((dep) => {
            setLast({ instance_id: e.newValue as string, status: dep.status, updatedAt: Date.now() })
            subscribe(e.newValue as string)
          })
          .catch(() => {})
      }
    }
    window.addEventListener("storage", onStorage)
    return () => {
      window.removeEventListener("storage", onStorage)
      esRef.current?.close()
    }
  }, [subscribe])


  const handleLogout = () => {
    logoutUser("Déconnecté")
  }

  return (
    <>
      <header className="sticky top-0 z-40 w-full border-b bg-background">
        <div className="mx-auto flex h-16 w-full max-w-[1440px] items-center gap-4 px-3 sm:px-4 md:px-6">
        <Button
          variant="outline"
          size="icon"
          className="shrink-0"
          onClick={onToggleSidebar}
        >
          <Menu className="h-5 w-5 sm:h-6 sm:w-6" />
          <span className="sr-only">{t("toggleSidebar")}</span>
        </Button>
        <Link href="/" className="ml-2 font-semibold sm:text-lg">
          LinuSupervisor
        </Link>
        {title && <h1 className="ml-4 text-base font-medium sm:text-lg">{title}</h1>}
        <div className="flex-1" />
        {last && (
          <Link href={`/deployments/${last.instance_id}`}>
            <Button
              variant="outline"
              className="rounded-xl h-9 sm:h-10 px-3.5 sm:px-4 flex items-center gap-2"
            >
              Reprendre dernier déploiement
              {getStatusBadge(last.status)}
            </Button>
          </Link>
        )}
        <Link href="/help#search">
          <Button variant="ghost" size="icon" className="rounded-full">
            <HelpCircle className="h-5 w-5 sm:h-6 sm:w-6" />
            <span className="sr-only">{t("needHelp")}</span>
          </Button>
        </Link>
        <Link href="/alerts">
          <Button variant="ghost" size="icon" className="relative rounded-full">
            <Bell className="h-5 w-5 sm:h-6 sm:w-6" />
            {alertCount > 0 && (
              <span className="absolute -right-1 -top-1 flex h-4 w-4 items-center justify-center rounded-full bg-destructive text-[10px] text-white">
                {alertCount}
              </span>
            )}
            <span className="sr-only">{t("notifications")}</span>
          </Button>
        </Link>
        <LanguageSwitcher />
        <ModeToggle />
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="relative h-9 w-9 rounded-full">
              <Avatar className="h-9 w-9">
                <AvatarImage src="/placeholder-user.jpg" alt="User Avatar" />
                <AvatarFallback>LS</AvatarFallback>
              </Avatar>
            <span className="sr-only">Toggle user menu</span>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>{t("myAccount")}</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem asChild>
              <Link href="/profile" className="flex items-center">
                <User className="mr-2 h-4 w-4" /> {t("profile")}
              </Link>
            </DropdownMenuItem>
            <DropdownMenuItem asChild>
              <Link href="/settings" className="flex items-center">
                <Settings className="mr-2 h-4 w-4" /> {t("settings")}
              </Link>
            </DropdownMenuItem>
            <DropdownMenuItem asChild>
              <Link href="/help" className="flex items-center">
                <HelpCircle className="mr-2 h-4 w-4" /> {t("help")}
              </Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={handleLogout} className="flex items-center text-destructive focus:text-destructive">
              <LogOut className="mr-2 h-4 w-4" /> {t("logout")}
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
      </header>
      <ErrorBanner id="session" />
    </>
  )
}
