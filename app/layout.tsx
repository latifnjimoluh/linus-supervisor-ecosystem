import type { Metadata } from "next"
import { Inter } from 'next/font/google'
import "./globals.css"
import { ThemeProvider } from "@/components/theme-provider"
import { Toaster } from "@/components/ui/toaster"
import { ToastProvider } from "@/hooks/use-toast" // ✅ Ajout
import { AppLayout } from "@/components/app-layout"

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
        <ToastProvider> {/* ✅ Contexte global */}
          <ThemeProvider
            attribute="class"
            defaultTheme="system"
            enableSystem
            disableTransitionOnChange
          >
            <AppLayout>
              {children}
            </AppLayout>
            <Toaster />
          </ThemeProvider>
        </ToastProvider>
      </body>
    </html>
  )
}
