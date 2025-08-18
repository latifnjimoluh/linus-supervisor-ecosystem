// components/public-aware-layout.tsx
"use client";

import { usePathname } from "next/navigation";
import dynamic from "next/dynamic";

// ✅ charge AppLayout côté client uniquement et gère export nommé ou default
const AppLayout = dynamic(
  () => import("./app-layout").then((m) => m.AppLayout ?? m.default),
  { ssr: false }
);

const PUBLIC_ROUTES = ["/login", "/login/otp", "/reset"];

export default function PublicAwareLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname() || "/";

  const isPublic = PUBLIC_ROUTES.some(
    (p) => pathname === p || pathname.startsWith(p)
  );

  // Sur routes publiques : pas d’AppLayout (évite fetch protégés / useAuth)
  if (isPublic) return <>{children}</>;

  // Routes protégées : AppLayout complet
  return <AppLayout>{children}</AppLayout>;
}
