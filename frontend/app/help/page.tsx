"use client"

import { useState } from "react"
import Link from "next/link"
import { Input } from "@/components/ui/input"
import { Accordion, AccordionItem, AccordionTrigger, AccordionContent } from "@/components/ui/accordion"
import { Settings, Code2, Shield, BarChart3, HelpCircle, BookOpen, Server, FileText } from "lucide-react"

interface GuideSection {
  id: string
  title: string
  icon: React.ReactNode
  steps: string[]
}

const guides: GuideSection[] = [
  {
    id: "quick-start",
    title: "Guide de démarrage rapide",
    icon: <HelpCircle className="h-5 w-5" />,
    steps: [
      "Connexion à la plateforme",
      "Navigation dans l’interface",
      "Lancement de votre premier déploiement"
    ]
  },
  {
    id: "accounts",
    title: "Gestion des comptes utilisateurs",
    icon: <Settings className="h-5 w-5" />,
    steps: [
      "Création et suppression d’un compte",
      "Gestion des rôles et permissions",
      "Réinitialisation de mot de passe"
    ]
  },
  {
    id: "deployments",
    title: "Déploiement de VM",
    icon: <Server className="h-5 w-5" />,
    steps: [
      "Sélection d’un template",
      "Choix des ressources",
      "Suivi des logs et tests post-déploiement"
    ]
  },
  {
    id: "scripts",
    title: "Gestion des scripts et templates",
    icon: <Code2 className="h-5 w-5" />,
    steps: [
      "Création et édition",
      "Export et import",
      "Bonnes pratiques"
    ]
  },
  {
    id: "monitoring",
    title: "Supervision et monitoring",
    icon: <BarChart3 className="h-5 w-5" />,
    steps: [
      "Lecture des métriques CPU/RAM",
      "Supervision des services",
      "Gestion des alertes"
    ]
  },
  {
    id: "logs",
    title: "Logs et auditabilité",
    icon: <FileText className="h-5 w-5" />,
    steps: [
      "Accès aux logs système",
      "Filtrage et export",
      "Traçabilité des actions"
    ]
  },
  {
    id: "security",
    title: "Sécurité et bonnes pratiques",
    icon: <Shield className="h-5 w-5" />,
    steps: [
      "Gestion des clés SSH",
      "Vérification d’intégrité",
      "Protection contre les erreurs courantes"
    ]
  }
]

export default function HelpPage() {
  const [query, setQuery] = useState("")

  const filtered = guides.filter(g =>
    g.title.toLowerCase().includes(query.toLowerCase()) ||
    g.steps.some(s => s.toLowerCase().includes(query.toLowerCase()))
  )

  return (
    <div className="space-y-6">
      <h1 className="text-4xl font-semibold flex items-center gap-2">
        <BookOpen className="h-6 w-6" /> Page d'aide
      </h1>
      <p className="text-muted-foreground">Cette page guide les utilisateurs étape par étape dans l’utilisation de la plateforme.</p>

      <Input
        placeholder="Rechercher dans les guides..."
        value={query}
        onChange={e => setQuery(e.target.value)}
        className="max-w-md"
      />

      <Accordion type="multiple" className="w-full">
        {filtered.map(section => (
          <AccordionItem key={section.id} value={section.id} id={section.id}>
            <AccordionTrigger className="flex items-center gap-2">
              {section.icon}
              {section.title}
            </AccordionTrigger>
            <AccordionContent>
              <ul className="list-disc pl-5 space-y-1">
                {section.steps.map((s, idx) => (
                  <li key={idx}>{s}</li>
                ))}
              </ul>
            </AccordionContent>
          </AccordionItem>
        ))}
      </Accordion>

      <div className="space-y-1 text-sm">
        <p>🔗 <Link href="/faq" className="underline">Voir la FAQ</Link></p>
        <p>📚 <a href="#" className="underline">Documentation technique</a></p>
        <p>📞 <a href="mailto:support@example.com" className="underline">Contact du support technique</a></p>
      </div>
    </div>
  )
}
