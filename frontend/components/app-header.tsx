"use client"

import Link from "next/link"
import { Button } from "@/components/ui/button"
import { DropdownMenu, DropdownMenuTrigger, DropdownMenuContent, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuItem } from "@/components/ui/dropdown-menu"
import { ModeToggle } from "@/components/mode-toggle"
import { Menu, Bell, User, Settings, LogOut, HelpCircle } from 'lucide-react'
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { useToast } from "@/hooks/use-toast"

interface AppHeaderProps {
  onToggleSidebar?: () => void
}

export function AppHeader({ onToggleSidebar }: AppHeaderProps) {
  const { toast } = useToast()

  const handleLogout = () => {
    toast({
      title: "Déconnexion",
      description: "Vous avez été déconnecté avec succès.",
      variant: "success",
    })
    // Simulate logout action, e.g., redirect to login page
    // router.push('/login');
  }

  return (
    <header className="sticky top-0 z-40 flex h-16 items-center gap-4 border-b bg-background px-4 md:px-6">
      <Button
        variant="outline"
        size="icon"
        className="shrink-0"
        onClick={onToggleSidebar}
      >
        <Menu className="h-5 w-5" />
        <span className="sr-only">Toggle sidebar</span>
      </Button>
      <div className="flex-1" />
      <Button variant="ghost" size="icon" className="rounded-full">
        <Bell className="h-5 w-5" />
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
            <Link href="#" className="flex items-center">
              <HelpCircle className="mr-2 h-4 w-4" /> Aide
            </Link>
          </DropdownMenuItem>
          <DropdownMenuSeparator />
          <DropdownMenuItem onClick={handleLogout} className="flex items-center text-destructive focus:text-destructive">
            <LogOut className="mr-2 h-4 w-4" /> Déconnexion
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </header>
  )
}
