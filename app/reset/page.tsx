"use client"

import { useEffect } from "react"
import Link from "next/link"
import { useActionState } from "react"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { useToast } from "@/hooks/use-toast"
import { requestPasswordReset } from "@/actions/auth"

export default function ResetPasswordPage() {
  const [state, action] = useActionState(requestPasswordReset, null)
  const { toast } = useToast()

  useEffect(() => {
    if (state) {
      toast({
        title: state.success ? "Demande envoyée" : "Erreur",
        description: state.message,
        variant: state.success ? "success" : "destructive",
      })
    }
  }, [state, toast])

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <Card className="w-full max-w-md rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl">Mot de passe oublié ?</CardTitle>
          <CardDescription>Saisissez votre email pour recevoir un lien de réinitialisation.</CardDescription>
        </CardHeader>
        <CardContent>
          <form action={action} className="space-y-6">
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                name="email"
                type="email"
                placeholder="votre@email.com"
                required
                className="rounded-xl focus-visible:ring-2 focus-visible:ring-primary"
              />
            </div>
            <Button
              type="submit"
              className="w-full rounded-xl"
              disabled={state?.pending}
            >
              {state?.pending ? (
                <span className="flex items-center">
                  <svg className="animate-spin h-5 w-5 mr-3" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Envoi du lien...
                </span>
              ) : (
                "Envoyer le lien"
              )}
            </Button>
            <div className="text-center text-sm">
              <Link href="/login" className="text-primary hover:underline">
                Retour à la connexion
              </Link>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
