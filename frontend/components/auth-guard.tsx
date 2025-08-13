"use client"

import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import {
  getAuthToken,
  isTokenExpired,
  removeAuthToken,
  getRefreshToken,
  getDeviceId,
  refreshAuthToken,
} from "@/services/api";

export function AuthGuard({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [authorized, setAuthorized] = useState(false);

  useEffect(() => {
    const check = async () => {
      let token = getAuthToken();
      if (!token || isTokenExpired(token)) {
        const refresh = getRefreshToken();
        const device = getDeviceId();
        if (refresh && device) {
          token = await refreshAuthToken();
        }
      }
      if (!token) {
        removeAuthToken();
        router.replace(`/login?redirect=${encodeURIComponent(pathname)}`);
      } else {
        setAuthorized(true);
      }
    };
    check();
  }, [pathname, router]);

  if (!authorized) return null;
  return <>{children}</>;
}

