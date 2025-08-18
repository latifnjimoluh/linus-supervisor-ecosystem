// app/layout.tsx
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { ThemeProvider } from "@/components/theme-provider";
import { Toaster } from "@/components/ui/toaster";
import { ToastProvider } from "@/hooks/use-toast";
import { ErrorProvider } from "@/hooks/use-errors";
import { LanguageProvider } from "@/hooks/use-language";
import PublicAwareLayout from "@/components/public-aware-layout"; // ✅ wrapper client

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "LinuSupervisor",
  description: "Plateforme de gestion et supervision d'infrastructure",
  generator: "v0.dev",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr" suppressHydrationWarning>
      <body className={`${inter.className} min-h-screen bg-background antialiased`}>
        <ErrorProvider>
          <ToastProvider>
            <ThemeProvider attribute="class" defaultTheme="system" enableSystem disableTransitionOnChange>
              <LanguageProvider>
                <PublicAwareLayout>{children}</PublicAwareLayout>
                <Toaster />
              </LanguageProvider>
            </ThemeProvider>
          </ToastProvider>
        </ErrorProvider>
      </body>
    </html>
  );
}
