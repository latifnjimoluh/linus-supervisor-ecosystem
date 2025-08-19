"use client";

import { usePathname } from "next/navigation";
import * as React from "react";

import { AppHeader } from "@/components/app-header";
import { AppSidebar } from "@/components/app-sidebar";
import { AuthGuard } from "@/components/auth-guard";
import { ErrorBanner } from "./error-banner";
import { Chatbot } from "@/components/chatbot";

interface AppLayoutProps {
  children: React.ReactNode;
}

export function AppLayout({ children }: AppLayoutProps) {
  const pathname = usePathname();
  const isPublicPage =
    pathname === "/" ||
    pathname === "/login" ||
    pathname.startsWith("/reset");
  const [isSidebarOpen, setIsSidebarOpen] = React.useState(false);

  const toggleSidebar = () => setIsSidebarOpen((open) => !open);
  const closeSidebar = () => setIsSidebarOpen(false);

  if (isPublicPage) {
    return <main className="flex min-h-screen w-full flex-col">{children}</main>;
  }

  return (
    <AuthGuard>
      <div className="flex h-screen w-full overflow-hidden">
        <AppSidebar isOpen={isSidebarOpen} onClose={closeSidebar} />
        <div className="flex flex-1 flex-col">
          <AppHeader onToggleSidebar={toggleSidebar} />
          <main className="mx-auto flex w-full max-w-[1440px] flex-1 flex-col gap-4 overflow-auto p-3 sm:p-4 md:p-6 pb-24">
            <ErrorBanner id="global" />
            {children}
          </main>
        </div>
        {process.env.NEXT_PUBLIC_USE_GEMINI === "true" && <Chatbot />}
      </div>
    </AuthGuard>
  );
}

export default AppLayout;
