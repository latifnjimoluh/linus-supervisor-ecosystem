"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useActionState } from "react"
import { Eye, EyeOff } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { useToast } from "@/hooks/use-toast"
import { resetPassword } from "@/actions/auth"

export default function SetNewPasswordPage({ params }: { params: { token: string } }) {
  const [state, action] = useActionState(resetPassword, null)
  const [showNewPassword, setShowNewPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const [newPassword, setNewPassword] = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [confirmShake, setConfirmShake] = useState(false)
  const { toast } = useToast()
  const router = useRouter()

  const isPasswordStrong = (password: string) => {
    return password.length >= 8 && /[A-Z]/.test(password) && /[a-z]/.test(password) && /[0-9]/.test(password)
  }

  useEffect(() => {
    if (state) {
      if (state.success) {
        toast({
          title: "Succès",
          description: state.message,
          variant: "success",
        })
        setTimeout(() => {
          router.push("/login")
        }, 5000) // Redirect after 5 seconds
      } else {
        toast({
          title: "Erreur",
          description: state.message,
          variant: "destructive",
        })
        if (state.message === "Les deux mots de passe ne sont pas identiques.") {
          setConfirmShake(true)
          setTimeout(() => setConfirmShake(false), 500)
        }
      }
    }
  }, [state, toast, router])

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <Card className="w-full max-w-md rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl">Définir un nouveau mot de passe</CardTitle>
          <CardDescription>Saisissez votre nouveau mot de passe.</CardDescription>
        </CardHeader>
        <CardContent>
          <form action={action} className="space-y-6">
            <input type="hidden" name="token" value={params.token} />
            <div className="space-y-2">
              <Label htmlFor="newPassword">Nouveau mot de passe</Label>
              <div className="relative">
                <Input
                  id="newPassword"
                  name="newPassword"
                  type={showNewPassword ? "text" : "password"}
                  required
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  className="rounded-xl focus-visible:ring-2 focus-visible:ring-primary pr-10"
                />
                <Button
                  type="button"
                  variant="ghost"
                  size="icon"
                  className="absolute right-2 top-1/2 -translate-y-1/2 h-8 w-8"
                  onClick={() => setShowNewPassword(!showNewPassword)}
                  aria-label={showNewPassword ? "Masquer le mot de passe" : "Afficher le mot de passe"}
                >
                  {showNewPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </Button>
              </div>
              <div className="text-xs text-muted-foreground">
                {newPassword.length > 0 && (
                  <ul className="list-disc list-inside">
                    <li className={newPassword.length >= 8 ? "text-success" : "text-destructive"}>Au moins 8 caractères</li>
                    <li className={/[A-Z]/.test(newPassword) ? "text-success" : "text-destructive"}>Une majuscule</li>
                    <li className={/[a-z]/.test(newPassword) ? "text-success" : "text-destructive"}>Une minuscule</li>
                    <li className={/[0-9]/.test(newPassword) ? "text-success" : "text-destructive"}>Un chiffre</li>
                  </ul>
                )}
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="confirmPassword">Confirmer mot de passe</Label>
              <motion.div
                className="relative"
                animate={confirmShake ? { x: [-5, 5, -5, 5, 0] } : { x: 0 }}
                transition={{ duration: 0.2, ease: "easeInOut" }}
              >
                <Input
                  id="confirmPassword"
                  name="confirmPassword"
                  type={showConfirmPassword ? "text" : "password"}
                  required
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  className="rounded-xl focus-visible:ring-2 focus-visible:ring-primary pr-10"
                />
                <Button
                  type="button"
                  variant="ghost"
                  size="icon"
                  className="absolute right-2 top-1/2 -translate-y-1/2 h-8 w-8"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  aria-label={showConfirmPassword ? "Masquer le mot de passe" : "Afficher le mot de passe"}
                >
                  {showConfirmPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </Button>
              </motion.div>
            </div>
            <Button
              type="submit"
              className="w-full rounded-xl"
              disabled={state?.pending || !isPasswordStrong(newPassword) || newPassword !== confirmPassword}
            >
              {state?.pending ? (
                <span className="flex items-center">
                  <svg className="animate-spin h-5 w-5 mr-3" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Changement...
                </span>
              ) : (
                "Changer le mot de passe"
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
