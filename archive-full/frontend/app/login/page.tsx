"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Eye, EyeOff, Loader2 } from "lucide-react";
import { motion } from "framer-motion";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";
import { useErrors } from "@/hooks/use-errors";
import { ErrorBanner } from "@/components/error-banner";

// ⬇️ IMPORTANT : importer depuis services/auth
import { loginUser, saveTokens } from "@/services/auth";

export default function LoginPage() {
  // ---- UI state
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [passwordShake, setPasswordShake] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [remember, setRemember] = useState(false); // valeur initiale identique SSR/CSR

  const { toast } = useToast();
  const router = useRouter();
  const { setError, clearError } = useErrors();
  const pwdRef = useRef<HTMLInputElement>(null);

  // ---- Effets client-only
  useEffect(() => {
    // 1) Message de logout (optionnel)
    const msg = localStorage.getItem("logout_message");
    if (msg) {
      const variant = msg.toLowerCase().includes("expir") ? "warning" : "success";
      toast({ title: msg, variant, duration: 4000 });
      localStorage.removeItem("logout_message");
    }

    // 2) Recharger la préférence "remember"
    const saved = localStorage.getItem("remember") === "1";
    if (saved) setRemember(true);

    // 3) Nettoyer les erreurs d’auth résiduelles
    clearError("auth");
  }, [toast, clearError]);

  // ---- Soumission du formulaire
  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setIsLoading(true);
    clearError("auth");

    try {
      // ⚠️ Calcul et sanitisation de redirectTo au moment de l’action (client-only)
      const params = new URLSearchParams(window.location.search);
      let redirectTo = params.get("redirect") || "/dashboard";
      // ⛔️ ne jamais rediriger vers /login ni /login/otp pour éviter une boucle
      if (redirectTo.startsWith("/login")) redirectTo = "/dashboard";

      // Persister la préférence "remember" (optionnel)
      localStorage.setItem("remember", remember ? "1" : "0");

      const res = await loginUser(email, password, remember);
      // res = { status, message?, token?, user?, refreshToken?, device_id? }

      if (res.status === 206) {
        // Étape 2FA requise -> on garde l'info minimale en sessionStorage, puis redirection OTP
        sessionStorage.setItem(
          "preAuth",
          JSON.stringify({ email, password, remember, redirectTo })
        );

        toast({
          title: "Code 2FA requis",
          description: "Veuillez saisir le code d'authentification.",
          variant: "info",
          duration: 3000,
        });

        router.push("/login/otp"); // pas de ?redirect= ici
        return;
      }

      if (res.status === 200 && res.token) {
        // Login direct (sans 2FA) -> on enregistre le token (et refresh/device si fournis), puis redirection
        saveTokens({ token: res.token, refreshToken: res.refreshToken, device_id: res.device_id });

        toast({
          title: "Connexion réussie",
          description: res.message,
          variant: "success",
          duration: 3000,
        });

        router.push(redirectTo);
        return;
      }

      // Statuts d’erreur côté API (401/403/429/500 …)
      throw new Error(res?.message || "Échec de la connexion.");
    } catch (error: any) {
      // Gestion centralisée + feedback local (shake)
      const message =
        error?.response?.data?.message ||
        error?.message ||
        "Identifiants incorrects.";

      setError("auth", {
        message,
        detailsUrl: "/logs", // si tu as une page de logs ; sinon enlève
        ttlMs: 6000,
      });

      setPasswordShake(true);
      setTimeout(() => setPasswordShake(false), 500);
      pwdRef.current?.focus();
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <Card className="w-full max-w-lg rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl">Connexion</CardTitle>
          <CardDescription>Connectez-vous à votre compte Linusupervisor</CardDescription>
        </CardHeader>

        <CardContent>
          {/* Bannière d’erreur globale (provider use-errors) */}
          <ErrorBanner id="auth" />

          <form onSubmit={handleSubmit} className="space-y-4">
            {/* Email */}
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                placeholder="votre@email.com"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="rounded-xl focus-visible:ring-2 focus-visible:ring-primary"
                autoComplete="username"
              />
            </div>

            {/* Password */}
            <div className="space-y-2">
              <Label htmlFor="password">Mot de passe</Label>
              <motion.div
                className="relative"
                animate={passwordShake ? { x: [-5, 5, -5, 5, 0] } : { x: 0 }}
                transition={{ duration: 0.2, ease: "easeInOut" }}
              >
                <Input
                  ref={pwdRef}
                  id="password"
                  type={showPassword ? "text" : "password"}
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="rounded-xl focus-visible:ring-2 focus-visible:ring-primary pr-10"
                  autoComplete="current-password"
                />
                <Button
                  type="button"
                  variant="ghost"
                  size="icon"
                  className="absolute right-2 top-1/2 -translate-y-1/2 h-8 w-8"
                  onClick={() => setShowPassword(!showPassword)}
                  aria-label={showPassword ? "Masquer le mot de passe" : "Afficher le mot de passe"}
                >
                  {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </Button>
              </motion.div>
            </div>

            {/* Remember me */}
            <div className="flex items-center space-x-2">
              <input
                id="remember"
                type="checkbox"
                className="h-4 w-4"
                checked={remember}
                onChange={(e) => setRemember(e.target.checked)}
              />
              <Label htmlFor="remember" className="text-sm">Se souvenir de moi</Label>
            </div>

            {/* Submit */}
            <Button type="submit" className="w-full rounded-xl" disabled={isLoading}>
              {isLoading ? (
                <span className="flex items-center">
                  <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                  Connexion...
                </span>
              ) : (
                "Connexion"
              )}
            </Button>

            {/* Reset link */}
            <div className="text-center text-sm">
              <Link href="/reset" className="text-primary hover:underline">
                Mot de passe oublié ?
              </Link>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
