"use client"

import * as React from "react"
import Link from "next/link"
import { Button } from "@/components/ui/button"
import { DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuItem } from "@/components/ui/dropdown-menu"
import { ModeToggle } from "@/components/mode-toggle"
import { Menu, Bell, User, Settings, LogOut, HelpCircle, Loader2 } from 'lucide-react'
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Badge } from "@/components/ui/badge"
import { fetchDeployment, fetchLastDeployment } from "@/services/deployments"
import { logoutUser } from "@/services/api"

interface AppHeaderProps {
  title?: string
  onToggleSidebar?: () => void
}

export function AppHeader({ title, onToggleSidebar }: AppHeaderProps) {
  const [last, setLast] = React.useState<null | { instance_id: string; status: string }>(null)

  React.useEffect(() => {
    const load = async () => {
      try {
        const id = typeof window !== "undefined" ? localStorage.getItem("last_instance_id") : null
        if (id) {
          const dep = await fetchDeployment(id)
          setLast({ instance_id: id, status: dep.status })
        } else {
          const dep = await fetchLastDeployment()
          localStorage.setItem("last_instance_id", dep.instance_id)
          setLast({ instance_id: dep.instance_id, status: dep.status })
        }
      } catch (e) {
        console.error("No last deployment", e)
      }
    }
    load()
  }, [])

  React.useEffect(() => {
    if (!last) return
    if (["completed", "failed", "deployed"].includes(last.status)) return
    const interval = setInterval(async () => {
      try {
        const dep = await fetchDeployment(last.instance_id)
        setLast({ instance_id: last.instance_id, status: dep.status })
      } catch {}
    }, 5000)
    return () => clearInterval(interval)
  }, [last])

  const handleLogout = () => {
    logoutUser("Déconnecté")
  }

  return (
    <header className="sticky top-0 z-40 w-full border-b bg-background">
      <div className="mx-auto flex h-16 w-full max-w-[1440px] items-center gap-4 px-3 sm:px-4 md:px-6">
        <Button
          variant="outline"
          size="icon"
          className="shrink-0"
          onClick={onToggleSidebar}
        >
          <Menu className="h-5 w-5 sm:h-6 sm:w-6" />
          <span className="sr-only">Toggle sidebar</span>
        </Button>
        {title && <h1 className="text-base font-medium sm:text-lg">{title}</h1>}
        <div className="flex-1" />
        {last && (
          <Link href={`/deployments/${last.instance_id}`}>
            <Button variant="outline" className="flex items-center gap-2">
              Dernier déploiement
              {(["completed", "deployed"].includes(last.status)) ? (
                <Badge variant="success">Terminé</Badge>
              ) : last.status === "failed" ? (
                <Badge variant="destructive">Échec</Badge>
              ) : (
                <span className="flex items-center text-sm text-muted-foreground">
                  <Loader2 className="mr-1 h-4 w-4 animate-spin" /> En cours…
                </span>
              )}
            </Button>
          </Link>
        )}
        <Link href="/help#search">
          <Button variant="ghost" size="icon" className="rounded-full">
            <HelpCircle className="h-5 w-5 sm:h-6 sm:w-6" />
            <span className="sr-only">Besoin d'aide ?</span>
          </Button>
        </Link>
        <Button variant="ghost" size="icon" className="rounded-full">
          <Bell className="h-5 w-5 sm:h-6 sm:w-6" />
          <span className="sr-only">Notifications</span>
        </Button>
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
            <DropdownMenuLabel>Mon Compte</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem asChild>
              <Link href="/profile" className="flex items-center">
                <User className="mr-2 h-4 w-4" /> Profil
              </Link>
            </DropdownMenuItem>
            <DropdownMenuItem asChild>
              <Link href="/settings" className="flex items-center">
                <Settings className="mr-2 h-4 w-4" /> Paramètres
              </Link>
            </DropdownMenuItem>
            <DropdownMenuItem asChild>
              <Link href="/help" className="flex items-center">
                <HelpCircle className="mr-2 h-4 w-4" /> Aide
              </Link>
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={handleLogout} className="flex items-center text-destructive focus:text-destructive">
              <LogOut className="mr-2 h-4 w-4" /> Déconnexion
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  )
}
