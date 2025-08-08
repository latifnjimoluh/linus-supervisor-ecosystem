"use server"

import { redirect } from "next/navigation";
import { cookies } from "next/headers";
import { login as loginApi, requestResetCode, resetPassword as resetPasswordApi, api } from "@/services/api";

export async function login(prevState: any, formData: FormData) {
  const email = formData.get("email") as string;
  const password = formData.get("password") as string;
  const remember = formData.get("rememberMe") === "on";

  if (!email || !password) {
    return { success: false, message: "Veuillez saisir votre email et mot de passe." };
  }

  try {
    const data = await loginApi(email, password, remember);

    const cookieStore = await cookies();
    cookieStore.set("auth_token", data.token, {
      httpOnly: false,
      path: "/",
      maxAge: remember ? 7 * 24 * 60 * 60 : 24 * 60 * 60
    });

    const roleRedirects: Record<string, string> = { 2: "/monitoring", 3: "/logs" };
    const redirectTo = roleRedirects[data.user.role_id] || "/dashboard";
    const displayName = `${data.user.first_name} ${data.user.last_name}`;

    return { success: true, message: `Bienvenue, ${displayName}!`, redirectTo, token: data.token };
  } catch (e: any) {
    const message = e.response?.data?.message || e.message || "Erreur serveur.";
    return { success: false, message };
  }
}

export async function requestPasswordReset(prevState: any, formData: FormData) {
  const email = formData.get("email") as string;
  if (!email) {
    return { success: false, message: "Veuillez saisir une adresse email valide." };
  }
  try {
    const data = await requestResetCode(email);
    return { success: true, message: data.message || "Demande envoyée" };
  } catch (e: any) {
    const message = e.response?.data?.message || e.message || "Erreur serveur.";
    return { success: false, message };
  }
}

export async function resetPassword(prevState: any, formData: FormData) {
  const token = formData.get("token") as string;
  const password = formData.get("newPassword") as string;
  const confirmPassword = formData.get("confirmPassword") as string;

  if (password !== confirmPassword) {
    return { success: false, message: "Les deux mots de passe ne sont pas identiques." };
  }
  try {
    const data = await resetPasswordApi(token, password);
    return { success: true, message: data.message || "Mot de passe mis à jour" };
  } catch (e: any) {
    const message = e.response?.data?.message || e.message || "Erreur serveur.";
    return { success: false, message };
  }
}

export async function logout() {
  cookies().delete("auth_token");
  redirect("/");
}

export async function getCurrentUser() {
  const cookieStore = cookies();
  const token = cookieStore.get("auth_token");
  if (!token) return null;
  try {
    const res = await api.get("/auth/me", {
      headers: { Authorization: `Bearer ${token.value}` }
    });
    return res.data;
  } catch {
    return null;
  }
}
