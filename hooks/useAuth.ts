"use client";

import { useRouter, usePathname } from "next/navigation";
import { useEffect } from "react";
import { getAuthToken } from "@/services/api";
import { refreshAuthToken } from "@/services/api"; // on réutilise celui du service

export function useAuth(redirect?: string) {
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    (async () => {
      let token = getAuthToken();
      if (!token) {
        // tente un refresh silencieux si un refresh_token + device_id sont présents
        token = await refreshAuthToken();
      }
      if (!token) {
        const target = redirect || pathname;
        router.replace(`/login?redirect=${encodeURIComponent(target)}`);
      }
    })();
  }, [router, pathname, redirect]);
}

export default useAuth;
