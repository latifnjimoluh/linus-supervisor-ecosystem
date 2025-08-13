"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Eye, EyeOff, Loader2 } from "lucide-react";
import { motion } from "framer-motion";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";
import { loginUser } from "@/services/api";

// ✅ import du hook d’erreurs global
import { useErrors } from "@/hooks/use-errors";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [passwordShake, setPasswordShake] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [remember, setRemember] = useState(false);

  const { toast } = useToast();
  const router = useRouter();
  const searchParams = useSearchParams();
  const redirectTo = searchParams.get("redirect") || "/dashboard";

  // ✅ accès au store d’erreurs
  const { setError, clearError } = useErrors();

  const pwdRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (typeof window === "undefined") return;
    const msg = localStorage.getItem("logout_message");
    if (msg) {
      const variant = msg.toLowerCase().includes("expir") ? "warning" : "success";
      toast({ title: msg, variant, duration: 4000 }); // durée explicite
      localStorage.removeItem("logout_message");
    }
    // on s’assure de partir sans reliquat d’erreur
    clearError("auth");
  }, [toast, clearError]);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    setIsLoading(true);
    // Nettoie une éventuelle erreur précédente avant de tenter à nouveau
    clearError("auth");

    try {
      const data = await loginUser(email, password, remember);

      // ✅ on purge l’erreur “auth” s’il en restait une (ex: tentative précédente)
      clearError("auth");

      toast({
        title: "Connexion réussie",
        description: data.message,
        variant: "success",
        duration: 3000,
      });

      router.push(redirectTo);
    } catch (error: any) {
      const status = error?.response?.status;
      const message =
        error?.response?.data?.message ||
        (status === 429 ? "Trop de tentatives. Réessayez plus tard." : "Identifiants incorrects.");

      // ✅ on pousse l’erreur dans le provider global avec TTL (auto-dismiss)
      setError("auth", {
        message,
        detailsUrl: "/logs",  // si tu as une page de logs ; sinon enlève
        ttlMs: 6000,          // disparaît tout seul après 6s
      });

      // feedback UI local (shake + focus)
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
          <form onSubmit={handleSubmit} className="space-y-4">
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
              />
            </div>

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

            <div className="text-center text-sm">
              <Link href="/reset" className="text-primary hover:underline">Mot de passe oublié ?</Link>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
