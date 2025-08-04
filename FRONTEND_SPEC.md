# 🔭 Spécification fonctionnelle du frontend

Ce document décrit l'ensemble des interfaces utilisateurs attendues pour interagir avec l'API du projet **linusupervisor-backend**. Il sert de guide pour la conception d'un frontend Web cohérent avec les capacités actuelles du backend.

## 1. Scénario d’utilisation global
1. **Connexion** : l’utilisateur s’authentifie via `/login` et accède au tableau de bord.
2. **Provisionnement d’une VM** : création d’un serveur via formulaire (template, nom, IP, ressources, clé SSH). Terraform s’exécute et le serveur apparaît dans la liste.
3. **Configuration d’un service** : choix d’un service (DNS, Web, VPN…) sur un serveur. Les scripts Bash et playbooks Ansible correspondants sont générés et affichés.
4. **Déploiement** : exécution distante du script, affichage des logs et confirmation de réussite.
5. **Supervision** : activation de la surveillance périodique (CPU, RAM, ports, uptime). Les alertes sont visibles dans l’interface.
6. **Gestion d’incidents** : alerte visuelle, possibilité de redémarrer un service et journalisation des actions.
7. **Historique** : consultation des logs d’exécution et de l’historique des déploiements par serveur ou utilisateur.

## 2. Interfaces principales

### Authentification
| Interface | Route | Description |
|-----------|-------|-------------|
| Connexion | `/login` | Email, mot de passe, mémorisation de session |
| Réinitialisation | `/forgot-password` | Envoi d’un lien de réinitialisation |
| Inscription (option) | `/register` | Création d’un compte utilisateur |

### Tableau de bord
| Interface | Route | Description |
|-----------|-------|-------------|
| Dashboard principal | `/dashboard` | Vue synthétique des serveurs et alertes |
| Carte d’infrastructure | `/dashboard/map` | Répartition visuelle LAN/DMZ |
| Alertes temps réel | `/dashboard/alerts` | Liste des incidents en cours |

### Utilisateurs
| Interface | Route | Description |
|-----------|-------|-------------|
| Liste des utilisateurs | `/users` | Gestion des comptes et rôles |
| Ajouter un utilisateur | `/users/add` | Formulaire d’ajout |
| Modifier un utilisateur | `/users/:id/edit` | Changement de rôle, réinitialisation |
| Mon profil | `/account` | Changement de mot de passe |

### Serveurs
| Interface | Route | Description |
|-----------|-------|-------------|
| Liste des serveurs | `/servers` | Tableau ou carte des machines |
| Détail d’un serveur | `/servers/:id` | Informations système et services |
| Ajouter un serveur | `/servers/add` | Enregistrement via SSH |
| Modifier un serveur | `/servers/:id/edit` | Mise à jour des métadonnées |
| Supprimer un serveur | `/servers/:id/delete` | Archivage ou purge |

### Configuration et déploiement de services
| Interface | Route | Description |
|-----------|-------|-------------|
| Choix du service | `/configure/:serverId` | Sélection d’un service à installer |
| Formulaire de configuration | `/configure/:serverId/:service` | Champs dynamiques selon le template |
| Aperçu du script | `/scripts/preview/:serverId/:service` | Visualisation Bash/Ansible |
| Déploiement distant | `/deploy/:serverId` | Exécution du script et logs live |
| Résumé post-déploiement | `/deploy/:serverId/summary` | Récapitulatif et actions suivantes |

### Provisionnement automatique
| Interface | Route | Description |
|-----------|-------|-------------|
| Création de VM | `/provision/create` | Formulaire Proxmox/VMware |
| Suivi du provisionnement | `/provision/status/:id` | Logs Terraform ou script |
| Templates de VM | `/provision/templates` | Gestion des modèles cloud-init |

### Supervision & monitoring
| Interface | Route | Description |
|-----------|-------|-------------|
| Vue globale | `/monitor` | Synthèse de l’infrastructure |
| Supervision serveur | `/monitor/:serverId` | CPU, RAM, services |
| Supervision service | `/monitor/:serverId/:service` | Ports, logs, statut systemd |
| Journal des incidents | `/monitor/alerts` | Historique des alertes |

### Assistant IA
| Interface | Route | Description |
|-----------|-------|-------------|
| Assistant global | `/assistant` | Chat d’aide technique |
| Assistant contextuel | composant modal | Suggestions en contexte |

### Historique / audit
| Interface | Route | Description |
|-----------|-------|-------------|
| Journal des actions | `/logs` | Historique des déploiements et scripts |
| Log de script | `/logs/:id` | Contenu stdout/stderr |
| Historique utilisateur | `/logs/users/:id` | Actions par personne |

### Paramètres
| Interface | Route | Description |
|-----------|-------|-------------|
| Paramètres globaux | `/settings` | Supervision, rôles, sécurité |
| Notifications | `/settings/notifications` | Canaux d’alerte |
| Templates de services | `/settings/templates` | Définition des champs JSON |
| Tester un template | `/settings/templates/:id/test` | Rendu du formulaire et script |

### Pages d’erreur
| Interface | Route | Description |
|-----------|-------|-------------|
| Accès interdit | `/403` | Rôle insuffisant |
| Page introuvable | `/404` | Mauvaise URL |
| Erreur technique | `/error` | Échec SSH/script/terraform |

## 3. Cas d’utilisation (résumé)
- **UC001 – Connexion** (`/login`) : authentification et mémorisation de session.
- **UC002 – Réinitialisation du mot de passe** (`/forgot-password`) : envoi d’un lien ou code de reset.
- **UC003 – Inscription** (`/register`) : création de compte si l’option est activée.
- **UC004 – Tableau de bord** (`/dashboard`) : synthèse des serveurs, alertes, actions rapides.
- **UC005 – Carte infrastructure** (`/dashboard/map`) : visualisation des zones réseau (LAN, DMZ…).
- **UC006 – Alertes temps réel** (`/dashboard/alerts`) : suivi des services dégradés ou en panne.
- **UC007 – Liste des utilisateurs** (`/users`) : gestion des comptes et rôles.
- **UC008 – Ajout d’un utilisateur** (`/users/add`) : création manuelle par un administrateur.
- **UC009 – Modification d’un utilisateur** (`/users/:id/edit`) : mise à jour des informations et du rôle.
- **UC010 – Mon profil** (`/account`) : modification du mot de passe personnel.
- **UC011 – Liste des serveurs** (`/servers`) : tableau ou carte avec filtrage et actions.
- **UC012 – Détail d’un serveur** (`/servers/:id`) : fiche complète avec services et supervision.
- **UC013 – Ajout manuel d’un serveur** (`/servers/add`) : enregistrement via SSH.
- **UC014 – Modification d’un serveur** (`/servers/:id/edit`) : mise à jour des métadonnées (IP, tags, notes).
- **UC015 – Suppression d’un serveur** (`/servers/:id/delete`) : archivage ou suppression définitive.
- **UC016 – Choix du service** (`/configure/:serverId`) : sélection d’un service à configurer.
- **UC017 – Formulaire de configuration** (`/configure/:serverId/:service`) : génération de script en temps réel.
- **UC018 – Vue script généré** (`/scripts/preview/:serverId/:service`) : aperçu Bash/Ansible avant export ou déploiement.
- **UC019 – Déploiement distant** (`/deploy/:serverId`) : exécution du script et affichage des logs live.
- **UC020 – Résumé post-déploiement** (`/deploy/:serverId/summary`) : récapitulatif des actions exécutées.
- **UC021 – Création de VM** (`/provision/create`) : provisionnement automatique via Proxmox/VMware.
- **UC022 – Suivi du provisionnement** (`/provision/status/:id`) : affichage des étapes Terraform ou script.
- **UC023 – Gestion des templates de VM** (`/provision/templates`) : bibliothèque de modèles cloud‑init.
- **UC024 – Supervision globale** (`/monitor`) : vue d’ensemble des serveurs et services surveillés.
- **UC025 – Supervision d’un serveur** (`/monitor/:serverId`) : métriques détaillées et alertes.
- **UC026 – Supervision d’un service** (`/monitor/:serverId/:service`) : état du processus, ports et logs.
- **UC027 – Journal des alertes** (`/monitor/alerts`) : historique consolidé des incidents.
- **UC028 – Assistant IA global** (`/assistant`) : chat d’aide technique et suggestions.
- **UC029 – Assistant IA contextuel** (modal) : assistance intégrée selon la page et les erreurs.
- **UC030 – Journal des actions** (`/logs`) : audit global des déploiements, scripts, provisionnements.
- **UC031 – Détail d’un log** (`/logs/:id`) : stdout/stderr d’un script exécuté.
- **UC032 – Historique d’un utilisateur** (`/logs/users/:id`) : actions effectuées par un compte donné.
- **UC033 – Paramètres globaux** (`/settings`) : configuration de la supervision, des rôles, de la sécurité.
- **UC034 – Notifications** (`/settings/notifications`) : définition des canaux d’alerte.
- **UC035 – Templates de services** (`/settings/templates`) : définition des formulaires dynamiques par service.
- **UC036 – Test de template** (`/settings/templates/:id/test`) : simulation du rendu et génération de script.

## 4. Détails par interface

### UC001 – Connexion (`/login`)
**Objectif :** permettre à un utilisateur de s’authentifier.
**Composants UI :**
| Élément | Type | États possibles | Description |
|--------|------|----------------|-------------|
| Email | `input type="email"` | vide, invalide, valide | Adresse de connexion |
| Mot de passe | `input type="password"` | vide, saisi, affiché | Mot de passe utilisateur |
| Mémoriser | `checkbox` | coché/non coché | Durée de session 7j ou 24h |
| Se connecter | bouton | inactif, actif, chargement | Envoi des identifiants |
**Règles métier :** email valide, mot de passe non vide, 5 tentatives max, redirection vers `/dashboard`.
**Erreurs :** EX1 email vide, EX2 format invalide, EX3 mot de passe vide, EX4 mauvais identifiants, EX5 compte désactivé, EX6 backend indisponible.

### UC002 – Réinitialisation du mot de passe (`/forgot-password`)
**Objectif :** envoyer un lien de reset par email.
**Composants UI :** champ email, bouton envoyer, message de confirmation ou d’erreur, lien retour.
**Règles métier :** email obligatoire, message générique si email inconnu, lien valide temporairement.
**Erreurs :** email vide, format invalide, erreur d’envoi, abus de demandes.

### UC003 – Inscription (`/register`)
**Objectif :** créer un nouvel utilisateur.
**Composants UI :** nom complet, email, mot de passe, confirmation, rôle (si admin), bouton créer.
**Règles métier :** email unique, mot de passe fort (8+ caractères avec majuscule/minuscule/chiffre), confirmation identique, rôle obligatoire si admin.
**Erreurs :** email déjà utilisé, format invalide, mot de passe faible, confirmation différente, champ vide, erreur serveur.

### UC004 – Tableau de bord (`/dashboard`)
**Objectif :** vue synthétique de l’infrastructure.
**Composants UI :** widgets récapitulatifs (serveurs, services, alertes), liste des serveurs avec actions rapides, bloc alertes récentes, actions rapides globales.
**Règles métier :** rafraîchissement régulier, actions limitées selon rôle, message vide si aucun serveur.
**Erreurs :** impossible d’accéder à la base, supervision KO, aucun serveur.

### UC005 – Carte infrastructure (`/dashboard/map`)
**Objectif :** visualiser la répartition des serveurs par zones réseau.
**Composants UI :** carte avec zones LAN/DMZ/etc., icônes de serveurs, légende, filtres, rafraîchissement.
**Règles métier :** chaque serveur rattaché à une zone, alertes clignotent, clic ouvre détail.
**Erreurs :** aucun serveur, erreur de rendu, serveurs sans zone → zone inconnue.

### UC006 – Alertes temps réel (`/dashboard/alerts`)
**Objectif :** lister les alertes en cours.
**Composants UI :** tableau chronologique (gravité, serveur, service, description, état, actions), filtres par gravité/serveur/service/état.
**Règles métier :** mise à jour temps réel, redémarrage loggé, résolution nécessite justification.
**Erreurs :** aucune alerte, redémarrage échoué, connexion perdue, rôle insuffisant.

### UC007 – Liste des utilisateurs (`/users`)
**Objectif :** gérer les comptes utilisateurs.
**Composants UI :** tableau (nom, email, rôle, statut, date), actions (modifier, reset MDP, désactiver, supprimer), recherche, tri, ajout utilisateur.
**Règles métier :** accès admin, impossible de supprimer son propre compte, changements loggés.
**Erreurs :** accès refusé, aucune donnée, erreur d’action, suppression de soi-même.

### UC008 – Ajout d’un utilisateur (`/users/add`)
**Objectif :** formulaire de création de compte.
**Composants UI :** nom, email, mot de passe, confirmation, rôle, case forcer reset, bouton générer mot de passe, bouton créer.
**Règles métier :** email unique, mot de passe conforme, rôle obligatoire, bouton créer actif si valide.
**Erreurs :** email déjà utilisé, mots de passe différents, format email invalide, rôle non sélectionné, erreur serveur.

### UC009 – Modifier un utilisateur (`/users/:id/edit`)
**Objectif :** mettre à jour les infos d’un utilisateur.
**Composants UI :** formulaire pré-rempli (nom, email, rôle), actions (reset MDP, désactiver/réactiver, supprimer), bouton enregistrer.
**Règles métier :** email unique, rôle modifiable par admin, pas de suppression de soi-même.
**Erreurs :** email en doublon, format invalide, aucun changement, rôle de soi-même, dernier admin supprimé.

### UC010 – Mon profil (`/account`)
**Objectif :** modifier son mot de passe personnel.
**Composants UI :** affichage lecture seule des infos, formulaire de changement de mot de passe (actuel, nouveau, confirmation), bouton mettre à jour.
**Règles métier :** mot de passe actuel obligatoire, nouveau ≠ ancien, validation des champs.
**Erreurs :** mot de passe actuel incorrect, nouveau trop faible, confirmation différente, serveur indisponible.

### UC011 – Liste des serveurs (`/servers`)
**Objectif :** afficher et gérer tous les serveurs.
**Composants UI :** tableau ou carte (nom, IP, zone, rôle, état, supervision, services, actions), filtres, recherche, bascule vue carte.
**Règles métier :** actions selon rôle, serveurs supprimés archivables, serveurs sans zone marqués inconnus.
**Erreurs :** aucun serveur, erreur de récupération, rôle insuffisant.

### UC012 – Détail d’un serveur (`/servers/:id`)
**Objectif :** fiche complète d’un serveur.
**Composants UI :** informations générales (nom, IP, OS, zone), ressources système, services installés, supervision, actions (configurer, déployer, logs, supprimer).
**Règles métier :** infos système en lecture seule, services inactifs déclenchent alerte, droits requis pour actions.
**Erreurs :** serveur introuvable, service sans statut, chargement échoué, action non autorisée.

### UC013 – Ajouter un serveur (`/servers/add`)
**Objectif :** enregistrer un serveur via SSH.
**Composants UI :** IP, port, méthode auth (mot de passe/clé), utilisateur, zone réseau, nom personnalisé, bouton tester connexion, bouton ajouter.
**Règles métier :** unicité IP, auth bloque après 3 échecs, récupération auto OS/RAM/CPU/hostname.
**Erreurs :** connexion impossible, authentification échouée, IP déjà utilisée, clé mal formatée, OS non détecté.

### UC014 – Modifier un serveur (`/servers/:id/edit`)
**Objectif :** mettre à jour métadonnées (IP, zone, tags, notes).
**Composants UI :** formulaire pré-rempli avec nom, IP, zone, tags, notes, bouton enregistrer.
**Règles métier :** IP valide et unique, max 10 tags, notes ≤ 1000 caractères, bouton inactif sans modification.
**Erreurs :** IP invalide, IP déjà utilisée, nom obligatoire, échec enregistrement.

### UC015 – Supprimer un serveur (`/servers/:id/delete`)
**Objectif :** archiver ou supprimer définitivement un serveur.
**Composants UI :** modal de confirmation avec nom/IP, options archiver ou supprimer définitivement, champ de confirmation, boutons.
**Règles métier :** admin uniquement, supervision stoppée avant suppression, confirmation obligatoire pour purge.
**Erreurs :** confirmation incorrecte, droits insuffisants, déploiement actif, erreur base.

### UC016 – Choix du service (`/configure/:serverId`)
**Objectif :** sélectionner un service à configurer pour un serveur.
**Composants UI :** informations serveur, liste de services, bloc assistant IA, actions configurer/exporter/annuler.
**Règles métier :** un service à la fois, compatibilité zone/OS, bouton inactif sans sélection.
**Erreurs :** serveur inexistant, droits insuffisants, service déjà configuré, formulaire indisponible.

### UC017 – Formulaire de configuration (`/configure/:serverId/:service`)
**Objectif :** remplir les paramètres du service et générer le script en direct.
**Composants UI :** champs dynamiques selon template, bloc script généré, bloc assistant IA, actions exporter/déployer.
**Règles métier :** champs requis pour activer les actions, script mis à jour en temps réel, vérifications IA.
**Erreurs :** champ manquant, format invalide, incohérence, erreur de génération, service déjà actif.

### UC018 – Vue script généré (`/scripts/preview/:serverId/:service`)
**Objectif :** afficher le script Bash/Ansible avant export ou déploiement.
**Composants UI :** onglets Bash/Ansible, bloc code avec numéros de lignes, boutons exporter, déployer, modifier, aide IA.
**Règles métier :** format Bash par défaut, script régénéré après modification, bouton déployer désactivé si serveur injoignable.
**Erreurs :** format inconnu, script vide, échec génération, déploiement impossible.

### UC019 – Déploiement distant (`/deploy/:serverId`)
**Objectif :** exécuter le script sur le serveur via SSH.
**Composants UI :** informations serveur, terminal/logs live avec codes couleurs, actions arrêter, télécharger logs, redéployer, terminer.
**Règles métier :** une seule opération à la fois, captures stdout/stderr, timeout automatique.
**Erreurs :** connexion SSH échouée, permission refusée, déploiement bloqué, erreur script, timeout.

### UC020 – Résumé post-déploiement (`/deploy/:serverId/summary`)
**Objectif :** présenter le résultat du déploiement.
**Composants UI :** statut global, résumé des actions, durée, liens logs et actions suivantes (supervision, redéploiement, modification).
**Règles métier :** accessible seulement après déploiement, résumé archivé pour audit.
**Erreurs :** aucun déploiement récent, logs manquants, échec sans détail.

### UC021 – Création de VM (`/provision/create`)
**Objectif :** provisionner une VM via Proxmox/VMware.
**Composants UI :** nom, OS, CPU, RAM, disque, IP, réseau, mot de passe root, résumé, vérification IP, bouton créer.
**Règles métier :** nom unique, IP libre, disque minimal selon OS, fiche serveur auto-créée.
**Erreurs :** IP utilisée, hyperviseur inaccessible, échec de création, OS indisponible, ressources insuffisantes.

### UC022 – Suivi du provisionnement (`/provision/status/:id`)
**Objectif :** afficher les étapes de création d’une VM.
**Composants UI :** console de logs avec statut par ligne, résumé final (statut, durée, IP, hyperviseur), actions reprovisionner, retour, télécharger logs.
**Règles métier :** ID unique, logs horodatés, timeout 10 min, échec marque VM non fonctionnelle.
**Erreurs :** log inexistant, provisionnement figé, erreur hyperviseur, script mal formé.

### UC023 – Gestion des templates de VM (`/provision/templates`)
**Objectif :** gérer les modèles de VM cloud-init.
**Composants UI :** tableau des templates (nom, OS, ressources par défaut, clé SSH, réseau, dernière modif), actions voir, modifier, supprimer, dupliquer, ajouter.
**Règles métier :** nom unique, image source existante, script cloud-init valide, minimum un utilisateur.
**Erreurs :** syntaxe cloud-init invalide, clé SSH mal formatée, nom déjà pris, image introuvable.

### UC024 – Supervision globale (`/monitor`)
**Objectif :** vue d’ensemble de la supervision.
**Composants UI :** tableau/grille de serveurs (statut, services, performances), filtres zone/état/service, indicateurs globaux.
**Règles métier :** statut calculé sur tous les services, agent inactif >5 min → rouge, mise à jour live.
**Erreurs :** agents injoignables, données CPU/RAM indisponibles, filtre invalide, service non déclaré.

### UC025 – Supervision d’un serveur (`/monitor/:serverId`)
**Objectif :** suivi détaillé d’un serveur.
**Composants UI :** en-tête serveur, performances live (CPU, RAM, disque, réseau), services supervisés, alertes, historique de déploiements, actions redémarrer, voir logs, stopper supervision, exporter stats.
**Règles métier :** rafraîchissement 30 s, agent offline >5 min → indéterminé, seuils déclenchent alertes.
**Erreurs :** serveur non trouvé, agent déconnecté, valeurs indisponibles, erreur communication.

### UC026 – Supervision d’un service (`/monitor/:serverId/:service`)
**Objectif :** suivre un service spécifique.
**Composants UI :** statut systemd, ports ouverts, tests de connectivité, logs récents, actions redémarrer, voir logs, exporter, reconfigurer.
**Règles métier :** mise à jour 60 s, test de port local, logs 100 lignes, redémarrage seulement si service reconnu.
**Erreurs :** service non détecté, port fermé, agent injoignable, logs introuvables, redémarrage échoué.

### UC027 – Journal des alertes (`/monitor/alerts`)
**Objectif :** historique des incidents et anomalies.
**Composants UI :** tableau (date, niveau, serveur, service, message, état, action), filtres, détail modal.
**Règles métier :** conservation 90 jours, badge rouge pour critiques, une alerte identique max toutes les 5 min.
**Erreurs :** aucune alerte, filtre sans résultat, détail inexistant, collecte interrompue.

### UC028 – Assistant IA global (`/assistant`)
**Objectif :** chat d’aide technique.
**Composants UI :** zone de saisie, historique des messages, boutons copier/exécuter, suggestions.
**Règles métier :** réponses horodatées, commandes exécutées seulement après confirmation, conversations conservées.
**Erreurs :** IA désactivée, question vague, logs inaccessibles, commande non applicable.

### UC029 – Assistant IA contextuel (modal)
**Objectif :** assistance en contexte sur les pages clés.
**Composants UI :** icône flottante, panneau de suggestion, boutons appliquer/copier/ignorer.
**Règles métier :** affichage conditionné au contexte, une seule assistance active, actions journalisées.
**Erreurs :** aucune suggestion, aide en double, timeout IA.

### UC030 – Journal des actions (`/logs`)
**Objectif :** audit global de la plateforme.
**Composants UI :** tableau (date, action, serveur, service, utilisateur, statut, détail), filtres par période/type/serveur/service/utilisateur.
**Règles métier :** tous événements horodatés, conservation 6–12 mois, export individuel.
**Erreurs :** aucun log, log introuvable, export échoué, filtre invalide.

### UC031 – Détail d’un log (`/logs/:id`)
**Objectif :** afficher stdout/stderr d’un script exécuté.
**Composants UI :** entête contexte (script, serveur, utilisateur, date, statut, durée), blocs stdout et stderr, outils (télécharger, rechercher, analyse IA, commentaire).
**Règles métier :** log exact sans modification, erreurs mises en évidence, accès selon permissions.
**Erreurs :** log introuvable, script interrompu, analyse IA indisponible, export erreur.

### UC032 – Historique par utilisateur (`/logs/users/:id`)
**Objectif :** lister les actions d’un utilisateur.
**Composants UI :** entête utilisateur, tableau des actions (date, action, cible, détail, statut), filtres période/type/statut/cible, export.
**Règles métier :** visible par admin ou soi-même, journal conservé 6–12 mois, chaque entrée liée à log global.
**Erreurs :** utilisateur introuvable, aucun log, accès refusé, export erreur.

### UC033 – Paramètres globaux (`/settings`)
**Objectif :** configurer la plateforme.
**Composants UI :** onglets supervision, rôles/sécurité, alertes, assistant IA, réseau/provisioning; champs avec aides; bouton enregistrer, réinitialiser.
**Règles métier :** super-admin seul, validations sur valeurs, modifications loggées.
**Erreurs :** accès refusé, valeur invalide, sauvegarde échouée, redémarrage supervision différé.

### UC034 – Notifications (`/settings/notifications`)
**Objectif :** définir les canaux et règles d’alerte.
**Composants UI :** toggles de canaux (email, webhook, Slack, Telegram…), tableau paramétrage par type d’alerte, réglages de relance, bouton test, enregistrer.
**Règles métier :** méthode par type, relances max définies, webhooks doivent répondre 2xx, toutes les alertes loggées.
**Erreurs :** webhook invalide, email non délivré, configuration vide, ID utilisateur invalide, API externe KO.

### UC035 – Templates de services (`/settings/templates`)
**Objectif :** définir les champs dynamiques des formulaires de services.
**Composants UI :** sélecteur de service, éditeur JSON, aperçu dynamique du formulaire, actions prévisualiser, enregistrer, exporter, importer, réinitialiser.
**Règles métier :** un template par service, clés uniques, types HTML supportés, validations frontend.
**Erreurs :** JSON invalide, champ sans clé, type non reconnu, clé dupliquée.

### UC036 – Test de template (`/settings/templates/:id/test`)
**Objectif :** simuler le rendu du formulaire et générer un script.
**Composants UI :** formulaire généré, script Bash/Ansible en temps réel, actions télécharger, copier, analyse IA, valider.
**Règles métier :** champs requis pour script, valeurs par défaut préchargées, test multipages possible.
**Erreurs :** template introuvable, JSON mal formé, génération de script impossible, script vide.

---
Ce fichier constitue la base de travail pour l’équipe frontend. Il peut être enrichi ou complété selon l’évolution du backend et les retours des utilisateurs.
