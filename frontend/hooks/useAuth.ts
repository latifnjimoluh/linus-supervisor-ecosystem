"use client";

import { useRouter, usePathname } from "next/navigation";
import { useEffect } from "react";
import { getAuthToken } from "@/services/api";

export function useAuth(redirect?: string, enabled: boolean = true) {
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    if (!enabled) return;
    const token = getAuthToken();
    if (!token) {
      const target = redirect || pathname;
      router.replace(`/login?redirect=${encodeURIComponent(target)}`);
    }
  }, [router, pathname, redirect, enabled]);
}

export default useAuth;

