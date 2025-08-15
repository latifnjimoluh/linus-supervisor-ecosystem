"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";
import { loginUser } from "@/services/api";
import { useErrors } from "@/hooks/use-errors";
import { ErrorBanner } from "@/components/error-banner";

export default function OtpPage() {
  const [otp, setOtp] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const router = useRouter();
  const { toast } = useToast();
  const { setError, clearError } = useErrors();

  useEffect(() => {
    clearError("auth");
  }, [clearError]);

  let creds: any = null;
  if (typeof window !== "undefined") {
    const stored = sessionStorage.getItem("preAuth");
    if (stored) creds = JSON.parse(stored);
    else router.replace("/login");
  }

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (!creds) return;

    setIsLoading(true);
    clearError("auth");
    try {
      const data = await loginUser(creds.email, creds.password, creds.remember, otp);
      clearError("auth");
      sessionStorage.removeItem("preAuth");
      toast({
        title: "Connexion réussie",
        description: data.message,
        variant: "success",
        duration: 3000,
      });
      router.push(creds.redirectTo || "/dashboard");
    } catch (error: any) {
      const status = error?.response?.status;
      const message =
        error?.response?.data?.message ||
        (status === 429 ? "Trop de tentatives. Réessayez plus tard." : "Code 2FA invalide.");
      setError("auth", { message, ttlMs: 6000 });
    } finally {
      setIsLoading(false);
    }
  };

  if (!creds) return null;

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <Card className="w-full max-w-md rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl">Vérification 2FA</CardTitle>
          <CardDescription>Entrez le code de votre application d'authentification</CardDescription>
        </CardHeader>
        <CardContent>
          <ErrorBanner id="auth" />
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="otp">Code 2FA</Label>
              <Input
                id="otp"
                value={otp}
                onChange={(e) => setOtp(e.target.value)}
                required
                className="rounded-xl focus-visible:ring-2 focus-visible:ring-primary"
              />
            </div>
            <Button type="submit" className="w-full rounded-xl" disabled={isLoading}>
              {isLoading ? (
                <span className="flex items-center">
                  <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                  Vérification...
                </span>
              ) : (
                "Vérifier"
              )}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}

