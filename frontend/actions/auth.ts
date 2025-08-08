"use server"

import { redirect } from "next/navigation"
import { cookies } from "next/headers"

interface UserRecord {
  id: number
  email: string
  password: string
  role_id: number
  status: "actif" | "inactif"
  first_name: string
  last_name: string
  avatar: string
}

const users: UserRecord[] = [
  {
    id: 1,
    email: "admin@example.com",
    password: "password123",
    role_id: 1,
    status: "actif",
    first_name: "Jean",
    last_name: "Dupont",
    avatar: "/placeholder-user.jpg"
  },
  {
    id: 2,
    email: "tech@example.com",
    password: "password123",
    role_id: 2,
    status: "actif",
    first_name: "Marie",
    last_name: "Martin",
    avatar: "/placeholder-user.jpg"
  },
  {
    id: 3,
    email: "auditor@example.com",
    password: "password123",
    role_id: 3,
    status: "actif",
    first_name: "Pierre",
    last_name: "Durand",
    avatar: "/placeholder-user.jpg"
  },
  {
    id: 4,
    email: "inactive@example.com",
    password: "password123",
    role_id: 2,
    status: "inactif",
    first_name: "Sophie",
    last_name: "Inactive",
    avatar: "/placeholder-user.jpg"
  },
]

// Simulate a password reset requests database
const resetTokens: { email: string; token: string; expiresAt: number; used: boolean }[] = []

// Simple brute-force protection (client-side simulation)
const failedLoginAttempts = new Map<string, number>()
const MAX_ATTEMPTS = 5

export async function login(prevState: any, formData: FormData) {
  await new Promise((resolve) => setTimeout(resolve, 1000)) // Simulate network delay

  const email = formData.get("email") as string
  const password = formData.get("password") as string
  const rememberMe = formData.get("rememberMe") === "on"

  // Basic client-side validation
  if (!email || !password) {
    return { success: false, message: "Veuillez saisir votre email et mot de passe." }
  }
  if (!/\S+@\S+\.\S+/.test(email)) {
    return { success: false, message: "Format email incorrect." }
  }

  // Brute-force check
  const attempts = failedLoginAttempts.get(email) || 0
  if (attempts >= MAX_ATTEMPTS) {
    return { success: false, message: "Trop de tentatives de connexion. Veuillez réessayer plus tard." }
  }

  const user = users.find((u) => u.email === email)

  if (!user) {
    failedLoginAttempts.set(email, attempts + 1)
    return { success: false, message: "Aucun compte avec cet email." }
  }

  if (user.password !== password) {
    failedLoginAttempts.set(email, attempts + 1)
    return { success: false, message: "Identifiants incorrects." }
  }

  if (user.status === "inactif") {
    failedLoginAttempts.set(email, attempts + 1)
    return { success: false, message: "Votre rôle est désactivé." }
  }

  // Clear failed attempts on success
  failedLoginAttempts.delete(email)

  // Create JWT payload with user info
  const jwtPayload = {
    id: user.id,
    email: user.email,
    role_id: user.role_id,
    first_name: user.first_name,
    last_name: user.last_name,
    avatar: user.avatar,
    exp: Date.now() + (rememberMe ? 7 * 24 * 60 * 60 * 1000 : 60 * 60 * 1000)
  }
  
  // Store in secure HttpOnly cookie
  const cookieStore = await cookies()
  cookieStore.set("auth_token", JSON.stringify(jwtPayload), {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    maxAge: rememberMe ? 7 * 24 * 60 * 60 : 60 * 60,
    path: "/",
  })

  // Log the attempt
  const roleLabels: Record<number, string> = { 1: "admin", 2: "technicien", 3: "auditeur" }
  console.log(`Login successful for ${email} (${roleLabels[user.role_id]})`)

  const roleRedirects: Record<number, string> = { 2: "/monitoring", 3: "/logs" }
  const redirectTo = roleRedirects[user.role_id] || "/dashboard"
  const displayName = `${user.first_name} ${user.last_name}`

  return { success: true, message: `Bienvenue, ${displayName}!`, redirectTo }
}

export async function requestPasswordReset(prevState: any, formData: FormData) {
  await new Promise((resolve) => setTimeout(resolve, 1000))

  const email = formData.get("email") as string

  if (!email || !/\S+@\S+\.\S+/.test(email)) {
    return { success: false, message: "Veuillez saisir une adresse email valide." }
  }

  const user = users.find((u) => u.email === email)

  if (!user) {
    console.log(`Password reset requested for non-existent email: ${email}`)
    return { success: true, message: "Un lien de réinitialisation a été envoyé à votre adresse (si elle existe dans notre système)." }
  }

  // Invalidate existing tokens
  resetTokens.forEach(t => {
    if (t.email === email) t.used = true;
  });

  const token = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15)
  const expiresAt = Date.now() + 30 * 60 * 1000 // 30 minutes
  resetTokens.push({ email, token, expiresAt, used: false })

  console.log(`Sending password reset link to ${email}: /reset/${token}`)

  return { success: true, message: "Un lien de réinitialisation a été envoyé à votre adresse." }
}

export async function resetPassword(prevState: any, formData: FormData) {
  await new Promise((resolve) => setTimeout(resolve, 1000))

  const token = formData.get("token") as string
  const newPassword = formData.get("newPassword") as string
  const confirmPassword = formData.get("confirmPassword") as string

  const resetRequest = resetTokens.find(r => r.token === token && !r.used && r.expiresAt > Date.now())
  if (!resetRequest) {
    return { success: false, message: "Lien expiré ou non valide." }
  }

  if (newPassword.length < 8 || !/[A-Z]/.test(newPassword) || !/[a-z]/.test(newPassword) || !/[0-9]/.test(newPassword)) {
    return { success: false, message: "Le mot de passe est trop faible. Il doit contenir au moins 8 caractères, une majuscule, une minuscule et un chiffre." }
  }

  if (newPassword !== confirmPassword) {
    return { success: false, message: "Les deux mots de passe ne sont pas identiques." }
  }

  const userIndex = users.findIndex(u => u.email === resetRequest.email)
  if (userIndex !== -1) {
    users[userIndex].password = newPassword
  }

  resetRequest.used = true
  console.log(`Password for ${resetRequest.email} reset successfully.`)

  return { success: true, message: "Mot de passe mis à jour avec succès." }
}

export async function logout() {
  cookies().delete("auth_token")
  redirect("/")
}

// Helper function to get current user from cookie
export async function getCurrentUser() {
  const cookieStore = cookies()
  const authToken = cookieStore.get("auth_token")
  
  if (!authToken) {
    return null
  }

  try {
    const payload = JSON.parse(authToken.value)
    if (payload.exp < Date.now()) {
      return null // Token expired
    }
    return payload
  } catch {
    return null
  }
}
