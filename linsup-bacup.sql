--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ai_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_cache (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    hash character varying(64) NOT NULL,
    input_text text NOT NULL,
    response_text text NOT NULL,
    entity_type character varying(255),
    entity_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.ai_cache OWNER TO postgres;

--
-- Name: ai_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ai_cache_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_cache_id_seq OWNER TO postgres;

--
-- Name: ai_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ai_cache_id_seq OWNED BY public.ai_cache.id;


--
-- Name: assigned_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assigned_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.assigned_permissions OWNER TO postgres;

--
-- Name: converted_vms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.converted_vms (
    id integer NOT NULL,
    vm_name character varying(255) NOT NULL,
    vm_id character varying(255) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.converted_vms OWNER TO postgres;

--
-- Name: converted_vms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.converted_vms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.converted_vms_id_seq OWNER TO postgres;

--
-- Name: converted_vms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.converted_vms_id_seq OWNED BY public.converted_vms.id;


--
-- Name: deletes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deletes (
    id integer NOT NULL,
    vm_id character varying(255) NOT NULL,
    instance_id character varying(255),
    vm_name character varying(255),
    vm_ip character varying(255),
    log_path character varying(255),
    user_id integer,
    user_email character varying(255),
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.deletes OWNER TO postgres;

--
-- Name: deletes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deletes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deletes_id_seq OWNER TO postgres;

--
-- Name: deletes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deletes_id_seq OWNED BY public.deletes.id;


--
-- Name: deployments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deployments (
    id integer NOT NULL,
    user_id integer,
    user_email character varying(255),
    vm_name character varying(255),
    service_name character varying(255),
    zone character varying(50),
    operation_type character varying(50),
    started_at timestamp with time zone,
    ended_at timestamp with time zone,
    duration character varying(50),
    success boolean,
    log_path character varying(255),
    vm_id character varying(255),
    vm_ip character varying(255),
    instance_id character varying(255),
    injected_files json,
    vm_specs json,
    status character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.deployments OWNER TO postgres;

--
-- Name: deployments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deployments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deployments_id_seq OWNER TO postgres;

--
-- Name: deployments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deployments_id_seq OWNED BY public.deployments.id;


--
-- Name: generated_scripts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.generated_scripts (
    id integer NOT NULL,
    template_id integer NOT NULL,
    category character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    script_path text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    abs_path character varying
);


ALTER TABLE public.generated_scripts OWNER TO postgres;

--
-- Name: generated_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.generated_scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.generated_scripts_id_seq OWNER TO postgres;

--
-- Name: generated_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.generated_scripts_id_seq OWNED BY public.generated_scripts.id;


--
-- Name: initialization_scripts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.initialization_scripts (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    script_path character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.initialization_scripts OWNER TO postgres;

--
-- Name: initialization_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.initialization_scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.initialization_scripts_id_seq OWNER TO postgres;

--
-- Name: initialization_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.initialization_scripts_id_seq OWNED BY public.initialization_scripts.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    user_id integer,
    action character varying(255) NOT NULL,
    details text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: monitored_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monitored_services (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    script_path character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.monitored_services OWNER TO postgres;

--
-- Name: monitored_services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monitored_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monitored_services_id_seq OWNER TO postgres;

--
-- Name: monitored_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monitored_services_id_seq OWNED BY public.monitored_services.id;


--
-- Name: monitoring_scripts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monitoring_scripts (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    script_path character varying(255) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.monitoring_scripts OWNER TO postgres;

--
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monitoring_scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monitoring_scripts_id_seq OWNER TO postgres;

--
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monitoring_scripts_id_seq OWNED BY public.monitoring_scripts.id;


--
-- Name: monitorings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monitorings (
    id integer NOT NULL,
    vm_ip character varying(255),
    ip_address character varying(255),
    instance_id character varying(255),
    services_status json,
    system_status json,
    retrieved_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.monitorings OWNER TO postgres;

--
-- Name: monitorings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monitorings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monitorings_id_seq OWNER TO postgres;

--
-- Name: monitorings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monitorings_id_seq OWNED BY public.monitorings.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    status character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: service_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    category character varying(255) NOT NULL,
    description text,
    template_content text NOT NULL,
    script_path character varying(255),
    fields_schema json,
    status character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    abs_path character varying
);


ALTER TABLE public.service_templates OWNER TO postgres;

--
-- Name: service_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_templates_id_seq OWNER TO postgres;

--
-- Name: service_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_templates_id_seq OWNED BY public.service_templates.id;


--
-- Name: user_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_settings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    cloudinit_user character varying(255),
    cloudinit_password character varying(255),
    proxmox_api_url character varying(255),
    proxmox_api_token_id character varying(255),
    proxmox_api_token_name character varying(255),
    proxmox_api_token_secret character varying(255),
    pm_user character varying(255),
    pm_password character varying(255),
    proxmox_node character varying(255),
    vm_storage character varying(255),
    vm_bridge character varying(255),
    ssh_public_key_path character varying(255),
    ssh_private_key_path character varying(255),
    statuspath character varying(255),
    servicespath character varying(255),
    instanceinfopath character varying(255),
    proxmox_host character varying(255),
    proxmox_ssh_user character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_settings OWNER TO postgres;

--
-- Name: user_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_settings_id_seq OWNER TO postgres;

--
-- Name: user_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_settings_id_seq OWNED BY public.user_settings.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(255),
    password character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying,
    reset_token character varying(255),
    reset_expires_at timestamp with time zone,
    last_password_reset_at timestamp with time zone,
    role_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: ai_cache id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_cache ALTER COLUMN id SET DEFAULT nextval('public.ai_cache_id_seq'::regclass);


--
-- Name: converted_vms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.converted_vms ALTER COLUMN id SET DEFAULT nextval('public.converted_vms_id_seq'::regclass);


--
-- Name: deletes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deletes ALTER COLUMN id SET DEFAULT nextval('public.deletes_id_seq'::regclass);


--
-- Name: deployments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployments ALTER COLUMN id SET DEFAULT nextval('public.deployments_id_seq'::regclass);


--
-- Name: generated_scripts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generated_scripts ALTER COLUMN id SET DEFAULT nextval('public.generated_scripts_id_seq'::regclass);


--
-- Name: initialization_scripts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initialization_scripts ALTER COLUMN id SET DEFAULT nextval('public.initialization_scripts_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: monitored_services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitored_services ALTER COLUMN id SET DEFAULT nextval('public.monitored_services_id_seq'::regclass);


--
-- Name: monitoring_scripts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring_scripts ALTER COLUMN id SET DEFAULT nextval('public.monitoring_scripts_id_seq'::regclass);


--
-- Name: monitorings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitorings ALTER COLUMN id SET DEFAULT nextval('public.monitorings_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: service_templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_templates ALTER COLUMN id SET DEFAULT nextval('public.service_templates_id_seq'::regclass);


--
-- Name: user_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_settings ALTER COLUMN id SET DEFAULT nextval('public.user_settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ai_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_cache (id, type, hash, input_text, response_text, entity_type, entity_id, created_at, updated_at) FROM stdin;
1	analyze_script	9765050c14cece2be366e3c64f639b94e05c42a7d2c3218e0d63c813ba30e746	#!/bin/bash\nsudo apt update	Absolument. Voici une analyse détaillée et des propositions d'amélioration pour ce script.\n\n---\n\n### 1. Analyse du script et améliorations possibles\n\nLe script est simple et fonctionnel pour son objectif unique : lancer `apt update`. Cependant, il lui manque plusieurs caractéristiques d'un script robuste et bien conçu.\n\n**Problèmes et points d'amélioration :**\n\n1.  **Gestion des erreurs :** Si la commande `apt update` échoue (par exemple, pas de connexion Internet, un dépôt est inaccessible), le script s'arrêtera, mais sans indiquer explicitement qu'une erreur s'est produite. Un bon script doit capturer les erreurs et se terminer proprement.\n2.  **Gestion des privilèges :** Le script utilise `sudo` à l'intérieur. La pratique standard est plutôt de vérifier si le script est lancé avec les privilèges nécessaires (en tant que `root`) et de laisser l'utilisateur le lancer avec `sudo` (`sudo ./mon_script.sh`). Cela rend le comportement plus prévisible.\n3.  **Portabilité du Shebang :** `#!/bin/bash` suppose que l'interpréteur bash se trouve toujours dans `/bin/bash`. Sur certains systèmes, il peut être dans `/usr/bin/bash` ou ailleurs. L'utilisation de `#!/usr/bin/env bash` est plus portable car elle cherche `bash` dans le `PATH` de l'utilisateur.\n4.  **Feedback utilisateur :** Le script s'exécute sans informer l'utilisateur de ce qu'il fait. Ajouter des messages simples (`echo`) pour indiquer le début et la fin des opérations est une bonne pratique.\n5.  **Non-interactivité :** Bien que `apt update` ne soit généralement pas interactif, si vous étendiez ce script pour inclure `apt upgrade`, le système demanderait une confirmation (Y/n), bloquant l'exécution. Il est donc sage de prévoir des options non interactives comme `-y`.\n\n---\n\n### 2. Alternatives ou pratiques modernes\n\nExécuter manuellement un script pour les mises à jour est une méthode viable, mais pour des environnements de serveurs ou pour une gestion rigoureuse, des approches plus modernes et automatisées sont préférables.\n\n1.  **Tâches planifiées (Cron / Systemd Timers)**\n    *   **Cron :** L'approche classique. On peut ajouter une tâche au `crontab` pour exécuter le script de mise à jour automatiquement (par exemple, tous les jours à 3h du matin).\n        ```bash\n        # crontab -e\n        0 3 * * * /chemin/vers/votre/script_optimise.sh > /var/log/update.log 2>&1\n        ```\n    *   **Systemd Timers :** L'alternative moderne à `cron` sur la plupart des distributions Linux récentes (dont Ubuntu). Ils offrent plus de flexibilité et une meilleure intégration avec le système de journalisation (`journalctl`).\n\n2.  **Le paquet `unattended-upgrades`**\n    *   C'est **la solution native et recommandée** sur les systèmes Debian/Ubuntu pour automatiser les mises à jour, en particulier celles de sécurité. Une fois configuré, il gère le téléchargement et l'installation des mises à jour de manière autonome et sécurisée, sans nécessiter de script personnalisé.\n    *   Pour l'installer et l'activer :\n        ```bash\n        sudo apt install unattended-upgrades\n        sudo dpkg-reconfigure -plow unattended-upgrades\n        ```\n\n3.  **Outils de gestion de configuration (Ansible, Puppet, Chef)**\n    *   Pour gérer un parc de plusieurs serveurs, ces outils sont la norme. Ils permettent de décrire l'état souhaité d'un système ("le paquet `nginx` doit être installé et le système à jour") de manière déclarative.\n    *   **Exemple avec Ansible :** On n'écrit pas un script bash, mais un "playbook" en YAML.\n        ```yaml\n        ---\n        - hosts: all\n          become: yes  # Équivalent de sudo\n          tasks:\n            - name: Update apt repo and cache\n              apt:\n                update_cache: yes\n                cache_valid_time: 3600 # Met à jour si le cache a plus d'une heure\n\n            - name: Upgrade all apt packages to the latest version\n              apt:\n                upgrade: dist # "dist" est plus prudent que "full"\n        ```\n    Cette approche est idempotente (l'exécuter plusieurs fois produit le même résultat), plus lisible et scalable.\n\n---\n\n### 3. Version optimisée du script\n\nVoici une version du script initial qui intègre les améliorations discutées. Ce script est plus robuste, plus sûr et plus informatif.\n\n```bash\n#!/usr/bin/env bash\n\n#\n# script_update_system.sh\n#\n# Description : Met à jour la liste des paquets disponibles (apt update).\n# Auteur : [Votre Nom]\n# Date : [Date du jour]\n#\n# Utilisation : sudo ./script_update_system.sh\n#\n\n# --- Configuration de la sécurité du script ---\n# set -e : Quitte immédiatement si une commande échoue.\n# set -u : Traite les variables non définies comme une erreur.\n# set -o pipefail : Fait échouer un pipeline si l'une de ses commandes échoue.\nset -euo pipefail\n\n# --- Fonctions ---\n\n# Affiche un message d'information\nlog_info() {\n    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"\n}\n\n# Affiche un message d'erreur et quitte\nlog_error() {\n    echo "[ERREUR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2\n    exit 1\n}\n\n# --- Script principal ---\n\nmain() {\n    # 1. Vérifier si le script est exécuté avec les privilèges root (sudo)\n    if [[ "${EUID}" -ne 0 ]]; then\n        log_error "Ce script doit être exécuté avec les privilèges root. Utilisez 'sudo'."\n    fi\n\n    # 2. Informer l'utilisateur du début du processus\n    log_info "Lancement de la mise à jour des listes de paquets..."\n\n    # 3. Exécuter la commande de mise à jour\n    # L'option -y n'est pas nécessaire pour `update` mais est une bonne pratique si on ajoute `upgrade`.\n    # Nous redirigeons la sortie vers /dev/null pour un affichage propre,\n    # mais en cas d'erreur, `set -e` arrêtera le script.\n    if apt-get update -y >/dev/null; then\n        log_info "Mise à jour des listes de paquets terminée avec succès."\n    else\n        # Cette partie n'est atteinte que si `set -e` est désactivé,\n        # mais c'est une bonne pratique pour la robustesse.\n        log_error "La commande 'apt-get update' a échoué."\n    fi\n\n    # 4. Message de fin\n    log_info "Script terminé."\n}\n\n# Lancement de la fonction principale\nmain\n```\n\n#### Qu'est-ce que cette version optimisée apporte ?\n\n1.  **Robustesse** : `set -euo pipefail` assure que le script s'arrête proprement à la moindre erreur.\n2.  **Sécurité** : La vérification `[[ "${EUID}" -ne 0 ]]` garantit que le script ne s'exécute que s'il a les bons privilèges.\n3.  **Clarté** : Les fonctions `log_info` et `log_error` et les messages `echo` rendent le script lisible et facile à déboguer.\n4.  **Bonnes pratiques** : Utilisation de `apt-get` (souvent préféré dans les scripts pour sa stabilité d'interface), et commentaires expliquant l'objectif et l'utilisation du script.\n5.  **Extensibilité** : La structure avec une fonction `main` facilite l'ajout de nouvelles fonctionnalités (par exemple, une fonction pour `apt upgrade`, une autre pour le nettoyage avec `autoremove`, etc.).	\N	\N	2025-08-07 04:16:53.819+01	2025-08-07 04:16:53.819+01
2	explain_variables	970f8684676a8125a124a348f9d5cfa28ffaae7f85e2fffae2626f632ddbf657	#!/bin/bash\nexport VAR={{VALUE}}	Bien sûr. Voici l'explication concise pour ce template.\n\n---\n\nDans ce template, vous devez renseigner deux éléments :\n\n*   `VAR` : Le **nom** de la variable d'environnement que vous souhaitez créer.\n*   `{{VALUE}}` : La **valeur** que vous voulez assigner à cette variable.\n\nLa commande `export` rend cette variable accessible à tous les programmes ou scripts qui seront lancés depuis ce terminal après l'exécution du script.\n\n**Exemple :**\n\nSi vous remplacez `VAR` par `API_KEY` et `{{VALUE}}` par `"abc123xyz"`, le script deviendra :\n\n```bash\n#!/bin/bash\nexport API_KEY="abc123xyz"\n```	\N	\N	2025-08-07 04:19:31.251+01	2025-08-07 04:19:31.251+01
3	analyze_script	5d0429fa78461a77fb3b71dc686c3572350b9e8fb7b3c9bc2cb48a4870670434	#!/bin/bash\\nsudo apt update		\N	\N	2025-08-07 04:58:08.369+01	2025-08-07 04:58:08.369+01
\.


--
-- Data for Name: assigned_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assigned_permissions (role_id, permission_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
1	9
1	10
1	11
1	12
1	13
1	14
1	15
1	16
1	17
1	18
1	19
1	20
1	21
1	22
1	23
1	24
1	25
1	26
1	27
1	28
1	29
1	30
1	31
1	32
1	33
1	34
1	35
1	36
1	37
1	38
1	39
1	40
1	41
1	42
1	43
1	45
1	46
1	47
1	48
1	49
1	50
1	51
1	52
1	53
1	54
\.


--
-- Data for Name: converted_vms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.converted_vms (id, vm_name, vm_id, user_id, created_at, updated_at) FROM stdin;
1	vm1	101	1	2025-08-06 04:39:32.331972+01	2025-08-06 04:39:32.331972+01
2	vm_104	104	1	2025-08-06 05:27:07.096+01	2025-08-06 05:27:07.096+01
\.


--
-- Data for Name: deletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deletes (id, vm_id, instance_id, vm_name, vm_ip, log_path, user_id, user_email, deleted_at, created_at, updated_at) FROM stdin;
1	101	inst-0001	vm-101	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T03-43-31-880Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 04:43:34.934+01	2025-08-06 04:43:34.935+01	2025-08-06 04:43:34.935+01
2	101	inst-0001	web-01	192.168.24.76	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T03-43-53-746Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 04:43:56.205+01	2025-08-06 04:43:56.205+01	2025-08-06 04:43:56.205+01
3	103	inst-0001	web-02	192.168.24.77	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T03-44-07-921Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 04:44:10.386+01	2025-08-06 04:44:10.386+01	2025-08-06 04:44:10.386+01
4	101	inst-0001	web-01	192.168.24.79	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T03-59-51-944Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 04:59:54.39+01	2025-08-06 04:59:54.39+01	2025-08-06 04:59:54.39+01
5	101	inst-0001	web-001	192.168.24.80	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-02-33-675Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:02:36.107+01	2025-08-06 05:02:36.108+01	2025-08-06 05:02:36.108+01
6	101	inst-0001	web-0001	192.168.24.81	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-26-19-168Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:26:21.56+01	2025-08-06 05:26:21.56+01	2025-08-06 05:26:21.56+01
7	103	inst-0001	web-01	192.168.24.82	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-26-28-228Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:26:30.604+01	2025-08-06 05:26:30.604+01	2025-08-06 05:26:30.604+01
8	104	inst-0001	web-03	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-34-10-718Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:34:10.837+01	2025-08-06 05:34:10.837+01	2025-08-06 05:34:10.837+01
9	101	inst-0001	web-02	192.168.24.83	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-34-15-743Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:34:18.157+01	2025-08-06 05:34:18.157+01	2025-08-06 05:34:18.157+01
10	101	inst-0001	web-10	192.168.24.84	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-52-43-649Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:52:46.064+01	2025-08-06 05:52:46.064+01	2025-08-06 05:52:46.064+01
11	103	inst-0001	web-110	192.168.24.85	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-52-47-779Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:52:50.159+01	2025-08-06 05:52:50.159+01	2025-08-06 05:52:50.159+01
12	104	inst-0001	w0	192.168.24.86	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T04-52-52-124Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 05:52:54.498+01	2025-08-06 05:52:54.499+01	2025-08-06 05:52:54.499+01
13	103	inst-0001	tss	192.168.24.88	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T05-11-44-433Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 06:11:46.937+01	2025-08-06 06:11:46.937+01	2025-08-06 06:11:46.937+01
14	101	inst-0001	ts	192.168.24.87	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T05-11-51-976Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 06:11:54.374+01	2025-08-06 06:11:54.375+01	2025-08-06 06:11:54.375+01
15	101	inst-0001	tes2023	192.168.24.89	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T10-21-11-818Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 11:21:14.204+01	2025-08-06 11:21:14.205+01	2025-08-06 11:21:14.205+01
16	103	inst-0001	tes20273	192.168.24.90	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T10-21-16-593Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 11:21:19.041+01	2025-08-06 11:21:19.041+01	2025-08-06 11:21:19.041+01
17	101	inst-0001	test	192.168.24.91	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T11-12-42-906Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 12:12:45.278+01	2025-08-06 12:12:45.278+01	2025-08-06 12:12:45.278+01
18	103	inst-0001	sdsf	192.168.24.92	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T11-12-50-373Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 12:12:52.751+01	2025-08-06 12:12:52.751+01	2025-08-06 12:12:52.751+01
19	104	inst-0001	yedb	192.168.24.93	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T11-12-54-994Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 12:12:57.36+01	2025-08-06 12:12:57.36+01	2025-08-06 12:12:57.36+01
20	101	inst-0001	test1	192.168.24.94	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T11-31-47-067Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 12:31:49.479+01	2025-08-06 12:31:49.479+01	2025-08-06 12:31:49.479+01
21	103	inst-0001	web1	192.168.24.95	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T11-31-51-422Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 12:31:53.84+01	2025-08-06 12:31:53.84+01	2025-08-06 12:31:53.84+01
22	101	inst-0001	web12	192.168.24.96	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T12-34-36-613Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 13:34:39.091+01	2025-08-06 13:34:39.091+01	2025-08-06 13:34:39.091+01
23	103	inst-0001	webtest	192.168.24.97	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T12-34-44-004Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 13:34:46.398+01	2025-08-06 13:34:46.398+01	2025-08-06 13:34:46.398+01
24	104	inst-0001	webtes2t	192.168.24.98	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T12-34-48-088Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 13:34:50.432+01	2025-08-06 13:34:50.432+01	2025-08-06 13:34:50.432+01
25	101	inst-0001	webtes2t	192.168.24.99	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T12-51-32-270Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 13:51:34.668+01	2025-08-06 13:51:34.669+01	2025-08-06 13:51:34.669+01
26	101	inst-0001	web	192.168.24.200	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T13-05-23-736Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 14:05:26.178+01	2025-08-06 14:05:26.178+01	2025-08-06 14:05:26.178+01
27	103	inst-0001	we02b	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\delete-2025-08-06T13-05-28-775Z-1.log	1	latifnjimoluh@gmail.com	2025-08-06 14:05:28.898+01	2025-08-06 14:05:28.898+01	2025-08-06 14:05:28.898+01
\.


--
-- Data for Name: deployments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deployments (id, user_id, user_email, vm_name, service_name, zone, operation_type, started_at, ended_at, duration, success, log_path, vm_id, vm_ip, instance_id, injected_files, vm_specs, status, created_at, updated_at) FROM stdin;
1	1	latifnjimoluh@gmail.com	vm1	service1	LAN	create	\N	\N	\N	t	\N	\N	\N	inst-0001	\N	\N	\N	2025-08-06 04:39:32.369199+01	2025-08-06 04:39:32.369199+01
2	1	latifnjimoluh@gmail.com	tes2023	web	LAN	apply	2025-08-06 09:59:32.654+01	2025-08-06 10:01:27.024+01	114.37s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T08-59-32-654Z-1.log	101	192.168.24.89	90c1de06-5101-4ed7-a500-0ad0006cb3cb	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 10:01:27.025+01	2025-08-06 10:01:27.025+01
3	1	latifnjimoluh@gmail.com	yedb	web	LAN	apply	2025-08-06 12:08:15.284+01	2025-08-06 12:10:16.111+01	120.827s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-08-15-284Z-1.log	104	192.168.24.93	387b2866-50c6-4c89-98f0-8db4125d137d	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:10:16.117+01	2025-08-06 12:10:16.117+01
4	1	latifnjimoluh@gmail.com	test1	web	LAN	apply	2025-08-06 12:17:15.327+01	2025-08-06 12:19:19.158+01	123.831s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-17-15-327Z-1.log	101	192.168.24.94	505bb44b-f327-47f7-a2d2-5fb231456c2f	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:19:19.159+01	2025-08-06 12:19:19.159+01
5	1	latifnjimoluh@gmail.com	web1	web	LAN	apply	2025-08-06 12:21:48.614+01	2025-08-06 12:26:23.835+01	275.221s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-21-48-614Z-1.log	103	192.168.24.95	9a9db055-86a2-4dff-a5be-f963756614c7	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:26:23.837+01	2025-08-06 12:26:23.837+01
6	1	latifnjimoluh@gmail.com	web12	web	LAN	apply	2025-08-06 12:31:32.685+01	2025-08-06 12:35:01.198+01	208.513s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-31-32-685Z-1.log	101	192.168.24.96	9fb15047-d841-4d06-b4ac-861ac93fe350	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:35:01.2+01	2025-08-06 12:35:01.2+01
7	1	latifnjimoluh@gmail.com	webtest	web	LAN	apply	2025-08-06 13:23:42.706+01	2025-08-06 13:25:42.865+01	120.159s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T12-23-42-706Z-1.log	103	192.168.24.97	3c634098-a504-4bcf-a13d-f0f807a7e0e7	["/scripts/generated/web/web_server_nginx_web_D_ploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_G_n_ration_du_script_script001.sh","/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_syst_me_-_G_n_ration_du_script_script001.sh","/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 13:25:42.869+01	2025-08-06 13:25:42.869+01
8	1	latifnjimoluh@gmail.com	webtes2t	web	LAN	apply	2025-08-06 13:28:12.098+01	2025-08-06 13:30:11.48+01	119.382s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T12-28-12-098Z-1.log	104	192.168.24.98	77f999e8-8948-4a8b-8254-c51f6adbdfdb	["/scripts/generated/web/004.sh","/scripts/generated/monitoring/003.sh","/scripts/generated/monitoring/002.sh","/scripts/generated/monitoring/001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 13:30:11.482+01	2025-08-06 13:30:11.482+01
9	1	latifnjimoluh@gmail.com	webtes2t	web	LAN	apply	2025-08-06 13:49:13.238+01	2025-08-06 13:51:06.001+01	112.763s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T12-49-13-238Z-1.log	101	192.168.24.99	8cc9e726-5696-4665-a7fc-3db9b56c84f6	["/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 13:51:06.003+01	2025-08-06 13:51:06.003+01
10	1	latifnjimoluh@gmail.com	we0w2b	web	LAN	apply	2025-08-06 14:02:25.881+01	2025-08-06 14:05:44.292+01	198.411s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T13-02-25-881Z-1.log	104	192.168.24.201	d45d414b-a18d-4f3a-9a97-c84d8d4417c5	["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 14:05:44.296+01	2025-08-06 14:05:44.296+01
11	1	latifnjimoluh@gmail.com	Webapache	web	LAN	apply	2025-08-06 14:16:15.333+01	2025-08-06 14:19:38.683+01	203.35s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T13-16-15-333Z-1.log	101	192.168.24.202	64072c58-458d-4b76-a264-ad763d3be64c	["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 14:19:38.687+01	2025-08-06 14:19:38.687+01
\.


--
-- Data for Name: generated_scripts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.generated_scripts (id, template_id, category, service_type, script_path, description, created_at, updated_at, abs_path) FROM stdin;
18	21	monitoring	monitoring_cron	/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script002.sh	Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.	2025-08-06 14:09:09.573+01	2025-08-06 14:09:09.573+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script002.sh
19	21	monitoring	monitoring_cron	/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script003.sh	Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.	2025-08-06 14:13:15.214+01	2025-08-06 14:13:15.214+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script003.sh
20	21	monitoring	monitoring_cron	/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.	2025-08-06 14:13:48.302+01	2025-08-06 14:13:48.302+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh
21	20	monitoring	system_monitoring_script	/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh	Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh	2025-08-06 14:14:28.597+01	2025-08-06 14:14:28.597+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh
9	14	file_sharing	nfs_client	/scripts/generated/file_sharing/nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh	Installe le client NFS et monte un partage distant automatiquement.	2025-08-06 13:45:14.603+01	2025-08-06 13:45:14.603+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\file_sharing\\nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh
10	13	file_sharing	nfs_server	/scripts/generated/file_sharing/nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh	Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.	2025-08-06 13:45:30.734+01	2025-08-06 13:45:30.734+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\file_sharing\\nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh
11	15	dns	dns_slave	/scripts/generated/dns/dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh	Installe et configure un serveur DNS esclave avec BIND9, prêt à recevoir les zones depuis le DNS maître.	2025-08-06 13:45:52.928+01	2025-08-06 13:45:52.928+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\dns\\dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh
12	16	dns	dns_master	/scripts/generated/dns/dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh	Installe et configure un serveur DNS maître avec BIND9, en définissant plusieurs zones et en autorisant le transfert vers le serveur esclave.	2025-08-06 13:46:16.618+01	2025-08-06 13:46:16.618+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\dns\\dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh
13	17	api	flask_api	/scripts/generated/api/flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.	2025-08-06 13:46:53.528+01	2025-08-06 13:46:53.528+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\api\\flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh
14	18	web	web_server_nginx	/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.	2025-08-06 13:47:14.85+01	2025-08-06 13:47:14.85+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\web\\web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh
15	19	monitoring	service_monitoring_script	/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh	Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh	2025-08-06 13:47:41.359+01	2025-08-06 13:47:41.359+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh
16	20	monitoring	system_monitoring_script	/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh	Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh	2025-08-06 13:48:01.896+01	2025-08-06 13:48:01.896+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh
17	21	monitoring	monitoring_cron	/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.	2025-08-06 13:48:27.991+01	2025-08-06 13:48:27.991+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh
22	19	monitoring	service_monitoring_script	/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh	Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh	2025-08-06 14:14:49.023+01	2025-08-06 14:14:49.023+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\monitoring\\service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh
23	18	web	web_server_nginx	/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.	2025-08-06 14:15:06.221+01	2025-08-06 14:15:06.221+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\web\\web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh
24	17	api	flask_api	/scripts/generated/api/flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.	2025-08-06 14:17:04.737+01	2025-08-06 14:17:04.737+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\api\\flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh
25	16	dns	dns_master	/scripts/generated/dns/dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh	Installe et configure un serveur DNS maître avec BIND9, en définissant plusieurs zones et en autorisant le transfert vers le serveur esclave.	2025-08-06 14:18:10.501+01	2025-08-06 14:18:10.501+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\dns\\dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh
26	15	dns	dns_slave	/scripts/generated/dns/dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh	Installe et configure un serveur DNS esclave avec BIND9, prêt à recevoir les zones depuis le DNS maître.	2025-08-06 14:18:31.855+01	2025-08-06 14:18:31.855+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\dns\\dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh
27	13	file_sharing	nfs_server	/scripts/generated/file_sharing/nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh	Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.	2025-08-06 14:18:50.535+01	2025-08-06 14:18:50.535+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\file_sharing\\nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh
28	14	file_sharing	nfs_client	/scripts/generated/file_sharing/nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh	Installe le client NFS et monte un partage distant automatiquement.	2025-08-06 14:19:05.439+01	2025-08-06 14:19:05.439+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\generated\\file_sharing\\nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh
\.


--
-- Data for Name: initialization_scripts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.initialization_scripts (id, name, script_path, description, created_at, updated_at) FROM stdin;
1	Ubuntu Base Setup	scripts/init.sh	Update packages and install base utilities	2025-08-06 04:39:32.352314+01	2025-08-06 04:39:32.352314+01
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, user_id, action, details, created_at) FROM stdin;
1	1	login	User logged in	2025-08-06 04:39:32.335271+01
2	\N	POST /auth/request-reset	{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}	2025-08-06 04:40:00.778+01
3	1	request_reset_code	{"user_id":1}	2025-08-06 04:40:05.894+01
4	\N	POST /auth/reset-password	{"body":{"code":"803327","password":"admin123."},"query":{}}	2025-08-06 04:41:00.176+01
5	1	reset_password	{"user_id":1}	2025-08-06 04:41:00.381+01
6	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 04:41:20.772+01
7	1	login	{"user_id":1}	2025-08-06 04:41:20.984+01
8	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:42:51.187+01
9	1	PUT /settings/me	{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"mytoken","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/tmp/status.json","servicespath":"/tmp/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}	2025-08-06 04:43:25.502+01
10	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:43:31.871+01
11	1	PUT /settings/me	{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"delete","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/tmp/status.json","servicespath":"/tmp/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}	2025-08-06 04:43:50.307+01
12	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:43:53.736+01
13	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:44:07.91+01
14	1	GET /auth/reset-history	{"query":{}}	2025-08-06 04:44:41.003+01
15	1	view_reset_history	{}	2025-08-06 04:44:41.015+01
16	1	GET /roles	{"query":{}}	2025-08-06 04:44:58.142+01
17	1	GET /roles/1	{"query":{}}	2025-08-06 04:45:04.94+01
18	1	POST /permissions	{"body":{"name":"test","description":"test posts"},"query":{}}	2025-08-06 04:45:33.666+01
19	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}	2025-08-06 04:45:50.077+01
20	1	GET /permissions/role/1	{"query":{}}	2025-08-06 04:46:00.952+01
21	1	POST /permissions/unassign	{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}	2025-08-06 04:46:16.479+01
22	1	POST /permissions/unassign	{"body":[{"role_id":1,"permission_ids":44}],"query":{}}	2025-08-06 04:46:51.809+01
23	1	DELETE /permissions/44	{"query":{}}	2025-08-06 04:47:55.707+01
24	1	GET /logs	{"query":{}}	2025-08-06 04:48:09.209+01
25	1	GET /settings/me	{"query":{}}	2025-08-06 04:48:24.116+01
26	1	GET /vms	{"query":{}}	2025-08-06 04:48:30.921+01
27	1	list_vms	{}	2025-08-06 04:48:30.945+01
28	1	POST /vms/check-status	{"body":{"vm_id":104},"query":{}}	2025-08-06 04:50:00.417+01
29	1	POST /vms/check-status	{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}	2025-08-06 04:50:36.826+01
30	1	check_vm_status	{"vm_id":104,"vm_status":"running","ping_ok":true}	2025-08-06 04:50:36.948+01
31	1	POST /vms/104/stop	{"query":{}}	2025-08-06 04:51:02.049+01
32	1	stop_vm:104	{}	2025-08-06 04:51:02.099+01
33	1	POST /vms/check-status	{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}	2025-08-06 04:51:16.897+01
34	1	check_vm_status	{"vm_id":104,"vm_status":"stopped","ping_ok":false}	2025-08-06 04:51:21.552+01
35	1	POST /vms/104/start	{"query":{}}	2025-08-06 04:51:34.177+01
36	1	start_vm:104	{}	2025-08-06 04:51:34.234+01
37	1	POST /vms/check-status	{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}	2025-08-06 04:51:37.87+01
38	1	check_vm_status	{"vm_id":104,"vm_status":"running","ping_ok":false}	2025-08-06 04:51:40.548+01
39	1	GET /templates	{"query":{}}	2025-08-06 04:51:52.614+01
40	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:59:51.934+01
41	1	Échec Déploiement Terraform	{}	2025-08-06 05:00:13.147+01
42	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:02:33.657+01
43	1	POST /permissions/unassign	{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}	2025-08-06 05:10:04.108+01
44	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:26:19.154+01
45	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:26:28.221+01
46	1	POST /vms/convert	{"body":{"vm_id":104},"query":{}}	2025-08-06 05:26:44.785+01
47	1	Échec Déploiement Terraform	{}	2025-08-06 05:26:49.252+01
48	1	convert_vm_template	{"vm_id":104}	2025-08-06 05:27:07.192+01
49	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:34:10.707+01
50	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:34:15.734+01
51	1	Échec Déploiement Terraform	{}	2025-08-06 05:34:27.3+01
52	1	Échec Déploiement Terraform	{}	2025-08-06 05:34:35.77+01
53	1	Échec Déploiement Terraform	{}	2025-08-06 05:36:34.655+01
54	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 05:43:26.289+01
55	1	login	{"user_id":1}	2025-08-06 05:43:26.497+01
56	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:52:43.634+01
57	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:52:47.77+01
58	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:52:52.116+01
59	1	Échec Déploiement Terraform	{}	2025-08-06 05:53:04.254+01
60	1	Échec Déploiement Terraform	{}	2025-08-06 05:53:09.288+01
61	1	Échec Déploiement Terraform	{}	2025-08-06 05:53:15.962+01
62	1	Échec Déploiement Terraform	{}	2025-08-06 06:10:43.953+01
63	1	Échec Déploiement Terraform	{}	2025-08-06 06:11:02.051+01
64	1	Échec Déploiement Terraform	{"error":"initCmd is not defined"}	2025-08-06 06:11:27.723+01
65	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 06:11:44.41+01
66	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 06:11:51.965+01
67	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 09:52:25.362+01
68	1	login	{"user_id":1}	2025-08-06 09:52:25.737+01
69	1	Échec Déploiement Terraform	{}	2025-08-06 09:53:08.949+01
70	1	Échec Déploiement Terraform	{}	2025-08-06 09:56:53.324+01
71	1	Déploiement Terraform	{"vm_name":"tes2023","service_type":"web","success":true}	2025-08-06 10:01:27.107+01
72	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 11:03:19.433+01
73	1	login	{"user_id":1}	2025-08-06 11:03:19.669+01
74	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 11:21:11.799+01
75	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 11:21:16.586+01
76	1	Déploiement Terraform	{"vm_name":"yedb","service_type":"web","success":true}	2025-08-06 12:10:16.223+01
77	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:12:42.896+01
78	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:12:50.365+01
79	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:12:54.986+01
80	1	Échec Déploiement Terraform	{}	2025-08-06 12:13:11.409+01
81	1	PUT /settings/me	{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"delete","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/opt/monitoring/status.json","servicespath":"/opt/monitoring/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}	2025-08-06 12:17:39.926+01
82	1	Déploiement Terraform	{"vm_name":"test1","service_type":"web","success":true}	2025-08-06 12:19:19.232+01
83	1	Déploiement Terraform	{"vm_name":"web1","service_type":"web","success":true}	2025-08-06 12:26:23.919+01
84	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:31:47.053+01
85	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:31:51.41+01
86	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute les tâches planifiées pour exécuter les scripts de surveillance système et services toutes les 5 minutes.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"/opt/monitoring/status.sh\\"\\nSERVICES_SCRIPT=\\"/opt/monitoring/services_status.sh\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/5 * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/5 * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[]}},"query":{}}	2025-08-06 12:34:12.22+01
87	1	create_template:2	{}	2025-08-06 12:34:12.256+01
88	1	Déploiement Terraform	{"vm_name":"web12","service_type":"web","success":true}	2025-08-06 12:35:01.288+01
89	1	POST /templates/generate	{"body":{"template_id":2,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 12:37:17.191+01
90	1	generate_template:2	{}	2025-08-06 12:37:17.206+01
91	1	PUT /templates/2	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 12:42:51.517+01
92	1	update_template:2	{}	2025-08-06 12:42:51.563+01
93	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 12:49:24.336+01
94	1	create_template:3	{}	2025-08-06 12:49:24.388+01
130	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:35:09.553+01
95	1	POST /templates/generate	{"body":{"template_id":3,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 12:50:16.472+01
96	1	generate_template_file:3:Activation_des_cronjobs_de_supervision_2025-08-06T11-50-16-492Z.sh	{}	2025-08-06 12:50:16.495+01
97	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:08:22.441+01
98	1	create_template:4	{}	2025-08-06 13:08:22.487+01
99	1	POST /templates/generate	{"body":{"template_id":4,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:08:32.157+01
100	1	generate_template_file:4:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervisionscript001.sh	{}	2025-08-06 13:08:32.187+01
101	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:10:52.966+01
102	1	create_template:5	{}	2025-08-06 13:10:53.01+01
103	1	POST /templates/generate	{"body":{"template_id":5,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:11:03.204+01
104	1	generate_template_file:5:Activation_des_cronjobs_de_supervisionscript001.sh	{}	2025-08-06 13:11:03.232+01
105	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:15:14.931+01
106	1	create_template:6	{}	2025-08-06 13:15:14.976+01
107	1	POST /templates/generate	{"body":{"template_id":5,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:15:20.043+01
108	1	generate_template_file:5:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	{}	2025-08-06 13:15:20.074+01
131	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:35:40.771+01
132	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:37:28.738+01
133	1	create_template:11	{}	2025-08-06 13:37:28.839+01
134	1	POST /templates/generate	{"body":{"template_id":11,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 13:37:37.614+01
135	1	generate_template_file:11:flask_api_api_D_ploiement_de_l_API_interne_Flask__api_camer_cm__script002.sh	{}	2025-08-06 13:37:37.637+01
136	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:38:35.52+01
137	1	create_template:12	{}	2025-08-06 13:38:35.612+01
189	1	POST /templates/generate	{"body":{"template_id":20,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}	2025-08-06 14:14:28.568+01
109	1	POST /templates	{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance système\\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\n\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\n\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\n\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\n\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s},\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > ${STATUS_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${STATUS_SCRIPT_PATH}","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}	2025-08-06 13:18:17.291+01
110	1	create_template:7	{}	2025-08-06 13:18:17.351+01
111	1	POST /templates/generate	{"body":{"template_id":7,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}	2025-08-06 13:18:45.73+01
112	1	generate_template_file:7:system_monitoring_script_monitoring_Surveillance_syst_me_-_G_n_ration_du_script_script001.sh	{}	2025-08-06 13:18:45.757+01
113	1	POST /templates	{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}	2025-08-06 13:19:40.204+01
114	1	create_template:8	{}	2025-08-06 13:19:40.26+01
115	1	POST /templates/generate	{"body":{"template_id":8,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}	2025-08-06 13:20:09.364+01
116	1	generate_template_file:8:service_monitoring_script_monitoring_Surveillance_des_services_-_G_n_ration_du_script_script001.sh	{}	2025-08-06 13:20:09.384+01
117	1	POST /templates	{"body":{"name":"Déploiement du serveur Web Camer-Web (web2.camer.cm)","service_type":"web_server_nginx","category":"web","description":"Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.","template_content":"#!/bin/bash\\nset -e\\n\\necho \\"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\\"\\n\\n# 1. Installation des paquets\\necho \\"📦 Installation de nginx et apache2 (optionnel)...\\"\\nsudo apt update\\nsudo apt install curl -y\\nsudo apt install nginx apache2 -y\\n\\n# 2. Préparation du répertoire web\\necho \\"📁 Création du site web ${WEB_ROOT}\\"\\nsudo mkdir -p ${WEB_ROOT}\\n\\necho \\"📝 Création de la page d’accueil personnalisée...\\"\\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\\n<!DOCTYPE html>\\n<html lang=\\\\\\"fr\\\\\\">\\n<head>\\n    <meta charset=\\\\\\"UTF-8\\\\\\">\\n    <title>Camer-Web</title>\\n</head>\\n<body style=\\\\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\\\\">\\n    <h1>✅ Bienvenue sur Camer-Web</h1>\\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nEOF\\n\\n# 3. Création du fichier NGINX vhost\\necho \\"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\\"\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\\nserver {\\n    listen 80;\\n    server_name ${DOMAIN_NAME};\\n\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\n\\n    root ${WEB_ROOT};\\n    index index.html;\\n\\n    location / {\\n        try_files \\\\$uri \\\\$uri/ =404;\\n    }\\n}\\nEOF\\n\\n# 4. Activation du site et désactivation du défaut\\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\\nsudo rm -f /etc/nginx/sites-enabled/default\\n\\n# 5. Redémarrage des services\\necho \\"🚀 Redémarrage de NGINX...\\"\\nsudo systemctl restart nginx\\nsudo systemctl enable nginx\\n\\n# 6. Pare-feu\\necho \\"🛡️ Configuration UFW pour NGINX...\\"\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\necho\\necho \\"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\\"\\n\\n: \\"\\\\${INSTANCE_ID:?INSTANCE_ID is required}\\"\\n\\n# Save instance identifier\\necho \\"INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\nexport INSTANCE_ID=\\\\${INSTANCE_ID}\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: \\\\${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log","script_path":"/scripts/deploy_web2.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web2.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.20.21"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"Camer-Web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}},"query":{}}	2025-08-06 13:20:32.527+01
118	1	create_template:9	{}	2025-08-06 13:20:32.594+01
119	1	POST /templates/generate	{"body":{"template_id":9,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}	2025-08-06 13:20:43.435+01
120	1	generate_template_file:9:web_server_nginx_web_D_ploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	{}	2025-08-06 13:20:43.46+01
121	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:23:12.691+01
122	1	create_template:10	{}	2025-08-06 13:23:12.766+01
123	1	POST /templates/generate	{"body":{"template_id":10,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 13:23:29.346+01
124	1	generate_template_file:10:flask_api_api_D_ploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	{}	2025-08-06 13:23:29.369+01
125	1	Déploiement Terraform	{"vm_name":"webtest","service_type":"web","success":true}	2025-08-06 13:25:42.947+01
126	1	Déploiement Terraform	{"vm_name":"webtes2t","service_type":"web","success":true}	2025-08-06 13:30:11.554+01
127	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:34:36.59+01
128	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:34:43.994+01
129	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:34:48.079+01
138	1	POST /templates	{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\\n\\necho \\"📦 Installation du serveur NFS...\\"\\nsudo apt update && sudo apt install -y nfs-kernel-server\\n\\necho \\"📁 Création du dossier partagé ${SHARE_DIR}...\\"\\nsudo mkdir -p ${SHARE_DIR}\\nsudo chown nobody:nogroup ${SHARE_DIR}\\nsudo chmod 777 ${SHARE_DIR}\\n\\necho \\"📝 Configuration du fichier /etc/exports...\\"\\necho \\"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\\" | sudo tee -a /etc/exports\\n\\necho \\"🔄 Redémarrage du service NFS...\\"\\nsudo systemctl restart nfs-kernel-server\\n\\necho \\"🔍 Vérification de l’export actif...\\"\\nsudo exportfs -v\\n\\necho \\"✅ Serveur NFS configuré avec succès.\\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.10.0/24"}]}},"query":{}}	2025-08-06 13:44:18.132+01
139	1	create_template:13	{}	2025-08-06 13:44:18.176+01
140	1	PUT /templates/2	{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\\n\\necho \\"📦 Installation du serveur NFS...\\"\\nsudo apt update && sudo apt install -y nfs-kernel-server\\n\\necho \\"📁 Création du dossier partagé ${SHARE_DIR}...\\"\\nsudo mkdir -p ${SHARE_DIR}\\nsudo chown nobody:nogroup ${SHARE_DIR}\\nsudo chmod 777 ${SHARE_DIR}\\n\\necho \\"📝 Configuration du fichier /etc/exports...\\"\\necho \\"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\\" | sudo tee -a /etc/exports\\n\\necho \\"🔄 Redémarrage du service NFS...\\"\\nsudo systemctl restart nfs-kernel-server\\n\\necho \\"🔍 Vérification de l’export actif...\\"\\nsudo exportfs -v\\n\\necho \\"✅ Serveur NFS configuré avec succès.\\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.24.0/24"}]}},"query":{}}	2025-08-06 13:44:32.062+01
141	1	PUT /templates/13	{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\\n\\necho \\"📦 Installation du serveur NFS...\\"\\nsudo apt update && sudo apt install -y nfs-kernel-server\\n\\necho \\"📁 Création du dossier partagé ${SHARE_DIR}...\\"\\nsudo mkdir -p ${SHARE_DIR}\\nsudo chown nobody:nogroup ${SHARE_DIR}\\nsudo chmod 777 ${SHARE_DIR}\\n\\necho \\"📝 Configuration du fichier /etc/exports...\\"\\necho \\"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\\" | sudo tee -a /etc/exports\\n\\necho \\"🔄 Redémarrage du service NFS...\\"\\nsudo systemctl restart nfs-kernel-server\\n\\necho \\"🔍 Vérification de l’export actif...\\"\\nsudo exportfs -v\\n\\necho \\"✅ Serveur NFS configuré avec succès.\\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.24.0/24"}]}},"query":{}}	2025-08-06 13:44:38.468+01
142	1	update_template:13	{}	2025-08-06 13:44:38.499+01
143	1	POST /templates	{"body":{"name":"Configuration du client NFS","service_type":"nfs_client","category":"file_sharing","description":"Installe le client NFS et monte un partage distant automatiquement.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration client NFS pour montage du dossier partagé\\n\\necho \\"📦 Installation du client NFS...\\"\\nsudo apt update && sudo apt install -y nfs-common\\n\\necho \\"📁 Création du dossier local ${MOUNT_DIR}...\\"\\nsudo mkdir -p ${MOUNT_DIR}\\n\\necho \\"🔗 Montage du partage NFS depuis ${NFS_SERVER}:${SHARE_DIR}\\"\\nsudo mount ${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR}\\n\\necho \\"🔒 Optionnel : ajout dans /etc/fstab pour montage permanent...\\"\\necho \\"${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR} nfs defaults 0 0\\" | sudo tee -a /etc/fstab\\n\\necho \\"✅ Client NFS configuré et monté.\\"","script_path":"/scripts/nfs_client_setup.sh","fields_schema":{"fields":[{"name":"NFS_SERVER","label":"Adresse IP du serveur NFS","type":"text","required":true,"default":"192.168.10.10"},{"name":"SHARE_DIR","label":"Répertoire exporté par le serveur","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"MOUNT_DIR","label":"Point de montage local","type":"text","required":true,"default":"/mnt/nfs_share"}]}},"query":{}}	2025-08-06 13:44:51.872+01
144	1	create_template:14	{}	2025-08-06 13:44:51.903+01
145	1	POST /templates/generate	{"body":{"template_id":14,"config_data":{"NFS_SERVER":"192.168.10.10","SHARE_DIR":"/srv/nfs_share","MOUNT_DIR":"/mnt/nfs_share"}},"query":{}}	2025-08-06 13:45:14.582+01
146	1	generate_template_file:14:nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh	{}	2025-08-06 13:45:14.607+01
147	1	POST /templates/generate	{"body":{"template_id":13,"config_data":{"SHARE_DIR":"/srv/nfs_share","CLIENT_SUBNET":"192.168.10.0/24"}},"query":{}}	2025-08-06 13:45:30.711+01
148	1	generate_template_file:13:nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh	{}	2025-08-06 13:45:30.738+01
149	1	POST /templates	{"body":{"name":"Configuration DNS Esclave avec BIND9 (dns2)","service_type":"dns_slave","category":"dns","description":"Installe et configure un serveur DNS esclave avec BIND9, prêt à recevoir les zones depuis le DNS maître.","template_content":"#!/bin/bash\\n\\necho \\"📦 Installation de BIND9 sur le DNS slave...\\"\\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\\nsudo apt install curl -y\\n\\necho \\"👤 Ajout de l'utilisateur courant au groupe bind...\\"\\nsudo usermod -aG bind \\"$USER\\"\\n\\necho \\"🔄 Activation du nouveau groupe pour cette session...\\"\\nnewgrp bind <<EONG\\n\\necho \\"📁 Vérification du répertoire de cache BIND...\\"\\nsudo mkdir -p /var/cache/bind\\nsudo chown bind:bind /var/cache/bind\\nsudo chmod 770 /var/cache/bind\\n\\necho \\"⚙️ Configuration des options globales dans /etc/bind/named.conf.options...\\"\\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\\noptions {\\n    directory \\"/var/cache/bind\\";\\n\\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\\n    recursion no;\\n\\n    dnssec-validation auto;\\n\\n    listen-on { 127.0.0.1; ${SLAVE_IP}; };\\n    listen-on-v6 { none; };\\n};\\nEOF\\n\\necho \\"📌 Configuration des zones esclaves dans /etc/bind/named.conf.local...\\"\\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\\n${ZONE_CONFIGS}\\nEOF\\n\\necho \\"🔓 Autorisation du trafic DNS depuis le maître (si UFW est actif)...\\"\\nsudo ufw allow from ${MASTER_IP} to any port 53 proto udp\\nsudo ufw allow from ${MASTER_IP} to any port 53 proto tcp\\n\\necho \\"🚀 Redémarrage de BIND9...\\"\\nsudo systemctl restart bind9\\nsudo systemctl enable bind9\\n\\necho \\"✅ Configuration terminée. Le slave attend les transferts du maître.\\"\\n\\nEONG","script_path":"/scripts/dns_slave_setup.sh","fields_schema":{"fields":[{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"MASTER_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones esclaves (bloc brut)","type":"textarea","required":true,"default":"zone \\"camer.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.camer.cm\\";\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.bunec.cm\\";\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.etatcivil.cm\\";\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.civilstatus.cm\\";\\n};"}]}},"query":{}}	2025-08-06 13:45:42.973+01
150	1	create_template:15	{}	2025-08-06 13:45:43.023+01
184	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script002.sh	{}	2025-08-06 14:09:09.578+01
190	1	generate_template_file:20:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh	{}	2025-08-06 14:14:28.603+01
151	1	POST /templates/generate	{"body":{"template_id":15,"config_data":{"SLAVE_IP":"192.168.20.20","MASTER_IP":"192.168.20.10","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.camer.cm\\";\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.bunec.cm\\";\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.etatcivil.cm\\";\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.civilstatus.cm\\";\\n};"}},"query":{}}	2025-08-06 13:45:52.896+01
152	1	generate_template_file:15:dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh	{}	2025-08-06 13:45:52.93+01
153	1	POST /templates	{"body":{"name":"Configuration DNS Maître avec BIND9 (dns1)","service_type":"dns_master","category":"dns","description":"Installe et configure un serveur DNS maître avec BIND9, en définissant plusieurs zones et en autorisant le transfert vers le serveur esclave.","template_content":"#!/bin/bash\\n# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})\\n\\necho \\"📦 Installation de BIND9...\\"\\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\\nsudo apt install curl -y\\n\\necho \\"📁 Création du répertoire des zones...\\"\\nsudo mkdir -p /etc/bind/zones\\nsudo chown bind:bind /etc/bind/zones\\n\\necho \\"🔧 Configuration des options globales dans /etc/bind/named.conf.options...\\"\\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\\noptions {\\n    directory \\"/var/cache/bind\\";\\n\\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\\n    recursion no;\\n\\n    allow-transfer { ${SLAVE_IP}; };\\n    dnssec-validation auto;\\n\\n    listen-on { 127.0.0.1; ${DNS_IP}; };\\n    listen-on-v6 { none; };\\n};\\nEOF\\n\\necho \\"📌 Définition des zones dans /etc/bind/named.conf.local...\\"\\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\\n${ZONE_CONFIGS}\\nEOF\\n\\necho \\"🔓 Autorisation du trafic DNS depuis le slave...\\"\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto udp\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp\\n\\necho \\"🚀 Redémarrage du service BIND9...\\"\\nsudo systemctl restart bind9\\nsudo systemctl enable bind9\\n\\necho \\"✅ Configuration du DNS Maître terminée.\\"","script_path":"/scripts/dns_master_setup.sh","fields_schema":{"fields":[{"name":"DNS_HOSTNAME","label":"Nom du serveur DNS maître","type":"text","required":true,"default":"dns1.camer.cm"},{"name":"OS_VERSION","label":"Version du système","type":"text","required":true,"default":"Ubuntu 22.04"},{"name":"DNS_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones BIND (bloc brut)","type":"textarea","required":true,"default":"zone \\"camer.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.camer.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.bunec.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.etatcivil.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.civilstatus.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};"}]}},"query":{}}	2025-08-06 13:46:04.833+01
154	1	create_template:16	{}	2025-08-06 13:46:04.88+01
155	1	POST /templates/generate	{"body":{"template_id":16,"config_data":{"DNS_HOSTNAME":"dns1.camer.cm","OS_VERSION":"Ubuntu 22.04","DNS_IP":"192.168.20.10","SLAVE_IP":"192.168.20.20","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.camer.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.bunec.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.etatcivil.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.civilstatus.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};"}},"query":{}}	2025-08-06 13:46:16.588+01
156	1	generate_template_file:16:dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh	{}	2025-08-06 13:46:16.621+01
157	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:46:35.221+01
158	1	create_template:17	{}	2025-08-06 13:46:35.289+01
159	1	POST /templates/generate	{"body":{"template_id":17,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 13:46:53.507+01
160	1	generate_template_file:17:flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	{}	2025-08-06 13:46:53.531+01
161	1	POST /templates	{"body":{"name":"Déploiement du serveur Web Camer-Web (web2.camer.cm)","service_type":"web_server_nginx","category":"web","description":"Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.","template_content":"#!/bin/bash\\nset -e\\n\\necho \\"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\\"\\n\\n# 1. Installation des paquets\\necho \\"📦 Installation de nginx et apache2 (optionnel)...\\"\\nsudo apt update\\nsudo apt install curl -y\\nsudo apt install nginx apache2 -y\\n\\n# 2. Préparation du répertoire web\\necho \\"📁 Création du site web ${WEB_ROOT}\\"\\nsudo mkdir -p ${WEB_ROOT}\\n\\necho \\"📝 Création de la page d’accueil personnalisée...\\"\\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\\n<!DOCTYPE html>\\n<html lang=\\\\\\"fr\\\\\\">\\n<head>\\n    <meta charset=\\\\\\"UTF-8\\\\\\">\\n    <title>Camer-Web</title>\\n</head>\\n<body style=\\\\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\\\\">\\n    <h1>✅ Bienvenue sur Camer-Web</h1>\\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nEOF\\n\\n# 3. Création du fichier NGINX vhost\\necho \\"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\\"\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\\nserver {\\n    listen 80;\\n    server_name ${DOMAIN_NAME};\\n\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\n\\n    root ${WEB_ROOT};\\n    index index.html;\\n\\n    location / {\\n        try_files \\\\$uri \\\\$uri/ =404;\\n    }\\n}\\nEOF\\n\\n# 4. Activation du site et désactivation du défaut\\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\\nsudo rm -f /etc/nginx/sites-enabled/default\\n\\n# 5. Redémarrage des services\\necho \\"🚀 Redémarrage de NGINX...\\"\\nsudo systemctl restart nginx\\nsudo systemctl enable nginx\\n\\n# 6. Pare-feu\\necho \\"🛡️ Configuration UFW pour NGINX...\\"\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\necho\\necho \\"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\\"\\n\\n: \\"\\\\${INSTANCE_ID:?INSTANCE_ID is required}\\"\\n\\n# Save instance identifier\\necho \\"INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\nexport INSTANCE_ID=\\\\${INSTANCE_ID}\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: \\\\${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log","script_path":"/scripts/deploy_web2.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web2.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.20.21"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"Camer-Web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}},"query":{}}	2025-08-06 13:47:06.158+01
162	1	create_template:18	{}	2025-08-06 13:47:06.234+01
163	1	POST /templates/generate	{"body":{"template_id":18,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}	2025-08-06 13:47:14.817+01
164	1	generate_template_file:18:web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	{}	2025-08-06 13:47:14.854+01
185	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:13:15.179+01
186	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script003.sh	{}	2025-08-06 14:13:15.218+01
187	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:13:48.273+01
188	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	{}	2025-08-06 14:13:48.307+01
191	1	POST /templates/generate	{"body":{"template_id":19,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}	2025-08-06 14:14:49.003+01
192	1	generate_template_file:19:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh	{}	2025-08-06 14:14:49.026+01
193	1	POST /templates/generate	{"body":{"template_id":18,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}	2025-08-06 14:15:06.195+01
194	1	generate_template_file:18:web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	{}	2025-08-06 14:15:06.225+01
165	1	POST /templates	{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","script_path":"/scripts/install_services_monitoring.sh","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}	2025-08-06 13:47:28.027+01
166	1	create_template:19	{}	2025-08-06 13:47:28.062+01
167	1	POST /templates/generate	{"body":{"template_id":19,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}	2025-08-06 13:47:41.342+01
168	1	generate_template_file:19:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh	{}	2025-08-06 13:47:41.362+01
169	1	POST /templates	{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance système\\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\n\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\n\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\n\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\n\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s},\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > ${STATUS_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${STATUS_SCRIPT_PATH}","script_path":"/scripts/install_status_monitoring.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}	2025-08-06 13:47:52.513+01
170	1	create_template:20	{}	2025-08-06 13:47:52.57+01
171	1	POST /templates/generate	{"body":{"template_id":20,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}	2025-08-06 13:48:01.882+01
172	1	generate_template_file:20:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh	{}	2025-08-06 13:48:01.898+01
173	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:48:14.792+01
174	1	create_template:21	{}	2025-08-06 13:48:14.824+01
175	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:48:27.974+01
176	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	{}	2025-08-06 13:48:27.993+01
177	1	Déploiement Terraform	{"vm_name":"webtes2t","service_type":"web","success":true}	2025-08-06 13:51:06.197+01
178	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:51:32.259+01
179	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 14:05:23.713+01
180	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 14:05:28.766+01
181	1	Déploiement Terraform	{"vm_name":"we0w2b","service_type":"web","success":true}	2025-08-06 14:05:44.363+01
182	1	POST /templates/generate	{"body":{"template_id":17,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:08:57.92+01
183	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:09:09.547+01
369	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:39.062+01
195	1	POST /templates/generate	{"body":{"template_id":17,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.24.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.24.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 14:17:04.714+01
196	1	generate_template_file:17:flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	{}	2025-08-06 14:17:04.741+01
197	1	POST /templates/generate	{"body":{"template_id":16,"config_data":{"DNS_HOSTNAME":"dns1.camer.cm","OS_VERSION":"Ubuntu 22.04","DNS_IP":"192.168.24.10","SLAVE_IP":"192.168.24.20","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.camer.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.bunec.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.etatcivil.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.civilstatus.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};"}},"query":{}}	2025-08-06 14:18:10.466+01
198	1	generate_template_file:16:dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh	{}	2025-08-06 14:18:10.505+01
199	1	POST /templates/generate	{"body":{"template_id":15,"config_data":{"SLAVE_IP":"192.168.24.20","MASTER_IP":"192.168.24.10","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.camer.cm\\";\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.bunec.cm\\";\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.etatcivil.cm\\";\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.civilstatus.cm\\";\\n};"}},"query":{}}	2025-08-06 14:18:31.816+01
200	1	generate_template_file:15:dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh	{}	2025-08-06 14:18:31.858+01
201	1	POST /templates/generate	{"body":{"template_id":13,"config_data":{"SHARE_DIR":"/srv/nfs_share","CLIENT_SUBNET":"192.168.10.0/24"}},"query":{}}	2025-08-06 14:18:50.516+01
202	1	generate_template_file:13:nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh	{}	2025-08-06 14:18:50.54+01
203	1	POST /templates/generate	{"body":{"template_id":14,"config_data":{"NFS_SERVER":"192.168.10.10","SHARE_DIR":"/srv/nfs_share","MOUNT_DIR":"/mnt/nfs_share"}},"query":{}}	2025-08-06 14:19:05.422+01
204	1	generate_template_file:14:nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh	{}	2025-08-06 14:19:05.442+01
205	1	Déploiement Terraform	{"vm_name":"Webapache","service_type":"web","success":true}	2025-08-06 14:19:38.764+01
206	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 15:31:11.598+01
207	1	login	{"user_id":1}	2025-08-06 15:31:11.839+01
208	1	POST /permissions	{"body":{"name":"script.analyze","description":"Analyser un script avec l’IA"},"query":{}}	2025-08-06 15:31:31.092+01
209	1	POST /permissions	{"body":{"name":"script.read","description":"Lire les analyses de script IA"},"query":{}}	2025-08-06 15:32:09.144+01
210	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[45,46]}],"query":{}}	2025-08-06 15:32:20.15+01
211	1	POST /permissions	{"body":{"name":"template.analyze","description":"Analyse du template"},"query":{}}	2025-08-06 15:37:58.465+01
212	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[47]}],"query":{}}	2025-08-06 15:38:07.754+01
213	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 15:38:16.339+01
214	1	create_template:22	{}	2025-08-06 15:38:16.378+01
215	1	POST /templates/analyze	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 15:41:17.661+01
216	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt install bind9 -y\\nsystemctl enable bind9"},"query":{}}	2025-08-06 15:41:46.993+01
217	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt install bind9 -y\\nsystemctl enable bind9"},"query":{}}	2025-08-06 15:42:47.183+01
218	1	POST /templates/analyze	{"body":{"script_content":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-06 15:44:39.688+01
370	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:39.109+01
219	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 15:44:58.763+01
220	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 15:45:55.51+01
221	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 15:48:59.019+01
222	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:01:12.237+01
223	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:21:45.518+01
224	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:27:34.396+01
225	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:29:40.83+01
226	1	GET /templates//2/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:50:04.094+01
227	1	GET /templates/2/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:50:23.733+01
228	1	GET /templates/9/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:50:32.887+01
229	1	GET /templates/9/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:51:07.676+01
230	1	POST /permissions	{"body":{"name":"template.audit","description":"template.audit"},"query":{}}	2025-08-06 17:05:38.324+01
231	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[48]}],"query":{}}	2025-08-06 17:05:46.202+01
232	1	POST /templates/audit	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 17:06:30.268+01
233	1	POST /templates/audit	{"body":{"script":"#!/bin/bash\\n# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})\\n\\necho \\"📦 Installation de BIND9...\\"\\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\\nsudo apt install curl -y\\n\\necho \\"📁 Création du répertoire des zones...\\"\\nsudo mkdir -p /etc/bind/zones\\nsudo chown bind:bind /etc/bind/zones\\n\\necho \\"🔧 Configuration des options globales dans /etc/bind/named.conf.options...\\"\\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\\noptions {\\n    directory \\"/var/cache/bind\\";\\n\\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\\n    recursion no;\\n\\n    allow-transfer { ${SLAVE_IP}; };\\n    dnssec-validation auto;\\n\\n    listen-on { 127.0.0.1; ${DNS_IP}; };\\n    listen-on-v6 { none; };\\n};\\nEOF\\n\\necho \\"📌 Définition des zones dans /etc/bind/named.conf.local...\\"\\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\\n${ZONE_CONFIGS}\\nEOF\\n\\necho \\"🔓 Autorisation du trafic DNS depuis le slave...\\"\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto udp\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp\\n\\necho \\"🚀 Redémarrage du service BIND9...\\"\\nsudo systemctl restart bind9\\nsudo systemctl enable bind9\\n\\necho \\"✅ Configuration du DNS Maître terminée.\\""},"query":{}}	2025-08-06 17:08:17.724+01
234	1	PUT /permissions/48	{"body":{"name":"template.audit","description":"Auditer un script avec IA avant déploiement"},"query":{}}	2025-08-06 17:13:34.202+01
235	1	POST /permissions	{"body":[{"name":"template.explain","description":"Explain script using AI"},{"name":"template.analyze","description":"Analyze script using AI"},{"name":"template.explainVariables","description":"Explain template variables using AI"},{"name":"template.summarizeLogs","description":"Summarize deployment logs using AI"},{"name":"template.suggestBundle","description":"Suggest stack bundles using AI"},{"name":"template.simulateExecution","description":"Simulate script execution using AI"}],"query":{}}	2025-08-06 17:49:12.794+01
236	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[49,50,51,52,53]}],"query":{}}	2025-08-06 17:49:30.121+01
237	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 17:50:25.232+01
238	1	login	{"user_id":1}	2025-08-06 17:50:25.418+01
239	1	POST /templates/explain	{"body":{"script":"#!/bin/bash\\necho hello"},"query":{}}	2025-08-06 17:50:59.816+01
240	1	POST /templates/logs/summarize	{"body":{"logs":"Log line 1\\nLog line 2"},"query":{}}	2025-08-06 17:51:51.723+01
241	1	POST /templates/bundle	{"body":{"needs":"Hébergement web"},"query":{}}	2025-08-06 17:54:19.826+01
242	1	POST /templates/simulate	{"body":{"script":"#!/bin/bash\\nsystemctl restart nginx"},"query":{}}	2025-08-06 17:54:22.25+01
243	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-06 17:54:30.585+01
244	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-06 17:56:08.844+01
245	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:03:09.024+01
246	1	login	{"user_id":1}	2025-08-07 04:03:09.233+01
247	1	POST /auth/register	{"body":{"first_name":"John","last_name":"Doe","email":"john@example.com","password":"secret","role_id":1},"query":{}}	2025-08-07 04:03:09.407+01
248	\N	POST /auth/request-reset	{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}	2025-08-07 04:03:09.503+01
249	1	request_reset_code	{"user_id":1}	2025-08-07 04:03:13.63+01
250	\N	POST /auth/reset-password	{"body":{"code":"803327","password":"admin123."},"query":{}}	2025-08-07 04:03:13.707+01
251	1	GET /auth/reset-history	{"query":{}}	2025-08-07 04:03:13.848+01
252	1	view_reset_history	{}	2025-08-07 04:03:13.859+01
253	1	POST /users	{"body":{"first_name":"Jane","last_name":"Doe","email":"jane@example.com","password":"secret","role_id":2},"query":{}}	2025-08-07 04:03:13.991+01
254	1	DELETE /users/1	{"query":{}}	2025-08-07 04:03:14.311+01
255	1	GET /users/1	{"query":{}}	2025-08-07 04:03:14.45+01
256	1	GET /users	{"query":{}}	2025-08-07 04:03:14.593+01
257	1	PATCH /users/1	{"body":{"last_name":"Smith"},"query":{}}	2025-08-07 04:03:14.753+01
258	1	GET /users/search?query=Jane	{"query":{"query":"Jane"}}	2025-08-07 04:03:14.886+01
259	1	PUT /users/1	{"body":{"first_name":"Jane"},"query":{}}	2025-08-07 04:03:15.03+01
260	1	GET /roles	{"query":{}}	2025-08-07 04:03:15.17+01
261	1	GET /roles/1	{"query":{}}	2025-08-07 04:03:15.314+01
262	1	POST /roles	{"body":{"name":"editor","description":"Content editor"},"query":{}}	2025-08-07 04:03:15.442+01
263	1	PUT /roles/1	{"body":{"description":"Updated role"},"query":{}}	2025-08-07 04:03:15.581+01
264	1	DELETE /roles/1	{"query":{}}	2025-08-07 04:03:15.729+01
265	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:09:17.691+01
266	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:09:51.167+01
267	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:10:03.561+01
268	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:12:07.792+01
269	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:12:29.238+01
270	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:13:16.518+01
271	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:14:13.131+01
272	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:15:40.803+01
273	1	login	{"user_id":1}	2025-08-07 04:15:40.976+01
274	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:16:00.784+01
275	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:17:37.36+01
276	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:18:02.041+01
277	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:18:05.707+01
278	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-07 04:19:12.44+01
279	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-07 04:20:30.172+01
280	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:46:47.538+01
281	1	login	{"user_id":1}	2025-08-07 04:46:47.754+01
282	1	GET /users	{"query":{}}	2025-08-07 04:46:47.939+01
283	1	GET /roles	{"query":{}}	2025-08-07 04:46:47.982+01
284	1	GET /permissions	{"query":{}}	2025-08-07 04:46:48.027+01
285	1	GET /logs	{"query":{}}	2025-08-07 04:46:48.07+01
286	1	GET /templates	{"query":{}}	2025-08-07 04:46:48.114+01
287	1	GET /vms	{"query":{}}	2025-08-07 04:46:48.181+01
288	1	GET /users	{"query":{}}	2025-08-07 04:46:48.38+01
289	1	GET /roles	{"query":{}}	2025-08-07 04:46:48.42+01
290	1	GET /permissions	{"query":{}}	2025-08-07 04:46:48.456+01
291	1	GET /logs	{"query":{}}	2025-08-07 04:46:48.514+01
292	1	list_vms	{}	2025-08-07 04:46:48.539+01
293	1	GET /templates	{"query":{}}	2025-08-07 04:46:48.663+01
294	1	GET /vms	{"query":{}}	2025-08-07 04:46:48.72+01
295	1	list_vms	{}	2025-08-07 04:46:48.762+01
296	1	GET /users	{"query":{}}	2025-08-07 04:47:19.782+01
297	1	GET /roles	{"query":{}}	2025-08-07 04:47:19.825+01
298	1	GET /permissions	{"query":{}}	2025-08-07 04:47:19.898+01
299	1	GET /logs	{"query":{}}	2025-08-07 04:47:19.937+01
300	1	GET /templates	{"query":{}}	2025-08-07 04:47:19.977+01
301	1	GET /vms	{"query":{}}	2025-08-07 04:47:20.034+01
302	1	GET /users	{"query":{}}	2025-08-07 04:47:20.167+01
303	1	GET /roles	{"query":{}}	2025-08-07 04:47:20.203+01
304	1	GET /permissions	{"query":{}}	2025-08-07 04:47:20.245+01
305	1	GET /logs	{"query":{}}	2025-08-07 04:47:20.334+01
306	1	GET /templates	{"query":{}}	2025-08-07 04:47:20.417+01
307	1	list_vms	{}	2025-08-07 04:47:20.423+01
308	1	GET /vms	{"query":{}}	2025-08-07 04:47:20.526+01
309	1	list_vms	{}	2025-08-07 04:47:20.554+01
310	1	GET /users	{"query":{}}	2025-08-07 04:47:34.542+01
311	1	GET /users	{"query":{}}	2025-08-07 04:47:34.615+01
312	1	GET /users/1	{"query":{}}	2025-08-07 04:47:38.112+01
313	1	GET /users/1	{"query":{}}	2025-08-07 04:47:38.172+01
314	1	PUT /users/1	{"body":{"first_name":"Nexus","last_name":"Nexus Latif","email":"latifnjimoluh@gmail.com","role_id":1},"query":{}}	2025-08-07 04:47:46.951+01
315	1	GET /users/1	{"query":{}}	2025-08-07 04:47:47.021+01
316	1	GET /users	{"query":{}}	2025-08-07 04:47:49.696+01
317	1	GET /users	{"query":{}}	2025-08-07 04:47:49.766+01
318	1	GET /users/1	{"query":{}}	2025-08-07 04:47:52.53+01
319	1	GET /users/1	{"query":{}}	2025-08-07 04:47:52.591+01
320	1	GET /roles	{"query":{}}	2025-08-07 04:48:00.218+01
321	1	GET /roles	{"query":{}}	2025-08-07 04:48:00.277+01
322	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:05.624+01
323	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:05.682+01
324	1	PUT /roles/2	{"body":{"name":"Admin","description":""},"query":{}}	2025-08-07 04:48:11.306+01
325	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:11.373+01
326	1	GET /roles	{"query":{}}	2025-08-07 04:48:13.639+01
327	1	GET /roles	{"query":{}}	2025-08-07 04:48:13.701+01
328	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:16.991+01
329	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:17.05+01
330	1	PUT /roles/2	{"body":{"name":"admin","description":""},"query":{}}	2025-08-07 04:48:21.129+01
331	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:21.199+01
332	1	GET /permissions	{"query":{}}	2025-08-07 04:48:32.494+01
333	1	GET /permissions	{"query":{}}	2025-08-07 04:48:32.554+01
334	1	GET /users	{"query":{}}	2025-08-07 04:50:13.516+01
335	1	GET /roles	{"query":{}}	2025-08-07 04:50:13.549+01
336	1	GET /permissions	{"query":{}}	2025-08-07 04:50:13.58+01
337	1	GET /logs	{"query":{}}	2025-08-07 04:50:13.613+01
338	1	GET /templates	{"query":{}}	2025-08-07 04:50:13.652+01
339	1	GET /vms	{"query":{}}	2025-08-07 04:50:13.701+01
340	1	GET /permissions	{"query":{}}	2025-08-07 04:50:13.825+01
341	1	GET /roles	{"query":{}}	2025-08-07 04:50:13.868+01
342	1	GET /users	{"query":{}}	2025-08-07 04:50:13.913+01
343	1	GET /logs	{"query":{}}	2025-08-07 04:50:13.979+01
344	1	GET /templates	{"query":{}}	2025-08-07 04:50:14.049+01
345	1	list_vms	{}	2025-08-07 04:50:14.063+01
346	1	GET /vms	{"query":{}}	2025-08-07 04:50:14.162+01
347	1	list_vms	{}	2025-08-07 04:50:14.183+01
348	1	GET /users	{"query":{}}	2025-08-07 04:50:14.853+01
349	1	GET /users	{"query":{}}	2025-08-07 04:50:14.911+01
350	1	GET /roles	{"query":{}}	2025-08-07 04:50:16.04+01
351	1	GET /roles	{"query":{}}	2025-08-07 04:50:16.083+01
352	1	GET /users	{"query":{}}	2025-08-07 04:50:17.186+01
353	1	GET /users	{"query":{}}	2025-08-07 04:50:17.242+01
354	1	GET /roles	{"query":{}}	2025-08-07 04:50:19.396+01
355	1	GET /roles	{"query":{}}	2025-08-07 04:50:19.446+01
356	1	GET /permissions	{"query":{}}	2025-08-07 04:50:20.599+01
357	1	GET /permissions	{"query":{}}	2025-08-07 04:50:20.668+01
358	1	GET /auth/reset-history	{"query":{}}	2025-08-07 04:51:25.443+01
359	1	view_reset_history	{}	2025-08-07 04:51:25.453+01
360	1	GET /auth/reset-history	{"query":{}}	2025-08-07 04:51:25.498+01
361	1	view_reset_history	{}	2025-08-07 04:51:25.502+01
362	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:28.104+01
363	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:28.163+01
364	1	GET /logs?page=2&q=	{"query":{"page":"2","q":""}}	2025-08-07 04:51:31.657+01
365	1	GET /roles	{"query":{}}	2025-08-07 04:51:34.803+01
366	1	GET /roles	{"query":{}}	2025-08-07 04:51:34.853+01
367	1	GET /permissions	{"query":{}}	2025-08-07 04:51:36.595+01
368	1	GET /permissions	{"query":{}}	2025-08-07 04:51:36.643+01
371	1	GET /logs?page=2&q=	{"query":{"page":"2","q":""}}	2025-08-07 04:51:42.444+01
373	1	GET /settings/me	{"query":{}}	2025-08-07 04:51:45.462+01
376	1	GET /settings	{"query":{}}	2025-08-07 04:51:45.603+01
372	1	GET /logs?page=3&q=	{"query":{"page":"3","q":""}}	2025-08-07 04:51:43.446+01
374	1	GET /settings	{"query":{}}	2025-08-07 04:51:45.503+01
375	1	GET /settings/me	{"query":{}}	2025-08-07 04:51:45.57+01
377	1	GET /templates	{"query":{}}	2025-08-07 04:51:55.445+01
378	1	GET /templates	{"query":{}}	2025-08-07 04:51:55.505+01
379	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:55:55.451+01
380	1	list_vms	{}	2025-08-07 04:55:55.475+01
381	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:55:55.522+01
382	1	list_vms	{}	2025-08-07 04:55:55.54+01
383	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:47.99+01
384	1	list_vms	{}	2025-08-07 04:56:48.017+01
385	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:48.059+01
386	1	list_vms	{}	2025-08-07 04:56:48.086+01
387	1	GET /vms/conversions	{"query":{}}	2025-08-07 04:56:51.219+01
388	1	view_conversion_history	{}	2025-08-07 04:56:51.231+01
389	1	GET /vms/conversions	{"query":{}}	2025-08-07 04:56:51.291+01
390	1	view_conversion_history	{}	2025-08-07 04:56:51.3+01
391	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:53.739+01
392	1	list_vms	{}	2025-08-07 04:56:53.769+01
393	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:53.816+01
394	1	list_vms	{}	2025-08-07 04:56:53.843+01
395	1	GET /ai-cache	{"query":{}}	2025-08-07 04:57:15.579+01
396	1	GET /ai-cache	{"query":{}}	2025-08-07 04:57:15.627+01
397	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\\\nsudo apt update"},"query":{}}	2025-08-07 04:57:55.603+01
398	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\\\nsudo apt update"},"query":{}}	2025-08-07 04:58:28.733+01
399	1	GET /ai-cache	{"query":{}}	2025-08-07 04:58:33.417+01
400	1	GET /ai-cache	{"query":{}}	2025-08-07 04:58:33.462+01
401	1	GET /permissions	{"query":{}}	2025-08-07 04:58:47.754+01
402	1	GET /permissions	{"query":{}}	2025-08-07 04:58:47.809+01
403	1	POST /permissions	{"body":{"name":"aiCache.list","description":"Liste des requete deja recu"},"query":{}}	2025-08-07 04:59:05.036+01
404	1	GET /permissions	{"query":{}}	2025-08-07 04:59:05.097+01
405	1	GET /permissions/54	{"query":{}}	2025-08-07 04:59:11.889+01
406	1	GET /permissions/54	{"query":{}}	2025-08-07 04:59:11.946+01
407	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[54]}],"query":{}}	2025-08-07 04:59:26.833+01
408	1	GET /ai-cache	{"query":{}}	2025-08-07 04:59:29.477+01
409	1	GET /ai-cache	{"query":{}}	2025-08-07 04:59:29.526+01
\.


--
-- Data for Name: monitored_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monitored_services (id, name, script_path, description, created_at, updated_at) FROM stdin;
1	Nginx Provisioning	scripts/service.sh	Configure Nginx and record service states	2025-08-06 04:39:32.364024+01	2025-08-06 04:39:32.364024+01
\.


--
-- Data for Name: monitoring_scripts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monitoring_scripts (id, name, script_path, description, created_at, updated_at) FROM stdin;
1	System Metrics Monitor	scripts/monitor.sh	Collect CPU, memory, disk and network metrics	2025-08-06 04:39:32.356362+01	2025-08-06 04:39:32.356362+01
\.


--
-- Data for Name: monitorings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monitorings (id, vm_ip, ip_address, instance_id, services_status, system_status, retrieved_at, created_at, updated_at) FROM stdin;
1	192.168.24.78	192.168.24.171	e591f327-9107-473b-9fd1-9c40c70641a4	{"vm_ip":"192.168.24.78","username":"nexus"}	{"vm_ip":"192.168.24.78","username":"nexus"}	2025-08-06 04:55:59.908+01	2025-08-06 04:55:59.908+01	2025-08-06 04:55:59.908+01
2	192.168.24.91	192.168.24.91	b10d3830-d27e-4cee-8166-4d36c27f8166	{"sshd":"active","ufw":"active","fail2ban":"inactive\\nabsent","cron":"active","crond":"inactive\\nabsent","nginx":"inactive\\nabsent","apache2":"inactive\\nabsent","mysql":"inactive\\nabsent","mariadb":"inactive\\nabsent","postgresql":"inactive\\nabsent","docker":"inactive\\nabsent","kubelet":"inactive\\nabsent","redis-server":"inactive\\nabsent","mongod":"inactive\\nabsent","vsftpd":"inactive\\nabsent","proftpd":"inactive\\nabsent","php-fpm":"inactive\\nabsent","timestamp":"2025-08-06T10:22:58+00:00","instance_id":"b10d3830-d27e-4cee-8166-4d36c27f8166"}	{"timestamp":"2025-08-06T10:22:58+00:00","instance_id":"b10d3830-d27e-4cee-8166-4d36c27f8166","hostname":"test","ip_address":"192.168.24.91","load_average":"1.17, 0.26, 0.09","memory":{"total_kb":2010676,"available_kb":1654228},"disk":{"total_bytes":10464022528,"used_bytes":5181259776,"available_bytes":4729114624},"network":{"interface":"eth0","rx_bytes":362655,"tx_bytes":43765},"open_ports":[22,53,68],"top_processes":[]}	2025-08-06 11:29:25.757+01	2025-08-06 11:29:25.758+01	2025-08-06 11:29:25.758+01
3	192.168.24.94	192.168.24.94	505bb44b-f327-47f7-a2d2-5fb231456c2f	{"timestamp":"2025-08-06T11:20:01+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-06T11:20:01+00:00","instance_id":"undefined","hostname":"test1","ip_address":"192.168.24.94","load_average":"0.58 0.20 0.07","memory":{"total_kb":2010676,"available_kb":1670152},"disk":{"total_bytes":10464022528,"used_bytes":5183983616,"available_bytes":4726390784},"network":{"interface":"eth0","rx_bytes":2895596,"tx_bytes":118169},"open_ports":[22,53,68],"top_processes":[{"pid":1,"cmd":"systemd","cpu":5.5},{"pid":752,"cmd":"snapd","cpu":5.1},{"pid":1303,"cmd":"systemd","cpu":2.7},{"pid":9,"cmd":"kworker/u4:0-ev","cpu":1.7},{"pid":427,"cmd":"systemd-journal","cpu":0.9}]}	2025-08-06 12:22:47.44+01	2025-08-06 12:22:47.442+01	2025-08-06 12:22:47.442+01
4	192.168.24.202	192.168.24.202	${INSTANCE_ID}	{"timestamp":"2025-08-07T03:55:30+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"},{"name":"nginx","active":"active","enabled":"enabled"},{"name":"apache2","active":"failed","enabled":"enabled"}]}	{"timestamp":"2025-08-07T03:55:15+00:00","instance_id":"undefined","hostname":"Webapache","ip_address":"192.168.24.202","load_average":"0.01 0.02 0.00","memory":{"total_kb":2010676,"available_kb":1590624},"disk":{"total_bytes":10464022528,"used_bytes":6119256064,"available_bytes":3791118336},"network":{"interface":"eth0","rx_bytes":347193895,"tx_bytes":4059300},"open_ports":[22,53,68,80],"top_processes":[{"pid":747,"cmd":"qemu-ga","cpu":0.1},{"pid":19095,"cmd":"kworker/0:2-eve","cpu":0.1},{"pid":19251,"cmd":"kworker/1:2-eve","cpu":0.1},{"pid":1,"cmd":"systemd","cpu":0},{"pid":2,"cmd":"kthreadd","cpu":0}]}	2025-08-07 04:55:39.75+01	2025-08-07 04:55:39.751+01	2025-08-07 04:55:39.751+01
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, description, status, created_at, updated_at) FROM stdin;
1	auth.reset-history	View password reset history	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
2	deployment.run	Run deployments	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
3	log.list	List logs	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
4	permission.assign	Assign permission to roles	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
5	permission.byRole	List permissions by role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
6	permission.create	Create permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
7	permission.delete	Delete permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
8	permission.list	List permissions	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
9	permission.read	Read permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
10	permission.unassign	Unassign permission from role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
11	permission.update	Update permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
12	role.create	Create role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
13	role.delete	Delete role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
14	role.list	List roles	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
15	role.read	Read role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
16	role.update	Update role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
17	settings.create	Create settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
18	settings.get	Get settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
19	settings.list	List settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
20	settings.update	Update settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
21	template.create	Create template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
22	template.delete	Delete template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
23	template.generate	Generate template script	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
24	template.list	List templates	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
25	template.read	Read template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
26	template.update	Update template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
27	user.create	Create user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
28	user.delete	Delete user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
29	user.list	List users	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
30	user.read	Read user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
31	user.search	Search users	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
32	user.update	Update user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
33	monitoring.collect	Collect monitoring data	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
34	monitoring.list	List monitoring records	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
35	monitoring.read	Read monitoring record	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
36	monitoring.sync	Synchronize deployment IP	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
37	vm.conversion.list	List VM conversions	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
38	vm.convert	Convert VM to template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
39	vm.list	List VMs	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
40	vm.start	Start VM	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
41	vm.status.check	Check VM status	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
42	vm.stop	Stop VM	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
43	vm.delete	Delete VM	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01
44	test	test posts	inactif	2025-08-06 04:45:33.679+01	2025-08-06 04:47:55.721+01
45	script.analyze	Analyser un script avec l’IA	actif	2025-08-06 15:31:31.112+01	2025-08-06 15:31:31.112+01
46	script.read	Lire les analyses de script IA	actif	2025-08-06 15:32:09.156+01	2025-08-06 15:32:09.156+01
47	template.analyze	Analyse du template	actif	2025-08-06 15:37:58.485+01	2025-08-06 15:37:58.485+01
48	template.audit	Auditer un script avec IA avant déploiement	actif	2025-08-06 17:05:38.346+01	2025-08-06 17:13:34.219+01
49	template.explain	Explain script using AI	actif	2025-08-06 17:49:12.831+01	2025-08-06 17:49:12.831+01
50	template.explainVariables	Explain template variables using AI	actif	2025-08-06 17:49:12.84+01	2025-08-06 17:49:12.84+01
51	template.summarizeLogs	Summarize deployment logs using AI	actif	2025-08-06 17:49:12.844+01	2025-08-06 17:49:12.844+01
52	template.suggestBundle	Suggest stack bundles using AI	actif	2025-08-06 17:49:12.848+01	2025-08-06 17:49:12.848+01
53	template.simulateExecution	Simulate script execution using AI	actif	2025-08-06 17:49:12.851+01	2025-08-06 17:49:12.851+01
54	aiCache.list	Liste des requete deja recu	actif	2025-08-07 04:59:05.047+01	2025-08-07 04:59:05.047+01
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, status, created_at, updated_at) FROM stdin;
1	superadmin	actif	2025-08-06 04:39:32.272046+01	2025-08-07 04:03:15.738+01
2	admin	actif	2025-08-07 04:03:15.448+01	2025-08-07 04:48:21.141+01
\.


--
-- Data for Name: service_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_templates (id, name, service_type, category, description, template_content, script_path, fields_schema, status, created_at, updated_at, abs_path) FROM stdin;
13	Configuration du serveur NFS	nfs_server	file_sharing	Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.	#!/bin/bash\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\n\necho "📦 Installation du serveur NFS..."\nsudo apt update && sudo apt install -y nfs-kernel-server\n\necho "📁 Création du dossier partagé ${SHARE_DIR}..."\nsudo mkdir -p ${SHARE_DIR}\nsudo chown nobody:nogroup ${SHARE_DIR}\nsudo chmod 777 ${SHARE_DIR}\n\necho "📝 Configuration du fichier /etc/exports..."\necho "${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports\n\necho "🔄 Redémarrage du service NFS..."\nsudo systemctl restart nfs-kernel-server\n\necho "🔍 Vérification de l’export actif..."\nsudo exportfs -v\n\necho "✅ Serveur NFS configuré avec succès."	/scripts/nfs_server_setup.sh	{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.24.0/24"}]}	actif	2025-08-06 13:44:18.171+01	2025-08-06 13:44:38.496+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\file_sharing\\nfs_server_file_sharing_Configuration_du_serveur_NFS_tpl001.sh
14	Configuration du client NFS	nfs_client	file_sharing	Installe le client NFS et monte un partage distant automatiquement.	#!/bin/bash\n# 🎯 Script de configuration client NFS pour montage du dossier partagé\n\necho "📦 Installation du client NFS..."\nsudo apt update && sudo apt install -y nfs-common\n\necho "📁 Création du dossier local ${MOUNT_DIR}..."\nsudo mkdir -p ${MOUNT_DIR}\n\necho "🔗 Montage du partage NFS depuis ${NFS_SERVER}:${SHARE_DIR}"\nsudo mount ${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR}\n\necho "🔒 Optionnel : ajout dans /etc/fstab pour montage permanent..."\necho "${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR} nfs defaults 0 0" | sudo tee -a /etc/fstab\n\necho "✅ Client NFS configuré et monté."	/scripts/templates/file_sharing/nfs_client_file_sharing_Configuration_du_client_NFS_tpl001.sh	{"fields":[{"name":"NFS_SERVER","label":"Adresse IP du serveur NFS","type":"text","required":true,"default":"192.168.10.10"},{"name":"SHARE_DIR","label":"Répertoire exporté par le serveur","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"MOUNT_DIR","label":"Point de montage local","type":"text","required":true,"default":"/mnt/nfs_share"}]}	actif	2025-08-06 13:44:51.899+01	2025-08-06 13:44:51.899+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\file_sharing\\nfs_client_file_sharing_Configuration_du_client_NFS_tpl001.sh
15	Configuration DNS Esclave avec BIND9 (dns2)	dns_slave	dns	Installe et configure un serveur DNS esclave avec BIND9, prêt à recevoir les zones depuis le DNS maître.	#!/bin/bash\n\necho "📦 Installation de BIND9 sur le DNS slave..."\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\nsudo apt install curl -y\n\necho "👤 Ajout de l'utilisateur courant au groupe bind..."\nsudo usermod -aG bind "$USER"\n\necho "🔄 Activation du nouveau groupe pour cette session..."\nnewgrp bind <<EONG\n\necho "📁 Vérification du répertoire de cache BIND..."\nsudo mkdir -p /var/cache/bind\nsudo chown bind:bind /var/cache/bind\nsudo chmod 770 /var/cache/bind\n\necho "⚙️ Configuration des options globales dans /etc/bind/named.conf.options..."\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\noptions {\n    directory "/var/cache/bind";\n\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\n    recursion no;\n\n    dnssec-validation auto;\n\n    listen-on { 127.0.0.1; ${SLAVE_IP}; };\n    listen-on-v6 { none; };\n};\nEOF\n\necho "📌 Configuration des zones esclaves dans /etc/bind/named.conf.local..."\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\n${ZONE_CONFIGS}\nEOF\n\necho "🔓 Autorisation du trafic DNS depuis le maître (si UFW est actif)..."\nsudo ufw allow from ${MASTER_IP} to any port 53 proto udp\nsudo ufw allow from ${MASTER_IP} to any port 53 proto tcp\n\necho "🚀 Redémarrage de BIND9..."\nsudo systemctl restart bind9\nsudo systemctl enable bind9\n\necho "✅ Configuration terminée. Le slave attend les transferts du maître."\n\nEONG	/scripts/templates/dns/dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__tpl001.sh	{"fields":[{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"MASTER_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones esclaves (bloc brut)","type":"textarea","required":true,"default":"zone \\"camer.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.camer.cm\\";\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.bunec.cm\\";\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.etatcivil.cm\\";\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.civilstatus.cm\\";\\n};"}]}	actif	2025-08-06 13:45:43.02+01	2025-08-06 13:45:43.02+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\dns\\dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__tpl001.sh
16	Configuration DNS Maître avec BIND9 (dns1)	dns_master	dns	Installe et configure un serveur DNS maître avec BIND9, en définissant plusieurs zones et en autorisant le transfert vers le serveur esclave.	#!/bin/bash\n# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})\n\necho "📦 Installation de BIND9..."\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\nsudo apt install curl -y\n\necho "📁 Création du répertoire des zones..."\nsudo mkdir -p /etc/bind/zones\nsudo chown bind:bind /etc/bind/zones\n\necho "🔧 Configuration des options globales dans /etc/bind/named.conf.options..."\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\noptions {\n    directory "/var/cache/bind";\n\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\n    recursion no;\n\n    allow-transfer { ${SLAVE_IP}; };\n    dnssec-validation auto;\n\n    listen-on { 127.0.0.1; ${DNS_IP}; };\n    listen-on-v6 { none; };\n};\nEOF\n\necho "📌 Définition des zones dans /etc/bind/named.conf.local..."\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\n${ZONE_CONFIGS}\nEOF\n\necho "🔓 Autorisation du trafic DNS depuis le slave..."\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto udp\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp\n\necho "🚀 Redémarrage du service BIND9..."\nsudo systemctl restart bind9\nsudo systemctl enable bind9\n\necho "✅ Configuration du DNS Maître terminée."	/scripts/templates/dns/dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__tpl001.sh	{"fields":[{"name":"DNS_HOSTNAME","label":"Nom du serveur DNS maître","type":"text","required":true,"default":"dns1.camer.cm"},{"name":"OS_VERSION","label":"Version du système","type":"text","required":true,"default":"Ubuntu 22.04"},{"name":"DNS_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones BIND (bloc brut)","type":"textarea","required":true,"default":"zone \\"camer.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.camer.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.bunec.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.etatcivil.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.civilstatus.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};"}]}	actif	2025-08-06 13:46:04.875+01	2025-08-06 13:46:04.875+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\dns\\dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__tpl001.sh
17	Déploiement de l'API interne Flask (api.camer.cm)	flask_api	api	Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.	#!/bin/bash\n\necho "🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})"\nAPP_DIR="${APP_DIR}"\nVENVDIR="$APP_DIR/venv"\nPROXY_IP="${PROXY_IP}"\nAPI_USER="${API_USER}"\n\n# 1. Mise à jour système & dépendances\necho "📦 Installation des paquets requis..."\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\nsudo apt install curl -y\n\n# 2. Création du dossier de l'application\necho "📁 Création du dossier $APP_DIR..."\nsudo mkdir -p "$APP_DIR"\nsudo chown -R $API_USER:$API_USER "$APP_DIR"\n\n# 3. Création d'un environnement virtuel Python\necho "🐍 Initialisation de l’environnement virtuel..."\nsudo -u $API_USER python3 -m venv "$VENVDIR"\nsource "$VENVDIR/bin/activate"\n\n# 4. Installation de Flask et Gunicorn\necho "📦 Installation de Flask & Gunicorn..."\n"$VENVDIR/bin/pip" install flask gunicorn\n\n# 5. Création d’une application Flask minimaliste\necho "📝 Déploiement de l'application Flask (hello.py)"\nsudo tee "$APP_DIR/app.py" > /dev/null <<EOF\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route("/")\ndef home():\n    return "✅ Bienvenue sur l’API interne Camer!"\n\nif __name__ == "__main__":\n    app.run()\nEOF\n\n# 6. Création du fichier WSGI\necho "🧩 Création du fichier WSGI (wsgi.py)"\nsudo tee "$APP_DIR/wsgi.py" > /dev/null <<EOF\nfrom app import app\n\nif __name__ == "__main__":\n    app.run()\nEOF\n\n# 7. Configuration du service systemd\necho "⚙️ Création du service systemd gunicorn"\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\n[Unit]\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nEnvironment="PATH=$VENVDIR/bin"\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\n# 8. Démarrage du service\necho "🔄 Activation et lancement du service"\nsudo systemctl daemon-reexec\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 9. Sécurisation avec UFW\necho "🛡️ Configuration du pare-feu (UFW)"\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment "Autorise accès proxy vers API"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 10. Test local\necho "🔎 Test local sur http://127.0.0.1:5000"\ncurl -s http://127.0.0.1:5000 || echo "⚠️ API non accessible localement, vérifier les logs."\n\necho "✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement)."	/scripts/templates/api/flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__tpl001.sh	{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}	actif	2025-08-06 13:46:35.285+01	2025-08-06 13:46:35.285+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\api\\flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__tpl001.sh
18	Déploiement du serveur Web Camer-Web (web2.camer.cm)	web_server_nginx	web	Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.	#!/bin/bash\nset -e\n\necho "🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})..."\n\n# 1. Installation des paquets\necho "📦 Installation de nginx et apache2 (optionnel)..."\nsudo apt update\nsudo apt install curl -y\nsudo apt install nginx apache2 -y\n\n# 2. Préparation du répertoire web\necho "📁 Création du site web ${WEB_ROOT}"\nsudo mkdir -p ${WEB_ROOT}\n\necho "📝 Création de la page d’accueil personnalisée..."\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\n<!DOCTYPE html>\n<html lang=\\"fr\\">\n<head>\n    <meta charset=\\"UTF-8\\">\n    <title>Camer-Web</title>\n</head>\n<body style=\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\">\n    <h1>✅ Bienvenue sur Camer-Web</h1>\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\n</body>\n</html>\nEOF\n\n# 3. Création du fichier NGINX vhost\necho "🔧 Configuration NGINX pour ${DOMAIN_NAME}..."\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\nserver {\n    listen 80;\n    server_name ${DOMAIN_NAME};\n\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\n\n    root ${WEB_ROOT};\n    index index.html;\n\n    location / {\n        try_files \\$uri \\$uri/ =404;\n    }\n}\nEOF\n\n# 4. Activation du site et désactivation du défaut\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\nsudo rm -f /etc/nginx/sites-enabled/default\n\n# 5. Redémarrage des services\necho "🚀 Redémarrage de NGINX..."\nsudo systemctl restart nginx\nsudo systemctl enable nginx\n\n# 6. Pare-feu\necho "🛡️ Configuration UFW pour NGINX..."\nsudo ufw allow OpenSSH\nsudo ufw allow 80/tcp\nsudo ufw allow 443/tcp\nsudo ufw --force enable\n\necho\necho "✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne."\n\n: "\\${INSTANCE_ID:?INSTANCE_ID is required}"\n\n# Save instance identifier\necho "INSTANCE_ID=\\${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null\necho "export INSTANCE_ID=\\${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\nsudo chmod +x /etc/profile.d/instance_id.sh\nexport INSTANCE_ID=\\${INSTANCE_ID}\n\n# Log initialization\necho "$(date --iso-8601=seconds) - Initialized instance with ID: \\${INSTANCE_ID}" | sudo tee -a /var/log/init.log	/scripts/templates/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__tpl001.sh	{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web2.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.20.21"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"Camer-Web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}	actif	2025-08-06 13:47:06.231+01	2025-08-06 13:47:06.231+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\web\\web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__tpl001.sh
19	Surveillance des services - Génération du script	service_monitoring_script	monitoring	Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh	#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=""\nfor svc in "${SERVICES[@]}"; do\n  if systemctl list-units --type=service --all | grep -q "$svc"; then\n    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)\n    SERVICE_STATUS_JSON+="{\\"name\\":\\"$svc\\",\\"active\\":\\"$ACTIVE\\",\\"enabled\\":\\"$ENABLED\\"},"\n  fi\ndone\n\nSERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "services": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}	/scripts/templates/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_tpl001.sh	{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}	actif	2025-08-06 13:47:28.059+01	2025-08-06 13:47:28.059+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\monitoring\\service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_tpl001.sh
20	Surveillance système - Génération du script	system_monitoring_script	monitoring	Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh	#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance système\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk '{print $1}')\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\n\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\n\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\n\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\n\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "{\\"pid\\":%s,\\"cmd\\":\\"%s\\",\\"cpu\\":%s},", $1, $2, $3}')\nTOP_PROCESSES="[${TOP_PROCESSES%,}]"\n\ncat <<JSON > ${STATUS_JSON_PATH}\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "hostname": "${HOSTNAME}",\n  "ip_address": "${IP_ADDR}",\n  "load_average": "${LOAD_AVG}",\n  "memory": {\n    "total_kb": ${MEM_TOTAL},\n    "available_kb": ${MEM_AVAILABLE}\n  },\n  "disk": {\n    "total_bytes": ${DISK_TOTAL},\n    "used_bytes": ${DISK_USED},\n    "available_bytes": ${DISK_AVAIL}\n  },\n  "network": {\n    "interface": "${IFACE}",\n    "rx_bytes": ${RX_BYTES},\n    "tx_bytes": ${TX_BYTES}\n  },\n  "open_ports": [${OPEN_PORTS}],\n  "top_processes": ${TOP_PROCESSES}\n}\nJSON\nEOS\n\nchmod +x ${STATUS_SCRIPT_PATH}	/scripts/templates/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_tpl001.sh	{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}	actif	2025-08-06 13:47:52.567+01	2025-08-06 13:47:52.567+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\monitoring\\system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_tpl001.sh
21	Activation des cronjobs de supervision	monitoring_cron	monitoring	Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.	#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT="${STATUS_SCRIPT}"\nSERVICES_SCRIPT="${SERVICES_SCRIPT}"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f "$STATUS_SCRIPT" ]; then\n  grep -q "$STATUS_SCRIPT" /etc/crontab || echo "*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT" >> /etc/crontab\n  echo "✅ Cron job ajouté pour status.sh"\nelse\n  echo "❌ Script $STATUS_SCRIPT introuvable"\nfi\n\nif [ -f "$SERVICES_SCRIPT" ]; then\n  grep -q "$SERVICES_SCRIPT" /etc/crontab || echo "*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT" >> /etc/crontab\n  echo "✅ Cron job ajouté pour services_status.sh"\nelse\n  echo "❌ Script $SERVICES_SCRIPT introuvable"\nfi	/scripts/templates/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_tpl001.sh	{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}	actif	2025-08-06 13:48:14.821+01	2025-08-06 13:48:14.821+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\monitoring\\monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_tpl001.sh
22	Activation des cronjobs de supervision	monitoring_cron	monitoring	Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.	#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT="${STATUS_SCRIPT}"\nSERVICES_SCRIPT="${SERVICES_SCRIPT}"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f "$STATUS_SCRIPT" ]; then\n  grep -q "$STATUS_SCRIPT" /etc/crontab || echo "*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT" >> /etc/crontab\n  echo "✅ Cron job ajouté pour status.sh"\nelse\n  echo "❌ Script $STATUS_SCRIPT introuvable"\nfi\n\nif [ -f "$SERVICES_SCRIPT" ]; then\n  grep -q "$SERVICES_SCRIPT" /etc/crontab || echo "*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT" >> /etc/crontab\n  echo "✅ Cron job ajouté pour services_status.sh"\nelse\n  echo "❌ Script $SERVICES_SCRIPT introuvable"\nfi	/scripts/templates/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_tpl002.sh	{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}	actif	2025-08-06 15:38:16.373+01	2025-08-06 15:38:16.373+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\scripts\\templates\\monitoring\\monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_tpl002.sh
\.


--
-- Data for Name: user_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_settings (id, user_id, cloudinit_user, cloudinit_password, proxmox_api_url, proxmox_api_token_id, proxmox_api_token_name, proxmox_api_token_secret, pm_user, pm_password, proxmox_node, vm_storage, vm_bridge, ssh_public_key_path, ssh_private_key_path, statuspath, servicespath, instanceinfopath, proxmox_host, proxmox_ssh_user, created_at, updated_at) FROM stdin;
1	1	nexus	Nexus2023.	https://192.168.24.134:8006/api2/json	root@pam	delete	0a804aa8-029e-4503-83a3-3fb51a804771	root@pam	Nexus2023.	pve	local-lvm	vmbr0	C:/Users/Nexus-PC/.ssh/id_rsa.pub	C:/Users/Nexus-PC/.ssh/id_rsa	/opt/monitoring/status.json	/opt/monitoring/services_status.json	/etc/instance-info.conf	192.168.24.134	root	2025-08-06 04:39:32.328273+01	2025-08-06 12:17:39.951+01
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, phone, password, status, reset_token, reset_expires_at, last_password_reset_at, role_id, created_at, updated_at) FROM stdin;
1	Nexus	Nexus Latif	latifnjimoluh@gmail.com	555-0100	$2b$10$/7k8y44BfxY.BBTDrtTNCuxR4jZ0B5oUNHUeBErGFxI.2amWvtb96	active	178494	2025-08-07 04:18:09.51+01	2025-08-06 04:41:00.376+01	1	2025-08-06 04:39:32.324893+01	2025-08-07 04:47:46.965+01
\.


--
-- Name: ai_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_cache_id_seq', 3, true);


--
-- Name: converted_vms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.converted_vms_id_seq', 2, true);


--
-- Name: deletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deletes_id_seq', 27, true);


--
-- Name: deployments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deployments_id_seq', 11, true);


--
-- Name: generated_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.generated_scripts_id_seq', 28, true);


--
-- Name: initialization_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.initialization_scripts_id_seq', 1, true);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 409, true);


--
-- Name: monitored_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitored_services_id_seq', 1, true);


--
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitoring_scripts_id_seq', 1, true);


--
-- Name: monitorings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitorings_id_seq', 4, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 54, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: service_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_templates_id_seq', 22, true);


--
-- Name: user_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_settings_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- Name: ai_cache ai_cache_hash_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_cache
    ADD CONSTRAINT ai_cache_hash_key UNIQUE (hash);


--
-- Name: ai_cache ai_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_cache
    ADD CONSTRAINT ai_cache_pkey PRIMARY KEY (id);


--
-- Name: assigned_permissions assigned_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_permissions
    ADD CONSTRAINT assigned_permissions_pkey PRIMARY KEY (role_id, permission_id);


--
-- Name: converted_vms converted_vms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.converted_vms
    ADD CONSTRAINT converted_vms_pkey PRIMARY KEY (id);


--
-- Name: deletes deletes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deletes
    ADD CONSTRAINT deletes_pkey PRIMARY KEY (id);


--
-- Name: deployments deployments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployments
    ADD CONSTRAINT deployments_pkey PRIMARY KEY (id);


--
-- Name: generated_scripts generated_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generated_scripts
    ADD CONSTRAINT generated_scripts_pkey PRIMARY KEY (id);


--
-- Name: initialization_scripts initialization_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.initialization_scripts
    ADD CONSTRAINT initialization_scripts_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: monitored_services monitored_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitored_services
    ADD CONSTRAINT monitored_services_pkey PRIMARY KEY (id);


--
-- Name: monitoring_scripts monitoring_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring_scripts
    ADD CONSTRAINT monitoring_scripts_pkey PRIMARY KEY (id);


--
-- Name: monitorings monitorings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitorings
    ADD CONSTRAINT monitorings_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_key UNIQUE (name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: service_templates service_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_templates
    ADD CONSTRAINT service_templates_pkey PRIMARY KEY (id);


--
-- Name: user_settings user_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: assigned_permissions assigned_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_permissions
    ADD CONSTRAINT assigned_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: assigned_permissions assigned_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assigned_permissions
    ADD CONSTRAINT assigned_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: converted_vms converted_vms_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.converted_vms
    ADD CONSTRAINT converted_vms_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: deletes deletes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deletes
    ADD CONSTRAINT deletes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: deployments deployments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployments
    ADD CONSTRAINT deployments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: generated_scripts generated_scripts_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generated_scripts
    ADD CONSTRAINT generated_scripts_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.service_templates(id) ON DELETE CASCADE;


--
-- Name: logs logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_settings user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- PostgreSQL database dump complete
--

