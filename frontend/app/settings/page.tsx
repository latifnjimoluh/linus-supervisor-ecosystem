"use client"

import Link from "next/link"
import { User, FileText, Server, HardDrive, Shield, Key } from 'lucide-react'

import { BackButton } from "@/components/back-button"
import { Card, CardHeader, CardTitle, CardDescription, CardFooter } from "@/components/ui/card"
import { Button } from "@/components/ui/button"

const settingsCards = [
  {
    title: "Paramètres du Compte",
    description: "Gérez votre profil, la sécurité de votre compte et vos préférences.",
    icon: <User className="h-8 w-8 text-primary" />,
    href: "/settings/account",
    cta: "Accéder",
  },
  {
    title: "Templates de Provisionnement",
    description: "Configurez et gérez les templates de machines virtuelles pour le déploiement.",
    icon: <FileText className="h-8 w-8 text-primary" />,
    href: "/settings/templates",
    cta: "Gérer",
  },
  {
    title: "Connexion Proxmox",
    description: "Configurez les informations de connexion à votre hyperviseur Proxmox.",
    icon: <Server className="h-8 w-8 text-primary" />,
    href: "/settings/proxmox",
    cta: "Configurer",
  },
  {
    title: "Gestion des Rôles",
    description: "Définissez et organisez les rôles des utilisateurs.",
    icon: <Shield className="h-8 w-8 text-primary" />,
    href: "/settings/roles",
    cta: "Gérer",
  },
  {
    title: "Gestion des Permissions",
    description: "Contrôlez les permissions associées aux rôles.",
    icon: <Key className="h-8 w-8 text-primary" />,
    href: "/settings/permissions",
    cta: "Gérer",
  },
  {
    title: "Gestion du Stockage",
    description: "Visualisez et gérez les stockages disponibles sur vos hyperviseurs.",
    icon: <HardDrive className="h-8 w-8 text-primary" />,
    href: "#",
    cta: "Bientôt disponible",
    disabled: true,
  },
]

export default function SettingsPage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <BackButton href="/dashboard" label="Retour" />
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Paramètres</h1>
          <p className="text-muted-foreground">
            Gérez les paramètres généraux de l’application et de votre infrastructure.
          </p>
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        {settingsCards.map((card) => (
          <Card key={card.title} className="hover:shadow-md transition-shadow">
            <CardHeader>
              <div className="flex items-start justify-between">
                <div className="space-y-1.5">
                  <CardTitle>{card.title}</CardTitle>
                  <CardDescription>{card.description}</CardDescription>
                </div>
                {card.icon}
              </div>
            </CardHeader>
            <CardFooter>
              <Button asChild className="w-full" disabled={card.disabled} variant={card.disabled ? "secondary" : "default"}>
                <Link href={card.href}>{card.cta}</Link>
              </Button>
            </CardFooter>
          </Card>
        ))}
      </div>
    </div>
  )
}
