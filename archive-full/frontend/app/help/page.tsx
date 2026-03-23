"use client"

import Link from "next/link"
import { useState, useMemo } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Separator } from "@/components/ui/separator"

interface Section {
  id: string
  title: string
  content: React.ReactNode
  text: string
}

export default function HelpPage() {
  const sections: Section[] = useMemo(
    () => [
      {
        id: "introduction",
        title: "1. Introduction",
        text:
          "Objectif de la page, public visé et brève présentation des modules de Linusupervisor.",
        content: (
          <>
            <p>
              Objectif de la page : expliquer comment utiliser Linusupervisor efficacement.
            </p>
            <p>
              Public visé : administrateurs système, techniciens réseau et opérateurs du BUNEC.
            </p>
            <p>
              La plateforme se compose de modules de déploiement, supervision, scripts & templates, statistiques et analyse IA.
            </p>
          </>
        ),
      },
      {
        id: "quick-start",
        title: "2. Guide de démarrage rapide",
        text:
          "Connexion, navigation, premier déploiement avec choix de template, configuration et suivi des logs.",
        content: (
          <>
            <h3 className="font-semibold">Connexion</h3>
            <p>
              Accédez à la plateforme via l'URL fournie et authentifiez-vous grâce à votre jeton JWT et votre rôle.
            </p>
            <h3 className="font-semibold">Navigation</h3>
            <p>
              La barre latérale regroupe les différents modules. Utilisez-la pour accéder rapidement aux sections clés.
            </p>
            <h3 className="font-semibold">Premier déploiement</h3>
            <ol className="list-decimal list-inside space-y-1">
              <li>Choisir un template depuis Proxmox via le sélecteur dynamique.</li>
              <li>Configurer CPU, RAM, disque et scripts nécessaires.</li>
              <li>Lancer le déploiement et suivre les logs en temps réel.</li>
            </ol>
          </>
        ),
      },
      {
        id: "tutorials",
        title: "3. Tutoriels détaillés par module",
        text:
          "Procédures pas-à-pas pour chaque module : déploiement, scripts, supervision, statistiques, sécurité et IA.",
        content: (
          <>
            <p>
              Chaque module dispose d'une description, d'une procédure pas-à-pas, de captures d'écran et de bonnes pratiques.
            </p>
            <ul className="list-disc list-inside space-y-1">
              <li>
                <strong>Déploiement de VM</strong> : sélection dynamique de templates Proxmox, vérification de l'espace disponible, suivi de statut et récupération des logs.
              </li>
              <li>
                <strong>Gestion des scripts et templates</strong> : création, édition, suppression (changement de statut), export en JSON/TXT/Bash et analyse IA des contenus.
              </li>
              <li>
                <strong>Supervision et monitoring</strong> : lecture des métriques CPU/RAM/Disque, surveillance des services et ports, gestion des alertes et historiques.
              </li>
              <li>
                <strong>Historique et statistiques</strong> : consultation des déploiements réussis ou échoués, statistiques graphiques et tendances.
              </li>
              <li>
                <strong>Sécurité</strong> : gestion des permissions et rôles, bonnes pratiques SSH, vérification de l'intégrité des scripts.
              </li>
              <li>
                <strong>Analyse IA</strong> : assistance avant et après déploiement, recommandations techniques, limites et précautions.
              </li>
            </ul>
          </>
        ),
      },
      {
        id: "troubleshooting",
        title: "4. Résolution de problèmes",
        text:
          "Conseils pour résoudre les problèmes courants de connexion, de déploiement, de supervision ou d'analyse IA.",
        content: (
          <>
            <ul className="list-disc list-inside space-y-1">
              <li>Connexion impossible → vérifier token et permissions.</li>
              <li>Échec de déploiement → lire les logs et vérifier les ressources.</li>
              <li>Supervision vide → s'assurer que les scripts de monitoring fonctionnent.</li>
              <li>
                Erreur IA → vérifier que le script ne contient pas d'informations sensibles ou bloquées.
              </li>
            </ul>
          </>
        ),
      },
      {
        id: "shortcuts",
        title: "5. Raccourcis utiles",
        text:
          "Liens vers la FAQ, la politique de confidentialité, le support technique et la documentation complète.",
        content: (
          <ul className="list-disc list-inside space-y-1">
            <li>
              <Link href="/faq" className="text-primary underline">
                FAQ
              </Link>
            </li>
            <li>
              <Link href="/privacy" className="text-primary underline">
                Politique de confidentialité
              </Link>
            </li>
            <li>
              <Link href="mailto:support@bunec.org" className="text-primary underline">
                Contact support technique
              </Link>
            </li>
            <li>
              <Link href="/docs" className="text-primary underline">
                Documentation technique
              </Link>
            </li>
          </ul>
        ),
      },
      {
        id: "tips",
        title: "6. Astuces d’utilisation",
        text:
          "Conseils pratiques pour gagner du temps et optimiser l'utilisation de la plateforme.",
        content: (
          <ul className="list-disc list-inside space-y-1">
            <li>Utiliser les filtres dans l'historique pour trouver rapidement une VM.</li>
            <li>Sauvegarder ses templates préférés.</li>
            <li>Lancer une analyse IA avant déploiement pour optimiser la configuration.</li>
          </ul>
        ),
      },
      {
        id: "interactive",
        title: "7. Section interactive",
        text:
          "Barre de recherche interne et bouton 'Besoin d'aide ?' disponible sur toutes les pages.",
        content: (
          <>
            <p>
              Utilisez la barre de recherche ci-dessous pour trouver un guide. Le bouton "Besoin d'aide ?" vous accompagne sur toutes les pages et renvoie directement ici.
            </p>
            <p>
              Entrez un mot-clé pour filtrer les sections de cette page.
            </p>
          </>
        ),
      },
    ],
    []
  )

  const [query, setQuery] = useState("")
  const router = useRouter()

  const filtered = sections.filter(
    (s) =>
      s.title.toLowerCase().includes(query.toLowerCase()) ||
      s.text.toLowerCase().includes(query.toLowerCase())
  )

  return (
    <div className="space-y-6" id="search">
      <Button variant="outline" onClick={() => router.back()}>Retour</Button>
      <h1 className="text-3xl font-semibold">Aide</h1>
      <Input
        placeholder="Rechercher dans l'aide..."
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />
      {filtered.map((section, idx) => (
        <Card
          key={section.id}
          className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40"
        >
          <CardHeader>
            <CardTitle>{section.title}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">{section.content}</CardContent>
          {idx < filtered.length - 1 && <Separator className="mt-6" />}
        </Card>
      ))}
    </div>
  )
}

