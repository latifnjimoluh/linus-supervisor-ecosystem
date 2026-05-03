# 📊 Analyse de la Structure des Données - LinuSupervisor

Ce document détaille l'architecture de la base de données et la structure des objets manipulés par le backend de LinuSupervisor. Le système utilise **Sequelize** (ORM) pour interagir avec une base de données **PostgreSQL**.

---

## 🏗️ Architecture Globale
Le backend est structuré autour de modèles Sequelize organisés de manière granulaire. La base de données est conçue pour gérer la supervision, l'automatisation de déploiement, et la gestion des accès.

---

## 🗃️ Modèles de Données Principaux

### 1. Gestion des Utilisateurs & Accès
*   **User** (`users`) : Gère l'identité des administrateurs.
    *   *Champs clés* : `first_name`, `last_name`, `email`, `password`, `status` (actif, inactif, blocked).
    *   *Associations* : Appartient à un `Role`, possède des `UserSettings`.
*   **Role** (`roles`) & **Permission** : Système RBAC (Role-Based Access Control) pour restreindre les actions sur l'infrastructure.
*   **Token** : Gestion des jetons de rafraîchissement pour la sécurité des sessions.

### 2. Supervision & Monitoring
*   **Monitoring** (`monitorings`) : Stocke les métriques de santé des serveurs.
    *   *Champs clés* : `vm_ip`, `instance_id`, `services_status` (JSONB), `system_status` (JSONB - CPU, RAM, Disk).
    *   *Fréquence* : Enregistrements datés via `retrieved_at`.
*   **Alert** (`alerts`) : Journalisation des incidents détectés.
    *   *Champs clés* : `server`, `service`, `severity` (info, warning, critical), `status` (en_cours, resolu), `description`.

### 3. Déploiement & Automatisation
*   **Deployment** (`deployments`) : Suivi des pipelines de déploiement d'infrastructure.
    *   *Champs clés* : `project_name`, `environment`, `status` (pending, success, failed), `logs`.
*   **GeneratedScript** (`generated_scripts`) : Stockage des scripts Bash/Ansible générés dynamiquement pour l'automatisation.
    *   *Champs clés* : `script_type`, `content`, `target_host`.
*   **Template** : Modèles de configuration réutilisables pour les nouveaux serveurs.

### 4. Journalisation & Audit
*   **Log** (`logs`) : Audit complet des actions effectuées sur la plateforme pour la traçabilité de sécurité.
    *   *Champs clés* : `user_id`, `action`, `target`, `payload` (Détails de la modification).

---

## 🛠️ Spécificités Techniques
*   **JSONB** : Utilisation intensive du type JSONB de PostgreSQL pour les métriques de monitoring, permettant une flexibilité sur les types de données collectées (différents services selon les VMs).
*   **Underscored naming** : Les tables et colonnes utilisent le `snake_case` (standard PostgreSQL) tandis que les modèles Sequelize utilisent le `PascalCase`.
*   **Sécurité** : Les mots de passe sont hashés et les sessions sont gérées via des tokens sécurisés avec expiration.

---
*Document généré pour NJIMOLUH Anas Farid — Analyse Backend Mai 2026*
