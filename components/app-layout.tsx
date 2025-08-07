"use client"

import { usePathname } from "next/navigation"
import * as React from "react"

import { AppHeader } from "@/components/app-header"
import { AppSidebar } from "@/components/app-sidebar"
import { ChatbotLauncher } from "@/components/chatbot-launcher"

interface AppLayoutProps {
  children: React.ReactNode
}

export function AppLayout({ children }: AppLayoutProps) {
  const pathname = usePathname()
  const isLoginPage = pathname === "/" || pathname === "/login"
  const [isSidebarOpen, setIsSidebarOpen] = React.useState(false)

  const toggleSidebar = () => setIsSidebarOpen((open) => !open)
  const closeSidebar = () => setIsSidebarOpen(false)

  return (
    <div className="flex min-h-screen w-full flex-col">
      {!isLoginPage && <AppHeader onToggleSidebar={toggleSidebar} />}
      <div className="flex flex-1">
        {!isLoginPage && (
          <AppSidebar isOpen={isSidebarOpen} onClose={closeSidebar} />
        )}
        <main className="flex flex-1 flex-col gap-4 p-4 lg:gap-6 lg:p-6">
          {children}
        </main>
      </div>
      {!isLoginPage && <ChatbotLauncher />}
    </div>
  )
}
