"use client"

import { usePathname } from "next/navigation"
import * as React from "react"

import { AppHeader } from "@/components/app-header"
import { AppSidebar } from "@/components/app-sidebar"
import { ChatbotLauncher } from "@/components/chatbot-launcher"
import useAuth from "@/hooks/useAuth"

interface AppLayoutProps {
  children: React.ReactNode
}

export function AppLayout({ children }: AppLayoutProps) {
  const pathname = usePathname()
  const publicRoutes = ["/", "/login", "/reset"]
  const isPublic = publicRoutes.some((route) => pathname.startsWith(route))
  const [isSidebarOpen, setIsSidebarOpen] = React.useState(false)

  useAuth(undefined, !isPublic)

  const toggleSidebar = () => setIsSidebarOpen((open) => !open)
  const closeSidebar = () => setIsSidebarOpen(false)

  if (isPublic) {
    return <main className="flex min-h-screen w-full flex-col">{children}</main>
  }

  return (
    <div className="flex h-screen w-full overflow-hidden">
      <AppSidebar isOpen={isSidebarOpen} onClose={closeSidebar} />
      <div className="flex flex-1 flex-col">
        <AppHeader onToggleSidebar={toggleSidebar} />
        <main className="flex flex-1 flex-col gap-4 overflow-auto p-4 lg:gap-6 lg:p-6">
          {children}
        </main>
      </div>
      <ChatbotLauncher />
    </div>
  )
}
