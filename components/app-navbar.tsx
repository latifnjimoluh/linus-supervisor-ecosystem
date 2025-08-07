"use client"

import Link from "next/link"
import { Bell, LogOut, User } from 'lucide-react'
import { SidebarTrigger } from "@/components/ui/sidebar"

import { Button } from "@/components/ui/button"
import { ModeToggle } from "@/components/mode-toggle"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu"
import { Badge } from "@/components/ui/badge"
import { logout } from "@/actions/auth"

interface AppNavbarProps {
  user?: {
    id: number
    email: string
    role_id: number
    first_name: string
    last_name: string
    avatar: string
  }
}

export function AppNavbar({ user }: AppNavbarProps) {
  const handleLogout = async () => {
    await logout()
  }

  // Use user data if provided, otherwise fallback to mock
  const currentUser = user || {
    first_name: "Jean",
    last_name: "Dupont",
    email: "admin@example.com",
    role_id: 1,
    avatar: "/placeholder-user.jpg",
    id: 1,
  }

  const getRoleBadgeVariant = (roleId: number) => {
    switch (roleId) {
      case 1: return "destructive"
      case 2: return "warning"
      case 3: return "info"
      default: return "default"
    }
  }

  const getRoleLabel = (roleId: number) => {
    switch (roleId) {
      case 1: return "Administrateur"
      case 2: return "Technicien"
      case 3: return "Auditeur"
      default: return "Inconnu"
    }
  }

  const displayName = `${currentUser.first_name} ${currentUser.last_name}`

  return (
    <header className="flex justify-between items-center h-16 px-4 border-b bg-background">
      <div className="flex items-center gap-4">
        <SidebarTrigger />
        <h1 className="text-xl font-semibold">Linusupervisor</h1>
        <Badge variant={getRoleBadgeVariant(currentUser.role_id)} className="text-xs">
          {getRoleLabel(currentUser.role_id)}
        </Badge>
      </div>
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" className="relative">
          <Bell className="h-5 w-5" />
          <span className="absolute -top-1 -right-1 h-4 w-4 bg-destructive text-destructive-foreground rounded-full text-xs flex items-center justify-center">
            3
          </span>
          <span className="sr-only">Notifications</span>
        </Button>
        <ModeToggle />
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="relative h-8 w-8 rounded-full">
              <Avatar className="h-8 w-8">
                <AvatarImage src={currentUser.avatar || "/placeholder.svg"} alt="User Avatar" />
                <AvatarFallback>{currentUser.first_name[0]}{currentUser.last_name[0]}</AvatarFallback>
              </Avatar>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent className="w-56" align="end" forceMount>
            <DropdownMenuLabel className="font-normal">
              <div className="flex flex-col space-y-1">
                <p className="text-sm font-medium leading-none">{displayName}</p>
                <p className="text-xs leading-none text-muted-foreground">
                  {currentUser.email}
                </p>
              </div>
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem>
              <User className="mr-2 h-4 w-4" />
              <span>Profile</span>
            </DropdownMenuItem>
            <DropdownMenuItem onClick={handleLogout}>
              <LogOut className="mr-2 h-4 w-4" />
              <span>Se déconnecter</span>
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  )
}
