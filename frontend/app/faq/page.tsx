"use client"

import { useState, useMemo } from "react"
import Link from "next/link"
import { Accordion, AccordionItem, AccordionTrigger, AccordionContent } from "@/components/ui/accordion"
import { Input } from "@/components/ui/input"

interface Question {
  id: string
  q: string
  a: string
}

interface Section {
  theme: string
  questions: Question[]
}

const sections: Section[] = [
  {
    theme: "Général",
    questions: [
      { id: "general-platform", q: "Qu’est-ce que la plateforme Linusupervisor ?", a: "Plateforme de supervision Linux du BUNEC." },
      { id: "general-target", q: "À qui est destinée cette application ?", a: "Aux administrateurs système du BUNEC." },
      { id: "general-config", q: "Quelles sont les configurations minimales pour utiliser l’outil ?", a: "Un navigateur moderne et une connexion réseau." },
      { id: "general-network", q: "Puis-je l’utiliser en dehors du réseau BUNEC ?", a: "Non, l’accès est restreint au réseau interne." }
    ]
  },
  {
    theme: "Comptes et accès",
    questions: [
      { id: "account-create", q: "Comment créer un compte utilisateur ?", a: "L’administrateur crée les comptes via le module utilisateurs." },
      { id: "account-reset", q: "Comment réinitialiser mon mot de passe ?", a: "Utilisez la fonction \"Mot de passe oublié\" sur l’écran de connexion." },
      { id: "account-role", q: "Comment changer mon rôle ou mes permissions ?", a: "Seuls les administrateurs peuvent modifier les rôles." },
      { id: "account-disabled", q: "Pourquoi mon compte est désactivé ?", a: "Après plusieurs échecs de connexion, le compte se verrouille." }
    ]
  },
  {
    theme: "Déploiement de VM",
    questions: [
      { id: "vm-create", q: "Comment créer une nouvelle VM à partir d’un template ?", a: "Utilisez le module de déploiement et choisissez un template." },
      { id: "vm-template-diff", q: "Quelle est la différence entre un Template et une VM classique ?", a: "Un template sert de modèle tandis qu’une VM est une instance déployée." },
      { id: "vm-status", q: "Comment savoir si une VM a été correctement déployée ?", a: "La page de supervision affiche l’état de chaque VM." },
      { id: "vm-logs", q: "Où trouver les logs de création d’une VM ?", a: "Dans le module Logs accessible depuis le menu principal." }
    ]
  },
  {
    theme: "Scripts et Templates",
    questions: [
      { id: "script-create", q: "Comment créer un nouveau template ?", a: "Depuis la section Templates, cliquez sur \"Nouveau\"." },
      { id: "script-link", q: "Comment associer un script à une VM ?", a: "Dans le formulaire de déploiement, sélectionnez le script à lier." },
      { id: "script-export", q: "Comment exporter un script au format JSON, TXT ou Bash ?", a: "Ouvrez le script puis choisissez l’option d’export." },
      { id: "script-edit", q: "Puis-je éditer un template après son déploiement ?", a: "Oui, mais les modifications n’affectent pas les VMs déjà déployées." }
    ]
  },
  {
    theme: "Supervision et alertes",
    questions: [
      { id: "monitoring-server", q: "Comment surveiller l’état d’un serveur ?", a: "La page de supervision liste les métriques de chaque serveur." },
      { id: "monitoring-colors", q: "Que signifient les codes couleurs dans la supervision ?", a: "Chaque couleur indique un niveau d’alerte spécifique." },
      { id: "monitoring-alerts", q: "Comment configurer des alertes personnalisées ?", a: "Utilisez le module d’alertes pour définir vos règles." },
      { id: "monitoring-history", q: "Où consulter l’historique des alertes ?", a: "L’historique est disponible dans la section Alertes." }
    ]
  },
  {
    theme: "Sécurité",
    questions: [
      { id: "security-practices", q: "Quelles sont les bonnes pratiques pour sécuriser mes déploiements ?", a: "Limitez les accès et appliquez les mises à jour." },
      { id: "security-integrity", q: "Comment vérifier l’intégrité d’un script avant exécution ?", a: "Comparez la somme de contrôle avec la valeur attendue." },
      { id: "security-ssh", q: "Comment gérer les clés SSH ?", a: "Utilisez des clés uniques et remplacez-les régulièrement." }
    ]
  },
  {
    theme: "Résolution de problèmes",
    questions: [
      { id: "troubleshoot-login", q: "Je n’arrive pas à me connecter, que faire ?", a: "Vérifiez vos identifiants ou contactez l’administrateur." },
      { id: "troubleshoot-script", q: "Un script ne s’exécute pas, comment diagnostiquer ?", a: "Consultez les logs du script pour identifier l’erreur." },
      { id: "troubleshoot-monitoring", q: "La supervision ne remonte pas d’informations, pourquoi ?", a: "Assurez-vous que l’agent de supervision est actif." },
      { id: "troubleshoot-vm", q: "Une VM ne démarre pas, quelles étapes vérifier ?", a: "Vérifiez les ressources allouées et les journaux de démarrage." }
    ]
  }
]

const topQuestions = [
  "general-platform",
  "account-reset",
  "vm-create",
  "script-export",
  "troubleshoot-login"
]

export default function FAQPage() {
  const [query, setQuery] = useState("")

  const filtered = useMemo(() =>
    sections.map(section => ({
      ...section,
      questions: section.questions.filter(q => q.q.toLowerCase().includes(query.toLowerCase()))
    })).filter(section => section.questions.length > 0)
  , [query])

  return (
    <div className="space-y-6">
      <h1 className="text-4xl font-semibold">Foire Aux Questions</h1>
      <p>Cette section répond aux questions les plus fréquentes concernant l’utilisation de la plateforme de supervision Linux du BUNEC.</p>

      <Input
        placeholder="Rechercher une question..."
        value={query}
        onChange={e => setQuery(e.target.value)}
        className="max-w-md"
      />

      <div>
        <h2 className="text-xl font-medium mb-2">Questions fréquentes</h2>
        <ul className="list-disc pl-5 space-y-1">
          {topQuestions.map(id => {
            const question = sections.flatMap(s => s.questions).find(q => q.id === id)
            return question ? (
              <li key={id}>
                <Link href={`#${id}`} className="underline">
                  {question.q}
                </Link>
              </li>
            ) : null
          })}
        </ul>
      </div>

      {filtered.map(section => (
        <div key={section.theme} className="space-y-2">
          <h2 className="text-2xl font-semibold" id={section.theme.replace(/\s+/g, '-').toLowerCase()}>{section.theme}</h2>
          <Accordion type="multiple" className="w-full">
            {section.questions.map(q => (
              <AccordionItem key={q.id} value={q.id} id={q.id}>
                <AccordionTrigger>{q.q}</AccordionTrigger>
                <AccordionContent>{q.a}</AccordionContent>
              </AccordionItem>
            ))}
          </Accordion>
        </div>
      ))}

      <p className="text-sm text-muted-foreground">Besoin d'aide plus détaillée ? Consultez la page <Link href="/help" className="underline">Help</Link>.</p>
    </div>
  )
}
