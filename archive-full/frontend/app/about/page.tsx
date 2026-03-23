"use client"

import Link from "next/link"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Separator } from "@/components/ui/separator"
import pkg from "../../package.json"

export default function AboutPage() {
  const updateDate = new Date().toLocaleDateString()

  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-semibold">À propos</h1>
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>
            Linusupervisor – Plateforme centralisée de supervision et de gestion des infrastructures Linux au BUNEC
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Présentation générale</h2>
            <p>
              Linusupervisor est une solution intelligente et centralisée permettant de déployer, configurer, superviser et sécuriser les serveurs Linux du BUNEC, avec intégration Proxmox, automatisation DevOps/DevSecOps et assistance IA.
            </p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Objectifs de l’application</h2>
            <ul className="list-disc list-inside">
              <li>Automatiser le déploiement et la configuration des serveurs.</li>
              <li>Centraliser la supervision et la gestion.</li>
              <li>Renforcer la sécurité des infrastructures Linux.</li>
              <li>Réduire les erreurs humaines et le temps de traitement.</li>
              <li>Offrir une interface intuitive pour techniciens et administrateurs.</li>
              <li>Fournir un assistant IA pour l’analyse et les recommandations.</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Historique et contexte</h2>
            <ul className="list-disc list-inside">
              <li>Origine du projet : besoin identifié au BUNEC pour moderniser la gestion des serveurs.</li>
              <li>Date de début et jalons importants.</li>
              <li>Étapes majeures de développement.</li>
              <li>Évolution prévue (roadmap).</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Fonctionnalités clés</h2>
            <ul className="list-disc list-inside">
              <li>Déploiement automatisé via Proxmox + Terraform.</li>
              <li>Supervision temps réel (services, ressources, logs).</li>
              <li>Gestion des scripts et templates avec activation/désactivation.</li>
              <li>Analyse IA avant et après déploiement.</li>
              <li>Historique complet des déploiements et destructions.</li>
              <li>Statistiques graphiques et KPIs sur le Dashboard.</li>
              <li>Sécurité intégrée (DevSecOps, restrictions d’accès).</li>
              <li>Support multi-zones (LAN, DMZ, WAN avec interconnexion Gateway).</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Architecture technique</h2>
            <ul className="list-disc list-inside">
              <li>Backend : Node.js + Express.</li>
              <li>Frontend : React.js.</li>
              <li>Infrastructure : Proxmox VE.</li>
              <li>Automatisation : Terraform, scripts Bash.</li>
              <li>Supervision : scripts internes + intégration monitoring.</li>
              <li>Base de données : PostgreSQL.</li>
              <li>IA : API d’analyse et d’assistance.</li>
              <li>Sécurité : JWT, contrôle des permissions.</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Technologies utilisées</h2>
            <ul className="list-disc list-inside">
              <li>Virtualisation : Proxmox VE.</li>
              <li>Infrastructure as Code : Terraform.</li>
              <li>Développement : Node.js, React.js, Bash.</li>
              <li>Base de données : PostgreSQL.</li>
              <li>Monitoring : scripts Bash personnalisés.</li>
              <li>Intelligence artificielle : API IA (Gemini/OpenAI).</li>
              <li>Sécurité : UFW, DevSecOps, auditabilité.</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Équipe de développement</h2>
            <ul className="list-disc list-inside">
              <li>Développeur Backend</li>
              <li>Développeur Frontend</li>
              <li>Architecte DevOps</li>
              <li>Encadrement académique et professionnel</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Institution et mission</h2>
            <ul className="list-disc list-inside">
              <li>Le BUNEC œuvre à la modernisation de l’état civil au Cameroun.</li>
              <li>Cette application est stratégique pour assurer la disponibilité et la sécurité de ses infrastructures.</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Public cible</h2>
            <ul className="list-disc list-inside">
              <li>Administrateurs système du BUNEC.</li>
              <li>Techniciens réseaux et sécurité.</li>
              <li>Services IT des institutions partenaires.</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Statut et licence</h2>
            <ul className="list-disc list-inside">
              <li>Statut : Application interne / projet académique.</li>
              <li>Licence : Propriété du BUNEC – usage interne uniquement.</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Contact</h2>
            <ul className="list-disc list-inside">
              <li>
                Email : <a href="mailto:contact@bunec.org" className="text-primary underline">contact@bunec.org</a>
              </li>
              <li>Adresse : BUNEC, Yaoundé, Cameroun.</li>
              <li>
                <Link href="/privacy" className="text-primary underline">
                  Politique de Confidentialité
                </Link>
              </li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">Version</h2>
            <p>
              Version {pkg.version} – mise à jour le {updateDate}.
            </p>
            <p>Changements récents : intégration de l’assistant IA pour les résumés de logs de déploiement.</p>
          </section>
        </CardContent>
      </Card>
    </div>
  )
}

