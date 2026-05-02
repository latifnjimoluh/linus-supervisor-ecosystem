"use client";

import { usePathname } from "next/navigation";
import * as React from "react";

import { AppHeader } from "@/components/app-header";
import { AppSidebar } from "@/components/app-sidebar";
import { AuthGuard } from "@/components/auth-guard";
import { ErrorBanner } from "./error-banner";
import { ChatButton } from "@/components/chat/ChatButton";
import { ChatPanel } from "@/components/chat/ChatPanel";

interface AppLayoutProps {
  children: React.ReactNode;
}

export function AppLayout({ children }: AppLayoutProps) {
  const pathname = usePathname();
  const isLoginPage = pathname === "/" || pathname === "/login";
  const [isSidebarOpen, setIsSidebarOpen] = React.useState(false);

  const toggleSidebar = () => setIsSidebarOpen((open) => !open);
  const closeSidebar = () => setIsSidebarOpen(false);

  if (isLoginPage) {
    return <main className="flex min-h-screen w-full flex-col">{children}</main>;
  }

  return (
    <div className="flex h-screen w-full overflow-hidden">
      <AppSidebar isOpen={isSidebarOpen} onClose={closeSidebar} />
      <div className="flex flex-1 flex-col">
        <AppHeader onToggleSidebar={toggleSidebar} />
        <main className="mx-auto flex w-full max-w-[1440px] flex-1 flex-col gap-4 overflow-auto p-3 sm:p-4 md:p-6 pb-24">
          <ErrorBanner id="global" />
          {children}
        </main>
      </div>
      <ChatButton />
      <ChatPanel />
    </div>
  );
}

export default AppLayout;
