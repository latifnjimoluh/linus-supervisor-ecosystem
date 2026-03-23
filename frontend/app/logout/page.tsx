"use client";
import { useEffect } from "react";
import { logoutUser } from "@/services/api";

export default function LogoutPage() {
  useEffect(() => {
    logoutUser("Déconnecté");
  }, []);
  return <p className="p-4">Déconnexion…</p>;
}
