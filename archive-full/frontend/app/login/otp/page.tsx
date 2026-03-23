// app/login/otp/page.tsx
"use client";

import { useEffect, useState, useMemo, useCallback, useRef } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { useToast } from "@/hooks/use-toast";
import { loginWithOtp } from "@/services/api"; // <-- depuis api.ts

export default function LoginOtpPage() {
  const [otp, setOtp] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [remember, setRemember] = useState(false);
  const [redirectTo, setRedirectTo] = useState("/dashboard");
  const [isLoading, setIsLoading] = useState(false);
  const [lastTriedOtp, setLastTriedOtp] = useState<string | null>(null); // ✅ empêche re-submit même OTP
  const debounceRef = useRef<NodeJS.Timeout | null>(null);

  const { toast } = useToast();
  const router = useRouter();
  const search = useSearchParams();

  useEffect(() => {
    const pre = sessionStorage.getItem("preAuth");
    if (!pre) {
      const qpRedirect = search?.get("redirect");
      router.replace(qpRedirect || "/login");
      return;
    }
    try {
      const p = JSON.parse(pre);
      setEmail(p.email || "");
      setPassword(p.password || "");
      setRemember(!!p.remember);
      setRedirectTo(p.redirectTo || "/dashboard");
    } catch {
      router.replace("/login");
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const onChangeOtp = (v: string) => {
    const onlyDigits = v.replace(/\D/g, "").slice(0, 6);
    setOtp(onlyDigits);
    // dès qu'on modifie l'OTP, on déverrouille la soumission
    setLastTriedOtp(null);
  };

  const canSubmit = useMemo(
    () => otp.length === 6 && !isLoading && otp !== lastTriedOtp,
    [otp, isLoading, lastTriedOtp]
  );

  const submit = useCallback(async () => {
    if (!canSubmit) return;
    if (debounceRef.current) return;
    debounceRef.current = setTimeout(() => {
      debounceRef.current = null;
    }, 250);
    setIsLoading(true);
    setLastTriedOtp(otp);

    try {
      // loginWithOtp renverra { status, message, token? } (voir api.ts plus bas)
      const res = await loginWithOtp(email, password, otp, remember);

      if (res?.status === 200 && res?.token) {
        sessionStorage.removeItem("preAuth");
        toast({ title: "Connexion réussie", variant: "success" });
        router.push(redirectTo);
        return;
      }

      // 401 → mauvais code OTP
      const msg =
        res?.message ||
        (res?.status === 401
          ? `Code OTP invalide.${
              typeof res?.remaining_attempts === "number"
                ? ` Tentatives restantes: ${res.remaining_attempts}.`
                : ""
            }`
          : "Échec de la vérification OTP.");
      toast({ title: msg, variant: "destructive" });
    } catch (err: any) {
      const message =
        err?.response?.data?.message ||
        err?.message ||
        "Impossible de vérifier le code OTP.";
      toast({ title: message, variant: "destructive" });
    } finally {
      setIsLoading(false);
    }
  }, [canSubmit, otp, email, password, remember, toast, router, redirectTo]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <Card className="w-full max-w-sm rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl">Vérification 2FA</CardTitle>
          <CardDescription>Entrez le code à 6 chiffres de votre application d’authentification.</CardDescription>
        </CardHeader>

        <CardContent className="space-y-4">
          <Input
            inputMode="numeric"
            pattern="\d*"
            maxLength={6}
            placeholder="000000"
            value={otp}
            onChange={(e) => onChangeOtp(e.target.value)}
            onKeyDown={(e) => { if (e.key === "Enter" && canSubmit) submit(); }}
            className="text-center tracking-widest text-lg"
            autoFocus
            aria-label="Code OTP à 6 chiffres"
          />

          <Button className="w-full" onClick={submit} disabled={!canSubmit}>
            {isLoading ? "Vérification..." : "Valider"}
          </Button>

          <Button variant="ghost" className="w-full" onClick={() => router.replace("/login")}>
            Revenir au login
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
