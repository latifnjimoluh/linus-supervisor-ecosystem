"use client"

import Link from "next/link"
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Separator } from "@/components/ui/separator"

export default function PrivacyPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-semibold">Politique de Confidentialité – Linusupervisor</h1>
      <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
        <CardHeader>
          <CardTitle>Politique de Confidentialité – Linusupervisor</CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">1. Titre & Préambule</h2>
            <p>
              Cette politique décrit comment <strong>nous</strong> (le BUNEC) traitons les données des
              <strong> utilisateurs</strong> (administrateurs et techniciens) de la plateforme web Linusupervisor.
              Elle s'applique à toutes les interfaces (web, API, agents) et réaffirme notre engagement à la
              confidentialité.
            </p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">2. Responsable du traitement & Contact</h2>
            <ul className="list-disc list-inside">
              <li>Responsable : Service informatique du BUNEC</li>
              <li>Adresse : BUNEC, Yaoundé, Cameroun</li>
              <li>Contact : <a href="mailto:privacy@bunec.org" className="text-primary underline">privacy@bunec.org</a></li>
              <li>Délégué à la Protection des Données : non applicable</li>
              <li>Réponse aux demandes : sous 30 jours ouvrables</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">3. Champ d’application</h2>
            <p>
              La présente politique couvre l'application Linusupervisor, son API backend, les intégrations Proxmox,
              ainsi que tout script ou agent associé en environnements de production, préproduction et test.
            </p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">4. Définitions</h2>
            <ul className="list-disc list-inside">
              <li>Données personnelles, Traitement, Sous-traitant</li>
              <li>Journal/Log, Template, Script, VM, VM_ID</li>
              <li>JWT, Rôle/Permission, Télémétrie, Analyse IA</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">5. Données collectées</h2>
            <ul className="list-disc list-inside">
              <li>Identité : nom, prénom, email, rôle, ID utilisateur, horodatages</li>
              <li>Sécurité : hachage mot de passe, JWT, tentatives d'accès, IP, user agent</li>
              <li>Infrastructure : VM_ID, nom VM, nœud, datastore, CPU/RAM, zones et états</li>
              <li>Logs techniques : sorties de déploiement, actions, erreurs</li>
              <li>Scripts & templates : intitulé, statut, version, auteur, contenu</li>
              <li>Supervision : états services, ports, ressources, horodatages</li>
              <li>Télémétrie UI (si activée) : clics critiques, temps d'exécution, chargements</li>
              <li>Contenu transmis à l’IA : extraits de scripts et paramètres sans secrets</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">6. Sources des données</h2>
            <ul className="list-disc list-inside">
              <li>Données fournies par l'utilisateur via formulaires ou uploads</li>
              <li>Données générées par le système : logs, métriques et IDs</li>
              <li>Proxmox API pour l'inventaire des VM et l'état des ressources</li>
              <li>Outils internes éventuels (ex. monitoring)</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">7. Finalités</h2>
            <ul className="list-disc list-inside">
              <li>Authentification et autorisation via JWT et rôles</li>
              <li>Déploiement, supervision et exploitation des services</li>
              <li>Traçabilité et audit par journalisation des actions</li>
              <li>Sécurité et détection d'usage frauduleux</li>
              <li>Assistance et support technique</li>
              <li>Statistiques et amélioration continue</li>
              <li>Analyse IA avant/après déploiement</li>
              <li>Respect d'obligations légales internes au BUNEC</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">8. Base légale</h2>
            <ul className="list-disc list-inside">
              <li>Exécution d'un service interne du BUNEC</li>
              <li>Intérêt légitime pour la sécurité et l'amélioration</li>
              <li>Obligations légales de journalisation et conservation</li>
              <li>Consentement pour la télémétrie optionnelle</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">9. Cookies & technologies similaires</h2>
            <ul className="list-disc list-inside">
              <li>Cookies de session pour l'authentification</li>
              <li>Préférences d'affichage et de sécurité</li>
              <li>Cookies analytics optionnels avec possibilité d'opt-out</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">10. Partage & destinataires</h2>
            <ul className="list-disc list-inside">
              <li>Sous-traitants techniques (hébergement, sauvegarde)</li>
              <li>Accès restreint à l'équipe IT autorisée</li>
              <li>Aucun partage commercial ni vente de données</li>
              <li>Pas de transferts internationaux prévus</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">11. Mesures de sécurité</h2>
            <ul className="list-disc list-inside">
              <li>Contrôles d'accès basés sur les rôles et expirations JWT</li>
              <li>Chiffrement des communications (TLS) et des disques</li>
              <li>Journalisation et détection des tentatives d'accès</li>
              <li>Durcissement : UFW, rotation des clés, secrets protégés</li>
              <li>Segmentation réseau par zones et principe du besoin d'en connaître</li>
              <li>Filtrage des données envoyées à l'IA, sans secrets</li>
            </ul>
            <p className="italic">
              « Les actions critiques (création/suppression de VM, changements de configuration) sont
              journalisées à des fins d’audit et de sécurité. Ces journaux sont conservés pour une durée
              limitée conformément à la politique interne. »
            </p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">12. Conservation & durées</h2>
            <ul className="list-disc list-inside">
              <li>Comptes utilisateurs : durée du compte + 2 ans d'archivage</li>
              <li>Journaux de déploiement : 12 mois, archivage 12–24 mois</li>
              <li>Logs sécurité : 12–24 mois</li>
              <li>Scripts/templates : conservés jusqu'à suppression définitive</li>
              <li>Télémétrie : 6–12 mois, préférentiellement anonymisée</li>
              <li>Sauvegardes : rotation quotidienne, hebdomadaire, mensuelle</li>
            </ul>
            <p>Ces durées peuvent être ajustées selon la politique interne du BUNEC.</p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">13. Droits des utilisateurs</h2>
            <ul className="list-disc list-inside">
              <li>Accès, rectification et effacement (dans les limites d'audit)</li>
              <li>Limitation ou opposition, notamment à la télémétrie</li>
              <li>Portabilité des données lorsque applicable</li>
              <li>Réclamation auprès du contact interne ou de l'autorité compétente</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">14. Spécificités Proxmox & VM</h2>
            <ul className="list-disc list-inside">
              <li>Inventaire synchronisé avec l'API Proxmox</li>
              <li>Dernière entrée <code>status=deployed</code> utilisée pour les VM_ID non uniques</li>
              <li>Zone LAN attribuée par défaut si non spécifiée</li>
              <li>Vérification de l'espace disque disponible avant déploiement</li>
              <li>Historique des déploiements et destructions pour rapports et KPIs</li>
            </ul>
            <p className="italic">
              « Avant tout déploiement, la plateforme vérifie l’espace disponible sur la cible Proxmox afin
              d’éviter déploiements partiels et risques d’indisponibilité. »
            </p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">15. Spécificités IA</h2>
            <ul className="list-disc list-inside">
              <li>Transmission minimale de données : scripts, paramètres, métriques agrégées</li>
              <li>Aucune inclusion de secrets ou identifiants sensibles</li>
              <li>Recommandations techniques sans action automatique</li>
              <li>Analyse via API externe (Gemini/OpenAI) sans conservation par défaut</li>
              <li>Possibilité de désactiver l’analyse IA par utilisateur ou organisation</li>
            </ul>
            <p className="italic">
              « Les analyses IA n’utilisent que les éléments strictement nécessaires (extraits de scripts,
              paramètres techniques, métriques agrégées). Les identifiants, mots de passe et secrets sont
              exclus ou masqués. Les recommandations issues de l’IA n’ont pas d’effet automatique : toute action
              reste sous contrôle d’un administrateur. »
            </p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">16. Enfants / mineurs</h2>
            <p>Le service est réservé aux agents autorisés adultes ; aucun usage par mineurs n’est prévu.</p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">17. Décisions automatisées</h2>
            <p>Aucune décision juridique n’est prise uniquement de manière automatisée ; l’IA ne fournit que des conseils.</p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">18. Transferts internationaux</h2>
            <p>Pas de transferts internationaux de données prévus.</p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">19. Procédure en cas d’incident</h2>
            <ul className="list-disc list-inside">
              <li>Détection et containment immédiats</li>
              <li>Notification interne et journal d’incident</li>
              <li>Information des utilisateurs concernés en cas de risque élevé</li>
              <li>Coordonnées d’escalade fournies par l’équipe IT</li>
            </ul>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">20. Modifications de la politique</h2>
            <p>
              Toute modification substantielle sera signalée via la plateforme ou par communication interne.
              Date d’entrée en vigueur et numéro de version seront mis à jour en conséquence.
            </p>
          </section>
          <Separator />
          <section className="space-y-2">
            <h2 className="text-xl font-semibold">21. Coordonnées finales & liens utiles</h2>
            <ul className="list-disc list-inside">
              <li>
                Contact confidentialité : <a href="mailto:privacy@bunec.org" className="text-primary underline">privacy@bunec.org</a>
              </li>
              <li>
                <Link href="/about" className="text-primary underline">À propos</Link>, <Link href="/faq" className="text-primary underline">FAQ</Link>, <Link href="/help" className="text-primary underline">Aide</Link>
              </li>
              <li>
                <Link href="/settings/cookies" className="text-primary underline">Préférences cookies</Link>
              </li>
            </ul>
          </section>
        </CardContent>
      </Card>
    </div>
  )
}

