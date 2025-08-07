"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useActionState } from "react"
import { Eye, EyeOff, Loader2 } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Checkbox } from "@/components/ui/checkbox"
import { useToast } from "@/hooks/use-toast"
import { login } from "@/actions/auth"

export default function LoginPage() {
  const [state, action, isPending] = useActionState(login, null)
  const [showPassword, setShowPassword] = useState(false)
  const [passwordShake, setPasswordShake] = useState(false)
  const { toast } = useToast()
  const router = useRouter()

  useEffect(() => {
    if (state) {
      if (state.success) {
        toast({
          title: "Connexion réussie",
          description: state.message,
          variant: "success",
        })
        // Redirection selon le rôle
        setTimeout(() => {
          router.push(state.redirectTo || "/dashboard")
        }, 1000)
      } else {
        toast({
          title: "Erreur de connexion",
          description: state.message,
          variant: "destructive",
        })
        if (state.message === "Identifiants incorrects.") {
          setPasswordShake(true)
          setTimeout(() => setPasswordShake(false), 500)
        }
      }
    }
  }, [state, toast, router])

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <Card className="w-full max-w-lg rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="text-center">
            <CardTitle className="text-2xl font-semibold">Connexion</CardTitle>
            <CardDescription>Connectez-vous à votre compte Linusupervisor</CardDescription>
          </CardHeader>
          <CardContent>
            <form action={action} className="space-y-4">
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
              <div className="space-y-2">
                <Label htmlFor="password">Mot de passe</Label>
                <motion.div
                  className="relative"
                  animate={passwordShake ? { x: [-5, 5, -5, 5, 0] } : { x: 0 }}
                  transition={{ duration: 0.2, ease: "easeInOut" }}
                >
                  <Input
                    id="password"
                    name="password"
                    type={showPassword ? "text" : "password"}
                    required
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
                <Checkbox id="rememberMe" name="rememberMe" className="rounded-md" />
                <Label htmlFor="rememberMe">Se souvenir de moi</Label>
              </div>
              <Button
                type="submit"
                className="w-full rounded-xl"
                disabled={isPending}
              >
                {isPending ? (
                  <span className="flex items-center">
                    <Loader2 className="animate-spin h-5 w-5 mr-3" />
                    Connexion...
                  </span>
                ) : (
                  "Connexion"
                )}
              </Button>
              <div className="text-center text-sm">
                <Link href="/reset" className="text-primary hover:underline">
                  Mot de passe oublié ?
                </Link>
              </div>
            </form>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  )
}
