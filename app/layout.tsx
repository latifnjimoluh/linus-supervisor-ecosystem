import type { Metadata } from "next"
import { Inter } from 'next/font/google'
import "./globals.css"
import { ThemeProvider } from "@/components/theme-provider"
import { AppHeader } from "@/components/app-header"
import { AppSidebar } from "@/components/app-sidebar"
import { Toaster } from "@/components/ui/toaster"
import { ChatbotLauncher } from "@/components/chatbot-launcher"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "LinuSupervisor",
  description: "Plateforme de gestion et supervision d'infrastructure",
    generator: 'v0.dev'
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="fr" suppressHydrationWarning>
      <body className="min-h-screen bg-background font-sans antialiased">
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <div className="flex min-h-screen w-full flex-col">
            <AppHeader />
            <div className="flex flex-1">
              <AppSidebar />
              <main className="flex flex-1 flex-col gap-4 p-4 lg:gap-6 lg:p-6">
                {children}
              </main>
            </div>
          </div>
          <Toaster />
          <ChatbotLauncher /> {/* ChatbotLauncher moved here */}
        </ThemeProvider>
      </body>
    </html>
  )
}
