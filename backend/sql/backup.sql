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

ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_role_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_settings DROP CONSTRAINT IF EXISTS user_settings_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.logs DROP CONSTRAINT IF EXISTS logs_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.generated_scripts DROP CONSTRAINT IF EXISTS generated_scripts_template_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deployments DROP CONSTRAINT IF EXISTS deployments_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deletes DROP CONSTRAINT IF EXISTS deletes_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.converted_vms DROP CONSTRAINT IF EXISTS converted_vms_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.assigned_permissions DROP CONSTRAINT IF EXISTS assigned_permissions_role_id_fkey;
ALTER TABLE IF EXISTS ONLY public.assigned_permissions DROP CONSTRAINT IF EXISTS assigned_permissions_permission_id_fkey;
DROP INDEX IF EXISTS public.idx_refresh_tokens_user;
DROP INDEX IF EXISTS public.idx_logs_user_id;
DROP INDEX IF EXISTS public.idx_logs_created_at;
DROP INDEX IF EXISTS public.idx_logs_action;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.user_settings DROP CONSTRAINT IF EXISTS user_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.service_templates DROP CONSTRAINT IF EXISTS service_templates_pkey;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_pkey;
ALTER TABLE IF EXISTS ONLY public.roles DROP CONSTRAINT IF EXISTS roles_name_key;
ALTER TABLE IF EXISTS ONLY public.refresh_tokens DROP CONSTRAINT IF EXISTS refresh_tokens_pkey;
ALTER TABLE IF EXISTS ONLY public.permissions DROP CONSTRAINT IF EXISTS permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.permissions DROP CONSTRAINT IF EXISTS permissions_key_key;
ALTER TABLE IF EXISTS ONLY public.monitorings DROP CONSTRAINT IF EXISTS monitorings_pkey;
ALTER TABLE IF EXISTS ONLY public.logs DROP CONSTRAINT IF EXISTS logs_pkey;
ALTER TABLE IF EXISTS ONLY public.generated_scripts DROP CONSTRAINT IF EXISTS generated_scripts_pkey;
ALTER TABLE IF EXISTS ONLY public.deployments DROP CONSTRAINT IF EXISTS deployments_pkey;
ALTER TABLE IF EXISTS ONLY public.deletes DROP CONSTRAINT IF EXISTS deletes_pkey;
ALTER TABLE IF EXISTS ONLY public.converted_vms DROP CONSTRAINT IF EXISTS converted_vms_pkey;
ALTER TABLE IF EXISTS ONLY public.assigned_permissions DROP CONSTRAINT IF EXISTS assigned_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.alerts DROP CONSTRAINT IF EXISTS alerts_pkey;
ALTER TABLE IF EXISTS ONLY public.ai_cache DROP CONSTRAINT IF EXISTS ai_cache_pkey;
ALTER TABLE IF EXISTS ONLY public.ai_cache DROP CONSTRAINT IF EXISTS ai_cache_hash_key;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.service_templates ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.roles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.permissions ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.monitorings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.logs ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.generated_scripts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.deployments ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.deletes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.converted_vms ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.alerts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.ai_cache ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_settings_id_seq;
DROP TABLE IF EXISTS public.user_settings;
DROP SEQUENCE IF EXISTS public.service_templates_id_seq;
DROP TABLE IF EXISTS public.service_templates;
DROP SEQUENCE IF EXISTS public.roles_id_seq;
DROP TABLE IF EXISTS public.roles;
DROP TABLE IF EXISTS public.refresh_tokens;
DROP SEQUENCE IF EXISTS public.permissions_id_seq;
DROP TABLE IF EXISTS public.permissions;
DROP SEQUENCE IF EXISTS public.monitorings_id_seq;
DROP TABLE IF EXISTS public.monitorings;
DROP SEQUENCE IF EXISTS public.logs_id_seq;
DROP TABLE IF EXISTS public.logs;
DROP SEQUENCE IF EXISTS public.generated_scripts_id_seq;
DROP TABLE IF EXISTS public.generated_scripts;
DROP SEQUENCE IF EXISTS public.deployments_id_seq;
DROP TABLE IF EXISTS public.deployments;
DROP SEQUENCE IF EXISTS public.deletes_id_seq;
DROP TABLE IF EXISTS public.deletes;
DROP SEQUENCE IF EXISTS public.converted_vms_id_seq;
DROP TABLE IF EXISTS public.converted_vms;
DROP TABLE IF EXISTS public.assigned_permissions;
DROP SEQUENCE IF EXISTS public.alerts_id_seq;
DROP TABLE IF EXISTS public.alerts;
DROP SEQUENCE IF EXISTS public.ai_cache_id_seq;
DROP TABLE IF EXISTS public.ai_cache;
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
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id integer NOT NULL,
    server character varying(255),
    service character varying(255),
    severity character varying(50),
    status character varying(50) DEFAULT 'en_cours'::character varying,
    description character varying(255),
    comment text,
    started_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alerts_id_seq OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


--
-- Name: assigned_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assigned_permissions (
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
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
    abs_path character varying,
    status character varying(20) DEFAULT 'actif'::character varying
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
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    user_id integer,
    action character varying(255) NOT NULL,
    details text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    host text,
    level character varying(20),
    source character varying(50)
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
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    logs_status json
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
    key character varying(255) NOT NULL,
    description character varying(255),
    status character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    name character varying(255) NOT NULL
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
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    jti uuid NOT NULL,
    user_id integer NOT NULL,
    device_id character varying(255) NOT NULL,
    revoked boolean DEFAULT false,
    expires_at timestamp with time zone NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    description text
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
    abs_path character varying,
    deleted_at timestamp without time zone
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
    status character varying(10) DEFAULT 'actif'::character varying,
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
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


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
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


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
4	explain_script	93ffd60cb15071cd624f3381f7ae9b5d607a3fb5e3db0c08583a6c88187bc878	#!/bin/bash\necho hello	Absolument ! Voici une analyse et des conseils pour ce script.\n\n---\n\n### 1. Explication du script\n\nCe script est un exemple très simple de script shell Bash.\n\n*   `#!/bin/bash` : C'est ce qu'on appelle un **shebang**. Il indique au système d'exploitation que le fichier doit être exécuté avec l'interpréteur `/bin/bash`. C'est la première ligne standard de la plupart des scripts shell pour garantir qu'ils sont interprétés correctement.\n*   `echo hello` : C'est la commande principale. `echo` est une commande intégrée au shell qui affiche le texte qui la suit (ici, le mot "hello") sur la **sortie standard**, qui est généralement votre terminal.\n\n**En résumé :** Lorsqu'il est exécuté, ce script affiche simplement le mot "hello" dans le terminal.\n\n---\n\n### 2. Conseils et alternatives après le déploiement\n\nMême pour un script aussi simple, le "déploiement" implique de penser à la manière dont il sera utilisé, maintenu et intégré dans un environnement plus large. Voici plusieurs pistes d'amélioration et alternatives.\n\n#### Améliorations de base du script\n\n1.  **Rendre le script exécutable**\n    Pour pouvoir exécuter le script directement (par ex. `./mon_script.sh`), vous devez lui donner les permissions d'exécution.\n    ```bash\n    chmod +x mon_script.sh\n    ```\n\n2.  **Utiliser des variables**\n    Au lieu d'écrire le texte en dur ("hardcoding"), utilisez des variables. C'est une bonne pratique qui rend le script plus flexible et facile à maintenir.\n    ```bash\n    #!/bin/bash\n    \n    # Définir une variable pour le message\n    MESSAGE="Hello, World!"\n    \n    # Afficher le contenu de la variable\n    # Les guillemets protègent les espaces et caractères spéciaux\n    echo "$MESSAGE"\n    ```\n\n3.  **Gestion des erreurs**\n    Un script robuste doit s'arrêter si une commande échoue. Pour cela, on ajoute généralement `set -e`.\n    *   `set -e` : Le script s'arrête immédiatement si une commande renvoie un code d'erreur non nul.\n    *   `set -o pipefail` : S'assure que si une étape dans un pipeline (`|`) échoue, toute la ligne est considérée comme un échec.\n    ```bash\n    #!/bin/bash\n    set -e\n    set -o pipefail\n    \n    echo "Cette commande va fonctionner"\n    commande_qui_n_existe_pas # Le script s'arrêtera ici\n    echo "Cette ligne ne sera jamais atteinte"\n    ```\n\n#### Intégration et automatisation (Vision DevOps)\n\n4.  **Journalisation (Logging)**\n    Au lieu de simplement afficher sur le terminal, un script en production devrait écrire dans un fichier de log, avec des informations de date/heure.\n    ```bash\n    #!/bin/bash\n    \n    LOG_FILE="/var/log/mon_app.log"\n    \n    # Redirige la sortie vers le fichier de log en ajoutant la date\n    echo "$(date '+%Y-%m-%d %H:%M:%S') - Script démarré" >> "$LOG_FILE"\n    echo "$(date '+%Y-%m-%d %H:%M:%S') - Hello" >> "$LOG_FILE"\n    ```\n    Pour une journalisation plus avancée, on peut utiliser l'utilitaire `logger` pour envoyer les messages vers `syslog`.\n\n5.  **Planification (Scheduling)**\n    Le script est-il destiné à être exécuté manuellement ou automatiquement ? Pour une exécution récurrente, on utilise un **cron job**.\n    Par exemple, pour exécuter le script tous les jours à 2h du matin :\n    ```crontab\n    # Éditer la crontab avec "crontab -e"\n    0 2 * * * /chemin/vers/mon_script.sh\n    ```\n\n6.  **Intégration dans un pipeline CI/CD**\n    Ce script pourrait être une étape dans un pipeline de déploiement (avec GitLab CI, GitHub Actions, Jenkins...). Dans ce contexte, son **code de sortie** est crucial.\n    *   Un code de sortie de `0` signifie "succès".\n    *   Tout autre code (de 1 à 255) signifie "échec".\n    Le pipeline utilisera ce code pour décider de passer à l'étape suivante ou d'arrêter le déploiement.\n\n#### Alternatives au script Bash\n\n7.  **Quand choisir un autre langage ?**\n    Bash est parfait pour enchaîner des commandes système, manipuler des fichiers ou pour des scripts simples. Cependant, si la logique devient complexe (structures de données, appels API, tests unitaires...), il est préférable d'utiliser un langage plus puissant.\n\n    *   **Python** : Excellent pour la manipulation de données (JSON, YAML), les interactions avec des API web et une gestion des erreurs plus fine. C'est un choix très courant en DevOps.\n      ```python\n      # equivalent.py\n      import sys\n      \n      def main():\n          print("Hello from Python!")\n          # En cas de succès, le script termine avec un code de sortie 0 par défaut\n          # En cas d'erreur : sys.exit(1)\n      \n      if __name__ == "__main__":\n          main()\n      ```\n\n    *   **Go** : Idéal si vous avez besoin de créer un binaire statique (un seul fichier exécutable sans dépendances) pour une performance maximale et une distribution facile.\n\n    *   **Outils de gestion de configuration (Ansible, Puppet, Chef)** : Si le but du script est de configurer un état sur un serveur (installer un paquet, vérifier qu'un service tourne...), un outil comme Ansible est souvent plus approprié. Il est déclaratif ("je veux que cet état soit atteint") plutôt qu'impératif ("exécute cette commande, puis celle-ci...").\n\n**Conclusion :** Votre script `echo hello` est le point de départ de toute automatisation. La vision DevOps consiste à immédiatement se demander : "Comment rendre ce script robuste, maintenable, sécurisé et l'intégrer dans un processus automatisé et surveillé ?".	\N	\N	2025-08-08 17:00:35.438+01	2025-08-08 17:00:35.438+01
5	simulate_execution	7ddcdac408524ea60559302ca1c25f13db1eac8ee0d03e16990595889b0e76f3	#!/bin/bash\nsystemctl restart nginx	Absolument. Voici une description détaillée de ce qui se passera lors de l'exécution de ce script.\n\n---\n\n### Description de l'exécution du script\n\nCe script exécute une seule commande : `systemctl restart nginx`. Pour que cette commande réussisse, elle doit être exécutée par un utilisateur avec des privilèges suffisants (généralement l'utilisateur `root` ou via `sudo`).\n\nVoici la réponse détaillée à vos questions :\n\n#### 1. Quelles ressources seront créées ou modifiées ?\n\nLe script ne **crée** pas de nouveaux fichiers de configuration de manière permanente, mais il **modifie** l'état de plusieurs ressources système de manière temporaire ou cyclique :\n\n*   **Processus Nginx :** C'est la modification la plus importante.\n    *   Tous les processus `nginx` existants (le processus maître et ses processus "workers") seront terminés (signal `SIGTERM`, puis `SIGKILL` si nécessaire).\n    *   De nouveaux processus `nginx` seront lancés. Le nouveau processus maître lira les fichiers de configuration actuels (situés par défaut dans `/etc/nginx/`) pour déterminer son comportement.\n\n*   **Fichier PID :** Le fichier contenant l'identifiant du processus maître Nginx (généralement `/var/run/nginx.pid` ou `/run/nginx.pid`) sera supprimé lorsque l'ancien processus s'arrête, puis recréé avec le nouvel identifiant de processus.\n\n*   **Sockets réseau :**\n    *   Les sockets réseau sur lesquels Nginx écoutait (typiquement le port 80 pour HTTP et 443 pour HTTPS) seront fermés.\n    *   Ils seront immédiatement rouverts par le nouveau processus Nginx. Pendant cette micro-seconde de transition, les nouvelles connexions entrantes peuvent être refusées.\n\n*   **Fichiers journaux (Logs) :** Nginx va rouvrir ses fichiers journaux (par exemple, `access.log` et `error.log`) et commencer à y écrire les nouvelles requêtes et les éventuelles erreurs du nouveau processus. Aucune nouvelle entrée ne sera ajoutée par les anciens processus.\n\n#### 2. Quels services seront redémarrés ?\n\n*   **Un seul service : `nginx`**.\n\nL'action `restart` indique à `systemd` (le gestionnaire de services du système) d'effectuer deux étapes :\n1.  **Arrêter (`stop`)** complètement le service `nginx`.\n2.  Puis **démarrer (`start`)** le service `nginx`.\n\nCela provoque une **brève interruption de service**. Toutes les connexions existantes sont coupées et pendant un court instant, le serveur web n'est pas disponible. C'est différent de la commande `systemctl reload nginx`, qui demande à Nginx de recharger sa configuration sans couper les connexions existantes.\n\n#### 3. Un redémarrage du système est-il nécessaire ?\n\n*   **Non, absolument pas.**\n\nLa commande `systemctl` est conçue spécifiquement pour gérer des services individuels **sans avoir à redémarrer l'ensemble du système d'exploitation**. Le système d'exploitation (le noyau Linux) et tous les autres services (base de données, SSH, etc.) continueront de fonctionner normalement sans aucune interruption.\n\n### En résumé\n\nCe script effectue une opération de maintenance ciblée et courante sur le serveur web Nginx. Il l'arrête complètement et le relance, ce qui a pour effet d'appliquer les changements de configuration qui auraient été faits dans ses fichiers. Cette opération provoque une interruption de service très brève pour Nginx uniquement et n'a **aucun impact** sur le reste du système.	\N	\N	2025-08-08 17:01:29.628+01	2025-08-08 17:01:29.628+01
6	simulate_execution	073b681ddf253bc154979e1a52a9d1a787c7301ee0f92116b37fd019010f8e51	#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT="${STATUS_SCRIPT}"\nSERVICES_SCRIPT="${SERVICES_SCRIPT}"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f "$STATUS_SCRIPT" ]; then\n  grep -q "$STATUS_SCRIPT" /etc/crontab || echo "*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT" >> /etc/crontab\n  echo "✅ Cron job ajouté pour status.sh"\nelse\n  echo "❌ Script $STATUS_SCRIPT introuvable"\nfi\n\nif [ -f "$SERVICES_SCRIPT" ]; then\n  grep -q "$SERVICES_SCRIPT" /etc/crontab || echo "*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT" >> /etc/crontab\n  echo "✅ Cron job ajouté pour services_status.sh"\nelse\n  echo "❌ Script $SERVICES_SCRIPT introuvable"\nfi	Absolument ! Voici une description détaillée de ce que fera ce script lors de son exécution.\n\n### Que se passera-t-il lors de son exécution ?\n\nLe but principal de ce script est d'ajouter deux tâches planifiées (cron jobs) au système, mais de manière "intelligente" et sécurisée. Il le fait en suivant une logique précise pour chaque tâche :\n\n1.  **Dépendance à des variables d'environnement** : Le script suppose que des variables d'environnement (`STATUS_SCRIPT`, `SERVICES_SCRIPT`, `STATUS_CRON_INTERVAL`, `SERVICES_CRON_INTERVAL`) ont été définies *avant* son lancement. Par exemple, il pourrait être exécuté comme ceci :\n    ```bash\n    STATUS_SCRIPT="/opt/monitoring/status.sh" \\\n    SERVICES_SCRIPT="/opt/monitoring/services_status.sh" \\\n    STATUS_CRON_INTERVAL=5 \\\n    SERVICES_CRON_INTERVAL=10 \\\n    ./votre_script.sh\n    ```\n\n2.  **Vérification du premier script (`status.sh`)** :\n    *   Il vérifie si le fichier spécifié par la variable `$STATUS_SCRIPT` existe (`if [ -f "$STATUS_SCRIPT" ]`).\n    *   **Si le fichier existe** :\n        *   Il lit le fichier `/etc/crontab` et cherche (`grep -q`) si une ligne contient déjà le chemin du script (`$STATUS_SCRIPT`). Le `-q` signifie "silencieux", il ne fait que renvoyer un statut de succès ou d'échec.\n        *   Si le chemin n'est **pas trouvé** (`||` signifie "OU"), il ajoute une nouvelle ligne à la fin du fichier `/etc/crontab`. Cette ligne sera, par exemple : `*/5 * * * * root /opt/monitoring/status.sh`.\n        *   Si le chemin est **déjà trouvé**, il ne fait rien.\n        *   Dans les deux cas (ajout ou déjà présent), il affiche le message : `✅ Cron job ajouté pour status.sh`.\n    *   **Si le fichier n'existe pas** :\n        *   Il affiche un message d'erreur : `❌ Script $STATUS_SCRIPT introuvable`.\n\n3.  **Vérification du second script (`services_status.sh`)** :\n    *   Il répète exactement la même logique pour le script défini dans `$SERVICES_SCRIPT` et l'intervalle `$SERVICES_CRON_INTERVAL`.\n\nEn résumé, le script s'assure que les scripts de monitoring existent avant de tenter d'ajouter une tâche cron, et il évite de créer des doublons dans le fichier `crontab`.\n\n---\n\n### Quelles ressources seront créées ou modifiées ?\n\nLa seule ressource système qui sera potentiellement modifiée est le fichier :\n*   **/etc/crontab**\n\nCe fichier sera modifié par l'**ajout de nouvelles lignes** (une pour chaque script), mais uniquement si deux conditions sont remplies pour chaque ligne :\n1.  Le script à exécuter existe bien sur le disque.\n2.  Une tâche cron pour ce même script n'existe pas déjà dans `/etc/crontab`.\n\nAucun nouveau fichier n'est créé par le script lui-même (il s'attend à ce que les scripts de monitoring existent déjà).\n\n---\n\n### Quels services seront redémarrés ?\n\n**Aucun service n'est explicitement redémarré par ce script.**\n\nCependant, le service `cron` (ou `crond` selon la distribution Linux) est conçu pour surveiller les changements dans ses fichiers de configuration, y compris `/etc/crontab`. Lorsqu'il détecte une modification, il **recharge automatiquement sa configuration** pour prendre en compte les nouvelles tâches.\n\nCe processus est transparent et automatique, il n'y a donc pas besoin d'une commande comme `systemctl restart cron`.\n\n---\n\n### Un redémarrage du système est-il nécessaire ?\n\n**Non, absolument pas.**\n\nLes modifications apportées au fichier `/etc/crontab` sont prises en compte "à chaud" par le service cron sans nécessiter le redémarrage ni du service lui-même, ni du système d'exploitation. Les nouvelles tâches planifiées deviendront actives dès que le service cron aura rechargé sa configuration (ce qui prend généralement moins d'une minute).	\N	\N	2025-08-10 13:04:40.037+01	2025-08-10 13:04:40.037+01
7	analyze_deployment_plan	3aa37fcb7b5984fe4e84e0867b011ecc0d84d0a51cfe0f70f62b1ca20c5532c0	{"vm_names":["ds-a-a-aa-a-a-a"],"template_name":"ubuntu-template","service_type":"monitoring__cron","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":10,"scripts":["monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]}		deployment_plan	\N	2025-08-12 13:06:23.209+01	2025-08-12 13:06:23.209+01
8	analyze_deployment_plan	0b026fab405433bd77bc1bab30b1c29604086ce973dc429ca7033e1b9ebbc249	{"vm_names":["ds-a-a-aa-a-a-a-2"],"template_name":"ubuntu-template","service_type":"monitoring__cron","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":10,"scripts":["monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]}	Absolument. Voici une analyse détaillée de la configuration de la VM, accompagnée de suggestions d'améliorations et de recommandations.\n\n---\n\n### Analyse et Recommandations pour le Déploiement de la VM\n\nBasé sur les paramètres fournis, la VM est destinée à exécuter des scripts de monitoring via des tâches planifiées (cron). C'est un cas d'usage courant mais qui nécessite une attention particulière pour être fiable et efficace.\n\n#### 1. Analyse de la configuration actuelle\n\nGlobalement, la configuration est un point de départ fonctionnel, mais elle n'est pas optimale et présente plusieurs points de friction potentiels.\n\n*   **Type de service (`monitoring__cron`)** :\n    *   **Analyse** : Le rôle est clair. Il s'agit d'un serveur dédié à l'orchestration de scripts. La charge de travail sera probablement **périodique et en rafale** (pics d'utilisation lors de l'exécution des scripts) plutôt que constante.\n\n*   **Ressources (2 vCPU, 2 Go de RAM)** :\n    *   **Analyse** : C'est une configuration **prudente, voire surdimensionnée**. Les tâches cron, même si elles exécutent des scripts de monitoring, consomment rarement autant de ressources en continu. La plupart du temps, la VM sera inactive.\n    *   **Verdict** : **Potentiellement sur-alloué.** On pourrait probablement démarrer avec moins et ajuster si nécessaire.\n\n*   **Taille du disque (10 Go)** :\n    *   **Analyse** : **Ceci est le point le plus critique et problématique de la configuration.** Une taille de 10 Go est extrêmement faible pour un serveur moderne.\n        *   Un système d'exploitation Ubuntu Server de base occupe déjà entre 4 et 6 Go.\n        *   Les scripts de monitoring vont générer des **logs**. Si la rotation des logs n'est pas gérée agressivement, le disque se remplira très rapidement, provoquant l'arrêt des services ou même du système.\n        *   Il ne reste quasiment aucune marge pour les mises à jour du système, les paquets additionnels, ou les fichiers temporaires.\n    *   **Verdict** : **Fortement sous-dimensionné et risqué.**\n\n*   **Template (`ubuntu-template`)** :\n    *   **Analyse** : Ubuntu est un excellent choix, stable et très répandu. Il est crucial de s'assurer que ce template est basé sur une version **LTS (Long-Term Support)**, comme Ubuntu 22.04 LTS, pour bénéficier de mises à jour de sécurité sur le long terme.\n    *   **Verdict** : **Approprié**, à condition que la version soit LTS.\n\n*   **Scripts** :\n    *   **Analyse** : Les noms des scripts indiquent des tâches de surveillance système et de services. Il est important de savoir ce que ces scripts font exactement : collectent-ils des métriques ? Font-ils des appels API ? Écrivent-ils beaucoup de données ? La complexité de ces scripts est le facteur principal qui déterminera les besoins réels en CPU/RAM.\n    *   **Verdict** : **Cohérent avec le rôle**, mais leur impact sur les ressources est une inconnue à valider.\n\n---\n\n#### 2. Suggestions d'améliorations (Pré-déploiement)\n\nVoici des actions concrètes pour optimiser la configuration avant de lancer le déploiement.\n\n##### Optimisation des ressources :\n\n1.  **Augmenter la taille du disque (Priorité #1)** :\n    *   **Recommandation** : Passer à **30 Go minimum**. 20 Go est un strict minimum acceptable. Cela offre une marge de manœuvre pour les logs, les mises à jour, et de potentiels outils supplémentaires. Le coût additionnel est marginal par rapport à la stabilité gagnée.\n\n2.  **Réduire les vCPU et la RAM (pour commencer)** :\n    *   **Recommandation** : Commencer avec **1 vCPU et 1 Go de RAM**. La plupart des plateformes de virtualisation permettent d'augmenter les ressources à chaud ou après un redémarrage rapide.\n    *   **Justification** : C'est une approche "start small" (commencer petit). Il est plus économique et efficace de surveiller la charge réelle et d'ajouter des ressources si nécessaire, plutôt que de payer pour des ressources inutilisées.\n\n##### Configurations alternatives :\n\n1.  **Utiliser les Timers `systemd` au lieu de `cron`** :\n    *   **Suggestion** : `systemd` (le gestionnaire de services et de système par défaut sur Ubuntu) propose des "timers" qui sont une alternative moderne et plus puissante à cron.\n    *   **Avantages** :\n        *   **Meilleure intégration** avec le système de logs (`journalctl`). Il est très facile de voir la sortie et les erreurs de chaque exécution.\n        *   **Contrôle plus fin** sur l'environnement d'exécution (ressources, permissions).\n        *   Dépendances entre les tâches plus faciles à gérer.\n\n2.  **Envisager une approche "Serverless" (Fonctions Cloud)** :\n    *   **Suggestion** : Si les scripts sont simples et s'exécutent périodiquement, l'utilisation de services comme **AWS Lambda, Google Cloud Functions ou Azure Functions** serait bien plus optimale.\n    *   **Avantages** :\n        *   **Pas de serveur à gérer** (mises à jour, sécurité, etc.).\n        *   **Paiement à l'usage** (uniquement pour le temps d'exécution du script, souvent gratuit dans la limite d'un certain quota).\n        *   Scalabilité automatique.\n\n##### Services complémentaires :\n\n1.  **Gestion centralisée des logs** :\n    *   Ne laissez pas les logs sur la VM. Envoyez-les vers un service centralisé (ex: Graylog, ELK Stack, ou les services natifs du cloud provider comme AWS CloudWatch Logs). Cela évite de remplir le disque et facilite l'analyse et l'alerte.\n\n2.  **Gestion de la configuration (IaC)** :\n    *   Utilisez un outil comme **Ansible** ou **Terraform** pour déployer et configurer la VM. Cela garantit que le déploiement est reproductible, documenté et facile à mettre à jour.\n\n---\n\n#### 3. Recommandations Post-Déploiement\n\nUne fois la VM déployée (avec les améliorations suggérées), voici les bonnes pratiques à mettre en place.\n\n##### Performance :\n\n1.  **Monitorer le moniteur** : Mettez en place un agent de monitoring (ex: `node_exporter` pour Prometheus, Datadog Agent) sur cette VM pour suivre sa propre consommation (CPU, RAM, disque, I/O).\n2.  **Analyser les pics de charge** : Observez l'utilisation des ressources spécifiquement pendant l'exécution des scripts. Si le CPU atteint 100% pendant de longues périodes ou si la RAM est saturée, il sera temps d'augmenter les ressources.\n3.  **Surveiller l'exécution des scripts** : Mettez en place un système de "heartbeat" (pulsation). À la fin d'une exécution réussie, le script "ping" une URL externe (ex: un service comme Healthchecks.io, Uptime Kuma). Si le ping n'est pas reçu dans le temps imparti, cela signifie que le cron n'a pas tourné ou a échoué, et une alerte est déclenchée. **C'est crucial pour la fiabilité d'un système basé sur cron.**\n\n##### Sécurité :\n\n1.  **Principe du moindre privilège** :\n    *   Créez un **utilisateur dédié** pour exécuter les scripts. Ne les exécutez **jamais en tant que `root`**.\n    *   Donnez à cet utilisateur les permissions minimales requises pour fonctionner (`sudo` uniquement pour les commandes qui en ont absolument besoin).\n2.  **Mises à jour régulières** : Configurez les mises à jour de sécurité automatiques (`unattended-upgrades`) pour que le système soit toujours protégé contre les vulnérabilités connues.\n3.  **Hardening du système** :\n    *   Configurez le pare-feu (`ufw`) pour n'autoriser que le trafic nécessaire (ex: SSH depuis des IP de confiance).\n    *   Sécurisez l'accès SSH : désactivez l'authentification par mot de passe au profit des clés SSH, et désactivez la connexion de l'utilisateur `root`.\n4.  **Gestion des secrets** : Si les scripts utilisent des clés d'API, des mots de passe ou des tokens, ne les stockez **jamais en clair** dans les fichiers. Utilisez un gestionnaire de secrets comme **HashiCorp Vault** ou les services de gestion de secrets de votre fournisseur cloud (ex: AWS Secrets Manager, Azure Key Vault).\n\nEn résumé, la configuration proposée est un brouillon qui nécessite une **révision critique de la taille du disque** et une **optimisation des ressources CPU/RAM**. L'adoption de pratiques modernes (timers systemd, monitoring du moniteur, gestion de la configuration) transformera ce simple déploiement en une solution de monitoring robuste et professionnelle.	deployment_plan	\N	2025-08-12 13:09:05.077+01	2025-08-12 13:09:05.077+01
9	analyze_dashboard	c02907bfd4c4d0e1722584970e2af40832c8a14dcc10ab54fdc935e754ac00bf	{"totals":{"deployed":27,"success":17,"failed":6,"deleted":35},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":14,"deleted":2,"success":4,"failed":6}]}	Absolument. Voici une analyse de ces données destinée à un administrateur système, axée sur l'interprétation, les conclusions et les actions à entreprendre.\n\n---\n\n### **Analyse des déploiements et suppressions de VM**\n\nCette analyse porte sur la période du 6 au 12 août 2025.\n\n#### **1. Tendances Marquantes et Points d'Attention**\n\nL'analyse de la timeline révèle plusieurs tendances critiques qui nécessitent une attention immédiate.\n\n*   **Pic d'échecs critique le 12/08 :** La journée du 12 août est un signal d'alarme majeur.\n    *   **Activité :** C'est la journée avec le plus grand nombre de déploiements tentés (14).\n    *   **Performance :** Le taux de succès s'est effondré à seulement **28%** (4 réussites sur 14 déploiements). Le taux d'échec confirmé est de **43%** (6 échecs).\n    *   **Interprétation :** Le système de déploiement, qui était parfaitement fiable en début de période (100% de succès les 6, 8 et 9 août), a connu une défaillance sévère sous une charge plus élevée. **Quelque chose a changé** entre le 9 et le 12 août (nouvelle image, mise à jour de l'hyperviseur, changement de configuration réseau/stockage ?).\n\n*   **Incohérence dans les métriques :**\n    *   Au total, **27 VM** sont listées comme "déployées", mais la somme des succès (17) et des échecs (6) n'est que de **23**.\n    *   Cette incohérence est particulièrement visible le 12/08 : 14 déploiements lancés, pour seulement 4 succès et 6 échecs. **Qu'est-il advenu des 4 VM restantes ?** Sont-elles dans un état "en attente", "inconnu" ou perdu ? Cela représente un risque potentiel de "VMs fantômes" consommant des ressources sans être suivies.\n\n*   **Forte activité de suppression ("nettoyage") :**\n    *   Avec **35 suppressions** pour seulement 27 déploiements, la tendance globale est à la réduction du parc de VM.\n    *   Le 6/08 a vu un nettoyage massif (27 suppressions), ce qui suggère la fin d'un projet, une migration ou une opération de maintenance planifiée. Ce contexte est important : l'activité n'est pas chaotique mais semble dictée par des événements spécifiques.\n\n#### **2. Conclusion sur l'État Global**\n\nL'état des déploiements est **préoccupant et instable**.\n\nBien que le système ait prouvé sa capacité à fonctionner parfaitement, sa fiabilité s'est brutalement dégradée. Un taux d'échec global de **26%** (6 échecs sur 23 déploiements terminés) est inacceptable pour un environnement de production.\n\nLe problème principal n'est pas le volume, mais **la fragilité du processus de déploiement face à une charge ou à un changement récent**. La confiance dans l'automatisation est actuellement rompue.\n\n#### **3. Recommandations et Plan d'Action**\n\nVoici les actions recommandées, classées par ordre de priorité.\n\n**A. Investigation Immédiate (Urgent)**\n\n1.  **Analyser les 6 échecs du 12/08 :**\n    *   **Action :** Plongez dans les logs (orchestrateur, hyperviseur, stockage) pour ces 6 déploiements. Identifiez la cause racine : timeout, erreur de configuration, problème d'accès au stockage, quota dépassé, bug dans le script de post-installation ?\n2.  **Identifier les "VMs fantômes" :**\n    *   **Action :** Retrouvez la trace des 4 déploiements non comptabilisés du 12/08. Sont-ils bloqués en cours de création ? Ont-ils été créés mais l'outil de reporting n'a pas reçu la confirmation ? Il est crucial de clarifier leur état pour éviter une consommation de ressources cachée.\n3.  **Identifier le "facteur X" du 12/08 :**\n    *   **Action :** Passez en revue le journal des changements (changelog). Qu'est-ce qui a été modifié entre le 9 et le 12 août ? Une nouvelle image de VM a-t-elle été utilisée ? Un patch de sécurité a-t-il été appliqué à l'infrastructure ? C'est le suspect principal.\n\n**B. Améliorations à Moyen Terme**\n\n4.  **Fiabiliser le reporting :**\n    *   **Action :** Modifiez le script ou l'outil de monitoring pour qu'il n'y ait plus de déploiements non suivis. Chaque tentative doit se terminer par un statut clair : `succès`, `échec`, ou `annulé`.\n5.  **Mettre en place des tests de validation d'image :**\n    *   **Action :** Avant de mettre une nouvelle image ou un nouveau template en production, faites-lui passer une batterie de tests automatisés, incluant un déploiement test. Cela aurait probablement intercepté le problème avant le 12/08.\n6.  **Renforcer l'alerting :**\n    *   **Action :** Configurez des alertes qui se déclenchent si le taux d'échec des déploiements dépasse un certain seuil (ex: >10%) sur une période donnée (ex: 1 heure). Vous auriez ainsi été notifié en temps réel de la dégradation le 12/08.\n\n**C. Stratégie à Long Terme**\n\n7.  **Implémenter un mécanisme de Rollback automatique :**\n    *   **Action :** Pour les déploiements critiques, mettez en place une procédure qui, en cas d'échec, nettoie automatiquement les ressources partiellement créées (IP, disque, VM) pour revenir à un état propre.\n8.  **Effectuer des tests de charge :**\n    *   **Action :** La défaillance ayant eu lieu lors d'un pic d'activité, planifiez des tests de charge trimestriels sur votre infrastructure de déploiement pour identifier les goulots d'étranglement avant qu'ils n'impactent la production.	\N	\N	2025-08-12 13:12:39.36+01	2025-08-12 13:12:39.36+01
10	analyze_script	48df1a645e4f6104c66f0e367b39e5633b2854bd7b88e7a3798b052df8716135	#!/bin/bash\nset -euo pipefail\n\n# === Variables substituées par le moteur de template ===\nSCRIPT_PATH="/opt/monitoring/monitoring.sh"\nSTATUS_SCRIPT_PATH="/opt/monitoring/status.sh"\nSERVICES_SCRIPT_PATH="/opt/monitoring/services_status.sh"\nSTATUS_CRON_EXPR='*/1 * * * *'\nSERVICES_CRON_EXPR='*/1 * * * *'\nCRON_USER='nexus'\n\nMONITOR_DIR="$(dirname "/opt/monitoring/status.sh")"\nMARK_BOOT="# MONITORING_CRON"\nMARK_STATUS="# MONITORING_STATUS_CRON"\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\n\nmkdir -p "${MONITOR_DIR}"\n\n# --- Génère le script  ---\ncat > "/opt/monitoring/monitoring.sh" <<'EOS'\n#!/bin/bash\nset -euo pipefail\n\nSTATUS_SCRIPT_PATH="__STATUS_SCRIPT_PATH__"\nSERVICES_SCRIPT_PATH="__SERVICES_SCRIPT_PATH__"\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\nCRON_USER='__CRON_USER__'\nMARK_BOOT="# MONITORING_CRON"\nMARK_STATUS="# MONITORING_STATUS_CRON"\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\n\nexists_and_exec() {\n  local f="$1"\n  [[ -f "$f" ]] || return 1\n  [[ -x "$f" ]] || chmod +x "$f" || true\n  return 0\n}\n\ncrontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }\ncrontab_set() { crontab -u "$CRON_USER" -; }\n\nadd_cron_once() {\n  local expr="$1" cmd="$2" mark="$3"\n  local current\n  current="$(crontab_get)"\n  if ! echo "$current" | grep -Fq "$mark"; then\n    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set\n  fi\n}\n\nremove_mark() {\n  local mark="$1"\n  crontab_get | grep -Fv "$mark" | crontab_set\n}\n\nok=1\nif exists_and_exec "$STATUS_SCRIPT_PATH"; then\n  add_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1" "$MARK_STATUS"\nelse\n  ok=0\nfi\n\nif exists_and_exec "$SERVICES_SCRIPT_PATH"; then\n  add_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1" "$MARK_SERVICES"\nelse\n  ok=0\nfi\n\nif [[ "$ok" -eq 1 ]]; then\n  # Exécuter une première fois pour générer les JSON immédiatement\n  bash "$STATUS_SCRIPT_PATH" || true\n  bash "$SERVICES_SCRIPT_PATH" || true\n  # Se retirer du crontab\n  remove_mark "$MARK_BOOT"\nfi\nEOS\n\n# Injecte les variables réelles dans le \nsed -i \\\n  -e "s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\//\\\\/}#g" \\\n  -e "s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\//\\\\/}#g" \\\n  -e "s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\//\\\\/}#g" \\\n  -e "s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\//\\\\/}#g" \\\n  -e "s#__CRON_USER__#nexus#g" \\\n  "/opt/monitoring/monitoring.sh"\n\nchmod +x "/opt/monitoring/monitoring.sh"\n\n# --- (Ré)active le service cron/ crond ---\nif command -v systemctl >/dev/null 2>&1; then\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\nfi\n\n# --- Installe le cron  (toutes les minutes) ---\ncurrent_cron="$(crontab -u "nexus" -l 2>/dev/null || true)"\nif ! echo "$current_cron" | grep -Fq "$MARK_BOOT"; then\n  { echo "$current_cron" | grep -Fv "$MARK_BOOT"; echo "* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT"; } | crontab -u "nexus" -\nfi\n\nexit 0\n	Absolument. Voici une analyse détaillée, des alternatives et une version améliorée de votre script.\n\n---\n\n### 1. Analyse du script original\n\nCe script a un objectif clair : mettre en place de manière asynchrone des tâches cron pour monitorer une application, mais seulement lorsque les scripts de monitoring (`status.sh`, `services_status.sh`) sont effectivement présents sur le système.\n\n**Points forts :**\n*   **Idempotence :** L'utilisation de marqueurs (`# MONITORING_...`) dans le crontab est une bonne pratique pour éviter d'ajouter des tâches en double. Le script peut être exécuté plusieurs fois sans causer de problèmes.\n*   **Séparation des privilèges :** Le cron final est configuré pour s'exécuter avec un utilisateur non-privilégié (`nexus`), ce qui est excellent pour la sécurité.\n*   **Robustesse de base :** L'utilisation de `set -euo pipefail` est une très bonne pratique pour rendre les scripts plus sûrs.\n*   **Logique de "bootstrap" :** Le script d'installation (`monitoring.sh`) se retire lui-même du crontab une fois sa mission accomplie. C'est une conception intelligente pour une tâche de configuration unique.\n\n**Points faibles et améliorations possibles :**\n1.  **Complexité inutile :** Le script génère un autre script (`monitoring.sh`) via un *heredoc* puis utilise `sed` pour substituer les variables. C'est une approche fonctionnelle mais complexe et sujette aux erreurs (caractères spéciaux dans les variables, etc.).\n2.  **Manipulation directe du crontab :** L'enchaînement `crontab -l | ... | crontab -` est une pratique courante mais fragile. Elle n'est pas atomique et peut être sujette à des "race conditions" (conditions de concurrence) si un autre processus modifie le crontab au même moment. Les modifications peuvent être perdues.\n3.  **Polling intensif :** Le script de "bootstrap" (`monitoring.sh`) est exécuté toutes les minutes. C'est beaucoup pour une tâche de configuration qui ne réussira qu'une seule fois. Cela génère une charge et des logs inutiles en attendant que les scripts dépendants soient déployés.\n4.  **Nom de fonction ambigu :** La fonction `exists_and_exec` ne fait pas ce que son nom indique. Elle vérifie l'existence et *rend* le fichier exécutable (`chmod +x`), mais ne l'exécute pas. Un nom comme `ensure_is_executable` serait plus clair.\n5.  **Gestion des erreurs masquée :** L'utilisation de `|| true` à plusieurs endroits (ex: `systemctl ... || true`) peut masquer des problèmes de configuration réels (par exemple, si le service cron n'existe vraiment pas sous les noms `cron` ou `crond`).\n6.  **Dépendance à `crontab` :** Le script suppose que l'utilisateur `nexus` a le droit d'utiliser `crontab` et que le binaire est disponible.\n\n---\n\n### 2. Alternatives et pratiques modernes\n\n1.  **Utiliser `/etc/cron.d/` (Alternative la plus simple et robuste) :**\n    *   Au lieu de manipuler le crontab d'un utilisateur, on peut déposer des fichiers de configuration directement dans le répertoire `/etc/cron.d/`.\n    *   **Avantages :**\n        *   **Atomicité :** La création de fichier est atomique (on peut écrire dans un fichier temporaire puis le renommer avec `mv`).\n        *   **Clarté :** Les tâches cron sont visibles par les administrateurs système dans un emplacement standard.\n        *   **Gestion centralisée :** Facile à gérer avec des outils de configuration comme Ansible, Puppet, etc.\n        *   **Pas de `crontab -e` :** On n'interfère pas avec les modifications manuelles que l'utilisateur pourrait faire sur son propre crontab.\n    *   Le format est légèrement différent, il inclut le nom de l'utilisateur : `* * * * * <utilisateur> <commande>`.\n\n2.  **Systemd Timers (Alternative moderne sur les systèmes récents) :**\n    *   Sur la plupart des distributions Linux modernes, `systemd` a remplacé cron. Les *timers* sont plus flexibles et plus puissants.\n    *   **Avantages :**\n        *   **Journalisation intégrée :** La sortie de chaque exécution est capturée par `journald` (`journalctl -u mon-service.service`).\n        *   **Flexibilité :** Déclenchements plus complexes (ex: "5 minutes après le démarrage", "toutes les 15 minutes entre 9h et 17h").\n        *   **Gestion des dépendances :** Peut être lié à des services réseau ou à d'autres unités systemd.\n    *   **Inconvénient :** Un peu plus verbeux à mettre en place (nécessite un fichier `.timer` et un fichier `.service`).\n\n3.  **Simplification du Script (Approche générale) :**\n    *   Éviter la génération de script en deux temps. Le script d'installation peut contenir toute la logique. Si une variable est nécessaire, elle peut être passée en paramètre ou lue depuis un fichier de configuration. Le *heredoc* avec expansion de variable (`<<EOF` au lieu de `<<'EOF'`) est beaucoup plus simple que la substitution avec `sed`.\n\n---\n\n### 3. Version optimisée du script\n\nCette version révisée applique les meilleures pratiques discutées :\n*   Elle n'utilise **qu'un seul script**.\n*   Elle utilise **`/etc/cron.d/`** pour une gestion robuste et atomique des tâches cron.\n*   La logique est simplifiée et plus facile à lire.\n*   Elle s'exécute en tant que `root` (nécessaire pour écrire dans `/etc/cron.d/`) mais s'assure que les tâches finales s'exécutent en tant que `nexus`.\n\n```bash\n#!/bin/bash\nset -euo pipefail\n\n# === Variables de configuration ===\n# Le script doit être exécuté en tant que root.\n\n# Scripts à surveiller et à exécuter\nSTATUS_SCRIPT_PATH="/opt/monitoring/status.sh"\nSERVICES_SCRIPT_PATH="/opt/monitoring/services_status.sh"\n\n# Configuration des tâches Cron finales\nSTATUS_CRON_EXPR='*/1 * * * *'\nSERVICES_CRON_EXPR='*/1 * * * *'\nCRON_USER='nexus'\n\n# Fichiers Cron gérés par ce script\n# Le fichier de bootstrap sera supprimé une fois la configuration terminée.\nCRON_BOOTSTRAP_FILE="/etc/cron.d/app-monitoring-setup"\nCRON_FINAL_FILE="/etc/cron.d/app-monitoring"\n\n# --- Fonctions utilitaires ---\n\n# Affiche un message et quitte avec un code d'erreur.\nfail() {\n  echo "ERREUR: $*" >&2\n  exit 1\n}\n\n# S'assure qu'un fichier existe et est exécutable.\nensure_executable() {\n  local f="$1"\n  [[ -f "$f" ]] || return 1\n  # Ne change les permissions que si nécessaire.\n  [[ -x "$f" ]] || chmod +x "$f"\n}\n\n# --- Début du script ---\n\n# 1. Vérification des prérequis\nif [[ "$(id -u)" -ne 0 ]]; then\n  fail "Ce script doit être exécuté en tant que root pour gérer les fichiers dans /etc/cron.d/"\nfi\n\n# 2. Création du répertoire de monitoring\nmkdir -p "$(dirname "$STATUS_SCRIPT_PATH")"\n\n# 3. Logique principale : vérifier si la configuration finale peut être appliquée\nif ensure_executable "$STATUS_SCRIPT_PATH" && ensure_executable "$SERVICES_SCRIPT_PATH"; then\n  # CAS 1 : Les deux scripts de monitoring existent. On peut finaliser l'installation.\n  \n  echo "Scripts de monitoring détectés. Configuration finale en cours..."\n\n  # Création du fichier cron final avec les tâches de monitoring.\n  # L'utilisation de `tee` permet de gérer les permissions sans `sudo` dans un heredoc.\n  tee "$CRON_FINAL_FILE" > /dev/null <<EOF\n# Fichier Cron pour le monitoring de l'application - Géré automatiquement\n# Tâche de statut global\n$STATUS_CRON_EXPR $CRON_USER bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\n\n# Tâche de statut des services\n$SERVICES_CRON_EXPR $CRON_USER bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\nEOF\n  # S'assure que le fichier cron a les bonnes permissions (lecture pour tous)\n  chmod 0644 "$CRON_FINAL_FILE"\n\n  echo "Tâches Cron finales installées dans $CRON_FINAL_FILE."\n\n  # Exécuter une première fois pour générer les JSON immédiatement\n  # On utilise `sudo -u` pour lancer la commande en tant que l'utilisateur cible\n  echo "Exécution initiale des scripts..."\n  sudo -u "$CRON_USER" bash "$STATUS_SCRIPT_PATH" || echo "Avertissement: l'exécution initiale de status.sh a échoué."\n  sudo -u "$CRON_USER" bash "$SERVICES_SCRIPT_PATH" || echo "Avertissement: l'exécution initiale de services_status.sh a échoué."\n\n  # Supprimer le cron de bootstrap, car il n'est plus nécessaire.\n  if [[ -f "$CRON_BOOTSTRAP_FILE" ]]; then\n    rm -f "$CRON_BOOTSTRAP_FILE"\n    echo "Le cron de bootstrap a été supprimé."\n  fi\n\n  echo "Configuration du monitoring terminée."\n\nelse\n  # CAS 2 : Au moins un des scripts de monitoring est manquant. On met en place le polling.\n\n  # Ne crée le fichier de bootstrap que s'il n'existe pas déjà.\n  if [[ ! -f "$CRON_FINAL_FILE" ]]; then\n    echo "Scripts de monitoring non trouvés. Mise en place d'une vérification périodique."\n    \n    # Le cron exécute ce même script en tant que root toutes les minutes.\n    # `flock` empêche les exécutions multiples si le script prend plus d'une minute.\n    tee "$CRON_BOOTSTRAP_FILE" > /dev/null <<EOF\n# Fichier Cron pour installer le monitoring de l'application - Géré automatiquement\n# Ce fichier sera supprimé une fois l'installation terminée.\n* * * * * root flock -n /tmp/monitoring-setup.lock bash $0\nEOF\n    chmod 0644 "$CRON_BOOTSTRAP_FILE"\n    echo "Ce script sera ré-exécuté toutes les minutes jusqu'à ce que les dépendances soient satisfaites."\n  else\n    echo "La configuration finale est déjà en place. Aucune action requise."\n  fi\nfi\n\n# 4. (Ré)activer le service cron/crond si possible\nif command -v systemctl >/dev/null 2>&1; then\n  if ! systemctl is-active --quiet cron && ! systemctl is-active --quiet crond; then\n    echo "Activation du service cron..."\n    systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || \\\n      echo "Avertissement: Impossible de démarrer le service 'cron' ou 'crond'."\n  fi\nfi\n\nexit 0\n```\n\n### Résumé des améliorations de la nouvelle version :\n\n1.  **Simplicité :** Un seul script, pas de génération de code ni de `sed`. La logique est linéaire et plus facile à suivre.\n2.  **Robustesse :** Utilise `/etc/cron.d/` pour éviter les conditions de concurrence et pour une gestion plus propre. L'ajout de `flock` dans le cron de bootstrap empêche que le script ne s'exécute plusieurs fois en parallèle s'il venait à être long.\n3.  **Clarté :** Les noms de variables et les commentaires expliquent l'intention. Le script informe l'utilisateur de ce qu'il fait.\n4.  **Sécurité :** Vérifie qu'il est exécuté en tant que `root` (une nécessité pour cette approche), mais délègue bien l'exécution finale à l'utilisateur non-privilégié.\n5.  **Moins de "bruit" :** Le cron de bootstrap ne se recrée pas à chaque exécution, et la logique de polling est clairement séparée du cas de succès.	script	29	2025-08-12 13:19:37.531+01	2025-08-12 13:19:37.531+01
11	analyze_dashboard	3e9248198b7429a42e1131f5e5c7a1ad13e1f5e75701d0a18c73892f2e19c90a	{"totals":{"deployed":29,"success":17,"failed":9,"deleted":35},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":16,"deleted":2,"success":4,"failed":9}]}		\N	\N	2025-08-12 15:24:00.448+01	2025-08-12 15:24:00.448+01
12	analyze_script	9ac31ca7d453411c34005540a32232db56f18235581c0968c018fa73796a9a1e	#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=""\nfor svc in "${SERVICES[@]}"; do\n  if systemctl list-units --type=service --all | grep -q "$svc"; then\n    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)\n    SERVICE_STATUS_JSON+="{\\"name\\":\\"$svc\\",\\"active\\":\\"$ACTIVE\\",\\"enabled\\":\\"$ENABLED\\"},"\n  fi\ndone\n\nSERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "services": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}		template	27	2025-08-12 16:18:23.628+01	2025-08-12 16:18:23.628+01
13	analyze_script	7db4448cb4b589027a8f905cc2af52058124164c84a5ab152f8ff758ac4293c4	#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance système\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk '{print $1}')\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\n\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\n\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\n\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\n\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "{\\"pid\\":%s,\\"cmd\\":\\"%s\\",\\"cpu\\":%s},", $1, $2, $3}')\nTOP_PROCESSES="[${TOP_PROCESSES%,}]"\n\ncat <<JSON > ${STATUS_JSON_PATH}\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "hostname": "${HOSTNAME}",\n  "ip_address": "${IP_ADDR}",\n  "load_average": "${LOAD_AVG}",\n  "memory": {\n    "total_kb": ${MEM_TOTAL},\n    "available_kb": ${MEM_AVAILABLE}\n  },\n  "disk": {\n    "total_bytes": ${DISK_TOTAL},\n    "used_bytes": ${DISK_USED},\n    "available_bytes": ${DISK_AVAIL}\n  },\n  "network": {\n    "interface": "${IFACE}",\n    "rx_bytes": ${RX_BYTES},\n    "tx_bytes": ${TX_BYTES}\n  },\n  "open_ports": [${OPEN_PORTS}],\n  "top_processes": ${TOP_PROCESSES}\n}\nJSON\nEOS\n\nchmod +x ${STATUS_SCRIPT_PATH}	Absolument ! Voici une analyse détaillée, des alternatives modernes, et une version optimisée de votre script.\n\n### 1. Analyse et Améliorations Possibles\n\nVotre script est un bon point de départ, typique de ce qu'on trouve dans les scripts de *bootstrap* ou *user-data* pour des instances cloud. Cependant, plusieurs points peuvent être améliorés en termes de robustesse, d'efficacité et de bonnes pratiques.\n\n**Points forts :**\n\n*   **Idempotence :** `mkdir -p` est une bonne pratique, car il ne génère pas d'erreur si le dossier existe déjà.\n*   **Heredoc avec guillemets simples :** `cat <<'EOS'` est excellent. L'utilisation des guillemets simples `''` autour de `EOS` empêche le shell *externe* d'interpréter les variables (`${...}`) à l'intérieur du bloc, les laissant pour le script *interne*, ce qui est l'intention ici.\n*   **Portabilité :** L'utilisation d'outils standards (`cut`, `awk`, `grep`, `df`, `ss`) le rend assez portable sur la plupart des systèmes Linux.\n\n**Points faibles et axes d'amélioration :**\n\n1.  **Variables non définies :** Les variables `${STATUS_SCRIPT_PATH}` et `${STATUS_JSON_PATH}` sont utilisées mais jamais définies dans le script de template. C'est le bug le plus critique. Le script échouera tel quel.\n2.  **Inefficacité des commandes :**\n    *   `grep` et `awk` sont appelés deux fois pour lire `/proc/meminfo`. Un seul appel à `awk` peut extraire les deux valeurs.\n    *   `df` est appelé trois fois pour obtenir trois colonnes de la même ligne. Un seul appel suffit.\n3.  **Fragilité du parsing :**\n    *   **`TOP_PROCESSES` est très fragile :** La commande `awk '{printf "{\\"pid\\":%s,\\"cmd\\":\\"%s\\",\\"cpu\\":%s},", $1, $2, $3}'` suppose que le nom de la commande (`comm`) ne contient pas d'espaces. Si un processus s'appelle	template	26	2025-08-12 16:26:43.364+01	2025-08-12 16:26:43.364+01
14	analyze_script	dfe259700db150048a8ef9085c096591423d29d4814c61444642089562c67d97	#!/bin/bash\nset -euo pipefail\n\n# === Variables substituées par le moteur de template ===\nSCRIPT_PATH="${SCRIPT_PATH}"\nSTATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH}"\nSERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH}"\nSTATUS_CRON_EXPR='${STATUS_CRON_EXPR}'\nSERVICES_CRON_EXPR='${SERVICES_CRON_EXPR}'\nCRON_USER='${CRON_USER}'\n\nMONITOR_DIR="$(dirname "${STATUS_SCRIPT_PATH}")"\nMARK_BOOT="# MONITORING_CRON"\nMARK_STATUS="# MONITORING_STATUS_CRON"\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\n\nmkdir -p "${MONITOR_DIR}"\n\n# --- Génère le script  ---\ncat > "${SCRIPT_PATH}" <<'EOS'\n#!/bin/bash\nset -euo pipefail\n\nSTATUS_SCRIPT_PATH="__STATUS_SCRIPT_PATH__"\nSERVICES_SCRIPT_PATH="__SERVICES_SCRIPT_PATH__"\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\nCRON_USER='__CRON_USER__'\nMARK_BOOT="# MONITORING_CRON"\nMARK_STATUS="# MONITORING_STATUS_CRON"\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\n\nexists_and_exec() {\n  local f="$1"\n  [[ -f "$f" ]] || return 1\n  [[ -x "$f" ]] || chmod +x "$f" || true\n  return 0\n}\n\ncrontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }\ncrontab_set() { crontab -u "$CRON_USER" -; }\n\nadd_cron_once() {\n  local expr="$1" cmd="$2" mark="$3"\n  local current\n  current="$(crontab_get)"\n  if ! echo "$current" | grep -Fq "$mark"; then\n    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set\n  fi\n}\n\nremove_mark() {\n  local mark="$1"\n  crontab_get | grep -Fv "$mark" | crontab_set\n}\n\nok=1\nif exists_and_exec "$STATUS_SCRIPT_PATH"; then\n  add_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1" "$MARK_STATUS"\nelse\n  ok=0\nfi\n\nif exists_and_exec "$SERVICES_SCRIPT_PATH"; then\n  add_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1" "$MARK_SERVICES"\nelse\n  ok=0\nfi\n\nif [[ "$ok" -eq 1 ]]; then\n  # Exécuter une première fois pour générer les JSON immédiatement\n  bash "$STATUS_SCRIPT_PATH" || true\n  bash "$SERVICES_SCRIPT_PATH" || true\n  # Se retirer du crontab\n  remove_mark "$MARK_BOOT"\nfi\nEOS\n\n# Injecte les variables réelles dans le \nsed -i \\\n  -e "s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\//\\\\/}#g" \\\n  -e "s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\//\\\\/}#g" \\\n  -e "s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\//\\\\/}#g" \\\n  -e "s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\//\\\\/}#g" \\\n  -e "s#__CRON_USER__#${CRON_USER}#g" \\\n  "${SCRIPT_PATH}"\n\nchmod +x "${SCRIPT_PATH}"\n\n# --- (Ré)active le service cron/ crond ---\nif command -v systemctl >/dev/null 2>&1; then\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\nfi\n\n# --- Installe le cron  (toutes les minutes) ---\ncurrent_cron="$(crontab -u "${CRON_USER}" -l 2>/dev/null || true)"\nif ! echo "$current_cron" | grep -Fq "$MARK_BOOT"; then\n  { echo "$current_cron" | grep -Fv "$MARK_BOOT"; echo "* * * * * ${SCRIPT_PATH} $MARK_BOOT"; } | crontab -u "${CRON_USER}" -\nfi\n\nexit 0\n		template	25	2025-08-12 16:27:39.943+01	2025-08-12 16:27:39.943+01
15	summarize_logs	7f287a07cd8c65322d1ce7831bf571c920fc26daf6b2953e4b5aca15141638ef	==== DÉPLOIEMENT monitoring__cron ====\n📅 Début : 2025-08-12T15:35:17.365Z\n👤 User: latifnjimoluh@gmail.com\n🔧 VM: webytest\n\n==== LANCEMENT Terraform (runId=20) ====\nCWD: D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\nCMD: terraform init -input=false -upgrade=false && terraform apply -auto-approve -var-file=variables.tfvars.json\n\n[0m[1mInitializing the backend...[0m\n[0m[1mInitializing provider plugins...[0m\n- Finding latest version of hashicorp/local...\n- Finding latest version of hashicorp/null...\n- Finding telmate/proxmox versions matching "3.0.2-rc01"...\n- Installing hashicorp/local v2.5.3...\n- Installed hashicorp/local v2.5.3 (signed by HashiCorp)\n- Installing hashicorp/null v3.2.4...\n- Installed hashicorp/null v3.2.4 (signed by HashiCorp)\n- Installing telmate/proxmox v3.0.2-rc01...\n- Installed telmate/proxmox v3.0.2-rc01 (self-signed, key ID [0m[1mA9EBBE091B35AFCE[0m[0m)\nPartner and community providers are signed by their developers.\nIf you'd like to know more about provider signing, you can read about it here:\nhttps://developer.hashicorp.com/terraform/cli/plugins/signing\nTerraform has created a lock file [1m.terraform.lock.hcl[0m to record the provider\nselections it made above. Include this file in your version control repository\nso that Terraform can guarantee to make the same selections by default when\nyou run "terraform init" in the future.[0m\n\n[0m[1m[32mTerraform has been successfully initialized![0m[32m[0m\n[0m[32m\nYou may now begin working with Terraform. Try running "terraform plan" to see\nany changes that are required for your infrastructure. All Terraform commands\nshould now work.\n\nIf you ever set or change modules or backend configuration for Terraform,\nrerun this command to reinitialize your working directory. If you forget, other\ncommands will detect it and remind you to do so if necessary.[0m\n\nTerraform used the selected providers to generate the following execution\nplan. Resource actions are indicated with the following symbols:\n  [32m+[0m create[0m\n\nTerraform will perform the following actions:\n\n[1m  # null_resource.run_scripts["webytest"][0m will be created\n[0m  [32m+[0m[0m resource "null_resource" "run_scripts" {\n      [32m+[0m[0m id       = (known after apply)\n      [32m+[0m[0m triggers = {\n          [32m+[0m[0m "always_run" = (known after apply)\n        }\n    }\n\n[1m  # proxmox_vm_qemu.vm["webytest"][0m will be created\n[0m  [32m+[0m[0m resource "proxmox_vm_qemu" "vm" {\n      [32m+[0m[0m additional_wait        = 5\n      [32m+[0m[0m agent                  = 1\n      [32m+[0m[0m agent_timeout          = 90\n      [32m+[0m[0m automatic_reboot       = true\n      [32m+[0m[0m balloon                = 0\n      [32m+[0m[0m bios                   = "seabios"\n      [32m+[0m[0m boot                   = (known after apply)\n      [32m+[0m[0m bootdisk               = "scsi0"\n      [32m+[0m[0m cipassword             = (sensitive value)\n      [32m+[0m[0m ciupgrade              = false\n      [32m+[0m[0m ciuser                 = "nexus"\n      [32m+[0m[0m clone                  = "ubuntu-template"\n      [32m+[0m[0m clone_wait             = 10\n      [32m+[0m[0m current_node           = (known after apply)\n      [32m+[0m[0m default_ipv4_address   = (known after apply)\n      [32m+[0m[0m default_ipv6_address   = (known after apply)\n      [32m+[0m[0m define_connection_info = true\n      [32m+[0m[0m desc                   = "Managed by Terraform."\n      [32m+[0m[0m force_create           = false\n      [32m+[0m[0m full_clone             = true\n      [32m+[0m[0m hotplug                = "network,disk,usb"\n      [32m+[0m[0m id                     = (known after apply)\n      [32m+[0m[0m ipconfig0              = "ip=dhcp"\n      [32m+[0m[0m kvm                    = true\n      [32m+[0m[0m linked_vmid            = (known after apply)\n      [32m+[0m[0m memory                 = 2048\n      [32m+[0m[0m name                   = "webytest"\n      [32m+[0m[0m onboot                 = true\n      [32m+[0m[0m os_type                = "cloud-init"\n      [32m+[0m[0m protection             = false\n      [32m+[0m[0m reboot_required        = (known after apply)\n      [32m+[0m[0m scsihw                 = "virtio-scsi-single"\n      [32m+[0m[0m skip_ipv4              = false\n      [32m+[0m[0m skip_ipv6              = false\n      [32m+[0m[0m ssh_host               = (known after apply)\n      [32m+[0m[0m ssh_port               = (known after apply)\n      [32m+[0m[0m sshkeys                = <<-EOT\n            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpzZk553L5CBy6MxS0pfsMDBXDgwI/W7jDVt6LOTrmz8Mn9L0ekk9op6xrJZqxOnnDYMV/VdWnZs9mJ06lSgvvOzzsbvjklu9UwxNJFtOjjBSrpCz7nD5M3N0oAD301kYHdDoeLai7DB27VAZiGkItJYIi6wtfa7CKy21z+lM9qE7n91u4PY2fMNskFVg9vdtDjxmTjp6cbalA3i8iL/vZJ2bUSkmCIsCEtoij/LdzixbcJRKMfXsfNJh2zoxt6GSOx5/rRZbgu0OOgKmJlRAn77OMAAnEqOieDZ4nna2B72CNfTOnkY2cc0/iytr5cZkBWHbfq9xYBsETVuw/6A7rZGiFFMTvxtFYuQhQUKJ/cLaVFR+RJ7BvSUZyd6jG40mG51+LWoOwf6N+38yljFItb5QEowek3ra5ycAGbnimeu3PcDvEIWDNsrAqGzWtGYaQin/DrHZZtmAL2L+5qBIdFd/jo1xlIrFRRSiCEEcPU5zBMycTZnVsXtn6QNZUzemGRtWkSMZB9yu/YgAT2EL1xHo76ai0o3VmI7LxZvBRIzaf3ejQpXLfd15XR8thHFGha4lPQ9T75fWZW/NtKTQ0b0UYdfxHJqAZc+fy71rTqQ7E0CkIieXuRsA5JMOjmcXjQtnoBrP+0hNIHMpThKTsA1BQsxZ7UU6w7bI4vIfbYw== nexus-pc@Nexus-PC-Victus\n        EOT\n      [32m+[0m[0m tablet                 = true\n      [32m+[0m[0m tags                   = (known after apply)\n      [32m+[0m[0m target_node            = "pve"\n      [32m+[0m[0m unused_disk            = (known after apply)\n      [32m+[0m[0m vm_state               = "running"\n      [32m+[0m[0m vmid                   = (known after apply)\n\n      [32m+[0m[0m cpu {\n          [32m+[0m[0m cores   = 2\n          [32m+[0m[0m limit   = 0\n          [32m+[0m[0m numa    = false\n          [32m+[0m[0m sockets = 1\n          [32m+[0m[0m type    = "host"\n          [32m+[0m[0m units   = 0\n          [32m+[0m[0m vcores  = 0\n        }\n\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m iothread             = true\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = "18G"\n          [32m+[0m[0m slot                 = "scsi0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "disk"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "sata0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "cloudinit"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "ide2"\n          [32m+[0m[0m type                 = "cdrom"\n        }\n\n      [32m+[0m[0m network {\n          [32m+[0m[0m bridge    = "vmbr0"\n          [32m+[0m[0m firewall  = false\n          [32m+[0m[0m id        = 0\n          [32m+[0m[0m link_down = false\n          [32m+[0m[0m macaddr   = (known after apply)\n          [32m+[0m[0m model     = "virtio"\n        }\n\n      [32m+[0m[0m smbios (known after apply)\n\n      [32m+[0m[0m timeouts {\n          [32m+[0m[0m create = "10m"\n        }\n    }\n\n[1mPlan:[0m 2 to add, 0 to change, 0 to destroy.\n[0m\nChanges to Outputs:\n  [32m+[0m[0m ssh_commands = {\n      [32m+[0m[0m webytest = (known after apply)\n    }\n  [32m+[0m[0m status       = <<-EOT\n        ✅ 1 VM(s) déployée(s)\r\n        📄 Scripts injectés :\r\n        - webytest : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-3.sh\n    EOT\n  [32m+[0m[0m vm_ids       = {\n      [32m+[0m[0m webytest = (known after apply)\n    }\n  [32m+[0m[0m vm_ips       = {\n      [32m+[0m[0m webytest = (known after apply)\n    }\n  [32m+[0m[0m vm_names     = [\n      [32m+[0m[0m "webytest",\n    ]\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Creating...[0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["webytest"]: Creation complete after 2m33s [id=pve/qemu/101][0m\n[0m[1mnull_resource.run_scripts["webytest"]: Creating...[0m[0m\n[0m[1mnull_resource.run_scripts["webytest"]: Provisioning with 'local-exec'...[0m[0m\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0mExecuting: ["cmd" "/C" "scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\20\\\\webytest-script-1.sh nexus@:/tmp/script_1.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\20\\\\webytest-script-2.sh nexus@:/tmp/script_2.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\20\\\\webytest-script-3.sh nexus@:/tmp/script_3.sh"]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0mYou must specify a subsystem to invoke.\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0musage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface] [-b bind_address]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-c cipher_spec] [-D [bind_address:]port] [-E log_file]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-e escape_char] [-F configfile] [-I pkcs11] [-i identity_file]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-J destination] [-L address] [-l login_name] [-m mac_spec]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-O ctl_cmd] [-o option] [-P tag] [-p port] [-Q query_option]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-R address] [-S ctl_path] [-W host:port] [-w local_tun[:remote_tun]]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           destination [command [argument ...]]\n[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0mscp: Connection closed\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "proxmox_api_token_id"\n[33m│[0m [0mbut a value was found in file "variables.tfvars.json". If you meant to use\n[33m│[0m [0mthis value, add a "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "_meta" but a value was\n[33m│[0m [0mfound in file "variables.tfvars.json". If you meant to use this value, add\n[33m│[0m [0ma "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[31m╷[0m[0m\n[31m│[0m [0m[1m[31mError: [0m[0m[1mlocal-exec provisioner error[0m\n[31m│[0m [0m\n[31m│[0m [0m[0m  with null_resource.run_scripts["webytest"],\n[31m│[0m [0m  on main.tf line 111, in resource "null_resource" "run_scripts":\n[31m│[0m [0m 111:   provisioner "local-exec" [4m{[0m[0m\n[31m│[0m [0m\n[31m│[0m [0mError running command 'scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o\n[31m│[0m [0mStrictHostKeyChecking=no\n[31m│[0m [0mD:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-1.sh\n[31m│[0m [0mnexus@:/tmp/script_1.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o\n[31m│[0m [0mStrictHostKeyChecking=no\n[31m│[0m [0mD:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-2.sh\n[31m│[0m [0mnexus@:/tmp/script_2.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o\n[31m│[0m [0mStrictHostKeyChecking=no\n[31m│[0m [0mD:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-3.sh\n[31m│[0m [0mnexus@:/tmp/script_3.sh': exit status 255. Output: You must specify a\n[31m│[0m [0msubsystem to invoke.\n[31m│[0m [0musage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface] [-b bind_address]\n[31m│[0m [0m           [-c cipher_spec] [-D [bind_address:]port] [-E log_file]\n[31m│[0m [0m           [-e escape_char] [-F configfile] [-I pkcs11] [-i identity_file]\n[31m│[0m [0m           [-J destination] [-L address] [-l login_name] [-m mac_spec]\n[31m│[0m [0m           [-O ctl_cmd] [-o option] [-P tag] [-p port] [-Q query_option]\n[31m│[0m [0m           [-R address] [-S ctl_path] [-W host:port] [-w local_tun[:remote_tun]]\n[31m│[0m [0m           destination [command [argument ...]]\n[31m│[0m [0mscp: Connection closed\n[31m│[0m [0m\n[31m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValues for undeclared variables[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mIn addition to the other similar warnings shown, 3 other variable(s)\n[33m│[0m [0mdefined without being declared.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mQemu Guest Agent is enabled but not working[0m\n[33m│[0m [0m\n[33m│[0m [0m[0m  with proxmox_vm_qemu.vm["webytest"],\n[33m│[0m [0m  on main.tf line 35, in resource "proxmox_vm_qemu" "vm":\n[33m│[0m [0m  35: resource "proxmox_vm_qemu" "vm" [4m{[0m[0m\n[33m│[0m [0m\n[33m│[0m [0merror from PVE: "500 QEMU guest agent is not running"\n[33m│[0m [0m, Qemu Guest Agent is enabled in you configuration but non installed/not\n[33m│[0m [0mworking on your vm\n[33m╵[0m[0m\n\n❌ Échec: SSH_HOST_MISSING - Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez.\n	Absolument. Voici une analyse détaillée de ces logs de déploiement.\n\n### 1. Résumé des événements principaux\n\nCe log retrace une tentative de déploiement automatisé d'une machine virtuelle (VM) nommée `webytest` sur un hyperviseur Proxmox à l'aide de Terraform.\n\nVoici le déroulement chronologique des événements :\n\n1.  **Initialisation (Succès) :**\n    *   Le déploiement démarre le 12 août 2025 à 15:35 UTC.\n    *   Terraform s'initialise correctement, téléchargeant les fournisseurs nécessaires (`local`, `null`, `proxmox`).\n\n2.  **Planification (Succès) :**\n    *   Terraform planifie la création de 2 ressources :\n        *   Une machine virtuelle Proxmox (`proxmox_vm_qemu.vm["webytest"]`).\n        *   Une ressource `null_resource` destinée à exécuter des scripts après la création de la VM.\n\n3.  **Création de la VM (Succès) :**\n    *   La création de la VM `webytest` est lancée. Elle est clonée à partir d'un template nommé `ubuntu-template`.\n    *   Après 2 minutes et 33 secondes, **la VM est créée avec succès** sur le nœud Proxmox `pve` avec l'ID `101`.\n\n4.  **Exécution des scripts (Échec) :**\n    *   La deuxième ressource (`null_resource`) tente de copier 3 scripts (`.sh`) depuis la machine locale vers la nouvelle VM via la commande `scp`.\n    *   **Cette étape échoue.** La commande `scp` est mal formée car il manque l'adresse IP (ou le nom d'hôte) de la VM de destination (`nexus@:/tmp/...` au lieu de `nexus@<IP_DE_LA_VM>:/tmp/...`).\n\n5.  **Diagnostic de l'échec :**\n    *   **Cause directe :** L'adresse IP de la VM n'a pas pu être récupérée par Terraform.\n    *   **Cause racine :** Un avertissement critique dans les logs révèle le problème : `Warning: Qemu Guest Agent is enabled but not working`. Terraform était configuré pour utiliser le "Qemu Guest Agent" afin d'obtenir l'IP de la VM, mais cet agent n'était pas installé ou ne fonctionnait pas dans le template `ubuntu-template` utilisé pour le clonage.\n\n**Conclusion :** Le déploiement a réussi à créer l'infrastructure de base (la VM), mais a échoué à la configurer (copie des scripts), rendant le déploiement global infructueux.\n\n---\n\n### 2. Analyse de la configuration utilisée\n\nLa configuration est **bien intentionnée mais inadaptée** en l'état, car elle repose sur une hypothèse qui s'est avérée fausse.\n\n**Points positifs :**\n\n*   **Infrastructure as Code (IaC) :** L'utilisation de Terraform est une excellente pratique pour automatiser et versionner l'infrastructure.\n*   **Utilisation de templates :** Cloner une VM à partir d'un template (`ubuntu-template`) est bien plus efficace que de construire une VM à partir de zéro à chaque fois.\n*   **Cloud-Init :** L'utilisation de Cloud-Init est la méthode standard et robuste pour la configuration initiale des VM dans le cloud et les environnements virtualisés.\n*   **Intention correcte :** Tenter d'utiliser le Qemu Guest Agent (`agent = 1`) est la bonne façon de récupérer dynamiquement des informations sur la VM, comme son adresse IP DHCP.\n\n**Points faibles (causes de l'échec) :**\n\n*   **Dépendance non satisfaite :** Le principal problème est le décalage entre la configuration Terraform (qui attend le Guest Agent) et l'état du template de la VM (qui ne l'a pas).\n*   **Manque de robustesse :** Le processus de déploiement n'a pas de plan B. Si l'agent ne répond pas, tout s'arrête. Il n'y a pas de tentative de re-vérification ou de mécanisme de secours (comme l'attribution d'une IP statique en cas d'échec).\n*   **Qualité du code Terraform :** Les nombreux avertissements (`Warning: Value for undeclared variable`) indiquent que des variables sont passées au script Terraform sans y être formellement déclarées. C'est une mauvaise pratique qui rend le code plus difficile à maintenir et à comprendre.\n\n---\n\n### 3. Optimisations possibles\n\nVoici des propositions d'amélioration classées par catégorie.\n\n#### A. Correction immédiate (pour que ça marche)\n\n1.  **Fixer le template :** La solution la plus propre est de modifier le template `ubuntu-template`. Démarrez une VM à partir de ce template, installez et activez le Qemu Guest Agent, puis convertissez cette VM en un nouveau template.\n    ```bash\n    # Sur la VM Ubuntu/Debian\n    sudo apt-get update\n    sudo apt-get install qemu-guest-agent\n    sudo systemctl start qemu-guest-agent\n    sudo systemctl enable qemu-guest-agent\n    ```\n2.  **Nettoyer le code Terraform :** Déclarez toutes les variables utilisées dans un fichier `variables.tf` pour éliminer les avertissements et améliorer la lisibilité du code.\n\n#### B. Optimisations de performance\n\n1.  **Clonage lié (Linked Clone) :** Le log indique `full_clone = true`. Pour des déploiements beaucoup plus rapides, passez à `full_clone = false`. Cela crée un "clone lié" qui ne duplique pas le disque entier mais utilise le disque du template comme base. **Inconvénient :** cela crée une dépendance forte avec le template, qui ne doit plus être modifié ou supprimé.\n2.  **Ajustement des ressources :** Le nom du déploiement (`monitoring__cron`) suggère une charge de travail potentiellement légère. Il faudrait monitorer l'utilisation réelle des 2 Go de RAM et des 2 vCPU pour vérifier s'ils peuvent être réduits afin d'économiser des ressources.\n\n#### C. Optimisations de sécurité\n\n1.  **Gestion des secrets :** La clé SSH (`ssh-rsa AAAAB...`) est visible en clair dans les logs. C'est une faille de sécurité majeure. Elle devrait être gérée via un gestionnaire de secrets (comme HashiCorp Vault ou les secrets d'un CI/CD) et passée à Terraform de manière sécurisée, sans être affichée dans les logs.\n2.  **Activer le pare-feu :** Le paramètre `firewall = false` sur l'interface réseau est une mauvaise pratique. Il faudrait le passer à `true` et gérer les règles de sécurité soit au niveau de Proxmox, soit directement dans la VM avec `ufw` ou `iptables`.\n3.  **Utilisateur avec moins de privilèges :** Le provisionnement se fait avec l'utilisateur `nexus`. Il faut s'assurer que cet utilisateur dispose du minimum de privilèges nécessaires et n'est pas, par exemple, un super-utilisateur sur la VM.\n\n#### D. Optimisations de monitoring et de robustesse\n\n1.  **Provisioning amélioré :** Au lieu d'enchaîner des commandes `scp` dans un `local-exec`, il serait plus robuste et lisible d'utiliser un outil de gestion de configuration comme **Ansible**. Terraform peut être configuré pour appeler un playbook Ansible après la création de la VM. Ansible gère mieux les erreurs de connexion, les réessais et la complexité de la configuration.\n2.  **Monitoring de la VM :** Puisque le but est le "monitoring", il faudrait inclure dans le processus de provisioning l'installation d'un agent de monitoring (ex: Prometheus Node Exporter, Zabbix Agent) sur la VM `webytest` elle-même pour qu'elle puisse être supervisée.\n3.  **Gestion centralisée des logs :** Configurer la nouvelle VM pour qu'elle envoie ses propres logs système et applicatifs vers une solution centralisée (comme ELK Stack, Graylog ou Loki) afin de faciliter le dépannage futur.	deployment	32	2025-08-12 16:48:32.724+01	2025-08-12 16:48:32.724+01
16	analyze_dashboard	0ebf16773128b931c132e83a35ea74f68504e7d2fc229d51cc115638add13ea0	{"totals":{"deployed":35,"success":18,"failed":14,"deleted":37},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":18,"deleted":3,"success":4,"failed":11},{"period":"2025-08-13","deployed":4,"deleted":1,"success":1,"failed":3}]}	Absolument. Voici une analyse de ces statistiques, conçue pour un administrateur système, qui va au-delà des chiffres pour fournir des interprétations et des actions concrètes.\n\n---\n\n**À :** Administrateur Système\n**De :** Analyse Automatisée des Déploiements\n**Objet :** Analyse des statistiques de déploiement de VM du 6 au 13 août 2025\n\n### 1. Analyse et Tendances Marquantes\n\nL'analyse des données révèle une rupture nette et inquiétante dans la performance des déploiements de VM.\n\n**a) Un Taux d'Échec Alarmant et Soudain**\n\n- **Avant le 12 août :** Entre le 6 et le 9 août, le système était parfaitement fiable. Sur 13 déploiements tentés, **100% ont réussi**. C'est un indicateur de performance excellent.\n- **À partir du 12 août :** La situation s'est inversée de manière catastrophique.\n  - Le 12 août : Sur 15 déploiements effectifs (4 succès + 11 échecs), le **taux d'échec est de 73%**.\n  - Le 13 août : La tendance se confirme avec **75% d'échecs** (1 succès / 3 échecs).\n\n**Interprétation :** Il ne s'agit pas d'un incident isolé. Un changement fondamental est survenu entre le 9 et le 12 août qui a rendu le processus de déploiement extrêmement instable.\n\n**b) Le Pic d'Activité du 12 Août : un "Stress Test" Révélateur**\n\nLe 12 août a connu un pic d'activité avec 18 déploiements lancés. C'est le volume le plus élevé de la période, agissant comme un test de charge involontaire pour l'infrastructure.\n\n**Interprétation :** Le système n'a pas supporté cette montée en charge. La corrélation entre le volume élevé et le taux d'échec massif suggère un problème de capacité ou de concurrence :\n- **Épuisement des ressources :** L'hyperviseur, le stockage (I/O, espace) ou le réseau n'ont peut-être pas pu gérer autant de requêtes simultanées.\n- **Verrouillage (locking) :** Un script ou un processus de provisionnement a pu créer des conflits en tentant d'accéder aux mêmes ressources.\n\n**c) Balance Déploiements vs. Suppressions**\n\nSur la période, 35 VM ont été déployées pour 37 supprimées. Le parc de VM est donc stable, voire en légère diminution. Les pics de suppression (27 le 6 août) semblent correspondre à des opérations de nettoyage planifiées, tandis que les suppressions plus faibles les 12 et 13 août pourraient être liées au nettoyage des VM qui n'ont pas pu être déployées correctement.\n\n### 2. Conclusion sur l'État Global\n\nL'état global des déploiements est passé de **"excellent" à "critique"** en l'espace de quelques jours.\n\nLe système, qui était fiable et robuste, souffre maintenant d'une **dégradation sévère et systémique**. Le taux d'échec actuel est inacceptable et présente un risque majeur pour la continuité des services et la productivité. La cause première semble être une incapacité à gérer la charge ou un changement technique introduit juste avant le 12 août.\n\n### 3. Recommandations et Plan d'Action\n\nIl est impératif d'agir rapidement. Voici un plan d'action structuré.\n\n**Phase 1 : Investigation Immédiate (Urgent)**\n\n1.  **Corréler avec les changements :**\n    - **Action :** Identifier **tous les changements** mis en production entre le 9 et le 12 août. Prioriser les modifications sur :\n      - Les images/templates de VM.\n      - Les scripts d'automatisation (Ansible, Terraform, etc.).\n      - La configuration des hyperviseurs, du réseau ou du stockage.\n      - Les mises à jour de sécurité ou système.\n\n2.  **Analyser les logs du 12 août :**\n    - **Action :** Plonger dans les logs (vCenter, OpenStack, gestionnaire de cloud, etc.) au moment précis des 11 échecs du 12 août. Rechercher des messages d'erreur récurrents : timeouts, erreurs de stockage (`datastore full`, `I/O error`), erreurs réseau (`no IP available`), échecs d'authentification.\n\n3.  **Vérifier les ressources de l'infrastructure :**\n    - **Action :** Analyser les graphiques de performance (CPU, RAM, I/O disque, latence réseau) des hyperviseurs et des baies de stockage pour la journée du 12 août. Rechercher des pics de saturation qui coïncident avec les tentatives de déploiement.\n\n**Phase 2 : Actions Correctives (Court terme)**\n\n1.  **Moratoire sur les déploiements :**\n    - **Action :** Communiquer sur l'incident et envisager un **gel temporaire des déploiements non essentiels** jusqu'à ce que la cause soit identifiée et corrigée. Cela évitera de générer plus d'échecs et de gaspiller des ressources.\n\n2.  **Rollback Ciblé :**\n    - **Action :** Si un changement suspect est identifié (ex: nouvelle image de VM), effectuer un retour en arrière (rollback) vers la version précédente et tenter un déploiement test pour valider si le problème est résolu.\n\n**Phase 3 : Amélioration et Prévention (Moyen/Long terme)**\n\n1.  **Renforcer le Monitoring et les Alertes :**\n    - **Action :** Mettre en place une alerte qui se déclenche non pas sur un échec unique, mais sur un **taux d'échec anormal** (ex: > 15% sur une heure). Cela permettra de détecter ce genre de dégradation bien plus tôt.\n\n2.  **Instaurer des Tests de Charge :**\n    - **Action :** Intégrer des tests de charge dans votre environnement de pré-production. Simulez périodiquement le déploiement de 15-20 VM en parallèle pour vous assurer que l'infrastructure supporte les pics d'activité prévisibles.\n\n3.  **Auditer les Processus d'Automatisation :**\n    - **Action :** Revoir les scripts de déploiement pour s'assurer qu'ils gèrent correctement les erreurs et les conditions de concurrence (ex: nouvelle tentative avec backoff exponentiel, verrouillage pour éviter les conflits).	\N	\N	2025-08-13 12:45:05.084+01	2025-08-13 12:45:05.084+01
17	summarize_logs	1b0c0e30393387b6adfc465a8f92bc2f6e26124e382fde3b231ed7acf89912ca	==== DÉPLOIEMENT monitoring__cron ====\n📅 Début : 2025-08-13T11:55:35.687Z\n👤 User: latifnjimoluh@gmail.com\n🔧 VM: web-test\n\n==== LANCEMENT Terraform (runId=26) ====\nCWD: D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\26\nCMD: terraform init -input=false -upgrade=false && terraform apply -auto-approve -var-file=variables.tfvars.json\n\n[0m[1mInitializing the backend...[0m\n[0m[1mInitializing provider plugins...[0m\n- Finding telmate/proxmox versions matching "3.0.2-rc01"...\n- Finding latest version of hashicorp/local...\n- Finding latest version of hashicorp/null...\n- Installing telmate/proxmox v3.0.2-rc01...\n- Installed telmate/proxmox v3.0.2-rc01 (self-signed, key ID [0m[1mA9EBBE091B35AFCE[0m[0m)\n- Installing hashicorp/local v2.5.3...\n- Installed hashicorp/local v2.5.3 (signed by HashiCorp)\n- Installing hashicorp/null v3.2.4...\n- Installed hashicorp/null v3.2.4 (signed by HashiCorp)\nPartner and community providers are signed by their developers.\nIf you'd like to know more about provider signing, you can read about it here:\nhttps://developer.hashicorp.com/terraform/cli/plugins/signing\nTerraform has created a lock file [1m.terraform.lock.hcl[0m to record the provider\nselections it made above. Include this file in your version control repository\nso that Terraform can guarantee to make the same selections by default when\nyou run "terraform init" in the future.[0m\n\n[0m[1m[32mTerraform has been successfully initialized![0m[32m[0m\n[0m[32m\nYou may now begin working with Terraform. Try running "terraform plan" to see\nany changes that are required for your infrastructure. All Terraform commands\nshould now work.\n\nIf you ever set or change modules or backend configuration for Terraform,\nrerun this command to reinitialize your working directory. If you forget, other\ncommands will detect it and remind you to do so if necessary.[0m\n\nTerraform used the selected providers to generate the following execution\nplan. Resource actions are indicated with the following symbols:\n  [32m+[0m create[0m\n\nTerraform will perform the following actions:\n\n[1m  # null_resource.run_scripts["web-test"][0m will be created\n[0m  [32m+[0m[0m resource "null_resource" "run_scripts" {\n      [32m+[0m[0m id       = (known after apply)\n      [32m+[0m[0m triggers = {\n          [32m+[0m[0m "always_run" = (known after apply)\n        }\n    }\n\n[1m  # proxmox_vm_qemu.vm["web-test"][0m will be created\n[0m  [32m+[0m[0m resource "proxmox_vm_qemu" "vm" {\n      [32m+[0m[0m additional_wait        = 5\n      [32m+[0m[0m agent                  = 1\n      [32m+[0m[0m agent_timeout          = 90\n      [32m+[0m[0m automatic_reboot       = true\n      [32m+[0m[0m balloon                = 0\n      [32m+[0m[0m bios                   = "seabios"\n      [32m+[0m[0m boot                   = (known after apply)\n      [32m+[0m[0m bootdisk               = "scsi0"\n      [32m+[0m[0m cipassword             = (sensitive value)\n      [32m+[0m[0m ciupgrade              = false\n      [32m+[0m[0m ciuser                 = "nexus"\n      [32m+[0m[0m clone                  = "ubuntu-template"\n      [32m+[0m[0m clone_wait             = 10\n      [32m+[0m[0m current_node           = (known after apply)\n      [32m+[0m[0m default_ipv4_address   = (known after apply)\n      [32m+[0m[0m default_ipv6_address   = (known after apply)\n      [32m+[0m[0m define_connection_info = true\n      [32m+[0m[0m desc                   = "Managed by Terraform."\n      [32m+[0m[0m force_create           = false\n      [32m+[0m[0m full_clone             = true\n      [32m+[0m[0m hotplug                = "network,disk,usb"\n      [32m+[0m[0m id                     = (known after apply)\n      [32m+[0m[0m ipconfig0              = "ip=dhcp"\n      [32m+[0m[0m kvm                    = true\n      [32m+[0m[0m linked_vmid            = (known after apply)\n      [32m+[0m[0m memory                 = 2048\n      [32m+[0m[0m name                   = "web-test"\n      [32m+[0m[0m onboot                 = true\n      [32m+[0m[0m os_type                = "cloud-init"\n      [32m+[0m[0m protection             = false\n      [32m+[0m[0m reboot_required        = (known after apply)\n      [32m+[0m[0m scsihw                 = "virtio-scsi-single"\n      [32m+[0m[0m skip_ipv4              = false\n      [32m+[0m[0m skip_ipv6              = false\n      [32m+[0m[0m ssh_host               = (known after apply)\n      [32m+[0m[0m ssh_port               = (known after apply)\n      [32m+[0m[0m sshkeys                = <<-EOT\n            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpzZk553L5CBy6MxS0pfsMDBXDgwI/W7jDVt6LOTrmz8Mn9L0ekk9op6xrJZqxOnnDYMV/VdWnZs9mJ06lSgvvOzzsbvjklu9UwxNJFtOjjBSrpCz7nD5M3N0oAD301kYHdDoeLai7DB27VAZiGkItJYIi6wtfa7CKy21z+lM9qE7n91u4PY2fMNskFVg9vdtDjxmTjp6cbalA3i8iL/vZJ2bUSkmCIsCEtoij/LdzixbcJRKMfXsfNJh2zoxt6GSOx5/rRZbgu0OOgKmJlRAn77OMAAnEqOieDZ4nna2B72CNfTOnkY2cc0/iytr5cZkBWHbfq9xYBsETVuw/6A7rZGiFFMTvxtFYuQhQUKJ/cLaVFR+RJ7BvSUZyd6jG40mG51+LWoOwf6N+38yljFItb5QEowek3ra5ycAGbnimeu3PcDvEIWDNsrAqGzWtGYaQin/DrHZZtmAL2L+5qBIdFd/jo1xlIrFRRSiCEEcPU5zBMycTZnVsXtn6QNZUzemGRtWkSMZB9yu/YgAT2EL1xHo76ai0o3VmI7LxZvBRIzaf3ejQpXLfd15XR8thHFGha4lPQ9T75fWZW/NtKTQ0b0UYdfxHJqAZc+fy71rTqQ7E0CkIieXuRsA5JMOjmcXjQtnoBrP+0hNIHMpThKTsA1BQsxZ7UU6w7bI4vIfbYw== nexus-pc@Nexus-PC-Victus\n        EOT\n      [32m+[0m[0m tablet                 = true\n      [32m+[0m[0m tags                   = (known after apply)\n      [32m+[0m[0m target_node            = "pve"\n      [32m+[0m[0m unused_disk            = (known after apply)\n      [32m+[0m[0m vm_state               = "running"\n      [32m+[0m[0m vmid                   = (known after apply)\n\n      [32m+[0m[0m cpu {\n          [32m+[0m[0m cores   = 2\n          [32m+[0m[0m limit   = 0\n          [32m+[0m[0m numa    = false\n          [32m+[0m[0m sockets = 1\n          [32m+[0m[0m type    = "host"\n          [32m+[0m[0m units   = 0\n          [32m+[0m[0m vcores  = 0\n        }\n\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m iothread             = true\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = "20G"\n          [32m+[0m[0m slot                 = "scsi0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "disk"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "sata0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "cloudinit"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "ide2"\n          [32m+[0m[0m type                 = "cdrom"\n        }\n\n      [32m+[0m[0m network {\n          [32m+[0m[0m bridge    = "vmbr0"\n          [32m+[0m[0m firewall  = false\n          [32m+[0m[0m id        = 0\n          [32m+[0m[0m link_down = false\n          [32m+[0m[0m macaddr   = (known after apply)\n          [32m+[0m[0m model     = "virtio"\n        }\n\n      [32m+[0m[0m smbios (known after apply)\n\n      [32m+[0m[0m timeouts {\n          [32m+[0m[0m create = "10m"\n        }\n    }\n\n[1mPlan:[0m 2 to add, 0 to change, 0 to destroy.\n[0m\nChanges to Outputs:\n  [32m+[0m[0m ssh_commands = {\n      [32m+[0m[0m web-test = (known after apply)\n    }\n  [32m+[0m[0m status       = <<-EOT\n        ✅ 1 VM(s) déployée(s)\r\n        📄 Scripts injectés :\r\n        - web-test : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\26\\web-test-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\26\\web-test-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\26\\web-test-script-3.sh\n    EOT\n  [32m+[0m[0m vm_ids       = {\n      [32m+[0m[0m web-test = (known after apply)\n    }\n  [32m+[0m[0m vm_ips       = {\n      [32m+[0m[0m web-test = (known after apply)\n    }\n  [32m+[0m[0m vm_names     = [\n      [32m+[0m[0m "web-test",\n    ]\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Creating...[0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [00m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [00m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [00m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [00m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [00m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [01m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [01m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [01m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Still creating... [01m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["web-test"]: Creation complete after 1m39s [id=pve/qemu/101][0m\n[0m[1mnull_resource.run_scripts["web-test"]: Creating...[0m[0m\n[0m[1mnull_resource.run_scripts["web-test"]: Provisioning with 'local-exec'...[0m[0m\n[0m[1mnull_resource.run_scripts["web-test"] (local-exec):[0m [0mExecuting: ["cmd" "/C" "scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\26\\\\web-test-script-1.sh nexus@192.168.24.212:/tmp/script_1.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\26\\\\web-test-script-2.sh nexus@192.168.24.212:/tmp/script_2.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\26\\\\web-test-script-3.sh nexus@192.168.24.212:/tmp/script_3.sh"]\n[0m[1mnull_resource.run_scripts["web-test"] (local-exec):[0m [0mWarning: Permanently added '192.168.24.212' (ED25519) to the list of known hosts.\n[0m[1mnull_resource.run_scripts["web-test"]: Provisioning with 'remote-exec'...[0m[0m\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0mConnecting to remote host via SSH...\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  Host: 192.168.24.212\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  User: nexus\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  Password: false\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  Private key: true\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  Certificate: false\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  SSH Agent: false\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  Checking Host Key: false\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m  Target Platform: unix\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0mConnected!\n[0m[1mnull_resource.run_scripts["web-test"] (remote-exec):[0m [0m✅ Fin des scripts avec INSTANCE_ID=542e8abc-c806-4507-862e-2e171e45784a\n[0m[1mnull_resource.run_scripts["web-test"]: Creation complete after 6s [id=9159049977765398597][0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "proxmox_api_token_id"\n[33m│[0m [0mbut a value was found in file "variables.tfvars.json". If you meant to use\n[33m│[0m [0mthis value, add a "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "service_type" but a\n[33m│[0m [0mvalue was found in file "variables.tfvars.json". If you meant to use this\n[33m│[0m [0mvalue, add a "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValues for undeclared variables[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mIn addition to the other similar warnings shown, 3 other variable(s)\n[33m│[0m [0mdefined without being declared.\n[33m╵[0m[0m\n[0m[1m[32m\nApply complete! Resources: 2 added, 0 changed, 0 destroyed.\n[0m[0m[1m[32m\nOutputs:\n\n[0mssh_commands = {\n  "web-test" = "ssh -i C:/Users/Nexus-PC/.ssh/id_rsa nexus@192.168.24.212"\n}\nstatus = <<EOT\n✅ 1 VM(s) déployée(s)\r\n📄 Scripts injectés :\r\n- web-test : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\26\\web-test-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\26\\web-test-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\26\\web-test-script-3.sh\r\n\nEOT\nvm_ids = {\n  "web-test" = 101\n}\nvm_ips = {\n  "web-test" = "192.168.24.212"\n}\nvm_names = [\n  "web-test",\n]\n		deployment	38	2025-08-13 15:06:17.892+01	2025-08-13 15:06:17.892+01
18	summarize_logs	cd02558b8126d2e0172cfe851e99d741ced954febafe63c5ebf2f6f7d8ce0a49	==== DÉPLOIEMENT monitoring__cron ====\n📅 Début : 2025-08-13T16:06:57.780Z\n👤 User: latifnjimoluh@gmail.com\n🔧 VM: testwebserver\n\n==== LANCEMENT Terraform (runId=28) ====\nCWD: D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\28\nCMD: terraform init -input=false -upgrade=false && terraform apply -auto-approve -var-file=variables.tfvars.json\n\n[0m[1mInitializing the backend...[0m\n[0m[1mInitializing provider plugins...[0m\n- Finding latest version of hashicorp/local...\n- Finding latest version of hashicorp/null...\n- Finding telmate/proxmox versions matching "3.0.2-rc01"...\n- Installing hashicorp/local v2.5.3...\n- Installed hashicorp/local v2.5.3 (signed by HashiCorp)\n- Installing hashicorp/null v3.2.4...\n- Installed hashicorp/null v3.2.4 (signed by HashiCorp)\n- Installing telmate/proxmox v3.0.2-rc01...\n- Installed telmate/proxmox v3.0.2-rc01 (self-signed, key ID [0m[1mA9EBBE091B35AFCE[0m[0m)\nPartner and community providers are signed by their developers.\nIf you'd like to know more about provider signing, you can read about it here:\nhttps://developer.hashicorp.com/terraform/cli/plugins/signing\nTerraform has created a lock file [1m.terraform.lock.hcl[0m to record the provider\nselections it made above. Include this file in your version control repository\nso that Terraform can guarantee to make the same selections by default when\nyou run "terraform init" in the future.[0m\n\n[0m[1m[32mTerraform has been successfully initialized![0m[32m[0m\n[0m[32m\nYou may now begin working with Terraform. Try running "terraform plan" to see\nany changes that are required for your infrastructure. All Terraform commands\nshould now work.\n\nIf you ever set or change modules or backend configuration for Terraform,\nrerun this command to reinitialize your working directory. If you forget, other\ncommands will detect it and remind you to do so if necessary.[0m\n\nTerraform used the selected providers to generate the following execution\nplan. Resource actions are indicated with the following symbols:\n  [32m+[0m create[0m\n\nTerraform will perform the following actions:\n\n[1m  # null_resource.run_scripts["testwebserver"][0m will be created\n[0m  [32m+[0m[0m resource "null_resource" "run_scripts" {\n      [32m+[0m[0m id       = (known after apply)\n      [32m+[0m[0m triggers = {\n          [32m+[0m[0m "always_run" = (known after apply)\n        }\n    }\n\n[1m  # proxmox_vm_qemu.vm["testwebserver"][0m will be created\n[0m  [32m+[0m[0m resource "proxmox_vm_qemu" "vm" {\n      [32m+[0m[0m additional_wait        = 5\n      [32m+[0m[0m agent                  = 1\n      [32m+[0m[0m agent_timeout          = 90\n      [32m+[0m[0m automatic_reboot       = true\n      [32m+[0m[0m balloon                = 0\n      [32m+[0m[0m bios                   = "seabios"\n      [32m+[0m[0m boot                   = (known after apply)\n      [32m+[0m[0m bootdisk               = "scsi0"\n      [32m+[0m[0m cipassword             = (sensitive value)\n      [32m+[0m[0m ciupgrade              = false\n      [32m+[0m[0m ciuser                 = "nexus"\n      [32m+[0m[0m clone                  = "ubuntu-template"\n      [32m+[0m[0m clone_wait             = 10\n      [32m+[0m[0m current_node           = (known after apply)\n      [32m+[0m[0m default_ipv4_address   = (known after apply)\n      [32m+[0m[0m default_ipv6_address   = (known after apply)\n      [32m+[0m[0m define_connection_info = true\n      [32m+[0m[0m desc                   = "Managed by Terraform."\n      [32m+[0m[0m force_create           = false\n      [32m+[0m[0m full_clone             = true\n      [32m+[0m[0m hotplug                = "network,disk,usb"\n      [32m+[0m[0m id                     = (known after apply)\n      [32m+[0m[0m ipconfig0              = "ip=dhcp"\n      [32m+[0m[0m kvm                    = true\n      [32m+[0m[0m linked_vmid            = (known after apply)\n      [32m+[0m[0m memory                 = 2048\n      [32m+[0m[0m name                   = "testwebserver"\n      [32m+[0m[0m onboot                 = true\n      [32m+[0m[0m os_type                = "cloud-init"\n      [32m+[0m[0m protection             = false\n      [32m+[0m[0m reboot_required        = (known after apply)\n      [32m+[0m[0m scsihw                 = "virtio-scsi-single"\n      [32m+[0m[0m skip_ipv4              = false\n      [32m+[0m[0m skip_ipv6              = false\n      [32m+[0m[0m ssh_host               = (known after apply)\n      [32m+[0m[0m ssh_port               = (known after apply)\n      [32m+[0m[0m sshkeys                = <<-EOT\n            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpzZk553L5CBy6MxS0pfsMDBXDgwI/W7jDVt6LOTrmz8Mn9L0ekk9op6xrJZqxOnnDYMV/VdWnZs9mJ06lSgvvOzzsbvjklu9UwxNJFtOjjBSrpCz7nD5M3N0oAD301kYHdDoeLai7DB27VAZiGkItJYIi6wtfa7CKy21z+lM9qE7n91u4PY2fMNskFVg9vdtDjxmTjp6cbalA3i8iL/vZJ2bUSkmCIsCEtoij/LdzixbcJRKMfXsfNJh2zoxt6GSOx5/rRZbgu0OOgKmJlRAn77OMAAnEqOieDZ4nna2B72CNfTOnkY2cc0/iytr5cZkBWHbfq9xYBsETVuw/6A7rZGiFFMTvxtFYuQhQUKJ/cLaVFR+RJ7BvSUZyd6jG40mG51+LWoOwf6N+38yljFItb5QEowek3ra5ycAGbnimeu3PcDvEIWDNsrAqGzWtGYaQin/DrHZZtmAL2L+5qBIdFd/jo1xlIrFRRSiCEEcPU5zBMycTZnVsXtn6QNZUzemGRtWkSMZB9yu/YgAT2EL1xHo76ai0o3VmI7LxZvBRIzaf3ejQpXLfd15XR8thHFGha4lPQ9T75fWZW/NtKTQ0b0UYdfxHJqAZc+fy71rTqQ7E0CkIieXuRsA5JMOjmcXjQtnoBrP+0hNIHMpThKTsA1BQsxZ7UU6w7bI4vIfbYw== nexus-pc@Nexus-PC-Victus\n        EOT\n      [32m+[0m[0m tablet                 = true\n      [32m+[0m[0m tags                   = (known after apply)\n      [32m+[0m[0m target_node            = "pve"\n      [32m+[0m[0m unused_disk            = (known after apply)\n      [32m+[0m[0m vm_state               = "running"\n      [32m+[0m[0m vmid                   = (known after apply)\n\n      [32m+[0m[0m cpu {\n          [32m+[0m[0m cores   = 2\n          [32m+[0m[0m limit   = 0\n          [32m+[0m[0m numa    = false\n          [32m+[0m[0m sockets = 1\n          [32m+[0m[0m type    = "host"\n          [32m+[0m[0m units   = 0\n          [32m+[0m[0m vcores  = 0\n        }\n\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m iothread             = true\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = "20G"\n          [32m+[0m[0m slot                 = "scsi0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "disk"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "sata0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "cloudinit"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "ide2"\n          [32m+[0m[0m type                 = "cdrom"\n        }\n\n      [32m+[0m[0m network {\n          [32m+[0m[0m bridge    = "vmbr0"\n          [32m+[0m[0m firewall  = false\n          [32m+[0m[0m id        = 0\n          [32m+[0m[0m link_down = false\n          [32m+[0m[0m macaddr   = (known after apply)\n          [32m+[0m[0m model     = "virtio"\n        }\n\n      [32m+[0m[0m smbios (known after apply)\n\n      [32m+[0m[0m timeouts {\n          [32m+[0m[0m create = "10m"\n        }\n    }\n\n[1mPlan:[0m 2 to add, 0 to change, 0 to destroy.\n[0m\nChanges to Outputs:\n  [32m+[0m[0m ssh_commands = {\n      [32m+[0m[0m testwebserver = (known after apply)\n    }\n  [32m+[0m[0m status       = <<-EOT\n        ✅ 1 VM(s) déployée(s)\r\n        📄 Scripts injectés :\r\n        - testwebserver : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\28\\testwebserver-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\28\\testwebserver-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\28\\testwebserver-script-3.sh\n    EOT\n  [32m+[0m[0m vm_ids       = {\n      [32m+[0m[0m testwebserver = (known after apply)\n    }\n  [32m+[0m[0m vm_ips       = {\n      [32m+[0m[0m testwebserver = (known after apply)\n    }\n  [32m+[0m[0m vm_names     = [\n      [32m+[0m[0m "testwebserver",\n    ]\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Creating...[0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [00m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [00m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [00m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [00m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [00m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [01m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [01m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [01m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [01m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [01m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [01m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [02m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [02m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [02m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [02m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [02m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [02m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [03m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [03m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [03m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [03m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [03m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [03m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [04m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [04m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [04m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Still creating... [04m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testwebserver"]: Creation complete after 4m33s [id=pve/qemu/102][0m\n[0m[1mnull_resource.run_scripts["testwebserver"]: Creating...[0m[0m\n[0m[1mnull_resource.run_scripts["testwebserver"]: Provisioning with 'local-exec'...[0m[0m\n[0m[1mnull_resource.run_scripts["testwebserver"] (local-exec):[0m [0mExecuting: ["cmd" "/C" "scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\28\\\\testwebserver-script-1.sh nexus@192.168.24.214:/tmp/script_1.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\28\\\\testwebserver-script-2.sh nexus@192.168.24.214:/tmp/script_2.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\28\\\\testwebserver-script-3.sh nexus@192.168.24.214:/tmp/script_3.sh"]\n[0m[1mnull_resource.run_scripts["testwebserver"] (local-exec):[0m [0mWarning: Permanently added '192.168.24.214' (ED25519) to the list of known hosts.\n[0m[1mnull_resource.run_scripts["testwebserver"]: Provisioning with 'remote-exec'...[0m[0m\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0mConnecting to remote host via SSH...\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  Host: 192.168.24.214\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  User: nexus\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  Password: false\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  Private key: true\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  Certificate: false\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  SSH Agent: false\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  Checking Host Key: false\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m  Target Platform: unix\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0mConnected!\n[0m[1mnull_resource.run_scripts["testwebserver"] (remote-exec):[0m [0m✅ Fin des scripts avec INSTANCE_ID=a8e8f5d1-e3ac-4daf-ae4d-496c0260f6f7\n[0m[1mnull_resource.run_scripts["testwebserver"]: Creation complete after 7s [id=677059963509715598][0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "_meta" but a value was\n[33m│[0m [0mfound in file "variables.tfvars.json". If you meant to use this value, add\n[33m│[0m [0ma "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "proxmox_api_token_name"\n[33m│[0m [0mbut a value was found in file "variables.tfvars.json". If you meant to use\n[33m│[0m [0mthis value, add a "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValues for undeclared variables[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mIn addition to the other similar warnings shown, 3 other variable(s)\n[33m│[0m [0mdefined without being declared.\n[33m╵[0m[0m\n[0m[1m[32m\nApply complete! Resources: 2 added, 0 changed, 0 destroyed.\n[0m[0m[1m[32m\nOutputs:\n\n[0mssh_commands = {\n  "testwebserver" = "ssh -i C:/Users/Nexus-PC/.ssh/id_rsa nexus@192.168.24.214"\n}\nstatus = <<EOT\n✅ 1 VM(s) déployée(s)\r\n📄 Scripts injectés :\r\n- testwebserver : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\28\\testwebserver-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\28\\testwebserver-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\28\\testwebserver-script-3.sh\r\n\nEOT\nvm_ids = {\n  "testwebserver" = 102\n}\nvm_ips = {\n  "testwebserver" = "192.168.24.214"\n}\nvm_names = [\n  "testwebserver",\n]\n	Absolument. Voici une analyse détaillée de ces logs de déploiement.\n\n### 1. Résumé des événements principaux\n\nCe log décrit le déploiement automatisé d'une machine virtuelle (VM) via Terraform sur une infrastructure Proxmox. Voici les étapes clés :\n\n1.  **Initiation :** Le déploiement, nommé `monitoring__cron`, a été lancé le 13 août 2025 par l'utilisateur `latifnjimoluh@gmail.com`.\n2.  **Préparation de Terraform :** La commande `terraform init` a été exécutée avec succès. Elle a téléchargé et installé les *providers* nécessaires : `hashicorp/local`, `hashicorp/null` et `telmate/proxmox` (version `3.0.2-rc01`).\n3.  **Planification et Création :** La commande `terraform apply` a planifié la création de deux ressources :\n    *   Une machine virtuelle Proxmox (`proxmox_vm_qemu`) nommée `testwebserver`.\n    *   Une ressource `null_resource` destinée à exécuter des scripts de configuration sur cette VM.\n4.  **Création de la VM :** La VM `testwebserver` a été créée en clonant un template existant ("ubuntu-template"). La création a duré **4 minutes et 33 secondes**. La VM a reçu l'adresse IP `192.168.24.214` et l'ID `102` sur Proxmox.\n5.  **Configuration Post-Création :**\n    *   **Copie des scripts :** Trois scripts shell ont été copiés depuis la machine locale (`D:\\...`) vers le répertoire `/tmp/` de la nouvelle VM via `scp`.\n    *   **Exécution des scripts :** Terraform s'est connecté en SSH à la VM et a exécuté les scripts. Le message `✅ Fin des scripts...` indique que cette étape s'est terminée avec succès.\n6.  **Finalisation :** Le déploiement s'est terminé avec succès (`Apply complete!`). Les informations de sortie (outputs) ont été affichées, notamment la commande SSH pour se connecter à la VM, son ID, son IP et la liste des scripts injectés.\n\n**En résumé :** Un processus automatisé a créé une nouvelle machine virtuelle, y a copié des scripts de configuration, puis les a exécutés pour finaliser l'installation. Le déploiement est un **succès technique**.\n\n---\n\n### 2. Analyse de la configuration utilisée\n\nLa configuration est fonctionnelle, mais présente plusieurs points qui pourraient être améliorés pour la rendre plus robuste, portable et maintenable.\n\n**Points positifs :**\n\n*   **Infrastructure as Code (IaC) :** L'utilisation de Terraform est une excellente pratique pour gérer l'infrastructure de manière déclarative et reproductible.\n*   **Utilisation de templates :** Le clonage depuis un template (`ubuntu-template`) est efficace car il garantit une base système cohérente pour toutes les VMs.\n\n**Points à améliorer (Problèmes potentiels) :**\n\n1.  **Variables non déclarées :** Les logs affichent de nombreux avertissements (`Warning: Value for undeclared variable`). Cela signifie que des variables sont passées via le fichier `variables.tfvars.json` sans avoir été déclarées dans un fichier `.tf` avec un bloc `variable "..." {}`. C'est une mauvaise pratique qui rend le code difficile à comprendre et à valider.\n2.  **Utilisation de `null_resource` pour la configuration :** L'enchaînement de `local-exec` (pour `scp`) et `remote-exec` (pour exécuter les scripts) est une approche courante mais fragile. Si un script échoue, le débogage peut être complexe. Des outils de gestion de configuration comme **Ansible** ou l'utilisation plus poussée de **cloud-init** sont généralement mieux adaptés et plus puissants.\n3.  **Chemins d'accès en dur (Hardcoded paths) :** Les logs montrent des chemins Windows absolus (ex: `D:\\Keyce_B3\\...` et `C:/Users/Nexus-PC/.ssh/id_rsa`). Cela rend la configuration **totalement dépendante de la machine de l'utilisateur "Nexus-PC"** et non portable. Dans un environnement d'intégration continue (CI/CD), ce déploiement échouerait.\n4.  **Version "Release Candidate" du Provider :** L'utilisation de la version `3.0.2-rc01` du provider Proxmox est risquée. Les versions `rc` (Release Candidate) sont des versions de pré-lancement, potentiellement instables et non recommandées pour des déploiements critiques.\n\n**Conclusion :** La configuration semble être celle d'un projet personnel ou d'un prototype. Elle fonctionne dans son contexte actuel mais n'est pas adaptée à un environnement de production collaboratif ou automatisé en raison de son manque de portabilité et de ses mauvaises pratiques.\n\n---\n\n### 3. Propositions d'optimisations\n\nVoici des pistes pour améliorer cette infrastructure après le déploiement.\n\n#### Performance\n\n1.  **Clonage rapide (Linked Clone) :** La création de la VM a pris plus de 4 minutes, probablement car `full_clone = true` a été utilisé. Pour des déploiements beaucoup plus rapides, passez à un clone lié en définissant `full_clone = false` (si le stockage sous-jacent le permet et que la dépendance au template n'est pas un problème).\n2.  **Utiliser Cloud-Init pour la configuration initiale :** Au lieu de copier et exécuter des scripts via SSH, la majorité de la configuration initiale (création d'utilisateur, installation de paquets, etc.) peut être effectuée directement et plus rapidement via `cloud-init`, qui est nativement supporté par Proxmox et Terraform. Cela évite la phase de connexion SSH post-déploiement.\n3.  **Dimensionnement (Rightsizing) :** La VM a 2 Go de RAM et 2 vCPU. Il faudrait monitorer son utilisation réelle pour s'assurer que ces ressources ne sont ni insuffisantes (problèmes de performance) ni excessives (gaspillage de ressources).\n\n#### Sécurité\n\n1.  **Gestion des secrets :** La clé SSH privée est référencée par un chemin absolu. C'est un risque de sécurité majeur. Il faudrait utiliser un agent SSH (`ssh-agent`) ou, mieux, stocker les secrets (clés, mots de passe) dans un gestionnaire de secrets comme **HashiCorp Vault**. Les mots de passe ne doivent jamais être stockés en clair dans des fichiers `.tfvars`.\n2.  **Pare-feu (Firewall) :** Le log indique `firewall = false` pour l'interface réseau de la VM. Il est fortement recommandé d'activer le pare-feu de Proxmox (`firewall = true`) et de définir des règles de sécurité explicites pour n'autoriser que les flux réseau nécessaires.\n3.  **Principe du moindre privilège :** Assurez-vous que l'utilisateur `nexus` créé via `cloud-init` dispose uniquement des droits nécessaires pour ses tâches, et n'a pas de permissions `sudo` inutiles.\n4.  **Mise à jour du template :** Le template `ubuntu-template` doit être régulièrement mis à jour (via `apt update && apt upgrade`) pour que les nouvelles VMs ne soient pas déployées avec des vulnérabilités connues.\n\n#### Monitoring\n\n1.  **Agent de supervision :** Le nom du déploiement (`monitoring__cron`) suggère que la VM a un rôle de monitoring. Pour superviser la VM *elle-même*, il faudrait y installer un agent de collecte de métriques (ex: **Prometheus Node Exporter**, **Zabbix Agent**, **Datadog Agent**). L'installation de cet agent pourrait être l'un des scripts automatisés.\n2.  **Centralisation des logs :** Configurer un agent de logging (ex: **Fluentd**, **Filebeat**) sur la VM pour envoyer ses logs système et applicatifs vers une plateforme centralisée (ex: **ELK Stack**, **Graylog**, **Loki**). Cela simplifie grandement le diagnostic en cas de problème.\n3.  **Sondes de santé (Health Checks) :** Mettre en place des sondes qui vérifient non seulement que la VM est allumée, mais aussi que les services qui tournent dessus (ex: un serveur web, une base de données) répondent correctement.	deployment	40	2025-08-13 22:39:19.926+01	2025-08-13 22:39:19.926+01
19	analyze_dashboard	aafcc3bcff156f9eb2ccb74e72197c67f06872f0442c4c225a92e347afeed0d5	{"totals":{"deployed":38,"success":21,"failed":14,"deleted":40},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":18,"deleted":3,"success":4,"failed":11},{"period":"2025-08-13","deployed":7,"deleted":4,"success":4,"failed":3}]}	Absolument. Voici une analyse complète et des recommandations basées sur les statistiques fournies, à destination d'un administrateur système.\n\n---\n\n### **Analyse des Déploiements et Suppressions de VM**\n\nCette analyse couvre la période du 6 au 13 août 2025.\n\n#### **1. Tendances Marquantes et Points d'Attention**\n\nL'analyse de la chronologie révèle une rupture nette et alarmante dans la performance des déploiements.\n\n*   **Pic d'échecs critiques le 12 août :**\n    *   Le **12 août** est la journée la plus préoccupante. Sur 18 VM déployées, **seules 4 ont réussi (22% de succès)**, tandis que **11 ont échoué (61% d'échecs)**.\n    *   Cet incident isolé est responsable de **78% de tous les échecs** survenus durant la période (11 échecs sur 14 au total). L'activité de déploiement était très élevée ce jour-là, ce qui a amplifié l'impact du problème.\n\n*   **Dégradation brutale de la fiabilité :**\n    *   La semaine a commencé de manière exemplaire. Entre le 6 et le 9 août, **100% des déploiements étaient des succès** (13 déploiements réussis sur 13 tentatives). Le système était donc parfaitement stable.\n    *   La dégradation commence le 12 août et se poursuit le 13 août, où le taux d'échec reste élevé (3 échecs sur 7 déploiements, soit **43% d'échecs**). Cela indique que le problème n'était pas ponctuel mais persiste.\n\n*   **Activité de suppression (Churn) :**\n    *   Le nombre total de suppressions (40) est légèrement supérieur au nombre de déploiements (38). Cela suggère une activité de rationalisation ou un "churn" (cycle de vie court des VM) élevé.\n    *   Le pic de suppression a eu lieu le 6 août (27 VM supprimées), ce qui pourrait correspondre à une opération de nettoyage planifiée, surtout que les déploiements ce jour-là étaient 100% réussis.\n\n*   **Données Incomplètes :**\n    *   Sur un total de 38 VM déployées, on compte 21 succès et 14 échecs. La somme (35) ne correspond pas au total. **Il manque le statut de 3 VM.** Sont-elles toujours en cours de déploiement ? Le système de reporting a-t-il échoué à remonter leur statut ? C'est un point à clarifier.\n\n#### **2. Conclusion sur l'État Global**\n\nLa situation est **critique**. Le système de déploiement, auparavant fiable, est devenu instable à partir du 12 août. Le taux de succès global sur la période est de **seulement 55% (21/38)**, ce qui est inacceptable pour un environnement de production.\n\nLa cause principale n'est pas une dégradation lente, mais un **événement ou un changement spécifique** qui a eu lieu juste avant ou le 12 août et qui continue d'affecter le système.\n\n#### **3. Recommandations et Plan d'Action**\n\nIl est impératif d'agir rapidement pour restaurer la fiabilité des déploiements.\n\n**Actions Immédiates (Triage) :**\n\n1.  **Investigation de l'incident du 12 août (Priorité #1) :**\n    *   **Analyser les logs** des 11 déploiements échoués du 12 août et des 3 du 13 août. Rechercher des messages d'erreur communs (ex: timeout de provisionnement, erreur de configuration réseau, problème de stockage, échec de personnalisation du template).\n    *   **Identifier les changements :** Qu'est-ce qui a été modifié juste avant le 12 août ?\n        *   Nouvelle image de VM (template) ?\n        *   Mise à jour des scripts d'automatisation (Ansible, Terraform, etc.) ?\n        *   Changement dans la configuration de l'hyperviseur, du réseau ou du stockage ?\n        *   Mise à jour des quotas ou des permissions ?\n\n2.  **Clarifier le statut des 3 VM manquantes :**\n    *   Vérifier manuellement l'état de ces VM. Leur état (ex: bloqué en cours de provisionnement) pourrait être un symptôme direct de la cause racine.\n\n**Actions à Court Terme (Stabilisation) :**\n\n3.  **Moratoire sur les déploiements de masse :**\n    *   Envisager de **suspendre temporairement les déploiements en grand volume**. Autoriser uniquement les déploiements unitaires et critiques, en les surveillant manuellement, jusqu'à ce que la cause racine soit identifiée et corrigée.\n\n4.  **Rollback (Retour en arrière) :**\n    *   Si un changement précis (script, image) est identifié comme le coupable probable, effectuer un **rollback vers la version stable précédente** qui était utilisée jusqu'au 9 août.\n\n**Améliorations à Long Terme (Prévention) :**\n\n5.  **Renforcer le Monitoring et les Alertes :**\n    *   Mettre en place une alerte qui se déclenche automatiquement lorsque le **taux d'échec des déploiements dépasse un seuil critique** (ex: >10% sur une heure). Cela aurait permis de détecter le problème du 12 août beaucoup plus tôt.\n\n6.  **Instaurer des Déploiements Canaris :**\n    *   Pour les déploiements de masse, ne pas lancer les 18 VM en même temps. Déployer d'abord une seule VM "canari". Si son déploiement réussit et qu'elle passe les tests de santé, alors seulement lancer le reste du lot. Cela aurait limité l'incident du 12 août à 1 seul échec.\n\n7.  **Améliorer les Tests Pré-production :**\n    *   Tout changement (image, script) doit être validé via un pipeline de tests automatisés dans un environnement de staging qui réplique fidèlement la production avant d'être promu.	\N	\N	2025-08-14 01:57:38.451+01	2025-08-14 01:57:38.451+01
20	analyze_dashboard	02122cfb1b97ccbe6c433873e803f60f09605a025652a5b6128e6a206a3596ef	{"totals":{"deployed":40,"success":23,"failed":14,"deleted":40},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":18,"deleted":3,"success":4,"failed":11},{"period":"2025-08-13","deployed":7,"deleted":4,"success":4,"failed":3},{"period":"2025-08-14","deployed":2,"deleted":0,"success":2,"failed":0}]}	Absolument. Voici une analyse des statistiques de déploiement de VM, conçue pour un administrateur système, qui va au-delà des chiffres bruts pour fournir des interprétations et des actions concrètes.\n\n---\n\n### **Analyse des Déploiements de VM (6 au 14 août 2025)**\n\nBonjour,\n\nVoici une analyse de l'activité de déploiement et de suppression des machines virtuelles sur la période du 6 au 14 août. La situation révèle des points critiques qui nécessitent une attention immédiate.\n\n### 1. Tendances Marquantes et Points d'Alerte\n\n#### **a) Taux d'échec global alarmant**\nSur un total de 40 déploiements tentés, **14 ont échoué**, ce qui représente un **taux d'échec de 35%**. Un tel taux est anormalement élevé et indique un problème systémique ou de configuration majeur. La plateforme de déploiement n'est actuellement pas fiable.\n\n#### **b) Pic d'activité et effondrement du système le 12 août**\nLa journée du **12 août** est la plus critique et révèle la fragilité du système sous charge :\n*   **Activité massive :** 18 VM ont été déployées, soit 45% de l'activité totale de la semaine.\n*   **Échec massif :** Sur ces 18 déploiements, **11 ont échoué (soit 61% d'échec sur la journée)**.\n*   **Interprétation :** Le système de déploiement semble stable pour des opérations isolées (comme les 8, 9 et 14 août où le taux de succès est de 100%), mais il **ne supporte pas la charge** lors de déploiements en volume. Cela peut être dû à des goulots d'étranglement (I/O disque sur le datastore, API de l'hyperviseur, quotas réseau, etc.).\n\n#### **c) Incohérence dans le suivi des déploiements**\nLes totaux montrent 40 déploiements, mais la somme des succès (23) et des échecs (14) est de 37. **Il manque le statut final de 3 déploiements**. Ces VM "fantômes" peuvent être bloquées dans un état de "provisioning", consommer des ressources sans être fonctionnelles, ou simplement indiquer une lacune dans notre monitoring. Ce problème est visible le 12 août (18 déployées vs 4 succès + 11 échecs = 15).\n\n#### **d) Activité de suppression élevée en début de période**\nLe 6 août, **27 VM ont été supprimées** pour seulement 10 déploiements. Cela suggère une opération de "nettoyage" importante, peut-être en préparation des déploiements massifs qui ont suivi.\n\n### 2. Conclusion sur l'État Global\n\nL'état global des déploiements est **préoccupant et instable**. La plateforme est incapable de garantir un service fiable pour les déploiements de masse, qui constituent pourtant un besoin opérationnel clé. Le taux d'échec de 35% est inacceptable et génère une perte de temps significative en diagnostic et en tentatives répétées. L'incapacité à suivre l'état de chaque déploiement complique la gestion et peut entraîner des coûts cachés.\n\n### 3. Recommandations et Plan d'Action\n\nIl est impératif d'agir pour stabiliser la plateforme. Voici un plan d'action priorisé :\n\n**Action Immédiate (Urgent)**\n\n1.  **Investigation de l'incident du 12 août :**\n    *   **Analyser les logs** de l'orchestrateur (ex: vCenter, OpenStack, Azure ARM) et des hyperviseurs pour la période du 12 août. Rechercher des erreurs spécifiques : `timeout`, `resource unavailable`, `quota exceeded`, `invalid template`.\n    *   **Corréler les échecs :** Est-ce que les 11 échecs utilisaient le même template de VM, le même réseau, ou visaient le même datastore/cluster ? L'identification d'un point commun est la clé.\n    *   **Vérifier les métriques de performance** des infrastructures sous-jacentes (CPU, RAM, I/O disques, latence réseau) pendant le pic d'activité.\n\n2.  **Identifier et traiter les 3 déploiements au statut inconnu :**\n    *   Lancer des requêtes via l'API ou l'interface de gestion pour retrouver ces VM. Sont-elles en cours d'exécution ? Bloquées ? Il faut clarifier leur état et les supprimer si nécessaire pour libérer les ressources.\n\n**Actions à Moyen Terme (Prochaines semaines)**\n\n3.  **Mettre en place un moratoire sur les déploiements de masse :**\n    *   Suspendre tout déploiement de plus de 5 VM simultanément jusqu'à ce que la cause racine soit identifiée et corrigée.\n    *   Pour les besoins urgents, **procéder par lots plus petits** (ex: 3x6 VM au lieu de 1x18 VM), avec une pause de vérification entre chaque lot.\n\n4.  **Améliorer le logging et le monitoring des déploiements :**\n    *   Le script ou l'outil de déploiement doit être modifié pour garantir qu'un statut final (**succès** ou **échec**) soit systématiquement enregistré. Un état "timeout" ou "inconnu" doit déclencher une alerte.\n    *   Enrichir les logs d'échec avec des informations de contexte (template utilisé, utilisateur, paramètres, etc.) pour accélérer les futurs diagnostics.\n\n5.  **Revoir et tester les templates de VM :**\n    *   Valider que les templates utilisés le 12 août sont toujours fonctionnels via un déploiement unitaire. Un template corrompu ou une post-configuration (via cloud-init par exemple) qui échoue sous charge est une hypothèse plausible.\n\nEn résumé, nous avons fait face à une défaillance critique de notre processus de déploiement sous charge. L'enquête sur l'incident du 12 août est la priorité absolue pour restaurer la confiance dans notre infrastructure.	\N	\N	2025-08-14 03:02:29.528+01	2025-08-14 03:02:29.528+01
21	summarize_logs	545db72188f4e1f2d458e67bd0b1f37581198ad3b6b0ec0e900cecd49bc526bd	==== DÉPLOIEMENT Web_Ngnix ====\n📅 Début : 2025-08-14T01:12:28.995Z\n👤 User: latifnjimoluh@gmail.com\n🔧 VM: testweb-ngnix\n\n==== LANCEMENT Terraform (runId=30) ====\nCWD: D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\nCMD: terraform init -input=false -upgrade=false && terraform apply -auto-approve -var-file=variables.tfvars.json\n\n[0m[1mInitializing the backend...[0m\n[0m[1mInitializing provider plugins...[0m\n- Finding latest version of hashicorp/null...\n- Finding telmate/proxmox versions matching "3.0.2-rc01"...\n- Finding latest version of hashicorp/local...\n- Installing hashicorp/null v3.2.4...\n- Installed hashicorp/null v3.2.4 (signed by HashiCorp)\n- Installing telmate/proxmox v3.0.2-rc01...\n- Installed telmate/proxmox v3.0.2-rc01 (self-signed, key ID [0m[1mA9EBBE091B35AFCE[0m[0m)\n- Installing hashicorp/local v2.5.3...\n- Installed hashicorp/local v2.5.3 (signed by HashiCorp)\nPartner and community providers are signed by their developers.\nIf you'd like to know more about provider signing, you can read about it here:\nhttps://developer.hashicorp.com/terraform/cli/plugins/signing\nTerraform has created a lock file [1m.terraform.lock.hcl[0m to record the provider\nselections it made above. Include this file in your version control repository\nso that Terraform can guarantee to make the same selections by default when\nyou run "terraform init" in the future.[0m\n\n[0m[1m[32mTerraform has been successfully initialized![0m[32m[0m\n[0m[32m\nYou may now begin working with Terraform. Try running "terraform plan" to see\nany changes that are required for your infrastructure. All Terraform commands\nshould now work.\n\nIf you ever set or change modules or backend configuration for Terraform,\nrerun this command to reinitialize your working directory. If you forget, other\ncommands will detect it and remind you to do so if necessary.[0m\n\nTerraform used the selected providers to generate the following execution\nplan. Resource actions are indicated with the following symbols:\n  [32m+[0m create[0m\n\nTerraform will perform the following actions:\n\n[1m  # null_resource.run_scripts["testweb-ngnix"][0m will be created\n[0m  [32m+[0m[0m resource "null_resource" "run_scripts" {\n      [32m+[0m[0m id       = (known after apply)\n      [32m+[0m[0m triggers = {\n          [32m+[0m[0m "always_run" = (known after apply)\n        }\n    }\n\n[1m  # proxmox_vm_qemu.vm["testweb-ngnix"][0m will be created\n[0m  [32m+[0m[0m resource "proxmox_vm_qemu" "vm" {\n      [32m+[0m[0m additional_wait        = 5\n      [32m+[0m[0m agent                  = 1\n      [32m+[0m[0m agent_timeout          = 90\n      [32m+[0m[0m automatic_reboot       = true\n      [32m+[0m[0m balloon                = 0\n      [32m+[0m[0m bios                   = "seabios"\n      [32m+[0m[0m boot                   = (known after apply)\n      [32m+[0m[0m bootdisk               = "scsi0"\n      [32m+[0m[0m cipassword             = (sensitive value)\n      [32m+[0m[0m ciupgrade              = false\n      [32m+[0m[0m ciuser                 = "nexus"\n      [32m+[0m[0m clone                  = "ubuntu-template"\n      [32m+[0m[0m clone_wait             = 10\n      [32m+[0m[0m current_node           = (known after apply)\n      [32m+[0m[0m default_ipv4_address   = (known after apply)\n      [32m+[0m[0m default_ipv6_address   = (known after apply)\n      [32m+[0m[0m define_connection_info = true\n      [32m+[0m[0m desc                   = "Managed by Terraform."\n      [32m+[0m[0m force_create           = false\n      [32m+[0m[0m full_clone             = true\n      [32m+[0m[0m hotplug                = "network,disk,usb"\n      [32m+[0m[0m id                     = (known after apply)\n      [32m+[0m[0m ipconfig0              = "ip=dhcp"\n      [32m+[0m[0m kvm                    = true\n      [32m+[0m[0m linked_vmid            = (known after apply)\n      [32m+[0m[0m memory                 = 2048\n      [32m+[0m[0m name                   = "testweb-ngnix"\n      [32m+[0m[0m onboot                 = true\n      [32m+[0m[0m os_type                = "cloud-init"\n      [32m+[0m[0m protection             = false\n      [32m+[0m[0m reboot_required        = (known after apply)\n      [32m+[0m[0m scsihw                 = "virtio-scsi-single"\n      [32m+[0m[0m skip_ipv4              = false\n      [32m+[0m[0m skip_ipv6              = false\n      [32m+[0m[0m ssh_host               = (known after apply)\n      [32m+[0m[0m ssh_port               = (known after apply)\n      [32m+[0m[0m sshkeys                = <<-EOT\n            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpzZk553L5CBy6MxS0pfsMDBXDgwI/W7jDVt6LOTrmz8Mn9L0ekk9op6xrJZqxOnnDYMV/VdWnZs9mJ06lSgvvOzzsbvjklu9UwxNJFtOjjBSrpCz7nD5M3N0oAD301kYHdDoeLai7DB27VAZiGkItJYIi6wtfa7CKy21z+lM9qE7n91u4PY2fMNskFVg9vdtDjxmTjp6cbalA3i8iL/vZJ2bUSkmCIsCEtoij/LdzixbcJRKMfXsfNJh2zoxt6GSOx5/rRZbgu0OOgKmJlRAn77OMAAnEqOieDZ4nna2B72CNfTOnkY2cc0/iytr5cZkBWHbfq9xYBsETVuw/6A7rZGiFFMTvxtFYuQhQUKJ/cLaVFR+RJ7BvSUZyd6jG40mG51+LWoOwf6N+38yljFItb5QEowek3ra5ycAGbnimeu3PcDvEIWDNsrAqGzWtGYaQin/DrHZZtmAL2L+5qBIdFd/jo1xlIrFRRSiCEEcPU5zBMycTZnVsXtn6QNZUzemGRtWkSMZB9yu/YgAT2EL1xHo76ai0o3VmI7LxZvBRIzaf3ejQpXLfd15XR8thHFGha4lPQ9T75fWZW/NtKTQ0b0UYdfxHJqAZc+fy71rTqQ7E0CkIieXuRsA5JMOjmcXjQtnoBrP+0hNIHMpThKTsA1BQsxZ7UU6w7bI4vIfbYw== nexus-pc@Nexus-PC-Victus\n        EOT\n      [32m+[0m[0m tablet                 = true\n      [32m+[0m[0m tags                   = (known after apply)\n      [32m+[0m[0m target_node            = "pve"\n      [32m+[0m[0m unused_disk            = (known after apply)\n      [32m+[0m[0m vm_state               = "running"\n      [32m+[0m[0m vmid                   = (known after apply)\n\n      [32m+[0m[0m cpu {\n          [32m+[0m[0m cores   = 2\n          [32m+[0m[0m limit   = 0\n          [32m+[0m[0m numa    = false\n          [32m+[0m[0m sockets = 1\n          [32m+[0m[0m type    = "host"\n          [32m+[0m[0m units   = 0\n          [32m+[0m[0m vcores  = 0\n        }\n\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m iothread             = true\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = "20G"\n          [32m+[0m[0m slot                 = "scsi0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "disk"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "sata0"\n          [32m+[0m[0m storage              = "local-lvm"\n          [32m+[0m[0m type                 = "cloudinit"\n        }\n      [32m+[0m[0m disk {\n          [32m+[0m[0m backup               = true\n          [32m+[0m[0m id                   = (known after apply)\n          [32m+[0m[0m iops_r_burst         = 0\n          [32m+[0m[0m iops_r_burst_length  = 0\n          [32m+[0m[0m iops_r_concurrent    = 0\n          [32m+[0m[0m iops_wr_burst        = 0\n          [32m+[0m[0m iops_wr_burst_length = 0\n          [32m+[0m[0m iops_wr_concurrent   = 0\n          [32m+[0m[0m linked_disk_id       = (known after apply)\n          [32m+[0m[0m mbps_r_burst         = 0\n          [32m+[0m[0m mbps_r_concurrent    = 0\n          [32m+[0m[0m mbps_wr_burst        = 0\n          [32m+[0m[0m mbps_wr_concurrent   = 0\n          [32m+[0m[0m passthrough          = false\n          [32m+[0m[0m size                 = (known after apply)\n          [32m+[0m[0m slot                 = "ide2"\n          [32m+[0m[0m type                 = "cdrom"\n        }\n\n      [32m+[0m[0m network {\n          [32m+[0m[0m bridge    = "vmbr0"\n          [32m+[0m[0m firewall  = false\n          [32m+[0m[0m id        = 0\n          [32m+[0m[0m link_down = false\n          [32m+[0m[0m macaddr   = (known after apply)\n          [32m+[0m[0m model     = "virtio"\n        }\n\n      [32m+[0m[0m smbios (known after apply)\n\n      [32m+[0m[0m timeouts {\n          [32m+[0m[0m create = "10m"\n        }\n    }\n\n[1mPlan:[0m 2 to add, 0 to change, 0 to destroy.\n[0m\nChanges to Outputs:\n  [32m+[0m[0m ssh_commands = {\n      [32m+[0m[0m testweb-ngnix = (known after apply)\n    }\n  [32m+[0m[0m status       = <<-EOT\n        ✅ 1 VM(s) déployée(s)\r\n        📄 Scripts injectés :\r\n        - testweb-ngnix : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-3.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-4.sh\n    EOT\n  [32m+[0m[0m vm_ids       = {\n      [32m+[0m[0m testweb-ngnix = (known after apply)\n    }\n  [32m+[0m[0m vm_ips       = {\n      [32m+[0m[0m testweb-ngnix = (known after apply)\n    }\n  [32m+[0m[0m vm_names     = [\n      [32m+[0m[0m "testweb-ngnix",\n    ]\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Creating...[0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [00m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [00m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [00m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [00m40s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [00m50s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [01m00s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [01m10s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [01m20s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Still creating... [01m30s elapsed][0m[0m\n[0m[1mproxmox_vm_qemu.vm["testweb-ngnix"]: Creation complete after 1m40s [id=pve/qemu/103][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Creating...[0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Provisioning with 'local-exec'...[0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (local-exec):[0m [0mExecuting: ["cmd" "/C" "scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\30\\\\testweb-ngnix-script-1.sh nexus@192.168.24.215:/tmp/script_1.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\30\\\\testweb-ngnix-script-2.sh nexus@192.168.24.215:/tmp/script_2.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\30\\\\testweb-ngnix-script-3.sh nexus@192.168.24.215:/tmp/script_3.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\30\\\\testweb-ngnix-script-4.sh nexus@192.168.24.215:/tmp/script_4.sh"]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (local-exec):[0m [0mWarning: Permanently added '192.168.24.215' (ED25519) to the list of known hosts.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Provisioning with 'remote-exec'...[0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mConnecting to remote host via SSH...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  Host: 192.168.24.215\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  User: nexus\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  Password: false\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  Private key: true\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  Certificate: false\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  SSH Agent: false\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  Checking Host Key: false\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  Target Platform: unix\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mConnected!\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m🌐 Déploiement du serveur Web Camer-Web (web.camer.cm)...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m📦 Installation de nginx et apache2 (optionnel)...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Connecting to cm.archive.ubuntu.com[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Connecting to cm.archive.ubuntu.com[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mHit:1 http://cm.archive.ubuntu.com/ubuntu jammy InRelease\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:2 http://security.ubuntu.com/ubuntu jammy-security InRelease [129 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers] [2 InRelease 5[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers] [2 InRelease 1[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:3 http://cm.archive.ubuntu.com/ubuntu jammy-updates InRelease [128 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [3 InRelease 12.9 kB/128 kB 10%] [2 [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [3 InRelease 54.9 kB/128 kB 43%] [2 [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers] [2 InRelease 8[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers] [2 InRelease 1[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:4 http://cm.archive.ubuntu.com/ubuntu jammy-backports InRelease [127 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [4 InRelease 2,092 B/127 kB 2%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [4 InRelease 127 kB/127 kB 100%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m18% [Waiting for headers] [Waiting for [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:5 http://security.ubuntu.com/ubuntu jammy-security/main amd64 Packages [2,558 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m18% [Waiting for headers] [5 Packages 3[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:6 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 Packages [2,803 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m18% [6 Packages 9,359 B/2,803 kB 0%] [5[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m21% [6 Packages 384 kB/2,803 kB 14%] [5[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m27% [6 Packages 1,156 kB/2,803 kB 41%] [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m32% [6 Packages 1,861 kB/2,803 kB 66%] [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Still creating... [00m10s elapsed][0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m38% [6 Packages 2,380 kB/2,803 kB 85%] [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m40% [Waiting for headers] [5 Packages 2[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:7 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main Translation-en [443 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m41% [7 Translation-en 106 kB/443 kB 24%[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m41% [6 Packages store 0 B] [7 Translati[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m41% [6 Packages store 0 B] [7 Translati[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m42% [7 Translation-en 214 kB/443 kB 48%[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m42% [5 Packages store 0 B] [7 Translati[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:8 http://cm.archive.ubuntu.com/ubuntu jammy-updates/restricted amd64 Packages [4,163 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m43% [5 Packages store 0 B] [8 Packages [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m46% [8 Packages 819 kB/4,163 kB 20%] [W[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m46% [7 Translation-en store 0 B] [8 Pac[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:9 http://security.ubuntu.com/ubuntu jammy-security/main Translation-en [379 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m46% [7 Translation-en store 0 B] [8 Pac[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m47% [8 Packages 859 kB/4,163 kB 21%] [9[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m48% [8 Packages 1,092 kB/4,163 kB 26%] [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m54% [8 Packages 2,399 kB/4,163 kB 58%] [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m58% [8 Packages 3,378 kB/4,163 kB 81%] [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [8 Packages 4,155 kB/4,163 kB 100%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [8 Packages 4,155 kB/4,163 kB 100%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [9 Translation-en store 0 B] [8 Pac[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [8 Packages 4,155 kB/4,163 kB 100%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:10 http://cm.archive.ubuntu.com/ubuntu jammy-updates/restricted Translation-en [756 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [10 Translation-en 773 B/756 kB 0%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [8 Packages store 0 B] [10 Translat[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:11 http://security.ubuntu.com/ubuntu jammy-security/restricted amd64 Packages [4,018 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [8 Packages store 0 B] [10 Translat[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:12 http://cm.archive.ubuntu.com/ubuntu jammy-updates/universe amd64 Packages [1,226 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m66% [8 Packages store 0 B] [12 Packages[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m73% [8 Packages store 0 B] [12 Packages[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m74% [12 Packages 1,202 kB/1,226 kB 98%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m74% [10 Translation-en store 0 B] [12 P[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:13 http://cm.archive.ubuntu.com/ubuntu jammy-updates/universe Translation-en [304 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m75% [10 Translation-en store 0 B] [13 T[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m77% [10 Translation-en store 0 B] [11 P[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:14 http://cm.archive.ubuntu.com/ubuntu jammy-updates/multiverse amd64 Packages [59.5 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m77% [10 Translation-en store 0 B] [14 P[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m77% [10 Translation-en store 0 B] [11 P[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:15 http://cm.archive.ubuntu.com/ubuntu jammy-updates/multiverse Translation-en [14.2 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m77% [10 Translation-en store 0 B] [15 T[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m77% [10 Translation-en store 0 B] [11 P[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:16 http://cm.archive.ubuntu.com/ubuntu jammy-backports/main amd64 Packages [68.8 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m77% [10 Translation-en store 0 B] [16 P[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:17 http://cm.archive.ubuntu.com/ubuntu jammy-backports/universe amd64 Packages [31.3 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:18 http://cm.archive.ubuntu.com/ubuntu jammy-backports/universe Translation-en [16.6 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m79% [10 Translation-en store 0 B] [11 P[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m79% [11 Packages 1,539 kB/4,018 kB 38%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m79% [12 Packages store 0 B] [11 Package[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m86% [11 Packages 2,979 kB/4,018 kB 74%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m86% [13 Translation-en store 0 B] [11 P[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m87% [11 Packages 3,222 kB/4,018 kB 80%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m87% [14 Packages store 0 B] [11 Package[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m88% [11 Packages 3,402 kB/4,018 kB 85%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m88% [15 Translation-en store 0 B] [11 P[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m88% [11 Packages 3,409 kB/4,018 kB 85%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m88% [16 Packages store 0 B] [11 Package[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m89% [11 Packages 3,566 kB/4,018 kB 89%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m89% [17 Packages store 0 B] [11 Package[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m89% [11 Packages 3,599 kB/4,018 kB 90%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m89% [18 Translation-en store 0 B] [11 P[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m89% [11 Packages 3,599 kB/4,018 kB 90%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m91% [Working]               960 kB/s 2s[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m91% [11 Packages store 0 B] [Waiting fo[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:19 http://security.ubuntu.com/ubuntu jammy-security/restricted Translation-en [732 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m91% [11 Packages store 0 B] [19 Transla[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m94% [11 Packages store 0 B][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:20 http://security.ubuntu.com/ubuntu jammy-security/universe amd64 Packages [993 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m94% [11 Packages store 0 B] [20 Package[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m95% [20 Packages 108 kB/993 kB 11%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m95% [19 Translation-en store 0 B] [20 P[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m98% [19 Translation-en store 0 B][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m99% [Waiting for headers]   960 kB/s 0s[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m99% [20 Packages store 0 B] [Waiting fo[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:21 http://security.ubuntu.com/ubuntu jammy-security/universe Translation-en [217 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m99% [20 Packages store 0 B] [21 Transla[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m99% [21 Translation-en 9,361 B/217 kB 4[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m100% [Working]            2,132 kB/s 0s[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m100% [21 Translation-en store 0 B][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m100% [Working]            2,132 kB/s 0s[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mFetched 19.2 MB in 12s (1,541 kB/s)\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Still creating... [00m20s elapsed][0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 2%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 2%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 3%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 3%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 4%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 4%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 4%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 4%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 24%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 29%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 29%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 40%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 40%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 41%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 41%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 41%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 41%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 47%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 47%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 51%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 51%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 56%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 61%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 61%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 67%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 67%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 70%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 70%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 71%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 77%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 77%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 81%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 81%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 90%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 90%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 96%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 96%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 98%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 98%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 99%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 99%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 99%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 99%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 99%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 99%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 50%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 50%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m21 packages can be upgraded. Run 'apt list --upgradable' to see them.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 100%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 50%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 50%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mcurl is already the newest version (7.81.0-1ubuntu1.20).\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mcurl set to manually installed.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0 upgraded, 0 newly installed, 0 to remove and 21 not upgraded.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... 100%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading package lists... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 50%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... 50%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mBuilding dependency tree... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... 0%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mReading state information... Done\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mThe following additional packages will be installed:\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  apache2-bin apache2-data\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  apache2-utils bzip2\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  fontconfig-config fonts-dejavu-core\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libapr1 libaprutil1\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libaprutil1-dbd-sqlite3\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libaprutil1-ldap libdeflate0\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libfontconfig1 libgd3 libjbig0\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libjpeg-turbo8 libjpeg8 liblua5.3-0\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-http-geoip2\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-http-image-filter\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-http-xslt-filter\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-mail\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-stream\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-stream-geoip2 libtiff5\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libwebp7 libxpm4 mailcap\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  mime-support nginx-common nginx-core\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  ssl-cert\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mSuggested packages:\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  apache2-doc apache2-suexec-pristine\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  | apache2-suexec-custom www-browser\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  bzip2-doc libgd-tools fcgiwrap\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  nginx-doc\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mThe following NEW packages will be installed:\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  apache2 apache2-bin apache2-data\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  apache2-utils bzip2\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  fontconfig-config fonts-dejavu-core\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libapr1 libaprutil1\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libaprutil1-dbd-sqlite3\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libaprutil1-ldap libdeflate0\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libfontconfig1 libgd3 libjbig0\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libjpeg-turbo8 libjpeg8 liblua5.3-0\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-http-geoip2\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-http-image-filter\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-http-xslt-filter\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-mail\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-stream\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libnginx-mod-stream-geoip2 libtiff5\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  libwebp7 libxpm4 mailcap\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  mime-support nginx nginx-common\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m  nginx-core ssl-cert\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0 upgraded, 33 newly installed, 0 to remove and 21 not upgraded.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mNeed to get 4,836 kB of archives.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mAfter this operation, 16.9 MB of additional disk space will be used.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:1 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libapr1 amd64 1.7.0-8ubuntu0.22.04.2 [108 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m0% [1 libapr1 9,308 B/108 kB 9%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m1% [1 libapr1 56.1 kB/108 kB 52%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Still creating... [00m30s elapsed][0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m2% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:2 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libaprutil1 amd64 1.6.1-5ubuntu4.22.04.2 [92.8 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m2% [2 libaprutil1 2,109 B/92.8 kB 2%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m5% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:3 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libaprutil1-dbd-sqlite3 amd64 1.6.1-5ubuntu4.22.04.2 [11.3 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m5% [3 libaprutil1-dbd-sqlite3 8,661 B/1[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:4 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libaprutil1-ldap amd64 1.6.1-5ubuntu4.22.04.2 [9,170 B]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m5% [4 libaprutil1-ldap 9,028 B/9,170 B [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m6% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:5 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 liblua5.3-0 amd64 5.3.6-1build1 [140 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m6% [5 liblua5.3-0 1,966 B/140 kB 1%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m9% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:6 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 apache2-bin amd64 2.4.52-1ubuntu4.16 [1,349 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m9% [6 apache2-bin 9,306 B/1,349 kB 1%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m29% [6 apache2-bin 1,209 kB/1,349 kB 90[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m32% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:7 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 apache2-data all 2.4.52-1ubuntu4.16 [165 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m32% [7 apache2-data 0 B/165 kB 0%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m35% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:8 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 apache2-utils amd64 2.4.52-1ubuntu4.16 [89.3 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m35% [8 apache2-utils 0 B/89.3 kB 0%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m37% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:9 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 mailcap all 3.70+nmu1ubuntu1 [23.8 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m37% [9 mailcap 0 B/23.8 kB 0%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m38% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:10 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 mime-support all 3.66 [3,696 B]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m38% [10 mime-support 3,696 B/3,696 B 10[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m39% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:11 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 apache2 amd64 2.4.52-1ubuntu4.16 [97.9 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m39% [11 apache2 10.1 kB/97.9 kB 10%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m41% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:12 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 bzip2 amd64 1.0.8-5build1 [34.8 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m41% [12 bzip2 7,286 B/34.8 kB 21%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m42% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:13 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 fonts-dejavu-core all 2.37-2build1 [1,041 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m43% [13 fonts-dejavu-core 36.4 kB/1,041[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m60% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:14 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 fontconfig-config all 2.13.1-4.2ubuntu5 [29.1 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m60% [14 fontconfig-config 0 B/29.1 kB 0[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:15 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 libdeflate0 amd64 1.10-2 [70.9 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m62% [15 libdeflate0 58.5 kB/70.9 kB 82%[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m63% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:16 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 libfontconfig1 amd64 2.13.1-4.2ubuntu5 [131 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m64% [16 libfontconfig1 51.5 kB/131 kB 3[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m66% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:17 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 libjpeg-turbo8 amd64 2.1.2-0ubuntu1 [134 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m67% [17 libjpeg-turbo8 50.9 kB/134 kB 3[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m69% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:18 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 libjpeg8 amd64 8c-2ubuntu10 [2,264 B]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m69% [18 libjpeg8 2,264 B/2,264 B 100%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m69% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:19 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libjbig0 amd64 2.1-3.1ubuntu0.22.04.1 [29.2 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m70% [19 libjbig0 29.2 kB/29.2 kB 100%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m70% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:20 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libwebp7 amd64 1.2.2-2ubuntu0.22.04.2 [206 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m72% [20 libwebp7 115 kB/206 kB 56%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m74% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:21 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libtiff5 amd64 4.3.0-6ubuntu0.10 [185 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m76% [21 libtiff5 121 kB/185 kB 65%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m78% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:22 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libxpm4 amd64 1:3.5.12-1ubuntu0.22.04.2 [36.7 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m79% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:23 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libgd3 amd64 2.3.0-2ubuntu2.3 [129 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m80% [23 libgd3 28.5 kB/129 kB 22%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m82% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:24 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 nginx-common all 1.18.0-6ubuntu14.6 [40.1 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m82% [24 nginx-common 8,110 B/40.1 kB 20[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m83% [Waiting for headers][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:25 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libnginx-mod-http-geoip2 amd64 1.18.0-6ubuntu14.6 [12.0 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m83% [25 libnginx-mod-http-geoip2 4,510 [0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:26 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libnginx-mod-http-image-filter amd64 1.18.0-6ubuntu14.6 [15.5 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:27 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libnginx-mod-http-xslt-filter amd64 1.18.0-6ubuntu14.6 [13.8 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:28 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libnginx-mod-mail amd64 1.18.0-6ubuntu14.6 [45.8 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:29 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libnginx-mod-stream amd64 1.18.0-6ubuntu14.6 [73.0 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m87% [29 libnginx-mod-stream 1,625 B/73.[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m89% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:30 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 libnginx-mod-stream-geoip2 amd64 1.18.0-6ubuntu14.6 [10.1 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m89% [30 libnginx-mod-stream-geoip2 0 B/[0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m90% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:31 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 nginx-core amd64 1.18.0-6ubuntu14.6 [483 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m90% [31 nginx-core 5,689 B/483 kB 1%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m98% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:32 http://cm.archive.ubuntu.com/ubuntu jammy-updates/main amd64 nginx amd64 1.18.0-6ubuntu14.6 [3,882 B]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m98% [32 nginx 912 B/3,882 B 23%][0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m99% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mGet:33 http://cm.archive.ubuntu.com/ubuntu jammy/main amd64 ssl-cert all 1.1.2 [17.4 kB]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m99% [33 ssl-cert 2,110 B/17.4 kB 12%][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[33m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m100% [Working][0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mFetched 4,836 kB in 4s (1,107 kB/s)\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mExtracting templates from packages: 90%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mExtracting templates from packages: 100%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreconfiguring packages ...\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[0;79r8[1ASelecting previously unselected package libapr1:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 5%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 10%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 15%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 20%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 25%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 30%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 35%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 40%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 45%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 50%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 55%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 60%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 65%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 70%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 75%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 80%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 85%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 90%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 95%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 100%\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m(Reading database ... 75004 files and directories currently installed.)\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../00-libapr1_1.7.0-8ubuntu0.22.04.2_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  0%][49m[39m [..................] 8Unpacking libapr1:amd64 (1.7.0-8ubuntu0.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  2%][49m[39m [..................] 8Selecting previously unselected package libaprutil1:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../01-libaprutil1_1.6.1-5ubuntu4.22.04.2_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  2%][49m[39m [..................] 8Unpacking libaprutil1:amd64 (1.6.1-5ubuntu4.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  3%][49m[39m [..................] 8Selecting previously unselected package libaprutil1-dbd-sqlite3:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../02-libaprutil1-dbd-sqlite3_1.6.1-5ubuntu4.22.04.2_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libaprutil1-dbd-sqlite3:amd64 (1.6.1-5ubuntu4.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  5%][49m[39m [..................] 8Selecting previously unselected package libaprutil1-ldap:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../03-libaprutil1-ldap_1.6.1-5ubuntu4.22.04.2_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  5%][49m[39m [..................] 8Unpacking libaprutil1-ldap:amd64 (1.6.1-5ubuntu4.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  6%][49m[39m [#.................] 8Selecting previously unselected package liblua5.3-0:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../04-liblua5.3-0_5.3.6-1build1_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking liblua5.3-0:amd64 (5.3.6-1build1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  8%][49m[39m [#.................] 8Selecting previously unselected package apache2-bin.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../05-apache2-bin_2.4.52-1ubuntu4.16_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  8%][49m[39m [#.................] 8Unpacking apache2-bin (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [  9%][49m[39m [#.................] 8Selecting previously unselected package apache2-data.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../06-apache2-data_2.4.52-1ubuntu4.16_all.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking apache2-data (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 11%][49m[39m [#.................] 8Selecting previously unselected package apache2-utils.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../07-apache2-utils_2.4.52-1ubuntu4.16_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 11%][49m[39m [##................] 8Unpacking apache2-utils (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 12%][49m[39m [##................] 8Selecting previously unselected package mailcap.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../08-mailcap_3.70+nmu1ubuntu1_all.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking mailcap (3.70+nmu1ubuntu1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 14%][49m[39m [##................] 8Selecting previously unselected package mime-support.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../09-mime-support_3.66_all.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 14%][49m[39m [##................] 8Unpacking mime-support (3.66) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 15%][49m[39m [##................] 8Selecting previously unselected package apache2.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../10-apache2_2.4.52-1ubuntu4.16_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking apache2 (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 17%][49m[39m [##................] 8Selecting previously unselected package bzip2.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../11-bzip2_1.0.8-5build1_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 17%][49m[39m [###...............] 8Unpacking bzip2 (1.0.8-5build1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 18%][49m[39m [###...............] 8Selecting previously unselected package fonts-dejavu-core.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../12-fonts-dejavu-core_2.37-2build1_all.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking fonts-dejavu-core (2.37-2build1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 20%][49m[39m [###...............] 8Selecting previously unselected package fontconfig-config.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../13-fontconfig-config_2.13.1-4.2ubuntu5_all.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 20%][49m[39m [###...............] 8Unpacking fontconfig-config (2.13.1-4.2ubuntu5) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 21%][49m[39m [###...............] 8Selecting previously unselected package libdeflate0:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../14-libdeflate0_1.10-2_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libdeflate0:amd64 (1.10-2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 23%][49m[39m [####..............] 8Selecting previously unselected package libfontconfig1:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../15-libfontconfig1_2.13.1-4.2ubuntu5_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 23%][49m[39m [####..............] 8Unpacking libfontconfig1:amd64 (2.13.1-4.2ubuntu5) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 24%][49m[39m [####..............] 8Selecting previously unselected package libjpeg-turbo8:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../16-libjpeg-turbo8_2.1.2-0ubuntu1_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libjpeg-turbo8:amd64 (2.1.2-0ubuntu1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 26%][49m[39m [####..............] 8Selecting previously unselected package libjpeg8:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../17-libjpeg8_8c-2ubuntu10_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 26%][49m[39m [####..............] 8Unpacking libjpeg8:amd64 (8c-2ubuntu10) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 27%][49m[39m [####..............] 8Selecting previously unselected package libjbig0:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../18-libjbig0_2.1-3.1ubuntu0.22.04.1_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libjbig0:amd64 (2.1-3.1ubuntu0.22.04.1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 29%][49m[39m [#####.............] 8Selecting previously unselected package libwebp7:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../19-libwebp7_1.2.2-2ubuntu0.22.04.2_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 29%][49m[39m [#####.............] 8Unpacking libwebp7:amd64 (1.2.2-2ubuntu0.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 30%][49m[39m [#####.............] 8Selecting previously unselected package libtiff5:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../20-libtiff5_4.3.0-6ubuntu0.10_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libtiff5:amd64 (4.3.0-6ubuntu0.10) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 32%][49m[39m [#####.............] 8Selecting previously unselected package libxpm4:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../21-libxpm4_1%3a3.5.12-1ubuntu0.22.04.2_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 32%][49m[39m [#####.............] 8Unpacking libxpm4:amd64 (1:3.5.12-1ubuntu0.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 33%][49m[39m [#####.............] 8Selecting previously unselected package libgd3:amd64.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../22-libgd3_2.3.0-2ubuntu2.3_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libgd3:amd64 (2.3.0-2ubuntu2.3) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 35%][49m[39m [######............] 8Selecting previously unselected package nginx-common.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../23-nginx-common_1.18.0-6ubuntu14.6_all.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 35%][49m[39m [######............] 8Unpacking nginx-common (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 36%][49m[39m [######............] 8Selecting previously unselected package libnginx-mod-http-geoip2.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../24-libnginx-mod-http-geoip2_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libnginx-mod-http-geoip2 (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 38%][49m[39m [######............] 8Selecting previously unselected package libnginx-mod-http-image-filter.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../25-libnginx-mod-http-image-filter_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 38%][49m[39m [######............] 8Unpacking libnginx-mod-http-image-filter (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 39%][49m[39m [#######...........] 8Selecting previously unselected package libnginx-mod-http-xslt-filter.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../26-libnginx-mod-http-xslt-filter_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libnginx-mod-http-xslt-filter (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 41%][49m[39m [#######...........] 8Selecting previously unselected package libnginx-mod-mail.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../27-libnginx-mod-mail_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 41%][49m[39m [#######...........] 8Unpacking libnginx-mod-mail (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 42%][49m[39m [#######...........] 8Selecting previously unselected package libnginx-mod-stream.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../28-libnginx-mod-stream_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking libnginx-mod-stream (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 44%][49m[39m [#######...........] 8Selecting previously unselected package libnginx-mod-stream-geoip2.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../29-libnginx-mod-stream-geoip2_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 44%][49m[39m [#######...........] 8Unpacking libnginx-mod-stream-geoip2 (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 45%][49m[39m [########..........] 8Selecting previously unselected package nginx-core.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../30-nginx-core_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking nginx-core (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 47%][49m[39m [########..........] 8Selecting previously unselected package nginx.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../31-nginx_1.18.0-6ubuntu14.6_amd64.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 47%][49m[39m [########..........] 8Unpacking nginx (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 48%][49m[39m [########..........] 8Selecting previously unselected package ssl-cert.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mPreparing to unpack .../32-ssl-cert_1.1.2_all.deb ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mUnpacking ssl-cert (1.1.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 50%][49m[39m [########..........] 8Setting up libxpm4:amd64 (1:3.5.12-1ubuntu0.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 50%][49m[39m [#########.........] 87[80;0f[42m[30mProgress: [ 51%][49m[39m [#########.........] 8Setting up libdeflate0:amd64 (1.10-2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 53%][49m[39m [#########.........] 8Setting up libapr1:amd64 (1.7.0-8ubuntu0.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 53%][49m[39m [#########.........] 87[80;0f[42m[30mProgress: [ 54%][49m[39m [#########.........] 8Setting up nginx-common (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mCreated symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib/systemd/system/nginx.service.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Still creating... [00m40s elapsed][0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 56%][49m[39m [##########........] 8Setting up bzip2 (1.0.8-5build1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 56%][49m[39m [##########........] 87[80;0f[42m[30mProgress: [ 57%][49m[39m [##########........] 8Setting up libjbig0:amd64 (2.1-3.1ubuntu0.22.04.1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 59%][49m[39m [##########........] 8Setting up libnginx-mod-http-xslt-filter (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 59%][49m[39m [##########........] 87[80;0f[42m[30mProgress: [ 60%][49m[39m [##########........] 8Setting up ssl-cert (1.1.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 62%][49m[39m [###########.......] 8Setting up fonts-dejavu-core (2.37-2build1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 62%][49m[39m [###########.......] 87[80;0f[42m[30mProgress: [ 63%][49m[39m [###########.......] 8Setting up libjpeg-turbo8:amd64 (2.1.2-0ubuntu1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 65%][49m[39m [###########.......] 8Setting up libwebp7:amd64 (1.2.2-2ubuntu0.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 65%][49m[39m [###########.......] 87[80;0f[42m[30mProgress: [ 66%][49m[39m [###########.......] 8Setting up liblua5.3-0:amd64 (5.3.6-1build1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 68%][49m[39m [############......] 8Setting up apache2-data (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 68%][49m[39m [############......] 87[80;0f[42m[30mProgress: [ 69%][49m[39m [############......] 8Setting up libnginx-mod-http-geoip2 (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 71%][49m[39m [############......] 8Setting up mailcap (3.70+nmu1ubuntu1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 71%][49m[39m [############......] 87[80;0f[42m[30mProgress: [ 72%][49m[39m [############......] 8Setting up libaprutil1:amd64 (1.6.1-5ubuntu4.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 74%][49m[39m [#############.....] 8Setting up libjpeg8:amd64 (8c-2ubuntu10) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 74%][49m[39m [#############.....] 87[80;0f[42m[30mProgress: [ 75%][49m[39m [#############.....] 8Setting up libnginx-mod-mail (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 77%][49m[39m [#############.....] 8Setting up mime-support (3.66) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 77%][49m[39m [#############.....] 87[80;0f[42m[30mProgress: [ 78%][49m[39m [##############....] 8Setting up fontconfig-config (2.13.1-4.2ubuntu5) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 80%][49m[39m [##############....] 8Setting up libnginx-mod-stream (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 80%][49m[39m [##############....] 87[80;0f[42m[30mProgress: [ 81%][49m[39m [##############....] 8Setting up libaprutil1-ldap:amd64 (1.6.1-5ubuntu4.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 83%][49m[39m [##############....] 8Setting up libaprutil1-dbd-sqlite3:amd64 (1.6.1-5ubuntu4.22.04.2) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 83%][49m[39m [###############...] 87[80;0f[42m[30mProgress: [ 84%][49m[39m [###############...] 8Setting up libtiff5:amd64 (4.3.0-6ubuntu0.10) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 86%][49m[39m [###############...] 8Setting up libfontconfig1:amd64 (2.13.1-4.2ubuntu5) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 86%][49m[39m [###############...] 87[80;0f[42m[30mProgress: [ 87%][49m[39m [###############...] 8Setting up libnginx-mod-stream-geoip2 (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 89%][49m[39m [###############...] 8Setting up apache2-utils (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 89%][49m[39m [################..] 87[80;0f[42m[30mProgress: [ 90%][49m[39m [################..] 8Setting up apache2-bin (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 92%][49m[39m [################..] 8Setting up libgd3:amd64 (2.3.0-2ubuntu2.3) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 92%][49m[39m [################..] 87[80;0f[42m[30mProgress: [ 93%][49m[39m [################..] 8Setting up apache2 (2.4.52-1ubuntu4.16) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module mpm_event.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module authz_core.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module authz_host.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module authn_core.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module auth_basic.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module access_compat.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module authn_file.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module authz_user.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module alias.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module dir.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module autoindex.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module env.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module mime.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module negotiation.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module setenvif.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module filter.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module deflate.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module status.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling module reqtimeout.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling conf charset.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling conf localized-error-pages.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling conf other-vhosts-access-log.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling conf security.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling conf serve-cgi-bin.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mEnabling site 000-default.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mCreated symlink /etc/systemd/system/multi-user.target.wants/apache2.service → /lib/systemd/system/apache2.service.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mCould not execute systemctl:  at /usr/bin/deb-systemd-invoke line 142.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mCreated symlink /etc/systemd/system/multi-user.target.wants/apache-htcacheclean.service → /lib/systemd/system/apache-htcacheclean.service.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 95%][49m[39m [#################.] 8Setting up libnginx-mod-http-image-filter (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 95%][49m[39m [#################.] 87[80;0f[42m[30mProgress: [ 96%][49m[39m [#################.] 8Setting up nginx-core (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m * Upgrading binary nginx       [40G\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Still creating... [00m50s elapsed][0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m[34G[ OK ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 98%][49m[39m [#################.] 8Setting up nginx (1.18.0-6ubuntu14.6) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[80;0f[42m[30mProgress: [ 98%][49m[39m [#################.] 87[80;0f[42m[30mProgress: [ 99%][49m[39m [#################.] 8Processing triggers for ufw (0.36.1-4ubuntu0.1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mProcessing triggers for man-db (2.10.2-1) ...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mProcessing triggers for libc-bin (2.35-0ubuntu3.10) ...\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m7[0;80r8[1A[J\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [                ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=               ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==              ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [====            ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=====           ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [======          ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=======         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [========        ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=========       ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==========      ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [===========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [============    ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============   ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [==============  ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [=============== ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes... [================]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning processes...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning linux images... [             ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning linux images... [====         ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning linux images... [========     ]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning linux images... [=============]\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mScanning linux images...\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mRunning kernel seems to be up-to-date.\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mNo services need to be restarted.\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mNo containers need to be restarted.\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mNo user sessions are running outdated\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m binaries.\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mNo VM guests are running outdated\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m hypervisor (qemu) binaries on this\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m host.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m📁 Création du site web /var/www/web.camer.cm\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m📝 Création de la page d’accueil personnalisée...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m🔧 Configuration NGINX pour web.camer.cm...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m🚀 Redémarrage de NGINX...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mSynchronizing state of nginx.service with SysV service script with /lib/systemd/systemd-sysv-install.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mExecuting: /lib/systemd/systemd-sysv-install enable nginx\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m🛡️ Configuration UFW pour NGINX...\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mRules updated\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mRules updated (v6)\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mRules updated\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mRules updated (v6)\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mRules updated\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mRules updated (v6)\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0mFirewall is active and enabled on system startup\n\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m✅ Camer-Web est prêt. Teste http://web.camer.cm depuis le reverse proxy ou le client interne.\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m2025-08-14T01:15:33+00:00 - Initialized instance with ID: ${INSTANCE_ID}\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Still creating... [01m00s elapsed][0m[0m\n[0m[1mnull_resource.run_scripts["testweb-ngnix"] (remote-exec):[0m [0m✅ Fin des scripts avec INSTANCE_ID=7acce2a5-2193-4978-8a29-f60bbd7d5058\n[0m[1mnull_resource.run_scripts["testweb-ngnix"]: Creation complete after 1m0s [id=323103114654977689][0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "service_type" but a\n[33m│[0m [0mvalue was found in file "variables.tfvars.json". If you meant to use this\n[33m│[0m [0mvalue, add a "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mThe root module does not declare a variable named "_meta" but a value was\n[33m│[0m [0mfound in file "variables.tfvars.json". If you meant to use this value, add\n[33m│[0m [0ma "variable" block to the configuration.\n[33m│[0m [0m\n[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide\n[33m│[0m [0mcertain "global" settings to all configurations in your organization. To\n[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.\n[33m╵[0m[0m\n[33m╷[0m[0m\n[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValues for undeclared variables[0m\n[33m│[0m [0m\n[33m│[0m [0m[0mIn addition to the other similar warnings shown, 3 other variable(s)\n[33m│[0m [0mdefined without being declared.\n[33m╵[0m[0m\n[0m[1m[32m\nApply complete! Resources: 2 added, 0 changed, 0 destroyed.\n[0m[0m[1m[32m\nOutputs:\n\n[0mssh_commands = {\n  "testweb-ngnix" = "ssh -i C:/Users/Nexus-PC/.ssh/id_rsa nexus@192.168.24.215"\n}\nstatus = <<EOT\n✅ 1 VM(s) déployée(s)\r\n📄 Scripts injectés :\r\n- testweb-ngnix : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-3.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\30\\testweb-ngnix-script-4.sh\r\n\nEOT\nvm_ids = {\n  "testweb-ngnix" = 103\n}\nvm_ips = {\n  "testweb-ngnix" = "192.168.24.215"\n}\nvm_names = [\n  "testweb-ngnix",\n]\n	Absolument. Voici une analyse détaillée de ces logs de déploiement.\n\n### 1. Résumé des événements principaux\n\nCe log décrit le déploiement automatisé d'une machine virtuelle (VM) destinée à héberger un service web Nginx, orchestré par Terraform.\n\nVoici les étapes clés dans l'ordre chronologique :\n\n1.  **👤 Lancement :** Le déploiement, nommé `Web_Ngnix`, a été initié par l'utilisateur `latifnjimoluh@gmail.com` le 14 août 2025.\n2.  **🔧 Initialisation de Terraform :** Terraform a démarré en initialisant ses fournisseurs (`providers`), notamment `telmate/proxmox` pour gérer la virtualisation sur Proxmox.\n3.  **VM Création :** Une machine virtuelle a été créée sur l'hyperviseur Proxmox :\n    *   **Nom :** `testweb-ngnix`\n    *   **Source :** Clonée à partir d'un template nommé `ubuntu-template`.\n    *   **Spécifications :** 2 cœurs CPU, 2 Go de RAM, 20 Go de disque.\n    *   **Durée :** La création de la VM a pris 1 minute et 40 secondes.\n    *   **Résultat :** La VM a obtenu l'ID `103` et l'adresse IP `192.168.24.215`.\n4.  **⚙️ Provisioning (Configuration post-création) :** Une fois la VM démarrée, Terraform a exécuté des scripts de configuration :\n    *   **Copie des scripts :** Quatre fichiers scripts (`.sh`) ont été copiés de la machine locale vers la nouvelle VM via `scp`.\n    *   **Exécution à distance :** Une connexion SSH a été établie avec la VM (`nexus@192.168.24.215`) pour exécuter ces scripts.\n    *   **Actions des scripts :**\n        *   Mise à jour des paquets (`apt update`).\n        *   Installation de logiciels, notamment **Nginx** et **Apache2**.\n        *   Création d'un répertoire pour le site web (`/var/www/web.camer.cm`).\n        *   Création d'une page d'accueil `index.html`.\n        *   Configuration d'un vhost Nginx pour `web.camer.cm` et redémarrage du service.\n        *   Configuration du pare-feu `ufw` pour autoriser le trafic Nginx.\n5.  **✅ Finalisation :** Le déploiement s'est terminé avec succès. Terraform a affiché en sortie l'adresse IP de la VM, son ID et la commande SSH pour s'y connecter.\n\n---\n\n### 2. Évaluation de la configuration utilisée\n\nLa configuration est fonctionnelle mais présente plusieurs points qui pourraient être améliorés en termes de bonnes pratiques et de robustesse.\n\n**Points positifs :**\n*   ✅ **Automatisation :** L'utilisation de Terraform pour l'IaC (Infrastructure as Code) est une excellente pratique. Elle garantit la reproductibilité et la rapidité des déploiements.\n*   ✅ **Utilisation de templates :** Le clonage depuis un `ubuntu-template` est efficace et plus rapide que d'installer un OS depuis zéro.\n*   ✅ **Cloud-init :** L'usage de `cloud-init` pour configurer l'utilisateur (`nexus`) et injecter la clé SSH est la méthode standard et sécurisée pour le premier démarrage d'une VM.\n\n**Points à améliorer (critiques) :**\n*   ⚠️ **Double serveur web :** Le script installe à la fois `nginx` et `apache2`. C'est inutile, redondant, et cela consomme des ressources (disque, RAM) tout en augmentant la surface d'attaque. Le déploiement étant nommé "Web_Ngnix", Apache2 ne devrait pas être là.\n*   ⛔ **Gestion des secrets :** La clé SSH privée (`ssh-rsa AAAAB3...`) est **directement intégrée dans la configuration Terraform** et apparaît en clair dans les logs. C'est une faille de sécurité majeure. Les secrets ne doivent jamais être codés en dur.\n*   🤔 **Méthode de provisioning :** L'utilisation de `null_resource` avec `remote-exec` fonctionne pour des tâches simples, mais elle est considérée comme fragile. Si une des commandes du script échoue, la ressource Terraform peut se retrouver dans un état incohérent. Des outils de gestion de configuration comme **Ansible**, **Packer** (pour pré-configurer l'image) ou un usage plus poussé de **cloud-init** sont plus robustes.\n*   🟡 **Variables non déclarées :** Les logs affichent des avertissements (`Warning: Value for undeclared variable`) pour `service_type`, `_meta`, etc. Cela indique que le fichier de variables (`variables.tfvars.json`) contient des variables qui n'existent pas dans le code Terraform. C'est un signe de code "malpropre" qui peut prêter à confusion.\n\n---\n\n### 3. Propositions d'optimisations\n\nVoici des pistes d'amélioration classées par catégorie :\n\n#### Performance\n1.  **Alléger l'image de base :**\n    *   Supprimer l'installation d'Apache2 du script de provisioning pour économiser des ressources.\n    *   Utiliser **Packer** pour créer un template (`ubuntu-template`) qui contient déjà Nginx et les configurations de base. Le déploiement serait alors quasi-instantané, car il n'y aurait plus d'`apt install` à exécuter.\n2.  **Optimisation Nginx :**\n    *   Activer la compression Gzip/Brotli dans la configuration Nginx pour réduire la taille des assets (HTML, CSS, JS) et accélérer le chargement côté client.\n    *   Mettre en place des règles de cache (`Cache-Control`) pour les fichiers statiques afin que les navigateurs ne les retéléchargent pas à chaque visite.\n3.  **Dimensionnement (Rightsizing) :**\n    *   Monitorer l'utilisation réelle des ressources (CPU, RAM) de la VM. 2 Go de RAM et 2 cœurs pour un simple site statique Nginx est probablement surdimensionné. La VM pourrait être réduite pour optimiser les coûts et les ressources de l'hyperviseur.\n\n#### Sécurité\n1.  **Gestion des secrets (Priorité haute) :**\n    *   Stocker la clé SSH dans un gestionnaire de secrets comme **HashiCorp Vault** ou AWS/Azure/GCP Secrets Manager. Terraform peut alors récupérer la clé dynamiquement sans l'exposer.\n    *   À défaut, utiliser des variables d'environnement (`export TF_VAR_ssh_private_key="..."`) pour injecter la clé au moment du `terraform apply` au lieu de la stocker dans un fichier.\n2.  **Principe de moindre privilège :**\n    *   L'utilisateur `nexus` a besoin de droits `sudo` pour installer des paquets. Après l'installation, Nginx devrait s'exécuter avec un utilisateur système non privilégié (ce que Nginx fait par défaut, `www-data`).\n    *   Durcir la configuration SSH : désactiver l'authentification par mot de passe et n'autoriser que les connexions par clé.\n3.  **Pare-feu (`ufw`) :**\n    *   S'assurer que le pare-feu n'autorise que le trafic strictement nécessaire : le port `22` (SSH) uniquement depuis des adresses IP de confiance (bastion, IP admin) et les ports `80`/`443` (HTTP/S) depuis n'importe où.\n4.  **Mises à jour régulières :**\n    *   Le log indique `21 packages can be upgraded`. Mettre en place un processus de **patch management** (par ex. `unattended-upgrades` ou un playbook Ansible mensuel) pour appliquer les mises à jour de sécurité critiques.\n\n#### Monitoring\n1.  **Supervision de la VM :**\n    *   Installer un agent de monitoring (ex: **Prometheus Node Exporter**, **Zabbix Agent**, **Datadog Agent**) pour collecter les métriques système : usage CPU, RAM, disque, I/O, réseau.\n2.  **Supervision Applicative (Nginx) :**\n    *   Activer le module `ngx_http_stub_status_module` de Nginx pour exposer des métriques de base (connexions actives, requêtes traitées).\n    *   Mettre en place un système de **centralisation des logs** (ex: pile ELK, Graylog, Loki) pour agréger les logs d'accès et d'erreur de Nginx. Cela est indispensable pour le débogage et la détection d'activités suspectes (tentatives de scan, erreurs 4xx/5xx en masse).\n3.  **Alerting :**\n    *   Configurer des alertes basées sur les métriques collectées : par exemple, si l'usage CPU dépasse 80% pendant 5 minutes, si le disque est presque plein, ou si le taux d'erreurs 5xx sur Nginx augmente.	deployment	42	2025-08-14 03:14:39.827+01	2025-08-14 03:14:39.827+01
22	analyze_dashboard	48b08cd8c476dd11575b5db807fee53a57ab7d8dbe0aae3db62f7c320b10b938	{"totals":{"deployed":41,"success":23,"failed":14,"deleted":40},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":18,"deleted":3,"success":4,"failed":11},{"period":"2025-08-13","deployed":7,"deleted":4,"success":4,"failed":3},{"period":"2025-08-14","deployed":3,"deleted":0,"success":2,"failed":0}]}		\N	\N	2025-08-14 04:18:33.27+01	2025-08-14 04:18:33.27+01
\.


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerts (id, server, service, severity, status, description, comment, started_at, created_at, updated_at) FROM stdin;
1	192.168.24.213	RAM	critique	en_cours	RAM usage 16.76% (seuil 10%)	\N	2025-08-14 13:10:57.035+01	2025-08-14 13:10:57.036+01	2025-08-14 13:10:57.036+01
2	192.168.24.214	RAM	critique	en_cours	RAM usage 18.69% (seuil 10%)	\N	2025-08-14 13:10:57.108+01	2025-08-14 13:10:57.109+01	2025-08-14 13:10:57.109+01
3	192.168.24.215	RAM	critique	en_cours	RAM usage 17.31% (seuil 10%)	\N	2025-08-14 13:10:57.128+01	2025-08-14 13:10:57.128+01	2025-08-14 13:10:57.128+01
\.


--
-- Data for Name: assigned_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assigned_permissions (role_id, permission_id, created_at, updated_at) FROM stdin;
1	1	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	2	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	3	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	4	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	5	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	6	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	7	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	8	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	9	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	10	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	11	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	12	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	13	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	14	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	15	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	16	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	17	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	18	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	19	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	20	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	21	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	22	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	23	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	24	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	25	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	26	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	27	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	28	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	29	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	30	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	31	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	32	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	33	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	34	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	35	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	36	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	37	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	38	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	39	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	40	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	41	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	42	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	43	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	45	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	46	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	47	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	48	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	49	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	50	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	51	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	52	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	53	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	54	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	55	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	56	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	57	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	58	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	59	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	60	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	61	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
2	54	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
3	36	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
3	5	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
3	6	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
3	4	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	63	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	64	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	65	2025-08-13 04:33:58.823508+01	2025-08-13 04:33:58.823508+01
1	68	2025-08-13 17:56:44.264987+01	2025-08-13 17:56:44.264987+01
1	69	2025-08-14 04:32:15.266808+01	2025-08-14 04:32:15.266808+01
1	70	2025-08-14 12:25:59.985895+01	2025-08-14 12:25:59.985895+01
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
28	101	inst-0001	Webapache	192.168.24.202	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-08T12-40-58-723Z-1.log	1	latifnjimoluh@gmail.com	2025-08-08 13:41:05.964+01	2025-08-08 13:41:05.964+01	2025-08-08 13:41:05.964+01
29	104	inst-0001	we0w2b	192.168.24.201	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-08T12-41-10-978Z-1.log	1	latifnjimoluh@gmail.com	2025-08-08 13:41:13.268+01	2025-08-08 13:41:13.268+01	2025-08-08 13:41:13.268+01
30	101	inst-0001	Webapache	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-08T12-43-05-739Z-1.log	1	latifnjimoluh@gmail.com	2025-08-08 13:43:05.852+01	2025-08-08 13:43:05.852+01	2025-08-08 13:43:05.852+01
31	101	c8f4a86e-ca73-44b8-bfca-edf40641cc99	Webapache	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-11T13-17-46-528Z-1.log	1	latifnjimoluh@gmail.com	2025-08-11 14:17:46.629+01	2025-08-11 14:17:46.63+01	2025-08-11 14:17:46.63+01
32	104	d45d414b-a18d-4f3a-9a97-c84d8d4417c5	testweb	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-11T13-30-33-735Z-1.log	1	latifnjimoluh@gmail.com	2025-08-11 14:30:33.819+01	2025-08-11 14:30:33.82+01	2025-08-11 14:30:33.82+01
33	103	c06d59eb-a650-4427-ba92-05b107a6fd81	monitoring	192.168.24.130	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-11T13-30-31-727Z-1.log	1	latifnjimoluh@gmail.com	2025-08-11 14:30:34.054+01	2025-08-11 14:30:34.055+01	2025-08-11 14:30:34.055+01
34	101	88966679-e8a2-4c48-b948-75ca879e7343	testwebserver	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-12T11-35-15-613Z-1.log	1	latifnjimoluh@gmail.com	2025-08-12 12:35:20.823+01	2025-08-12 12:35:20.824+01	2025-08-12 12:35:20.824+01
35	103	793826a0-2600-40a4-bdd8-2fd2209e4df9	testweb20122	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-12T11-35-18-649Z-1.log	1	latifnjimoluh@gmail.com	2025-08-12 12:35:23.876+01	2025-08-12 12:35:23.876+01	2025-08-12 12:35:23.876+01
36	101	88966679-e8a2-4c48-b948-75ca879e7343	web301	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-12T14-25-17-922Z-1.log	1	latifnjimoluh@gmail.com	2025-08-12 15:25:23.134+01	2025-08-12 15:25:23.134+01	2025-08-12 15:25:23.134+01
37	101	88966679-e8a2-4c48-b948-75ca879e7343	test-cron	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-13T06-51-21-574Z-1.log	1	latifnjimoluh@gmail.com	2025-08-13 07:51:21.657+01	2025-08-13 07:51:21.658+01	2025-08-13 07:51:21.658+01
38	102	f737e3a0-19c9-4530-8526-59d196247813	dsfgdggd	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-13T15-36-45-402Z-1.log	1	latifnjimoluh@gmail.com	2025-08-13 16:36:45.498+01	2025-08-13 16:36:45.498+01	2025-08-13 16:36:45.498+01
39	103	793826a0-2600-40a4-bdd8-2fd2209e4df9	second	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-13T15-36-53-782Z-1.log	1	latifnjimoluh@gmail.com	2025-08-13 16:36:53.875+01	2025-08-13 16:36:53.875+01	2025-08-13 16:36:53.875+01
40	101	542e8abc-c806-4507-862e-2e171e45784a	web-test	192.168.24.212	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-13T15-36-59-781Z-1.log	1	latifnjimoluh@gmail.com	2025-08-13 16:37:02.146+01	2025-08-13 16:37:02.146+01	2025-08-13 16:37:02.146+01
\.


--
-- Data for Name: deployments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deployments (id, user_id, user_email, vm_name, service_name, zone, operation_type, started_at, ended_at, duration, success, log_path, vm_id, vm_ip, instance_id, injected_files, vm_specs, status, created_at, updated_at) FROM stdin;
2	1	latifnjimoluh@gmail.com	tes2023	web	LAN	apply	2025-08-06 09:59:32.654+01	2025-08-06 10:01:27.024+01	114.37s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T08-59-32-654Z-1.log	101	192.168.24.89	90c1de06-5101-4ed7-a500-0ad0006cb3cb	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 10:01:27.025+01	2025-08-06 10:01:27.025+01
3	1	latifnjimoluh@gmail.com	yedb	web	LAN	apply	2025-08-06 12:08:15.284+01	2025-08-06 12:10:16.111+01	120.827s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-08-15-284Z-1.log	104	192.168.24.93	387b2866-50c6-4c89-98f0-8db4125d137d	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:10:16.117+01	2025-08-06 12:10:16.117+01
4	1	latifnjimoluh@gmail.com	test1	web	LAN	apply	2025-08-06 12:17:15.327+01	2025-08-06 12:19:19.158+01	123.831s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-17-15-327Z-1.log	101	192.168.24.94	505bb44b-f327-47f7-a2d2-5fb231456c2f	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:19:19.159+01	2025-08-06 12:19:19.159+01
5	1	latifnjimoluh@gmail.com	web1	web	LAN	apply	2025-08-06 12:21:48.614+01	2025-08-06 12:26:23.835+01	275.221s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-21-48-614Z-1.log	103	192.168.24.95	9a9db055-86a2-4dff-a5be-f963756614c7	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:26:23.837+01	2025-08-06 12:26:23.837+01
6	1	latifnjimoluh@gmail.com	web12	web	LAN	apply	2025-08-06 12:31:32.685+01	2025-08-06 12:35:01.198+01	208.513s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T11-31-32-685Z-1.log	101	192.168.24.96	9fb15047-d841-4d06-b4ac-861ac93fe350	["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 12:35:01.2+01	2025-08-06 12:35:01.2+01
7	1	latifnjimoluh@gmail.com	webtest	web	LAN	apply	2025-08-06 13:23:42.706+01	2025-08-06 13:25:42.865+01	120.159s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T12-23-42-706Z-1.log	103	192.168.24.97	3c634098-a504-4bcf-a13d-f0f807a7e0e7	["/scripts/generated/web/web_server_nginx_web_D_ploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_G_n_ration_du_script_script001.sh","/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_syst_me_-_G_n_ration_du_script_script001.sh","/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 13:25:42.869+01	2025-08-06 13:25:42.869+01
8	1	latifnjimoluh@gmail.com	webtes2t	web	LAN	apply	2025-08-06 13:28:12.098+01	2025-08-06 13:30:11.48+01	119.382s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T12-28-12-098Z-1.log	104	192.168.24.98	77f999e8-8948-4a8b-8254-c51f6adbdfdb	["/scripts/generated/web/004.sh","/scripts/generated/monitoring/003.sh","/scripts/generated/monitoring/002.sh","/scripts/generated/monitoring/001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 13:30:11.482+01	2025-08-06 13:30:11.482+01
9	1	latifnjimoluh@gmail.com	webtes2t	web	LAN	apply	2025-08-06 13:49:13.238+01	2025-08-06 13:51:06.001+01	112.763s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T12-49-13-238Z-1.log	101	192.168.24.99	8cc9e726-5696-4665-a7fc-3db9b56c84f6	["/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 13:51:06.003+01	2025-08-06 13:51:06.003+01
11	1	latifnjimoluh@gmail.com	Webapache	web	LAN	apply	2025-08-06 14:16:15.333+01	2025-08-06 14:19:38.683+01	203.35s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T13-16-15-333Z-1.log	101	192.168.24.202	64072c58-458d-4b76-a264-ad763d3be64c	["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 14:19:38.687+01	2025-08-06 14:19:38.687+01
10	1	latifnjimoluh@gmail.com	we0w2b	web	LAN	destroy	2025-08-06 14:02:25.881+01	2025-08-06 14:05:44.292+01	198.411s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\logs\\deploy-2025-08-06T13-02-25-881Z-1.log	104	192.168.24.201	d45d414b-a18d-4f3a-9a97-c84d8d4417c5	["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-06 14:05:44.296+01	2025-08-11 14:30:33.816+01
13	1	latifnjimoluh@gmail.com	testVM	web	LAN	apply	2025-08-08 13:45:23.974+01	2025-08-08 13:47:25.654+01	121.68s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-2025-08-08T12-45-23-974Z-1.log	103	192.168.24.204	10727005-f0aa-49d9-9d2a-519e7a93770f	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-08 13:47:25.656+01	2025-08-08 13:47:25.656+01
17	1	latifnjimoluh@gmail.com	web-test2	monitoring_cron	LAN	apply	2025-08-12 04:02:24.141+01	2025-08-12 04:02:25.846+01	2s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-3c5c7c1e-50f6-4b90-a6da-15f5ee9cbb39.log	\N	\N	3c5c7c1e-50f6-4b90-a6da-15f5ee9cbb39	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-12 04:02:24.192+01	2025-08-12 04:02:25.847+01
12	1	latifnjimoluh@gmail.com	Webapache	web	LAN	destroy	2025-08-08 13:41:55.026+01	2025-08-08 13:44:36.081+01	161.055s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-2025-08-08T12-41-55-026Z-1.log	101	192.168.24.203	c8f4a86e-ca73-44b8-bfca-edf40641cc99	["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-08 13:44:36.084+01	2025-08-11 14:17:46.623+01
15	1	latifnjimoluh@gmail.com	monitoring	web_server_nginx	LAN	destroy	2025-08-09 19:04:11.8+01	2025-08-09 19:07:31.875+01	200.075s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-2025-08-09T18-04-11-800Z-1.log	103	192.168.24.130	c06d59eb-a650-4427-ba92-05b107a6fd81	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-09 19:07:31.877+01	2025-08-11 14:30:34.052+01
16	1	latifnjimoluh@gmail.com	testweb	web_server_nginx	LAN	apply	2025-08-12 03:17:32.683+01	2025-08-12 03:19:37.224+01	124.541s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-2025-08-12T02-17-32-683Z-1.log	101	192.168.24.206	b588f5d0-0045-403d-ae1c-71dd0135d23f	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	deployed	2025-08-12 03:19:37.226+01	2025-08-12 03:19:37.226+01
18	1	latifnjimoluh@gmail.com	web-test2	web_server_nginx	LAN	apply	2025-08-12 04:08:30.833+01	2025-08-12 04:08:30.909+01	0s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-bdeeb806-8146-404d-aef8-e7fd0a8f5f56.log	\N	\N	bdeeb806-8146-404d-aef8-e7fd0a8f5f56	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-12 04:08:30.895+01	2025-08-12 04:08:30.91+01
19	1	latifnjimoluh@gmail.com	testwebserver2	web_server_nginx	LAN	apply	2025-08-12 04:11:16.41+01	\N	\N	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-aa38c0b4-30a3-45a2-867b-cb11e051c369.log	\N	\N	aa38c0b4-30a3-45a2-867b-cb11e051c369	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	in_progress	2025-08-12 04:11:16.471+01	2025-08-12 04:11:16.471+01
20	1	latifnjimoluh@gmail.com	testweb3	web_server_nginx	LAN	apply	2025-08-12 04:19:52.244+01	2025-08-12 04:22:05.323+01	133s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-12ca649c-5815-4412-97b7-4298b2a83444.log	104	192.168.24.208	12ca649c-5815-4412-97b7-4298b2a83444	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	completed	2025-08-12 04:19:52.297+01	2025-08-12 04:22:05.324+01
21	1	latifnjimoluh@gmail.com	web777	web_server_nginx	LAN	apply	2025-08-12 04:25:56.156+01	\N	\N	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-960b605f-d928-4cdd-b370-1046cf552394.log	\N	\N	960b605f-d928-4cdd-b370-1046cf552394	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	in_progress	2025-08-12 04:25:56.187+01	2025-08-12 04:25:56.187+01
22	1	latifnjimoluh@gmail.com	testweb88	web_server_nginx	LAN	apply	2025-08-12 04:40:47.044+01	2025-08-12 04:44:36.609+01	230s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-0c50c329-4400-49b2-9fdb-077d0523e1cd.log	\N	\N	0c50c329-4400-49b2-9fdb-077d0523e1cd	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-12 04:40:47.095+01	2025-08-12 04:44:36.61+01
23	1	latifnjimoluh@gmail.com	testwebdsfgfd	service_monitoring_script	DMZ	apply	2025-08-12 04:45:06.547+01	2025-08-12 04:45:30.64+01	24s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-d9c6028f-9b25-4d96-a056-be2a0120979b.log	\N	\N	d9c6028f-9b25-4d96-a056-be2a0120979b	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-12 04:45:06.572+01	2025-08-12 04:45:30.64+01
26	1	latifnjimoluh@gmail.com	test monitoring	monitoring__cron	LAN	apply	2025-08-12 05:39:22.455+01	2025-08-12 05:39:45.791+01	23s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-96ed7722-3a83-4528-a610-390fdafc1f89.log	\N	\N	96ed7722-3a83-4528-a610-390fdafc1f89	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-12 05:39:22.481+01	2025-08-12 05:39:45.792+01
27	1	latifnjimoluh@gmail.com	test-web	monitoring__cron	LAN	apply	2025-08-12 05:47:17.126+01	\N	\N	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-964520ce-24f3-4c19-9e0b-b510125c2bfe.log	\N	\N	964520ce-24f3-4c19-9e0b-b510125c2bfe	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	in_progress	2025-08-12 05:47:17.149+01	2025-08-12 05:47:17.149+01
28	1	latifnjimoluh@gmail.com	webser-tts-fgj	monitoring__cron	LAN	apply	2025-08-12 05:49:56.282+01	2025-08-12 05:53:22.233+01	206s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-3b7f7818-5b11-4552-ac40-5b428ddce60e.log	\N	\N	3b7f7818-5b11-4552-ac40-5b428ddce60e	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-12 05:49:56.333+01	2025-08-12 05:53:22.233+01
29	1	latifnjimoluh@gmail.com	ds-a-a-aa-a-a-a-2	monitoring__cron	LAN	apply	2025-08-12 13:09:46.849+01	2025-08-12 13:22:35.824+01	769s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-a6dd007c-ac3d-4504-bfd0-1bc1d93c5d9b.log	\N	\N	a6dd007c-ac3d-4504-bfd0-1bc1d93c5d9b	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"10G"}	failed	2025-08-12 13:09:47.055+01	2025-08-12 13:22:35.824+01
30	1	latifnjimoluh@gmail.com	testweb2	monitoring__cron	LAN	apply	2025-08-12 13:27:58.777+01	2025-08-12 13:42:15.629+01	857s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-7d8ac446-0660-4f98-bb3a-4c5f206477f1.log	\N	\N	7d8ac446-0660-4f98-bb3a-4c5f206477f1	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"10G"}	failed	2025-08-12 13:27:58.945+01	2025-08-12 13:42:15.63+01
31	1	latifnjimoluh@gmail.com	web301	monitoring__cron	WAN	apply	2025-08-12 14:24:47.554+01	2025-08-12 14:35:21.505+01	634s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-ffb7b8c4-0040-47a2-bd2f-7b0809387fef.log	\N	\N	ffb7b8c4-0040-47a2-bd2f-7b0809387fef	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"10G"}	failed	2025-08-12 14:24:47.744+01	2025-08-12 14:35:21.505+01
25	1	latifnjimoluh@gmail.com	testweb20122	monitoring_cron	LAN	destroy	2025-08-12 05:20:35.804+01	2025-08-12 05:22:34.771+01	119s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-13T15-36-53-782Z-1.log	103	\N	793826a0-2600-40a4-bdd8-2fd2209e4df9	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-12 05:20:35.827+01	2025-08-13 16:36:53.872+01
32	1	latifnjimoluh@gmail.com	webytest	monitoring__cron	LAN	apply	2025-08-12 16:35:17.365+01	2025-08-12 16:38:33.343+01	196s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-9a40f8b7-993e-4fcd-b548-2d230a942134.log	\N	\N	9a40f8b7-993e-4fcd-b548-2d230a942134	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"18G"}	failed	2025-08-12 16:35:17.572+01	2025-08-12 16:38:33.344+01
33	1	latifnjimoluh@gmail.com	test23-4	monitoring__cron	LAN	apply	2025-08-12 16:54:08.689+01	2025-08-12 16:57:24.103+01	195s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-cd0af94f-89dd-42ab-adf4-e109d1e9aadf.log	\N	\N	cd0af94f-89dd-42ab-adf4-e109d1e9aadf	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"13G"}	failed	2025-08-12 16:54:08.897+01	2025-08-12 16:57:24.103+01
34	1	latifnjimoluh@gmail.com	web55	monitoring__cron	WAN	apply	2025-08-13 05:50:39.406+01	2025-08-13 05:53:58.341+01	199s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-0a6bff8f-f323-429f-96e2-0da84a83ea8c.log	\N	\N	0a6bff8f-f323-429f-96e2-0da84a83ea8c	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"18G"}	failed	2025-08-13 05:50:39.58+01	2025-08-13 05:53:58.342+01
35	1	latifnjimoluh@gmail.com	testwebserver	monitoring__cron	LAN	apply	2025-08-13 06:40:45.86+01	2025-08-13 06:42:01.351+01	75s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-f747abb8-455d-4e09-b8e9-6b7086425d58.log	\N	\N	f747abb8-455d-4e09-b8e9-6b7086425d58	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-13 06:40:46.066+01	2025-08-13 06:42:01.352+01
36	1	latifnjimoluh@gmail.com	test-cron	monitoring__cron	MGMT	apply	2025-08-13 07:05:44.41+01	2025-08-13 07:09:27.683+01	223s	f	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-c2a6999e-7021-4688-844a-4d1d753ddebd.log	\N	\N	c2a6999e-7021-4688-844a-4d1d753ddebd	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	failed	2025-08-13 07:05:44.59+01	2025-08-13 07:09:27.683+01
39	1	latifnjimoluh@gmail.com	testweb	monitoring__cron	WAN	apply	2025-08-13 16:37:53.701+01	2025-08-13 16:40:18.872+01	145s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-54426125-bc6f-4cce-87d2-4dcfa3d6bcf6.log	101	192.168.24.213	54426125-bc6f-4cce-87d2-4dcfa3d6bcf6	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-13 16:37:54.16+01	2025-08-13 16:40:18.873+01
24	1	latifnjimoluh@gmail.com	testwebserver	monitoring_cron	LAN	destroy	2025-08-12 04:52:49.611+01	2025-08-12 04:54:43.848+01	114s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-88966679-e8a2-4c48-b948-75ca879e7343.log	101	192.168.24.209	88966679-e8a2-4c48-b948-75ca879e7343	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	completed	2025-08-12 04:52:49.65+01	2025-08-13 07:51:21.653+01
37	1	latifnjimoluh@gmail.com	dsfgdggd	monitoring__cron	LAN	destroy	2025-08-13 07:34:32.546+01	2025-08-13 07:36:36.684+01	124s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-13T15-36-45-402Z-1.log	102	\N	f737e3a0-19c9-4530-8526-59d196247813	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-13 07:34:32.738+01	2025-08-13 16:36:45.493+01
38	1	latifnjimoluh@gmail.com	web-test	monitoring__cron	MGMT	destroy	2025-08-13 12:55:35.687+01	2025-08-13 12:58:09.196+01	154s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\delete-2025-08-13T15-36-59-781Z-1.log	101	192.168.24.212	542e8abc-c806-4507-862e-2e171e45784a	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-13 12:55:36.109+01	2025-08-13 16:37:02.144+01
41	1	latifnjimoluh@gmail.com	testweb	monitoring__cron	DMZ	apply	2025-08-14 02:03:44.402+01	2025-08-14 02:05:11.62+01	87s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-2304dfa2-c3e9-4e45-b2b0-25ea2d67c5e0.log	101	192.168.24.213	2304dfa2-c3e9-4e45-b2b0-25ea2d67c5e0	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-14 02:03:44.597+01	2025-08-14 02:05:11.621+01
40	1	latifnjimoluh@gmail.com	testwebserver	monitoring__cron	LAN	apply	2025-08-13 17:06:57.78+01	2025-08-13 17:12:21.229+01	323s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-a8e8f5d1-e3ac-4daf-ae4d-496c0260f6f7.log	102	192.168.24.214	a8e8f5d1-e3ac-4daf-ae4d-496c0260f6f7	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-13 17:06:57.989+01	2025-08-13 17:12:21.229+01
42	1	latifnjimoluh@gmail.com	testweb-ngnix	Web_Ngnix	LAN	apply	2025-08-14 02:12:28.995+01	2025-08-14 02:15:35.866+01	187s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-7acce2a5-2193-4978-8a29-f60bbd7d5058.log	103	192.168.24.215	7acce2a5-2193-4978-8a29-f60bbd7d5058	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/Web_Ngnix_web_Serveur_Web_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-14 02:12:29.204+01	2025-08-14 02:15:35.867+01
43	1	latifnjimoluh@gmail.com	test-yoads	Web_Ngnix	LAN	apply	2025-08-14 03:43:07.368+01	\N	\N	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-8bc75727-451f-46d0-9ee9-048eae5c0394.log	\N	\N	8bc75727-451f-46d0-9ee9-048eae5c0394	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/Web_Ngnix_web_Serveur_Web_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	running	2025-08-14 03:43:07.563+01	2025-08-14 03:43:07.673+01
44	1	latifnjimoluh@gmail.com	testwebngnix	web_server_nginx_autoip	LAN	apply	2025-08-14 12:35:27.483+01	2025-08-14 12:39:10.131+01	223s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-cf8d9d32-1af0-472c-9800-8a74d4290c59.log	105	192.168.24.216	cf8d9d32-1af0-472c-9800-8a74d4290c59	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_setup_monitoring_Monitoring_setup_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script001.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-14 12:35:27.719+01	2025-08-14 12:39:10.131+01
46	1	latifnjimoluh@gmail.com	xertfyh	web_server_apache_autoip	WAN	apply	2025-08-14 13:59:50.926+01	2025-08-14 14:03:12.262+01	201s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-21a2a595-3add-401a-bc2a-4be46546b56b.log	107	192.168.24.218	21a2a595-3add-401a-bc2a-4be46546b56b	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_setup_monitoring_Monitoring_setup_script003.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_apache_autoip_web_Web_Server_Apache_auto_IP_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-14 13:59:51.15+01	2025-08-14 14:03:12.263+01
45	1	latifnjimoluh@gmail.com	ngnix	web_server_nginx_autoip	LAN	apply	2025-08-14 13:54:04.593+01	2025-08-14 13:58:40.741+01	276s	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-43be83b9-c408-4dc7-b538-ca23dd4908cf.log	106	192.168.24.217	43be83b9-c408-4dc7-b538-ca23dd4908cf	["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_setup_monitoring_Monitoring_setup_script003.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script002.sh"]	{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}	success	2025-08-14 13:54:04.833+01	2025-08-14 13:58:40.742+01
\.


--
-- Data for Name: generated_scripts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.generated_scripts (id, template_id, category, service_type, script_path, description, created_at, updated_at, abs_path, status) FROM stdin;
33	28	web	Web_Ngnix	/scripts/generated/web/Web_Ngnix_web_Serveur_Web_script002.sh		2025-08-14 03:38:10.316+01	2025-08-14 12:26:06.069+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\web\\Web_Ngnix_web_Serveur_Web_script002.sh	supprime
34	29	monitoring	monitoring_setup	/scripts/generated/monitoring/monitoring_setup_monitoring_Monitoring_setup_script001.sh	Installe les scripts de monitoring (statut système, services, logs) et les planifie via cron.	2025-08-14 12:13:04.806+01	2025-08-14 12:26:09.919+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\monitoring\\monitoring_setup_monitoring_Monitoring_setup_script001.sh	supprime
29	25	monitoring	monitoring__cron	/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh	Installe un cron job minuteur qui attend la présence des scripts de monitoring, les exécute, crée leurs crons définitifs puis se désinstalle.	2025-08-12 05:37:40.624+01	2025-08-14 12:26:31.722+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\monitoring\\monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh	supprime
30	26	monitoring	system_monitoring_script	/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh	Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh	2025-08-12 05:37:54.864+01	2025-08-14 12:26:37.648+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\monitoring\\system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh	supprime
31	27	monitoring	service_monitoring_script	/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh	Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh	2025-08-12 05:38:00.056+01	2025-08-14 12:26:38.738+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\monitoring\\service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh	supprime
32	28	web	Web_Ngnix	/scripts/generated/web/Web_Ngnix_web_Serveur_Web_script001.sh	Installe NGINX, déploie un site web de test sur la VM web camer.cm et configure UFW.	2025-08-14 02:10:32.302+01	2025-08-14 12:26:40.411+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\web\\Web_Ngnix_web_Serveur_Web_script001.sh	supprime
35	29	monitoring	monitoring_setup	/scripts/generated/monitoring/monitoring_setup_monitoring_Monitoring_setup_script002.sh	Installe les scripts de monitoring (statut système, services, logs) et les planifie via cron.	2025-08-14 12:27:47.181+01	2025-08-14 13:27:38.554+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\monitoring\\monitoring_setup_monitoring_Monitoring_setup_script002.sh	supprime
37	31	web	web_server_apache_autoip	/scripts/generated/web/web_server_apache_autoip_web_Web_Server_Apache_auto_IP_script001.sh	Installe Apache et injecte automatiquement l’IP de la VM dans la page d’accueil.	2025-08-14 12:33:19.163+01	2025-08-14 13:27:40.243+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\web\\web_server_apache_autoip_web_Web_Server_Apache_auto_IP_script001.sh	supprime
36	30	web	web_server_nginx_autoip	/scripts/generated/web/web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script001.sh	Installe NGINX et injecte automatiquement l’IP de la VM dans la page d’accueil.	2025-08-14 12:32:34.148+01	2025-08-14 13:27:41.96+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\web\\web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script001.sh	supprime
38	34	monitoring	monitoring_setup	/scripts/generated/monitoring/monitoring_setup_monitoring_Monitoring_setup_script003.sh	Génère les scripts de statut système, services et logs importants et les planifie via cron.	2025-08-14 13:42:47.751+01	2025-08-14 13:42:47.751+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\monitoring\\monitoring_setup_monitoring_Monitoring_setup_script003.sh	actif
39	35	web	web_server_apache_autoip	/scripts/generated/web/web_server_apache_autoip_web_Web_Server_Apache_auto_IP_script002.sh	Installe Apache et injecte automatiquement l’IP de la VM dans la page d’accueil.	2025-08-14 13:47:02.578+01	2025-08-14 13:47:02.578+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\web\\web_server_apache_autoip_web_Web_Server_Apache_auto_IP_script002.sh	actif
40	36	web	web_server_nginx_autoip	/scripts/generated/web/web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script002.sh	Installe NGINX et injecte automatiquement l’IP de la VM dans la page d’accueil.	2025-08-14 13:49:47.531+01	2025-08-14 13:49:47.531+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\generated\\web\\web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script002.sh	actif
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, user_id, action, details, created_at, host, level, source) FROM stdin;
1	1	login	User logged in	2025-08-06 04:39:32.335271+01	\N	\N	\N
2	\N	POST /auth/request-reset	{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}	2025-08-06 04:40:00.778+01	\N	\N	\N
3	1	request_reset_code	{"user_id":1}	2025-08-06 04:40:05.894+01	\N	\N	\N
4	\N	POST /auth/reset-password	{"body":{"code":"803327","password":"admin123."},"query":{}}	2025-08-06 04:41:00.176+01	\N	\N	\N
5	1	reset_password	{"user_id":1}	2025-08-06 04:41:00.381+01	\N	\N	\N
6	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 04:41:20.772+01	\N	\N	\N
7	1	login	{"user_id":1}	2025-08-06 04:41:20.984+01	\N	\N	\N
8	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:42:51.187+01	\N	\N	\N
9	1	PUT /settings/me	{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"mytoken","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/tmp/status.json","servicespath":"/tmp/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}	2025-08-06 04:43:25.502+01	\N	\N	\N
10	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:43:31.871+01	\N	\N	\N
11	1	PUT /settings/me	{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"delete","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/tmp/status.json","servicespath":"/tmp/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}	2025-08-06 04:43:50.307+01	\N	\N	\N
12	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:43:53.736+01	\N	\N	\N
13	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:44:07.91+01	\N	\N	\N
14	1	GET /auth/reset-history	{"query":{}}	2025-08-06 04:44:41.003+01	\N	\N	\N
15	1	view_reset_history	{}	2025-08-06 04:44:41.015+01	\N	\N	\N
16	1	GET /roles	{"query":{}}	2025-08-06 04:44:58.142+01	\N	\N	\N
17	1	GET /roles/1	{"query":{}}	2025-08-06 04:45:04.94+01	\N	\N	\N
18	1	POST /permissions	{"body":{"name":"test","description":"test posts"},"query":{}}	2025-08-06 04:45:33.666+01	\N	\N	\N
19	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}	2025-08-06 04:45:50.077+01	\N	\N	\N
20	1	GET /permissions/role/1	{"query":{}}	2025-08-06 04:46:00.952+01	\N	\N	\N
21	1	POST /permissions/unassign	{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}	2025-08-06 04:46:16.479+01	\N	\N	\N
22	1	POST /permissions/unassign	{"body":[{"role_id":1,"permission_ids":44}],"query":{}}	2025-08-06 04:46:51.809+01	\N	\N	\N
23	1	DELETE /permissions/44	{"query":{}}	2025-08-06 04:47:55.707+01	\N	\N	\N
24	1	GET /logs	{"query":{}}	2025-08-06 04:48:09.209+01	\N	\N	\N
25	1	GET /settings/me	{"query":{}}	2025-08-06 04:48:24.116+01	\N	\N	\N
26	1	GET /vms	{"query":{}}	2025-08-06 04:48:30.921+01	\N	\N	\N
27	1	list_vms	{}	2025-08-06 04:48:30.945+01	\N	\N	\N
28	1	POST /vms/check-status	{"body":{"vm_id":104},"query":{}}	2025-08-06 04:50:00.417+01	\N	\N	\N
29	1	POST /vms/check-status	{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}	2025-08-06 04:50:36.826+01	\N	\N	\N
30	1	check_vm_status	{"vm_id":104,"vm_status":"running","ping_ok":true}	2025-08-06 04:50:36.948+01	\N	\N	\N
31	1	POST /vms/104/stop	{"query":{}}	2025-08-06 04:51:02.049+01	\N	\N	\N
32	1	stop_vm:104	{}	2025-08-06 04:51:02.099+01	\N	\N	\N
33	1	POST /vms/check-status	{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}	2025-08-06 04:51:16.897+01	\N	\N	\N
34	1	check_vm_status	{"vm_id":104,"vm_status":"stopped","ping_ok":false}	2025-08-06 04:51:21.552+01	\N	\N	\N
35	1	POST /vms/104/start	{"query":{}}	2025-08-06 04:51:34.177+01	\N	\N	\N
36	1	start_vm:104	{}	2025-08-06 04:51:34.234+01	\N	\N	\N
37	1	POST /vms/check-status	{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}	2025-08-06 04:51:37.87+01	\N	\N	\N
38	1	check_vm_status	{"vm_id":104,"vm_status":"running","ping_ok":false}	2025-08-06 04:51:40.548+01	\N	\N	\N
39	1	GET /templates	{"query":{}}	2025-08-06 04:51:52.614+01	\N	\N	\N
40	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 04:59:51.934+01	\N	\N	\N
41	1	Échec Déploiement Terraform	{}	2025-08-06 05:00:13.147+01	\N	\N	\N
42	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:02:33.657+01	\N	\N	\N
43	1	POST /permissions/unassign	{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}	2025-08-06 05:10:04.108+01	\N	\N	\N
44	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:26:19.154+01	\N	\N	\N
45	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:26:28.221+01	\N	\N	\N
46	1	POST /vms/convert	{"body":{"vm_id":104},"query":{}}	2025-08-06 05:26:44.785+01	\N	\N	\N
47	1	Échec Déploiement Terraform	{}	2025-08-06 05:26:49.252+01	\N	\N	\N
48	1	convert_vm_template	{"vm_id":104}	2025-08-06 05:27:07.192+01	\N	\N	\N
49	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:34:10.707+01	\N	\N	\N
50	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:34:15.734+01	\N	\N	\N
51	1	Échec Déploiement Terraform	{}	2025-08-06 05:34:27.3+01	\N	\N	\N
52	1	Échec Déploiement Terraform	{}	2025-08-06 05:34:35.77+01	\N	\N	\N
53	1	Échec Déploiement Terraform	{}	2025-08-06 05:36:34.655+01	\N	\N	\N
54	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 05:43:26.289+01	\N	\N	\N
55	1	login	{"user_id":1}	2025-08-06 05:43:26.497+01	\N	\N	\N
56	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:52:43.634+01	\N	\N	\N
57	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:52:47.77+01	\N	\N	\N
58	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 05:52:52.116+01	\N	\N	\N
59	1	Échec Déploiement Terraform	{}	2025-08-06 05:53:04.254+01	\N	\N	\N
60	1	Échec Déploiement Terraform	{}	2025-08-06 05:53:09.288+01	\N	\N	\N
61	1	Échec Déploiement Terraform	{}	2025-08-06 05:53:15.962+01	\N	\N	\N
62	1	Échec Déploiement Terraform	{}	2025-08-06 06:10:43.953+01	\N	\N	\N
63	1	Échec Déploiement Terraform	{}	2025-08-06 06:11:02.051+01	\N	\N	\N
64	1	Échec Déploiement Terraform	{"error":"initCmd is not defined"}	2025-08-06 06:11:27.723+01	\N	\N	\N
65	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 06:11:44.41+01	\N	\N	\N
66	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 06:11:51.965+01	\N	\N	\N
67	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 09:52:25.362+01	\N	\N	\N
68	1	login	{"user_id":1}	2025-08-06 09:52:25.737+01	\N	\N	\N
69	1	Échec Déploiement Terraform	{}	2025-08-06 09:53:08.949+01	\N	\N	\N
70	1	Échec Déploiement Terraform	{}	2025-08-06 09:56:53.324+01	\N	\N	\N
71	1	Déploiement Terraform	{"vm_name":"tes2023","service_type":"web","success":true}	2025-08-06 10:01:27.107+01	\N	\N	\N
72	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 11:03:19.433+01	\N	\N	\N
73	1	login	{"user_id":1}	2025-08-06 11:03:19.669+01	\N	\N	\N
74	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 11:21:11.799+01	\N	\N	\N
75	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 11:21:16.586+01	\N	\N	\N
76	1	Déploiement Terraform	{"vm_name":"yedb","service_type":"web","success":true}	2025-08-06 12:10:16.223+01	\N	\N	\N
77	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:12:42.896+01	\N	\N	\N
78	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:12:50.365+01	\N	\N	\N
79	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:12:54.986+01	\N	\N	\N
80	1	Échec Déploiement Terraform	{}	2025-08-06 12:13:11.409+01	\N	\N	\N
81	1	PUT /settings/me	{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"delete","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/opt/monitoring/status.json","servicespath":"/opt/monitoring/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}	2025-08-06 12:17:39.926+01	\N	\N	\N
82	1	Déploiement Terraform	{"vm_name":"test1","service_type":"web","success":true}	2025-08-06 12:19:19.232+01	\N	\N	\N
83	1	Déploiement Terraform	{"vm_name":"web1","service_type":"web","success":true}	2025-08-06 12:26:23.919+01	\N	\N	\N
84	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:31:47.053+01	\N	\N	\N
85	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 12:31:51.41+01	\N	\N	\N
86	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute les tâches planifiées pour exécuter les scripts de surveillance système et services toutes les 5 minutes.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"/opt/monitoring/status.sh\\"\\nSERVICES_SCRIPT=\\"/opt/monitoring/services_status.sh\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/5 * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/5 * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[]}},"query":{}}	2025-08-06 12:34:12.22+01	\N	\N	\N
87	1	create_template:2	{}	2025-08-06 12:34:12.256+01	\N	\N	\N
88	1	Déploiement Terraform	{"vm_name":"web12","service_type":"web","success":true}	2025-08-06 12:35:01.288+01	\N	\N	\N
89	1	POST /templates/generate	{"body":{"template_id":2,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 12:37:17.191+01	\N	\N	\N
90	1	generate_template:2	{}	2025-08-06 12:37:17.206+01	\N	\N	\N
91	1	PUT /templates/2	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 12:42:51.517+01	\N	\N	\N
92	1	update_template:2	{}	2025-08-06 12:42:51.563+01	\N	\N	\N
93	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 12:49:24.336+01	\N	\N	\N
94	1	create_template:3	{}	2025-08-06 12:49:24.388+01	\N	\N	\N
130	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:35:09.553+01	\N	\N	\N
95	1	POST /templates/generate	{"body":{"template_id":3,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 12:50:16.472+01	\N	\N	\N
96	1	generate_template_file:3:Activation_des_cronjobs_de_supervision_2025-08-06T11-50-16-492Z.sh	{}	2025-08-06 12:50:16.495+01	\N	\N	\N
97	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:08:22.441+01	\N	\N	\N
98	1	create_template:4	{}	2025-08-06 13:08:22.487+01	\N	\N	\N
99	1	POST /templates/generate	{"body":{"template_id":4,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:08:32.157+01	\N	\N	\N
100	1	generate_template_file:4:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervisionscript001.sh	{}	2025-08-06 13:08:32.187+01	\N	\N	\N
101	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:10:52.966+01	\N	\N	\N
102	1	create_template:5	{}	2025-08-06 13:10:53.01+01	\N	\N	\N
103	1	POST /templates/generate	{"body":{"template_id":5,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:11:03.204+01	\N	\N	\N
104	1	generate_template_file:5:Activation_des_cronjobs_de_supervisionscript001.sh	{}	2025-08-06 13:11:03.232+01	\N	\N	\N
105	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:15:14.931+01	\N	\N	\N
106	1	create_template:6	{}	2025-08-06 13:15:14.976+01	\N	\N	\N
107	1	POST /templates/generate	{"body":{"template_id":5,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:15:20.043+01	\N	\N	\N
108	1	generate_template_file:5:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	{}	2025-08-06 13:15:20.074+01	\N	\N	\N
131	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:35:40.771+01	\N	\N	\N
132	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:37:28.738+01	\N	\N	\N
133	1	create_template:11	{}	2025-08-06 13:37:28.839+01	\N	\N	\N
134	1	POST /templates/generate	{"body":{"template_id":11,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 13:37:37.614+01	\N	\N	\N
135	1	generate_template_file:11:flask_api_api_D_ploiement_de_l_API_interne_Flask__api_camer_cm__script002.sh	{}	2025-08-06 13:37:37.637+01	\N	\N	\N
136	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:38:35.52+01	\N	\N	\N
137	1	create_template:12	{}	2025-08-06 13:38:35.612+01	\N	\N	\N
189	1	POST /templates/generate	{"body":{"template_id":20,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}	2025-08-06 14:14:28.568+01	\N	\N	\N
109	1	POST /templates	{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance système\\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\n\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\n\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\n\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\n\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s},\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > ${STATUS_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${STATUS_SCRIPT_PATH}","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}	2025-08-06 13:18:17.291+01	\N	\N	\N
110	1	create_template:7	{}	2025-08-06 13:18:17.351+01	\N	\N	\N
111	1	POST /templates/generate	{"body":{"template_id":7,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}	2025-08-06 13:18:45.73+01	\N	\N	\N
112	1	generate_template_file:7:system_monitoring_script_monitoring_Surveillance_syst_me_-_G_n_ration_du_script_script001.sh	{}	2025-08-06 13:18:45.757+01	\N	\N	\N
113	1	POST /templates	{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}	2025-08-06 13:19:40.204+01	\N	\N	\N
114	1	create_template:8	{}	2025-08-06 13:19:40.26+01	\N	\N	\N
115	1	POST /templates/generate	{"body":{"template_id":8,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}	2025-08-06 13:20:09.364+01	\N	\N	\N
116	1	generate_template_file:8:service_monitoring_script_monitoring_Surveillance_des_services_-_G_n_ration_du_script_script001.sh	{}	2025-08-06 13:20:09.384+01	\N	\N	\N
117	1	POST /templates	{"body":{"name":"Déploiement du serveur Web Camer-Web (web2.camer.cm)","service_type":"web_server_nginx","category":"web","description":"Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.","template_content":"#!/bin/bash\\nset -e\\n\\necho \\"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\\"\\n\\n# 1. Installation des paquets\\necho \\"📦 Installation de nginx et apache2 (optionnel)...\\"\\nsudo apt update\\nsudo apt install curl -y\\nsudo apt install nginx apache2 -y\\n\\n# 2. Préparation du répertoire web\\necho \\"📁 Création du site web ${WEB_ROOT}\\"\\nsudo mkdir -p ${WEB_ROOT}\\n\\necho \\"📝 Création de la page d’accueil personnalisée...\\"\\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\\n<!DOCTYPE html>\\n<html lang=\\\\\\"fr\\\\\\">\\n<head>\\n    <meta charset=\\\\\\"UTF-8\\\\\\">\\n    <title>Camer-Web</title>\\n</head>\\n<body style=\\\\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\\\\">\\n    <h1>✅ Bienvenue sur Camer-Web</h1>\\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nEOF\\n\\n# 3. Création du fichier NGINX vhost\\necho \\"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\\"\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\\nserver {\\n    listen 80;\\n    server_name ${DOMAIN_NAME};\\n\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\n\\n    root ${WEB_ROOT};\\n    index index.html;\\n\\n    location / {\\n        try_files \\\\$uri \\\\$uri/ =404;\\n    }\\n}\\nEOF\\n\\n# 4. Activation du site et désactivation du défaut\\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\\nsudo rm -f /etc/nginx/sites-enabled/default\\n\\n# 5. Redémarrage des services\\necho \\"🚀 Redémarrage de NGINX...\\"\\nsudo systemctl restart nginx\\nsudo systemctl enable nginx\\n\\n# 6. Pare-feu\\necho \\"🛡️ Configuration UFW pour NGINX...\\"\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\necho\\necho \\"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\\"\\n\\n: \\"\\\\${INSTANCE_ID:?INSTANCE_ID is required}\\"\\n\\n# Save instance identifier\\necho \\"INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\nexport INSTANCE_ID=\\\\${INSTANCE_ID}\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: \\\\${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log","script_path":"/scripts/deploy_web2.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web2.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.20.21"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"Camer-Web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}},"query":{}}	2025-08-06 13:20:32.527+01	\N	\N	\N
118	1	create_template:9	{}	2025-08-06 13:20:32.594+01	\N	\N	\N
119	1	POST /templates/generate	{"body":{"template_id":9,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}	2025-08-06 13:20:43.435+01	\N	\N	\N
120	1	generate_template_file:9:web_server_nginx_web_D_ploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	{}	2025-08-06 13:20:43.46+01	\N	\N	\N
121	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:23:12.691+01	\N	\N	\N
122	1	create_template:10	{}	2025-08-06 13:23:12.766+01	\N	\N	\N
123	1	POST /templates/generate	{"body":{"template_id":10,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 13:23:29.346+01	\N	\N	\N
124	1	generate_template_file:10:flask_api_api_D_ploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	{}	2025-08-06 13:23:29.369+01	\N	\N	\N
125	1	Déploiement Terraform	{"vm_name":"webtest","service_type":"web","success":true}	2025-08-06 13:25:42.947+01	\N	\N	\N
126	1	Déploiement Terraform	{"vm_name":"webtes2t","service_type":"web","success":true}	2025-08-06 13:30:11.554+01	\N	\N	\N
127	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:34:36.59+01	\N	\N	\N
128	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:34:43.994+01	\N	\N	\N
129	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:34:48.079+01	\N	\N	\N
138	1	POST /templates	{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\\n\\necho \\"📦 Installation du serveur NFS...\\"\\nsudo apt update && sudo apt install -y nfs-kernel-server\\n\\necho \\"📁 Création du dossier partagé ${SHARE_DIR}...\\"\\nsudo mkdir -p ${SHARE_DIR}\\nsudo chown nobody:nogroup ${SHARE_DIR}\\nsudo chmod 777 ${SHARE_DIR}\\n\\necho \\"📝 Configuration du fichier /etc/exports...\\"\\necho \\"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\\" | sudo tee -a /etc/exports\\n\\necho \\"🔄 Redémarrage du service NFS...\\"\\nsudo systemctl restart nfs-kernel-server\\n\\necho \\"🔍 Vérification de l’export actif...\\"\\nsudo exportfs -v\\n\\necho \\"✅ Serveur NFS configuré avec succès.\\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.10.0/24"}]}},"query":{}}	2025-08-06 13:44:18.132+01	\N	\N	\N
139	1	create_template:13	{}	2025-08-06 13:44:18.176+01	\N	\N	\N
140	1	PUT /templates/2	{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\\n\\necho \\"📦 Installation du serveur NFS...\\"\\nsudo apt update && sudo apt install -y nfs-kernel-server\\n\\necho \\"📁 Création du dossier partagé ${SHARE_DIR}...\\"\\nsudo mkdir -p ${SHARE_DIR}\\nsudo chown nobody:nogroup ${SHARE_DIR}\\nsudo chmod 777 ${SHARE_DIR}\\n\\necho \\"📝 Configuration du fichier /etc/exports...\\"\\necho \\"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\\" | sudo tee -a /etc/exports\\n\\necho \\"🔄 Redémarrage du service NFS...\\"\\nsudo systemctl restart nfs-kernel-server\\n\\necho \\"🔍 Vérification de l’export actif...\\"\\nsudo exportfs -v\\n\\necho \\"✅ Serveur NFS configuré avec succès.\\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.24.0/24"}]}},"query":{}}	2025-08-06 13:44:32.062+01	\N	\N	\N
141	1	PUT /templates/13	{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\\n\\necho \\"📦 Installation du serveur NFS...\\"\\nsudo apt update && sudo apt install -y nfs-kernel-server\\n\\necho \\"📁 Création du dossier partagé ${SHARE_DIR}...\\"\\nsudo mkdir -p ${SHARE_DIR}\\nsudo chown nobody:nogroup ${SHARE_DIR}\\nsudo chmod 777 ${SHARE_DIR}\\n\\necho \\"📝 Configuration du fichier /etc/exports...\\"\\necho \\"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\\" | sudo tee -a /etc/exports\\n\\necho \\"🔄 Redémarrage du service NFS...\\"\\nsudo systemctl restart nfs-kernel-server\\n\\necho \\"🔍 Vérification de l’export actif...\\"\\nsudo exportfs -v\\n\\necho \\"✅ Serveur NFS configuré avec succès.\\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.24.0/24"}]}},"query":{}}	2025-08-06 13:44:38.468+01	\N	\N	\N
142	1	update_template:13	{}	2025-08-06 13:44:38.499+01	\N	\N	\N
143	1	POST /templates	{"body":{"name":"Configuration du client NFS","service_type":"nfs_client","category":"file_sharing","description":"Installe le client NFS et monte un partage distant automatiquement.","template_content":"#!/bin/bash\\n# 🎯 Script de configuration client NFS pour montage du dossier partagé\\n\\necho \\"📦 Installation du client NFS...\\"\\nsudo apt update && sudo apt install -y nfs-common\\n\\necho \\"📁 Création du dossier local ${MOUNT_DIR}...\\"\\nsudo mkdir -p ${MOUNT_DIR}\\n\\necho \\"🔗 Montage du partage NFS depuis ${NFS_SERVER}:${SHARE_DIR}\\"\\nsudo mount ${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR}\\n\\necho \\"🔒 Optionnel : ajout dans /etc/fstab pour montage permanent...\\"\\necho \\"${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR} nfs defaults 0 0\\" | sudo tee -a /etc/fstab\\n\\necho \\"✅ Client NFS configuré et monté.\\"","script_path":"/scripts/nfs_client_setup.sh","fields_schema":{"fields":[{"name":"NFS_SERVER","label":"Adresse IP du serveur NFS","type":"text","required":true,"default":"192.168.10.10"},{"name":"SHARE_DIR","label":"Répertoire exporté par le serveur","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"MOUNT_DIR","label":"Point de montage local","type":"text","required":true,"default":"/mnt/nfs_share"}]}},"query":{}}	2025-08-06 13:44:51.872+01	\N	\N	\N
144	1	create_template:14	{}	2025-08-06 13:44:51.903+01	\N	\N	\N
145	1	POST /templates/generate	{"body":{"template_id":14,"config_data":{"NFS_SERVER":"192.168.10.10","SHARE_DIR":"/srv/nfs_share","MOUNT_DIR":"/mnt/nfs_share"}},"query":{}}	2025-08-06 13:45:14.582+01	\N	\N	\N
146	1	generate_template_file:14:nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh	{}	2025-08-06 13:45:14.607+01	\N	\N	\N
147	1	POST /templates/generate	{"body":{"template_id":13,"config_data":{"SHARE_DIR":"/srv/nfs_share","CLIENT_SUBNET":"192.168.10.0/24"}},"query":{}}	2025-08-06 13:45:30.711+01	\N	\N	\N
148	1	generate_template_file:13:nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh	{}	2025-08-06 13:45:30.738+01	\N	\N	\N
149	1	POST /templates	{"body":{"name":"Configuration DNS Esclave avec BIND9 (dns2)","service_type":"dns_slave","category":"dns","description":"Installe et configure un serveur DNS esclave avec BIND9, prêt à recevoir les zones depuis le DNS maître.","template_content":"#!/bin/bash\\n\\necho \\"📦 Installation de BIND9 sur le DNS slave...\\"\\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\\nsudo apt install curl -y\\n\\necho \\"👤 Ajout de l'utilisateur courant au groupe bind...\\"\\nsudo usermod -aG bind \\"$USER\\"\\n\\necho \\"🔄 Activation du nouveau groupe pour cette session...\\"\\nnewgrp bind <<EONG\\n\\necho \\"📁 Vérification du répertoire de cache BIND...\\"\\nsudo mkdir -p /var/cache/bind\\nsudo chown bind:bind /var/cache/bind\\nsudo chmod 770 /var/cache/bind\\n\\necho \\"⚙️ Configuration des options globales dans /etc/bind/named.conf.options...\\"\\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\\noptions {\\n    directory \\"/var/cache/bind\\";\\n\\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\\n    recursion no;\\n\\n    dnssec-validation auto;\\n\\n    listen-on { 127.0.0.1; ${SLAVE_IP}; };\\n    listen-on-v6 { none; };\\n};\\nEOF\\n\\necho \\"📌 Configuration des zones esclaves dans /etc/bind/named.conf.local...\\"\\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\\n${ZONE_CONFIGS}\\nEOF\\n\\necho \\"🔓 Autorisation du trafic DNS depuis le maître (si UFW est actif)...\\"\\nsudo ufw allow from ${MASTER_IP} to any port 53 proto udp\\nsudo ufw allow from ${MASTER_IP} to any port 53 proto tcp\\n\\necho \\"🚀 Redémarrage de BIND9...\\"\\nsudo systemctl restart bind9\\nsudo systemctl enable bind9\\n\\necho \\"✅ Configuration terminée. Le slave attend les transferts du maître.\\"\\n\\nEONG","script_path":"/scripts/dns_slave_setup.sh","fields_schema":{"fields":[{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"MASTER_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones esclaves (bloc brut)","type":"textarea","required":true,"default":"zone \\"camer.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.camer.cm\\";\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.bunec.cm\\";\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.etatcivil.cm\\";\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.civilstatus.cm\\";\\n};"}]}},"query":{}}	2025-08-06 13:45:42.973+01	\N	\N	\N
150	1	create_template:15	{}	2025-08-06 13:45:43.023+01	\N	\N	\N
184	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script002.sh	{}	2025-08-06 14:09:09.578+01	\N	\N	\N
190	1	generate_template_file:20:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh	{}	2025-08-06 14:14:28.603+01	\N	\N	\N
151	1	POST /templates/generate	{"body":{"template_id":15,"config_data":{"SLAVE_IP":"192.168.20.20","MASTER_IP":"192.168.20.10","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.camer.cm\\";\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.bunec.cm\\";\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.etatcivil.cm\\";\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.civilstatus.cm\\";\\n};"}},"query":{}}	2025-08-06 13:45:52.896+01	\N	\N	\N
152	1	generate_template_file:15:dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh	{}	2025-08-06 13:45:52.93+01	\N	\N	\N
153	1	POST /templates	{"body":{"name":"Configuration DNS Maître avec BIND9 (dns1)","service_type":"dns_master","category":"dns","description":"Installe et configure un serveur DNS maître avec BIND9, en définissant plusieurs zones et en autorisant le transfert vers le serveur esclave.","template_content":"#!/bin/bash\\n# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})\\n\\necho \\"📦 Installation de BIND9...\\"\\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\\nsudo apt install curl -y\\n\\necho \\"📁 Création du répertoire des zones...\\"\\nsudo mkdir -p /etc/bind/zones\\nsudo chown bind:bind /etc/bind/zones\\n\\necho \\"🔧 Configuration des options globales dans /etc/bind/named.conf.options...\\"\\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\\noptions {\\n    directory \\"/var/cache/bind\\";\\n\\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\\n    recursion no;\\n\\n    allow-transfer { ${SLAVE_IP}; };\\n    dnssec-validation auto;\\n\\n    listen-on { 127.0.0.1; ${DNS_IP}; };\\n    listen-on-v6 { none; };\\n};\\nEOF\\n\\necho \\"📌 Définition des zones dans /etc/bind/named.conf.local...\\"\\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\\n${ZONE_CONFIGS}\\nEOF\\n\\necho \\"🔓 Autorisation du trafic DNS depuis le slave...\\"\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto udp\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp\\n\\necho \\"🚀 Redémarrage du service BIND9...\\"\\nsudo systemctl restart bind9\\nsudo systemctl enable bind9\\n\\necho \\"✅ Configuration du DNS Maître terminée.\\"","script_path":"/scripts/dns_master_setup.sh","fields_schema":{"fields":[{"name":"DNS_HOSTNAME","label":"Nom du serveur DNS maître","type":"text","required":true,"default":"dns1.camer.cm"},{"name":"OS_VERSION","label":"Version du système","type":"text","required":true,"default":"Ubuntu 22.04"},{"name":"DNS_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones BIND (bloc brut)","type":"textarea","required":true,"default":"zone \\"camer.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.camer.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.bunec.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.etatcivil.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.civilstatus.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};"}]}},"query":{}}	2025-08-06 13:46:04.833+01	\N	\N	\N
154	1	create_template:16	{}	2025-08-06 13:46:04.88+01	\N	\N	\N
155	1	POST /templates/generate	{"body":{"template_id":16,"config_data":{"DNS_HOSTNAME":"dns1.camer.cm","OS_VERSION":"Ubuntu 22.04","DNS_IP":"192.168.20.10","SLAVE_IP":"192.168.20.20","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.camer.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.bunec.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.etatcivil.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.civilstatus.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};"}},"query":{}}	2025-08-06 13:46:16.588+01	\N	\N	\N
156	1	generate_template_file:16:dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh	{}	2025-08-06 13:46:16.621+01	\N	\N	\N
157	1	POST /templates	{"body":{"name":"Déploiement de l'API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nVENVDIR=\\"$APP_DIR/venv\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\n\\n# 1. Mise à jour système & dépendances\\necho \\"📦 Installation des paquets requis...\\"\\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\\nsudo apt install curl -y\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création d'un environnement virtuel Python\\necho \\"🐍 Initialisation de l’environnement virtuel...\\"\\nsudo -u $API_USER python3 -m venv \\"$VENVDIR\\"\\nsource \\"$VENVDIR/bin/activate\\"\\n\\n# 4. Installation de Flask et Gunicorn\\necho \\"📦 Installation de Flask & Gunicorn...\\"\\n\\"$VENVDIR/bin/pip\\" install flask gunicorn\\n\\n# 5. Création d’une application Flask minimaliste\\necho \\"📝 Déploiement de l'application Flask (hello.py)\\"\\nsudo tee \\"$APP_DIR/app.py\\" > /dev/null <<EOF\\nfrom flask import Flask\\napp = Flask(__name__)\\n\\n@app.route(\\"/\\")\\ndef home():\\n    return \\"✅ Bienvenue sur l’API interne Camer!\\"\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 6. Création du fichier WSGI\\necho \\"🧩 Création du fichier WSGI (wsgi.py)\\"\\nsudo tee \\"$APP_DIR/wsgi.py\\" > /dev/null <<EOF\\nfrom app import app\\n\\nif __name__ == \\"__main__\\":\\n    app.run()\\nEOF\\n\\n# 7. Configuration du service systemd\\necho \\"⚙️ Création du service systemd gunicorn\\"\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\\n[Unit]\\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nEnvironment=\\"PATH=$VENVDIR/bin\\"\\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\\nRestart=on-failure\\n\\n[Install]\\nWantedBy=multi-user.target\\nEOF\\n\\n# 8. Démarrage du service\\necho \\"🔄 Activation et lancement du service\\"\\nsudo systemctl daemon-reexec\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 9. Sécurisation avec UFW\\necho \\"🛡️ Configuration du pare-feu (UFW)\\"\\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 10. Test local\\necho \\"🔎 Test local sur http://127.0.0.1:5000\\"\\ncurl -s http://127.0.0.1:5000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l'API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d'installation de l'app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}	2025-08-06 13:46:35.221+01	\N	\N	\N
158	1	create_template:17	{}	2025-08-06 13:46:35.289+01	\N	\N	\N
159	1	POST /templates/generate	{"body":{"template_id":17,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 13:46:53.507+01	\N	\N	\N
160	1	generate_template_file:17:flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	{}	2025-08-06 13:46:53.531+01	\N	\N	\N
161	1	POST /templates	{"body":{"name":"Déploiement du serveur Web Camer-Web (web2.camer.cm)","service_type":"web_server_nginx","category":"web","description":"Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.","template_content":"#!/bin/bash\\nset -e\\n\\necho \\"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\\"\\n\\n# 1. Installation des paquets\\necho \\"📦 Installation de nginx et apache2 (optionnel)...\\"\\nsudo apt update\\nsudo apt install curl -y\\nsudo apt install nginx apache2 -y\\n\\n# 2. Préparation du répertoire web\\necho \\"📁 Création du site web ${WEB_ROOT}\\"\\nsudo mkdir -p ${WEB_ROOT}\\n\\necho \\"📝 Création de la page d’accueil personnalisée...\\"\\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\\n<!DOCTYPE html>\\n<html lang=\\\\\\"fr\\\\\\">\\n<head>\\n    <meta charset=\\\\\\"UTF-8\\\\\\">\\n    <title>Camer-Web</title>\\n</head>\\n<body style=\\\\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\\\\">\\n    <h1>✅ Bienvenue sur Camer-Web</h1>\\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nEOF\\n\\n# 3. Création du fichier NGINX vhost\\necho \\"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\\"\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\\nserver {\\n    listen 80;\\n    server_name ${DOMAIN_NAME};\\n\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\n\\n    root ${WEB_ROOT};\\n    index index.html;\\n\\n    location / {\\n        try_files \\\\$uri \\\\$uri/ =404;\\n    }\\n}\\nEOF\\n\\n# 4. Activation du site et désactivation du défaut\\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\\nsudo rm -f /etc/nginx/sites-enabled/default\\n\\n# 5. Redémarrage des services\\necho \\"🚀 Redémarrage de NGINX...\\"\\nsudo systemctl restart nginx\\nsudo systemctl enable nginx\\n\\n# 6. Pare-feu\\necho \\"🛡️ Configuration UFW pour NGINX...\\"\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\necho\\necho \\"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\\"\\n\\n: \\"\\\\${INSTANCE_ID:?INSTANCE_ID is required}\\"\\n\\n# Save instance identifier\\necho \\"INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\nexport INSTANCE_ID=\\\\${INSTANCE_ID}\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: \\\\${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log","script_path":"/scripts/deploy_web2.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web2.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.20.21"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"Camer-Web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}},"query":{}}	2025-08-06 13:47:06.158+01	\N	\N	\N
162	1	create_template:18	{}	2025-08-06 13:47:06.234+01	\N	\N	\N
163	1	POST /templates/generate	{"body":{"template_id":18,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}	2025-08-06 13:47:14.817+01	\N	\N	\N
164	1	generate_template_file:18:web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	{}	2025-08-06 13:47:14.854+01	\N	\N	\N
185	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:13:15.179+01	\N	\N	\N
186	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script003.sh	{}	2025-08-06 14:13:15.218+01	\N	\N	\N
187	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:13:48.273+01	\N	\N	\N
188	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	{}	2025-08-06 14:13:48.307+01	\N	\N	\N
191	1	POST /templates/generate	{"body":{"template_id":19,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}	2025-08-06 14:14:49.003+01	\N	\N	\N
192	1	generate_template_file:19:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh	{}	2025-08-06 14:14:49.026+01	\N	\N	\N
193	1	POST /templates/generate	{"body":{"template_id":18,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}	2025-08-06 14:15:06.195+01	\N	\N	\N
194	1	generate_template_file:18:web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh	{}	2025-08-06 14:15:06.225+01	\N	\N	\N
165	1	POST /templates	{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","script_path":"/scripts/install_services_monitoring.sh","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}	2025-08-06 13:47:28.027+01	\N	\N	\N
166	1	create_template:19	{}	2025-08-06 13:47:28.062+01	\N	\N	\N
167	1	POST /templates/generate	{"body":{"template_id":19,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}	2025-08-06 13:47:41.342+01	\N	\N	\N
168	1	generate_template_file:19:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh	{}	2025-08-06 13:47:41.362+01	\N	\N	\N
169	1	POST /templates	{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance système\\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\n\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\n\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\n\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\n\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s},\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > ${STATUS_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${STATUS_SCRIPT_PATH}","script_path":"/scripts/install_status_monitoring.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}	2025-08-06 13:47:52.513+01	\N	\N	\N
170	1	create_template:20	{}	2025-08-06 13:47:52.57+01	\N	\N	\N
171	1	POST /templates/generate	{"body":{"template_id":20,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}	2025-08-06 13:48:01.882+01	\N	\N	\N
172	1	generate_template_file:20:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh	{}	2025-08-06 13:48:01.898+01	\N	\N	\N
173	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 13:48:14.792+01	\N	\N	\N
174	1	create_template:21	{}	2025-08-06 13:48:14.824+01	\N	\N	\N
175	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 13:48:27.974+01	\N	\N	\N
176	1	generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh	{}	2025-08-06 13:48:27.993+01	\N	\N	\N
177	1	Déploiement Terraform	{"vm_name":"webtes2t","service_type":"web","success":true}	2025-08-06 13:51:06.197+01	\N	\N	\N
178	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 13:51:32.259+01	\N	\N	\N
179	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-06 14:05:23.713+01	\N	\N	\N
180	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}	2025-08-06 14:05:28.766+01	\N	\N	\N
181	1	Déploiement Terraform	{"vm_name":"we0w2b","service_type":"web","success":true}	2025-08-06 14:05:44.363+01	\N	\N	\N
182	1	POST /templates/generate	{"body":{"template_id":17,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:08:57.92+01	\N	\N	\N
183	1	POST /templates/generate	{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}	2025-08-06 14:09:09.547+01	\N	\N	\N
369	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:39.062+01	\N	\N	\N
195	1	POST /templates/generate	{"body":{"template_id":17,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.24.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.24.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}	2025-08-06 14:17:04.714+01	\N	\N	\N
196	1	generate_template_file:17:flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh	{}	2025-08-06 14:17:04.741+01	\N	\N	\N
197	1	POST /templates/generate	{"body":{"template_id":16,"config_data":{"DNS_HOSTNAME":"dns1.camer.cm","OS_VERSION":"Ubuntu 22.04","DNS_IP":"192.168.24.10","SLAVE_IP":"192.168.24.20","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.camer.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.bunec.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.etatcivil.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type master;\\n    file \\"/etc/bind/zones/db.civilstatus.cm\\";\\n    allow-transfer { 192.168.20.20; };\\n};"}},"query":{}}	2025-08-06 14:18:10.466+01	\N	\N	\N
198	1	generate_template_file:16:dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh	{}	2025-08-06 14:18:10.505+01	\N	\N	\N
199	1	POST /templates/generate	{"body":{"template_id":15,"config_data":{"SLAVE_IP":"192.168.24.20","MASTER_IP":"192.168.24.10","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \\"camer.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.camer.cm\\";\\n};\\n\\nzone \\"bunec.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.bunec.cm\\";\\n};\\n\\nzone \\"etatcivil.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.etatcivil.cm\\";\\n};\\n\\nzone \\"civilstatus.cm\\" {\\n    type slave;\\n    masters { 192.168.20.10; };\\n    file \\"/var/cache/bind/db.civilstatus.cm\\";\\n};"}},"query":{}}	2025-08-06 14:18:31.816+01	\N	\N	\N
200	1	generate_template_file:15:dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh	{}	2025-08-06 14:18:31.858+01	\N	\N	\N
201	1	POST /templates/generate	{"body":{"template_id":13,"config_data":{"SHARE_DIR":"/srv/nfs_share","CLIENT_SUBNET":"192.168.10.0/24"}},"query":{}}	2025-08-06 14:18:50.516+01	\N	\N	\N
202	1	generate_template_file:13:nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh	{}	2025-08-06 14:18:50.54+01	\N	\N	\N
203	1	POST /templates/generate	{"body":{"template_id":14,"config_data":{"NFS_SERVER":"192.168.10.10","SHARE_DIR":"/srv/nfs_share","MOUNT_DIR":"/mnt/nfs_share"}},"query":{}}	2025-08-06 14:19:05.422+01	\N	\N	\N
204	1	generate_template_file:14:nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh	{}	2025-08-06 14:19:05.442+01	\N	\N	\N
205	1	Déploiement Terraform	{"vm_name":"Webapache","service_type":"web","success":true}	2025-08-06 14:19:38.764+01	\N	\N	\N
206	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 15:31:11.598+01	\N	\N	\N
207	1	login	{"user_id":1}	2025-08-06 15:31:11.839+01	\N	\N	\N
208	1	POST /permissions	{"body":{"name":"script.analyze","description":"Analyser un script avec l’IA"},"query":{}}	2025-08-06 15:31:31.092+01	\N	\N	\N
209	1	POST /permissions	{"body":{"name":"script.read","description":"Lire les analyses de script IA"},"query":{}}	2025-08-06 15:32:09.144+01	\N	\N	\N
210	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[45,46]}],"query":{}}	2025-08-06 15:32:20.15+01	\N	\N	\N
211	1	POST /permissions	{"body":{"name":"template.analyze","description":"Analyse du template"},"query":{}}	2025-08-06 15:37:58.465+01	\N	\N	\N
212	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[47]}],"query":{}}	2025-08-06 15:38:07.754+01	\N	\N	\N
213	1	POST /templates	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 15:38:16.339+01	\N	\N	\N
214	1	create_template:22	{}	2025-08-06 15:38:16.378+01	\N	\N	\N
215	1	POST /templates/analyze	{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}	2025-08-06 15:41:17.661+01	\N	\N	\N
216	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt install bind9 -y\\nsystemctl enable bind9"},"query":{}}	2025-08-06 15:41:46.993+01	\N	\N	\N
217	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt install bind9 -y\\nsystemctl enable bind9"},"query":{}}	2025-08-06 15:42:47.183+01	\N	\N	\N
218	1	POST /templates/analyze	{"body":{"script_content":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-06 15:44:39.688+01	\N	\N	\N
370	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:39.109+01	\N	\N	\N
219	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 15:44:58.763+01	\N	\N	\N
220	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 15:45:55.51+01	\N	\N	\N
221	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 15:48:59.019+01	\N	\N	\N
222	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:01:12.237+01	\N	\N	\N
223	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:21:45.518+01	\N	\N	\N
224	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:27:34.396+01	\N	\N	\N
225	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:29:40.83+01	\N	\N	\N
226	1	GET /templates//2/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:50:04.094+01	\N	\N	\N
227	1	GET /templates/2/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:50:23.733+01	\N	\N	\N
228	1	GET /templates/9/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:50:32.887+01	\N	\N	\N
229	1	GET /templates/9/assistant-help	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 16:51:07.676+01	\N	\N	\N
230	1	POST /permissions	{"body":{"name":"template.audit","description":"template.audit"},"query":{}}	2025-08-06 17:05:38.324+01	\N	\N	\N
231	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[48]}],"query":{}}	2025-08-06 17:05:46.202+01	\N	\N	\N
232	1	POST /templates/audit	{"body":{"script":"#!/bin/bash\\nsudo apt update && sudo apt install nginx"},"query":{}}	2025-08-06 17:06:30.268+01	\N	\N	\N
233	1	POST /templates/audit	{"body":{"script":"#!/bin/bash\\n# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})\\n\\necho \\"📦 Installation de BIND9...\\"\\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\\nsudo apt install curl -y\\n\\necho \\"📁 Création du répertoire des zones...\\"\\nsudo mkdir -p /etc/bind/zones\\nsudo chown bind:bind /etc/bind/zones\\n\\necho \\"🔧 Configuration des options globales dans /etc/bind/named.conf.options...\\"\\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\\noptions {\\n    directory \\"/var/cache/bind\\";\\n\\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\\n    recursion no;\\n\\n    allow-transfer { ${SLAVE_IP}; };\\n    dnssec-validation auto;\\n\\n    listen-on { 127.0.0.1; ${DNS_IP}; };\\n    listen-on-v6 { none; };\\n};\\nEOF\\n\\necho \\"📌 Définition des zones dans /etc/bind/named.conf.local...\\"\\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\\n${ZONE_CONFIGS}\\nEOF\\n\\necho \\"🔓 Autorisation du trafic DNS depuis le slave...\\"\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto udp\\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp\\n\\necho \\"🚀 Redémarrage du service BIND9...\\"\\nsudo systemctl restart bind9\\nsudo systemctl enable bind9\\n\\necho \\"✅ Configuration du DNS Maître terminée.\\""},"query":{}}	2025-08-06 17:08:17.724+01	\N	\N	\N
234	1	PUT /permissions/48	{"body":{"name":"template.audit","description":"Auditer un script avec IA avant déploiement"},"query":{}}	2025-08-06 17:13:34.202+01	\N	\N	\N
235	1	POST /permissions	{"body":[{"name":"template.explain","description":"Explain script using AI"},{"name":"template.analyze","description":"Analyze script using AI"},{"name":"template.explainVariables","description":"Explain template variables using AI"},{"name":"template.summarizeLogs","description":"Summarize deployment logs using AI"},{"name":"template.suggestBundle","description":"Suggest stack bundles using AI"},{"name":"template.simulateExecution","description":"Simulate script execution using AI"}],"query":{}}	2025-08-06 17:49:12.794+01	\N	\N	\N
236	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[49,50,51,52,53]}],"query":{}}	2025-08-06 17:49:30.121+01	\N	\N	\N
237	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-06 17:50:25.232+01	\N	\N	\N
238	1	login	{"user_id":1}	2025-08-06 17:50:25.418+01	\N	\N	\N
239	1	POST /templates/explain	{"body":{"script":"#!/bin/bash\\necho hello"},"query":{}}	2025-08-06 17:50:59.816+01	\N	\N	\N
240	1	POST /templates/logs/summarize	{"body":{"logs":"Log line 1\\nLog line 2"},"query":{}}	2025-08-06 17:51:51.723+01	\N	\N	\N
241	1	POST /templates/bundle	{"body":{"needs":"Hébergement web"},"query":{}}	2025-08-06 17:54:19.826+01	\N	\N	\N
242	1	POST /templates/simulate	{"body":{"script":"#!/bin/bash\\nsystemctl restart nginx"},"query":{}}	2025-08-06 17:54:22.25+01	\N	\N	\N
243	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-06 17:54:30.585+01	\N	\N	\N
244	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-06 17:56:08.844+01	\N	\N	\N
245	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:03:09.024+01	\N	\N	\N
246	1	login	{"user_id":1}	2025-08-07 04:03:09.233+01	\N	\N	\N
247	1	POST /auth/register	{"body":{"first_name":"John","last_name":"Doe","email":"john@example.com","password":"secret","role_id":1},"query":{}}	2025-08-07 04:03:09.407+01	\N	\N	\N
248	\N	POST /auth/request-reset	{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}	2025-08-07 04:03:09.503+01	\N	\N	\N
249	1	request_reset_code	{"user_id":1}	2025-08-07 04:03:13.63+01	\N	\N	\N
250	\N	POST /auth/reset-password	{"body":{"code":"803327","password":"admin123."},"query":{}}	2025-08-07 04:03:13.707+01	\N	\N	\N
251	1	GET /auth/reset-history	{"query":{}}	2025-08-07 04:03:13.848+01	\N	\N	\N
252	1	view_reset_history	{}	2025-08-07 04:03:13.859+01	\N	\N	\N
253	1	POST /users	{"body":{"first_name":"Jane","last_name":"Doe","email":"jane@example.com","password":"secret","role_id":2},"query":{}}	2025-08-07 04:03:13.991+01	\N	\N	\N
254	1	DELETE /users/1	{"query":{}}	2025-08-07 04:03:14.311+01	\N	\N	\N
255	1	GET /users/1	{"query":{}}	2025-08-07 04:03:14.45+01	\N	\N	\N
256	1	GET /users	{"query":{}}	2025-08-07 04:03:14.593+01	\N	\N	\N
257	1	PATCH /users/1	{"body":{"last_name":"Smith"},"query":{}}	2025-08-07 04:03:14.753+01	\N	\N	\N
258	1	GET /users/search?query=Jane	{"query":{"query":"Jane"}}	2025-08-07 04:03:14.886+01	\N	\N	\N
259	1	PUT /users/1	{"body":{"first_name":"Jane"},"query":{}}	2025-08-07 04:03:15.03+01	\N	\N	\N
260	1	GET /roles	{"query":{}}	2025-08-07 04:03:15.17+01	\N	\N	\N
261	1	GET /roles/1	{"query":{}}	2025-08-07 04:03:15.314+01	\N	\N	\N
262	1	POST /roles	{"body":{"name":"editor","description":"Content editor"},"query":{}}	2025-08-07 04:03:15.442+01	\N	\N	\N
263	1	PUT /roles/1	{"body":{"description":"Updated role"},"query":{}}	2025-08-07 04:03:15.581+01	\N	\N	\N
264	1	DELETE /roles/1	{"query":{}}	2025-08-07 04:03:15.729+01	\N	\N	\N
265	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:09:17.691+01	\N	\N	\N
266	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:09:51.167+01	\N	\N	\N
267	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:10:03.561+01	\N	\N	\N
268	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:12:07.792+01	\N	\N	\N
643	1	GET /roles	{"query":{}}	2025-08-09 17:13:34.036+01	\N	\N	\N
269	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:12:29.238+01	\N	\N	\N
270	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:13:16.518+01	\N	\N	\N
271	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:14:13.131+01	\N	\N	\N
272	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:15:40.803+01	\N	\N	\N
273	1	login	{"user_id":1}	2025-08-07 04:15:40.976+01	\N	\N	\N
274	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:16:00.784+01	\N	\N	\N
275	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:17:37.36+01	\N	\N	\N
276	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:18:02.041+01	\N	\N	\N
277	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}	2025-08-07 04:18:05.707+01	\N	\N	\N
278	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-07 04:19:12.44+01	\N	\N	\N
279	1	POST /templates/variables/explain	{"body":{"template":"#!/bin/bash\\nexport VAR={{VALUE}}"},"query":{}}	2025-08-07 04:20:30.172+01	\N	\N	\N
280	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 04:46:47.538+01	\N	\N	\N
281	1	login	{"user_id":1}	2025-08-07 04:46:47.754+01	\N	\N	\N
282	1	GET /users	{"query":{}}	2025-08-07 04:46:47.939+01	\N	\N	\N
283	1	GET /roles	{"query":{}}	2025-08-07 04:46:47.982+01	\N	\N	\N
284	1	GET /permissions	{"query":{}}	2025-08-07 04:46:48.027+01	\N	\N	\N
285	1	GET /logs	{"query":{}}	2025-08-07 04:46:48.07+01	\N	\N	\N
286	1	GET /templates	{"query":{}}	2025-08-07 04:46:48.114+01	\N	\N	\N
287	1	GET /vms	{"query":{}}	2025-08-07 04:46:48.181+01	\N	\N	\N
288	1	GET /users	{"query":{}}	2025-08-07 04:46:48.38+01	\N	\N	\N
289	1	GET /roles	{"query":{}}	2025-08-07 04:46:48.42+01	\N	\N	\N
290	1	GET /permissions	{"query":{}}	2025-08-07 04:46:48.456+01	\N	\N	\N
291	1	GET /logs	{"query":{}}	2025-08-07 04:46:48.514+01	\N	\N	\N
292	1	list_vms	{}	2025-08-07 04:46:48.539+01	\N	\N	\N
293	1	GET /templates	{"query":{}}	2025-08-07 04:46:48.663+01	\N	\N	\N
294	1	GET /vms	{"query":{}}	2025-08-07 04:46:48.72+01	\N	\N	\N
295	1	list_vms	{}	2025-08-07 04:46:48.762+01	\N	\N	\N
296	1	GET /users	{"query":{}}	2025-08-07 04:47:19.782+01	\N	\N	\N
297	1	GET /roles	{"query":{}}	2025-08-07 04:47:19.825+01	\N	\N	\N
298	1	GET /permissions	{"query":{}}	2025-08-07 04:47:19.898+01	\N	\N	\N
299	1	GET /logs	{"query":{}}	2025-08-07 04:47:19.937+01	\N	\N	\N
300	1	GET /templates	{"query":{}}	2025-08-07 04:47:19.977+01	\N	\N	\N
301	1	GET /vms	{"query":{}}	2025-08-07 04:47:20.034+01	\N	\N	\N
302	1	GET /users	{"query":{}}	2025-08-07 04:47:20.167+01	\N	\N	\N
303	1	GET /roles	{"query":{}}	2025-08-07 04:47:20.203+01	\N	\N	\N
304	1	GET /permissions	{"query":{}}	2025-08-07 04:47:20.245+01	\N	\N	\N
305	1	GET /logs	{"query":{}}	2025-08-07 04:47:20.334+01	\N	\N	\N
306	1	GET /templates	{"query":{}}	2025-08-07 04:47:20.417+01	\N	\N	\N
307	1	list_vms	{}	2025-08-07 04:47:20.423+01	\N	\N	\N
308	1	GET /vms	{"query":{}}	2025-08-07 04:47:20.526+01	\N	\N	\N
309	1	list_vms	{}	2025-08-07 04:47:20.554+01	\N	\N	\N
310	1	GET /users	{"query":{}}	2025-08-07 04:47:34.542+01	\N	\N	\N
311	1	GET /users	{"query":{}}	2025-08-07 04:47:34.615+01	\N	\N	\N
312	1	GET /users/1	{"query":{}}	2025-08-07 04:47:38.112+01	\N	\N	\N
313	1	GET /users/1	{"query":{}}	2025-08-07 04:47:38.172+01	\N	\N	\N
314	1	PUT /users/1	{"body":{"first_name":"Nexus","last_name":"Nexus Latif","email":"latifnjimoluh@gmail.com","role_id":1},"query":{}}	2025-08-07 04:47:46.951+01	\N	\N	\N
315	1	GET /users/1	{"query":{}}	2025-08-07 04:47:47.021+01	\N	\N	\N
316	1	GET /users	{"query":{}}	2025-08-07 04:47:49.696+01	\N	\N	\N
317	1	GET /users	{"query":{}}	2025-08-07 04:47:49.766+01	\N	\N	\N
318	1	GET /users/1	{"query":{}}	2025-08-07 04:47:52.53+01	\N	\N	\N
319	1	GET /users/1	{"query":{}}	2025-08-07 04:47:52.591+01	\N	\N	\N
320	1	GET /roles	{"query":{}}	2025-08-07 04:48:00.218+01	\N	\N	\N
321	1	GET /roles	{"query":{}}	2025-08-07 04:48:00.277+01	\N	\N	\N
322	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:05.624+01	\N	\N	\N
323	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:05.682+01	\N	\N	\N
324	1	PUT /roles/2	{"body":{"name":"Admin","description":""},"query":{}}	2025-08-07 04:48:11.306+01	\N	\N	\N
325	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:11.373+01	\N	\N	\N
326	1	GET /roles	{"query":{}}	2025-08-07 04:48:13.639+01	\N	\N	\N
327	1	GET /roles	{"query":{}}	2025-08-07 04:48:13.701+01	\N	\N	\N
328	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:16.991+01	\N	\N	\N
329	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:17.05+01	\N	\N	\N
330	1	PUT /roles/2	{"body":{"name":"admin","description":""},"query":{}}	2025-08-07 04:48:21.129+01	\N	\N	\N
331	1	GET /roles/2	{"query":{}}	2025-08-07 04:48:21.199+01	\N	\N	\N
332	1	GET /permissions	{"query":{}}	2025-08-07 04:48:32.494+01	\N	\N	\N
333	1	GET /permissions	{"query":{}}	2025-08-07 04:48:32.554+01	\N	\N	\N
334	1	GET /users	{"query":{}}	2025-08-07 04:50:13.516+01	\N	\N	\N
335	1	GET /roles	{"query":{}}	2025-08-07 04:50:13.549+01	\N	\N	\N
336	1	GET /permissions	{"query":{}}	2025-08-07 04:50:13.58+01	\N	\N	\N
337	1	GET /logs	{"query":{}}	2025-08-07 04:50:13.613+01	\N	\N	\N
338	1	GET /templates	{"query":{}}	2025-08-07 04:50:13.652+01	\N	\N	\N
339	1	GET /vms	{"query":{}}	2025-08-07 04:50:13.701+01	\N	\N	\N
340	1	GET /permissions	{"query":{}}	2025-08-07 04:50:13.825+01	\N	\N	\N
341	1	GET /roles	{"query":{}}	2025-08-07 04:50:13.868+01	\N	\N	\N
342	1	GET /users	{"query":{}}	2025-08-07 04:50:13.913+01	\N	\N	\N
343	1	GET /logs	{"query":{}}	2025-08-07 04:50:13.979+01	\N	\N	\N
344	1	GET /templates	{"query":{}}	2025-08-07 04:50:14.049+01	\N	\N	\N
345	1	list_vms	{}	2025-08-07 04:50:14.063+01	\N	\N	\N
346	1	GET /vms	{"query":{}}	2025-08-07 04:50:14.162+01	\N	\N	\N
347	1	list_vms	{}	2025-08-07 04:50:14.183+01	\N	\N	\N
348	1	GET /users	{"query":{}}	2025-08-07 04:50:14.853+01	\N	\N	\N
349	1	GET /users	{"query":{}}	2025-08-07 04:50:14.911+01	\N	\N	\N
350	1	GET /roles	{"query":{}}	2025-08-07 04:50:16.04+01	\N	\N	\N
351	1	GET /roles	{"query":{}}	2025-08-07 04:50:16.083+01	\N	\N	\N
352	1	GET /users	{"query":{}}	2025-08-07 04:50:17.186+01	\N	\N	\N
353	1	GET /users	{"query":{}}	2025-08-07 04:50:17.242+01	\N	\N	\N
354	1	GET /roles	{"query":{}}	2025-08-07 04:50:19.396+01	\N	\N	\N
355	1	GET /roles	{"query":{}}	2025-08-07 04:50:19.446+01	\N	\N	\N
356	1	GET /permissions	{"query":{}}	2025-08-07 04:50:20.599+01	\N	\N	\N
357	1	GET /permissions	{"query":{}}	2025-08-07 04:50:20.668+01	\N	\N	\N
358	1	GET /auth/reset-history	{"query":{}}	2025-08-07 04:51:25.443+01	\N	\N	\N
359	1	view_reset_history	{}	2025-08-07 04:51:25.453+01	\N	\N	\N
360	1	GET /auth/reset-history	{"query":{}}	2025-08-07 04:51:25.498+01	\N	\N	\N
361	1	view_reset_history	{}	2025-08-07 04:51:25.502+01	\N	\N	\N
362	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:28.104+01	\N	\N	\N
363	1	GET /logs?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:51:28.163+01	\N	\N	\N
364	1	GET /logs?page=2&q=	{"query":{"page":"2","q":""}}	2025-08-07 04:51:31.657+01	\N	\N	\N
365	1	GET /roles	{"query":{}}	2025-08-07 04:51:34.803+01	\N	\N	\N
366	1	GET /roles	{"query":{}}	2025-08-07 04:51:34.853+01	\N	\N	\N
367	1	GET /permissions	{"query":{}}	2025-08-07 04:51:36.595+01	\N	\N	\N
368	1	GET /permissions	{"query":{}}	2025-08-07 04:51:36.643+01	\N	\N	\N
644	1	GET /users	{"query":{}}	2025-08-09 17:14:27.594+01	\N	\N	\N
371	1	GET /logs?page=2&q=	{"query":{"page":"2","q":""}}	2025-08-07 04:51:42.444+01	\N	\N	\N
373	1	GET /settings/me	{"query":{}}	2025-08-07 04:51:45.462+01	\N	\N	\N
376	1	GET /settings	{"query":{}}	2025-08-07 04:51:45.603+01	\N	\N	\N
1233	1	GET /templates	{"query":{}}	2025-08-10 10:34:04.158+01	\N	\N	\N
1234	1	GET /templates	{"query":{}}	2025-08-10 10:34:04.222+01	\N	\N	\N
1244	1	GET /templates	{"query":{}}	2025-08-10 11:00:55.089+01	\N	\N	\N
1245	1	GET /templates	{"query":{}}	2025-08-10 11:00:55.155+01	\N	\N	\N
1257	1	GET /templates	{"query":{}}	2025-08-10 11:14:05.147+01	\N	\N	\N
1272	1	GET /templates	{"query":{}}	2025-08-10 11:17:22.924+01	\N	\N	\N
1273	1	GET /templates	{"query":{}}	2025-08-10 11:17:22.985+01	\N	\N	\N
1283	1	GET /templates	{"query":{}}	2025-08-10 11:26:46.928+01	\N	\N	\N
1296	1	GET /templates	{"query":{}}	2025-08-10 11:48:27.459+01	\N	\N	\N
1297	1	GET /templates	{"query":{}}	2025-08-10 11:48:27.539+01	\N	\N	\N
1308	1	GET /dashboard/map	{"query":{}}	2025-08-10 12:51:22.828+01	\N	\N	\N
1309	1	GET /dashboard/map	{"query":{}}	2025-08-10 12:51:28.608+01	\N	\N	\N
1329	1	GET /templates	{"query":{}}	2025-08-10 12:59:21.93+01	\N	\N	\N
1338	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-10 13:07:22.961+01	\N	\N	\N
1350	1	GET /dashboard	{"query":{}}	2025-08-10 13:52:18.942+01	\N	\N	\N
1351	1	GET /dashboard	{"query":{}}	2025-08-10 13:52:19.015+01	\N	\N	\N
1362	1	GET /dashboard/map	{"query":{}}	2025-08-10 14:23:37.559+01	\N	\N	\N
1363	1	GET /dashboard/map	{"query":{}}	2025-08-10 14:23:37.626+01	\N	\N	\N
1378	1	GET /dashboard	{"query":{}}	2025-08-10 14:40:11.931+01	\N	\N	\N
1386	1	GET /dashboard	{"query":{}}	2025-08-10 14:48:11.914+01	\N	\N	\N
1394	1	GET /dashboard	{"query":{}}	2025-08-10 14:56:11.972+01	\N	\N	\N
1402	1	GET /dashboard	{"query":{}}	2025-08-10 15:04:11.926+01	\N	\N	\N
1410	1	GET /dashboard	{"query":{}}	2025-08-10 15:12:11.937+01	\N	\N	\N
1418	1	GET /dashboard	{"query":{}}	2025-08-10 15:20:11.935+01	\N	\N	\N
1426	1	GET /dashboard	{"query":{}}	2025-08-10 15:28:12.024+01	\N	\N	\N
1434	1	GET /dashboard	{"query":{}}	2025-08-10 15:36:11.949+01	\N	\N	\N
1442	1	GET /dashboard	{"query":{}}	2025-08-10 15:44:11.926+01	\N	\N	\N
1450	1	GET /dashboard	{"query":{}}	2025-08-10 15:52:11.927+01	\N	\N	\N
1458	1	GET /dashboard	{"query":{}}	2025-08-10 16:00:11.921+01	\N	\N	\N
1482	1	GET /templates	{"query":{}}	2025-08-10 23:40:39.502+01	\N	\N	\N
1500	1	GET /templates	{"query":{}}	2025-08-11 08:04:27.421+01	\N	\N	\N
1511	1	GET /roles	{"query":{}}	2025-08-11 08:09:10.922+01	\N	\N	\N
1513	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-11 08:09:14.34+01	\N	\N	\N
1515	1	GET /roles	{"query":{}}	2025-08-11 08:09:14.446+01	\N	\N	\N
1535	1	GET /templates	{"query":{}}	2025-08-11 08:11:13.786+01	\N	\N	\N
1536	1	GET /templates	{"query":{}}	2025-08-11 08:11:13.843+01	\N	\N	\N
1549	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-11 10:19:51.325+01	\N	\N	\N
1566	1	GET /templates	{"query":{}}	2025-08-11 10:22:07.3+01	\N	\N	\N
1581	1	GET /dashboard/map	{"query":{}}	2025-08-11 10:45:20.485+01	\N	\N	\N
1582	1	GET /dashboard/map	{"query":{}}	2025-08-11 10:45:20.554+01	\N	\N	\N
1600	1	GET /roles	{"query":{}}	2025-08-11 11:25:52.369+01	\N	\N	\N
1601	1	GET /roles	{"query":{}}	2025-08-11 11:25:52.439+01	\N	\N	\N
1612	1	GET /dashboard	{"query":{}}	2025-08-11 11:45:33.72+01	\N	\N	\N
1613	1	list_vms	{}	2025-08-11 11:45:33.782+01	\N	\N	\N
1614	1	GET /vms	{"query":{}}	2025-08-11 11:45:33.859+01	\N	\N	\N
1629	1	GET /templates	{"query":{}}	2025-08-11 11:49:31.633+01	\N	\N	\N
1630	1	GET /templates	{"query":{}}	2025-08-11 11:49:31.684+01	\N	\N	\N
1656	1	GET /vms	{"query":{}}	2025-08-11 11:57:43.104+01	\N	\N	\N
1659	1	GET /vms	{"query":{}}	2025-08-11 11:57:43.231+01	\N	\N	\N
1672	1	terminal_list_vms	{}	2025-08-11 12:46:26.322+01	\N	\N	\N
1673	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 12:46:26.373+01	\N	\N	\N
1694	1	Échec Déploiement Terraform	{}	2025-08-11 13:47:22.579+01	\N	\N	\N
1708	1	list_vms	{}	2025-08-11 14:28:15.683+01	\N	\N	\N
1731	1	POST /vms/105/start	{"query":{}}	2025-08-11 14:36:30.742+01	\N	\N	\N
1732	1	start_vm:105	{}	2025-08-11 14:36:30.786+01	\N	\N	\N
1751	1	GET /templates	{"query":{}}	2025-08-11 15:24:54.137+01	\N	\N	\N
1759	1	GET /vms	{"query":{}}	2025-08-12 02:59:44.936+01	\N	\N	\N
1768	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 04:22:29.153+01	\N	\N	\N
1769	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 04:22:29.229+01	\N	\N	\N
1770	1	GET /roles	{"query":{}}	2025-08-12 04:22:29.27+01	\N	\N	\N
1772	1	GET /permissions/role/2	{"query":{}}	2025-08-12 04:22:29.393+01	\N	\N	\N
1775	1	GET /permissions/role/3	{"query":{}}	2025-08-12 04:22:29.547+01	\N	\N	\N
1777	1	GET /permissions/role/2	{"query":{}}	2025-08-12 04:22:29.629+01	\N	\N	\N
1797	1	list_vms	{}	2025-08-12 04:25:00.446+01	\N	\N	\N
1807	1	GET /dashboard	{"query":{}}	2025-08-12 05:33:14.348+01	\N	\N	\N
1809	1	list_vms	{}	2025-08-12 05:33:14.401+01	\N	\N	\N
1810	1	GET /vms	{"query":{}}	2025-08-12 05:33:14.462+01	\N	\N	\N
1814	1	GET /templates	{"query":{}}	2025-08-12 05:33:22.313+01	\N	\N	\N
1817	1	POST /templates	{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance système\\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\n\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\n\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\n\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\n\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s},\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > ${STATUS_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${STATUS_SCRIPT_PATH}","script_path":"/scripts/install_status_monitoring.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}	2025-08-12 05:36:50.541+01	\N	\N	\N
1818	1	create_template:26	{}	2025-08-12 05:36:50.555+01	\N	\N	\N
1833	1	Échec Déploiement Terraform	{"code":"TF_APPLY_FAILED","message":"Le déploiement a échoué."}	2025-08-12 05:53:22.307+01	\N	\N	\N
1847	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-12 12:09:21.637+01	\N	\N	\N
1848	1	login	{"user_id":1}	2025-08-12 12:09:21.833+01	\N	\N	\N
1849	1	GET /dashboard	{"query":{}}	2025-08-12 12:09:23.927+01	\N	\N	\N
1850	1	GET /vms	{"query":{}}	2025-08-12 12:09:23.93+01	\N	\N	\N
1851	1	list_vms	{}	2025-08-12 12:09:23.999+01	\N	\N	\N
1852	1	GET /vms	{"query":{}}	2025-08-12 12:09:24.08+01	\N	\N	\N
1853	1	GET /dashboard	{"query":{}}	2025-08-12 12:09:24.133+01	\N	\N	\N
1854	1	list_vms	{}	2025-08-12 12:09:24.153+01	\N	\N	\N
1865	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 12:22:57.767+01	\N	\N	\N
372	1	GET /logs?page=3&q=	{"query":{"page":"3","q":""}}	2025-08-07 04:51:43.446+01	\N	\N	\N
374	1	GET /settings	{"query":{}}	2025-08-07 04:51:45.503+01	\N	\N	\N
375	1	GET /settings/me	{"query":{}}	2025-08-07 04:51:45.57+01	\N	\N	\N
377	1	GET /templates	{"query":{}}	2025-08-07 04:51:55.445+01	\N	\N	\N
378	1	GET /templates	{"query":{}}	2025-08-07 04:51:55.505+01	\N	\N	\N
379	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:55:55.451+01	\N	\N	\N
380	1	list_vms	{}	2025-08-07 04:55:55.475+01	\N	\N	\N
381	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:55:55.522+01	\N	\N	\N
382	1	list_vms	{}	2025-08-07 04:55:55.54+01	\N	\N	\N
383	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:47.99+01	\N	\N	\N
384	1	list_vms	{}	2025-08-07 04:56:48.017+01	\N	\N	\N
385	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:48.059+01	\N	\N	\N
386	1	list_vms	{}	2025-08-07 04:56:48.086+01	\N	\N	\N
387	1	GET /vms/conversions	{"query":{}}	2025-08-07 04:56:51.219+01	\N	\N	\N
388	1	view_conversion_history	{}	2025-08-07 04:56:51.231+01	\N	\N	\N
389	1	GET /vms/conversions	{"query":{}}	2025-08-07 04:56:51.291+01	\N	\N	\N
390	1	view_conversion_history	{}	2025-08-07 04:56:51.3+01	\N	\N	\N
391	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:53.739+01	\N	\N	\N
392	1	list_vms	{}	2025-08-07 04:56:53.769+01	\N	\N	\N
393	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 04:56:53.816+01	\N	\N	\N
394	1	list_vms	{}	2025-08-07 04:56:53.843+01	\N	\N	\N
395	1	GET /ai-cache	{"query":{}}	2025-08-07 04:57:15.579+01	\N	\N	\N
396	1	GET /ai-cache	{"query":{}}	2025-08-07 04:57:15.627+01	\N	\N	\N
397	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\\\nsudo apt update"},"query":{}}	2025-08-07 04:57:55.603+01	\N	\N	\N
398	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\\\nsudo apt update"},"query":{}}	2025-08-07 04:58:28.733+01	\N	\N	\N
399	1	GET /ai-cache	{"query":{}}	2025-08-07 04:58:33.417+01	\N	\N	\N
400	1	GET /ai-cache	{"query":{}}	2025-08-07 04:58:33.462+01	\N	\N	\N
401	1	GET /permissions	{"query":{}}	2025-08-07 04:58:47.754+01	\N	\N	\N
402	1	GET /permissions	{"query":{}}	2025-08-07 04:58:47.809+01	\N	\N	\N
403	1	POST /permissions	{"body":{"name":"aiCache.list","description":"Liste des requete deja recu"},"query":{}}	2025-08-07 04:59:05.036+01	\N	\N	\N
404	1	GET /permissions	{"query":{}}	2025-08-07 04:59:05.097+01	\N	\N	\N
405	1	GET /permissions/54	{"query":{}}	2025-08-07 04:59:11.889+01	\N	\N	\N
406	1	GET /permissions/54	{"query":{}}	2025-08-07 04:59:11.946+01	\N	\N	\N
407	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[54]}],"query":{}}	2025-08-07 04:59:26.833+01	\N	\N	\N
408	1	GET /ai-cache	{"query":{}}	2025-08-07 04:59:29.477+01	\N	\N	\N
409	1	GET /ai-cache	{"query":{}}	2025-08-07 04:59:29.526+01	\N	\N	\N
410	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-07 05:09:27.443+01	\N	\N	\N
411	1	login	{"user_id":1}	2025-08-07 05:09:27.647+01	\N	\N	\N
412	1	GET /users	{"query":{}}	2025-08-07 05:09:27.822+01	\N	\N	\N
413	1	GET /roles	{"query":{}}	2025-08-07 05:09:27.88+01	\N	\N	\N
414	1	GET /permissions	{"query":{}}	2025-08-07 05:09:27.96+01	\N	\N	\N
415	1	GET /logs	{"query":{}}	2025-08-07 05:09:27.999+01	\N	\N	\N
416	1	GET /templates	{"query":{}}	2025-08-07 05:09:28.038+01	\N	\N	\N
417	1	GET /vms	{"query":{}}	2025-08-07 05:09:28.055+01	\N	\N	\N
418	1	GET /users	{"query":{}}	2025-08-07 05:09:28.223+01	\N	\N	\N
419	1	GET /roles	{"query":{}}	2025-08-07 05:09:28.26+01	\N	\N	\N
420	1	GET /permissions	{"query":{}}	2025-08-07 05:09:28.302+01	\N	\N	\N
421	1	list_vms	{}	2025-08-07 05:09:28.312+01	\N	\N	\N
422	1	GET /logs	{"query":{}}	2025-08-07 05:09:28.36+01	\N	\N	\N
423	1	GET /templates	{"query":{}}	2025-08-07 05:09:28.42+01	\N	\N	\N
424	1	GET /vms	{"query":{}}	2025-08-07 05:09:28.552+01	\N	\N	\N
425	1	list_vms	{}	2025-08-07 05:09:28.588+01	\N	\N	\N
426	1	POST /permissions	{"body":[{"name":"dashboard.view","description":"View dashboard data"},{"name":"alert.list","description":"List alerts"},{"name":"alert.update","description":"Update alert"},{"name":"servers.view","description":"View servers"},{"name":"servers.add","description":"Add server"},{"name":"servers.edit","description":"Edit server"},{"name":"servers.delete","description":"Delete server"}],"query":{}}	2025-08-07 07:02:52.482+01	\N	\N	\N
427	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[55,56,57,58,59,60,61]}],"query":{}}	2025-08-07 07:03:20.174+01	\N	\N	\N
428	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:03:32.109+01	\N	\N	\N
429	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:03:32.111+01	\N	\N	\N
430	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:03:32.248+01	\N	\N	\N
431	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:03:32.252+01	\N	\N	\N
432	1	GET /alerts	{"query":{}}	2025-08-07 07:03:41.947+01	\N	\N	\N
433	1	GET /alerts	{"query":{}}	2025-08-07 07:03:42.08+01	\N	\N	\N
434	1	GET /alerts	{"query":{}}	2025-08-07 07:03:44.151+01	\N	\N	\N
435	1	GET /alerts	{"query":{}}	2025-08-07 07:03:44.276+01	\N	\N	\N
436	1	GET /alerts	{"query":{}}	2025-08-07 07:03:46.016+01	\N	\N	\N
437	1	GET /alerts	{"query":{}}	2025-08-07 07:03:46.127+01	\N	\N	\N
438	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:03:54.854+01	\N	\N	\N
439	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:03:54.855+01	\N	\N	\N
440	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:03:54.958+01	\N	\N	\N
441	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:03:54.96+01	\N	\N	\N
442	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:01.579+01	\N	\N	\N
443	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:01.641+01	\N	\N	\N
444	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:05.787+01	\N	\N	\N
445	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:05.843+01	\N	\N	\N
446	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:09.674+01	\N	\N	\N
447	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:09.729+01	\N	\N	\N
448	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:14.29+01	\N	\N	\N
449	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:14.346+01	\N	\N	\N
450	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:18.832+01	\N	\N	\N
451	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:18.887+01	\N	\N	\N
452	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:19.62+01	\N	\N	\N
453	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:04:19.63+01	\N	\N	\N
454	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:04:19.724+01	\N	\N	\N
455	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:04:19.775+01	\N	\N	\N
456	1	GET /templates	{"query":{}}	2025-08-07 07:04:21.654+01	\N	\N	\N
457	1	GET /templates	{"query":{}}	2025-08-07 07:04:21.715+01	\N	\N	\N
458	1	GET /templates/22	{"query":{}}	2025-08-07 07:04:25.352+01	\N	\N	\N
459	1	GET /templates/22	{"query":{}}	2025-08-07 07:04:25.413+01	\N	\N	\N
536	1	POST /templates/explain	{"body":{"script":"#!/bin/bash\\necho hello"},"query":{}}	2025-08-08 16:59:58.155+01	\N	\N	\N
537	1	POST /templates/simulate	{"body":{"script":"#!/bin/bash\\nsystemctl restart nginx"},"query":{}}	2025-08-08 17:01:00.672+01	\N	\N	\N
538	1	GET /ai-cache	{"query":{}}	2025-08-08 17:02:57.723+01	\N	\N	\N
539	1	GET /ai-cache/1	{"query":{}}	2025-08-08 17:03:26.527+01	\N	\N	\N
540	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:53:32.325+01	\N	\N	\N
541	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:53:32.398+01	\N	\N	\N
645	1	GET /roles	{"query":{}}	2025-08-09 17:14:27.634+01	\N	\N	\N
460	1	POST /templates/audit	{"body":{"script":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi"},"query":{}}	2025-08-07 07:04:31.384+01	\N	\N	\N
461	1	GET /ai-cache	{"query":{}}	2025-08-07 07:04:58.74+01	\N	\N	\N
462	1	GET /ai-cache	{"query":{}}	2025-08-07 07:04:58.794+01	\N	\N	\N
463	1	GET /auth/me	{"query":{}}	2025-08-07 07:05:10.653+01	\N	\N	\N
464	1	GET /auth/me	{"query":{}}	2025-08-07 07:05:10.7+01	\N	\N	\N
465	1	GET /settings/me	{"query":{}}	2025-08-07 07:05:14.751+01	\N	\N	\N
466	1	GET /settings	{"query":{}}	2025-08-07 07:05:14.789+01	\N	\N	\N
467	1	GET /settings/me	{"query":{}}	2025-08-07 07:05:14.872+01	\N	\N	\N
468	1	GET /settings	{"query":{}}	2025-08-07 07:05:14.91+01	\N	\N	\N
469	1	GET /settings/notifications	{"query":{}}	2025-08-07 07:05:16.949+01	\N	\N	\N
470	1	GET /settings/notifications	{"query":{}}	2025-08-07 07:05:17.021+01	\N	\N	\N
471	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:05:19.845+01	\N	\N	\N
472	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:05:19.847+01	\N	\N	\N
473	1	GET /dashboard/servers	{"query":{}}	2025-08-07 07:05:19.945+01	\N	\N	\N
474	1	GET /dashboard/summary	{"query":{}}	2025-08-07 07:05:19.946+01	\N	\N	\N
475	1	GET /templates	{"query":{}}	2025-08-07 07:05:21.4+01	\N	\N	\N
476	1	GET /templates	{"query":{}}	2025-08-07 07:05:21.453+01	\N	\N	\N
477	1	GET /servers	{"query":{}}	2025-08-07 07:05:27.726+01	\N	\N	\N
478	1	GET /servers	{"query":{}}	2025-08-07 07:05:27.773+01	\N	\N	\N
479	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 07:05:31.202+01	\N	\N	\N
480	1	list_vms	{}	2025-08-07 07:05:31.243+01	\N	\N	\N
481	1	GET /vms?page=1&q=	{"query":{"page":"1","q":""}}	2025-08-07 07:05:31.292+01	\N	\N	\N
482	1	list_vms	{}	2025-08-07 07:05:31.316+01	\N	\N	\N
483	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-07 11:42:40.938+01	\N	\N	\N
484	1	login	{"user_id":1}	2025-08-07 11:42:41.07+01	\N	\N	\N
485	1	GET /alerts	{"query":{}}	2025-08-07 11:42:54.798+01	\N	\N	\N
486	1	GET /alerts	{"query":{}}	2025-08-07 11:42:54.928+01	\N	\N	\N
487	1	GET /alerts	{"query":{}}	2025-08-07 11:42:58.575+01	\N	\N	\N
488	1	GET /alerts	{"query":{}}	2025-08-07 11:42:58.718+01	\N	\N	\N
489	1	GET /alerts	{"query":{}}	2025-08-07 11:43:01.469+01	\N	\N	\N
490	1	GET /alerts	{"query":{}}	2025-08-07 11:43:01.609+01	\N	\N	\N
491	1	GET /alerts	{"query":{}}	2025-08-07 11:43:04.287+01	\N	\N	\N
492	1	GET /alerts	{"query":{}}	2025-08-07 11:43:04.389+01	\N	\N	\N
493	1	GET /alerts	{"query":{}}	2025-08-07 11:43:06.875+01	\N	\N	\N
494	1	GET /alerts	{"query":{}}	2025-08-07 11:43:06.976+01	\N	\N	\N
495	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-07 11:56:25.969+01	\N	\N	\N
496	1	login	{"user_id":1}	2025-08-07 11:56:26.15+01	\N	\N	\N
497	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 07:48:55.587+01	\N	\N	\N
498	1	login	{"user_id":1}	2025-08-08 07:48:55.791+01	\N	\N	\N
499	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-08 07:56:07.52+01	\N	\N	\N
500	1	login	{"user_id":1}	2025-08-08 07:56:07.73+01	\N	\N	\N
501	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-08 08:26:38.966+01	\N	\N	\N
502	1	login	{"user_id":1}	2025-08-08 08:26:39.167+01	\N	\N	\N
503	1	GET /users/1	{"query":{}}	2025-08-08 08:30:07.969+01	\N	\N	\N
504	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-08 13:40:58.698+01	\N	\N	\N
505	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}	2025-08-08 13:41:10.961+01	\N	\N	\N
506	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}	2025-08-08 13:43:05.724+01	\N	\N	\N
507	1	Déploiement Terraform	{"vm_name":"Webapache","service_type":"web","success":true}	2025-08-08 13:44:36.162+01	\N	\N	\N
508	1	Déploiement Terraform	{"vm_name":"testVM","service_type":"web","success":true}	2025-08-08 13:47:25.735+01	\N	\N	\N
509	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-08 14:21:53.639+01	\N	\N	\N
510	1	login	{"user_id":1}	2025-08-08 14:21:53.819+01	\N	\N	\N
511	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:39:16.057+01	\N	\N	\N
512	1	login	{"user_id":1}	2025-08-08 14:39:16.205+01	\N	\N	\N
513	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:40:38.377+01	\N	\N	\N
514	1	login	{"user_id":1}	2025-08-08 14:40:38.504+01	\N	\N	\N
515	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:42:02.045+01	\N	\N	\N
516	1	login	{"user_id":1}	2025-08-08 14:42:02.204+01	\N	\N	\N
517	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:42:14.969+01	\N	\N	\N
518	1	login	{"user_id":1}	2025-08-08 14:42:15.097+01	\N	\N	\N
519	\N	POST /auth/login	{"body":{"identifier":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:44:46.654+01	\N	\N	\N
520	\N	POST /auth/login	{"body":{"identifier":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:50:32.773+01	\N	\N	\N
521	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:53:03.857+01	\N	\N	\N
522	1	login	{"user_id":1}	2025-08-08 14:53:04.035+01	\N	\N	\N
523	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 14:57:20.048+01	\N	\N	\N
524	1	login	{"user_id":1}	2025-08-08 14:57:20.233+01	\N	\N	\N
525	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 15:04:17.014+01	\N	\N	\N
526	1	login	{"user_id":1}	2025-08-08 15:04:17.186+01	\N	\N	\N
527	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 15:49:29.659+01	\N	\N	\N
528	1	login	{"user_id":1}	2025-08-08 15:49:29.805+01	\N	\N	\N
529	\N	POST /auth/request-reset	{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}	2025-08-08 15:49:42.933+01	\N	\N	\N
530	1	request_reset_code	{"user_id":1}	2025-08-08 15:49:46.243+01	\N	\N	\N
531	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-08 16:23:33.494+01	\N	\N	\N
532	1	login	{"user_id":1}	2025-08-08 16:23:33.699+01	\N	\N	\N
533	1	GET /auth/me	{"query":{}}	2025-08-08 16:23:50.763+01	\N	\N	\N
534	1	GET /auth/me	{"query":{}}	2025-08-08 16:23:50.838+01	\N	\N	\N
535	1	POST /templates/explain	{"body":{"script":"#!/bin/bash\\necho hello"},"query":{}}	2025-08-08 16:59:06.832+01	\N	\N	\N
542	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:53:45.3+01	\N	\N	\N
543	1	GET /settings/me	{"query":{}}	2025-08-08 17:54:14.304+01	\N	\N	\N
544	1	GET /settings/me	{"query":{}}	2025-08-08 17:54:14.382+01	\N	\N	\N
545	1	GET /templates	{"query":{}}	2025-08-08 17:54:21.856+01	\N	\N	\N
546	1	GET /templates	{"query":{}}	2025-08-08 17:54:21.918+01	\N	\N	\N
547	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:54:33.56+01	\N	\N	\N
548	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:54:33.634+01	\N	\N	\N
549	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:54:43.531+01	\N	\N	\N
550	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:54:53.61+01	\N	\N	\N
551	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:55:03.672+01	\N	\N	\N
552	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:55:13.542+01	\N	\N	\N
553	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:55:23.866+01	\N	\N	\N
554	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:55:33.851+01	\N	\N	\N
555	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:55:44.057+01	\N	\N	\N
556	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:55:53.837+01	\N	\N	\N
557	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:56:03.834+01	\N	\N	\N
558	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:56:13.837+01	\N	\N	\N
559	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:57:19.991+01	\N	\N	\N
560	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:58:19.924+01	\N	\N	\N
561	1	GET /dashboard/summary	{"query":{}}	2025-08-08 17:59:19.897+01	\N	\N	\N
562	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:00:19.951+01	\N	\N	\N
563	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:01:08.046+01	\N	\N	\N
564	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:01:13.537+01	\N	\N	\N
565	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:01:14.759+01	\N	\N	\N
566	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:01:15.842+01	\N	\N	\N
567	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:01:23.58+01	\N	\N	\N
568	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:01:33.836+01	\N	\N	\N
569	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:01:43.556+01	\N	\N	\N
570	1	GET /templates	{"query":{}}	2025-08-08 18:01:59.064+01	\N	\N	\N
571	1	GET /users	{"query":{}}	2025-08-08 18:02:11.489+01	\N	\N	\N
572	1	GET /roles	{"query":{}}	2025-08-08 18:02:11.534+01	\N	\N	\N
573	1	GET /servers	{"query":{}}	2025-08-08 18:02:34.484+01	\N	\N	\N
574	1	POST /servers	{"body":{"name":"test","ip":" ddd","zone":"LAN"},"query":{}}	2025-08-08 18:02:42.9+01	\N	\N	\N
575	1	DELETE /servers/4fff5737-ea6a-4806-aaa6-05936daa9924	{"query":{}}	2025-08-08 18:02:50+01	\N	\N	\N
576	1	GET /auth/me	{"query":{}}	2025-08-08 18:09:17.862+01	\N	\N	\N
577	1	GET /settings/me	{"query":{}}	2025-08-08 18:09:26.747+01	\N	\N	\N
578	1	GET /settings/me	{"query":{}}	2025-08-08 18:09:26.82+01	\N	\N	\N
579	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:09:53.011+01	\N	\N	\N
580	1	GET /dashboard/summary	{"query":{}}	2025-08-08 18:09:53.07+01	\N	\N	\N
581	1	GET /servers	{"query":{}}	2025-08-08 18:09:57.277+01	\N	\N	\N
582	1	GET /servers	{"query":{}}	2025-08-08 18:09:57.332+01	\N	\N	\N
583	1	GET /servers	{"query":{}}	2025-08-08 18:10:25.996+01	\N	\N	\N
584	1	GET /servers	{"query":{}}	2025-08-08 18:10:26.05+01	\N	\N	\N
585	1	GET /alerts	{"query":{}}	2025-08-08 18:10:32.474+01	\N	\N	\N
586	1	GET /alerts	{"query":{}}	2025-08-08 18:10:32.534+01	\N	\N	\N
587	1	GET /auth/me	{"query":{}}	2025-08-08 18:10:38.363+01	\N	\N	\N
588	1	GET /servers	{"query":{}}	2025-08-08 18:10:38.464+01	\N	\N	\N
589	1	GET /templates	{"query":{}}	2025-08-08 18:10:46.994+01	\N	\N	\N
590	1	GET /templates	{"query":{}}	2025-08-08 18:10:47.052+01	\N	\N	\N
591	1	GET /templates	{"query":{}}	2025-08-08 18:11:14.256+01	\N	\N	\N
592	1	GET /templates	{"query":{}}	2025-08-08 18:11:14.328+01	\N	\N	\N
593	1	GET /auth/me	{"query":{}}	2025-08-08 18:11:20.378+01	\N	\N	\N
594	1	GET /templates	{"query":{}}	2025-08-08 18:11:20.593+01	\N	\N	\N
595	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 16:09:36.722+01	\N	\N	\N
596	1	login	{"user_id":1}	2025-08-09 16:09:36.921+01	\N	\N	\N
597	1	GET /settings/me	{"query":{}}	2025-08-09 16:14:10.705+01	\N	\N	\N
598	1	GET /settings/me	{"query":{}}	2025-08-09 16:14:10.784+01	\N	\N	\N
599	1	GET /settings/me	{"query":{}}	2025-08-09 16:14:49.609+01	\N	\N	\N
600	1	GET /settings/me	{"query":{}}	2025-08-09 16:14:49.676+01	\N	\N	\N
601	1	GET /settings/me	{"query":{}}	2025-08-09 16:15:16.933+01	\N	\N	\N
602	1	GET /auth/me	{"query":{}}	2025-08-09 16:16:30.315+01	\N	\N	\N
603	1	GET /auth/me	{"query":{}}	2025-08-09 16:16:30.369+01	\N	\N	\N
604	1	Échec Déploiement Terraform	{}	2025-08-09 16:18:33.143+01	\N	\N	\N
605	1	GET /roles	{"query":{}}	2025-08-09 16:27:49.553+01	\N	\N	\N
606	1	GET /roles	{"query":{}}	2025-08-09 16:27:49.612+01	\N	\N	\N
607	1	GET /permissions	{"query":{}}	2025-08-09 16:31:03.993+01	\N	\N	\N
608	1	GET /roles	{"query":{}}	2025-08-09 16:31:04.033+01	\N	\N	\N
609	1	GET /permissions	{"query":{}}	2025-08-09 16:31:04.103+01	\N	\N	\N
610	1	GET /roles	{"query":{}}	2025-08-09 16:31:04.148+01	\N	\N	\N
611	1	GET /permissions/role/1	{"query":{}}	2025-08-09 16:31:04.195+01	\N	\N	\N
612	1	GET /permissions/role/2	{"query":{}}	2025-08-09 16:31:04.236+01	\N	\N	\N
613	1	GET /permissions/role/2	{"query":{}}	2025-08-09 16:31:04.358+01	\N	\N	\N
614	1	GET /permissions/role/1	{"query":{}}	2025-08-09 16:31:04.41+01	\N	\N	\N
615	1	POST /permissions/assign	{"body":[{"role_id":2,"permission_ids":[54]}],"query":{}}	2025-08-09 16:31:18.138+01	\N	\N	\N
616	1	GET /permissions	{"query":{}}	2025-08-09 16:31:38.236+01	\N	\N	\N
617	1	GET /roles	{"query":{}}	2025-08-09 16:31:38.279+01	\N	\N	\N
618	1	GET /permissions/role/2	{"query":{}}	2025-08-09 16:31:38.379+01	\N	\N	\N
619	1	GET /permissions/role/1	{"query":{}}	2025-08-09 16:31:38.421+01	\N	\N	\N
620	1	GET /users	{"query":{}}	2025-08-09 16:32:38.898+01	\N	\N	\N
621	1	GET /roles	{"query":{}}	2025-08-09 16:32:38.948+01	\N	\N	\N
622	1	GET /users	{"query":{}}	2025-08-09 16:32:39.036+01	\N	\N	\N
623	1	GET /roles	{"query":{}}	2025-08-09 16:32:39.089+01	\N	\N	\N
624	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 17:08:33.486+01	\N	\N	\N
625	1	login	{"user_id":1}	2025-08-09 17:08:33.688+01	\N	\N	\N
626	1	GET /settings/account	{"query":{}}	2025-08-09 17:08:45.412+01	\N	\N	\N
627	1	GET /settings/account	{"query":{}}	2025-08-09 17:08:45.491+01	\N	\N	\N
628	1	GET /settings/me	{"query":{}}	2025-08-09 17:10:23.961+01	\N	\N	\N
629	1	GET /settings/me	{"query":{}}	2025-08-09 17:10:24.027+01	\N	\N	\N
630	1	GET /settings/me	{"query":{}}	2025-08-09 17:10:41.429+01	\N	\N	\N
631	1	GET /settings/me	{"query":{}}	2025-08-09 17:10:41.488+01	\N	\N	\N
632	1	GET /auth/me	{"query":{}}	2025-08-09 17:11:04.898+01	\N	\N	\N
633	1	GET /auth/me	{"query":{}}	2025-08-09 17:11:04.961+01	\N	\N	\N
634	1	GET /settings/me	{"query":{}}	2025-08-09 17:12:19.131+01	\N	\N	\N
635	1	GET /settings/me	{"query":{}}	2025-08-09 17:12:19.194+01	\N	\N	\N
636	1	GET /settings/account	{"query":{}}	2025-08-09 17:12:47.967+01	\N	\N	\N
637	1	GET /settings/account	{"query":{}}	2025-08-09 17:12:48.029+01	\N	\N	\N
638	1	GET /settings/me	{"query":{}}	2025-08-09 17:13:25.454+01	\N	\N	\N
639	1	GET /settings/me	{"query":{}}	2025-08-09 17:13:25.511+01	\N	\N	\N
640	1	GET /users	{"query":{}}	2025-08-09 17:13:33.86+01	\N	\N	\N
641	1	GET /roles	{"query":{}}	2025-08-09 17:13:33.896+01	\N	\N	\N
642	1	GET /users	{"query":{}}	2025-08-09 17:13:33.989+01	\N	\N	\N
646	1	GET /users	{"query":{}}	2025-08-09 17:14:27.699+01	\N	\N	\N
1235	1	GET /templates	{"query":{}}	2025-08-10 10:34:08.109+01	\N	\N	\N
1246	1	GET /templates	{"query":{}}	2025-08-10 11:01:30.212+01	\N	\N	\N
1247	1	GET /templates	{"query":{}}	2025-08-10 11:01:30.28+01	\N	\N	\N
1258	1	GET /templates	{"query":{}}	2025-08-10 11:15:58.3+01	\N	\N	\N
1259	1	GET /templates	{"query":{}}	2025-08-10 11:15:58.358+01	\N	\N	\N
1274	1	GET /templates	{"query":{}}	2025-08-10 11:17:27.24+01	\N	\N	\N
1284	1	GET /templates	{"query":{}}	2025-08-10 11:26:58.844+01	\N	\N	\N
1285	1	GET /templates	{"query":{}}	2025-08-10 11:26:58.908+01	\N	\N	\N
1298	1	GET /templates	{"query":{}}	2025-08-10 11:48:45.344+01	\N	\N	\N
1299	1	GET /templates	{"query":{}}	2025-08-10 11:48:45.411+01	\N	\N	\N
1310	1	GET /dashboard	{"query":{}}	2025-08-10 12:54:57.619+01	\N	\N	\N
1311	1	GET /dashboard	{"query":{}}	2025-08-10 12:54:57.705+01	\N	\N	\N
1312	1	GET /dashboard	{"query":{}}	2025-08-10 12:55:07.538+01	\N	\N	\N
1313	1	GET /dashboard	{"query":{}}	2025-08-10 12:55:16.191+01	\N	\N	\N
1314	1	GET /dashboard	{"query":{}}	2025-08-10 12:55:17.537+01	\N	\N	\N
1315	1	GET /dashboard/map	{"query":{}}	2025-08-10 12:55:25.344+01	\N	\N	\N
1316	1	GET /dashboard/map	{"query":{}}	2025-08-10 12:55:25.401+01	\N	\N	\N
1330	1	GET /templates	{"query":{}}	2025-08-10 13:00:16.772+01	\N	\N	\N
1339	1	terminal_list_vms	{}	2025-08-10 13:07:23.034+01	\N	\N	\N
1352	1	GET /templates	{"query":{}}	2025-08-10 14:01:50.372+01	\N	\N	\N
1353	1	GET /templates	{"query":{}}	2025-08-10 14:01:50.442+01	\N	\N	\N
1364	1	GET /dashboard	{"query":{}}	2025-08-10 14:32:18.719+01	\N	\N	\N
1365	1	GET /dashboard	{"query":{}}	2025-08-10 14:32:18.789+01	\N	\N	\N
1366	1	GET /dashboard	{"query":{}}	2025-08-10 14:32:28.868+01	\N	\N	\N
1367	1	GET /dashboard	{"query":{}}	2025-08-10 14:32:38.993+01	\N	\N	\N
1368	1	GET /dashboard	{"query":{}}	2025-08-10 14:32:48.871+01	\N	\N	\N
1369	1	GET /dashboard	{"query":{}}	2025-08-10 14:32:58.866+01	\N	\N	\N
1370	1	GET /dashboard	{"query":{}}	2025-08-10 14:33:08.888+01	\N	\N	\N
1371	1	GET /dashboard	{"query":{}}	2025-08-10 14:33:18.834+01	\N	\N	\N
1379	1	GET /dashboard	{"query":{}}	2025-08-10 14:41:11.924+01	\N	\N	\N
1387	1	GET /dashboard	{"query":{}}	2025-08-10 14:49:11.953+01	\N	\N	\N
1395	1	GET /dashboard	{"query":{}}	2025-08-10 14:57:11.957+01	\N	\N	\N
1403	1	GET /dashboard	{"query":{}}	2025-08-10 15:05:11.919+01	\N	\N	\N
1411	1	GET /dashboard	{"query":{}}	2025-08-10 15:13:11.923+01	\N	\N	\N
1419	1	GET /dashboard	{"query":{}}	2025-08-10 15:21:11.935+01	\N	\N	\N
1427	1	GET /dashboard	{"query":{}}	2025-08-10 15:29:11.944+01	\N	\N	\N
1435	1	GET /dashboard	{"query":{}}	2025-08-10 15:37:11.924+01	\N	\N	\N
1443	1	GET /dashboard	{"query":{}}	2025-08-10 15:45:11.942+01	\N	\N	\N
1451	1	GET /dashboard	{"query":{}}	2025-08-10 15:53:11.917+01	\N	\N	\N
1459	1	GET /dashboard	{"query":{}}	2025-08-10 16:01:11.909+01	\N	\N	\N
1483	1	GET /templates	{"query":{}}	2025-08-11 07:48:54.728+01	\N	\N	\N
1501	1	GET /templates	{"query":{}}	2025-08-11 08:04:27.486+01	\N	\N	\N
1518	1	GET /permissions/role/1	{"query":{}}	2025-08-11 08:09:14.583+01	\N	\N	\N
1520	1	GET /permissions/role/3	{"query":{}}	2025-08-11 08:09:14.697+01	\N	\N	\N
1537	1	PUT /templates/20	{"body":{"name":"monitor.sh","template_content":"#!/bin/bash\\r\\n\\r\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\r\\nmkdir -p /opt/monitoring\\r\\n\\r\\n# 📦 Créer le script de surveillance système\\r\\ncat <<'EOS' > /opt/monitoring/status.sh\\r\\n#!/bin/bash\\r\\n\\r\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\r\\nif [ -f /etc/instance-info.conf ]; then\\r\\n  source /etc/instance-info.conf\\r\\nfi\\r\\n\\r\\nTIMESTAMP=$(date -Iseconds)\\r\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\r\\nHOSTNAME=$(hostname)\\r\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\r\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\r\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\r\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\r\\n\\r\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\r\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\r\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\r\\n\\r\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\r\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\r\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\r\\n\\r\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\r\\n\\r\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s},\\", $1, $2, $3}')\\r\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\r\\n\\r\\ncat <<JSON > /opt/monitoring/status.json\\r\\n{\\r\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\r\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\r\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\r\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\r\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\r\\n  \\"memory\\": {\\r\\n    \\"total_kb\\": ${MEM_TOTAL},\\r\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\r\\n  },\\r\\n  \\"disk\\": {\\r\\n    \\"total_bytes\\": ${DISK_TOTAL},\\r\\n    \\"used_bytes\\": ${DISK_USED},\\r\\n    \\"available_bytes\\": ${DISK_AVAIL}\\r\\n  },\\r\\n  \\"network\\": {\\r\\n    \\"interface\\": \\"${IFACE}\\",\\r\\n    \\"rx_bytes\\": ${RX_BYTES},\\r\\n    \\"tx_bytes\\": ${TX_BYTES}\\r\\n  },\\r\\n  \\"open_ports\\": [${OPEN_PORTS}],\\r\\n  \\"top_processes\\": ${TOP_PROCESSES}\\r\\n}\\r\\nJSON\\r\\nEOS\\r\\n\\r\\nchmod +x /opt/monitoring/status.sh\\r\\n\\r\\n# 🕔 Ajout au cron (évite les doublons)\\r\\ngrep -q \\"status.sh\\" /etc/crontab || echo \\"*/5 * * * * root /opt/monitoring/status.sh\\" >> /etc/crontab\\r\\n"},"query":{}}	2025-08-11 08:11:55.207+01	\N	\N	\N
1538	1	update_template:20	{}	2025-08-11 08:11:55.259+01	\N	\N	\N
1550	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 10:20:01.141+01	\N	\N	\N
1567	1	GET /auth/me	{"query":{}}	2025-08-11 10:25:40.478+01	\N	\N	\N
1568	1	GET /auth/me	{"query":{}}	2025-08-11 10:25:40.522+01	\N	\N	\N
1583	1	GET /templates	{"query":{}}	2025-08-11 11:15:35.421+01	\N	\N	\N
1584	1	GET /templates	{"query":{}}	2025-08-11 11:15:35.484+01	\N	\N	\N
1602	1	GET /users	{"query":{}}	2025-08-11 11:25:57.42+01	\N	\N	\N
1617	1	GET /dashboard/map	{"query":{}}	2025-08-11 11:45:47.42+01	\N	\N	\N
1618	1	GET /dashboard/map	{"query":{}}	2025-08-11 11:45:47.499+01	\N	\N	\N
1631	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-11 11:49:55.261+01	\N	\N	\N
1632	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-11 11:49:55.321+01	\N	\N	\N
1633	1	GET /roles	{"query":{}}	2025-08-11 11:49:55.357+01	\N	\N	\N
1635	1	GET /permissions/role/2	{"query":{}}	2025-08-11 11:49:55.472+01	\N	\N	\N
1636	1	GET /permissions/role/3	{"query":{}}	2025-08-11 11:49:55.508+01	\N	\N	\N
1638	1	GET /permissions/role/2	{"query":{}}	2025-08-11 11:49:55.64+01	\N	\N	\N
1639	1	GET /permissions/role/1	{"query":{}}	2025-08-11 11:49:55.681+01	\N	\N	\N
1660	1	list_vms	{}	2025-08-11 11:57:43.26+01	\N	\N	\N
1677	1	GET /dashboard/map	{"query":{}}	2025-08-11 13:01:26.569+01	\N	\N	\N
1695	1	GET /templates	{"query":{}}	2025-08-11 13:55:28.471+01	\N	\N	\N
1696	1	GET /templates	{"query":{}}	2025-08-11 13:55:28.532+01	\N	\N	\N
1709	1	GET /dashboard/map	{"query":{}}	2025-08-11 14:28:19.246+01	\N	\N	\N
1710	1	GET /dashboard/map	{"query":{}}	2025-08-11 14:28:19.311+01	\N	\N	\N
1711	1	GET /templates	{"query":{}}	2025-08-11 14:28:27.762+01	\N	\N	\N
1712	1	GET /templates	{"query":{}}	2025-08-11 14:28:27.829+01	\N	\N	\N
1733	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-11 14:36:42.489+01	\N	\N	\N
1734	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-11 14:36:54.638+01	\N	\N	\N
1735	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-11 14:36:59.495+01	\N	\N	\N
1752	1	GET /templates	{"query":{}}	2025-08-11 16:19:58.136+01	\N	\N	\N
1761	1	GET /dashboard/map	{"query":{}}	2025-08-12 03:00:02.274+01	\N	\N	\N
1762	1	GET /dashboard/map	{"query":{}}	2025-08-12 03:00:02.341+01	\N	\N	\N
1771	1	GET /roles	{"query":{}}	2025-08-12 04:22:29.348+01	\N	\N	\N
1773	1	GET /permissions/role/3	{"query":{}}	2025-08-12 04:22:29.431+01	\N	\N	\N
1774	1	GET /permissions/role/1	{"query":{}}	2025-08-12 04:22:29.47+01	\N	\N	\N
1776	1	GET /permissions/role/1	{"query":{}}	2025-08-12 04:22:29.587+01	\N	\N	\N
1798	1	Échec Déploiement Terraform	{}	2025-08-12 04:44:36.616+01	\N	\N	\N
1823	1	GET /templates	{"query":{}}	2025-08-12 05:37:14.281+01	\N	\N	\N
1834	1	GET /dashboard	{"query":{}}	2025-08-12 08:26:45.377+01	\N	\N	\N
1836	1	list_vms	{}	2025-08-12 08:26:45.494+01	\N	\N	\N
1838	1	GET /vms	{"query":{}}	2025-08-12 08:26:51.289+01	\N	\N	\N
1855	1	GET /dashboard/map	{"query":{}}	2025-08-12 12:09:42.207+01	\N	\N	\N
647	1	GET /roles	{"query":{}}	2025-08-09 17:14:27.751+01	\N	\N	\N
648	1	GET /users	{"query":{}}	2025-08-09 17:15:58.358+01	\N	\N	\N
649	1	GET /roles	{"query":{}}	2025-08-09 17:15:58.414+01	\N	\N	\N
650	1	GET /users	{"query":{}}	2025-08-09 17:15:58.499+01	\N	\N	\N
651	1	GET /roles	{"query":{}}	2025-08-09 17:15:58.567+01	\N	\N	\N
652	1	GET /users	{"query":{}}	2025-08-09 17:16:09.072+01	\N	\N	\N
653	1	GET /roles	{"query":{}}	2025-08-09 17:16:09.115+01	\N	\N	\N
654	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 17:19:20.468+01	\N	\N	\N
655	1	login	{"user_id":1}	2025-08-09 17:19:20.646+01	\N	\N	\N
656	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 17:33:03.918+01	\N	\N	\N
657	1	GET /roles	{"query":{}}	2025-08-09 17:33:04.007+01	\N	\N	\N
658	1	GET /permissions/role/2	{"query":{}}	2025-08-09 17:33:04.093+01	\N	\N	\N
659	1	GET /permissions/role/1	{"query":{}}	2025-08-09 17:33:04.137+01	\N	\N	\N
660	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 17:34:02.37+01	\N	\N	\N
661	1	GET /roles	{"query":{}}	2025-08-09 17:34:02.448+01	\N	\N	\N
662	1	GET /permissions/role/2	{"query":{}}	2025-08-09 17:34:02.555+01	\N	\N	\N
663	1	GET /permissions/role/1	{"query":{}}	2025-08-09 17:34:02.6+01	\N	\N	\N
664	1	GET /permissions?page=2&limit=10	{"query":{"page":"2","limit":"10"}}	2025-08-09 17:35:06.146+01	\N	\N	\N
665	1	GET /roles	{"query":{}}	2025-08-09 17:35:06.222+01	\N	\N	\N
666	1	GET /permissions/role/2	{"query":{}}	2025-08-09 17:35:06.299+01	\N	\N	\N
667	1	GET /permissions/role/1	{"query":{}}	2025-08-09 17:35:06.34+01	\N	\N	\N
668	1	GET /roles	{"query":{}}	2025-08-09 17:36:12.974+01	\N	\N	\N
669	1	GET /roles	{"query":{}}	2025-08-09 17:36:13.051+01	\N	\N	\N
670	1	POST /roles	{"body":{"name":"supertest","description":"testeur de roles"},"query":{}}	2025-08-09 17:36:35.905+01	\N	\N	\N
671	1	GET /roles	{"query":{}}	2025-08-09 17:51:52.397+01	\N	\N	\N
672	1	GET /roles	{"query":{}}	2025-08-09 17:52:02.464+01	\N	\N	\N
673	1	PUT /roles/3	{"body":{"name":"gdgdhd","description":"ajaja"},"query":{}}	2025-08-09 17:52:11.835+01	\N	\N	\N
674	1	GET /roles	{"query":{}}	2025-08-09 17:52:21.011+01	\N	\N	\N
675	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 17:53:11.717+01	\N	\N	\N
676	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 17:53:11.773+01	\N	\N	\N
677	1	GET /roles	{"query":{}}	2025-08-09 17:53:11.823+01	\N	\N	\N
678	1	GET /roles	{"query":{}}	2025-08-09 17:53:11.896+01	\N	\N	\N
679	1	GET /permissions/role/2	{"query":{}}	2025-08-09 17:53:11.94+01	\N	\N	\N
680	1	GET /permissions/role/3	{"query":{}}	2025-08-09 17:53:11.984+01	\N	\N	\N
681	1	GET /permissions/role/1	{"query":{}}	2025-08-09 17:53:12.028+01	\N	\N	\N
682	1	GET /permissions/role/2	{"query":{}}	2025-08-09 17:53:12.116+01	\N	\N	\N
683	1	GET /permissions/role/3	{"query":{}}	2025-08-09 17:53:12.156+01	\N	\N	\N
684	1	GET /permissions/role/1	{"query":{}}	2025-08-09 17:53:12.191+01	\N	\N	\N
685	1	GET /roles	{"query":{}}	2025-08-09 17:53:15.244+01	\N	\N	\N
686	1	GET /roles	{"query":{}}	2025-08-09 17:53:15.322+01	\N	\N	\N
687	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 17:53:17.266+01	\N	\N	\N
688	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 17:53:17.322+01	\N	\N	\N
689	1	GET /roles	{"query":{}}	2025-08-09 17:53:17.364+01	\N	\N	\N
690	1	GET /roles	{"query":{}}	2025-08-09 17:53:17.424+01	\N	\N	\N
691	1	GET /permissions/role/2	{"query":{}}	2025-08-09 17:53:17.498+01	\N	\N	\N
692	1	GET /permissions/role/3	{"query":{}}	2025-08-09 17:53:17.56+01	\N	\N	\N
693	1	GET /permissions/role/1	{"query":{}}	2025-08-09 17:53:17.611+01	\N	\N	\N
694	1	GET /permissions/role/2	{"query":{}}	2025-08-09 17:53:17.694+01	\N	\N	\N
695	1	GET /permissions/role/3	{"query":{}}	2025-08-09 17:53:17.737+01	\N	\N	\N
696	1	GET /permissions/role/1	{"query":{}}	2025-08-09 17:53:17.779+01	\N	\N	\N
697	1	GET /users	{"query":{}}	2025-08-09 17:53:28.238+01	\N	\N	\N
698	1	GET /roles	{"query":{}}	2025-08-09 17:53:28.286+01	\N	\N	\N
699	1	GET /users	{"query":{}}	2025-08-09 17:53:28.372+01	\N	\N	\N
700	1	GET /roles	{"query":{}}	2025-08-09 17:53:28.433+01	\N	\N	\N
701	1	GET /users	{"query":{}}	2025-08-09 17:53:59.849+01	\N	\N	\N
702	1	GET /roles	{"query":{}}	2025-08-09 17:53:59.886+01	\N	\N	\N
703	1	GET /users	{"query":{}}	2025-08-09 17:53:59.951+01	\N	\N	\N
704	1	GET /roles	{"query":{}}	2025-08-09 17:54:00.007+01	\N	\N	\N
705	1	GET /users	{"query":{}}	2025-08-09 17:54:18.547+01	\N	\N	\N
706	1	GET /roles	{"query":{}}	2025-08-09 17:54:18.583+01	\N	\N	\N
707	1	GET /users	{"query":{}}	2025-08-09 17:55:59.35+01	\N	\N	\N
708	1	GET /roles	{"query":{}}	2025-08-09 17:55:59.391+01	\N	\N	\N
709	1	Échec Déploiement Terraform	{}	2025-08-09 17:59:47.274+01	\N	\N	\N
710	1	GET /roles	{"query":{}}	2025-08-09 18:02:15.803+01	\N	\N	\N
711	1	GET /roles	{"query":{}}	2025-08-09 18:02:15.897+01	\N	\N	\N
712	1	GET /roles	{"query":{}}	2025-08-09 18:52:10.334+01	\N	\N	\N
713	1	GET /roles	{"query":{}}	2025-08-09 18:52:21.681+01	\N	\N	\N
714	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 18:52:32.181+01	\N	\N	\N
715	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 18:52:32.261+01	\N	\N	\N
716	1	GET /roles	{"query":{}}	2025-08-09 18:52:32.305+01	\N	\N	\N
717	1	GET /roles	{"query":{}}	2025-08-09 18:52:32.38+01	\N	\N	\N
718	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:52:32.449+01	\N	\N	\N
719	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:52:32.508+01	\N	\N	\N
720	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:52:32.571+01	\N	\N	\N
721	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:52:32.668+01	\N	\N	\N
722	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:52:32.727+01	\N	\N	\N
723	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:52:32.778+01	\N	\N	\N
724	1	GET /permissions?page=2&limit=10	{"query":{"page":"2","limit":"10"}}	2025-08-09 18:52:36.809+01	\N	\N	\N
725	1	GET /roles	{"query":{}}	2025-08-09 18:52:36.874+01	\N	\N	\N
726	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:52:36.933+01	\N	\N	\N
727	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:52:36.973+01	\N	\N	\N
728	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:52:37.016+01	\N	\N	\N
729	1	POST /permissions/assign	{"body":[{"role_id":3,"permission_ids":[36]}],"query":{}}	2025-08-09 18:52:48.969+01	\N	\N	\N
730	1	POST /permissions/assign	{"body":[{"role_id":3,"permission_ids":[5]}],"query":{}}	2025-08-09 18:52:56.654+01	\N	\N	\N
731	1	POST /permissions/assign	{"body":[{"role_id":3,"permission_ids":[6]}],"query":{}}	2025-08-09 18:52:57.793+01	\N	\N	\N
732	1	POST /permissions/assign	{"body":[{"role_id":3,"permission_ids":[4]}],"query":{}}	2025-08-09 18:52:59.864+01	\N	\N	\N
733	1	GET /roles	{"query":{}}	2025-08-09 18:53:05.826+01	\N	\N	\N
734	1	GET /roles	{"query":{}}	2025-08-09 18:53:05.899+01	\N	\N	\N
735	1	GET /users	{"query":{}}	2025-08-09 18:53:31.459+01	\N	\N	\N
736	1	GET /roles	{"query":{}}	2025-08-09 18:53:31.505+01	\N	\N	\N
737	1	GET /users	{"query":{}}	2025-08-09 18:53:31.583+01	\N	\N	\N
738	1	GET /roles	{"query":{}}	2025-08-09 18:53:31.64+01	\N	\N	\N
739	1	GET /users/1	{"query":{}}	2025-08-09 18:53:48.888+01	\N	\N	\N
740	1	GET /users/1	{"query":{}}	2025-08-09 18:54:34.516+01	\N	\N	\N
741	1	GET /roles	{"query":{}}	2025-08-09 18:54:37.042+01	\N	\N	\N
742	1	GET /roles	{"query":{}}	2025-08-09 18:54:37.149+01	\N	\N	\N
743	1	POST /users	{"body":{"first_name":"tes","last_name":"test","email":"res@gmail.com","password":"Nexus2023.","role_id":2},"query":{}}	2025-08-09 18:54:53.264+01	\N	\N	\N
744	1	GET /users	{"query":{}}	2025-08-09 18:54:53.628+01	\N	\N	\N
745	1	GET /roles	{"query":{}}	2025-08-09 18:54:53.679+01	\N	\N	\N
746	1	GET /users	{"query":{}}	2025-08-09 18:54:53.736+01	\N	\N	\N
747	1	GET /roles	{"query":{}}	2025-08-09 18:54:53.781+01	\N	\N	\N
748	1	GET /users	{"query":{}}	2025-08-09 18:55:03.703+01	\N	\N	\N
749	1	GET /roles	{"query":{}}	2025-08-09 18:55:03.744+01	\N	\N	\N
750	1	GET /users/3	{"query":{}}	2025-08-09 18:55:11.472+01	\N	\N	\N
751	1	GET /roles	{"query":{}}	2025-08-09 18:55:11.506+01	\N	\N	\N
752	1	GET /users/3	{"query":{}}	2025-08-09 18:55:11.552+01	\N	\N	\N
753	1	GET /roles	{"query":{}}	2025-08-09 18:55:11.591+01	\N	\N	\N
754	1	PUT /users/3	{"body":{"first_name":"tes3","last_name":"test","phone":"","status":"","role_id":2},"query":{}}	2025-08-09 18:55:17.934+01	\N	\N	\N
755	1	GET /users	{"query":{}}	2025-08-09 18:55:18.144+01	\N	\N	\N
756	1	GET /roles	{"query":{}}	2025-08-09 18:55:18.175+01	\N	\N	\N
757	1	GET /users	{"query":{}}	2025-08-09 18:55:18.224+01	\N	\N	\N
758	1	GET /roles	{"query":{}}	2025-08-09 18:55:18.271+01	\N	\N	\N
759	1	GET /users/3	{"query":{}}	2025-08-09 18:55:21.83+01	\N	\N	\N
760	1	GET /users/3	{"query":{}}	2025-08-09 18:55:25.027+01	\N	\N	\N
761	1	GET /roles	{"query":{}}	2025-08-09 18:55:25.062+01	\N	\N	\N
762	1	GET /users/3	{"query":{}}	2025-08-09 18:55:25.109+01	\N	\N	\N
763	1	GET /roles	{"query":{}}	2025-08-09 18:55:25.151+01	\N	\N	\N
764	1	PUT /users/3	{"body":{"first_name":"tes3","last_name":"test","phone":"","status":"inactif","role_id":2},"query":{}}	2025-08-09 18:55:28.751+01	\N	\N	\N
765	1	GET /roles	{"query":{}}	2025-08-09 18:55:28.984+01	\N	\N	\N
766	1	GET /users	{"query":{}}	2025-08-09 18:55:29.032+01	\N	\N	\N
767	1	GET /users	{"query":{}}	2025-08-09 18:55:29.117+01	\N	\N	\N
768	1	GET /roles	{"query":{}}	2025-08-09 18:55:29.151+01	\N	\N	\N
769	1	PATCH /users/3	{"body":{"status":"actif"},"query":{}}	2025-08-09 18:55:35.624+01	\N	\N	\N
770	1	GET /roles	{"query":{}}	2025-08-09 18:58:03.818+01	\N	\N	\N
771	1	GET /roles	{"query":{}}	2025-08-09 18:58:03.889+01	\N	\N	\N
772	1	PUT /roles/3	{"body":{"name":"gdgdhd","description":"de"},"query":{}}	2025-08-09 18:58:14.456+01	\N	\N	\N
773	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 18:58:29.306+01	\N	\N	\N
774	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 18:58:29.373+01	\N	\N	\N
775	1	GET /roles	{"query":{}}	2025-08-09 18:58:29.413+01	\N	\N	\N
776	1	GET /roles	{"query":{}}	2025-08-09 18:58:29.502+01	\N	\N	\N
777	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:58:29.573+01	\N	\N	\N
778	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:58:29.621+01	\N	\N	\N
779	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:58:29.683+01	\N	\N	\N
780	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:58:29.82+01	\N	\N	\N
781	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:58:29.858+01	\N	\N	\N
782	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:58:29.894+01	\N	\N	\N
783	1	GET /roles	{"query":{}}	2025-08-09 18:58:35.731+01	\N	\N	\N
784	1	GET /roles	{"query":{}}	2025-08-09 18:58:35.784+01	\N	\N	\N
785	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 18:58:42.27+01	\N	\N	\N
786	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 18:58:42.324+01	\N	\N	\N
787	1	GET /roles	{"query":{}}	2025-08-09 18:58:42.365+01	\N	\N	\N
788	1	GET /roles	{"query":{}}	2025-08-09 18:58:42.419+01	\N	\N	\N
789	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:58:42.477+01	\N	\N	\N
790	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:58:42.53+01	\N	\N	\N
791	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:58:42.596+01	\N	\N	\N
792	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:58:42.661+01	\N	\N	\N
793	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:58:42.697+01	\N	\N	\N
794	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:58:42.745+01	\N	\N	\N
795	1	POST /permissions	{"body":{"name":"test.analyse","description":"testdanalyse"},"query":{}}	2025-08-09 18:59:15.73+01	\N	\N	\N
796	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 18:59:33.607+01	\N	\N	\N
797	1	GET /roles	{"query":{}}	2025-08-09 18:59:33.662+01	\N	\N	\N
798	1	GET /permissions/role/2	{"query":{}}	2025-08-09 18:59:33.741+01	\N	\N	\N
799	1	GET /permissions/role/3	{"query":{}}	2025-08-09 18:59:33.776+01	\N	\N	\N
800	1	GET /permissions/role/1	{"query":{}}	2025-08-09 18:59:33.809+01	\N	\N	\N
801	1	GET /users	{"query":{}}	2025-08-09 19:00:32.058+01	\N	\N	\N
802	1	GET /roles	{"query":{}}	2025-08-09 19:00:32.101+01	\N	\N	\N
803	1	GET /users	{"query":{}}	2025-08-09 19:00:32.173+01	\N	\N	\N
804	1	GET /roles	{"query":{}}	2025-08-09 19:00:32.222+01	\N	\N	\N
805	1	GET /users/3	{"query":{}}	2025-08-09 19:00:36.911+01	\N	\N	\N
806	1	GET /users/3	{"query":{}}	2025-08-09 19:00:42.009+01	\N	\N	\N
807	1	GET /roles	{"query":{}}	2025-08-09 19:00:42.052+01	\N	\N	\N
808	1	GET /users/3	{"query":{}}	2025-08-09 19:00:42.11+01	\N	\N	\N
809	1	GET /roles	{"query":{}}	2025-08-09 19:00:42.171+01	\N	\N	\N
810	1	PUT /users/3	{"body":{"first_name":"tes3","last_name":"test","phone":"55555555555","status":"actif","role_id":2},"query":{}}	2025-08-09 19:00:46.67+01	\N	\N	\N
811	1	GET /roles	{"query":{}}	2025-08-09 19:00:46.932+01	\N	\N	\N
812	1	GET /users	{"query":{}}	2025-08-09 19:00:46.969+01	\N	\N	\N
813	1	GET /users	{"query":{}}	2025-08-09 19:00:47.044+01	\N	\N	\N
814	1	GET /roles	{"query":{}}	2025-08-09 19:00:47.09+01	\N	\N	\N
815	1	GET /users/3	{"query":{}}	2025-08-09 19:00:48.827+01	\N	\N	\N
816	1	GET /auth/me	{"query":{}}	2025-08-09 19:01:05.346+01	\N	\N	\N
817	1	GET /auth/me	{"query":{}}	2025-08-09 19:01:05.397+01	\N	\N	\N
818	1	GET /settings/account	{"query":{}}	2025-08-09 19:01:15.575+01	\N	\N	\N
819	1	GET /settings/account	{"query":{}}	2025-08-09 19:01:15.633+01	\N	\N	\N
820	\N	POST /auth/request-reset	{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}	2025-08-09 19:01:21.189+01	\N	\N	\N
821	1	request_reset_code	{"user_id":1}	2025-08-09 19:01:26.991+01	\N	\N	\N
822	1	GET /settings/me	{"query":{}}	2025-08-09 19:01:48.441+01	\N	\N	\N
823	1	GET /settings/me	{"query":{}}	2025-08-09 19:01:48.49+01	\N	\N	\N
824	1	GET /users	{"query":{}}	2025-08-09 19:02:25.586+01	\N	\N	\N
825	1	GET /roles	{"query":{}}	2025-08-09 19:02:25.621+01	\N	\N	\N
826	1	GET /users	{"query":{}}	2025-08-09 19:02:25.692+01	\N	\N	\N
827	1	GET /roles	{"query":{}}	2025-08-09 19:02:25.741+01	\N	\N	\N
828	1	GET /roles	{"query":{}}	2025-08-09 19:02:28.441+01	\N	\N	\N
829	1	GET /users/3	{"query":{}}	2025-08-09 19:02:28.493+01	\N	\N	\N
830	1	GET /users/3	{"query":{}}	2025-08-09 19:02:28.56+01	\N	\N	\N
831	1	GET /roles	{"query":{}}	2025-08-09 19:02:28.604+01	\N	\N	\N
832	1	GET /users	{"query":{}}	2025-08-09 19:02:29.742+01	\N	\N	\N
833	1	GET /roles	{"query":{}}	2025-08-09 19:02:29.784+01	\N	\N	\N
834	1	GET /users	{"query":{}}	2025-08-09 19:02:29.846+01	\N	\N	\N
835	1	GET /roles	{"query":{}}	2025-08-09 19:02:29.894+01	\N	\N	\N
836	1	DELETE /users/3	{"query":{}}	2025-08-09 19:02:34.055+01	\N	\N	\N
837	1	GET /users	{"query":{}}	2025-08-09 19:03:00.721+01	\N	\N	\N
838	1	GET /roles	{"query":{}}	2025-08-09 19:03:00.762+01	\N	\N	\N
839	1	PATCH /users/3	{"body":{"status":"actif"},"query":{}}	2025-08-09 19:03:07.26+01	\N	\N	\N
840	1	Déploiement Terraform	{"vm_name":"testweb","service_type":"web_server_nginx","success":true}	2025-08-09 19:07:31.949+01	\N	\N	\N
841	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 19:42:40.324+01	\N	\N	\N
842	1	login	{"user_id":1}	2025-08-09 19:42:40.531+01	\N	\N	\N
843	1	GET /users	{"query":{}}	2025-08-09 19:42:59.749+01	\N	\N	\N
844	1	GET /roles	{"query":{}}	2025-08-09 19:42:59.795+01	\N	\N	\N
845	1	GET /users	{"query":{}}	2025-08-09 19:42:59.904+01	\N	\N	\N
1236	1	GET /templates	{"query":{}}	2025-08-10 10:34:08.208+01	\N	\N	\N
1248	1	GET /templates	{"query":{}}	2025-08-10 11:01:50.785+01	\N	\N	\N
1249	1	GET /templates	{"query":{}}	2025-08-10 11:01:50.85+01	\N	\N	\N
1260	1	GET /templates	{"query":{}}	2025-08-10 11:16:05.805+01	\N	\N	\N
1262	1	GET /templates	{"query":{}}	2025-08-10 11:16:14.917+01	\N	\N	\N
1264	1	GET /templates	{"query":{}}	2025-08-10 11:16:22.381+01	\N	\N	\N
1275	1	GET /templates	{"query":{}}	2025-08-10 11:17:27.293+01	\N	\N	\N
1286	1	GET /templates	{"query":{}}	2025-08-10 11:27:00.51+01	\N	\N	\N
1288	1	GET /templates	{"query":{}}	2025-08-10 11:27:10.919+01	\N	\N	\N
1289	1	GET /templates	{"query":{}}	2025-08-10 11:27:10.987+01	\N	\N	\N
1300	1	GET /templates	{"query":{}}	2025-08-10 11:48:46.299+01	\N	\N	\N
1317	1	GET /dashboard	{"query":{}}	2025-08-10 12:55:38.616+01	\N	\N	\N
1318	1	GET /dashboard	{"query":{}}	2025-08-10 12:55:38.676+01	\N	\N	\N
1331	1	GET /templates	{"query":{}}	2025-08-10 13:03:36.231+01	\N	\N	\N
1332	1	GET /templates	{"query":{}}	2025-08-10 13:03:36.303+01	\N	\N	\N
1340	1	GET /templates	{"query":{}}	2025-08-10 13:07:39.895+01	\N	\N	\N
1341	1	GET /templates	{"query":{}}	2025-08-10 13:07:39.966+01	\N	\N	\N
1354	1	GET /templates	{"query":{}}	2025-08-10 14:02:05.064+01	\N	\N	\N
1355	1	GET /templates	{"query":{}}	2025-08-10 14:02:05.127+01	\N	\N	\N
1372	1	GET /dashboard	{"query":{}}	2025-08-10 14:34:11.919+01	\N	\N	\N
1380	1	GET /dashboard	{"query":{}}	2025-08-10 14:42:12.045+01	\N	\N	\N
1388	1	GET /dashboard	{"query":{}}	2025-08-10 14:50:11.915+01	\N	\N	\N
1396	1	GET /dashboard	{"query":{}}	2025-08-10 14:58:11.942+01	\N	\N	\N
1404	1	GET /dashboard	{"query":{}}	2025-08-10 15:06:11.912+01	\N	\N	\N
1412	1	GET /dashboard	{"query":{}}	2025-08-10 15:14:11.942+01	\N	\N	\N
1420	1	GET /dashboard	{"query":{}}	2025-08-10 15:22:11.925+01	\N	\N	\N
1428	1	GET /dashboard	{"query":{}}	2025-08-10 15:30:11.937+01	\N	\N	\N
1436	1	GET /dashboard	{"query":{}}	2025-08-10 15:38:11.937+01	\N	\N	\N
1444	1	GET /dashboard	{"query":{}}	2025-08-10 15:46:11.917+01	\N	\N	\N
1452	1	GET /dashboard	{"query":{}}	2025-08-10 15:54:11.922+01	\N	\N	\N
1460	1	GET /dashboard	{"query":{}}	2025-08-10 16:02:11.922+01	\N	\N	\N
1484	1	GET /templates	{"query":{}}	2025-08-11 07:48:57.359+01	\N	\N	\N
1502	1	GET /templates	{"query":{}}	2025-08-11 08:08:49.738+01	\N	\N	\N
1503	1	GET /templates	{"query":{}}	2025-08-11 08:08:49.791+01	\N	\N	\N
1522	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-11 08:09:42.7+01	\N	\N	\N
1539	1	GET /settings/account	{"query":{}}	2025-08-11 08:13:40.795+01	\N	\N	\N
1540	1	GET /settings/account	{"query":{}}	2025-08-11 08:13:40.85+01	\N	\N	\N
1551	1	terminal_list_vms	{}	2025-08-11 10:20:02.892+01	\N	\N	\N
1552	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 10:20:02.954+01	\N	\N	\N
1569	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 10:26:05.958+01	\N	\N	\N
1585	1	GET /templates	{"query":{}}	2025-08-11 11:23:48.184+01	\N	\N	\N
1586	1	GET /templates	{"query":{}}	2025-08-11 11:23:48.231+01	\N	\N	\N
1603	1	GET /roles	{"query":{}}	2025-08-11 11:25:57.452+01	\N	\N	\N
1605	1	GET /roles	{"query":{}}	2025-08-11 11:25:57.535+01	\N	\N	\N
1619	1	POST /vms/104/stop	{"query":{}}	2025-08-11 11:46:52.501+01	\N	\N	\N
1620	1	stop_vm:104	{}	2025-08-11 11:46:52.545+01	\N	\N	\N
1634	1	GET /roles	{"query":{}}	2025-08-11 11:49:55.433+01	\N	\N	\N
1637	1	GET /permissions/role/1	{"query":{}}	2025-08-11 11:49:55.548+01	\N	\N	\N
1640	1	GET /permissions/role/3	{"query":{}}	2025-08-11 11:49:55.743+01	\N	\N	\N
1641	1	GET /roles	{"query":{}}	2025-08-11 11:50:04.145+01	\N	\N	\N
1643	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 11:50:10.881+01	\N	\N	\N
1644	1	terminal_list_vms	{}	2025-08-11 11:50:10.957+01	\N	\N	\N
1645	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 11:50:10.995+01	\N	\N	\N
1661	1	GET /dashboard/map	{"query":{}}	2025-08-11 12:08:37.994+01	\N	\N	\N
1662	1	GET /dashboard/map	{"query":{}}	2025-08-11 12:08:38.064+01	\N	\N	\N
1678	1	GET /dashboard	{"query":{}}	2025-08-11 13:02:58.859+01	\N	\N	\N
1680	1	list_vms	{}	2025-08-11 13:02:58.93+01	\N	\N	\N
1681	1	GET /vms	{"query":{}}	2025-08-11 13:02:59.003+01	\N	\N	\N
1697	1	POST /vms/105/start	{"query":{}}	2025-08-11 13:57:50.604+01	\N	\N	\N
1698	1	start_vm:105	{}	2025-08-11 13:57:50.642+01	\N	\N	\N
1713	1	GET /dashboard	{"query":{}}	2025-08-11 14:29:03.203+01	\N	\N	\N
1714	1	GET /vms	{"query":{}}	2025-08-11 14:29:03.205+01	\N	\N	\N
1715	1	list_vms	{}	2025-08-11 14:29:03.264+01	\N	\N	\N
1716	1	GET /vms	{"query":{}}	2025-08-11 14:29:03.318+01	\N	\N	\N
1736	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-11 14:37:44.224+01	\N	\N	\N
1753	1	GET /templates	{"query":{}}	2025-08-11 16:20:55.742+01	\N	\N	\N
1763	1	GET /dashboard/map	{"query":{}}	2025-08-12 03:16:24.296+01	\N	\N	\N
1778	1	GET /roles	{"query":{}}	2025-08-12 04:22:59.174+01	\N	\N	\N
1779	1	GET /roles	{"query":{}}	2025-08-12 04:22:59.246+01	\N	\N	\N
1799	1	Échec Déploiement Terraform	{}	2025-08-12 04:45:30.723+01	\N	\N	\N
1815	1	POST /templates	{"body":{"name":"Cron des scripts de monitoring","service_type":"monitoring__cron","category":"monitoring","description":"Installe un cron job minuteur qui attend la présence des scripts de monitoring, les exécute, crée leurs crons définitifs puis se désinstalle.","template_content":"#!/bin/bash\\nset -euo pipefail\\n\\n# === Variables substituées par le moteur de template ===\\nSCRIPT_PATH=\\"${SCRIPT_PATH}\\"\\nSTATUS_SCRIPT_PATH=\\"${STATUS_SCRIPT_PATH}\\"\\nSERVICES_SCRIPT_PATH=\\"${SERVICES_SCRIPT_PATH}\\"\\nSTATUS_CRON_EXPR='${STATUS_CRON_EXPR}'\\nSERVICES_CRON_EXPR='${SERVICES_CRON_EXPR}'\\nCRON_USER='${CRON_USER}'\\n\\nMONITOR_DIR=\\"$(dirname \\"${STATUS_SCRIPT_PATH}\\")\\"\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nmkdir -p \\"${MONITOR_DIR}\\"\\n\\n# --- Génère le script  ---\\ncat > \\"${SCRIPT_PATH}\\" <<'EOS'\\n#!/bin/bash\\nset -euo pipefail\\n\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\nCRON_USER='__CRON_USER__'\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nexists_and_exec() {\\n  local f=\\"$1\\"\\n  [[ -f \\"$f\\" ]] || return 1\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\n  return 0\\n}\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\n\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nremove_mark() {\\n  local mark=\\"$1\\"\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\n}\\n\\nok=1\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nelse\\n  ok=0\\nfi\\n\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nelse\\n  ok=0\\nfi\\n\\nif [[ \\"$ok\\" -eq 1 ]]; then\\n  # Exécuter une première fois pour générer les JSON immédiatement\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\n  # Se retirer du crontab\\n  remove_mark \\"$MARK_BOOT\\"\\nfi\\nEOS\\n\\n# Injecte les variables réelles dans le \\nsed -i \\\\\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__CRON_USER__#${CRON_USER}#g\\" \\\\\\n  \\"${SCRIPT_PATH}\\"\\n\\nchmod +x \\"${SCRIPT_PATH}\\"\\n\\n# --- (Ré)active le service cron/ crond ---\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\nfi\\n\\n# --- Installe le cron  (toutes les minutes) ---\\ncurrent_cron=\\"$(crontab -u \\"${CRON_USER}\\" -l 2>/dev/null || true)\\"\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * ${SCRIPT_PATH} $MARK_BOOT\\"; } | crontab -u \\"${CRON_USER}\\" -\\nfi\\n\\nexit 0\\n","script_path":"/scripts/install_monitoring_cron.sh","fields_schema":{"fields":[{"name":"SCRIPT_PATH","label":"Chemin du script ","type":"text","required":true,"default":"/opt/monitoring/monitoring.sh"},{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_EXPR","label":"Cron du script status","type":"text","required":true,"default":"*/1 * * * *"},{"name":"SERVICES_CRON_EXPR","label":"Cron du script services","type":"text","required":true,"default":"*/1 * * * *"},{"name":"CRON_USER","label":"Utilisateur cron","type":"text","required":true,"default":"root"}]}},"query":{}}	2025-08-12 05:36:17.465+01	\N	\N	\N
1816	1	create_template:25	{}	2025-08-12 05:36:17.485+01	\N	\N	\N
1824	1	GET /templates	{"query":{}}	2025-08-12 05:37:14.332+01	\N	\N	\N
1835	1	GET /vms	{"query":{}}	2025-08-12 08:26:45.387+01	\N	\N	\N
1837	1	GET /dashboard	{"query":{}}	2025-08-12 08:26:51.287+01	\N	\N	\N
1839	1	list_vms	{}	2025-08-12 08:26:51.321+01	\N	\N	\N
1856	1	GET /dashboard/map	{"query":{}}	2025-08-12 12:09:42.279+01	\N	\N	\N
1866	1	GET /templates?status=supprime	{"query":{"status":"supprime"}}	2025-08-12 12:23:28.764+01	\N	\N	\N
1869	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 12:23:38.788+01	\N	\N	\N
1875	1	POST /vms/105/start	{"query":{}}	2025-08-12 12:36:45.318+01	\N	\N	\N
1876	1	start_vm:105	{}	2025-08-12 12:36:45.363+01	\N	\N	\N
846	1	GET /roles	{"query":{}}	2025-08-09 19:42:59.956+01	\N	\N	\N
847	1	GET /users	{"query":{}}	2025-08-09 19:43:43.522+01	\N	\N	\N
848	1	GET /roles	{"query":{}}	2025-08-09 19:43:43.566+01	\N	\N	\N
849	1	GET /users	{"query":{}}	2025-08-09 19:48:09.256+01	\N	\N	\N
850	1	GET /roles	{"query":{}}	2025-08-09 19:48:09.31+01	\N	\N	\N
851	1	GET /users	{"query":{}}	2025-08-09 19:48:12.389+01	\N	\N	\N
852	1	GET /roles	{"query":{}}	2025-08-09 19:48:12.451+01	\N	\N	\N
853	1	GET /users	{"query":{}}	2025-08-09 19:48:23.442+01	\N	\N	\N
854	1	GET /roles	{"query":{}}	2025-08-09 19:48:23.493+01	\N	\N	\N
855	1	GET /users	{"query":{}}	2025-08-09 19:48:26.287+01	\N	\N	\N
856	1	GET /roles	{"query":{}}	2025-08-09 19:48:26.356+01	\N	\N	\N
857	1	GET /users	{"query":{}}	2025-08-09 19:48:43.33+01	\N	\N	\N
858	1	GET /roles	{"query":{}}	2025-08-09 19:48:43.38+01	\N	\N	\N
859	1	GET /users	{"query":{}}	2025-08-09 19:48:44.923+01	\N	\N	\N
860	1	GET /roles	{"query":{}}	2025-08-09 19:48:44.967+01	\N	\N	\N
861	1	GET /users	{"query":{}}	2025-08-09 19:48:47.968+01	\N	\N	\N
862	1	GET /roles	{"query":{}}	2025-08-09 19:48:48.017+01	\N	\N	\N
863	1	GET /users	{"query":{}}	2025-08-09 19:48:51.168+01	\N	\N	\N
864	1	GET /roles	{"query":{}}	2025-08-09 19:48:51.21+01	\N	\N	\N
865	1	GET /users	{"query":{}}	2025-08-09 19:49:11.946+01	\N	\N	\N
866	1	GET /roles	{"query":{}}	2025-08-09 19:49:11.993+01	\N	\N	\N
867	1	GET /users	{"query":{}}	2025-08-09 19:49:17.453+01	\N	\N	\N
868	1	GET /roles	{"query":{}}	2025-08-09 19:49:17.509+01	\N	\N	\N
869	1	GET /users	{"query":{}}	2025-08-09 19:49:46.174+01	\N	\N	\N
870	1	GET /roles	{"query":{}}	2025-08-09 19:49:46.212+01	\N	\N	\N
871	1	GET /users/3	{"query":{}}	2025-08-09 19:49:53.648+01	\N	\N	\N
872	1	GET /users/3	{"query":{}}	2025-08-09 19:50:00.861+01	\N	\N	\N
873	1	GET /roles	{"query":{}}	2025-08-09 19:50:00.899+01	\N	\N	\N
874	1	GET /users/3	{"query":{}}	2025-08-09 19:50:00.977+01	\N	\N	\N
875	1	GET /roles	{"query":{}}	2025-08-09 19:50:01.02+01	\N	\N	\N
876	1	GET /roles	{"query":{}}	2025-08-09 19:50:05.521+01	\N	\N	\N
877	1	GET /users	{"query":{}}	2025-08-09 19:50:05.568+01	\N	\N	\N
878	1	GET /roles	{"query":{}}	2025-08-09 19:50:05.637+01	\N	\N	\N
879	1	GET /users	{"query":{}}	2025-08-09 19:50:05.673+01	\N	\N	\N
880	1	GET /roles	{"query":{}}	2025-08-09 19:50:19.985+01	\N	\N	\N
881	1	GET /roles	{"query":{}}	2025-08-09 19:50:20.07+01	\N	\N	\N
882	1	GET /roles	{"query":{}}	2025-08-09 19:50:21.212+01	\N	\N	\N
883	1	GET /users	{"query":{}}	2025-08-09 19:50:21.244+01	\N	\N	\N
884	1	GET /roles	{"query":{}}	2025-08-09 19:50:21.302+01	\N	\N	\N
885	1	GET /users	{"query":{}}	2025-08-09 19:50:21.341+01	\N	\N	\N
886	1	GET /roles	{"query":{}}	2025-08-09 19:50:23.773+01	\N	\N	\N
887	1	GET /roles	{"query":{}}	2025-08-09 19:50:23.827+01	\N	\N	\N
888	1	GET /users	{"query":{}}	2025-08-09 19:50:27.016+01	\N	\N	\N
889	1	GET /roles	{"query":{}}	2025-08-09 19:50:27.055+01	\N	\N	\N
890	1	GET /users	{"query":{}}	2025-08-09 19:50:27.114+01	\N	\N	\N
891	1	GET /roles	{"query":{}}	2025-08-09 19:50:27.165+01	\N	\N	\N
892	1	GET /roles	{"query":{}}	2025-08-09 19:50:31.963+01	\N	\N	\N
893	1	GET /roles	{"query":{}}	2025-08-09 19:50:32.007+01	\N	\N	\N
894	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 19:50:37.81+01	\N	\N	\N
895	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 19:50:37.859+01	\N	\N	\N
896	1	GET /roles	{"query":{}}	2025-08-09 19:50:37.902+01	\N	\N	\N
897	1	GET /roles	{"query":{}}	2025-08-09 19:50:37.954+01	\N	\N	\N
898	1	GET /permissions/role/2	{"query":{}}	2025-08-09 19:50:37.997+01	\N	\N	\N
899	1	GET /permissions/role/3	{"query":{}}	2025-08-09 19:50:38.045+01	\N	\N	\N
900	1	GET /permissions/role/1	{"query":{}}	2025-08-09 19:50:38.083+01	\N	\N	\N
901	1	GET /permissions/role/2	{"query":{}}	2025-08-09 19:50:38.185+01	\N	\N	\N
902	1	GET /permissions/role/3	{"query":{}}	2025-08-09 19:50:38.23+01	\N	\N	\N
903	1	GET /permissions/role/1	{"query":{}}	2025-08-09 19:50:38.276+01	\N	\N	\N
904	1	GET /roles	{"query":{}}	2025-08-09 19:50:39.345+01	\N	\N	\N
905	1	GET /roles	{"query":{}}	2025-08-09 19:50:39.405+01	\N	\N	\N
906	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 19:55:20.23+01	\N	\N	\N
907	1	GET /roles	{"query":{}}	2025-08-09 19:55:20.315+01	\N	\N	\N
908	1	GET /permissions/role/2	{"query":{}}	2025-08-09 19:55:20.421+01	\N	\N	\N
909	1	GET /permissions/role/1	{"query":{}}	2025-08-09 19:55:20.465+01	\N	\N	\N
910	1	GET /permissions/role/3	{"query":{}}	2025-08-09 19:55:20.527+01	\N	\N	\N
911	1	GET /roles	{"query":{}}	2025-08-09 19:55:43.074+01	\N	\N	\N
912	1	GET /roles	{"query":{}}	2025-08-09 19:56:34.441+01	\N	\N	\N
913	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 19:56:55.077+01	\N	\N	\N
914	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 19:56:55.135+01	\N	\N	\N
915	1	GET /roles	{"query":{}}	2025-08-09 19:56:55.179+01	\N	\N	\N
916	1	GET /roles	{"query":{}}	2025-08-09 19:56:55.252+01	\N	\N	\N
917	1	GET /permissions/role/2	{"query":{}}	2025-08-09 19:56:55.304+01	\N	\N	\N
918	1	GET /permissions/role/1	{"query":{}}	2025-08-09 19:56:55.342+01	\N	\N	\N
919	1	GET /permissions/role/3	{"query":{}}	2025-08-09 19:56:55.379+01	\N	\N	\N
920	1	GET /permissions/role/1	{"query":{}}	2025-08-09 19:56:55.449+01	\N	\N	\N
921	1	GET /permissions/role/2	{"query":{}}	2025-08-09 19:56:55.493+01	\N	\N	\N
922	1	GET /permissions/role/3	{"query":{}}	2025-08-09 19:56:55.554+01	\N	\N	\N
923	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 19:57:31.843+01	\N	\N	\N
924	1	GET /roles	{"query":{}}	2025-08-09 19:57:31.949+01	\N	\N	\N
925	1	GET /permissions/role/2	{"query":{}}	2025-08-09 19:57:32.06+01	\N	\N	\N
926	1	GET /permissions/role/3	{"query":{}}	2025-08-09 19:57:32.103+01	\N	\N	\N
927	1	GET /permissions/role/1	{"query":{}}	2025-08-09 19:57:32.146+01	\N	\N	\N
928	1	GET /permissions?page=2&limit=10	{"query":{"page":"2","limit":"10"}}	2025-08-09 20:00:05.999+01	\N	\N	\N
929	1	GET /roles	{"query":{}}	2025-08-09 20:00:06.078+01	\N	\N	\N
930	1	GET /permissions/role/2	{"query":{}}	2025-08-09 20:00:06.187+01	\N	\N	\N
931	1	GET /permissions/role/3	{"query":{}}	2025-08-09 20:00:06.23+01	\N	\N	\N
932	1	GET /permissions/role/1	{"query":{}}	2025-08-09 20:00:06.278+01	\N	\N	\N
933	1	GET /permissions?page=3&limit=10	{"query":{"page":"3","limit":"10"}}	2025-08-09 20:00:07.525+01	\N	\N	\N
934	1	GET /roles	{"query":{}}	2025-08-09 20:00:07.592+01	\N	\N	\N
935	1	GET /permissions/role/2	{"query":{}}	2025-08-09 20:00:07.661+01	\N	\N	\N
936	1	GET /permissions/role/3	{"query":{}}	2025-08-09 20:00:07.7+01	\N	\N	\N
937	1	GET /permissions/role/1	{"query":{}}	2025-08-09 20:00:07.74+01	\N	\N	\N
938	1	GET /permissions?page=4&limit=10	{"query":{"page":"4","limit":"10"}}	2025-08-09 20:00:08.788+01	\N	\N	\N
939	1	GET /roles	{"query":{}}	2025-08-09 20:00:08.854+01	\N	\N	\N
940	1	GET /permissions/role/2	{"query":{}}	2025-08-09 20:00:08.916+01	\N	\N	\N
941	1	GET /permissions/role/3	{"query":{}}	2025-08-09 20:00:08.953+01	\N	\N	\N
942	1	GET /permissions/role/1	{"query":{}}	2025-08-09 20:00:08.996+01	\N	\N	\N
943	1	GET /permissions?page=5&limit=10	{"query":{"page":"5","limit":"10"}}	2025-08-09 20:00:09.922+01	\N	\N	\N
944	1	GET /roles	{"query":{}}	2025-08-09 20:00:09.985+01	\N	\N	\N
945	1	GET /permissions/role/2	{"query":{}}	2025-08-09 20:00:10.047+01	\N	\N	\N
946	1	GET /permissions/role/3	{"query":{}}	2025-08-09 20:00:10.088+01	\N	\N	\N
947	1	GET /permissions/role/1	{"query":{}}	2025-08-09 20:00:10.127+01	\N	\N	\N
948	1	GET /permissions?page=6&limit=10	{"query":{"page":"6","limit":"10"}}	2025-08-09 20:00:10.637+01	\N	\N	\N
949	1	GET /roles	{"query":{}}	2025-08-09 20:00:10.693+01	\N	\N	\N
950	1	GET /permissions/role/2	{"query":{}}	2025-08-09 20:00:10.755+01	\N	\N	\N
955	1	GET /permissions/role/2	{"query":{}}	2025-08-09 20:00:11.748+01	\N	\N	\N
960	1	GET /permissions/role/2	{"query":{}}	2025-08-09 20:00:14.297+01	\N	\N	\N
1237	1	GET /templates	{"query":{}}	2025-08-10 10:40:01.212+01	\N	\N	\N
1238	1	GET /templates	{"query":{}}	2025-08-10 10:40:01.305+01	\N	\N	\N
1250	1	GET /templates	{"query":{}}	2025-08-10 11:01:51.745+01	\N	\N	\N
1252	1	GET /templates	{"query":{}}	2025-08-10 11:01:57.042+01	\N	\N	\N
1261	1	GET /templates	{"query":{}}	2025-08-10 11:16:05.862+01	\N	\N	\N
1263	1	GET /templates	{"query":{}}	2025-08-10 11:16:14.967+01	\N	\N	\N
1265	1	GET /templates	{"query":{}}	2025-08-10 11:16:22.453+01	\N	\N	\N
1276	1	GET /templates	{"query":{}}	2025-08-10 11:23:08.812+01	\N	\N	\N
1277	1	GET /templates	{"query":{}}	2025-08-10 11:23:08.878+01	\N	\N	\N
1287	1	GET /templates	{"query":{}}	2025-08-10 11:27:00.578+01	\N	\N	\N
1301	1	GET /templates	{"query":{}}	2025-08-10 11:48:46.369+01	\N	\N	\N
1319	1	GET /dashboard	{"query":{}}	2025-08-10 12:57:44.861+01	\N	\N	\N
1320	1	GET /dashboard	{"query":{}}	2025-08-10 12:57:44.93+01	\N	\N	\N
1321	1	GET /dashboard	{"query":{}}	2025-08-10 12:57:54.795+01	\N	\N	\N
1333	1	GET /templates	{"query":{}}	2025-08-10 13:03:46.172+01	\N	\N	\N
1342	1	GET /templates	{"query":{}}	2025-08-10 13:08:14.153+01	\N	\N	\N
1343	1	GET /templates	{"query":{}}	2025-08-10 13:08:14.226+01	\N	\N	\N
1356	1	GET /templates	{"query":{}}	2025-08-10 14:02:13.068+01	\N	\N	\N
1373	1	GET /dashboard	{"query":{}}	2025-08-10 14:35:11.924+01	\N	\N	\N
1381	1	GET /dashboard	{"query":{}}	2025-08-10 14:43:11.962+01	\N	\N	\N
1389	1	GET /dashboard	{"query":{}}	2025-08-10 14:51:11.945+01	\N	\N	\N
1397	1	GET /dashboard	{"query":{}}	2025-08-10 14:59:11.933+01	\N	\N	\N
1405	1	GET /dashboard	{"query":{}}	2025-08-10 15:07:11.973+01	\N	\N	\N
1413	1	GET /dashboard	{"query":{}}	2025-08-10 15:15:11.958+01	\N	\N	\N
1421	1	GET /dashboard	{"query":{}}	2025-08-10 15:23:11.99+01	\N	\N	\N
1429	1	GET /dashboard	{"query":{}}	2025-08-10 15:31:12.023+01	\N	\N	\N
1437	1	GET /dashboard	{"query":{}}	2025-08-10 15:39:11.937+01	\N	\N	\N
1445	1	GET /dashboard	{"query":{}}	2025-08-10 15:47:11.94+01	\N	\N	\N
1453	1	GET /dashboard	{"query":{}}	2025-08-10 15:55:11.932+01	\N	\N	\N
1461	1	GET /dashboard	{"query":{}}	2025-08-10 16:03:11.919+01	\N	\N	\N
1464	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-10 20:33:07.371+01	\N	\N	\N
1465	1	login	{"user_id":1}	2025-08-10 20:33:07.572+01	\N	\N	\N
1466	1	GET /dashboard	{"query":{}}	2025-08-10 20:33:08.067+01	\N	\N	\N
1467	1	GET /dashboard	{"query":{}}	2025-08-10 20:33:08.176+01	\N	\N	\N
1468	1	GET /dashboard	{"query":{}}	2025-08-10 20:33:18.127+01	\N	\N	\N
1469	1	GET /dashboard	{"query":{}}	2025-08-10 20:33:28.076+01	\N	\N	\N
1470	1	GET /dashboard/map	{"query":{}}	2025-08-10 20:33:28.949+01	\N	\N	\N
1471	1	GET /dashboard/map	{"query":{}}	2025-08-10 20:33:29.002+01	\N	\N	\N
1485	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123"},"query":{}}	2025-08-11 07:50:48.889+01	\N	\N	\N
1486	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-11 07:50:58.551+01	\N	\N	\N
1487	1	login	{"user_id":1}	2025-08-11 07:50:58.662+01	\N	\N	\N
1488	1	GET /dashboard	{"query":{}}	2025-08-11 07:51:00.62+01	\N	\N	\N
1489	1	GET /dashboard	{"query":{}}	2025-08-11 07:51:00.749+01	\N	\N	\N
1490	1	GET /dashboard	{"query":{}}	2025-08-11 07:51:10.627+01	\N	\N	\N
1491	1	GET /dashboard/map	{"query":{}}	2025-08-11 07:51:10.775+01	\N	\N	\N
1492	1	GET /dashboard/map	{"query":{}}	2025-08-11 07:51:10.832+01	\N	\N	\N
1504	1	GET /templates	{"query":{}}	2025-08-11 08:08:55.594+01	\N	\N	\N
1523	1	GET /logs?page=1&pageSize=50	{"query":{"page":"1","pageSize":"50"}}	2025-08-11 08:10:03.571+01	\N	\N	\N
1541	1	GET /settings/account	{"query":{}}	2025-08-11 10:09:09.541+01	\N	\N	\N
1553	1	terminal_list_vms	{}	2025-08-11 10:20:03.897+01	\N	\N	\N
1554	1	POST /terminal/ssh/test	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus"},"query":{}}	2025-08-11 10:20:09.485+01	\N	\N	\N
1555	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ip a"},"query":{}}	2025-08-11 10:20:15.858+01	\N	\N	\N
1556	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-11 10:20:19.21+01	\N	\N	\N
1557	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /etc"},"query":{}}	2025-08-11 10:20:25.823+01	\N	\N	\N
1558	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-11 10:20:31.112+01	\N	\N	\N
1570	1	terminal_list_vms	{}	2025-08-11 10:26:07.884+01	\N	\N	\N
1571	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 10:26:07.933+01	\N	\N	\N
1587	1	GET /templates	{"query":{}}	2025-08-11 11:23:55.189+01	\N	\N	\N
1589	1	GET /templates	{"query":{}}	2025-08-11 11:23:55.392+01	\N	\N	\N
1604	1	GET /users	{"query":{}}	2025-08-11 11:25:57.503+01	\N	\N	\N
1621	1	POST /vms/101/stop	{"query":{}}	2025-08-11 11:47:13.996+01	\N	\N	\N
1622	1	stop_vm:101	{}	2025-08-11 11:47:14.041+01	\N	\N	\N
1642	1	GET /roles	{"query":{}}	2025-08-11 11:50:04.205+01	\N	\N	\N
1663	1	GET /dashboard/map	{"query":{}}	2025-08-11 12:10:46.541+01	\N	\N	\N
1664	1	GET /dashboard/map	{"query":{}}	2025-08-11 12:10:46.61+01	\N	\N	\N
1679	1	GET /vms	{"query":{}}	2025-08-11 13:02:58.864+01	\N	\N	\N
1682	1	GET /dashboard	{"query":{}}	2025-08-11 13:02:59.059+01	\N	\N	\N
1683	1	list_vms	{}	2025-08-11 13:02:59.074+01	\N	\N	\N
1699	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"c8f4a86e-ca73-44b8-bfca-edf40641cc99"},"query":{}}	2025-08-11 14:17:46.513+01	\N	\N	\N
1717	1	GET /dashboard	{"query":{}}	2025-08-11 14:29:03.363+01	\N	\N	\N
1737	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-11 15:01:47.153+01	\N	\N	\N
1738	1	GET /dashboard	{"query":{}}	2025-08-11 15:01:53.822+01	\N	\N	\N
1739	1	GET /vms	{"query":{}}	2025-08-11 15:01:53.823+01	\N	\N	\N
1740	1	list_vms	{}	2025-08-11 15:01:53.928+01	\N	\N	\N
1741	1	GET /vms	{"query":{}}	2025-08-11 15:01:53.981+01	\N	\N	\N
1754	1	GET /dashboard	{"query":{}}	2025-08-12 02:57:30.23+01	\N	\N	\N
1780	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 04:23:06.625+01	\N	\N	\N
1782	1	GET /roles	{"query":{}}	2025-08-12 04:23:06.742+01	\N	\N	\N
1785	1	GET /permissions/role/3	{"query":{}}	2025-08-12 04:23:06.895+01	\N	\N	\N
1787	1	GET /permissions/role/2	{"query":{}}	2025-08-12 04:23:07.031+01	\N	\N	\N
1800	1	Déploiement Terraform	{"vm_name":"testwebserver","service_type":"monitoring_cron","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-88966679-e8a2-4c48-b948-75ca879e7343.log"}	2025-08-12 04:54:43.917+01	\N	\N	\N
1825	1	POST /templates/generate	{"body":{"template_id":25,"config_data":{"SCRIPT_PATH":"/opt/monitoring/monitoring.sh","STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","STATUS_CRON_EXPR":"*/1 * * * *","SERVICES_CRON_EXPR":"*/1 * * * *","CRON_USER":"nexus"}},"query":{}}	2025-08-12 05:37:40.615+01	\N	\N	\N
1826	1	generate_template_file:25:monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh	{}	2025-08-12 05:37:40.629+01	\N	\N	\N
1840	1	GET /dashboard/map	{"query":{}}	2025-08-12 09:25:23.403+01	\N	\N	\N
1841	1	GET /dashboard/map	{"query":{}}	2025-08-12 09:25:23.505+01	\N	\N	\N
1857	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-12 12:12:04.497+01	\N	\N	\N
951	1	GET /permissions/role/3	{"query":{}}	2025-08-09 20:00:10.797+01	\N	\N	\N
954	1	GET /roles	{"query":{}}	2025-08-09 20:00:11.684+01	\N	\N	\N
956	1	GET /permissions/role/3	{"query":{}}	2025-08-09 20:00:11.81+01	\N	\N	\N
959	1	GET /roles	{"query":{}}	2025-08-09 20:00:14.231+01	\N	\N	\N
961	1	GET /permissions/role/3	{"query":{}}	2025-08-09 20:00:14.335+01	\N	\N	\N
1239	1	GET /templates	{"query":{}}	2025-08-10 10:59:54.239+01	\N	\N	\N
1251	1	GET /templates	{"query":{}}	2025-08-10 11:01:51.814+01	\N	\N	\N
1253	1	GET /templates	{"query":{}}	2025-08-10 11:01:57.1+01	\N	\N	\N
1266	1	GET /templates	{"query":{}}	2025-08-10 11:16:39.615+01	\N	\N	\N
1267	1	GET /templates	{"query":{}}	2025-08-10 11:16:39.675+01	\N	\N	\N
1278	1	GET /templates	{"query":{}}	2025-08-10 11:23:13.017+01	\N	\N	\N
1290	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-10 11:46:55.435+01	\N	\N	\N
1302	1	GET /templates	{"query":{}}	2025-08-10 11:49:44.165+01	\N	\N	\N
1303	1	GET /templates	{"query":{}}	2025-08-10 11:49:44.232+01	\N	\N	\N
1322	1	GET /templates	{"query":{}}	2025-08-10 12:58:12.66+01	\N	\N	\N
1323	1	GET /templates	{"query":{}}	2025-08-10 12:58:12.73+01	\N	\N	\N
1334	1	GET /templates	{"query":{}}	2025-08-10 13:03:46.238+01	\N	\N	\N
1344	1	GET /templates	{"query":{}}	2025-08-10 13:08:21.348+01	\N	\N	\N
1357	1	GET /templates	{"query":{}}	2025-08-10 14:02:13.132+01	\N	\N	\N
1374	1	GET /dashboard	{"query":{}}	2025-08-10 14:36:11.926+01	\N	\N	\N
1382	1	GET /dashboard	{"query":{}}	2025-08-10 14:44:11.927+01	\N	\N	\N
1390	1	GET /dashboard	{"query":{}}	2025-08-10 14:52:11.944+01	\N	\N	\N
1398	1	GET /dashboard	{"query":{}}	2025-08-10 15:00:11.937+01	\N	\N	\N
1406	1	GET /dashboard	{"query":{}}	2025-08-10 15:08:11.919+01	\N	\N	\N
1414	1	GET /dashboard	{"query":{}}	2025-08-10 15:16:11.924+01	\N	\N	\N
1422	1	GET /dashboard	{"query":{}}	2025-08-10 15:24:11.932+01	\N	\N	\N
1430	1	GET /dashboard	{"query":{}}	2025-08-10 15:32:11.934+01	\N	\N	\N
1438	1	GET /dashboard	{"query":{}}	2025-08-10 15:40:11.928+01	\N	\N	\N
1446	1	GET /dashboard	{"query":{}}	2025-08-10 15:48:11.941+01	\N	\N	\N
1454	1	GET /dashboard	{"query":{}}	2025-08-10 15:56:11.915+01	\N	\N	\N
1462	1	GET /dashboard	{"query":{}}	2025-08-10 16:04:11.923+01	\N	\N	\N
1472	1	GET /settings/me	{"query":{}}	2025-08-10 22:08:35.699+01	\N	\N	\N
1473	1	GET /settings/me	{"query":{}}	2025-08-10 22:08:35.749+01	\N	\N	\N
1474	1	GET /settings/account	{"query":{}}	2025-08-10 22:08:42.217+01	\N	\N	\N
1475	1	GET /settings/account	{"query":{}}	2025-08-10 22:08:42.269+01	\N	\N	\N
1493	1	GET /dashboard/map	{"query":{}}	2025-08-11 07:52:00.584+01	\N	\N	\N
1494	1	GET /dashboard/map	{"query":{}}	2025-08-11 07:52:00.638+01	\N	\N	\N
1505	1	GET /templates	{"query":{}}	2025-08-11 08:08:55.648+01	\N	\N	\N
1524	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 08:10:13.532+01	\N	\N	\N
1542	1	GET /dashboard/map	{"query":{}}	2025-08-11 10:09:42.538+01	\N	\N	\N
1543	1	GET /dashboard/map	{"query":{}}	2025-08-11 10:09:42.657+01	\N	\N	\N
1559	1	GET /templates	{"query":{}}	2025-08-11 10:20:42.094+01	\N	\N	\N
1560	1	GET /templates	{"query":{}}	2025-08-11 10:20:42.151+01	\N	\N	\N
1572	1	terminal_list_vms	{}	2025-08-11 10:26:09.889+01	\N	\N	\N
1588	1	GET /templates	{"query":{}}	2025-08-11 11:23:55.255+01	\N	\N	\N
1606	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-11 11:27:00.085+01	\N	\N	\N
1623	1	GET /templates	{"query":{}}	2025-08-11 11:48:10.015+01	\N	\N	\N
1624	1	GET /templates	{"query":{}}	2025-08-11 11:48:10.072+01	\N	\N	\N
1646	1	terminal_list_vms	{}	2025-08-11 11:50:11.053+01	\N	\N	\N
1647	1	POST /terminal/ssh/test	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus"},"query":{}}	2025-08-11 11:50:17.725+01	\N	\N	\N
1648	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ip a"},"query":{}}	2025-08-11 11:50:24.506+01	\N	\N	\N
1649	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /tmp"},"query":{}}	2025-08-11 11:50:28.74+01	\N	\N	\N
1650	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-11 11:50:32.474+01	\N	\N	\N
1665	1	GET /templates	{"query":{}}	2025-08-11 12:34:24.254+01	\N	\N	\N
1666	1	GET /templates	{"query":{}}	2025-08-11 12:34:24.308+01	\N	\N	\N
1684	1	GET /templates	{"query":{}}	2025-08-11 13:05:48.008+01	\N	\N	\N
1685	1	GET /templates	{"query":{}}	2025-08-11 13:05:48.084+01	\N	\N	\N
1700	1	GET /dashboard	{"query":{}}	2025-08-11 14:25:16.533+01	\N	\N	\N
1702	1	list_vms	{}	2025-08-11 14:25:16.58+01	\N	\N	\N
1718	1	list_vms	{}	2025-08-11 14:29:03.376+01	\N	\N	\N
1719	1	GET /dashboard/map	{"query":{}}	2025-08-11 14:29:04.845+01	\N	\N	\N
1720	1	GET /dashboard/map	{"query":{}}	2025-08-11 14:29:04.919+01	\N	\N	\N
1742	1	GET /dashboard	{"query":{}}	2025-08-11 15:01:54.022+01	\N	\N	\N
1755	1	GET /vms	{"query":{}}	2025-08-12 02:57:30.236+01	\N	\N	\N
1764	1	Déploiement Terraform	{"vm_name":"testweb","service_type":"web_server_nginx","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-2025-08-12T02-17-32-683Z-1.log","stdout":"\\u001b[0m\\u001b[1m\\u001b[33mWarning: \\u001b[0m\\u001b[0m\\u001b[1mValues for undeclared variables\\u001b[0m\\n\\u001b[33m│\\u001b[0m \\u001b[0m\\n\\u001b[33m│\\u001b[0m \\u001b[0m\\u001b[0mIn addition to the other similar warnings shown, 2 other variable(s)\\n\\u001b[33m│\\u001b[0m \\u001b[0mdefined without being declared.\\n\\u001b[33m╵\\u001b[0m\\u001b[0m\\n\\u001b[0m\\u001b[1m\\u001b[32m\\nApply complete! Resources: 2 added, 0 changed, 0 destroyed.\\n\\u001b[0m\\u001b[0m\\u001b[1m\\u001b[32m\\nOutputs:\\n\\n\\u001b[0mssh_commands = {\\n  \\"testweb\\" = \\"ssh -i C:/Users/Nexus-PC/.ssh/id_rsa nexus@192.168.24.206\\"\\n}\\nstatus = <<EOT\\n✅ 1 VM(s) déployée(s)\\r\\n📄 Scripts injectés :\\r\\n- testweb : D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\5\\\\testweb-script-1.sh, D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\5\\\\testweb-script-2.sh, D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\5\\\\testweb-script-3.sh, D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\terraform\\\\deployments\\\\5\\\\testweb-script-4.sh\\r\\n\\nEOT\\nvm_ids = {\\n  \\"testweb\\" = 101\\n}\\nvm_ips = {\\n  \\"testweb\\" = \\"192.168.24.206\\"\\n}\\nvm_names = [\\n  \\"testweb\\",\\n]\\n","stderr":""}	2025-08-12 03:19:37.285+01	\N	\N	\N
1781	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 04:23:06.704+01	\N	\N	\N
1784	1	GET /permissions/role/2	{"query":{}}	2025-08-12 04:23:06.841+01	\N	\N	\N
1788	1	GET /permissions/role/3	{"query":{}}	2025-08-12 04:23:07.082+01	\N	\N	\N
1801	1	Déploiement Terraform	{"vm_name":"testweb20122","service_type":"monitoring_cron","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-793826a0-2600-40a4-bdd8-2fd2209e4df9.log"}	2025-08-12 05:22:34.95+01	\N	\N	\N
1827	1	POST /templates/generate	{"body":{"template_id":26,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}	2025-08-12 05:37:54.853+01	\N	\N	\N
1828	1	generate_template_file:26:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh	{}	2025-08-12 05:37:54.867+01	\N	\N	\N
1829	1	POST /templates/generate	{"body":{"template_id":27,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}	2025-08-12 05:38:00.05+01	\N	\N	\N
1842	1	GET /templates	{"query":{}}	2025-08-12 09:26:06.513+01	\N	\N	\N
952	1	GET /permissions/role/1	{"query":{}}	2025-08-09 20:00:10.843+01	\N	\N	\N
953	1	GET /permissions?page=7&limit=10	{"query":{"page":"7","limit":"10"}}	2025-08-09 20:00:11.624+01	\N	\N	\N
957	1	GET /permissions/role/1	{"query":{}}	2025-08-09 20:00:11.858+01	\N	\N	\N
958	1	GET /permissions?page=6&limit=10	{"query":{"page":"6","limit":"10"}}	2025-08-09 20:00:14.176+01	\N	\N	\N
962	1	GET /permissions/role/1	{"query":{}}	2025-08-09 20:00:14.375+01	\N	\N	\N
963	1	GET /roles	{"query":{}}	2025-08-09 20:03:10.33+01	\N	\N	\N
964	1	GET /roles	{"query":{}}	2025-08-09 20:03:10.404+01	\N	\N	\N
965	1	GET /roles	{"query":{}}	2025-08-09 20:03:12.648+01	\N	\N	\N
966	1	GET /users	{"query":{}}	2025-08-09 20:03:12.685+01	\N	\N	\N
967	1	GET /users	{"query":{}}	2025-08-09 20:03:12.737+01	\N	\N	\N
968	1	GET /roles	{"query":{}}	2025-08-09 20:03:12.77+01	\N	\N	\N
969	1	GET /terminal/vms	{"query":{}}	2025-08-09 20:03:42.526+01	\N	\N	\N
970	1	terminal_list_vms	{}	2025-08-09 20:03:42.576+01	\N	\N	\N
971	1	GET /terminal/vms	{"query":{}}	2025-08-09 20:03:42.644+01	\N	\N	\N
972	1	terminal_list_vms	{}	2025-08-09 20:03:42.668+01	\N	\N	\N
973	1	GET /terminal/vms	{"query":{}}	2025-08-09 20:16:58.078+01	\N	\N	\N
974	1	GET /vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 20:34:07.252+01	\N	\N	\N
975	1	list_vms	{}	2025-08-09 20:34:07.313+01	\N	\N	\N
976	1	GET /vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 20:39:00.628+01	\N	\N	\N
977	1	list_vms	{}	2025-08-09 20:39:00.689+01	\N	\N	\N
978	1	GET /vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 20:50:15.159+01	\N	\N	\N
979	1	list_vms	{}	2025-08-09 20:50:15.214+01	\N	\N	\N
980	1	GET /terminal/vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 20:54:56.108+01	\N	\N	\N
981	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 20:55:31.188+01	\N	\N	\N
982	1	login	{"user_id":1}	2025-08-09 20:55:31.394+01	\N	\N	\N
983	1	GET /terminal/vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 20:55:53.844+01	\N	\N	\N
984	1	GET /terminal/vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 20:56:07.254+01	\N	\N	\N
985	1	GET /terminal/vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 21:38:10.629+01	\N	\N	\N
986	1	GET /terminal/vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 21:39:21.741+01	\N	\N	\N
987	1	terminal_list_vms	{}	2025-08-09 21:39:21.819+01	\N	\N	\N
988	1	GET /terminal/vms	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-09 21:44:14.088+01	\N	\N	\N
989	1	terminal_list_vms	{}	2025-08-09 21:44:14.289+01	\N	\N	\N
990	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-09 21:52:07.002+01	\N	\N	\N
991	1	terminal_list_vms	{}	2025-08-09 21:52:07.173+01	\N	\N	\N
992	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-09 22:00:32.731+01	\N	\N	\N
993	1	terminal_list_vms	{}	2025-08-09 22:00:32.865+01	\N	\N	\N
994	1	POST /terminal/ssh/test	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus"},"query":{}}	2025-08-09 22:00:40.97+01	\N	\N	\N
995	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ip a"},"query":{}}	2025-08-09 22:00:59.419+01	\N	\N	\N
996	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"systemctl status bind9"},"query":{}}	2025-08-09 22:01:27.362+01	\N	\N	\N
997	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /tmp"},"query":{}}	2025-08-09 22:01:42.641+01	\N	\N	\N
998	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:01:46.111+01	\N	\N	\N
999	1	POST /terminal/ssh/test	{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus"},"query":{}}	2025-08-09 22:02:26.182+01	\N	\N	\N
1000	1	POST /terminal/ssh/exec	{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"cd /tmp"},"query":{}}	2025-08-09 22:02:32.758+01	\N	\N	\N
1001	1	POST /terminal/ssh/exec	{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:02:36.472+01	\N	\N	\N
1002	1	POST /terminal/ssh/exec	{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"cd /opt"},"query":{}}	2025-08-09 22:02:43.759+01	\N	\N	\N
1003	1	POST /terminal/ssh/exec	{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:02:47.043+01	\N	\N	\N
1004	1	POST /terminal/ssh/test	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus"},"query":{}}	2025-08-09 22:02:54.63+01	\N	\N	\N
1005	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /etc"},"query":{}}	2025-08-09 22:03:01.652+01	\N	\N	\N
1006	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:03:04.968+01	\N	\N	\N
1007	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"mkdir test"},"query":{}}	2025-08-09 22:04:38.588+01	\N	\N	\N
1008	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:04:45.023+01	\N	\N	\N
1009	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd test"},"query":{}}	2025-08-09 22:04:51.726+01	\N	\N	\N
1010	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:04:58.15+01	\N	\N	\N
1011	1	GET /users	{"query":{}}	2025-08-09 22:09:54.178+01	\N	\N	\N
1012	1	GET /roles	{"query":{}}	2025-08-09 22:09:54.226+01	\N	\N	\N
1013	1	GET /users	{"query":{}}	2025-08-09 22:09:54.309+01	\N	\N	\N
1014	1	GET /roles	{"query":{}}	2025-08-09 22:09:54.377+01	\N	\N	\N
1015	1	GET /roles	{"query":{}}	2025-08-09 22:10:01.182+01	\N	\N	\N
1016	1	GET /roles	{"query":{}}	2025-08-09 22:10:01.253+01	\N	\N	\N
1017	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 22:10:04.158+01	\N	\N	\N
1018	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-09 22:10:04.221+01	\N	\N	\N
1019	1	GET /roles	{"query":{}}	2025-08-09 22:10:04.279+01	\N	\N	\N
1020	1	GET /roles	{"query":{}}	2025-08-09 22:10:04.365+01	\N	\N	\N
1021	1	GET /permissions/role/2	{"query":{}}	2025-08-09 22:10:04.439+01	\N	\N	\N
1022	1	GET /permissions/role/3	{"query":{}}	2025-08-09 22:10:04.508+01	\N	\N	\N
1023	1	GET /permissions/role/1	{"query":{}}	2025-08-09 22:10:04.56+01	\N	\N	\N
1024	1	GET /permissions/role/2	{"query":{}}	2025-08-09 22:10:04.637+01	\N	\N	\N
1025	1	GET /permissions/role/3	{"query":{}}	2025-08-09 22:10:04.68+01	\N	\N	\N
1026	1	GET /permissions/role/1	{"query":{}}	2025-08-09 22:10:04.724+01	\N	\N	\N
1027	1	GET /permissions?page=2&limit=10	{"query":{"page":"2","limit":"10"}}	2025-08-09 22:11:14.035+01	\N	\N	\N
1028	1	GET /roles	{"query":{}}	2025-08-09 22:11:14.098+01	\N	\N	\N
1029	1	GET /permissions/role/2	{"query":{}}	2025-08-09 22:11:14.179+01	\N	\N	\N
1030	1	GET /permissions/role/3	{"query":{}}	2025-08-09 22:11:14.216+01	\N	\N	\N
1031	1	GET /permissions/role/1	{"query":{}}	2025-08-09 22:11:14.255+01	\N	\N	\N
1032	1	GET /permissions?page=3&limit=10	{"query":{"page":"3","limit":"10"}}	2025-08-09 22:11:15.14+01	\N	\N	\N
1033	1	GET /roles	{"query":{}}	2025-08-09 22:11:15.203+01	\N	\N	\N
1034	1	GET /permissions/role/2	{"query":{}}	2025-08-09 22:11:15.27+01	\N	\N	\N
1039	1	GET /permissions/role/2	{"query":{}}	2025-08-09 22:11:16.244+01	\N	\N	\N
1044	1	GET /permissions/role/2	{"query":{}}	2025-08-09 22:11:17.107+01	\N	\N	\N
1240	1	GET /templates	{"query":{}}	2025-08-10 11:00:16.404+01	\N	\N	\N
1241	1	GET /templates	{"query":{}}	2025-08-10 11:00:16.468+01	\N	\N	\N
1254	1	GET /templates	{"query":{}}	2025-08-10 11:07:13.102+01	\N	\N	\N
1268	1	GET /templates	{"query":{}}	2025-08-10 11:17:00.549+01	\N	\N	\N
1269	1	GET /templates	{"query":{}}	2025-08-10 11:17:00.612+01	\N	\N	\N
1279	1	GET /templates	{"query":{}}	2025-08-10 11:23:13.086+01	\N	\N	\N
1291	1	terminal_list_vms	{}	2025-08-10 11:46:55.572+01	\N	\N	\N
1292	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-10 11:46:55.632+01	\N	\N	\N
1304	1	GET /templates	{"query":{}}	2025-08-10 11:58:57.658+01	\N	\N	\N
1305	1	GET /templates	{"query":{}}	2025-08-10 11:58:57.733+01	\N	\N	\N
1324	1	GET /templates	{"query":{}}	2025-08-10 12:59:00.649+01	\N	\N	\N
1325	1	GET /templates	{"query":{}}	2025-08-10 12:59:00.718+01	\N	\N	\N
1335	1	POST /templates/simulate	{"body":{"script":"#!/bin/bash\\n\\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\\n\\n# 🔐 Vérifie que les scripts à exécuter existent\\nSTATUS_SCRIPT=\\"${STATUS_SCRIPT}\\"\\nSERVICES_SCRIPT=\\"${SERVICES_SCRIPT}\\"\\n\\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\\nif [ -f \\"$STATUS_SCRIPT\\" ]; then\\n  grep -q \\"$STATUS_SCRIPT\\" /etc/crontab || echo \\"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour status.sh\\"\\nelse\\n  echo \\"❌ Script $STATUS_SCRIPT introuvable\\"\\nfi\\n\\nif [ -f \\"$SERVICES_SCRIPT\\" ]; then\\n  grep -q \\"$SERVICES_SCRIPT\\" /etc/crontab || echo \\"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\\" >> /etc/crontab\\n  echo \\"✅ Cron job ajouté pour services_status.sh\\"\\nelse\\n  echo \\"❌ Script $SERVICES_SCRIPT introuvable\\"\\nfi"},"query":{}}	2025-08-10 13:04:07.412+01	\N	\N	\N
1345	1	GET /templates	{"query":{}}	2025-08-10 13:08:21.405+01	\N	\N	\N
1358	1	GET /templates	{"query":{}}	2025-08-10 14:23:14.936+01	\N	\N	\N
1359	1	GET /templates	{"query":{}}	2025-08-10 14:23:15.004+01	\N	\N	\N
1375	1	GET /dashboard	{"query":{}}	2025-08-10 14:37:11.925+01	\N	\N	\N
1383	1	GET /dashboard	{"query":{}}	2025-08-10 14:45:11.937+01	\N	\N	\N
1391	1	GET /dashboard	{"query":{}}	2025-08-10 14:53:11.928+01	\N	\N	\N
1399	1	GET /dashboard	{"query":{}}	2025-08-10 15:01:11.948+01	\N	\N	\N
1407	1	GET /dashboard	{"query":{}}	2025-08-10 15:09:11.924+01	\N	\N	\N
1415	1	GET /dashboard	{"query":{}}	2025-08-10 15:17:11.931+01	\N	\N	\N
1423	1	GET /dashboard	{"query":{}}	2025-08-10 15:25:11.938+01	\N	\N	\N
1431	1	GET /dashboard	{"query":{}}	2025-08-10 15:33:11.951+01	\N	\N	\N
1439	1	GET /dashboard	{"query":{}}	2025-08-10 15:41:11.926+01	\N	\N	\N
1447	1	GET /dashboard	{"query":{}}	2025-08-10 15:49:11.912+01	\N	\N	\N
1455	1	GET /dashboard	{"query":{}}	2025-08-10 15:57:12.019+01	\N	\N	\N
1463	1	GET /dashboard	{"query":{}}	2025-08-10 16:05:11.924+01	\N	\N	\N
1476	1	GET /templates	{"query":{}}	2025-08-10 23:27:52.357+01	\N	\N	\N
1477	1	GET /templates	{"query":{}}	2025-08-10 23:27:52.436+01	\N	\N	\N
1495	1	GET /templates	{"query":{}}	2025-08-11 07:54:52.087+01	\N	\N	\N
1496	1	GET /templates	{"query":{}}	2025-08-11 07:54:52.148+01	\N	\N	\N
1506	1	GET /users	{"query":{}}	2025-08-11 08:09:05.932+01	\N	\N	\N
1508	1	GET /users	{"query":{}}	2025-08-11 08:09:06.052+01	\N	\N	\N
1525	1	terminal_list_vms	{}	2025-08-11 08:10:15.39+01	\N	\N	\N
1526	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 08:10:15.44+01	\N	\N	\N
1544	1	GET /dashboard	{"query":{}}	2025-08-11 10:10:18.299+01	\N	\N	\N
1545	1	GET /dashboard	{"query":{}}	2025-08-11 10:10:18.382+01	\N	\N	\N
1561	1	GET /templates	{"query":{}}	2025-08-11 10:21:46.043+01	\N	\N	\N
1562	1	GET /templates	{"query":{}}	2025-08-11 10:21:46.106+01	\N	\N	\N
1573	1	GET /dashboard	{"query":{}}	2025-08-11 10:36:59.508+01	\N	\N	\N
1574	1	GET /dashboard	{"query":{}}	2025-08-11 10:36:59.589+01	\N	\N	\N
1590	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-11 11:25:29.601+01	\N	\N	\N
1591	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-11 11:25:29.673+01	\N	\N	\N
1592	1	GET /roles	{"query":{}}	2025-08-11 11:25:29.728+01	\N	\N	\N
1593	1	GET /roles	{"query":{}}	2025-08-11 11:25:29.805+01	\N	\N	\N
1596	1	GET /permissions/role/1	{"query":{}}	2025-08-11 11:25:29.937+01	\N	\N	\N
1599	1	GET /permissions/role/1	{"query":{}}	2025-08-11 11:25:30.088+01	\N	\N	\N
1607	1	GET /templates	{"query":{}}	2025-08-11 11:27:11.629+01	\N	\N	\N
1608	1	GET /templates	{"query":{}}	2025-08-11 11:27:11.682+01	\N	\N	\N
1625	1	GET /templates	{"query":{}}	2025-08-11 11:48:45.541+01	\N	\N	\N
1626	1	GET /templates	{"query":{}}	2025-08-11 11:48:45.601+01	\N	\N	\N
1651	1	GET /templates	{"query":{}}	2025-08-11 11:50:46.754+01	\N	\N	\N
1652	1	GET /templates	{"query":{}}	2025-08-11 11:50:46.832+01	\N	\N	\N
1667	1	GET /users	{"query":{}}	2025-08-11 12:46:25.347+01	\N	\N	\N
1670	1	GET /roles	{"query":{}}	2025-08-11 12:46:25.512+01	\N	\N	\N
1686	1	GET /dashboard/map	{"query":{}}	2025-08-11 13:26:49.606+01	\N	\N	\N
1687	1	GET /dashboard/map	{"query":{}}	2025-08-11 13:26:49.67+01	\N	\N	\N
1688	1	GET /dashboard	{"query":{}}	2025-08-11 13:26:59.997+01	\N	\N	\N
1689	1	GET /vms	{"query":{}}	2025-08-11 13:27:00+01	\N	\N	\N
1692	1	GET /dashboard	{"query":{}}	2025-08-11 13:27:00.219+01	\N	\N	\N
1701	1	GET /vms	{"query":{}}	2025-08-11 14:25:16.534+01	\N	\N	\N
1721	1	GET /settings/account	{"query":{}}	2025-08-11 14:29:18.356+01	\N	\N	\N
1722	1	GET /settings/account	{"query":{}}	2025-08-11 14:29:18.407+01	\N	\N	\N
1723	1	GET /settings/me	{"query":{}}	2025-08-11 14:29:22.017+01	\N	\N	\N
1724	1	GET /settings/me	{"query":{}}	2025-08-11 14:29:22.071+01	\N	\N	\N
1725	1	GET /templates	{"query":{}}	2025-08-11 14:29:28.444+01	\N	\N	\N
1726	1	GET /templates	{"query":{}}	2025-08-11 14:29:28.511+01	\N	\N	\N
1743	1	list_vms	{}	2025-08-11 15:01:54.036+01	\N	\N	\N
1744	1	GET /dashboard	{"query":{}}	2025-08-11 15:01:59.391+01	\N	\N	\N
1746	1	list_vms	{}	2025-08-11 15:01:59.419+01	\N	\N	\N
1756	1	GET /dashboard	{"query":{}}	2025-08-12 02:57:50.224+01	\N	\N	\N
1765	1	Échec Déploiement Terraform	{"error":"Terraform apply a échoué"}	2025-08-12 04:02:25.852+01	\N	\N	\N
1783	1	GET /roles	{"query":{}}	2025-08-12 04:23:06.801+01	\N	\N	\N
1789	1	GET /permissions/role/1	{"query":{}}	2025-08-12 04:23:07.131+01	\N	\N	\N
1802	1	GET /templates	{"query":{}}	2025-08-12 05:24:07.409+01	\N	\N	\N
1803	1	GET /templates	{"query":{}}	2025-08-12 05:24:07.483+01	\N	\N	\N
1830	1	generate_template_file:27:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh	{}	2025-08-12 05:38:00.058+01	\N	\N	\N
1843	1	GET /templates	{"query":{}}	2025-08-12 09:26:06.591+01	\N	\N	\N
1858	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-12 12:12:04.557+01	\N	\N	\N
1867	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 12:23:36.016+01	\N	\N	\N
1868	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 12:23:36.076+01	\N	\N	\N
1870	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 12:23:38.853+01	\N	\N	\N
1877	1	GET /vms	{"query":{}}	2025-08-12 12:37:40.389+01	\N	\N	\N
1881	1	GET /vms	{"query":{}}	2025-08-12 12:37:57.138+01	\N	\N	\N
1883	1	GET /vms	{"query":{}}	2025-08-12 12:38:49.628+01	\N	\N	\N
1885	1	GET /vms	{"query":{}}	2025-08-12 12:53:16.726+01	\N	\N	\N
1889	1	GET /roles	{"query":{}}	2025-08-12 12:53:27.293+01	\N	\N	\N
1035	1	GET /permissions/role/3	{"query":{}}	2025-08-09 22:11:15.311+01	\N	\N	\N
1038	1	GET /roles	{"query":{}}	2025-08-09 22:11:16.185+01	\N	\N	\N
1040	1	GET /permissions/role/3	{"query":{}}	2025-08-09 22:11:16.282+01	\N	\N	\N
1043	1	GET /roles	{"query":{}}	2025-08-09 22:11:17.044+01	\N	\N	\N
1045	1	GET /permissions/role/3	{"query":{}}	2025-08-09 22:11:17.149+01	\N	\N	\N
1242	1	GET /templates	{"query":{}}	2025-08-10 11:00:26.113+01	\N	\N	\N
1255	1	GET /templates	{"query":{}}	2025-08-10 11:08:48.49+01	\N	\N	\N
1270	1	GET /templates	{"query":{}}	2025-08-10 11:17:04.77+01	\N	\N	\N
1280	1	GET /templates	{"query":{}}	2025-08-10 11:26:40.235+01	\N	\N	\N
1281	1	GET /templates	{"query":{}}	2025-08-10 11:26:40.308+01	\N	\N	\N
1293	1	terminal_list_vms	{}	2025-08-10 11:46:55.705+01	\N	\N	\N
1306	1	GET /templates	{"query":{}}	2025-08-10 11:58:59.474+01	\N	\N	\N
1326	1	GET /templates	{"query":{}}	2025-08-10 12:59:12.994+01	\N	\N	\N
1327	1	GET /templates	{"query":{}}	2025-08-10 12:59:13.073+01	\N	\N	\N
1336	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-10 13:07:22.785+01	\N	\N	\N
1346	1	GET /templates	{"query":{}}	2025-08-10 13:08:35.896+01	\N	\N	\N
1347	1	GET /templates	{"query":{}}	2025-08-10 13:08:35.955+01	\N	\N	\N
1360	1	GET /templates	{"query":{}}	2025-08-10 14:23:22.757+01	\N	\N	\N
1376	1	GET /dashboard	{"query":{}}	2025-08-10 14:38:11.924+01	\N	\N	\N
1384	1	GET /dashboard	{"query":{}}	2025-08-10 14:46:11.924+01	\N	\N	\N
1392	1	GET /dashboard	{"query":{}}	2025-08-10 14:54:11.939+01	\N	\N	\N
1400	1	GET /dashboard	{"query":{}}	2025-08-10 15:02:11.961+01	\N	\N	\N
1408	1	GET /dashboard	{"query":{}}	2025-08-10 15:10:11.928+01	\N	\N	\N
1416	1	GET /dashboard	{"query":{}}	2025-08-10 15:18:12.013+01	\N	\N	\N
1424	1	GET /dashboard	{"query":{}}	2025-08-10 15:26:11.938+01	\N	\N	\N
1432	1	GET /dashboard	{"query":{}}	2025-08-10 15:34:11.917+01	\N	\N	\N
1440	1	GET /dashboard	{"query":{}}	2025-08-10 15:42:11.923+01	\N	\N	\N
1448	1	GET /dashboard	{"query":{}}	2025-08-10 15:50:11.934+01	\N	\N	\N
1456	1	GET /dashboard	{"query":{}}	2025-08-10 15:58:11.913+01	\N	\N	\N
1478	1	GET /templates	{"query":{}}	2025-08-10 23:37:49.98+01	\N	\N	\N
1479	1	GET /templates	{"query":{}}	2025-08-10 23:37:50.048+01	\N	\N	\N
1497	1	GET /templates	{"query":{}}	2025-08-11 08:03:14.525+01	\N	\N	\N
1507	1	GET /roles	{"query":{}}	2025-08-11 08:09:05.972+01	\N	\N	\N
1509	1	GET /roles	{"query":{}}	2025-08-11 08:09:06.1+01	\N	\N	\N
1512	1	GET /permissions?page=1&limit=10	{"query":{"page":"1","limit":"10"}}	2025-08-11 08:09:14.286+01	\N	\N	\N
1514	1	GET /roles	{"query":{}}	2025-08-11 08:09:14.388+01	\N	\N	\N
1516	1	GET /permissions/role/2	{"query":{}}	2025-08-11 08:09:14.49+01	\N	\N	\N
1519	1	GET /permissions/role/2	{"query":{}}	2025-08-11 08:09:14.653+01	\N	\N	\N
1527	1	terminal_list_vms	{}	2025-08-11 08:10:16.39+01	\N	\N	\N
1528	1	POST /terminal/ssh/test	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus"},"query":{}}	2025-08-11 08:10:21.453+01	\N	\N	\N
1529	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ip a"},"query":{}}	2025-08-11 08:10:26.478+01	\N	\N	\N
1530	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-11 08:10:30.251+01	\N	\N	\N
1531	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /tmp"},"query":{}}	2025-08-11 08:10:36.674+01	\N	\N	\N
1532	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-11 08:10:41.053+01	\N	\N	\N
1546	1	POST /vms/103/start	{"query":{}}	2025-08-11 10:15:10.722+01	\N	\N	\N
1547	1	start_vm:103	{}	2025-08-11 10:15:10.776+01	\N	\N	\N
1563	1	GET /templates	{"query":{}}	2025-08-11 10:21:58.86+01	\N	\N	\N
1564	1	GET /templates	{"query":{}}	2025-08-11 10:21:58.917+01	\N	\N	\N
1575	1	GET /dashboard	{"query":{}}	2025-08-11 10:42:03.358+01	\N	\N	\N
1576	1	GET /dashboard	{"query":{}}	2025-08-11 10:42:03.434+01	\N	\N	\N
1577	1	GET /templates	{"query":{}}	2025-08-11 10:42:06.719+01	\N	\N	\N
1578	1	GET /templates	{"query":{}}	2025-08-11 10:42:06.78+01	\N	\N	\N
1594	1	GET /permissions/role/2	{"query":{}}	2025-08-11 11:25:29.856+01	\N	\N	\N
1597	1	GET /permissions/role/2	{"query":{}}	2025-08-11 11:25:30.009+01	\N	\N	\N
1609	1	GET /auth/me	{"query":{}}	2025-08-11 11:30:51.046+01	\N	\N	\N
1610	1	GET /auth/me	{"query":{}}	2025-08-11 11:30:51.089+01	\N	\N	\N
1627	1	GET /templates	{"query":{}}	2025-08-11 11:48:56.302+01	\N	\N	\N
1653	1	GET /templates	{"query":{}}	2025-08-11 11:52:40.848+01	\N	\N	\N
1654	1	GET /templates	{"query":{}}	2025-08-11 11:52:40.947+01	\N	\N	\N
1668	1	GET /roles	{"query":{}}	2025-08-11 12:46:25.392+01	\N	\N	\N
1669	1	GET /users	{"query":{}}	2025-08-11 12:46:25.457+01	\N	\N	\N
1674	1	terminal_list_vms	{}	2025-08-11 12:46:26.446+01	\N	\N	\N
1675	1	GET /dashboard/map	{"query":{}}	2025-08-11 12:46:36.52+01	\N	\N	\N
1676	1	GET /dashboard/map	{"query":{}}	2025-08-11 12:46:36.588+01	\N	\N	\N
1690	1	list_vms	{}	2025-08-11 13:27:00.084+01	\N	\N	\N
1691	1	GET /vms	{"query":{}}	2025-08-11 13:27:00.218+01	\N	\N	\N
1703	1	GET /dashboard	{"query":{}}	2025-08-11 14:28:15.52+01	\N	\N	\N
1704	1	GET /vms	{"query":{}}	2025-08-11 14:28:15.521+01	\N	\N	\N
1705	1	list_vms	{}	2025-08-11 14:28:15.572+01	\N	\N	\N
1706	1	GET /dashboard	{"query":{}}	2025-08-11 14:28:15.656+01	\N	\N	\N
1727	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"c06d59eb-a650-4427-ba92-05b107a6fd81"},"query":{}}	2025-08-11 14:30:31.718+01	\N	\N	\N
1728	1	POST /vms/delete	{"body":{"vm_id":104,"instance_id":"d45d414b-a18d-4f3a-9a97-c84d8d4417c5"},"query":{}}	2025-08-11 14:30:33.728+01	\N	\N	\N
1729	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-11 14:30:45.157+01	\N	\N	\N
1745	1	GET /vms	{"query":{}}	2025-08-11 15:01:59.392+01	\N	\N	\N
1747	1	GET /dashboard/map	{"query":{}}	2025-08-11 15:02:04.804+01	\N	\N	\N
1748	1	GET /dashboard/map	{"query":{}}	2025-08-11 15:02:04.859+01	\N	\N	\N
1757	1	GET /vms	{"query":{}}	2025-08-12 02:57:50.225+01	\N	\N	\N
1766	1	Échec Déploiement Terraform	{"error":"runTerraformApplyStream is not a function"}	2025-08-12 04:08:30.915+01	\N	\N	\N
1786	1	GET /permissions/role/1	{"query":{}}	2025-08-12 04:23:06.938+01	\N	\N	\N
1804	1	GET /templates	{"query":{}}	2025-08-12 05:32:20.087+01	\N	\N	\N
1805	1	GET /templates	{"query":{}}	2025-08-12 05:32:20.16+01	\N	\N	\N
1831	1	Échec Déploiement Terraform	{"code":"TF_APPLY_FAILED","message":"Le déploiement a échoué."}	2025-08-12 05:39:45.861+01	\N	\N	\N
1844	1	GET /templates	{"query":{}}	2025-08-12 09:26:13.957+01	\N	\N	\N
1846	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-12 09:26:23.559+01	\N	\N	\N
1859	1	GET /dashboard/stats?period=week	{"query":{"period":"week"}}	2025-08-12 12:13:09.164+01	\N	\N	\N
1860	1	GET /dashboard/stats?period=month	{"query":{"period":"month"}}	2025-08-12 12:13:12.213+01	\N	\N	\N
1861	1	GET /dashboard/stats?period=week	{"query":{"period":"week"}}	2025-08-12 12:13:14.967+01	\N	\N	\N
1862	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-12 12:13:22.447+01	\N	\N	\N
1871	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"88966679-e8a2-4c48-b948-75ca879e7343"},"query":{}}	2025-08-12 12:35:15.602+01	\N	\N	\N
1872	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"793826a0-2600-40a4-bdd8-2fd2209e4df9"},"query":{}}	2025-08-12 12:35:18.64+01	\N	\N	\N
1873	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-12 12:35:38.213+01	\N	\N	\N
1878	1	list_vms	{}	2025-08-12 12:37:40.42+01	\N	\N	\N
1879	1	GET /vms	{"query":{}}	2025-08-12 12:37:40.476+01	\N	\N	\N
1036	1	GET /permissions/role/1	{"query":{}}	2025-08-09 22:11:15.35+01	\N	\N	\N
1037	1	GET /permissions?page=4&limit=10	{"query":{"page":"4","limit":"10"}}	2025-08-09 22:11:16.11+01	\N	\N	\N
1041	1	GET /permissions/role/1	{"query":{}}	2025-08-09 22:11:16.319+01	\N	\N	\N
1042	1	GET /permissions?page=5&limit=10	{"query":{"page":"5","limit":"10"}}	2025-08-09 22:11:16.992+01	\N	\N	\N
1046	1	GET /permissions/role/1	{"query":{}}	2025-08-09 22:11:17.186+01	\N	\N	\N
1047	1	GET /templates	{"query":{}}	2025-08-09 22:51:30.643+01	\N	\N	\N
1048	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-09 22:51:48.591+01	\N	\N	\N
1049	1	terminal_list_vms	{}	2025-08-09 22:51:48.811+01	\N	\N	\N
1050	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-09 22:51:48.912+01	\N	\N	\N
1051	1	terminal_list_vms	{}	2025-08-09 22:51:49.037+01	\N	\N	\N
1052	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-09 22:52:24.386+01	\N	\N	\N
1053	1	terminal_list_vms	{}	2025-08-09 22:52:24.595+01	\N	\N	\N
1054	1	POST /terminal/ssh/test	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus"},"query":{}}	2025-08-09 22:53:01.721+01	\N	\N	\N
1055	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:53:06.845+01	\N	\N	\N
1056	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /tmp"},"query":{}}	2025-08-09 22:53:16.52+01	\N	\N	\N
1057	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:53:19.759+01	\N	\N	\N
1058	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"curl localhost"},"query":{}}	2025-08-09 22:53:45.779+01	\N	\N	\N
1059	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /var"},"query":{}}	2025-08-09 22:54:21.521+01	\N	\N	\N
1060	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /var"},"query":{}}	2025-08-09 22:54:28.263+01	\N	\N	\N
1061	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /etc"},"query":{}}	2025-08-09 22:54:32.846+01	\N	\N	\N
1062	1	POST /terminal/ssh/exec	{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-09 22:54:39.114+01	\N	\N	\N
1063	1	GET /logs	{"query":{}}	2025-08-09 22:54:59.826+01	\N	\N	\N
1064	1	GET /logs	{"query":{}}	2025-08-09 22:54:59.905+01	\N	\N	\N
1065	1	GET /logs	{"query":{}}	2025-08-09 22:55:59.714+01	\N	\N	\N
1066	1	GET /logs	{"query":{}}	2025-08-09 22:56:59.666+01	\N	\N	\N
1067	1	GET /logs	{"query":{}}	2025-08-09 22:57:59.671+01	\N	\N	\N
1068	1	GET /logs	{"query":{}}	2025-08-09 22:58:59.69+01	\N	\N	\N
1069	1	GET /templates	{"query":{}}	2025-08-09 22:59:57.261+01	\N	\N	\N
1070	1	GET /templates	{"query":{}}	2025-08-09 22:59:57.373+01	\N	\N	\N
1071	1	GET /templates	{"query":{}}	2025-08-09 23:03:49.704+01	\N	\N	\N
1072	1	GET /templates	{"query":{}}	2025-08-09 23:04:06.78+01	\N	\N	\N
1073	1	GET /templates	{"query":{}}	2025-08-09 23:05:25.779+01	\N	\N	\N
1074	1	GET /templates	{"query":{}}	2025-08-09 23:05:25.841+01	\N	\N	\N
1075	1	GET /templates	{"query":{}}	2025-08-09 23:05:40.648+01	\N	\N	\N
1076	1	GET /templates	{"query":{}}	2025-08-09 23:05:40.715+01	\N	\N	\N
1077	1	GET /templates	{"query":{}}	2025-08-09 23:09:23.234+01	\N	\N	\N
1078	1	GET /templates	{"query":{}}	2025-08-09 23:09:23.309+01	\N	\N	\N
1079	1	POST /templates	{"body":{"name":"script_1754777375273.sh","service_type":"custom","category":"general","description":"","template_content":"#!/bin/bash\\n\\n# Nouveau script","fields_schema":{"fields":[]}},"query":{}}	2025-08-09 23:09:35.381+01	\N	\N	\N
1080	1	create_template:23	{}	2025-08-09 23:09:35.393+01	\N	\N	\N
1081	1	PUT /templates/23	{"body":{"name":"script_de_test.sh","template_content":"#!/bin/bash\\n\\n# Nouveau script"},"query":{}}	2025-08-09 23:10:07.056+01	\N	\N	\N
1082	1	update_template:23	{}	2025-08-09 23:10:07.082+01	\N	\N	\N
1083	1	GET /templates	{"query":{}}	2025-08-09 23:22:12.552+01	\N	\N	\N
1084	1	GET /templates	{"query":{}}	2025-08-09 23:22:12.613+01	\N	\N	\N
1085	1	GET /templates	{"query":{}}	2025-08-09 23:23:05.921+01	\N	\N	\N
1086	1	GET /templates	{"query":{}}	2025-08-09 23:23:05.979+01	\N	\N	\N
1087	1	GET /templates	{"query":{}}	2025-08-09 23:23:11.489+01	\N	\N	\N
1088	1	GET /templates	{"query":{}}	2025-08-09 23:23:11.573+01	\N	\N	\N
1089	1	GET /templates	{"query":{}}	2025-08-09 23:23:13.609+01	\N	\N	\N
1090	1	GET /templates	{"query":{}}	2025-08-09 23:23:13.661+01	\N	\N	\N
1091	1	GET /templates	{"query":{}}	2025-08-09 23:23:15.191+01	\N	\N	\N
1092	1	GET /templates	{"query":{}}	2025-08-09 23:23:15.249+01	\N	\N	\N
1093	1	GET /templates	{"query":{}}	2025-08-10 00:00:36.636+01	\N	\N	\N
1094	1	GET /templates	{"query":{}}	2025-08-10 00:00:36.725+01	\N	\N	\N
1095	1	GET /templates	{"query":{}}	2025-08-10 00:01:02.681+01	\N	\N	\N
1096	1	GET /templates	{"query":{}}	2025-08-10 00:01:02.75+01	\N	\N	\N
1097	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-10 00:01:54.943+01	\N	\N	\N
1098	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:02:01.968+01	\N	\N	\N
1099	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:03:01.886+01	\N	\N	\N
1100	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:04:01.745+01	\N	\N	\N
1101	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:05:01.74+01	\N	\N	\N
1102	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:06:01.731+01	\N	\N	\N
1103	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:07:01.749+01	\N	\N	\N
1104	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:08:01.735+01	\N	\N	\N
1105	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:09:01.731+01	\N	\N	\N
1106	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:10:01.743+01	\N	\N	\N
1107	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:11:01.732+01	\N	\N	\N
1108	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:12:01.755+01	\N	\N	\N
1109	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:13:01.743+01	\N	\N	\N
1110	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:14:01.724+01	\N	\N	\N
1111	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:15:01.743+01	\N	\N	\N
1112	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:16:01.761+01	\N	\N	\N
1113	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:17:01.773+01	\N	\N	\N
1114	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:18:01.735+01	\N	\N	\N
1115	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:19:01.743+01	\N	\N	\N
1116	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:20:01.743+01	\N	\N	\N
1117	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:21:01.735+01	\N	\N	\N
1118	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:22:01.751+01	\N	\N	\N
1119	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:23:03.823+01	\N	\N	\N
1120	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:24:01.738+01	\N	\N	\N
1121	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:25:01.742+01	\N	\N	\N
1122	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:26:01.754+01	\N	\N	\N
1123	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:27:01.765+01	\N	\N	\N
1124	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:28:01.735+01	\N	\N	\N
1125	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:29:01.737+01	\N	\N	\N
1126	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:30:01.84+01	\N	\N	\N
1127	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:31:01.751+01	\N	\N	\N
1128	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:32:01.739+01	\N	\N	\N
1129	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:33:01.744+01	\N	\N	\N
1130	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:34:01.73+01	\N	\N	\N
1131	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:35:01.752+01	\N	\N	\N
1132	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:36:01.738+01	\N	\N	\N
1133	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:37:01.749+01	\N	\N	\N
1134	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:38:01.731+01	\N	\N	\N
1135	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:39:01.75+01	\N	\N	\N
1136	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:40:01.745+01	\N	\N	\N
1137	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:41:01.738+01	\N	\N	\N
1138	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:42:01.733+01	\N	\N	\N
1139	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:43:01.762+01	\N	\N	\N
1140	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:44:01.726+01	\N	\N	\N
1141	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:45:01.739+01	\N	\N	\N
1142	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:46:01.743+01	\N	\N	\N
1143	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:47:01.742+01	\N	\N	\N
1144	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:48:01.746+01	\N	\N	\N
1145	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:49:01.733+01	\N	\N	\N
1146	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:50:01.724+01	\N	\N	\N
1147	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:51:01.762+01	\N	\N	\N
1148	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-10 00:52:01.749+01	\N	\N	\N
1149	1	GET /templates	{"query":{}}	2025-08-10 00:54:33.66+01	\N	\N	\N
1150	1	GET /templates	{"query":{}}	2025-08-10 00:54:33.731+01	\N	\N	\N
1151	1	GET /templates	{"query":{}}	2025-08-10 00:54:46.352+01	\N	\N	\N
1152	1	GET /templates	{"query":{}}	2025-08-10 00:54:46.421+01	\N	\N	\N
1153	1	GET /templates	{"query":{}}	2025-08-10 09:05:46.113+01	\N	\N	\N
1154	1	GET /templates	{"query":{}}	2025-08-10 09:06:03.285+01	\N	\N	\N
1155	1	GET /templates	{"query":{}}	2025-08-10 09:07:03.886+01	\N	\N	\N
1156	1	GET /templates	{"query":{}}	2025-08-10 09:07:03.953+01	\N	\N	\N
1157	1	GET /templates	{"query":{}}	2025-08-10 09:08:22.437+01	\N	\N	\N
1158	1	GET /templates	{"query":{}}	2025-08-10 09:08:22.505+01	\N	\N	\N
1159	1	GET /templates	{"query":{}}	2025-08-10 09:39:23.455+01	\N	\N	\N
1160	1	GET /templates	{"query":{}}	2025-08-10 09:39:30.103+01	\N	\N	\N
1161	1	GET /templates	{"query":{}}	2025-08-10 09:39:30.192+01	\N	\N	\N
1162	1	GET /templates	{"query":{}}	2025-08-10 09:39:50.962+01	\N	\N	\N
1163	1	GET /templates	{"query":{}}	2025-08-10 09:41:27.879+01	\N	\N	\N
1164	1	GET /templates	{"query":{}}	2025-08-10 09:41:27.947+01	\N	\N	\N
1165	1	GET /templates	{"query":{}}	2025-08-10 09:41:38.433+01	\N	\N	\N
1166	1	GET /templates	{"query":{}}	2025-08-10 09:41:51.223+01	\N	\N	\N
1167	1	GET /templates	{"query":{}}	2025-08-10 09:41:51.284+01	\N	\N	\N
1168	1	GET /templates	{"query":{}}	2025-08-10 09:42:05.11+01	\N	\N	\N
1169	1	GET /templates	{"query":{}}	2025-08-10 09:42:05.166+01	\N	\N	\N
1170	1	GET /templates	{"query":{}}	2025-08-10 09:42:10.3+01	\N	\N	\N
1171	1	GET /templates	{"query":{}}	2025-08-10 09:42:10.385+01	\N	\N	\N
1172	1	GET /templates	{"query":{}}	2025-08-10 09:42:26.928+01	\N	\N	\N
1173	1	GET /templates	{"query":{}}	2025-08-10 09:42:26.984+01	\N	\N	\N
1174	1	GET /templates	{"query":{}}	2025-08-10 09:43:01.708+01	\N	\N	\N
1175	1	GET /templates	{"query":{}}	2025-08-10 09:43:05.223+01	\N	\N	\N
1176	1	GET /templates	{"query":{}}	2025-08-10 09:43:05.301+01	\N	\N	\N
1177	1	POST /templates	{"body":{"name":"script_1754815397604.sh","service_type":"custom","category":"general","description":"","template_content":"#!/bin/bash\\n\\n# Nouveau script","fields_schema":{"fields":[]}},"query":{}}	2025-08-10 09:43:17.743+01	\N	\N	\N
1178	1	create_template:24	{}	2025-08-10 09:43:17.754+01	\N	\N	\N
1179	1	GET /templates	{"query":{}}	2025-08-10 09:53:30.905+01	\N	\N	\N
1180	1	GET /templates	{"query":{}}	2025-08-10 09:53:30.968+01	\N	\N	\N
1181	1	GET /templates	{"query":{}}	2025-08-10 10:03:19.257+01	\N	\N	\N
1182	1	GET /templates	{"query":{}}	2025-08-10 10:03:19.343+01	\N	\N	\N
1183	1	GET /templates	{"query":{}}	2025-08-10 10:03:24.586+01	\N	\N	\N
1184	1	GET /templates	{"query":{}}	2025-08-10 10:03:24.658+01	\N	\N	\N
1185	1	GET /templates	{"query":{}}	2025-08-10 10:03:30.69+01	\N	\N	\N
1186	1	GET /templates	{"query":{}}	2025-08-10 10:03:30.759+01	\N	\N	\N
1187	1	GET /templates	{"query":{}}	2025-08-10 10:03:42.725+01	\N	\N	\N
1188	1	GET /templates	{"query":{}}	2025-08-10 10:03:42.861+01	\N	\N	\N
1189	1	GET /templates	{"query":{}}	2025-08-10 10:04:33.927+01	\N	\N	\N
1190	1	GET /templates	{"query":{}}	2025-08-10 10:04:33.997+01	\N	\N	\N
1191	1	GET /templates	{"query":{}}	2025-08-10 10:04:41.029+01	\N	\N	\N
1192	1	GET /templates	{"query":{}}	2025-08-10 10:04:41.099+01	\N	\N	\N
1193	1	GET /templates	{"query":{}}	2025-08-10 10:21:36.88+01	\N	\N	\N
1194	1	GET /templates	{"query":{}}	2025-08-10 10:21:45.748+01	\N	\N	\N
1195	1	GET /templates	{"query":{}}	2025-08-10 10:21:45.822+01	\N	\N	\N
1196	1	GET /templates	{"query":{}}	2025-08-10 10:22:24.749+01	\N	\N	\N
1197	1	GET /templates	{"query":{}}	2025-08-10 10:24:05.791+01	\N	\N	\N
1198	1	GET /templates	{"query":{}}	2025-08-10 10:24:05.861+01	\N	\N	\N
1199	1	GET /templates	{"query":{}}	2025-08-10 10:24:09.878+01	\N	\N	\N
1200	1	GET /templates	{"query":{}}	2025-08-10 10:24:09.954+01	\N	\N	\N
1201	1	GET /templates	{"query":{}}	2025-08-10 10:24:14.979+01	\N	\N	\N
1202	1	GET /templates	{"query":{}}	2025-08-10 10:24:15.041+01	\N	\N	\N
1203	1	GET /templates	{"query":{}}	2025-08-10 10:24:21.523+01	\N	\N	\N
1204	1	GET /templates	{"query":{}}	2025-08-10 10:24:21.583+01	\N	\N	\N
1205	1	GET /templates	{"query":{}}	2025-08-10 10:24:28.11+01	\N	\N	\N
1206	1	GET /templates	{"query":{}}	2025-08-10 10:24:28.172+01	\N	\N	\N
1207	1	GET /templates	{"query":{}}	2025-08-10 10:24:43.889+01	\N	\N	\N
1208	1	GET /templates	{"query":{}}	2025-08-10 10:24:43.964+01	\N	\N	\N
1209	1	GET /templates	{"query":{}}	2025-08-10 10:24:54.935+01	\N	\N	\N
1210	1	GET /templates	{"query":{}}	2025-08-10 10:24:55.001+01	\N	\N	\N
1211	1	GET /templates	{"query":{}}	2025-08-10 10:24:57.847+01	\N	\N	\N
1212	1	GET /templates	{"query":{}}	2025-08-10 10:24:57.91+01	\N	\N	\N
1213	1	GET /templates	{"query":{}}	2025-08-10 10:25:07.606+01	\N	\N	\N
1214	1	GET /templates	{"query":{}}	2025-08-10 10:25:07.691+01	\N	\N	\N
1215	1	GET /templates	{"query":{}}	2025-08-10 10:25:11.191+01	\N	\N	\N
1216	1	GET /templates	{"query":{}}	2025-08-10 10:25:11.256+01	\N	\N	\N
1217	1	GET /templates	{"query":{}}	2025-08-10 10:25:39.793+01	\N	\N	\N
1218	1	GET /templates	{"query":{}}	2025-08-10 10:25:39.873+01	\N	\N	\N
1219	1	GET /templates	{"query":{}}	2025-08-10 10:25:47.639+01	\N	\N	\N
1220	1	GET /templates	{"query":{}}	2025-08-10 10:25:47.721+01	\N	\N	\N
1221	1	GET /templates	{"query":{}}	2025-08-10 10:25:51.675+01	\N	\N	\N
1222	1	GET /templates	{"query":{}}	2025-08-10 10:25:51.736+01	\N	\N	\N
1223	1	GET /templates	{"query":{}}	2025-08-10 10:29:20.976+01	\N	\N	\N
1224	1	GET /templates	{"query":{}}	2025-08-10 10:29:21.042+01	\N	\N	\N
1225	1	GET /templates	{"query":{}}	2025-08-10 10:30:02.801+01	\N	\N	\N
1226	1	GET /templates	{"query":{}}	2025-08-10 10:30:02.858+01	\N	\N	\N
1227	1	GET /templates	{"query":{}}	2025-08-10 10:30:18.374+01	\N	\N	\N
1228	1	GET /templates	{"query":{}}	2025-08-10 10:30:18.46+01	\N	\N	\N
1229	1	GET /templates	{"query":{}}	2025-08-10 10:32:44.048+01	\N	\N	\N
1230	1	GET /templates	{"query":{}}	2025-08-10 10:32:44.106+01	\N	\N	\N
1231	1	GET /templates	{"query":{}}	2025-08-10 10:32:46.008+01	\N	\N	\N
1232	1	GET /templates	{"query":{}}	2025-08-10 10:32:46.07+01	\N	\N	\N
1243	1	GET /templates	{"query":{}}	2025-08-10 11:00:26.169+01	\N	\N	\N
1256	1	GET /templates	{"query":{}}	2025-08-10 11:12:06.216+01	\N	\N	\N
1271	1	GET /templates	{"query":{}}	2025-08-10 11:17:04.824+01	\N	\N	\N
1282	1	GET /templates	{"query":{}}	2025-08-10 11:26:46.862+01	\N	\N	\N
1294	1	GET /templates	{"query":{}}	2025-08-10 11:48:06.302+01	\N	\N	\N
1295	1	GET /templates	{"query":{}}	2025-08-10 11:48:06.39+01	\N	\N	\N
1307	1	GET /templates	{"query":{}}	2025-08-10 11:58:59.54+01	\N	\N	\N
1328	1	GET /templates	{"query":{}}	2025-08-10 12:59:21.86+01	\N	\N	\N
1337	1	terminal_list_vms	{}	2025-08-10 13:07:22.908+01	\N	\N	\N
1348	1	GET /dashboard/map	{"query":{}}	2025-08-10 13:51:45.035+01	\N	\N	\N
1349	1	GET /dashboard/map	{"query":{}}	2025-08-10 13:51:45.112+01	\N	\N	\N
1361	1	GET /templates	{"query":{}}	2025-08-10 14:23:22.833+01	\N	\N	\N
1377	1	GET /dashboard	{"query":{}}	2025-08-10 14:39:11.942+01	\N	\N	\N
1385	1	GET /dashboard	{"query":{}}	2025-08-10 14:47:11.95+01	\N	\N	\N
1393	1	GET /dashboard	{"query":{}}	2025-08-10 14:55:11.933+01	\N	\N	\N
1401	1	GET /dashboard	{"query":{}}	2025-08-10 15:03:11.934+01	\N	\N	\N
1409	1	GET /dashboard	{"query":{}}	2025-08-10 15:11:11.944+01	\N	\N	\N
1417	1	GET /dashboard	{"query":{}}	2025-08-10 15:19:11.918+01	\N	\N	\N
1425	1	GET /dashboard	{"query":{}}	2025-08-10 15:27:11.923+01	\N	\N	\N
1433	1	GET /dashboard	{"query":{}}	2025-08-10 15:35:11.919+01	\N	\N	\N
1441	1	GET /dashboard	{"query":{}}	2025-08-10 15:43:11.936+01	\N	\N	\N
1449	1	GET /dashboard	{"query":{}}	2025-08-10 15:51:11.926+01	\N	\N	\N
1457	1	GET /dashboard	{"query":{}}	2025-08-10 15:59:11.928+01	\N	\N	\N
1480	1	GET /templates	{"query":{}}	2025-08-10 23:40:06.186+01	\N	\N	\N
1481	1	GET /templates	{"query":{}}	2025-08-10 23:40:06.253+01	\N	\N	\N
1498	1	GET /templates	{"query":{}}	2025-08-11 08:04:22.161+01	\N	\N	\N
1499	1	GET /templates	{"query":{}}	2025-08-11 08:04:22.218+01	\N	\N	\N
1510	1	GET /roles	{"query":{}}	2025-08-11 08:09:10.864+01	\N	\N	\N
1517	1	GET /permissions/role/3	{"query":{}}	2025-08-11 08:09:14.543+01	\N	\N	\N
1521	1	GET /permissions/role/1	{"query":{}}	2025-08-11 08:09:14.733+01	\N	\N	\N
1533	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /etc"},"query":{}}	2025-08-11 08:10:53.556+01	\N	\N	\N
1534	1	POST /terminal/ssh/exec	{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-11 08:10:55.603+01	\N	\N	\N
1548	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-11 10:19:39.969+01	\N	\N	\N
1565	1	GET /templates	{"query":{}}	2025-08-11 10:22:07.248+01	\N	\N	\N
1579	1	GET /dashboard	{"query":{}}	2025-08-11 10:42:08.167+01	\N	\N	\N
1580	1	GET /dashboard	{"query":{}}	2025-08-11 10:42:08.231+01	\N	\N	\N
1595	1	GET /permissions/role/3	{"query":{}}	2025-08-11 11:25:29.896+01	\N	\N	\N
1598	1	GET /permissions/role/3	{"query":{}}	2025-08-11 11:25:30.047+01	\N	\N	\N
1611	1	GET /vms	{"query":{}}	2025-08-11 11:45:33.712+01	\N	\N	\N
1615	1	GET /dashboard	{"query":{}}	2025-08-11 11:45:33.918+01	\N	\N	\N
1616	1	list_vms	{}	2025-08-11 11:45:33.939+01	\N	\N	\N
1628	1	GET /templates	{"query":{}}	2025-08-11 11:48:56.356+01	\N	\N	\N
1655	1	GET /dashboard	{"query":{}}	2025-08-11 11:57:43.103+01	\N	\N	\N
1657	1	list_vms	{}	2025-08-11 11:57:43.152+01	\N	\N	\N
1658	1	GET /dashboard	{"query":{}}	2025-08-11 11:57:43.231+01	\N	\N	\N
1671	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-11 12:46:26.248+01	\N	\N	\N
1693	1	list_vms	{}	2025-08-11 13:27:00.243+01	\N	\N	\N
1707	1	GET /vms	{"query":{}}	2025-08-11 14:28:15.658+01	\N	\N	\N
1730	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-11 14:36:18.002+01	\N	\N	\N
1749	1	GET /templates	{"query":{}}	2025-08-11 15:03:01.857+01	\N	\N	\N
1750	1	GET /templates	{"query":{}}	2025-08-11 15:03:01.938+01	\N	\N	\N
1758	1	GET /dashboard	{"query":{}}	2025-08-12 02:59:44.934+01	\N	\N	\N
1760	1	list_vms	{}	2025-08-12 02:59:44.966+01	\N	\N	\N
1767	1	Déploiement Terraform	{"vm_name":"testweb3","service_type":"web_server_nginx","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-12ca649c-5815-4412-97b7-4298b2a83444.log"}	2025-08-12 04:22:05.33+01	\N	\N	\N
1790	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-12 04:24:57.518+01	\N	\N	\N
1791	1	login	{"user_id":1}	2025-08-12 04:24:57.79+01	\N	\N	\N
1792	1	GET /dashboard	{"query":{}}	2025-08-12 04:25:00.287+01	\N	\N	\N
1793	1	GET /vms	{"query":{}}	2025-08-12 04:25:00.288+01	\N	\N	\N
1794	1	list_vms	{}	2025-08-12 04:25:00.328+01	\N	\N	\N
1795	1	GET /vms	{"query":{}}	2025-08-12 04:25:00.418+01	\N	\N	\N
1796	1	GET /dashboard	{"query":{}}	2025-08-12 04:25:00.422+01	\N	\N	\N
1806	1	GET /templates	{"query":{}}	2025-08-12 05:33:10.754+01	\N	\N	\N
1808	1	GET /vms	{"query":{}}	2025-08-12 05:33:14.349+01	\N	\N	\N
1811	1	GET /dashboard	{"query":{}}	2025-08-12 05:33:14.517+01	\N	\N	\N
1812	1	list_vms	{}	2025-08-12 05:33:14.531+01	\N	\N	\N
1813	1	GET /templates	{"query":{}}	2025-08-12 05:33:22.253+01	\N	\N	\N
1832	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-12 05:51:09.576+01	\N	\N	\N
1845	1	GET /templates	{"query":{}}	2025-08-12 09:26:14.021+01	\N	\N	\N
1863	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 12:20:10.102+01	\N	\N	\N
1864	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 12:20:10.245+01	\N	\N	\N
1874	1	POST /vms/delete	{"body":{"vm_id":105,"instance_id":""},"query":{}}	2025-08-12 12:36:20.587+01	\N	\N	\N
1880	1	list_vms	{}	2025-08-12 12:37:40.496+01	\N	\N	\N
1882	1	list_vms	{}	2025-08-12 12:37:57.169+01	\N	\N	\N
1884	1	list_vms	{}	2025-08-12 12:38:49.704+01	\N	\N	\N
1886	1	list_vms	{}	2025-08-12 12:53:16.801+01	\N	\N	\N
1887	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 12:53:27.153+01	\N	\N	\N
1819	1	POST /templates	{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","script_path":"/scripts/install_services_monitoring.sh","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}	2025-08-12 05:37:03.49+01	\N	\N	\N
1820	1	create_template:27	{}	2025-08-12 05:37:03.504+01	\N	\N	\N
1821	1	GET /templates	{"query":{}}	2025-08-12 05:37:08.556+01	\N	\N	\N
1822	1	GET /templates	{"query":{}}	2025-08-12 05:37:08.609+01	\N	\N	\N
1888	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 12:53:27.239+01	\N	\N	\N
1890	1	GET /roles	{"query":{}}	2025-08-12 12:53:27.356+01	\N	\N	\N
1891	1	GET /permissions/role/2	{"query":{}}	2025-08-12 12:53:27.404+01	\N	\N	\N
1894	1	GET /permissions/role/2	{"query":{}}	2025-08-12 12:53:27.571+01	\N	\N	\N
1892	1	GET /permissions/role/3	{"query":{}}	2025-08-12 12:53:27.454+01	\N	\N	\N
1893	1	GET /permissions/role/1	{"query":{}}	2025-08-12 12:53:27.493+01	\N	\N	\N
1895	1	GET /permissions/role/3	{"query":{}}	2025-08-12 12:53:27.629+01	\N	\N	\N
1896	1	GET /permissions/role/1	{"query":{}}	2025-08-12 12:53:27.673+01	\N	\N	\N
1897	1	POST /permissions	{"body":{"name":"script.servicetypes","description":"Script type"},"query":{}}	2025-08-12 12:54:10.529+01	\N	\N	\N
1898	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[63]}],"query":{}}	2025-08-12 12:54:25.988+01	\N	\N	\N
1899	1	GET /vms	{"query":{}}	2025-08-12 12:54:31.204+01	\N	\N	\N
1900	1	list_vms	{}	2025-08-12 12:54:31.325+01	\N	\N	\N
1901	1	GET /vms	{"query":{}}	2025-08-12 12:54:31.412+01	\N	\N	\N
1902	1	list_vms	{}	2025-08-12 12:54:31.45+01	\N	\N	\N
1903	1	GET /vms	{"query":{}}	2025-08-12 12:54:38.367+01	\N	\N	\N
1904	1	list_vms	{}	2025-08-12 12:54:38.392+01	\N	\N	\N
1905	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 12:55:12.739+01	\N	\N	\N
1906	1	GET /roles	{"query":{}}	2025-08-12 12:55:12.81+01	\N	\N	\N
1907	1	GET /permissions/role/2	{"query":{}}	2025-08-12 12:55:12.889+01	\N	\N	\N
1908	1	GET /permissions/role/1	{"query":{}}	2025-08-12 12:55:12.925+01	\N	\N	\N
1909	1	GET /permissions/role/3	{"query":{}}	2025-08-12 12:55:12.963+01	\N	\N	\N
1910	1	GET /vms	{"query":{}}	2025-08-12 12:55:49.254+01	\N	\N	\N
1911	1	list_vms	{}	2025-08-12 12:55:49.304+01	\N	\N	\N
1912	1	POST /permissions	{"body":{"name":"script.list","description":"script.list"},"query":{}}	2025-08-12 12:56:36.328+01	\N	\N	\N
1913	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[64]}],"query":{}}	2025-08-12 12:56:39.513+01	\N	\N	\N
1914	1	GET /vms	{"query":{}}	2025-08-12 12:56:45.835+01	\N	\N	\N
1915	1	list_vms	{}	2025-08-12 12:56:45.868+01	\N	\N	\N
1916	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-12 12:58:09.279+01	\N	\N	\N
1917	1	login	{"user_id":1}	2025-08-12 12:58:09.454+01	\N	\N	\N
1918	1	GET /dashboard	{"query":{}}	2025-08-12 12:58:12.171+01	\N	\N	\N
1919	1	GET /vms	{"query":{}}	2025-08-12 12:58:12.173+01	\N	\N	\N
1920	1	list_vms	{}	2025-08-12 12:58:12.2+01	\N	\N	\N
1921	1	GET /vms	{"query":{}}	2025-08-12 12:58:12.279+01	\N	\N	\N
1922	1	GET /dashboard	{"query":{}}	2025-08-12 12:58:12.339+01	\N	\N	\N
1923	1	list_vms	{}	2025-08-12 12:58:12.354+01	\N	\N	\N
1924	1	GET /vms	{"query":{}}	2025-08-12 12:58:20.623+01	\N	\N	\N
1925	1	list_vms	{}	2025-08-12 12:58:20.647+01	\N	\N	\N
1926	1	GET /vms	{"query":{}}	2025-08-12 12:58:20.7+01	\N	\N	\N
1927	1	list_vms	{}	2025-08-12 12:58:20.719+01	\N	\N	\N
1928	1	GET /vms	{"query":{}}	2025-08-12 13:00:56.964+01	\N	\N	\N
1929	1	list_vms	{}	2025-08-12 13:00:57.029+01	\N	\N	\N
1930	1	GET /vms	{"query":{}}	2025-08-12 13:03:00.802+01	\N	\N	\N
1931	1	list_vms	{}	2025-08-12 13:03:00.852+01	\N	\N	\N
1932	1	GET /vms	{"query":{}}	2025-08-12 13:04:29.807+01	\N	\N	\N
1933	1	list_vms	{}	2025-08-12 13:04:29.87+01	\N	\N	\N
1934	1	GET /vms	{"query":{}}	2025-08-12 13:04:57.212+01	\N	\N	\N
1935	1	list_vms	{}	2025-08-12 13:04:57.278+01	\N	\N	\N
1936	1	GET /vms	{"query":{}}	2025-08-12 13:05:20.686+01	\N	\N	\N
1937	1	list_vms	{}	2025-08-12 13:05:20.723+01	\N	\N	\N
1938	1	GET /vms	{"query":{}}	2025-08-12 13:05:44.012+01	\N	\N	\N
1939	1	list_vms	{}	2025-08-12 13:05:44.093+01	\N	\N	\N
1940	1	GET /dashboard	{"query":{}}	2025-08-12 13:11:48.901+01	\N	\N	\N
1941	1	GET /vms	{"query":{}}	2025-08-12 13:11:48.902+01	\N	\N	\N
1942	1	list_vms	{}	2025-08-12 13:11:48.947+01	\N	\N	\N
1943	1	GET /vms	{"query":{}}	2025-08-12 13:11:49.052+01	\N	\N	\N
1944	1	GET /dashboard	{"query":{}}	2025-08-12 13:11:49.056+01	\N	\N	\N
1945	1	list_vms	{}	2025-08-12 13:11:49.075+01	\N	\N	\N
1946	1	GET /dashboard/insights	{"query":{}}	2025-08-12 13:11:55.037+01	\N	\N	\N
1947	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 13:15:11.45+01	\N	\N	\N
1948	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 13:15:11.532+01	\N	\N	\N
1949	1	DELETE /templates/27	{"query":{}}	2025-08-12 13:15:16.59+01	\N	\N	\N
1950	1	delete_template:27	{}	2025-08-12 13:15:16.605+01	\N	\N	\N
1951	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 13:15:16.664+01	\N	\N	\N
1952	1	GET /templates?status=supprime	{"query":{"status":"supprime"}}	2025-08-12 13:15:20.342+01	\N	\N	\N
1953	1	POST /templates/27/restore	{"query":{}}	2025-08-12 13:15:22.971+01	\N	\N	\N
1954	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 13:15:40.656+01	\N	\N	\N
1955	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 13:15:40.729+01	\N	\N	\N
1956	1	GET /roles	{"query":{}}	2025-08-12 13:15:40.781+01	\N	\N	\N
1957	1	GET /roles	{"query":{}}	2025-08-12 13:15:40.87+01	\N	\N	\N
1958	1	GET /permissions/role/2	{"query":{}}	2025-08-12 13:15:40.93+01	\N	\N	\N
1959	1	GET /permissions/role/1	{"query":{}}	2025-08-12 13:15:40.972+01	\N	\N	\N
1960	1	GET /permissions/role/3	{"query":{}}	2025-08-12 13:15:41.032+01	\N	\N	\N
1961	1	GET /permissions/role/2	{"query":{}}	2025-08-12 13:15:41.108+01	\N	\N	\N
1962	1	GET /permissions/role/3	{"query":{}}	2025-08-12 13:15:41.15+01	\N	\N	\N
2201	1	GET /roles	{"query":{}}	2025-08-13 04:35:47.943+01	\N	\N	\N
1963	1	GET /permissions/role/1	{"query":{}}	2025-08-12 13:15:41.193+01	\N	\N	\N
1964	1	POST /permissions	{"body":{"name":"template.restore","description":"template.restore"},"query":{}}	2025-08-12 13:15:51.888+01	\N	\N	\N
1965	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 13:17:50.356+01	\N	\N	\N
1966	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 13:17:50.416+01	\N	\N	\N
1967	1	GET /templates?status=supprime	{"query":{"status":"supprime"}}	2025-08-12 13:17:53.368+01	\N	\N	\N
1968	1	POST /templates/27/restore	{"query":{}}	2025-08-12 13:17:55.903+01	\N	\N	\N
1969	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 13:18:01.828+01	\N	\N	\N
1970	1	GET /templates?status=supprime	{"query":{"status":"supprime"}}	2025-08-12 13:18:05.57+01	\N	\N	\N
1971	1	POST /templates/27/restore	{"query":{}}	2025-08-12 13:18:07.377+01	\N	\N	\N
1972	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 13:18:23.797+01	\N	\N	\N
1973	1	POST /scripts/29/analyze	{"body":{"script":"#!/bin/bash\\nset -euo pipefail\\n\\n# === Variables substituées par le moteur de template ===\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\nSTATUS_CRON_EXPR='*/1 * * * *'\\nSERVICES_CRON_EXPR='*/1 * * * *'\\nCRON_USER='nexus'\\n\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nmkdir -p \\"${MONITOR_DIR}\\"\\n\\n# --- Génère le script  ---\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\n#!/bin/bash\\nset -euo pipefail\\n\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\nCRON_USER='__CRON_USER__'\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nexists_and_exec() {\\n  local f=\\"$1\\"\\n  [[ -f \\"$f\\" ]] || return 1\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\n  return 0\\n}\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\n\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nremove_mark() {\\n  local mark=\\"$1\\"\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\n}\\n\\nok=1\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nelse\\n  ok=0\\nfi\\n\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nelse\\n  ok=0\\nfi\\n\\nif [[ \\"$ok\\" -eq 1 ]]; then\\n  # Exécuter une première fois pour générer les JSON immédiatement\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\n  # Se retirer du crontab\\n  remove_mark \\"$MARK_BOOT\\"\\nfi\\nEOS\\n\\n# Injecte les variables réelles dans le \\nsed -i \\\\\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\n  \\"/opt/monitoring/monitoring.sh\\"\\n\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\n\\n# --- (Ré)active le service cron/ crond ---\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\nfi\\n\\n# --- Installe le cron  (toutes les minutes) ---\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\nfi\\n\\nexit 0\\n","entity_type":"script","entity_id":29},"query":{}}	2025-08-12 13:18:29.516+01	\N	\N	\N
1974	1	GET /dashboard	{"query":{}}	2025-08-12 13:21:18.616+01	\N	\N	\N
1975	1	GET /vms	{"query":{}}	2025-08-12 13:21:18.616+01	\N	\N	\N
1976	1	list_vms	{}	2025-08-12 13:21:18.661+01	\N	\N	\N
1977	1	GET /vms	{"query":{}}	2025-08-12 13:21:18.717+01	\N	\N	\N
1978	1	GET /dashboard	{"query":{}}	2025-08-12 13:21:18.767+01	\N	\N	\N
1979	1	list_vms	{}	2025-08-12 13:21:18.783+01	\N	\N	\N
1980	1	Échec Déploiement Terraform	{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}	2025-08-12 13:22:35.894+01	\N	\N	\N
1981	1	GET /vms	{"query":{}}	2025-08-12 13:26:16.714+01	\N	\N	\N
1982	1	list_vms	{}	2025-08-12 13:26:16.868+01	\N	\N	\N
1983	1	GET /vms	{"query":{}}	2025-08-12 13:26:16.933+01	\N	\N	\N
1984	1	list_vms	{}	2025-08-12 13:26:16.957+01	\N	\N	\N
1985	1	GET /vms	{"query":{}}	2025-08-12 13:26:45.694+01	\N	\N	\N
1986	1	list_vms	{}	2025-08-12 13:26:45.813+01	\N	\N	\N
1987	1	GET /vms	{"query":{}}	2025-08-12 13:26:45.875+01	\N	\N	\N
1988	1	list_vms	{}	2025-08-12 13:26:45.899+01	\N	\N	\N
1989	1	GET /vms	{"query":{}}	2025-08-12 13:26:49.559+01	\N	\N	\N
1990	1	list_vms	{}	2025-08-12 13:26:49.586+01	\N	\N	\N
1991	1	GET /vms	{"query":{}}	2025-08-12 13:27:39.533+01	\N	\N	\N
1992	1	list_vms	{}	2025-08-12 13:27:39.571+01	\N	\N	\N
1993	1	Échec Déploiement Terraform	{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}	2025-08-12 13:42:15.693+01	\N	\N	\N
1994	1	GET /vms	{"query":{}}	2025-08-12 14:24:19.573+01	\N	\N	\N
1995	1	list_vms	{}	2025-08-12 14:24:19.703+01	\N	\N	\N
1996	1	GET /vms	{"query":{}}	2025-08-12 14:24:19.758+01	\N	\N	\N
1997	1	list_vms	{}	2025-08-12 14:24:19.783+01	\N	\N	\N
1998	1	GET /settings/me	{"query":{}}	2025-08-12 14:29:55.066+01	\N	\N	\N
1999	1	GET /settings/me	{"query":{}}	2025-08-12 14:29:55.141+01	\N	\N	\N
2000	1	GET /templates	{"query":{}}	2025-08-12 14:30:27.644+01	\N	\N	\N
2001	1	GET /templates	{"query":{}}	2025-08-12 14:30:27.714+01	\N	\N	\N
2002	1	GET /settings/account	{"query":{}}	2025-08-12 14:30:41.534+01	\N	\N	\N
2003	1	GET /settings/account	{"query":{}}	2025-08-12 14:30:41.592+01	\N	\N	\N
2004	1	GET /settings/me	{"query":{}}	2025-08-12 14:31:14.632+01	\N	\N	\N
2005	1	GET /settings/me	{"query":{}}	2025-08-12 14:31:14.693+01	\N	\N	\N
2006	1	GET /templates	{"query":{}}	2025-08-12 14:33:42.53+01	\N	\N	\N
2007	1	GET /templates	{"query":{}}	2025-08-12 14:33:42.629+01	\N	\N	\N
2008	1	GET /settings/me	{"query":{}}	2025-08-12 14:33:44.818+01	\N	\N	\N
2009	1	GET /settings/me	{"query":{}}	2025-08-12 14:33:44.881+01	\N	\N	\N
2010	1	GET /settings/account	{"query":{}}	2025-08-12 14:33:48.604+01	\N	\N	\N
2011	1	GET /settings/account	{"query":{}}	2025-08-12 14:33:48.66+01	\N	\N	\N
2012	1	GET /auth/me	{"query":{}}	2025-08-12 14:34:17.679+01	\N	\N	\N
2013	1	GET /auth/me	{"query":{}}	2025-08-12 14:34:17.748+01	\N	\N	\N
2014	1	GET /vms	{"query":{}}	2025-08-12 14:34:41.248+01	\N	\N	\N
2015	1	list_vms	{}	2025-08-12 14:34:41.376+01	\N	\N	\N
2016	1	GET /vms	{"query":{}}	2025-08-12 14:34:41.432+01	\N	\N	\N
2017	1	list_vms	{}	2025-08-12 14:34:41.451+01	\N	\N	\N
2018	1	Échec Déploiement Terraform	{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}	2025-08-12 14:35:21.572+01	\N	\N	\N
2019	1	GET /settings/account	{"query":{}}	2025-08-12 14:35:28.353+01	\N	\N	\N
2020	1	GET /settings/account	{"query":{}}	2025-08-12 14:35:28.406+01	\N	\N	\N
2021	1	GET /settings/me	{"query":{}}	2025-08-12 14:35:30.438+01	\N	\N	\N
2022	1	GET /settings/me	{"query":{}}	2025-08-12 14:35:30.499+01	\N	\N	\N
2023	1	GET /templates	{"query":{}}	2025-08-12 14:39:29.596+01	\N	\N	\N
2024	1	GET /templates	{"query":{}}	2025-08-12 14:39:29.663+01	\N	\N	\N
2025	1	GET /settings/me	{"query":{}}	2025-08-12 14:39:32.049+01	\N	\N	\N
2026	1	GET /settings/me	{"query":{}}	2025-08-12 14:39:32.116+01	\N	\N	\N
2027	1	GET /settings/account	{"query":{}}	2025-08-12 14:39:34.466+01	\N	\N	\N
2028	1	GET /settings/account	{"query":{}}	2025-08-12 14:39:34.534+01	\N	\N	\N
2029	1	GET /settings/account	{"query":{}}	2025-08-12 14:40:57.887+01	\N	\N	\N
2030	1	GET /settings/account	{"query":{}}	2025-08-12 14:40:57.948+01	\N	\N	\N
2031	1	GET /vms	{"query":{}}	2025-08-12 14:49:09.487+01	\N	\N	\N
2032	1	list_vms	{}	2025-08-12 14:49:09.614+01	\N	\N	\N
2033	1	GET /vms	{"query":{}}	2025-08-12 14:49:09.674+01	\N	\N	\N
2034	1	list_vms	{}	2025-08-12 14:49:09.696+01	\N	\N	\N
2035	1	GET /vms	{"query":{}}	2025-08-12 15:14:57.666+01	\N	\N	\N
2036	1	list_vms	{}	2025-08-12 15:14:57.696+01	\N	\N	\N
2037	1	GET /vms	{"query":{}}	2025-08-12 15:22:50.517+01	\N	\N	\N
2038	1	list_vms	{}	2025-08-12 15:22:50.649+01	\N	\N	\N
2039	1	GET /dashboard	{"query":{}}	2025-08-12 15:23:19.725+01	\N	\N	\N
2040	1	GET /vms	{"query":{}}	2025-08-12 15:23:19.727+01	\N	\N	\N
2041	1	list_vms	{}	2025-08-12 15:23:19.775+01	\N	\N	\N
2042	1	GET /vms	{"query":{}}	2025-08-12 15:23:19.861+01	\N	\N	\N
2043	1	GET /dashboard	{"query":{}}	2025-08-12 15:23:19.918+01	\N	\N	\N
2044	1	list_vms	{}	2025-08-12 15:23:19.936+01	\N	\N	\N
2045	1	GET /dashboard/map	{"query":{}}	2025-08-12 15:23:32.754+01	\N	\N	\N
2046	1	GET /dashboard/map	{"query":{}}	2025-08-12 15:23:32.838+01	\N	\N	\N
2047	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-12 15:23:47.406+01	\N	\N	\N
2048	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-12 15:23:47.467+01	\N	\N	\N
2049	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-12 15:23:51.739+01	\N	\N	\N
2050	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-12 15:24:08.287+01	\N	\N	\N
2051	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"88966679-e8a2-4c48-b948-75ca879e7343"},"query":{}}	2025-08-12 15:25:17.913+01	\N	\N	\N
2052	1	GET /vms	{"query":{}}	2025-08-12 15:25:51.194+01	\N	\N	\N
2053	1	list_vms	{}	2025-08-12 15:25:51.324+01	\N	\N	\N
2054	1	GET /vms	{"query":{}}	2025-08-12 15:25:51.384+01	\N	\N	\N
2055	1	list_vms	{}	2025-08-12 15:25:51.406+01	\N	\N	\N
2056	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 15:26:36.858+01	\N	\N	\N
2057	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 15:26:36.928+01	\N	\N	\N
2058	1	GET /templates?status=all	{"query":{"status":"all"}}	2025-08-12 15:26:42.711+01	\N	\N	\N
2059	1	POST /templates/27/restore	{"query":{}}	2025-08-12 15:26:44.923+01	\N	\N	\N
2060	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 15:26:55.118+01	\N	\N	\N
2061	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 15:26:55.191+01	\N	\N	\N
2062	1	GET /roles	{"query":{}}	2025-08-12 15:26:55.241+01	\N	\N	\N
2063	1	GET /roles	{"query":{}}	2025-08-12 15:26:55.359+01	\N	\N	\N
2064	1	GET /permissions/role/2	{"query":{}}	2025-08-12 15:26:55.426+01	\N	\N	\N
2065	1	GET /permissions/role/3	{"query":{}}	2025-08-12 15:26:55.472+01	\N	\N	\N
2066	1	GET /permissions/role/1	{"query":{}}	2025-08-12 15:26:55.517+01	\N	\N	\N
2067	1	GET /permissions/role/2	{"query":{}}	2025-08-12 15:26:55.692+01	\N	\N	\N
2068	1	GET /permissions/role/3	{"query":{}}	2025-08-12 15:26:55.734+01	\N	\N	\N
2069	1	GET /permissions/role/1	{"query":{}}	2025-08-12 15:26:55.781+01	\N	\N	\N
2070	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[65]}],"query":{}}	2025-08-12 15:27:25.37+01	\N	\N	\N
2071	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 15:27:30.499+01	\N	\N	\N
2072	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 15:27:30.565+01	\N	\N	\N
2073	1	GET /templates?status=all	{"query":{"status":"all"}}	2025-08-12 15:27:33.692+01	\N	\N	\N
2074	1	POST /templates/27/restore	{"query":{}}	2025-08-12 15:27:35.305+01	\N	\N	\N
2075	1	restore_template:27	{}	2025-08-12 15:27:35.316+01	\N	\N	\N
2076	1	GET /templates?status=all	{"query":{"status":"all"}}	2025-08-12 15:27:35.376+01	\N	\N	\N
2077	1	GET /settings/account	{"query":{}}	2025-08-12 15:27:46.069+01	\N	\N	\N
2078	1	GET /settings/account	{"query":{}}	2025-08-12 15:27:46.136+01	\N	\N	\N
2079	1	GET /settings/me	{"query":{}}	2025-08-12 15:28:02.806+01	\N	\N	\N
2080	1	GET /vms/nodes	{"query":{}}	2025-08-12 15:28:02.816+01	\N	\N	\N
2081	1	GET /settings/me	{"query":{}}	2025-08-12 15:28:02.902+01	\N	\N	\N
2082	1	GET /vms/nodes	{"query":{}}	2025-08-12 15:28:03.021+01	\N	\N	\N
2083	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:28:03.071+01	\N	\N	\N
2084	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:28:03.075+01	\N	\N	\N
2085	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:28:03.237+01	\N	\N	\N
2086	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:28:03.238+01	\N	\N	\N
2087	1	GET /settings/me	{"query":{}}	2025-08-12 15:28:19.45+01	\N	\N	\N
2088	1	GET /vms/nodes	{"query":{}}	2025-08-12 15:28:19.517+01	\N	\N	\N
2089	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:28:19.703+01	\N	\N	\N
2090	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:28:19.704+01	\N	\N	\N
2091	1	GET /settings/me	{"query":{}}	2025-08-12 15:57:51.371+01	\N	\N	\N
2092	1	GET /vms/nodes	{"query":{}}	2025-08-12 15:57:51.411+01	\N	\N	\N
2093	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:57:51.531+01	\N	\N	\N
2094	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-12 15:57:51.532+01	\N	\N	\N
2095	1	GET /settings/me	{"query":{}}	2025-08-12 16:03:44.556+01	\N	\N	\N
2096	1	GET /vms/nodes	{"query":{}}	2025-08-12 16:03:44.618+01	\N	\N	\N
2097	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-12 16:03:44.767+01	\N	\N	\N
2098	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-12 16:03:44.769+01	\N	\N	\N
2099	1	GET /dashboard	{"query":{}}	2025-08-12 16:04:13.334+01	\N	\N	\N
2100	1	GET /vms	{"query":{}}	2025-08-12 16:04:13.336+01	\N	\N	\N
2101	1	list_vms	{}	2025-08-12 16:04:13.389+01	\N	\N	\N
2102	1	GET /vms	{"query":{}}	2025-08-12 16:04:13.497+01	\N	\N	\N
2103	1	GET /dashboard	{"query":{}}	2025-08-12 16:04:13.505+01	\N	\N	\N
2104	1	list_vms	{}	2025-08-12 16:04:13.534+01	\N	\N	\N
2105	1	GET /settings/account	{"query":{}}	2025-08-12 16:10:13.23+01	\N	\N	\N
2106	1	GET /settings/account	{"query":{}}	2025-08-12 16:10:13.29+01	\N	\N	\N
2107	1	GET /templates	{"query":{}}	2025-08-12 16:11:47.645+01	\N	\N	\N
2108	1	GET /templates	{"query":{}}	2025-08-12 16:11:47.724+01	\N	\N	\N
2109	1	GET /settings/me	{"query":{}}	2025-08-12 16:11:49.979+01	\N	\N	\N
2110	1	GET /settings/me	{"query":{}}	2025-08-12 16:11:50.043+01	\N	\N	\N
2111	1	GET /vms/storages	{"query":{}}	2025-08-12 16:11:50.097+01	\N	\N	\N
2112	1	GET /vms/storages	{"query":{}}	2025-08-12 16:11:50.164+01	\N	\N	\N
2113	1	GET /settings/account	{"query":{}}	2025-08-12 16:11:53.277+01	\N	\N	\N
2114	1	GET /settings/account	{"query":{}}	2025-08-12 16:11:53.328+01	\N	\N	\N
2115	1	GET /settings/me	{"query":{}}	2025-08-12 16:11:54.585+01	\N	\N	\N
2116	1	GET /settings/me	{"query":{}}	2025-08-12 16:11:54.655+01	\N	\N	\N
2117	1	GET /vms/storages	{"query":{}}	2025-08-12 16:11:54.707+01	\N	\N	\N
2118	1	GET /vms/storages	{"query":{}}	2025-08-12 16:11:54.777+01	\N	\N	\N
2119	1	GET /settings/account	{"query":{}}	2025-08-12 16:12:11.239+01	\N	\N	\N
2120	1	GET /settings/account	{"query":{}}	2025-08-12 16:12:11.291+01	\N	\N	\N
2121	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:12:21.747+01	\N	\N	\N
2122	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:12:21.864+01	\N	\N	\N
2123	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-12 16:12:35.008+01	\N	\N	\N
2124	1	terminal_list_vms	{}	2025-08-12 16:12:35.037+01	\N	\N	\N
2125	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-12 16:12:35.096+01	\N	\N	\N
2126	1	terminal_list_vms	{}	2025-08-12 16:12:35.12+01	\N	\N	\N
2127	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-12 16:12:44.05+01	\N	\N	\N
2128	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 16:13:26.963+01	\N	\N	\N
2129	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-12 16:13:27.027+01	\N	\N	\N
2130	1	GET /roles	{"query":{}}	2025-08-12 16:13:27.068+01	\N	\N	\N
2131	1	GET /roles	{"query":{}}	2025-08-12 16:13:27.14+01	\N	\N	\N
2132	1	GET /permissions/role/2	{"query":{}}	2025-08-12 16:13:27.197+01	\N	\N	\N
2133	1	GET /permissions/role/1	{"query":{}}	2025-08-12 16:13:27.236+01	\N	\N	\N
2134	1	GET /permissions/role/3	{"query":{}}	2025-08-12 16:13:27.273+01	\N	\N	\N
2135	1	GET /permissions/role/2	{"query":{}}	2025-08-12 16:13:27.349+01	\N	\N	\N
2136	1	GET /permissions/role/1	{"query":{}}	2025-08-12 16:13:27.386+01	\N	\N	\N
2137	1	GET /permissions/role/3	{"query":{}}	2025-08-12 16:13:27.441+01	\N	\N	\N
2138	1	GET /roles	{"query":{}}	2025-08-12 16:14:31.705+01	\N	\N	\N
2139	1	GET /roles	{"query":{}}	2025-08-12 16:14:31.767+01	\N	\N	\N
2140	1	GET /users	{"query":{}}	2025-08-12 16:14:39.685+01	\N	\N	\N
2141	1	GET /roles	{"query":{}}	2025-08-12 16:14:39.724+01	\N	\N	\N
2142	1	GET /users	{"query":{}}	2025-08-12 16:14:39.78+01	\N	\N	\N
2143	1	GET /roles	{"query":{}}	2025-08-12 16:14:39.823+01	\N	\N	\N
2144	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:14:48.255+01	\N	\N	\N
2145	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:14:48.317+01	\N	\N	\N
2146	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:14:57.645+01	\N	\N	\N
2147	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:18:11.458+01	\N	\N	\N
2148	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:25:23.297+01	\N	\N	\N
2149	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:25:45.135+01	\N	\N	\N
2150	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:25:57.013+01	\N	\N	\N
2151	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance système\\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\n\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\n\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\n\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\n\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s},\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > ${STATUS_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${STATUS_SCRIPT_PATH}","entity_type":"template","entity_id":26},"query":{}}	2025-08-12 16:26:01.769+01	\N	\N	\N
2183	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-13 04:18:08.85+01	\N	\N	\N
2184	1	login	{"user_id":1}	2025-08-13 04:18:09.318+01	\N	\N	\N
2189	1	GET /auth/me	{"query":{}}	2025-08-13 04:31:02.654+01	\N	\N	\N
2191	1	GET /settings/account	{"query":{}}	2025-08-13 04:34:06.996+01	\N	\N	\N
2152	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\nset -euo pipefail\\n\\n# === Variables substituées par le moteur de template ===\\nSCRIPT_PATH=\\"${SCRIPT_PATH}\\"\\nSTATUS_SCRIPT_PATH=\\"${STATUS_SCRIPT_PATH}\\"\\nSERVICES_SCRIPT_PATH=\\"${SERVICES_SCRIPT_PATH}\\"\\nSTATUS_CRON_EXPR='${STATUS_CRON_EXPR}'\\nSERVICES_CRON_EXPR='${SERVICES_CRON_EXPR}'\\nCRON_USER='${CRON_USER}'\\n\\nMONITOR_DIR=\\"$(dirname \\"${STATUS_SCRIPT_PATH}\\")\\"\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nmkdir -p \\"${MONITOR_DIR}\\"\\n\\n# --- Génère le script  ---\\ncat > \\"${SCRIPT_PATH}\\" <<'EOS'\\n#!/bin/bash\\nset -euo pipefail\\n\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\nCRON_USER='__CRON_USER__'\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nexists_and_exec() {\\n  local f=\\"$1\\"\\n  [[ -f \\"$f\\" ]] || return 1\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\n  return 0\\n}\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\n\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nremove_mark() {\\n  local mark=\\"$1\\"\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\n}\\n\\nok=1\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nelse\\n  ok=0\\nfi\\n\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nelse\\n  ok=0\\nfi\\n\\nif [[ \\"$ok\\" -eq 1 ]]; then\\n  # Exécuter une première fois pour générer les JSON immédiatement\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\n  # Se retirer du crontab\\n  remove_mark \\"$MARK_BOOT\\"\\nfi\\nEOS\\n\\n# Injecte les variables réelles dans le \\nsed -i \\\\\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__CRON_USER__#${CRON_USER}#g\\" \\\\\\n  \\"${SCRIPT_PATH}\\"\\n\\nchmod +x \\"${SCRIPT_PATH}\\"\\n\\n# --- (Ré)active le service cron/ crond ---\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\nfi\\n\\n# --- Installe le cron  (toutes les minutes) ---\\ncurrent_cron=\\"$(crontab -u \\"${CRON_USER}\\" -l 2>/dev/null || true)\\"\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * ${SCRIPT_PATH} $MARK_BOOT\\"; } | crontab -u \\"${CRON_USER}\\" -\\nfi\\n\\nexit 0\\n","entity_type":"template","entity_id":25},"query":{}}	2025-08-12 16:27:33.836+01	\N	\N	\N
2153	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:28:09.553+01	\N	\N	\N
2154	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:30:53.133+01	\N	\N	\N
2155	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:30:55.771+01	\N	\N	\N
2156	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:30:57.749+01	\N	\N	\N
2157	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:31:05.78+01	\N	\N	\N
2158	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:31:24.199+01	\N	\N	\N
2159	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:31:24.283+01	\N	\N	\N
2160	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:32:34.01+01	\N	\N	\N
2161	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-12 16:32:34.092+01	\N	\N	\N
2162	1	POST /templates/analyze	{"body":{"script":"#!/bin/bash\\n\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\nmkdir -p /opt/monitoring\\n\\n# 📦 Créer le script de surveillance des services\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\n#!/bin/bash\\n\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\n\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\n  mariadb postgresql docker kubelet redis-server\\n  mongod vsftpd proftpd php-fpm\\n)\\n\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\n\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > ${SERVICES_JSON_PATH}\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\n\\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}	2025-08-12 16:32:42.441+01	\N	\N	\N
2163	1	GET /vms	{"query":{}}	2025-08-12 16:33:07.089+01	\N	\N	\N
2164	1	list_vms	{}	2025-08-12 16:33:07.35+01	\N	\N	\N
2165	1	GET /vms	{"query":{}}	2025-08-12 16:33:07.429+01	\N	\N	\N
2166	1	list_vms	{}	2025-08-12 16:33:07.453+01	\N	\N	\N
2185	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-13 04:25:06.892+01	\N	\N	\N
2186	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-13 04:25:15.313+01	\N	\N	\N
2167	1	Échec Déploiement Terraform	{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}	2025-08-12 16:38:33.423+01	\N	\N	\N
2168	1	GET /vms	{"query":{}}	2025-08-12 16:53:23.948+01	\N	\N	\N
2169	1	list_vms	{}	2025-08-12 16:53:24.066+01	\N	\N	\N
2170	1	GET /vms	{"query":{}}	2025-08-12 16:53:24.125+01	\N	\N	\N
2171	1	list_vms	{}	2025-08-12 16:53:24.146+01	\N	\N	\N
2172	1	Échec Déploiement Terraform	{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}	2025-08-12 16:57:24.188+01	\N	\N	\N
2173	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-13 03:40:19.648+01	\N	\N	\N
2174	1	login	{"user_id":1}	2025-08-13 03:40:19.77+01	\N	\N	\N
2175	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-13 03:46:43.358+01	\N	\N	\N
2176	1	login	{"user_id":1}	2025-08-13 03:46:43.527+01	\N	\N	\N
2177	1	GET /dashboard	{"query":{}}	2025-08-13 03:46:46.47+01	\N	\N	\N
2178	1	GET /vms	{"query":{}}	2025-08-13 03:46:46.472+01	\N	\N	\N
2179	1	list_vms	{}	2025-08-13 03:46:46.573+01	\N	\N	\N
2180	1	GET /vms	{"query":{}}	2025-08-13 03:46:46.647+01	\N	\N	\N
2181	1	GET /dashboard	{"query":{}}	2025-08-13 03:46:46.712+01	\N	\N	\N
2182	1	list_vms	{}	2025-08-13 03:46:46.755+01	\N	\N	\N
2187	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}	2025-08-13 04:26:48.208+01	\N	\N	\N
2188	1	login	{"user_id":1}	2025-08-13 04:26:48.712+01	\N	\N	\N
2190	1	GET /settings/account	{"query":{}}	2025-08-13 04:31:17.545+01	\N	\N	\N
2192	1	GET /settings/me	{"query":{}}	2025-08-13 04:34:21.183+01	\N	\N	\N
2193	1	GET /vms/storages	{"query":{}}	2025-08-13 04:34:21.837+01	\N	\N	\N
2194	1	GET /settings/me	{"query":{}}	2025-08-13 04:34:32.577+01	\N	\N	\N
2195	1	GET /vms/nodes	{"query":{}}	2025-08-13 04:34:32.882+01	\N	\N	\N
2196	1	GET /settings/me	{"query":{}}	2025-08-13 04:35:07.638+01	\N	\N	\N
2197	1	GET /vms/nodes	{"query":{}}	2025-08-13 04:35:07.654+01	\N	\N	\N
2198	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 04:35:19.469+01	\N	\N	\N
2199	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 04:35:38.821+01	\N	\N	\N
2200	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-13 04:35:42.845+01	\N	\N	\N
2202	1	GET /users	{"query":{}}	2025-08-13 04:35:47.947+01	\N	\N	\N
2203	1	GET /roles	{"query":{}}	2025-08-13 04:35:51.587+01	\N	\N	\N
2204	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-13 04:35:59.742+01	\N	\N	\N
2205	1	GET /roles	{"query":{}}	2025-08-13 04:36:00.166+01	\N	\N	\N
2206	1	GET /permissions/role/3	{"query":{}}	2025-08-13 04:36:01.06+01	\N	\N	\N
2207	1	GET /permissions/role/1	{"query":{}}	2025-08-13 04:36:01.117+01	\N	\N	\N
2208	1	GET /permissions/role/2	{"query":{}}	2025-08-13 04:36:01.121+01	\N	\N	\N
2209	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 04:36:07.289+01	\N	\N	\N
2210	1	GET /vms	{"query":{}}	2025-08-13 04:36:10.608+01	\N	\N	\N
2211	1	GET /dashboard	{"query":{}}	2025-08-13 04:37:26.993+01	\N	\N	\N
2212	1	GET /vms	{"query":{}}	2025-08-13 04:37:46.96+01	\N	\N	\N
2213	1	GET /vms	{"query":{}}	2025-08-13 05:33:23.733+01	\N	\N	\N
2214	1	list_vms	{}	2025-08-13 05:33:23.801+01	\N	\N	\N
2215	1	GET /vms	{"query":{}}	2025-08-13 05:33:23.826+01	\N	\N	\N
2216	1	list_vms	{}	2025-08-13 05:33:23.85+01	\N	\N	\N
2217	1	GET /vms	{"query":{}}	2025-08-13 05:41:33.829+01	\N	\N	\N
2218	1	list_vms	{}	2025-08-13 05:41:33.886+01	\N	\N	\N
2219	1	GET /vms	{"query":{}}	2025-08-13 05:50:10.405+01	\N	\N	\N
2220	1	list_vms	{}	2025-08-13 05:50:10.477+01	\N	\N	\N
2221	1	Échec Déploiement Terraform	{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}	2025-08-13 05:53:58.423+01	\N	\N	\N
2222	1	GET /vms	{"query":{}}	2025-08-13 06:12:07.026+01	\N	\N	\N
2223	1	list_vms	{}	2025-08-13 06:12:07.077+01	\N	\N	\N
2224	1	GET /vms	{"query":{}}	2025-08-13 06:12:07.095+01	\N	\N	\N
2225	1	list_vms	{}	2025-08-13 06:12:07.11+01	\N	\N	\N
2226	1	GET /vms	{"query":{}}	2025-08-13 06:12:13.765+01	\N	\N	\N
2227	1	list_vms	{}	2025-08-13 06:12:13.784+01	\N	\N	\N
2228	1	GET /vms	{"query":{}}	2025-08-13 06:12:38.671+01	\N	\N	\N
2229	1	list_vms	{}	2025-08-13 06:12:38.7+01	\N	\N	\N
2230	1	GET /auth/me	{"query":{}}	2025-08-13 06:16:31.32+01	\N	\N	\N
2231	1	GET /settings/account	{"query":{}}	2025-08-13 06:16:37.969+01	\N	\N	\N
2232	1	GET /settings/account	{"query":{}}	2025-08-13 06:16:37.988+01	\N	\N	\N
2233	1	GET /settings/me	{"query":{}}	2025-08-13 06:16:45.937+01	\N	\N	\N
2234	1	GET /vms/nodes	{"query":{}}	2025-08-13 06:16:45.946+01	\N	\N	\N
2235	1	GET /settings/me	{"query":{}}	2025-08-13 06:16:45.969+01	\N	\N	\N
2236	1	GET /vms/nodes	{"query":{}}	2025-08-13 06:16:46.005+01	\N	\N	\N
2237	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 06:16:46.033+01	\N	\N	\N
2238	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 06:16:46.034+01	\N	\N	\N
2239	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 06:16:46.076+01	\N	\N	\N
2240	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 06:16:46.077+01	\N	\N	\N
2241	1	GET /vms	{"query":{}}	2025-08-13 06:28:41.943+01	\N	\N	\N
2242	1	list_vms	{}	2025-08-13 06:28:42+01	\N	\N	\N
2243	1	GET /vms	{"query":{}}	2025-08-13 06:29:00.033+01	\N	\N	\N
2244	1	list_vms	{}	2025-08-13 06:29:00.068+01	\N	\N	\N
2245	1	PUT /settings/storage	{"body":{"proxmox_node":"pve","vm_storage":"local"},"query":{}}	2025-08-13 06:35:25.968+01	\N	\N	\N
2246	1	GET /vms	{"query":{}}	2025-08-13 06:35:38.191+01	\N	\N	\N
2247	1	list_vms	{}	2025-08-13 06:35:38.216+01	\N	\N	\N
2248	1	Échec Déploiement Terraform	{"code":"TF_APPLY_FAILED","message":"Le déploiement a échoué."}	2025-08-13 06:42:01.417+01	\N	\N	\N
2249	1	PUT /settings/storage	{"body":{"proxmox_node":"pve","vm_storage":"local-lvm"},"query":{}}	2025-08-13 06:47:40.388+01	\N	\N	\N
2250	1	PUT /settings/storage	{"body":{"proxmox_node":"pve","vm_storage":"local"},"query":{}}	2025-08-13 06:47:56.153+01	\N	\N	\N
2251	1	PUT /settings/storage	{"body":{"proxmox_node":"pve","vm_storage":"local-lvm"},"query":{}}	2025-08-13 06:48:05.904+01	\N	\N	\N
2252	1	GET /vms	{"query":{}}	2025-08-13 07:04:57.892+01	\N	\N	\N
2253	1	list_vms	{}	2025-08-13 07:04:57.948+01	\N	\N	\N
2254	1	GET /vms	{"query":{}}	2025-08-13 07:04:57.968+01	\N	\N	\N
2255	1	list_vms	{}	2025-08-13 07:04:57.986+01	\N	\N	\N
2256	1	GET /vms	{"query":{}}	2025-08-13 07:05:08.994+01	\N	\N	\N
2257	1	list_vms	{}	2025-08-13 07:05:09.023+01	\N	\N	\N
2258	1	Échec Déploiement Terraform	{"code":"TF_APPLY_FAILED","message":"Le déploiement a échoué."}	2025-08-13 07:09:27.754+01	\N	\N	\N
2259	1	GET /settings/me	{"query":{}}	2025-08-13 07:11:13.39+01	\N	\N	\N
2260	1	GET /vms/nodes	{"query":{}}	2025-08-13 07:11:13.396+01	\N	\N	\N
2261	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 07:11:13.463+01	\N	\N	\N
2262	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 07:11:13.464+01	\N	\N	\N
2263	1	GET /vms	{"query":{}}	2025-08-13 07:34:13.556+01	\N	\N	\N
2264	1	list_vms	{}	2025-08-13 07:34:13.61+01	\N	\N	\N
2265	1	GET /vms	{"query":{}}	2025-08-13 07:34:13.642+01	\N	\N	\N
2266	1	list_vms	{}	2025-08-13 07:34:13.659+01	\N	\N	\N
2267	1	Déploiement Terraform	{"vm_name":"dsfgdggd","service_type":"monitoring__cron","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-f737e3a0-19c9-4530-8526-59d196247813.log"}	2025-08-13 07:36:36.751+01	\N	\N	\N
2268	1	GET /vms	{"query":{}}	2025-08-13 07:38:02.912+01	\N	\N	\N
2269	1	list_vms	{}	2025-08-13 07:38:02.964+01	\N	\N	\N
2270	1	GET /vms	{"query":{}}	2025-08-13 07:38:02.995+01	\N	\N	\N
2271	1	list_vms	{}	2025-08-13 07:38:03.012+01	\N	\N	\N
2272	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"88966679-e8a2-4c48-b948-75ca879e7343"},"query":{}}	2025-08-13 07:51:21.566+01	\N	\N	\N
2273	1	GET /vms	{"query":{}}	2025-08-13 07:55:46.745+01	\N	\N	\N
2274	1	GET /dashboard	{"query":{}}	2025-08-13 07:55:46.746+01	\N	\N	\N
2275	1	list_vms	{}	2025-08-13 07:55:46.769+01	\N	\N	\N
2276	1	GET /vms	{"query":{}}	2025-08-13 07:55:46.793+01	\N	\N	\N
2277	1	GET /dashboard	{"query":{}}	2025-08-13 07:55:46.808+01	\N	\N	\N
2278	1	list_vms	{}	2025-08-13 07:55:46.817+01	\N	\N	\N
2279	1	GET /dashboard/map	{"query":{}}	2025-08-13 07:56:00.906+01	\N	\N	\N
2280	1	GET /dashboard/map	{"query":{}}	2025-08-13 07:56:00.935+01	\N	\N	\N
2281	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 07:56:07.927+01	\N	\N	\N
2282	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 07:56:07.944+01	\N	\N	\N
2283	1	GET /dashboard/stats?period=week	{"query":{"period":"week"}}	2025-08-13 07:56:58.952+01	\N	\N	\N
2284	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 07:57:04.241+01	\N	\N	\N
2285	1	GET /vms	{"query":{}}	2025-08-13 07:58:05.991+01	\N	\N	\N
2286	1	list_vms	{}	2025-08-13 07:58:06.04+01	\N	\N	\N
2287	1	GET /vms	{"query":{}}	2025-08-13 07:58:06.059+01	\N	\N	\N
2288	1	list_vms	{}	2025-08-13 07:58:06.074+01	\N	\N	\N
2289	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 07:59:24.758+01	\N	\N	\N
2290	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 07:59:24.79+01	\N	\N	\N
2291	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 07:59:37.438+01	\N	\N	\N
2292	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 07:59:37.467+01	\N	\N	\N
2293	1	GET /users	{"query":{}}	2025-08-13 07:59:40.834+01	\N	\N	\N
2294	1	GET /roles	{"query":{}}	2025-08-13 07:59:40.839+01	\N	\N	\N
2295	1	GET /users	{"query":{}}	2025-08-13 07:59:40.866+01	\N	\N	\N
2296	1	GET /roles	{"query":{}}	2025-08-13 07:59:40.898+01	\N	\N	\N
2297	1	GET /roles	{"query":{}}	2025-08-13 07:59:47.972+01	\N	\N	\N
2298	1	GET /users/3	{"query":{}}	2025-08-13 07:59:47.98+01	\N	\N	\N
2299	1	GET /users/3	{"query":{}}	2025-08-13 07:59:48.011+01	\N	\N	\N
2300	1	GET /roles	{"query":{}}	2025-08-13 07:59:48.018+01	\N	\N	\N
2301	1	GET /roles	{"query":{}}	2025-08-13 08:00:56.208+01	\N	\N	\N
2302	1	GET /roles	{"query":{}}	2025-08-13 08:00:56.236+01	\N	\N	\N
2303	1	PUT /roles/2	{"body":{"name":"admin","description":"User complet"},"query":{}}	2025-08-13 08:01:06.086+01	\N	\N	\N
2304	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-13 08:01:52.843+01	\N	\N	\N
2305	1	GET /permissions?page=1&limit=100	{"query":{"page":"1","limit":"100"}}	2025-08-13 08:01:52.874+01	\N	\N	\N
2306	1	GET /roles	{"query":{}}	2025-08-13 08:01:52.879+01	\N	\N	\N
2307	1	GET /roles	{"query":{}}	2025-08-13 08:01:52.917+01	\N	\N	\N
2308	1	GET /permissions/role/2	{"query":{}}	2025-08-13 08:01:52.936+01	\N	\N	\N
2309	1	GET /permissions/role/3	{"query":{}}	2025-08-13 08:01:52.947+01	\N	\N	\N
2310	1	GET /permissions/role/1	{"query":{}}	2025-08-13 08:01:52.962+01	\N	\N	\N
2311	1	GET /permissions/role/2	{"query":{}}	2025-08-13 08:01:53.001+01	\N	\N	\N
2312	1	GET /permissions/role/1	{"query":{}}	2025-08-13 08:01:53.005+01	\N	\N	\N
2313	1	GET /permissions/role/3	{"query":{}}	2025-08-13 08:01:53.024+01	\N	\N	\N
2314	1	POST /permissions	{"body":{"name":"test.permissionmodule","description":"dhdh"},"query":{}}	2025-08-13 08:02:48.403+01	\N	\N	\N
2315	1	POST /permissions	{"body":{"name":"testbe.dkjhd","description":"jdhudj"},"query":{}}	2025-08-13 08:03:07.896+01	\N	\N	\N
2316	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-13 08:04:17.123+01	\N	\N	\N
2317	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 08:04:55.448+01	\N	\N	\N
2318	1	terminal_list_vms	{}	2025-08-13 08:04:55.678+01	\N	\N	\N
2319	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 08:04:55.693+01	\N	\N	\N
2320	1	terminal_list_vms	{}	2025-08-13 08:04:55.873+01	\N	\N	\N
2321	1	POST /terminal/ssh/test	{"body":{"vm_id":"102","ip":"192.168.24.211","ssh_user":"nexus"},"query":{}}	2025-08-13 08:05:01.826+01	\N	\N	\N
2322	1	POST /terminal/ssh/exec	{"body":{"vm_id":"102","ip":"192.168.24.211","ssh_user":"nexus","command":"cd /opt"},"query":{}}	2025-08-13 08:05:07.041+01	\N	\N	\N
2323	1	POST /terminal/ssh/exec	{"body":{"vm_id":"102","ip":"192.168.24.211","ssh_user":"nexus","command":"ls"},"query":{}}	2025-08-13 08:05:09.331+01	\N	\N	\N
2324	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 08:05:19.994+01	\N	\N	\N
2325	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 08:05:20.02+01	\N	\N	\N
2326	1	PUT /templates/29	{"body":{"name":"monitoring__cron","template_content":"#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\n# === jessaie Variables substituées par le moteur de template ===\\r\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\r\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\r\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\r\\nSTATUS_CRON_EXPR='*/1 * * * *'\\r\\nSERVICES_CRON_EXPR='*/1 * * * *'\\r\\nCRON_USER='nexus'\\r\\n\\r\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nmkdir -p \\"${MONITOR_DIR}\\"\\r\\n\\r\\n# --- Génère le script  ---\\r\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\r\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\r\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\r\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\r\\nCRON_USER='__CRON_USER__'\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nexists_and_exec() {\\r\\n  local f=\\"$1\\"\\r\\n  [[ -f \\"$f\\" ]] || return 1\\r\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\r\\n  return 0\\r\\n}\\r\\n\\r\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\r\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\r\\n\\r\\nadd_cron_once() {\\r\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\r\\n  local current\\r\\n  current=\\"$(crontab_get)\\"\\r\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\r\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\r\\n  fi\\r\\n}\\r\\n\\r\\nremove_mark() {\\r\\n  local mark=\\"$1\\"\\r\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\r\\n}\\r\\n\\r\\nok=1\\r\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif [[ \\"$ok\\" -eq 1 ]]; then\\r\\n  # Exécuter une première fois pour générer les JSON immédiatement\\r\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\r\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\r\\n  # Se retirer du crontab\\r\\n  remove_mark \\"$MARK_BOOT\\"\\r\\nfi\\r\\nEOS\\r\\n\\r\\n# Injecte les variables réelles dans le \\r\\nsed -i \\\\\\r\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\r\\n  \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\n# --- (Ré)active le service cron/ crond ---\\r\\nif command -v systemctl >/dev/null 2>&1; then\\r\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\r\\nfi\\r\\n\\r\\n# --- Installe le cron  (toutes les minutes) ---\\r\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\r\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\r\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\r\\nfi\\r\\n\\r\\nexit 0\\r\\n"},"query":{}}	2025-08-13 08:05:35.924+01	\N	\N	\N
2400	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:44.061+01	\N	\N	\N
2401	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:44.067+01	\N	\N	\N
2402	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:44.074+01	\N	\N	\N
2403	1	GET /permissions?page=1&limit=10&q=&sort=name&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:57:50.811+01	\N	\N	\N
2404	1	GET /roles	{"query":{}}	2025-08-13 12:57:50.848+01	\N	\N	\N
2405	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:50.886+01	\N	\N	\N
2406	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:50.894+01	\N	\N	\N
2407	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:50.903+01	\N	\N	\N
2408	1	GET /permissions?page=2&limit=10&q=&sort=name&order=asc	{"query":{"page":"2","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:57:59.428+01	\N	\N	\N
2409	1	GET /roles	{"query":{}}	2025-08-13 12:57:59.457+01	\N	\N	\N
2410	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:59.484+01	\N	\N	\N
2528	1	login	{"user_id":1}	2025-08-13 15:01:58.783+01	\N	\N	\N
2327	1	PUT /templates/29	{"body":{"name":"monitoring__cron","template_content":"#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\n# === jessaie Variables substituées par le moteur de template ===\\r\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\r\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\r\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\r\\nSTATUS_CRON_EXPR='*/1 * * * *'\\r\\nSERVICES_CRON_EXPR='*/1 * * * *'\\r\\nCRON_USER='nexus'\\r\\n\\r\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nmkdir -p \\"${MONITOR_DIR}\\"\\r\\n\\r\\n# --- Génère le script  ---\\r\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\r\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\r\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\r\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\r\\nCRON_USER='__CRON_USER__'\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nexists_and_exec() {\\r\\n  local f=\\"$1\\"\\r\\n  [[ -f \\"$f\\" ]] || return 1\\r\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\r\\n  return 0\\r\\n}\\r\\n\\r\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\r\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\r\\n\\r\\nadd_cron_once() {\\r\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\r\\n  local current\\r\\n  current=\\"$(crontab_get)\\"\\r\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\r\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\r\\n  fi\\r\\n}\\r\\n\\r\\nremove_mark() {\\r\\n  local mark=\\"$1\\"\\r\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\r\\n}\\r\\n\\r\\nok=1\\r\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif [[ \\"$ok\\" -eq 1 ]]; then\\r\\n  # Exécuter une première fois pour générer les JSON immédiatement\\r\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\r\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\r\\n  # Se retirer du crontab\\r\\n  remove_mark \\"$MARK_BOOT\\"\\r\\nfi\\r\\nEOS\\r\\n\\r\\n# Injecte les variables réelles dans le \\r\\nsed -i \\\\\\r\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\r\\n  \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\n# --- (Ré)active le service cron/ crond ---\\r\\nif command -v systemctl >/dev/null 2>&1; then\\r\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\r\\nfi\\r\\n\\r\\n# --- Installe le cron  (toutes les minutes) ---\\r\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\r\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\r\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\r\\nfi\\r\\n\\r\\nexit 0\\r\\n"},"query":{}}	2025-08-13 08:05:40.318+01	\N	\N	\N
2328	1	GET /settings/account	{"query":{}}	2025-08-13 08:09:17.649+01	\N	\N	\N
2329	1	GET /settings/account	{"query":{}}	2025-08-13 08:09:17.671+01	\N	\N	\N
2330	1	GET /vms	{"query":{}}	2025-08-13 12:20:06.184+01	\N	\N	\N
2331	1	GET /dashboard	{"query":{}}	2025-08-13 12:20:06.186+01	\N	\N	\N
2332	1	list_vms	{}	2025-08-13 12:20:06.22+01	\N	\N	\N
2333	1	GET /vms	{"query":{}}	2025-08-13 12:20:06.243+01	\N	\N	\N
2334	1	GET /dashboard	{"query":{}}	2025-08-13 12:20:06.255+01	\N	\N	\N
2335	1	list_vms	{}	2025-08-13 12:20:06.266+01	\N	\N	\N
2336	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 12:35:49.401+01	\N	\N	\N
2337	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 12:39:37.84+01	\N	\N	\N
2338	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 12:39:50.451+01	\N	\N	\N
2339	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 12:41:29.736+01	\N	\N	\N
2340	1	login	{"user_id":1}	2025-08-13 12:41:29.933+01	\N	\N	\N
2341	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 12:44:02.17+01	\N	\N	\N
2342	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 12:44:02.205+01	\N	\N	\N
2343	1	GET /dashboard	{"query":{}}	2025-08-13 12:44:17.587+01	\N	\N	\N
2344	1	GET /vms	{"query":{}}	2025-08-13 12:44:17.588+01	\N	\N	\N
2345	1	list_vms	{}	2025-08-13 12:44:17.621+01	\N	\N	\N
2346	1	GET /vms	{"query":{}}	2025-08-13 12:44:17.656+01	\N	\N	\N
2347	1	GET /dashboard	{"query":{}}	2025-08-13 12:44:17.673+01	\N	\N	\N
2348	1	list_vms	{}	2025-08-13 12:44:17.686+01	\N	\N	\N
2349	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-13 12:44:22.411+01	\N	\N	\N
2350	1	GET /dashboard	{"query":{}}	2025-08-13 12:45:59.652+01	\N	\N	\N
2351	1	GET /vms	{"query":{}}	2025-08-13 12:45:59.653+01	\N	\N	\N
2352	1	list_vms	{}	2025-08-13 12:45:59.69+01	\N	\N	\N
2353	1	GET /dashboard/map	{"query":{}}	2025-08-13 12:46:49.077+01	\N	\N	\N
2354	1	GET /dashboard/map	{"query":{}}	2025-08-13 12:46:49.109+01	\N	\N	\N
2355	1	GET /dashboard/map	{"query":{}}	2025-08-13 12:47:12.929+01	\N	\N	\N
2356	1	GET /dashboard/map	{"query":{}}	2025-08-13 12:47:12.995+01	\N	\N	\N
2357	1	GET /dashboard/map	{"query":{}}	2025-08-13 12:47:19.247+01	\N	\N	\N
2358	1	GET /dashboard/map	{"query":{}}	2025-08-13 12:47:19.284+01	\N	\N	\N
2359	1	GET /logs?page=1&pageSize=10	{"query":{"page":"1","pageSize":"10"}}	2025-08-13 12:48:27.022+01	\N	\N	\N
2360	1	GET /logs?page=2&pageSize=10	{"query":{"page":"2","pageSize":"10"}}	2025-08-13 12:49:57.987+01	\N	\N	\N
2361	1	GET /logs?page=4&pageSize=10	{"query":{"page":"4","pageSize":"10"}}	2025-08-13 12:49:58.859+01	\N	\N	\N
2362	1	GET /logs?page=5&pageSize=10	{"query":{"page":"5","pageSize":"10"}}	2025-08-13 12:49:59.619+01	\N	\N	\N
2363	1	GET /logs?page=4&pageSize=10	{"query":{"page":"4","pageSize":"10"}}	2025-08-13 12:50:01.493+01	\N	\N	\N
2364	1	GET /logs?page=5&pageSize=10	{"query":{"page":"5","pageSize":"10"}}	2025-08-13 12:50:16.56+01	\N	\N	\N
2365	1	GET /logs?page=6&pageSize=10	{"query":{"page":"6","pageSize":"10"}}	2025-08-13 12:50:20.022+01	\N	\N	\N
2366	1	GET /logs?page=7&pageSize=10	{"query":{"page":"7","pageSize":"10"}}	2025-08-13 12:50:21.521+01	\N	\N	\N
2367	1	GET /alerts	{"query":{}}	2025-08-13 12:53:59.416+01	\N	\N	\N
2368	1	GET /alerts	{"query":{}}	2025-08-13 12:53:59.438+01	\N	\N	\N
2369	1	GET /vms	{"query":{}}	2025-08-13 12:54:17.438+01	\N	\N	\N
2370	1	list_vms	{}	2025-08-13 12:54:17.492+01	\N	\N	\N
2371	1	GET /vms	{"query":{}}	2025-08-13 12:54:17.511+01	\N	\N	\N
2372	1	list_vms	{}	2025-08-13 12:54:17.529+01	\N	\N	\N
2373	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 12:57:19.782+01	\N	\N	\N
2374	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 12:57:19.852+01	\N	\N	\N
2375	1	GET /roles	{"query":{}}	2025-08-13 12:57:19.87+01	\N	\N	\N
2376	1	GET /roles	{"query":{}}	2025-08-13 12:57:19.901+01	\N	\N	\N
2377	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:19.917+01	\N	\N	\N
2378	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:19.923+01	\N	\N	\N
2379	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:19.929+01	\N	\N	\N
2380	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:19.981+01	\N	\N	\N
2381	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:19.988+01	\N	\N	\N
2382	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:19.994+01	\N	\N	\N
2383	1	GET /permissions?page=1&limit=10&q=&sort=name&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:57:25.087+01	\N	\N	\N
2384	1	GET /roles	{"query":{}}	2025-08-13 12:57:25.116+01	\N	\N	\N
2385	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:25.146+01	\N	\N	\N
2386	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:25.152+01	\N	\N	\N
2387	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:25.157+01	\N	\N	\N
2388	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 12:57:27.658+01	\N	\N	\N
2389	1	GET /roles	{"query":{}}	2025-08-13 12:57:27.686+01	\N	\N	\N
2390	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:27.717+01	\N	\N	\N
2391	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:27.723+01	\N	\N	\N
2392	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:27.729+01	\N	\N	\N
2393	1	GET /permissions?page=1&limit=10&q=&sort=key&order=desc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"desc"}}	2025-08-13 12:57:42.579+01	\N	\N	\N
2394	1	GET /roles	{"query":{}}	2025-08-13 12:57:42.613+01	\N	\N	\N
2395	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:57:42.658+01	\N	\N	\N
2396	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:42.667+01	\N	\N	\N
2397	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:42.675+01	\N	\N	\N
2398	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 12:57:43.991+01	\N	\N	\N
2399	1	GET /roles	{"query":{}}	2025-08-13 12:57:44.026+01	\N	\N	\N
2411	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:57:59.49+01	\N	\N	\N
2414	1	GET /roles	{"query":{}}	2025-08-13 12:58:05.857+01	\N	\N	\N
2416	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:58:05.893+01	\N	\N	\N
2420	1	GET /roles	{"query":{}}	2025-08-13 12:58:10.458+01	\N	\N	\N
2422	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:58:10.498+01	\N	\N	\N
2425	1	GET /roles	{"query":{}}	2025-08-13 12:58:17.507+01	\N	\N	\N
2427	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:58:17.546+01	\N	\N	\N
2430	1	GET /roles	{"query":{}}	2025-08-13 12:58:20.655+01	\N	\N	\N
2432	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:58:20.69+01	\N	\N	\N
2435	1	GET /roles	{"query":{}}	2025-08-13 12:58:26.702+01	\N	\N	\N
2437	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:58:26.755+01	\N	\N	\N
2412	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:57:59.497+01	\N	\N	\N
2413	1	GET /permissions?page=3&limit=10&q=&sort=name&order=asc	{"query":{"page":"3","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:58:05.83+01	\N	\N	\N
2417	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:58:05.899+01	\N	\N	\N
2418	1	Déploiement Terraform	{"vm_name":"web-test","service_type":"monitoring__cron","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-542e8abc-c806-4507-862e-2e171e45784a.log"}	2025-08-13 12:58:09.201+01	\N	\N	\N
2419	1	GET /permissions?page=4&limit=10&q=&sort=name&order=asc	{"query":{"page":"4","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:58:10.427+01	\N	\N	\N
2423	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:58:10.505+01	\N	\N	\N
2424	1	GET /permissions?page=5&limit=10&q=&sort=name&order=asc	{"query":{"page":"5","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:58:17.477+01	\N	\N	\N
2428	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:58:17.553+01	\N	\N	\N
2429	1	GET /permissions?page=6&limit=10&q=&sort=name&order=asc	{"query":{"page":"6","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:58:20.626+01	\N	\N	\N
2433	1	GET /permissions/role/1	{"query":{}}	2025-08-13 12:58:20.698+01	\N	\N	\N
2434	1	GET /permissions?page=7&limit=10&q=&sort=name&order=asc	{"query":{"page":"7","limit":"10","q":"","sort":"name","order":"asc"}}	2025-08-13 12:58:26.673+01	\N	\N	\N
2438	1	GET /permissions/role/3	{"query":{}}	2025-08-13 12:58:26.765+01	\N	\N	\N
2439	1	GET /vms	{"query":{}}	2025-08-13 12:59:57.16+01	\N	\N	\N
2440	1	list_vms	{}	2025-08-13 12:59:57.228+01	\N	\N	\N
2441	1	GET /vms	{"query":{}}	2025-08-13 12:59:57.247+01	\N	\N	\N
2442	1	list_vms	{}	2025-08-13 12:59:57.264+01	\N	\N	\N
2415	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:58:05.887+01	\N	\N	\N
2421	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:58:10.492+01	\N	\N	\N
2426	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:58:17.54+01	\N	\N	\N
2431	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:58:20.682+01	\N	\N	\N
2436	1	GET /permissions/role/2	{"query":{}}	2025-08-13 12:58:26.739+01	\N	\N	\N
2443	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 13:00:08.431+01	\N	\N	\N
2444	1	terminal_list_vms	{}	2025-08-13 13:00:10.387+01	\N	\N	\N
2445	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 13:00:10.409+01	\N	\N	\N
2446	1	terminal_list_vms	{}	2025-08-13 13:00:11.396+01	\N	\N	\N
2447	1	POST /terminal/ssh/test	{"body":{"vm_id":"101","ip":"192.168.24.206","ssh_user":"nexus"},"query":{}}	2025-08-13 13:00:16.555+01	\N	\N	\N
2448	1	POST /terminal/ssh/test	{"body":{"vm_id":"101","ip":"192.168.24.206","ssh_user":"nexus"},"query":{}}	2025-08-13 13:00:48.269+01	\N	\N	\N
2449	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 13:02:02.615+01	\N	\N	\N
2450	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 13:02:02.642+01	\N	\N	\N
2451	1	GET /settings/account	{"query":{}}	2025-08-13 13:05:07.2+01	\N	\N	\N
2452	1	GET /settings/account	{"query":{}}	2025-08-13 13:05:07.226+01	\N	\N	\N
2453	1	GET /settings/me	{"query":{}}	2025-08-13 13:05:31.926+01	\N	\N	\N
2454	1	GET /vms/nodes	{"query":{}}	2025-08-13 13:05:31.938+01	\N	\N	\N
2455	1	GET /settings/me	{"query":{}}	2025-08-13 13:05:31.956+01	\N	\N	\N
2456	1	GET /vms/nodes	{"query":{}}	2025-08-13 13:05:31.978+01	\N	\N	\N
2457	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:05:32.012+01	\N	\N	\N
2458	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:05:32.013+01	\N	\N	\N
2459	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:05:32.072+01	\N	\N	\N
2460	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:05:32.074+01	\N	\N	\N
2461	1	GET /vms/nodes	{"query":{}}	2025-08-13 13:06:00.019+01	\N	\N	\N
2462	1	GET /settings/me	{"query":{}}	2025-08-13 13:06:00.061+01	\N	\N	\N
2463	1	GET /settings/me	{"query":{}}	2025-08-13 13:06:00.103+01	\N	\N	\N
2464	1	GET /vms/nodes	{"query":{}}	2025-08-13 13:06:00.128+01	\N	\N	\N
2465	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:06:00.149+01	\N	\N	\N
2466	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:06:00.15+01	\N	\N	\N
2467	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:06:00.196+01	\N	\N	\N
2468	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 13:06:00.198+01	\N	\N	\N
2469	1	GET /dashboard	{"query":{}}	2025-08-13 13:06:59.481+01	\N	\N	\N
2470	1	GET /vms	{"query":{}}	2025-08-13 13:06:59.482+01	\N	\N	\N
2471	1	list_vms	{}	2025-08-13 13:06:59.528+01	\N	\N	\N
2472	1	GET /vms	{"query":{}}	2025-08-13 13:06:59.565+01	\N	\N	\N
2473	1	GET /dashboard	{"query":{}}	2025-08-13 13:06:59.566+01	\N	\N	\N
2474	1	list_vms	{}	2025-08-13 13:06:59.591+01	\N	\N	\N
2475	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":null},"query":{}}	2025-08-13 13:09:33.498+01	\N	\N	\N
2476	1	logout	{"user_id":1}	2025-08-13 13:09:33.504+01	\N	\N	\N
2477	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":true,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 13:09:53.703+01	\N	\N	\N
2478	1	login	{"user_id":1}	2025-08-13 13:09:54.043+01	\N	\N	\N
2479	1	GET /dashboard	{"query":{}}	2025-08-13 13:09:54.516+01	\N	\N	\N
2480	1	GET /vms	{"query":{}}	2025-08-13 13:09:54.517+01	\N	\N	\N
2481	1	list_vms	{}	2025-08-13 13:09:54.566+01	\N	\N	\N
2482	1	GET /vms	{"query":{}}	2025-08-13 13:09:54.603+01	\N	\N	\N
2483	1	GET /dashboard	{"query":{}}	2025-08-13 13:09:54.604+01	\N	\N	\N
2484	1	list_vms	{}	2025-08-13 13:09:54.63+01	\N	\N	\N
2485	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 13:10:30.409+01	\N	\N	\N
2486	1	login	{"user_id":1}	2025-08-13 13:10:30.624+01	\N	\N	\N
2487	1	GET /dashboard	{"query":{}}	2025-08-13 13:10:31.129+01	\N	\N	\N
2488	1	GET /vms	{"query":{}}	2025-08-13 13:10:31.13+01	\N	\N	\N
2489	1	list_vms	{}	2025-08-13 13:10:31.189+01	\N	\N	\N
2490	1	GET /dashboard	{"query":{}}	2025-08-13 13:10:31.224+01	\N	\N	\N
2491	1	GET /vms	{"query":{}}	2025-08-13 13:10:31.225+01	\N	\N	\N
2492	1	list_vms	{}	2025-08-13 13:10:31.255+01	\N	\N	\N
2493	1	GET /dashboard	{"query":{}}	2025-08-13 14:11:19.922+01	\N	\N	\N
2494	1	GET /vms	{"query":{}}	2025-08-13 14:11:19.925+01	\N	\N	\N
2495	1	list_vms	{}	2025-08-13 14:11:19.982+01	\N	\N	\N
2496	1	GET /vms	{"query":{}}	2025-08-13 14:11:20.016+01	\N	\N	\N
2497	1	GET /dashboard	{"query":{}}	2025-08-13 14:11:20.021+01	\N	\N	\N
2498	1	list_vms	{}	2025-08-13 14:11:20.042+01	\N	\N	\N
2499	1	POST /auth/logout	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6ImQ5YWNiYmU0LWI0OGMtNDhlYi1hNTM0LWZjYzVlNzgyY2UyYyIsImlhdCI6MTc1NTA4Njk5NCwiZXhwIjoxNzU1NjkxNzk0LCJqdGkiOiI3YjFkNzI0NS03MmM0LTQwMGEtYTVmNy0yYjNjYjg0ODZlNzYifQ.B6dyY_UuF_Wid4FZenFGdmkn3VyT-y1_P_acpJ5ecSM","device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 14:17:25.848+01	\N	\N	\N
2500	1	logout	{"user_id":1}	2025-08-13 14:17:25.87+01	\N	\N	\N
2501	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 14:17:37.92+01	\N	\N	\N
2502	1	login	{"user_id":1}	2025-08-13 14:17:38.131+01	\N	\N	\N
2503	1	GET /dashboard	{"query":{}}	2025-08-13 14:39:46.486+01	\N	\N	\N
2504	1	GET /vms	{"query":{}}	2025-08-13 14:39:46.488+01	\N	\N	\N
2505	1	list_vms	{}	2025-08-13 14:39:46.569+01	\N	\N	\N
2506	1	GET /vms	{"query":{}}	2025-08-13 14:39:46.704+01	\N	\N	\N
2507	1	GET /dashboard	{"query":{}}	2025-08-13 14:39:46.725+01	\N	\N	\N
2508	1	list_vms	{}	2025-08-13 14:39:46.743+01	\N	\N	\N
2509	1	GET /logs?sort=timestamp&order=desc&page=1&limit=10	{"query":{"sort":"timestamp","order":"desc","page":"1","limit":"10"}}	2025-08-13 14:41:21.65+01	\N	\N	\N
2510	1	GET /logs?sort=timestamp&order=desc&page=1&limit=10	{"query":{"sort":"timestamp","order":"desc","page":"1","limit":"10"}}	2025-08-13 14:42:10.247+01	\N	\N	\N
2511	1	GET /auth/me	{"query":{}}	2025-08-13 14:52:13.983+01	\N	\N	\N
2512	1	GET /auth/me	{"query":{}}	2025-08-13 14:52:14.045+01	\N	\N	\N
2513	1	GET /auth/me	{"query":{}}	2025-08-13 14:52:24.609+01	\N	\N	\N
2514	1	GET /auth/me	{"query":{}}	2025-08-13 14:52:24.651+01	\N	\N	\N
2515	1	GET /dashboard	{"query":{}}	2025-08-13 14:53:04.885+01	\N	\N	\N
2516	1	GET /vms	{"query":{}}	2025-08-13 14:53:04.885+01	\N	\N	\N
2517	1	list_vms	{}	2025-08-13 14:53:04.934+01	\N	\N	\N
2518	1	GET /vms	{"query":{}}	2025-08-13 14:53:04.969+01	\N	\N	\N
2519	1	GET /dashboard	{"query":{}}	2025-08-13 14:53:04.97+01	\N	\N	\N
2520	1	list_vms	{}	2025-08-13 14:53:05+01	\N	\N	\N
2521	1	GET /dashboard/map	{"query":{}}	2025-08-13 14:54:10.15+01	\N	\N	\N
2522	1	GET /dashboard/map	{"query":{}}	2025-08-13 14:54:10.185+01	\N	\N	\N
2523	1	GET /dashboard/map	{"query":{}}	2025-08-13 14:54:34.265+01	\N	\N	\N
2524	1	GET /dashboard/map	{"query":{}}	2025-08-13 14:54:34.34+01	\N	\N	\N
2525	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:00:25.33+01	\N	\N	\N
2526	1	logout	{"user_id":1}	2025-08-13 15:00:25.345+01	\N	\N	\N
2527	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:01:58.532+01	\N	\N	\N
2529	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:01:59.289+01	\N	\N	\N
2530	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:01:59.361+01	\N	\N	\N
2531	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:02:10.524+01	\N	\N	\N
2532	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:02:10.639+01	\N	\N	\N
2533	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:11:12.294+01	\N	\N	\N
2534	1	logout	{"user_id":1}	2025-08-13 15:11:12.309+01	\N	\N	\N
2535	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":true,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:11:26.193+01	\N	\N	\N
2536	1	login	{"user_id":1}	2025-08-13 15:11:26.383+01	\N	\N	\N
2537	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:11:30.823+01	\N	\N	\N
2538	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:11:30.89+01	\N	\N	\N
2539	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:16:11.341+01	\N	\N	\N
2540	1	login	{"user_id":1}	2025-08-13 15:16:11.589+01	\N	\N	\N
2541	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:16:12.153+01	\N	\N	\N
2542	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:16:12.219+01	\N	\N	\N
2543	1	GET /settings/me	{"query":{}}	2025-08-13 15:18:32.179+01	\N	\N	\N
2544	1	GET /settings/me	{"query":{}}	2025-08-13 15:18:32.214+01	\N	\N	\N
2545	1	GET /vms/storages	{"query":{}}	2025-08-13 15:18:32.243+01	\N	\N	\N
2546	1	GET /vms/storages	{"query":{}}	2025-08-13 15:18:32.327+01	\N	\N	\N
2547	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:18:43.618+01	\N	\N	\N
2548	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:18:43.678+01	\N	\N	\N
2549	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:19:53.671+01	\N	\N	\N
2550	1	logout	{"user_id":1}	2025-08-13 15:19:53.687+01	\N	\N	\N
2551	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:20:06.97+01	\N	\N	\N
2552	1	login	{"user_id":1}	2025-08-13 15:20:07.208+01	\N	\N	\N
2553	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:20:07.771+01	\N	\N	\N
2554	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:20:07.839+01	\N	\N	\N
2555	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:20:14.687+01	\N	\N	\N
2556	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:20:14.849+01	\N	\N	\N
2557	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:20:39.112+01	\N	\N	\N
2558	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:20:40.352+01	\N	\N	\N
2559	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:20:41.709+01	\N	\N	\N
2560	1	GET /settings/me	{"query":{}}	2025-08-13 15:21:06.539+01	\N	\N	\N
2561	1	GET /settings/me	{"query":{}}	2025-08-13 15:21:06.563+01	\N	\N	\N
2562	1	GET /vms/storages	{"query":{}}	2025-08-13 15:21:06.583+01	\N	\N	\N
2563	1	GET /vms/storages	{"query":{}}	2025-08-13 15:21:06.642+01	\N	\N	\N
2564	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:21:46.677+01	\N	\N	\N
2565	1	logout	{"user_id":1}	2025-08-13 15:21:46.691+01	\N	\N	\N
2566	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:21:53.5+01	\N	\N	\N
2567	1	login	{"user_id":1}	2025-08-13 15:21:53.657+01	\N	\N	\N
2568	1	GET /settings/me	{"query":{}}	2025-08-13 15:21:54.162+01	\N	\N	\N
2569	1	GET /settings/me	{"query":{}}	2025-08-13 15:21:54.192+01	\N	\N	\N
2570	1	GET /vms/storages	{"query":{}}	2025-08-13 15:21:54.214+01	\N	\N	\N
2571	1	GET /vms/storages	{"query":{}}	2025-08-13 15:21:54.283+01	\N	\N	\N
2572	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:22:16.755+01	\N	\N	\N
2573	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:22:16.814+01	\N	\N	\N
2574	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:26:16.461+01	\N	\N	\N
2575	1	logout	{"user_id":1}	2025-08-13 15:26:16.479+01	\N	\N	\N
2576	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:27:15.668+01	\N	\N	\N
2577	1	login	{"user_id":1}	2025-08-13 15:27:15.844+01	\N	\N	\N
2578	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:27:16.363+01	\N	\N	\N
2579	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:27:16.432+01	\N	\N	\N
2580	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:30:05.528+01	\N	\N	\N
2581	1	logout	{"user_id":1}	2025-08-13 15:30:05.542+01	\N	\N	\N
2582	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:32:25.983+01	\N	\N	\N
2583	1	login	{"user_id":1}	2025-08-13 15:32:26.142+01	\N	\N	\N
2584	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:32:26.685+01	\N	\N	\N
2585	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:32:26.766+01	\N	\N	\N
2586	1	GET /dashboard	{"query":{}}	2025-08-13 15:32:33.051+01	\N	\N	\N
2587	1	GET /vms	{"query":{}}	2025-08-13 15:32:33.054+01	\N	\N	\N
2588	1	list_vms	{}	2025-08-13 15:32:33.132+01	\N	\N	\N
2589	1	GET /vms	{"query":{}}	2025-08-13 15:32:33.179+01	\N	\N	\N
2590	1	list_vms	{}	2025-08-13 15:32:33.259+01	\N	\N	\N
2591	1	GET /dashboard	{"query":{}}	2025-08-13 15:32:33.275+01	\N	\N	\N
2592	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:32:40.84+01	\N	\N	\N
2593	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:32:40.907+01	\N	\N	\N
2594	1	GET /dashboard	{"query":{}}	2025-08-13 15:32:45.388+01	\N	\N	\N
2595	1	GET /vms	{"query":{}}	2025-08-13 15:32:45.39+01	\N	\N	\N
2596	1	list_vms	{}	2025-08-13 15:32:45.43+01	\N	\N	\N
2597	1	GET /vms	{"query":{}}	2025-08-13 15:32:45.456+01	\N	\N	\N
2598	1	list_vms	{}	2025-08-13 15:32:45.492+01	\N	\N	\N
2599	1	GET /dashboard	{"query":{}}	2025-08-13 15:32:45.511+01	\N	\N	\N
2600	1	GET /dashboard	{"query":{}}	2025-08-13 15:32:51.699+01	\N	\N	\N
2601	1	GET /vms	{"query":{}}	2025-08-13 15:32:51.7+01	\N	\N	\N
2602	1	list_vms	{}	2025-08-13 15:32:51.808+01	\N	\N	\N
2603	1	GET /vms	{"query":{}}	2025-08-13 15:32:51.846+01	\N	\N	\N
2604	1	list_vms	{}	2025-08-13 15:32:51.896+01	\N	\N	\N
2605	1	GET /dashboard	{"query":{}}	2025-08-13 15:32:51.898+01	\N	\N	\N
2606	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:34:22.331+01	\N	\N	\N
2607	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:34:22.395+01	\N	\N	\N
2608	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:34:28.295+01	\N	\N	\N
2609	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:34:28.437+01	\N	\N	\N
2610	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:37:25.953+01	\N	\N	\N
2611	1	login	{"user_id":1}	2025-08-13 15:37:26.18+01	\N	\N	\N
2612	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:37:26.72+01	\N	\N	\N
2613	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:37:26.802+01	\N	\N	\N
2614	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:39:26.471+01	\N	\N	\N
2615	1	login	{"user_id":1}	2025-08-13 15:39:26.666+01	\N	\N	\N
2616	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:39:27.161+01	\N	\N	\N
2617	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:39:27.232+01	\N	\N	\N
2618	1	GET /dashboard	{"query":{}}	2025-08-13 15:39:35.86+01	\N	\N	\N
2619	1	GET /vms	{"query":{}}	2025-08-13 15:39:35.863+01	\N	\N	\N
2620	1	list_vms	{}	2025-08-13 15:39:35.932+01	\N	\N	\N
2621	1	GET /dashboard	{"query":{}}	2025-08-13 15:39:35.934+01	\N	\N	\N
2622	1	GET /vms	{"query":{}}	2025-08-13 15:39:35.966+01	\N	\N	\N
2623	1	list_vms	{}	2025-08-13 15:39:35.994+01	\N	\N	\N
2624	1	GET /dashboard	{"query":{}}	2025-08-13 15:39:39.507+01	\N	\N	\N
2625	1	GET /vms	{"query":{}}	2025-08-13 15:39:39.508+01	\N	\N	\N
2626	1	list_vms	{}	2025-08-13 15:39:39.561+01	\N	\N	\N
2628	1	GET /vms	{"query":{}}	2025-08-13 15:39:39.595+01	\N	\N	\N
2627	1	GET /dashboard	{"query":{}}	2025-08-13 15:39:39.564+01	\N	\N	\N
2629	1	list_vms	{}	2025-08-13 15:39:39.62+01	\N	\N	\N
2630	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:40:09.862+01	\N	\N	\N
2631	1	logout	{"user_id":1}	2025-08-13 15:40:09.879+01	\N	\N	\N
2632	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"adnas123.","remember":false},"query":{}}	2025-08-13 15:46:27.347+01	\N	\N	\N
2633	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:46:32.613+01	\N	\N	\N
2634	1	login	{"user_id":1}	2025-08-13 15:46:32.751+01	\N	\N	\N
2635	1	GET /dashboard	{"query":{}}	2025-08-13 15:46:33.379+01	\N	\N	\N
2636	1	GET /vms	{"query":{}}	2025-08-13 15:46:33.38+01	\N	\N	\N
2637	1	list_vms	{}	2025-08-13 15:46:33.467+01	\N	\N	\N
2638	1	GET /dashboard	{"query":{}}	2025-08-13 15:46:33.474+01	\N	\N	\N
2639	1	GET /vms	{"query":{}}	2025-08-13 15:46:33.498+01	\N	\N	\N
2640	1	list_vms	{}	2025-08-13 15:46:33.532+01	\N	\N	\N
2641	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:48:06.834+01	\N	\N	\N
2642	1	logout	{"user_id":1}	2025-08-13 15:48:06.84+01	\N	\N	\N
2643	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:49:06.507+01	\N	\N	\N
2644	1	login	{"user_id":1}	2025-08-13 15:49:06.7+01	\N	\N	\N
2645	1	GET /dashboard	{"query":{}}	2025-08-13 15:49:07.258+01	\N	\N	\N
2646	1	GET /vms	{"query":{}}	2025-08-13 15:49:07.259+01	\N	\N	\N
2647	1	list_vms	{}	2025-08-13 15:49:07.367+01	\N	\N	\N
2648	1	GET /dashboard	{"query":{}}	2025-08-13 15:49:07.374+01	\N	\N	\N
2649	1	GET /vms	{"query":{}}	2025-08-13 15:49:07.403+01	\N	\N	\N
2650	1	list_vms	{}	2025-08-13 15:49:07.438+01	\N	\N	\N
2651	1	GET /dashboard	{"query":{}}	2025-08-13 15:49:10.689+01	\N	\N	\N
2652	1	GET /vms	{"query":{}}	2025-08-13 15:49:10.691+01	\N	\N	\N
2653	1	list_vms	{}	2025-08-13 15:49:10.731+01	\N	\N	\N
2654	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:49:12.858+01	\N	\N	\N
2655	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:49:12.907+01	\N	\N	\N
2656	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:51:11.785+01	\N	\N	\N
2657	1	login	{"user_id":1}	2025-08-13 15:51:11.967+01	\N	\N	\N
2658	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:51:12.459+01	\N	\N	\N
2659	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:51:12.538+01	\N	\N	\N
2660	1	GET /dashboard	{"query":{}}	2025-08-13 15:51:25.259+01	\N	\N	\N
2661	1	GET /vms	{"query":{}}	2025-08-13 15:51:25.261+01	\N	\N	\N
2662	1	list_vms	{}	2025-08-13 15:51:25.317+01	\N	\N	\N
2663	1	GET /dashboard	{"query":{}}	2025-08-13 15:51:25.337+01	\N	\N	\N
2664	1	GET /vms	{"query":{}}	2025-08-13 15:51:25.354+01	\N	\N	\N
2665	1	list_vms	{}	2025-08-13 15:51:25.386+01	\N	\N	\N
2666	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:51:34.172+01	\N	\N	\N
2667	1	logout	{"user_id":1}	2025-08-13 15:51:34.186+01	\N	\N	\N
2668	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:51:41.865+01	\N	\N	\N
2669	1	login	{"user_id":1}	2025-08-13 15:51:42.021+01	\N	\N	\N
2670	1	GET /dashboard	{"query":{}}	2025-08-13 15:51:42.546+01	\N	\N	\N
2671	1	GET /vms	{"query":{}}	2025-08-13 15:51:42.548+01	\N	\N	\N
2672	1	list_vms	{}	2025-08-13 15:51:42.608+01	\N	\N	\N
2673	1	GET /vms	{"query":{}}	2025-08-13 15:51:42.674+01	\N	\N	\N
2674	1	GET /dashboard	{"query":{}}	2025-08-13 15:51:42.693+01	\N	\N	\N
2675	1	list_vms	{}	2025-08-13 15:51:42.715+01	\N	\N	\N
2676	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:53:43.665+01	\N	\N	\N
2677	1	login	{"user_id":1}	2025-08-13 15:53:43.866+01	\N	\N	\N
2678	1	GET /dashboard	{"query":{}}	2025-08-13 15:53:44.388+01	\N	\N	\N
2679	1	GET /vms	{"query":{}}	2025-08-13 15:53:44.39+01	\N	\N	\N
2680	1	list_vms	{}	2025-08-13 15:53:44.493+01	\N	\N	\N
2681	1	GET /vms	{"query":{}}	2025-08-13 15:53:44.599+01	\N	\N	\N
2682	1	GET /dashboard	{"query":{}}	2025-08-13 15:53:44.624+01	\N	\N	\N
2683	1	list_vms	{}	2025-08-13 15:53:44.649+01	\N	\N	\N
2684	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:53:46.759+01	\N	\N	\N
2685	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:53:46.815+01	\N	\N	\N
2686	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:54:08.256+01	\N	\N	\N
2687	1	logout	{"user_id":1}	2025-08-13 15:54:08.272+01	\N	\N	\N
2688	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:54:27.173+01	\N	\N	\N
2689	1	login	{"user_id":1}	2025-08-13 15:54:27.406+01	\N	\N	\N
2690	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:54:27.903+01	\N	\N	\N
2691	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:54:27.985+01	\N	\N	\N
2692	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 15:57:07.882+01	\N	\N	\N
2693	1	logout	{"user_id":1}	2025-08-13 15:57:07.894+01	\N	\N	\N
2694	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 15:57:59.394+01	\N	\N	\N
2695	1	login	{"user_id":1}	2025-08-13 15:57:59.579+01	\N	\N	\N
2696	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:58:00.036+01	\N	\N	\N
2697	1	GET /dashboard/map	{"query":{}}	2025-08-13 15:58:00.109+01	\N	\N	\N
2698	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:05:30.501+01	\N	\N	\N
2699	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 16:09:28.372+01	\N	\N	\N
2700	1	login	{"user_id":1}	2025-08-13 16:09:28.607+01	\N	\N	\N
2701	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:09:29.077+01	\N	\N	\N
2702	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:09:29.145+01	\N	\N	\N
2703	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:17:04.135+01	\N	\N	\N
2704	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:17:05.479+01	\N	\N	\N
2705	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:17:07.303+01	\N	\N	\N
2706	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:17:14.888+01	\N	\N	\N
2707	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:17:15.012+01	\N	\N	\N
2708	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:18:55.774+01	\N	\N	\N
2709	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:19:03.348+01	\N	\N	\N
2710	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 16:21:58.362+01	\N	\N	\N
2711	1	login	{"user_id":1}	2025-08-13 16:21:58.549+01	\N	\N	\N
2712	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:21:59.032+01	\N	\N	\N
2713	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:21:59.106+01	\N	\N	\N
2714	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:22:20.848+01	\N	\N	\N
2715	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:22:20.982+01	\N	\N	\N
2716	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:22:53.717+01	\N	\N	\N
2717	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:22:53.793+01	\N	\N	\N
2718	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:24:13.837+01	\N	\N	\N
2719	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 16:25:57.773+01	\N	\N	\N
2720	1	logout	{"user_id":1}	2025-08-13 16:25:57.789+01	\N	\N	\N
2721	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin2023.","remember":false},"query":{}}	2025-08-13 16:26:04.817+01	\N	\N	\N
2722	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123..","remember":false},"query":{}}	2025-08-13 16:26:13.448+01	\N	\N	\N
2723	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 16:26:16.172+01	\N	\N	\N
2724	1	login	{"user_id":1}	2025-08-13 16:26:16.314+01	\N	\N	\N
2725	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:26:16.811+01	\N	\N	\N
2726	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:26:16.883+01	\N	\N	\N
2727	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:26:53.671+01	\N	\N	\N
2728	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:26:53.712+01	\N	\N	\N
2729	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:27:31.886+01	\N	\N	\N
2730	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:27:31.976+01	\N	\N	\N
2731	1	GET /vms	{"query":{}}	2025-08-13 16:30:17.095+01	\N	\N	\N
2732	1	list_vms	{}	2025-08-13 16:30:17.186+01	\N	\N	\N
2733	1	GET /vms	{"query":{}}	2025-08-13 16:30:17.21+01	\N	\N	\N
2734	1	list_vms	{}	2025-08-13 16:30:17.243+01	\N	\N	\N
2735	1	GET /vms	{"query":{}}	2025-08-13 16:30:57.575+01	\N	\N	\N
2736	1	list_vms	{}	2025-08-13 16:30:57.643+01	\N	\N	\N
2737	1	GET /vms	{"query":{}}	2025-08-13 16:30:57.669+01	\N	\N	\N
2738	1	list_vms	{}	2025-08-13 16:30:57.689+01	\N	\N	\N
2739	1	GET /dashboard	{"query":{}}	2025-08-13 16:32:06.343+01	\N	\N	\N
2740	1	GET /vms	{"query":{}}	2025-08-13 16:32:06.344+01	\N	\N	\N
2741	1	list_vms	{}	2025-08-13 16:32:06.391+01	\N	\N	\N
2742	1	GET /vms	{"query":{}}	2025-08-13 16:32:06.459+01	\N	\N	\N
2743	1	GET /dashboard	{"query":{}}	2025-08-13 16:32:06.46+01	\N	\N	\N
2744	1	list_vms	{}	2025-08-13 16:32:06.485+01	\N	\N	\N
2745	1	GET /vms	{"query":{}}	2025-08-13 16:32:10.171+01	\N	\N	\N
2746	1	list_vms	{}	2025-08-13 16:32:10.248+01	\N	\N	\N
2747	1	GET /vms	{"query":{}}	2025-08-13 16:32:10.267+01	\N	\N	\N
2748	1	list_vms	{}	2025-08-13 16:32:10.289+01	\N	\N	\N
2749	1	GET /vms	{"query":{}}	2025-08-13 16:32:28.057+01	\N	\N	\N
2750	1	GET /dashboard	{"query":{}}	2025-08-13 16:32:28.058+01	\N	\N	\N
2751	1	list_vms	{}	2025-08-13 16:32:28.107+01	\N	\N	\N
2752	1	GET /vms	{"query":{}}	2025-08-13 16:32:28.147+01	\N	\N	\N
2753	1	GET /dashboard	{"query":{}}	2025-08-13 16:32:28.189+01	\N	\N	\N
2754	1	list_vms	{}	2025-08-13 16:32:28.206+01	\N	\N	\N
2755	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:34:10.227+01	\N	\N	\N
2756	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:34:10.264+01	\N	\N	\N
2757	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:35:37.656+01	\N	\N	\N
2758	1	GET /dashboard/map	{"query":{}}	2025-08-13 16:35:37.722+01	\N	\N	\N
2759	1	GET /vms	{"query":{}}	2025-08-13 16:35:41.591+01	\N	\N	\N
2760	1	list_vms	{}	2025-08-13 16:35:41.645+01	\N	\N	\N
2761	1	GET /vms	{"query":{}}	2025-08-13 16:35:41.672+01	\N	\N	\N
2762	1	list_vms	{}	2025-08-13 16:35:41.695+01	\N	\N	\N
2763	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 16:35:57.923+01	\N	\N	\N
2764	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 16:35:57.972+01	\N	\N	\N
2765	1	POST /vms/delete	{"body":{"vm_id":102,"instance_id":"f737e3a0-19c9-4530-8526-59d196247813"},"query":{}}	2025-08-13 16:36:45.394+01	\N	\N	\N
2766	1	POST /vms/delete	{"body":{"vm_id":103,"instance_id":"793826a0-2600-40a4-bdd8-2fd2209e4df9"},"query":{}}	2025-08-13 16:36:53.775+01	\N	\N	\N
2767	1	POST /vms/delete	{"body":{"vm_id":101,"instance_id":"542e8abc-c806-4507-862e-2e171e45784a"},"query":{}}	2025-08-13 16:36:59.774+01	\N	\N	\N
2768	1	GET /vms	{"query":{}}	2025-08-13 16:37:14.016+01	\N	\N	\N
2769	1	list_vms	{}	2025-08-13 16:37:14.077+01	\N	\N	\N
2770	1	GET /vms	{"query":{}}	2025-08-13 16:37:14.105+01	\N	\N	\N
2771	1	list_vms	{}	2025-08-13 16:37:14.123+01	\N	\N	\N
2772	1	GET /vms	{"query":{}}	2025-08-13 16:39:10.398+01	\N	\N	\N
2773	1	list_vms	{}	2025-08-13 16:39:10.503+01	\N	\N	\N
2774	1	GET /vms	{"query":{}}	2025-08-13 16:39:10.527+01	\N	\N	\N
2775	1	list_vms	{}	2025-08-13 16:39:10.569+01	\N	\N	\N
2776	1	GET /vms	{"query":{}}	2025-08-13 16:40:05.998+01	\N	\N	\N
2777	1	GET /dashboard	{"query":{}}	2025-08-13 16:40:05.999+01	\N	\N	\N
2778	1	list_vms	{}	2025-08-13 16:40:06.041+01	\N	\N	\N
2779	1	GET /vms	{"query":{}}	2025-08-13 16:40:06.073+01	\N	\N	\N
2780	1	GET /dashboard	{"query":{}}	2025-08-13 16:40:06.099+01	\N	\N	\N
2781	1	list_vms	{}	2025-08-13 16:40:06.114+01	\N	\N	\N
2782	1	Déploiement Terraform	{"vm_name":"testweb","service_type":"monitoring__cron","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-54426125-bc6f-4cce-87d2-4dcfa3d6bcf6.log"}	2025-08-13 16:40:18.961+01	\N	\N	\N
2783	1	GET /vms	{"query":{}}	2025-08-13 16:42:45.798+01	\N	\N	\N
2784	1	GET /dashboard	{"query":{}}	2025-08-13 16:42:45.818+01	\N	\N	\N
2785	1	list_vms	{}	2025-08-13 16:42:45.878+01	\N	\N	\N
2786	1	GET /vms	{"query":{}}	2025-08-13 16:42:48.039+01	\N	\N	\N
2787	1	GET /dashboard	{"query":{}}	2025-08-13 16:42:48.04+01	\N	\N	\N
2788	1	list_vms	{}	2025-08-13 16:42:48.067+01	\N	\N	\N
2789	1	GET /vms	{"query":{}}	2025-08-13 16:43:00.29+01	\N	\N	\N
2790	1	list_vms	{}	2025-08-13 16:43:00.351+01	\N	\N	\N
2791	1	GET /vms	{"query":{}}	2025-08-13 16:43:00.382+01	\N	\N	\N
2792	1	list_vms	{}	2025-08-13 16:43:00.405+01	\N	\N	\N
2793	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 16:45:38.305+01	\N	\N	\N
2794	1	logout	{"user_id":1}	2025-08-13 16:45:38.311+01	\N	\N	\N
2795	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 16:45:43.615+01	\N	\N	\N
2796	1	logout	{"user_id":1}	2025-08-13 16:45:43.619+01	\N	\N	\N
2797	1	GET /vms	{"query":{}}	2025-08-13 16:48:13.822+01	\N	\N	\N
2798	1	list_vms	{}	2025-08-13 16:48:13.897+01	\N	\N	\N
2799	1	GET /vms	{"query":{}}	2025-08-13 16:48:13.917+01	\N	\N	\N
2800	1	list_vms	{}	2025-08-13 16:48:13.939+01	\N	\N	\N
2801	1	GET /vms	{"query":{}}	2025-08-13 16:55:18.092+01	\N	\N	\N
2802	1	GET /vms	{"query":{}}	2025-08-13 16:55:33.171+01	\N	\N	\N
2803	1	GET /vms	{"query":{}}	2025-08-13 17:06:39.752+01	\N	\N	\N
2804	1	list_vms	{}	2025-08-13 17:06:39.806+01	\N	\N	\N
2805	1	GET /vms	{"query":{}}	2025-08-13 17:06:39.852+01	\N	\N	\N
2806	1	list_vms	{}	2025-08-13 17:06:39.874+01	\N	\N	\N
2807	1	GET /vms	{"query":{}}	2025-08-13 17:07:05.106+01	\N	\N	\N
2808	1	list_vms	{}	2025-08-13 17:07:05.161+01	\N	\N	\N
2809	1	GET /vms	{"query":{}}	2025-08-13 17:07:05.203+01	\N	\N	\N
2810	1	list_vms	{}	2025-08-13 17:07:05.223+01	\N	\N	\N
2811	1	Déploiement Terraform	{"vm_name":"testwebserver","service_type":"monitoring__cron","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-a8e8f5d1-e3ac-4daf-ae4d-496c0260f6f7.log"}	2025-08-13 17:12:21.234+01	\N	\N	\N
2812	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:19:51.503+01	\N	\N	\N
2813	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:19:51.543+01	\N	\N	\N
2814	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:20:00.359+01	\N	\N	\N
2815	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:20:00.392+01	\N	\N	\N
2816	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:20:08.172+01	\N	\N	\N
2817	1	terminal_list_vms	{}	2025-08-13 17:20:09.886+01	\N	\N	\N
2818	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:20:09.903+01	\N	\N	\N
2819	1	terminal_list_vms	{}	2025-08-13 17:20:11.894+01	\N	\N	\N
2820	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:20:23.571+01	\N	\N	\N
2821	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:20:23.604+01	\N	\N	\N
2822	1	PUT /templates/29	{"body":{"name":"monitoring__cron","template_content":"#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nsudo chown -R nexus:nexus /opt/monitoring\\r\\nsudo chmod 775 /opt/monitoring\\r\\n\\r\\n# === vVariables substituées par le moteur de template ===\\r\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\r\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\r\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\r\\nSTATUS_CRON_EXPR='*/1 * * * *'\\r\\nSERVICES_CRON_EXPR='*/1 * * * *'\\r\\nCRON_USER='nexus'\\r\\n\\r\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nmkdir -p \\"${MONITOR_DIR}\\"\\r\\n\\r\\n# --- Génère le script  ---\\r\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\r\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\r\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\r\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\r\\nCRON_USER='__CRON_USER__'\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nexists_and_exec() {\\r\\n  local f=\\"$1\\"\\r\\n  [[ -f \\"$f\\" ]] || return 1\\r\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\r\\n  return 0\\r\\n}\\r\\n\\r\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\r\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\r\\n\\r\\nadd_cron_once() {\\r\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\r\\n  local current\\r\\n  current=\\"$(crontab_get)\\"\\r\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\r\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\r\\n  fi\\r\\n}\\r\\n\\r\\nremove_mark() {\\r\\n  local mark=\\"$1\\"\\r\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\r\\n}\\r\\n\\r\\nok=1\\r\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif [[ \\"$ok\\" -eq 1 ]]; then\\r\\n  # Exécuter une première fois pour générer les JSON immédiatement\\r\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\r\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\r\\n  # Se retirer du crontab\\r\\n  remove_mark \\"$MARK_BOOT\\"\\r\\nfi\\r\\nEOS\\r\\n\\r\\n# Injecte les variables réelles dans le \\r\\nsed -i \\\\\\r\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\r\\n  \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\n# --- (Ré)active le service cron/ crond ---\\r\\nif command -v systemctl >/dev/null 2>&1; then\\r\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\r\\nfi\\r\\n\\r\\n# --- Installe le cron  (toutes les minutes) ---\\r\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\r\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\r\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\r\\nfi\\r\\n\\r\\nexit 0\\r\\n"},"query":{}}	2025-08-13 17:20:33.411+01	\N	\N	\N
2823	1	PUT /templates/29	{"body":{"name":"monitoring__cron","template_content":"#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nsudo chown -R nexus:nexus /opt/monitoring\\r\\nsudo chmod 775 /opt/monitoring\\r\\n\\r\\n# === vVariables substituées par le moteur de template ===\\r\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\r\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\r\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\r\\nSTATUS_CRON_EXPR='*/1 * * * *'\\r\\nSERVICES_CRON_EXPR='*/1 * * * *'\\r\\nCRON_USER='nexus'\\r\\n\\r\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nmkdir -p \\"${MONITOR_DIR}\\"\\r\\n\\r\\n# --- Génère le script  ---\\r\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\r\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\r\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\r\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\r\\nCRON_USER='__CRON_USER__'\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nexists_and_exec() {\\r\\n  local f=\\"$1\\"\\r\\n  [[ -f \\"$f\\" ]] || return 1\\r\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\r\\n  return 0\\r\\n}\\r\\n\\r\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\r\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\r\\n\\r\\nadd_cron_once() {\\r\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\r\\n  local current\\r\\n  current=\\"$(crontab_get)\\"\\r\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\r\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\r\\n  fi\\r\\n}\\r\\n\\r\\nremove_mark() {\\r\\n  local mark=\\"$1\\"\\r\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\r\\n}\\r\\n\\r\\nok=1\\r\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif [[ \\"$ok\\" -eq 1 ]]; then\\r\\n  # Exécuter une première fois pour générer les JSON immédiatement\\r\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\r\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\r\\n  # Se retirer du crontab\\r\\n  remove_mark \\"$MARK_BOOT\\"\\r\\nfi\\r\\nEOS\\r\\n\\r\\n# Injecte les variables réelles dans le \\r\\nsed -i \\\\\\r\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\r\\n  \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\n# --- (Ré)active le service cron/ crond ---\\r\\nif command -v systemctl >/dev/null 2>&1; then\\r\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\r\\nfi\\r\\n\\r\\n# --- Installe le cron  (toutes les minutes) ---\\r\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\r\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\r\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\r\\nfi\\r\\n\\r\\nexit 0\\r\\n"},"query":{}}	2025-08-13 17:20:49.735+01	\N	\N	\N
2824	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 17:31:52.644+01	\N	\N	\N
2825	1	logout	{"user_id":1}	2025-08-13 17:31:52.657+01	\N	\N	\N
2826	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 17:31:52.679+01	\N	\N	\N
2827	1	logout	{"user_id":1}	2025-08-13 17:31:52.684+01	\N	\N	\N
2828	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 17:35:31.222+01	\N	\N	\N
2829	1	login	{"user_id":1}	2025-08-13 17:35:31.435+01	\N	\N	\N
2830	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:35:31.996+01	\N	\N	\N
2831	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:35:32.049+01	\N	\N	\N
2832	1	GET /settings/account	{"query":{}}	2025-08-13 17:38:48.773+01	\N	\N	\N
2833	1	GET /settings/account	{"query":{}}	2025-08-13 17:38:48.806+01	\N	\N	\N
2834	1	GET /settings/me	{"query":{}}	2025-08-13 17:43:10.098+01	\N	\N	\N
2835	1	GET /vms/nodes	{"query":{}}	2025-08-13 17:43:10.11+01	\N	\N	\N
2836	1	GET /settings/me	{"query":{}}	2025-08-13 17:43:10.153+01	\N	\N	\N
2837	1	GET /vms/nodes	{"query":{}}	2025-08-13 17:43:10.186+01	\N	\N	\N
2838	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:10.217+01	\N	\N	\N
2839	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:10.218+01	\N	\N	\N
2840	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:10.274+01	\N	\N	\N
2841	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:10.275+01	\N	\N	\N
2842	1	GET /settings/me	{"query":{}}	2025-08-13 17:43:22.747+01	\N	\N	\N
2843	1	GET /vms/nodes	{"query":{}}	2025-08-13 17:43:22.764+01	\N	\N	\N
2844	1	GET /settings/me	{"query":{}}	2025-08-13 17:43:22.805+01	\N	\N	\N
2845	1	GET /vms/nodes	{"query":{}}	2025-08-13 17:43:22.87+01	\N	\N	\N
2846	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:22.873+01	\N	\N	\N
2847	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:22.893+01	\N	\N	\N
2848	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:22.937+01	\N	\N	\N
2849	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:22.938+01	\N	\N	\N
2850	1	GET /settings/me	{"query":{}}	2025-08-13 17:43:44.706+01	\N	\N	\N
2851	1	GET /vms/nodes	{"query":{}}	2025-08-13 17:43:44.725+01	\N	\N	\N
2852	1	GET /settings/me	{"query":{}}	2025-08-13 17:43:44.763+01	\N	\N	\N
2853	1	GET /vms/nodes	{"query":{}}	2025-08-13 17:43:44.843+01	\N	\N	\N
2854	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:44.856+01	\N	\N	\N
2855	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:44.862+01	\N	\N	\N
2856	1	GET /vms/system?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:44.915+01	\N	\N	\N
2857	1	GET /vms/storages?node=pve	{"query":{"node":"pve"}}	2025-08-13 17:43:44.917+01	\N	\N	\N
2858	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:46:25.762+01	\N	\N	\N
2859	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:46:25.798+01	\N	\N	\N
2860	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:46:46.193+01	\N	\N	\N
2861	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:46:46.219+01	\N	\N	\N
2862	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:46:53.066+01	\N	\N	\N
2863	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:46:53.096+01	\N	\N	\N
2864	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:48:26.445+01	\N	\N	\N
2865	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:48:26.504+01	\N	\N	\N
2866	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:49:02.89+01	\N	\N	\N
2867	1	terminal_list_vms	{}	2025-08-13 17:49:04.884+01	\N	\N	\N
2868	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:49:04.907+01	\N	\N	\N
2869	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:49:05.057+01	\N	\N	\N
2870	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:49:05.076+01	\N	\N	\N
2871	1	terminal_list_vms	{}	2025-08-13 17:49:06.901+01	\N	\N	\N
2872	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:52:51.837+01	\N	\N	\N
2873	1	terminal_list_vms	{}	2025-08-13 17:52:53.89+01	\N	\N	\N
2874	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:52:53.909+01	\N	\N	\N
2875	1	terminal_list_vms	{}	2025-08-13 17:52:55.895+01	\N	\N	\N
2876	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 17:52:57.427+01	\N	\N	\N
2877	1	logout	{"user_id":1}	2025-08-13 17:52:57.434+01	\N	\N	\N
2878	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:52:58.61+01	\N	\N	\N
2881	1	terminal_list_vms	{}	2025-08-13 17:53:02.399+01	\N	\N	\N
2879	1	terminal_list_vms	{}	2025-08-13 17:53:00.394+01	\N	\N	\N
2880	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 17:53:00.407+01	\N	\N	\N
2882	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:53:59.164+01	\N	\N	\N
2883	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:53:59.188+01	\N	\N	\N
2884	1	PUT /scripts/29	{"body":{"name":"monitoring__cron","content":"#!/bin/bash\\nset -euo pipefail\\n\\nsudo chown -R nexus:nexus /opt/monitoring\\nsudo chmod 775 /opt/monitoring\\n\\n# === test Variables substituées par le moteur de template ===\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\nSTATUS_CRON_EXPR='*/1 * * * *'\\nSERVICES_CRON_EXPR='*/1 * * * *'\\nCRON_USER='nexus'\\n\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nmkdir -p \\"${MONITOR_DIR}\\"\\n\\n# --- Génère le script  ---\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\n#!/bin/bash\\nset -euo pipefail\\n\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\nCRON_USER='__CRON_USER__'\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nexists_and_exec() {\\n  local f=\\"$1\\"\\n  [[ -f \\"$f\\" ]] || return 1\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\n  return 0\\n}\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\n\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nremove_mark() {\\n  local mark=\\"$1\\"\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\n}\\n\\nok=1\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nelse\\n  ok=0\\nfi\\n\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nelse\\n  ok=0\\nfi\\n\\nif [[ \\"$ok\\" -eq 1 ]]; then\\n  # Exécuter une première fois pour générer les JSON immédiatement\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\n  # Se retirer du crontab\\n  remove_mark \\"$MARK_BOOT\\"\\nfi\\nEOS\\n\\n# Injecte les variables réelles dans le \\nsed -i \\\\\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\n  \\"/opt/monitoring/monitoring.sh\\"\\n\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\n\\n# --- (Ré)active le service cron/ crond ---\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\nfi\\n\\n# --- Installe le cron  (toutes les minutes) ---\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\nfi\\n\\nexit 0\\n"},"query":{}}	2025-08-13 17:54:07.558+01	\N	\N	\N
2885	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:54:37.232+01	\N	\N	\N
2886	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:54:37.268+01	\N	\N	\N
2887	1	PUT /scripts/29	{"body":{"name":"monitoring__cron","content":"#!/bin/bash\\nset -euo pipefail\\n\\nsudo chown -R nexus:nexus /opt/monitoring\\nsudo chmod 775 /opt/monitoring\\n\\n# ===ss Variables substituées par le moteur de template ===\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\nSTATUS_CRON_EXPR='*/1 * * * *'\\nSERVICES_CRON_EXPR='*/1 * * * *'\\nCRON_USER='nexus'\\n\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nmkdir -p \\"${MONITOR_DIR}\\"\\n\\n# --- Génère le script  ---\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\n#!/bin/bash\\nset -euo pipefail\\n\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\nCRON_USER='__CRON_USER__'\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nexists_and_exec() {\\n  local f=\\"$1\\"\\n  [[ -f \\"$f\\" ]] || return 1\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\n  return 0\\n}\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\n\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nremove_mark() {\\n  local mark=\\"$1\\"\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\n}\\n\\nok=1\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nelse\\n  ok=0\\nfi\\n\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nelse\\n  ok=0\\nfi\\n\\nif [[ \\"$ok\\" -eq 1 ]]; then\\n  # Exécuter une première fois pour générer les JSON immédiatement\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\n  # Se retirer du crontab\\n  remove_mark \\"$MARK_BOOT\\"\\nfi\\nEOS\\n\\n# Injecte les variables réelles dans le \\nsed -i \\\\\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\n  \\"/opt/monitoring/monitoring.sh\\"\\n\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\n\\n# --- (Ré)active le service cron/ crond ---\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\nfi\\n\\n# --- Installe le cron  (toutes les minutes) ---\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\nfi\\n\\nexit 0\\n"},"query":{}}	2025-08-13 17:54:48.154+01	\N	\N	\N
2888	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 17:55:52.335+01	\N	\N	\N
2889	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 17:55:52.393+01	\N	\N	\N
2890	1	GET /roles	{"query":{}}	2025-08-13 17:55:52.413+01	\N	\N	\N
2891	1	GET /roles	{"query":{}}	2025-08-13 17:55:52.45+01	\N	\N	\N
2892	1	GET /permissions/role/2	{"query":{}}	2025-08-13 17:55:52.472+01	\N	\N	\N
2893	1	GET /permissions/role/3	{"query":{}}	2025-08-13 17:55:52.478+01	\N	\N	\N
2894	1	GET /permissions/role/1	{"query":{}}	2025-08-13 17:55:52.483+01	\N	\N	\N
2895	1	GET /permissions/role/3	{"query":{}}	2025-08-13 17:55:52.525+01	\N	\N	\N
2896	1	GET /permissions/role/1	{"query":{}}	2025-08-13 17:55:52.532+01	\N	\N	\N
2897	1	GET /permissions/role/2	{"query":{}}	2025-08-13 17:55:52.546+01	\N	\N	\N
2898	1	POST /permissions	{"body":{"key":"script.update","name":"script.update","description":"script.update"},"query":{}}	2025-08-13 17:56:32.069+01	\N	\N	\N
2899	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 17:56:32.101+01	\N	\N	\N
2900	1	GET /roles	{"query":{}}	2025-08-13 17:56:32.212+01	\N	\N	\N
2901	1	GET /permissions/role/2	{"query":{}}	2025-08-13 17:56:32.298+01	\N	\N	\N
2902	1	GET /permissions/role/3	{"query":{}}	2025-08-13 17:56:32.307+01	\N	\N	\N
2903	1	GET /permissions/role/1	{"query":{}}	2025-08-13 17:56:32.314+01	\N	\N	\N
2904	1	GET /permissions?page=1&limit=10&q=script.update&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"script.update","sort":"key","order":"asc"}}	2025-08-13 17:56:35.562+01	\N	\N	\N
2905	1	GET /roles	{"query":{}}	2025-08-13 17:56:35.596+01	\N	\N	\N
2906	1	GET /permissions/role/2	{"query":{}}	2025-08-13 17:56:35.646+01	\N	\N	\N
2907	1	GET /permissions/role/3	{"query":{}}	2025-08-13 17:56:35.655+01	\N	\N	\N
2908	1	GET /permissions/role/1	{"query":{}}	2025-08-13 17:56:35.665+01	\N	\N	\N
2909	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[68]}],"query":{}}	2025-08-13 17:56:44.247+01	\N	\N	\N
2910	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:56:54.937+01	\N	\N	\N
2911	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:56:55.015+01	\N	\N	\N
2912	1	PUT /scripts/29	{"body":{"name":"monitoring__cron","content":"#!/bin/bash\\nset -euo pipefail\\n\\nsudo chown -R nexus:nexus /opt/monitoring\\nsudo chmod 775 /opt/monitoring\\n\\n# === testVariables substituées par le moteur de template ===\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\nSTATUS_CRON_EXPR='*/1 * * * *'\\nSERVICES_CRON_EXPR='*/1 * * * *'\\nCRON_USER='nexus'\\n\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nmkdir -p \\"${MONITOR_DIR}\\"\\n\\n# --- Génère le script  ---\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\n#!/bin/bash\\nset -euo pipefail\\n\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\nCRON_USER='__CRON_USER__'\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\n\\nexists_and_exec() {\\n  local f=\\"$1\\"\\n  [[ -f \\"$f\\" ]] || return 1\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\n  return 0\\n}\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\n\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nremove_mark() {\\n  local mark=\\"$1\\"\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\n}\\n\\nok=1\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nelse\\n  ok=0\\nfi\\n\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nelse\\n  ok=0\\nfi\\n\\nif [[ \\"$ok\\" -eq 1 ]]; then\\n  # Exécuter une première fois pour générer les JSON immédiatement\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\n  # Se retirer du crontab\\n  remove_mark \\"$MARK_BOOT\\"\\nfi\\nEOS\\n\\n# Injecte les variables réelles dans le \\nsed -i \\\\\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\n  \\"/opt/monitoring/monitoring.sh\\"\\n\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\n\\n# --- (Ré)active le service cron/ crond ---\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\nfi\\n\\n# --- Installe le cron  (toutes les minutes) ---\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\nfi\\n\\nexit 0\\n"},"query":{}}	2025-08-13 17:57:01.869+01	\N	\N	\N
2913	1	update_script:29	{}	2025-08-13 17:57:01.881+01	\N	\N	\N
2914	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:57:20.201+01	\N	\N	\N
2915	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 17:57:20.25+01	\N	\N	\N
2916	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:02:20.317+01	\N	\N	\N
2917	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:02:20.35+01	\N	\N	\N
3012	1	list_vms	{}	2025-08-13 19:06:57.945+01	\N	\N	\N
2918	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 18:02:33.57+01	\N	\N	\N
2919	1	logout	{"user_id":1}	2025-08-13 18:02:33.576+01	\N	\N	\N
2920	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:02:41.106+01	\N	\N	\N
2921	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:02:41.191+01	\N	\N	\N
2922	1	GET /logs?sort=timestamp&order=desc&page=1&limit=10	{"query":{"sort":"timestamp","order":"desc","page":"1","limit":"10"}}	2025-08-13 18:03:53.592+01	\N	\N	\N
2923	1	GET /logs?sort=timestamp&order=desc&page=1&limit=10	{"query":{"sort":"timestamp","order":"desc","page":"1","limit":"10"}}	2025-08-13 18:03:58.096+01	\N	\N	\N
2924	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:12:34.885+01	\N	\N	\N
2925	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:12:34.914+01	\N	\N	\N
2926	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 18:12:38.125+01	\N	\N	\N
2927	1	logout	{"user_id":1}	2025-08-13 18:12:38.131+01	\N	\N	\N
2928	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:12:44.251+01	\N	\N	\N
2929	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:12:44.311+01	\N	\N	\N
2930	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 18:22:08.493+01	\N	\N	\N
2931	1	logout	{"user_id":1}	2025-08-13 18:22:08.499+01	\N	\N	\N
2932	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:23:26.877+01	\N	\N	\N
2933	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:23:26.984+01	\N	\N	\N
2934	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:25:58.61+01	\N	\N	\N
2935	1	PUT /scripts/29	{"body":{"name":"monitoring__cron","content":"#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nsudo chown -R nexus:nexus /opt/monitoring\\r\\nsudo chmod 775 /opt/monitoring\\r\\n\\r\\n# === Variables substituées par le moteur de template ===\\r\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\r\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\r\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\r\\nSTATUS_CRON_EXPR='*/1 * * * *'\\r\\nSERVICES_CRON_EXPR='*/1 * * * *'\\r\\nCRON_USER='nexus'\\r\\n\\r\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nmkdir -p \\"${MONITOR_DIR}\\"\\r\\n\\r\\n# --- Génère le script  ---\\r\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\r\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\r\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\r\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\r\\nCRON_USER='__CRON_USER__'\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nexists_and_exec() {\\r\\n  local f=\\"$1\\"\\r\\n  [[ -f \\"$f\\" ]] || return 1\\r\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\r\\n  return 0\\r\\n}\\r\\n\\r\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\r\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\r\\n\\r\\nadd_cron_once() {\\r\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\r\\n  local current\\r\\n  current=\\"$(crontab_get)\\"\\r\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\r\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\r\\n  fi\\r\\n}\\r\\n\\r\\nremove_mark() {\\r\\n  local mark=\\"$1\\"\\r\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\r\\n}\\r\\n\\r\\nok=1\\r\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif [[ \\"$ok\\" -eq 1 ]]; then\\r\\n  # Exécuter une première fois pour générer les JSON immédiatement\\r\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\r\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\r\\n  # Se retirer du crontab\\r\\n  remove_mark \\"$MARK_BOOT\\"\\r\\nfi\\r\\nEOS\\r\\n\\r\\n# Injecte les variables réelles dans le \\r\\nsed -i \\\\\\r\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\r\\n  \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\n# --- (Ré)active le service cron/ crond ---\\r\\nif command -v systemctl >/dev/null 2>&1; then\\r\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\r\\nfi\\r\\n\\r\\n# --- Installe le cron  (toutes les minutes) ---\\r\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\r\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\r\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\r\\nfi\\r\\n\\r\\nexit 0\\r\\n"},"query":{}}	2025-08-13 18:26:06.525+01	\N	\N	\N
2936	1	update_script:29	{}	2025-08-13 18:26:06.535+01	\N	\N	\N
2937	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:26:26.259+01	\N	\N	\N
2938	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:26:26.349+01	\N	\N	\N
2939	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:26:55.474+01	\N	\N	\N
2940	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:26:55.548+01	\N	\N	\N
2941	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 18:27:32.355+01	\N	\N	\N
2942	1	logout	{"user_id":1}	2025-08-13 18:27:32.362+01	\N	\N	\N
2943	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"jkhg","remember":false},"query":{}}	2025-08-13 18:27:37.268+01	\N	\N	\N
2944	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 18:27:45.729+01	\N	\N	\N
2945	1	login	{"user_id":1}	2025-08-13 18:27:45.857+01	\N	\N	\N
2946	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:27:46.38+01	\N	\N	\N
2947	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:27:46.408+01	\N	\N	\N
2948	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 18:28:43.909+01	\N	\N	\N
2949	1	logout	{"user_id":1}	2025-08-13 18:28:43.917+01	\N	\N	\N
2950	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:28:46.624+01	\N	\N	\N
2951	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:28:46.684+01	\N	\N	\N
2952	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 18:28:52.651+01	\N	\N	\N
2953	1	logout	{"user_id":1}	2025-08-13 18:28:52.658+01	\N	\N	\N
2954	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"sdf","remember":false},"query":{}}	2025-08-13 18:28:57.825+01	\N	\N	\N
2955	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"adsf","remember":false},"query":{}}	2025-08-13 18:30:21.017+01	\N	\N	\N
2956	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 18:30:26.887+01	\N	\N	\N
2957	1	login	{"user_id":1}	2025-08-13 18:30:27.026+01	\N	\N	\N
2958	1	GET /vms	{"query":{}}	2025-08-13 18:30:36.542+01	\N	\N	\N
2959	1	GET /dashboard	{"query":{}}	2025-08-13 18:30:36.545+01	\N	\N	\N
2960	1	list_vms	{}	2025-08-13 18:30:36.584+01	\N	\N	\N
2961	1	GET /vms	{"query":{}}	2025-08-13 18:30:36.611+01	\N	\N	\N
2962	1	GET /dashboard	{"query":{}}	2025-08-13 18:30:36.676+01	\N	\N	\N
2963	1	list_vms	{}	2025-08-13 18:30:36.682+01	\N	\N	\N
2964	1	GET /dashboard/map	{"query":{}}	2025-08-13 18:31:33.333+01	\N	\N	\N
2965	1	GET /dashboard/map	{"query":{}}	2025-08-13 18:31:33.383+01	\N	\N	\N
2966	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:39:42.176+01	\N	\N	\N
2967	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:39:42.227+01	\N	\N	\N
3013	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 19:11:20.544+01	\N	\N	\N
3014	1	login	{"user_id":1}	2025-08-13 19:11:20.754+01	\N	\N	\N
3015	1	GET /dashboard	{"query":{}}	2025-08-13 19:11:21.224+01	\N	\N	\N
3016	1	GET /vms	{"query":{}}	2025-08-13 19:11:21.226+01	\N	\N	\N
3017	1	list_vms	{}	2025-08-13 19:11:21.27+01	\N	\N	\N
3018	1	GET /vms	{"query":{}}	2025-08-13 19:11:21.32+01	\N	\N	\N
3019	1	GET /dashboard	{"query":{}}	2025-08-13 19:11:21.335+01	\N	\N	\N
3020	1	list_vms	{}	2025-08-13 19:11:21.35+01	\N	\N	\N
3021	1	GET /vms	{"query":{}}	2025-08-13 19:13:52.236+01	\N	\N	\N
3022	1	list_vms	{}	2025-08-13 19:13:52.283+01	\N	\N	\N
3023	1	GET /vms	{"query":{}}	2025-08-13 19:13:52.304+01	\N	\N	\N
3024	1	list_vms	{}	2025-08-13 19:13:52.321+01	\N	\N	\N
3025	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-13 21:41:58.731+01	\N	\N	\N
3026	1	login	{"user_id":1}	2025-08-13 21:41:58.924+01	\N	\N	\N
3027	1	GET /dashboard	{"query":{}}	2025-08-13 21:42:08.297+01	\N	\N	\N
3028	1	GET /vms	{"query":{}}	2025-08-13 21:42:08.298+01	\N	\N	\N
3029	1	list_vms	{}	2025-08-13 21:42:08.384+01	\N	\N	\N
3030	1	GET /vms	{"query":{}}	2025-08-13 21:42:08.422+01	\N	\N	\N
2968	1	PUT /scripts/29	{"body":{"name":"monitoring__cron","content":"#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nsudo chown -R nexus:nexus /opt/monitoring\\r\\nsudo chmod 775 /opt/monitoring\\r\\n\\r\\n# === testVariables substituées par le moteur de template ===\\r\\nSCRIPT_PATH=\\"/opt/monitoring/monitoring.sh\\"\\r\\nSTATUS_SCRIPT_PATH=\\"/opt/monitoring/status.sh\\"\\r\\nSERVICES_SCRIPT_PATH=\\"/opt/monitoring/services_status.sh\\"\\r\\nSTATUS_CRON_EXPR='*/1 * * * *'\\r\\nSERVICES_CRON_EXPR='*/1 * * * *'\\r\\nCRON_USER='nexus'\\r\\n\\r\\nMONITOR_DIR=\\"$(dirname \\"/opt/monitoring/status.sh\\")\\"\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nmkdir -p \\"${MONITOR_DIR}\\"\\r\\n\\r\\n# --- Génère le script  ---\\r\\ncat > \\"/opt/monitoring/monitoring.sh\\" <<'EOS'\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\nSTATUS_SCRIPT_PATH=\\"__STATUS_SCRIPT_PATH__\\"\\r\\nSERVICES_SCRIPT_PATH=\\"__SERVICES_SCRIPT_PATH__\\"\\r\\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\\r\\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\\r\\nCRON_USER='__CRON_USER__'\\r\\nMARK_BOOT=\\"# MONITORING_CRON\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\n\\r\\nexists_and_exec() {\\r\\n  local f=\\"$1\\"\\r\\n  [[ -f \\"$f\\" ]] || return 1\\r\\n  [[ -x \\"$f\\" ]] || chmod +x \\"$f\\" || true\\r\\n  return 0\\r\\n}\\r\\n\\r\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\r\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\r\\n\\r\\nadd_cron_once() {\\r\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\r\\n  local current\\r\\n  current=\\"$(crontab_get)\\"\\r\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\r\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\r\\n  fi\\r\\n}\\r\\n\\r\\nremove_mark() {\\r\\n  local mark=\\"$1\\"\\r\\n  crontab_get | grep -Fv \\"$mark\\" | crontab_set\\r\\n}\\r\\n\\r\\nok=1\\r\\nif exists_and_exec \\"$STATUS_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\\" \\"$MARK_STATUS\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif exists_and_exec \\"$SERVICES_SCRIPT_PATH\\"; then\\r\\n  add_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\r\\nelse\\r\\n  ok=0\\r\\nfi\\r\\n\\r\\nif [[ \\"$ok\\" -eq 1 ]]; then\\r\\n  # Exécuter une première fois pour générer les JSON immédiatement\\r\\n  bash \\"$STATUS_SCRIPT_PATH\\" || true\\r\\n  bash \\"$SERVICES_SCRIPT_PATH\\" || true\\r\\n  # Se retirer du crontab\\r\\n  remove_mark \\"$MARK_BOOT\\"\\r\\nfi\\r\\nEOS\\r\\n\\r\\n# Injecte les variables réelles dans le \\r\\nsed -i \\\\\\r\\n  -e \\"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\\\//\\\\\\\\/}#g\\" \\\\\\r\\n  -e \\"s#__CRON_USER__#nexus#g\\" \\\\\\r\\n  \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\nchmod +x \\"/opt/monitoring/monitoring.sh\\"\\r\\n\\r\\n# --- (Ré)active le service cron/ crond ---\\r\\nif command -v systemctl >/dev/null 2>&1; then\\r\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\r\\nfi\\r\\n\\r\\n# --- Installe le cron  (toutes les minutes) ---\\r\\ncurrent_cron=\\"$(crontab -u \\"nexus\\" -l 2>/dev/null || true)\\"\\r\\nif ! echo \\"$current_cron\\" | grep -Fq \\"$MARK_BOOT\\"; then\\r\\n  { echo \\"$current_cron\\" | grep -Fv \\"$MARK_BOOT\\"; echo \\"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\\"; } | crontab -u \\"nexus\\" -\\r\\nfi\\r\\n\\r\\nexit 0"},"query":{}}	2025-08-13 18:39:51.529+01	\N	\N	\N
2969	1	update_script:29	{}	2025-08-13 18:39:51.542+01	\N	\N	\N
2970	1	PUT /templates/27	{"body":{"name":"Surveillance des services - Génération du script","category":"monitoring","service_type":"service_monitoring_script","description":"","template_content":"#!/bin/bash\\r\\n\\r\\n# 📁 testCréer le dossier de monitoring s’il n’existe pas\\r\\nmkdir -p /opt/monitoring\\r\\n\\r\\n# 📦 Créer le script de surveillance des services\\r\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\r\\n#!/bin/bash\\r\\n\\r\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\r\\nif [ -f /etc/instance-info.conf ]; then\\r\\n  source /etc/instance-info.conf\\r\\nfi\\r\\n\\r\\nTIMESTAMP=$(date -Iseconds)\\r\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\r\\n\\r\\nSERVICES=(\\r\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\r\\n  mariadb postgresql docker kubelet redis-server\\r\\n  mongod vsftpd proftpd php-fpm\\r\\n)\\r\\n\\r\\nSERVICE_STATUS_JSON=\\"\\"\\r\\nfor svc in \\"${SERVICES[@]}\\"; do\\r\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\r\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\r\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\r\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\r\\n  fi\\r\\ndone\\r\\n\\r\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\r\\n\\r\\ncat <<JSON > ${SERVICES_JSON_PATH}\\r\\n{\\r\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\r\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\r\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\r\\n}\\r\\nJSON\\r\\nEOS\\r\\n\\r\\nchmod +x ${SERVICES_SCRIPT_PATH}","fields_schema":{"fields":[]}},"query":{}}	2025-08-13 18:40:00.707+01	\N	\N	\N
2971	1	update_template:27	{}	2025-08-13 18:40:00.75+01	\N	\N	\N
2972	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:40:11.867+01	\N	\N	\N
2973	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:40:11.925+01	\N	\N	\N
2974	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:41:52.8+01	\N	\N	\N
2975	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:41:52.86+01	\N	\N	\N
2976	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:41:59.979+01	\N	\N	\N
2977	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 18:42:00.027+01	\N	\N	\N
2978	1	GET /dashboard	{"query":{}}	2025-08-13 18:44:02.099+01	\N	\N	\N
2979	1	GET /vms	{"query":{}}	2025-08-13 18:44:02.101+01	\N	\N	\N
2980	1	list_vms	{}	2025-08-13 18:44:02.164+01	\N	\N	\N
2981	1	GET /vms	{"query":{}}	2025-08-13 18:44:02.208+01	\N	\N	\N
2982	1	GET /dashboard	{"query":{}}	2025-08-13 18:44:02.223+01	\N	\N	\N
2983	1	list_vms	{}	2025-08-13 18:44:02.236+01	\N	\N	\N
2984	1	GET /templates	{"query":{}}	2025-08-13 18:46:41.914+01	\N	\N	\N
2985	1	GET /templates	{"query":{}}	2025-08-13 18:46:41.939+01	\N	\N	\N
2986	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 19:02:33.947+01	\N	\N	\N
2987	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 19:02:33.979+01	\N	\N	\N
2988	1	PUT /templates/27	{"body":{"name":"Surveillance des services - Génération du script","category":"monitoring","service_type":"service_monitoring_script","description":"","template_content":"#!/bin/bash\\r\\n\\r\\n# 📁 Créer le dossier de monitoring s’il n’existe pas\\r\\nmkdir -p /opt/monitoring\\r\\n\\r\\n# 📦 Créer le script de surveillance des services\\r\\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\\r\\n#!/bin/bash\\r\\n\\r\\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\\r\\nif [ -f /etc/instance-info.conf ]; then\\r\\n  source /etc/instance-info.conf\\r\\nfi\\r\\n\\r\\nTIMESTAMP=$(date -Iseconds)\\r\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\r\\n\\r\\nSERVICES=(\\r\\n  sshd ufw fail2ban cron crond nginx apache2 mysql\\r\\n  mariadb postgresql docker kubelet redis-server\\r\\n  mongod vsftpd proftpd php-fpm\\r\\n)\\r\\n\\r\\nSERVICE_STATUS_JSON=\\"\\"\\r\\nfor svc in \\"${SERVICES[@]}\\"; do\\r\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\r\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\r\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\r\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\r\\n  fi\\r\\ndone\\r\\n\\r\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\r\\n\\r\\ncat <<JSON > ${SERVICES_JSON_PATH}\\r\\n{\\r\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\r\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\r\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\r\\n}\\r\\nJSON\\r\\nEOS\\r\\n\\r\\nchmod +x ${SERVICES_SCRIPT_PATH}","fields_schema":{"fields":[]}},"query":{}}	2025-08-13 19:02:45.455+01	\N	\N	\N
2989	1	update_template:27	{}	2025-08-13 19:02:45.5+01	\N	\N	\N
2990	1	GET /dashboard	{"query":{}}	2025-08-13 19:03:08.405+01	\N	\N	\N
2991	1	GET /vms	{"query":{}}	2025-08-13 19:03:08.406+01	\N	\N	\N
2992	1	list_vms	{}	2025-08-13 19:03:08.457+01	\N	\N	\N
2993	1	GET /dashboard	{"query":{}}	2025-08-13 19:03:08.472+01	\N	\N	\N
2994	1	GET /vms	{"query":{}}	2025-08-13 19:03:08.485+01	\N	\N	\N
2995	1	list_vms	{}	2025-08-13 19:03:08.511+01	\N	\N	\N
2996	1	GET /dashboard/map	{"query":{}}	2025-08-13 19:03:10.824+01	\N	\N	\N
2997	1	GET /dashboard/map	{"query":{}}	2025-08-13 19:03:10.864+01	\N	\N	\N
2998	1	GET /dashboard/map	{"query":{}}	2025-08-13 19:03:17.593+01	\N	\N	\N
2999	1	GET /dashboard/map	{"query":{}}	2025-08-13 19:03:17.68+01	\N	\N	\N
3000	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 19:03:30.538+01	\N	\N	\N
3001	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 19:03:30.578+01	\N	\N	\N
3002	1	GET /dashboard/servers	{"query":{}}	2025-08-13 19:05:39.926+01	\N	\N	\N
3003	1	GET /dashboard/servers	{"query":{}}	2025-08-13 19:05:40.024+01	\N	\N	\N
3004	1	POST /dashboard/servers	{"body":{"name":"sdddd","ip":"192.168.10.10","zone":"WAN"},"query":{}}	2025-08-13 19:06:03.336+01	\N	\N	\N
3005	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-13 19:06:34.874+01	\N	\N	\N
3006	1	logout	{"user_id":1}	2025-08-13 19:06:34.88+01	\N	\N	\N
3007	1	GET /dashboard	{"query":{}}	2025-08-13 19:06:57.867+01	\N	\N	\N
3008	1	GET /vms	{"query":{}}	2025-08-13 19:06:57.868+01	\N	\N	\N
3009	1	list_vms	{}	2025-08-13 19:06:57.896+01	\N	\N	\N
3010	1	GET /vms	{"query":{}}	2025-08-13 19:06:57.917+01	\N	\N	\N
3011	1	GET /dashboard	{"query":{}}	2025-08-13 19:06:57.936+01	\N	\N	\N
3031	1	GET /dashboard	{"query":{}}	2025-08-13 21:42:08.423+01	\N	\N	\N
3032	1	list_vms	{}	2025-08-13 21:42:08.45+01	\N	\N	\N
3033	1	GET /dashboard	{"query":{}}	2025-08-13 21:42:17.963+01	\N	\N	\N
3034	1	GET /vms	{"query":{}}	2025-08-13 21:42:17.964+01	\N	\N	\N
3035	1	list_vms	{}	2025-08-13 21:42:17.996+01	\N	\N	\N
3036	1	GET /dashboard/map	{"query":{}}	2025-08-13 21:46:34.711+01	\N	\N	\N
3037	1	GET /dashboard/map	{"query":{}}	2025-08-13 21:46:34.752+01	\N	\N	\N
3038	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 21:50:22.484+01	\N	\N	\N
3039	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-13 21:50:22.532+01	\N	\N	\N
3040	1	GET /logs?sort=timestamp&order=desc&page=1&limit=10	{"query":{"sort":"timestamp","order":"desc","page":"1","limit":"10"}}	2025-08-13 22:12:01.288+01	\N	\N	\N
3041	1	GET /alerts	{"query":{}}	2025-08-13 22:12:14.389+01	\N	\N	\N
3042	1	GET /alerts	{"query":{}}	2025-08-13 22:12:14.414+01	\N	\N	\N
3043	1	GET /vms	{"query":{}}	2025-08-13 22:13:12.312+01	\N	\N	\N
3044	1	list_vms	{}	2025-08-13 22:13:12.387+01	\N	\N	\N
3045	1	GET /vms	{"query":{}}	2025-08-13 22:13:12.407+01	\N	\N	\N
3046	1	list_vms	{}	2025-08-13 22:13:12.427+01	\N	\N	\N
3047	1	GET /vms	{"query":{}}	2025-08-13 22:39:49.548+01	\N	\N	\N
3048	1	list_vms	{}	2025-08-13 22:39:49.602+01	\N	\N	\N
3049	1	GET /vms	{"query":{}}	2025-08-13 22:39:49.622+01	\N	\N	\N
3050	1	list_vms	{}	2025-08-13 22:39:49.642+01	\N	\N	\N
3051	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 22:44:57.864+01	\N	\N	\N
3052	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 22:44:57.896+01	\N	\N	\N
3053	1	GET /templates?status=supprime	{"query":{"status":"supprime"}}	2025-08-13 22:45:46.607+01	\N	\N	\N
3054	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 22:45:59.457+01	\N	\N	\N
3055	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-13 22:45:59.489+01	\N	\N	\N
3056	1	GET /roles	{"query":{}}	2025-08-13 22:47:23.944+01	\N	\N	\N
3057	1	GET /users	{"query":{}}	2025-08-13 22:47:23.95+01	\N	\N	\N
3058	1	GET /users	{"query":{}}	2025-08-13 22:47:23.993+01	\N	\N	\N
3059	1	GET /roles	{"query":{}}	2025-08-13 22:47:24.003+01	\N	\N	\N
3060	1	GET /roles	{"query":{}}	2025-08-13 22:47:50.352+01	\N	\N	\N
3061	1	GET /users	{"query":{}}	2025-08-13 22:47:50.36+01	\N	\N	\N
3062	1	GET /users	{"query":{}}	2025-08-13 22:47:50.43+01	\N	\N	\N
3063	1	GET /roles	{"query":{}}	2025-08-13 22:47:50.439+01	\N	\N	\N
3064	1	GET /users/3	{"query":{}}	2025-08-13 22:48:03.029+01	\N	\N	\N
3065	1	GET /users/3	{"query":{}}	2025-08-13 22:48:07.959+01	\N	\N	\N
3066	1	GET /users/3	{"query":{}}	2025-08-13 22:48:26.997+01	\N	\N	\N
3067	1	GET /roles	{"query":{}}	2025-08-13 22:48:27.003+01	\N	\N	\N
3068	1	GET /users/3	{"query":{}}	2025-08-13 22:48:27.026+01	\N	\N	\N
3069	1	GET /roles	{"query":{}}	2025-08-13 22:48:27.044+01	\N	\N	\N
3070	1	PUT /users/3	{"body":{"first_name":"tes3","last_name":"test","phone":"555555555555","status":"actif","role_id":2},"query":{}}	2025-08-13 22:48:34.962+01	\N	\N	\N
3071	1	GET /users	{"query":{}}	2025-08-13 22:48:35.184+01	\N	\N	\N
3072	1	GET /roles	{"query":{}}	2025-08-13 22:48:35.19+01	\N	\N	\N
3073	1	GET /users	{"query":{}}	2025-08-13 22:48:35.213+01	\N	\N	\N
3074	1	GET /roles	{"query":{}}	2025-08-13 22:48:35.217+01	\N	\N	\N
3075	1	GET /roles	{"query":{}}	2025-08-13 22:50:11.301+01	\N	\N	\N
3076	1	GET /roles	{"query":{}}	2025-08-13 22:50:11.345+01	\N	\N	\N
3077	1	GET /roles	{"query":{}}	2025-08-13 22:51:37+01	\N	\N	\N
3078	1	GET /users	{"query":{}}	2025-08-13 22:51:37.016+01	\N	\N	\N
3079	1	GET /users	{"query":{}}	2025-08-13 22:51:37.066+01	\N	\N	\N
3080	1	GET /roles	{"query":{}}	2025-08-13 22:51:37.076+01	\N	\N	\N
3081	1	GET /roles	{"query":{}}	2025-08-13 22:54:25.912+01	\N	\N	\N
3082	1	GET /roles	{"query":{}}	2025-08-13 22:54:25.943+01	\N	\N	\N
3083	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 22:55:03.681+01	\N	\N	\N
3084	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-13 22:55:03.718+01	\N	\N	\N
3085	1	GET /roles	{"query":{}}	2025-08-13 22:55:03.751+01	\N	\N	\N
3086	1	GET /roles	{"query":{}}	2025-08-13 22:55:03.784+01	\N	\N	\N
3087	1	GET /permissions/role/3	{"query":{}}	2025-08-13 22:55:03.81+01	\N	\N	\N
3088	1	GET /permissions/role/1	{"query":{}}	2025-08-13 22:55:03.815+01	\N	\N	\N
3089	1	GET /permissions/role/2	{"query":{}}	2025-08-13 22:55:03.823+01	\N	\N	\N
3090	1	GET /permissions/role/2	{"query":{}}	2025-08-13 22:55:04.035+01	\N	\N	\N
3091	1	GET /permissions/role/3	{"query":{}}	2025-08-13 22:55:04.04+01	\N	\N	\N
3092	1	GET /permissions/role/1	{"query":{}}	2025-08-13 22:55:04.045+01	\N	\N	\N
3093	1	GET /permissions?page=1&limit=10&q=&sort=key&order=desc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"desc"}}	2025-08-13 22:55:18.892+01	\N	\N	\N
3094	1	GET /roles	{"query":{}}	2025-08-13 22:55:18.926+01	\N	\N	\N
3095	1	GET /permissions/role/3	{"query":{}}	2025-08-13 22:55:18.974+01	\N	\N	\N
3096	1	GET /permissions/role/2	{"query":{}}	2025-08-13 22:55:18.982+01	\N	\N	\N
3097	1	GET /permissions/role/1	{"query":{}}	2025-08-13 22:55:18.989+01	\N	\N	\N
3098	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 22:55:48.105+01	\N	\N	\N
3099	1	terminal_list_vms	{}	2025-08-13 22:55:49.886+01	\N	\N	\N
3100	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-13 22:55:49.905+01	\N	\N	\N
3101	1	terminal_list_vms	{}	2025-08-13 22:55:50.882+01	\N	\N	\N
3102	1	GET /settings/account	{"query":{}}	2025-08-13 22:56:43.547+01	\N	\N	\N
3103	1	GET /settings/account	{"query":{}}	2025-08-13 22:56:43.572+01	\N	\N	\N
3104	1	GET /templates	{"query":{}}	2025-08-13 22:57:05.827+01	\N	\N	\N
3105	1	GET /templates	{"query":{}}	2025-08-13 22:57:05.86+01	\N	\N	\N
3106	1	GET /settings/me	{"query":{}}	2025-08-13 22:57:18.53+01	\N	\N	\N
3107	1	GET /settings/me	{"query":{}}	2025-08-13 22:57:18.555+01	\N	\N	\N
3108	1	GET /vms/storages	{"query":{}}	2025-08-13 22:57:18.58+01	\N	\N	\N
3109	1	GET /vms/storages	{"query":{}}	2025-08-13 22:57:18.634+01	\N	\N	\N
3110	1	GET /settings/account	{"query":{}}	2025-08-13 22:58:11.585+01	\N	\N	\N
3111	1	GET /settings/account	{"query":{}}	2025-08-13 22:58:11.603+01	\N	\N	\N
3112	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 01:55:38.861+01	\N	\N	\N
3113	1	login	{"user_id":1}	2025-08-14 01:55:39.112+01	\N	\N	\N
3114	1	GET /dashboard	{"query":{}}	2025-08-14 01:55:42.168+01	\N	\N	\N
3115	1	GET /vms	{"query":{}}	2025-08-14 01:55:42.17+01	\N	\N	\N
3116	1	list_vms	{}	2025-08-14 01:55:42.235+01	\N	\N	\N
3117	1	GET /vms	{"query":{}}	2025-08-14 01:55:42.293+01	\N	\N	\N
3118	1	GET /dashboard	{"query":{}}	2025-08-14 01:55:42.307+01	\N	\N	\N
3119	1	list_vms	{}	2025-08-14 01:55:42.323+01	\N	\N	\N
3120	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 01:56:00.234+01	\N	\N	\N
3121	1	logout	{"user_id":1}	2025-08-14 01:56:00.241+01	\N	\N	\N
3122	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":true,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 01:56:09.348+01	\N	\N	\N
3123	1	login	{"user_id":1}	2025-08-14 01:56:09.48+01	\N	\N	\N
3124	1	GET /dashboard	{"query":{}}	2025-08-14 01:56:09.94+01	\N	\N	\N
3125	1	GET /vms	{"query":{}}	2025-08-14 01:56:09.942+01	\N	\N	\N
3126	1	list_vms	{}	2025-08-14 01:56:10.025+01	\N	\N	\N
3127	1	GET /vms	{"query":{}}	2025-08-14 01:56:10.059+01	\N	\N	\N
3128	1	GET /dashboard	{"query":{}}	2025-08-14 01:56:10.073+01	\N	\N	\N
3129	1	list_vms	{}	2025-08-14 01:56:10.085+01	\N	\N	\N
3130	1	GET /dashboard	{"query":{}}	2025-08-14 01:56:16.973+01	\N	\N	\N
3131	1	GET /vms	{"query":{}}	2025-08-14 01:56:16.974+01	\N	\N	\N
3132	1	list_vms	{}	2025-08-14 01:56:17.027+01	\N	\N	\N
3133	1	GET /vms	{"query":{}}	2025-08-14 01:56:17.056+01	\N	\N	\N
3134	1	GET /dashboard	{"query":{}}	2025-08-14 01:56:17.072+01	\N	\N	\N
3135	1	list_vms	{}	2025-08-14 01:56:17.085+01	\N	\N	\N
3136	1	GET /dashboard/map	{"query":{}}	2025-08-14 01:56:21.492+01	\N	\N	\N
3137	1	GET /dashboard/map	{"query":{}}	2025-08-14 01:56:21.527+01	\N	\N	\N
3138	1	GET /dashboard	{"query":{}}	2025-08-14 01:56:24.969+01	\N	\N	\N
3139	1	GET /vms	{"query":{}}	2025-08-14 01:56:24.97+01	\N	\N	\N
3140	1	list_vms	{}	2025-08-14 01:56:24.996+01	\N	\N	\N
3141	1	GET /vms	{"query":{}}	2025-08-14 01:56:25.024+01	\N	\N	\N
3142	1	GET /dashboard	{"query":{}}	2025-08-14 01:56:25.028+01	\N	\N	\N
3143	1	list_vms	{}	2025-08-14 01:56:25.045+01	\N	\N	\N
3144	1	GET /dashboard/map	{"query":{}}	2025-08-14 01:56:27.706+01	\N	\N	\N
3145	1	GET /dashboard/map	{"query":{}}	2025-08-14 01:56:27.746+01	\N	\N	\N
3146	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-14 01:56:42.579+01	\N	\N	\N
3147	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-14 01:56:42.622+01	\N	\N	\N
3148	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-14 01:56:55.136+01	\N	\N	\N
3149	1	GET /dashboard/map	{"query":{}}	2025-08-14 01:58:06.123+01	\N	\N	\N
3150	1	GET /dashboard/map	{"query":{}}	2025-08-14 01:58:06.16+01	\N	\N	\N
3151	1	GET /dashboard	{"query":{}}	2025-08-14 01:58:07.725+01	\N	\N	\N
3152	1	GET /vms	{"query":{}}	2025-08-14 01:58:07.725+01	\N	\N	\N
3153	1	list_vms	{}	2025-08-14 01:58:07.767+01	\N	\N	\N
3154	1	GET /vms	{"query":{}}	2025-08-14 01:58:07.805+01	\N	\N	\N
3155	1	GET /dashboard	{"query":{}}	2025-08-14 01:58:07.824+01	\N	\N	\N
3156	1	list_vms	{}	2025-08-14 01:58:07.836+01	\N	\N	\N
3157	1	GET /logs?sort=timestamp&order=desc&page=1&limit=10	{"query":{"sort":"timestamp","order":"desc","page":"1","limit":"10"}}	2025-08-14 02:02:19.779+01	\N	\N	\N
3158	1	GET /alerts	{"query":{}}	2025-08-14 02:02:27.352+01	\N	\N	\N
3159	1	GET /alerts	{"query":{}}	2025-08-14 02:02:27.375+01	\N	\N	\N
3160	1	GET /vms	{"query":{}}	2025-08-14 02:02:44.204+01	\N	\N	\N
3161	1	list_vms	{}	2025-08-14 02:02:44.272+01	\N	\N	\N
3162	1	GET /vms	{"query":{}}	2025-08-14 02:02:44.297+01	\N	\N	\N
3163	1	list_vms	{}	2025-08-14 02:02:44.318+01	\N	\N	\N
3164	1	GET /vms	{"query":{}}	2025-08-14 02:04:02.69+01	\N	\N	\N
3165	1	list_vms	{}	2025-08-14 02:04:02.749+01	\N	\N	\N
3166	1	GET /vms	{"query":{}}	2025-08-14 02:04:02.767+01	\N	\N	\N
3167	1	list_vms	{}	2025-08-14 02:04:02.786+01	\N	\N	\N
3168	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:04:42.496+01	\N	\N	\N
3169	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:04:42.526+01	\N	\N	\N
3170	1	Déploiement Terraform	{"vm_name":"testweb","service_type":"monitoring__cron","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-2304dfa2-c3e9-4e45-b2b0-25ea2d67c5e0.log"}	2025-08-14 02:05:11.684+01	\N	\N	\N
3171	1	POST /templates	{"body":{"name":"Serveur_Web","service_type":"Web_Ngnix","category":"web","description":"Installe NGINX, déploie un site web de test sur la VM web camer.cm et configure UFW.","template_content":"#!/bin/bash\\r\\nset -e\\r\\n\\r\\necho \\"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\\"\\r\\n\\r\\n# 1. Installation des paquets\\r\\necho \\"📦 Installation de nginx et apache2 (optionnel)...\\"\\r\\nsudo apt update\\r\\nsudo apt install curl -y\\r\\nsudo apt install nginx apache2 -y\\r\\n\\r\\n# 2. Préparation du répertoire web\\r\\necho \\"📁 Création du site web ${WEB_ROOT}\\"\\r\\nsudo mkdir -p ${WEB_ROOT}\\r\\n\\r\\necho \\"📝 Création de la page d’accueil personnalisée...\\"\\r\\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\\r\\n<!DOCTYPE html>\\r\\n<html lang=\\\\\\"fr\\\\\\">\\r\\n<head>\\r\\n    <meta charset=\\\\\\"UTF-8\\\\\\">\\r\\n    <title>Camer-Web</title>\\r\\n</head>\\r\\n<body style=\\\\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\\\\">\\r\\n    <h1>✅ Bienvenue sur Camer-Web</h1>\\r\\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\r\\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\\r\\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\r\\n</body>\\r\\n</html>\\r\\nEOF\\r\\n\\r\\n# 3. Création du fichier NGINX vhost\\r\\necho \\"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\\"\\r\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\\r\\nserver {\\r\\n    listen 80;\\r\\n    server_name ${DOMAIN_NAME};\\r\\n\\r\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\r\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\r\\n\\r\\n    root ${WEB_ROOT};\\r\\n    index index.html;\\r\\n\\r\\n    location / {\\r\\n        try_files \\\\$uri \\\\$uri/ =404;\\r\\n    }\\r\\n}\\r\\nEOF\\r\\n\\r\\n# 4. Activation du site et désactivation du défaut\\r\\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\\r\\nsudo rm -f /etc/nginx/sites-enabled/default\\r\\n\\r\\n# 5. Redémarrage des services\\r\\necho \\"🚀 Redémarrage de NGINX...\\"\\r\\nsudo systemctl restart nginx\\r\\nsudo systemctl enable nginx\\r\\n\\r\\n# 6. Pare-feu\\r\\necho \\"🛡️ Configuration UFW pour NGINX...\\"\\r\\nsudo ufw allow OpenSSH\\r\\nsudo ufw allow 80/tcp\\r\\nsudo ufw allow 443/tcp\\r\\nsudo ufw --force enable\\r\\n\\r\\necho\\r\\necho \\"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\\"\\r\\n\\r\\n: \\"\\\\${INSTANCE_ID:?INSTANCE_ID is required}\\"\\r\\n\\r\\n# Save instance identifier\\r\\necho \\"INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\r\\necho \\"export INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\r\\nsudo chmod +x /etc/profile.d/instance_id.sh\\r\\nexport INSTANCE_ID=\\\\${INSTANCE_ID}\\r\\n\\r\\n# Log initialization\\r\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: \\\\${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log","script_path":"/scripts/serveur-web.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.24.130"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}},"query":{}}	2025-08-14 02:09:36.817+01	\N	\N	\N
3172	1	create_template:28	{}	2025-08-14 02:09:36.827+01	\N	\N	\N
3173	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:09:39.403+01	\N	\N	\N
3174	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:09:39.431+01	\N	\N	\N
3175	1	GET /templates	{"query":{}}	2025-08-14 02:09:51.732+01	\N	\N	\N
3176	1	GET /templates	{"query":{}}	2025-08-14 02:09:51.774+01	\N	\N	\N
3177	1	POST /templates/generate	{"body":{"template_id":28,"config_data":{"DOMAIN_NAME":"web.camer.cm","IP_ADDRESS":"192.168.24.130","VM_NAME":"camer-web","WEB_ROOT":"/var/www/web.camer.cm"}},"query":{}}	2025-08-14 02:10:32.288+01	\N	\N	\N
3178	1	generate_template_file:28:Web_Ngnix_web_Serveur_Web_script001.sh	{}	2025-08-14 02:10:32.306+01	\N	\N	\N
3179	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:10:58.673+01	\N	\N	\N
3180	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:10:58.734+01	\N	\N	\N
3181	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:11:56.587+01	\N	\N	\N
3182	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:11:56.615+01	\N	\N	\N
3183	1	GET /vms	{"query":{}}	2025-08-14 02:12:03.248+01	\N	\N	\N
3184	1	list_vms	{}	2025-08-14 02:12:03.324+01	\N	\N	\N
3185	1	GET /vms	{"query":{}}	2025-08-14 02:12:03.352+01	\N	\N	\N
3186	1	list_vms	{}	2025-08-14 02:12:03.37+01	\N	\N	\N
3187	1	GET /settings/me	{"query":{}}	2025-08-14 02:13:35.158+01	\N	\N	\N
3188	1	GET /settings/me	{"query":{}}	2025-08-14 02:13:35.197+01	\N	\N	\N
3189	1	GET /vms/storages	{"query":{}}	2025-08-14 02:13:35.224+01	\N	\N	\N
3190	1	GET /vms/storages	{"query":{}}	2025-08-14 02:13:35.263+01	\N	\N	\N
3191	1	GET /settings/account	{"query":{}}	2025-08-14 02:13:44.815+01	\N	\N	\N
3192	1	GET /settings/account	{"query":{}}	2025-08-14 02:13:44.832+01	\N	\N	\N
3193	1	GET /users	{"query":{}}	2025-08-14 02:14:06.52+01	\N	\N	\N
3194	1	GET /roles	{"query":{}}	2025-08-14 02:14:06.529+01	\N	\N	\N
3195	1	GET /users	{"query":{}}	2025-08-14 02:14:06.574+01	\N	\N	\N
3196	1	GET /roles	{"query":{}}	2025-08-14 02:14:06.591+01	\N	\N	\N
3197	1	GET /users/3	{"query":{}}	2025-08-14 02:14:14.379+01	\N	\N	\N
3198	1	GET /users/3	{"query":{}}	2025-08-14 02:14:20.22+01	\N	\N	\N
3199	1	GET /roles	{"query":{}}	2025-08-14 02:14:20.229+01	\N	\N	\N
3200	1	GET /users/3	{"query":{}}	2025-08-14 02:14:20.277+01	\N	\N	\N
3201	1	GET /roles	{"query":{}}	2025-08-14 02:14:20.289+01	\N	\N	\N
3202	1	GET /users	{"query":{}}	2025-08-14 02:14:24.21+01	\N	\N	\N
3203	1	GET /roles	{"query":{}}	2025-08-14 02:14:24.217+01	\N	\N	\N
3204	1	GET /users	{"query":{}}	2025-08-14 02:14:24.243+01	\N	\N	\N
3205	1	GET /roles	{"query":{}}	2025-08-14 02:14:24.255+01	\N	\N	\N
3206	1	GET /users/1	{"query":{}}	2025-08-14 02:14:26.487+01	\N	\N	\N
3278	1	list_vms	{}	2025-08-14 02:46:07.36+01	\N	\N	\N
3207	1	GET /users/1	{"query":{}}	2025-08-14 02:14:30.43+01	\N	\N	\N
3208	1	GET /roles	{"query":{}}	2025-08-14 02:14:37.947+01	\N	\N	\N
3209	1	GET /roles	{"query":{}}	2025-08-14 02:14:37.977+01	\N	\N	\N
3210	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 02:14:47.959+01	\N	\N	\N
3211	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 02:14:47.992+01	\N	\N	\N
3212	1	GET /roles	{"query":{}}	2025-08-14 02:14:48.001+01	\N	\N	\N
3213	1	GET /roles	{"query":{}}	2025-08-14 02:14:48.038+01	\N	\N	\N
3214	1	GET /permissions/role/2	{"query":{}}	2025-08-14 02:14:48.053+01	\N	\N	\N
3215	1	GET /permissions/role/3	{"query":{}}	2025-08-14 02:14:48.078+01	\N	\N	\N
3216	1	GET /permissions/role/1	{"query":{}}	2025-08-14 02:14:48.09+01	\N	\N	\N
3217	1	GET /permissions/role/2	{"query":{}}	2025-08-14 02:14:48.118+01	\N	\N	\N
3218	1	GET /permissions/role/3	{"query":{}}	2025-08-14 02:14:48.129+01	\N	\N	\N
3219	1	GET /permissions/role/1	{"query":{}}	2025-08-14 02:14:48.15+01	\N	\N	\N
3220	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-14 02:15:00.001+01	\N	\N	\N
3221	1	terminal_list_vms	{}	2025-08-14 02:15:01.901+01	\N	\N	\N
3222	1	GET /terminal/vms?onlyConnectable=false	{"query":{"onlyConnectable":"false"}}	2025-08-14 02:15:01.927+01	\N	\N	\N
3223	1	terminal_list_vms	{}	2025-08-14 02:15:03.886+01	\N	\N	\N
3224	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:15:14.774+01	\N	\N	\N
3225	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:15:14.809+01	\N	\N	\N
3226	1	Déploiement Terraform	{"vm_name":"testweb-ngnix","service_type":"Web_Ngnix","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-7acce2a5-2193-4978-8a29-f60bbd7d5058.log"}	2025-08-14 02:15:35.876+01	\N	\N	\N
3227	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:16:12.769+01	\N	\N	\N
3228	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:16:12.798+01	\N	\N	\N
3229	1	PUT /templates/28	{"body":{"name":"Serveur_Web","category":"web","service_type":"Web_Ngnix","description":"","template_content":"#!/bin/bash\\r\\nset -e\\r\\n\\r\\necho \\"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\\"\\r\\n\\r\\n# 1. J' Installation des paquets\\r\\necho \\"📦 Installation de nginx et apache2 (optionnel)...\\"\\r\\nsudo apt update\\r\\nsudo apt install curl -y\\r\\nsudo apt install nginx apache2 -y\\r\\n\\r\\n# 2. Préparation du répertoire web\\r\\necho \\"📁 Création du site web ${WEB_ROOT}\\"\\r\\nsudo mkdir -p ${WEB_ROOT}\\r\\n\\r\\necho \\"📝 Création de la page d’accueil personnalisée...\\"\\r\\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\\r\\n<!DOCTYPE html>\\r\\n<html lang=\\\\\\"fr\\\\\\">\\r\\n<head>\\r\\n    <meta charset=\\\\\\"UTF-8\\\\\\">\\r\\n    <title>Camer-Web</title>\\r\\n</head>\\r\\n<body style=\\\\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\\\\">\\r\\n    <h1>✅ Bienvenue sur Camer-Web</h1>\\r\\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\r\\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\\r\\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\r\\n</body>\\r\\n</html>\\r\\nEOF\\r\\n\\r\\n# 3. Création du fichier NGINX vhost\\r\\necho \\"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\\"\\r\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\\r\\nserver {\\r\\n    listen 80;\\r\\n    server_name ${DOMAIN_NAME};\\r\\n\\r\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\r\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\r\\n\\r\\n    root ${WEB_ROOT};\\r\\n    index index.html;\\r\\n\\r\\n    location / {\\r\\n        try_files \\\\$uri \\\\$uri/ =404;\\r\\n    }\\r\\n}\\r\\nEOF\\r\\n\\r\\n# 4. Activation du site et désactivation du défaut\\r\\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\\r\\nsudo rm -f /etc/nginx/sites-enabled/default\\r\\n\\r\\n# 5. Redémarrage des services\\r\\necho \\"🚀 Redémarrage de NGINX...\\"\\r\\nsudo systemctl restart nginx\\r\\nsudo systemctl enable nginx\\r\\n\\r\\n# 6. Pare-feu\\r\\necho \\"🛡️ Configuration UFW pour NGINX...\\"\\r\\nsudo ufw allow OpenSSH\\r\\nsudo ufw allow 80/tcp\\r\\nsudo ufw allow 443/tcp\\r\\nsudo ufw --force enable\\r\\n\\r\\necho\\r\\necho \\"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\\"\\r\\n\\r\\n: \\"\\\\${INSTANCE_ID:?INSTANCE_ID is required}\\"\\r\\n\\r\\n# Save instance identifier\\r\\necho \\"INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\r\\necho \\"export INSTANCE_ID=\\\\${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\r\\nsudo chmod +x /etc/profile.d/instance_id.sh\\r\\nexport INSTANCE_ID=\\\\${INSTANCE_ID}\\r\\n\\r\\n# Log initialization\\r\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: \\\\${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log","fields_schema":{"fields":[]}},"query":{}}	2025-08-14 02:16:34.67+01	\N	\N	\N
3230	1	update_template:28	{}	2025-08-14 02:16:34.733+01	\N	\N	\N
3231	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:17:12.922+01	\N	\N	\N
3232	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 02:17:12.949+01	\N	\N	\N
3233	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 02:32:14.016+01	\N	\N	\N
3234	1	login	{"user_id":1}	2025-08-14 02:32:14.254+01	\N	\N	\N
3235	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":true,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 02:32:32.033+01	\N	\N	\N
3236	1	login	{"user_id":1}	2025-08-14 02:32:32.219+01	\N	\N	\N
3237	1	GET /dashboard	{"query":{}}	2025-08-14 02:32:33.531+01	\N	\N	\N
3238	1	GET /vms	{"query":{}}	2025-08-14 02:32:33.532+01	\N	\N	\N
3239	1	list_vms	{}	2025-08-14 02:32:33.672+01	\N	\N	\N
3240	1	GET /vms	{"query":{}}	2025-08-14 02:32:33.74+01	\N	\N	\N
3241	1	GET /dashboard	{"query":{}}	2025-08-14 02:32:33.762+01	\N	\N	\N
3242	1	list_vms	{}	2025-08-14 02:32:33.775+01	\N	\N	\N
3243	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":true,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 02:36:20.226+01	\N	\N	\N
3244	1	login	{"user_id":1}	2025-08-14 02:36:20.472+01	\N	\N	\N
3245	1	GET /dashboard	{"query":{}}	2025-08-14 02:36:20.86+01	\N	\N	\N
3246	1	GET /vms	{"query":{}}	2025-08-14 02:36:20.861+01	\N	\N	\N
3247	1	list_vms	{}	2025-08-14 02:36:20.949+01	\N	\N	\N
3248	1	GET /vms	{"query":{}}	2025-08-14 02:36:21.003+01	\N	\N	\N
3249	1	GET /dashboard	{"query":{}}	2025-08-14 02:36:21.027+01	\N	\N	\N
3250	1	list_vms	{}	2025-08-14 02:36:21.04+01	\N	\N	\N
3251	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 02:40:52.708+01	\N	\N	\N
3252	1	login	{"user_id":1}	2025-08-14 02:40:52.949+01	\N	\N	\N
3253	1	GET /dashboard	{"query":{}}	2025-08-14 02:40:53.378+01	\N	\N	\N
3254	1	GET /vms	{"query":{}}	2025-08-14 02:40:53.38+01	\N	\N	\N
3255	1	list_vms	{}	2025-08-14 02:40:53.484+01	\N	\N	\N
3256	1	GET /vms	{"query":{}}	2025-08-14 02:40:53.547+01	\N	\N	\N
3257	1	GET /dashboard	{"query":{}}	2025-08-14 02:40:53.573+01	\N	\N	\N
3258	1	list_vms	{}	2025-08-14 02:40:53.588+01	\N	\N	\N
3259	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 02:44:27.522+01	\N	\N	\N
3260	1	logout	{"user_id":1}	2025-08-14 02:44:27.533+01	\N	\N	\N
3261	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 02:44:36.711+01	\N	\N	\N
3262	1	login	{"user_id":1}	2025-08-14 02:44:36.864+01	\N	\N	\N
3263	1	GET /dashboard	{"query":{}}	2025-08-14 02:44:37.281+01	\N	\N	\N
3264	1	GET /vms	{"query":{}}	2025-08-14 02:44:37.283+01	\N	\N	\N
3265	1	list_vms	{}	2025-08-14 02:44:37.417+01	\N	\N	\N
3266	1	GET /vms	{"query":{}}	2025-08-14 02:44:37.447+01	\N	\N	\N
3267	1	GET /dashboard	{"query":{}}	2025-08-14 02:44:37.499+01	\N	\N	\N
3268	1	list_vms	{}	2025-08-14 02:44:37.514+01	\N	\N	\N
3269	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 02:45:36.234+01	\N	\N	\N
3270	1	logout	{"user_id":1}	2025-08-14 02:45:36.248+01	\N	\N	\N
3271	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 02:46:06.563+01	\N	\N	\N
3272	1	login	{"user_id":1}	2025-08-14 02:46:06.72+01	\N	\N	\N
3273	1	GET /dashboard	{"query":{}}	2025-08-14 02:46:07.152+01	\N	\N	\N
3274	1	GET /vms	{"query":{}}	2025-08-14 02:46:07.154+01	\N	\N	\N
3275	1	list_vms	{}	2025-08-14 02:46:07.243+01	\N	\N	\N
3276	1	GET /vms	{"query":{}}	2025-08-14 02:46:07.311+01	\N	\N	\N
3277	1	GET /dashboard	{"query":{}}	2025-08-14 02:46:07.346+01	\N	\N	\N
3279	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 02:46:22.214+01	\N	\N	\N
3280	1	logout	{"user_id":1}	2025-08-14 02:46:22.227+01	\N	\N	\N
3281	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 02:47:44.367+01	\N	\N	\N
3282	1	login	{"user_id":1}	2025-08-14 02:47:44.59+01	\N	\N	\N
3283	1	GET /dashboard	{"query":{}}	2025-08-14 02:47:45.022+01	\N	\N	\N
3284	1	GET /vms	{"query":{}}	2025-08-14 02:47:45.023+01	\N	\N	\N
3285	1	list_vms	{}	2025-08-14 02:47:45.135+01	\N	\N	\N
3286	1	GET /vms	{"query":{}}	2025-08-14 02:47:45.199+01	\N	\N	\N
3287	1	GET /dashboard	{"query":{}}	2025-08-14 02:47:45.228+01	\N	\N	\N
3288	1	list_vms	{}	2025-08-14 02:47:45.245+01	\N	\N	\N
3289	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 03:01:42.241+01	\N	\N	\N
3290	1	login	{"user_id":1}	2025-08-14 03:01:42.473+01	\N	\N	\N
3291	1	GET /dashboard	{"query":{}}	2025-08-14 03:01:42.969+01	\N	\N	\N
3292	1	GET /vms	{"query":{}}	2025-08-14 03:01:42.971+01	\N	\N	\N
3293	1	list_vms	{}	2025-08-14 03:01:43.048+01	\N	\N	\N
3294	1	GET /vms	{"query":{}}	2025-08-14 03:01:43.122+01	\N	\N	\N
3295	1	GET /dashboard	{"query":{}}	2025-08-14 03:01:43.127+01	\N	\N	\N
3296	1	list_vms	{}	2025-08-14 03:01:43.148+01	\N	\N	\N
3297	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-14 03:01:46.687+01	\N	\N	\N
3298	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 03:02:57.922+01	\N	\N	\N
3299	1	logout	{"user_id":1}	2025-08-14 03:02:57.935+01	\N	\N	\N
3300	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 03:13:02.017+01	\N	\N	\N
3301	1	login	{"user_id":1}	2025-08-14 03:13:02.234+01	\N	\N	\N
3302	1	GET /dashboard	{"query":{}}	2025-08-14 03:13:02.732+01	\N	\N	\N
3303	1	GET /vms	{"query":{}}	2025-08-14 03:13:02.734+01	\N	\N	\N
3304	1	list_vms	{}	2025-08-14 03:13:02.827+01	\N	\N	\N
3305	1	GET /vms	{"query":{}}	2025-08-14 03:13:02.892+01	\N	\N	\N
3306	1	GET /dashboard	{"query":{}}	2025-08-14 03:13:02.916+01	\N	\N	\N
3307	1	list_vms	{}	2025-08-14 03:13:02.931+01	\N	\N	\N
3308	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-14 03:13:06.045+01	\N	\N	\N
3309	1	GET /dashboard/map	{"query":{}}	2025-08-14 03:13:12.551+01	\N	\N	\N
3310	1	GET /dashboard/map	{"query":{}}	2025-08-14 03:13:12.602+01	\N	\N	\N
3311	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-14 03:13:26.206+01	\N	\N	\N
3312	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-14 03:13:26.259+01	\N	\N	\N
3313	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-14 03:13:29.001+01	\N	\N	\N
3314	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 03:18:27.133+01	\N	\N	\N
3315	1	logout	{"user_id":1}	2025-08-14 03:18:27.144+01	\N	\N	\N
3316	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 03:25:46.761+01	\N	\N	\N
3317	1	login	{"user_id":1}	2025-08-14 03:25:46.969+01	\N	\N	\N
3318	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:25:56.926+01	\N	\N	\N
3319	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:25:56.973+01	\N	\N	\N
3320	1	GET /roles	{"query":{}}	2025-08-14 03:25:56.98+01	\N	\N	\N
3321	1	GET /roles	{"query":{}}	2025-08-14 03:25:57.016+01	\N	\N	\N
3322	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:25:57.028+01	\N	\N	\N
3323	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:25:57.037+01	\N	\N	\N
3324	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:25:57.043+01	\N	\N	\N
3325	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:25:57.099+01	\N	\N	\N
3326	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:25:57.107+01	\N	\N	\N
3327	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:25:57.116+01	\N	\N	\N
3328	1	POST /permissions	{"body":{"key":"chatbot.use","name":"chatbot.use","description":"chatbot.use"},"query":{}}	2025-08-14 03:26:05.328+01	\N	\N	\N
3329	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:26:05.355+01	\N	\N	\N
3330	1	GET /roles	{"query":{}}	2025-08-14 03:26:05.504+01	\N	\N	\N
3331	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:26:05.537+01	\N	\N	\N
3332	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:26:05.542+01	\N	\N	\N
3333	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:26:05.548+01	\N	\N	\N
3334	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 03:29:14.053+01	\N	\N	\N
3335	1	logout	{"user_id":1}	2025-08-14 03:29:14.071+01	\N	\N	\N
3336	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 03:34:40.78+01	\N	\N	\N
3337	1	login	{"user_id":1}	2025-08-14 03:34:41.01+01	\N	\N	\N
3338	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:34:41.495+01	\N	\N	\N
3339	1	GET /roles	{"query":{}}	2025-08-14 03:34:41.606+01	\N	\N	\N
3340	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:34:41.614+01	\N	\N	\N
3341	1	GET /roles	{"query":{}}	2025-08-14 03:34:41.682+01	\N	\N	\N
3342	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:34:41.689+01	\N	\N	\N
3343	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:34:41.696+01	\N	\N	\N
3344	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:34:41.701+01	\N	\N	\N
3345	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:34:41.749+01	\N	\N	\N
3346	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:34:41.755+01	\N	\N	\N
3347	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:34:41.761+01	\N	\N	\N
3348	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-14 03:36:03.061+01	\N	\N	\N
3349	1	GET /dashboard/stats?period=day	{"query":{"period":"day"}}	2025-08-14 03:36:03.14+01	\N	\N	\N
3350	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-14 03:36:12.276+01	\N	\N	\N
3351	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:37:33.229+01	\N	\N	\N
3352	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:37:33.261+01	\N	\N	\N
3353	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:37:38.999+01	\N	\N	\N
3354	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:37:39.029+01	\N	\N	\N
3355	1	GET /templates	{"query":{}}	2025-08-14 03:37:44.126+01	\N	\N	\N
3356	1	GET /templates	{"query":{}}	2025-08-14 03:37:44.149+01	\N	\N	\N
3357	1	POST /templates/generate	{"body":{"template_id":28,"config_data":{}},"query":{}}	2025-08-14 03:38:10.295+01	\N	\N	\N
3358	1	generate_template_file:28:Web_Ngnix_web_Serveur_Web_script002.sh	{}	2025-08-14 03:38:10.32+01	\N	\N	\N
3359	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:38:52.248+01	\N	\N	\N
3360	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:38:52.278+01	\N	\N	\N
3361	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 03:38:56.125+01	\N	\N	\N
3362	1	logout	{"user_id":1}	2025-08-14 03:38:56.135+01	\N	\N	\N
3363	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:38:56.69+01	\N	\N	\N
3364	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:38:56.742+01	\N	\N	\N
3365	1	DELETE /scripts/33	{"query":{}}	2025-08-14 03:40:10.047+01	\N	\N	\N
3366	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:40:15.234+01	\N	\N	\N
3367	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:40:15.313+01	\N	\N	\N
3368	1	GET /templates	{"query":{}}	2025-08-14 03:40:20.764+01	\N	\N	\N
3369	1	GET /templates	{"query":{}}	2025-08-14 03:40:20.789+01	\N	\N	\N
3370	1	GET /templates	{"query":{}}	2025-08-14 03:40:40.509+01	\N	\N	\N
3371	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 03:40:46.881+01	\N	\N	\N
3372	1	logout	{"user_id":1}	2025-08-14 03:40:46.888+01	\N	\N	\N
3373	1	GET /templates	{"query":{}}	2025-08-14 03:40:47.32+01	\N	\N	\N
3374	1	GET /templates	{"query":{}}	2025-08-14 03:40:47.342+01	\N	\N	\N
3375	1	GET /templates	{"query":{}}	2025-08-14 03:41:14.356+01	\N	\N	\N
3376	1	GET /templates	{"query":{}}	2025-08-14 03:41:14.427+01	\N	\N	\N
3377	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:41:27.379+01	\N	\N	\N
3378	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:41:27.411+01	\N	\N	\N
3379	1	GET /templates	{"query":{}}	2025-08-14 03:41:39.113+01	\N	\N	\N
3380	1	GET /templates	{"query":{}}	2025-08-14 03:41:39.14+01	\N	\N	\N
3381	1	GET /templates	{"query":{}}	2025-08-14 03:41:42.195+01	\N	\N	\N
3382	1	GET /templates	{"query":{}}	2025-08-14 03:41:42.219+01	\N	\N	\N
3383	1	GET /templates	{"query":{}}	2025-08-14 03:41:43.346+01	\N	\N	\N
3384	1	GET /templates	{"query":{}}	2025-08-14 03:41:43.371+01	\N	\N	\N
3385	1	GET /templates	{"query":{}}	2025-08-14 03:41:57.766+01	\N	\N	\N
3386	1	GET /templates	{"query":{}}	2025-08-14 03:41:57.836+01	\N	\N	\N
3387	1	GET /vms	{"query":{}}	2025-08-14 03:42:44.816+01	\N	\N	\N
3388	1	list_vms	{}	2025-08-14 03:42:44.882+01	\N	\N	\N
3389	1	GET /vms	{"query":{}}	2025-08-14 03:42:44.903+01	\N	\N	\N
3390	1	list_vms	{}	2025-08-14 03:42:44.929+01	\N	\N	\N
3391	1	GET /alerts	{"query":{}}	2025-08-14 03:43:24.078+01	\N	\N	\N
3392	1	GET /alerts	{"query":{}}	2025-08-14 03:43:24.101+01	\N	\N	\N
3393	1	GET /settings/account	{"query":{}}	2025-08-14 03:43:42.251+01	\N	\N	\N
3394	1	GET /settings/account	{"query":{}}	2025-08-14 03:43:42.283+01	\N	\N	\N
3395	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 03:46:14.569+01	\N	\N	\N
3396	1	login	{"user_id":1}	2025-08-14 03:46:14.894+01	\N	\N	\N
3397	1	GET /settings/account	{"query":{}}	2025-08-14 03:46:15.162+01	\N	\N	\N
3398	1	GET /settings/account	{"query":{}}	2025-08-14 03:46:15.195+01	\N	\N	\N
3399	1	GET /settings/account	{"query":{}}	2025-08-14 03:47:42.66+01	\N	\N	\N
3400	1	GET /settings/account	{"query":{}}	2025-08-14 03:47:42.713+01	\N	\N	\N
3401	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:48:55.912+01	\N	\N	\N
3402	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:48:55.95+01	\N	\N	\N
3403	1	GET /roles	{"query":{}}	2025-08-14 03:48:55.958+01	\N	\N	\N
3404	1	GET /roles	{"query":{}}	2025-08-14 03:48:56.01+01	\N	\N	\N
3405	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:48:56.031+01	\N	\N	\N
3406	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:48:56.037+01	\N	\N	\N
3407	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:48:56.041+01	\N	\N	\N
3408	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:48:56.099+01	\N	\N	\N
3409	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:48:56.104+01	\N	\N	\N
3410	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:48:56.111+01	\N	\N	\N
3411	1	POST /permissions	{"body":{"key":"script.delete","name":"script.delete","description":"script.delete"},"query":{}}	2025-08-14 03:49:03.858+01	\N	\N	\N
3412	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 03:49:03.886+01	\N	\N	\N
3413	1	GET /roles	{"query":{}}	2025-08-14 03:49:03.948+01	\N	\N	\N
3414	1	GET /permissions/role/2	{"query":{}}	2025-08-14 03:49:03.986+01	\N	\N	\N
3415	1	GET /permissions/role/3	{"query":{}}	2025-08-14 03:49:03.991+01	\N	\N	\N
3416	1	GET /permissions/role/1	{"query":{}}	2025-08-14 03:49:03.997+01	\N	\N	\N
3417	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:49:10.816+01	\N	\N	\N
3418	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:49:10.844+01	\N	\N	\N
3419	1	DELETE /scripts/33	{"query":{}}	2025-08-14 03:49:15.227+01	\N	\N	\N
3420	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:49:22.526+01	\N	\N	\N
3421	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 03:49:22.582+01	\N	\N	\N
3422	1	DELETE /scripts/33	{"query":{}}	2025-08-14 03:49:25.041+01	\N	\N	\N
3423	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 03:49:25.197+01	\N	\N	\N
3424	1	logout	{"user_id":1}	2025-08-14 03:49:25.203+01	\N	\N	\N
3425	1	GET /dashboard	{"query":{}}	2025-08-14 03:50:24.504+01	\N	\N	\N
3426	1	GET /vms	{"query":{}}	2025-08-14 03:50:24.504+01	\N	\N	\N
3427	1	list_vms	{}	2025-08-14 03:50:24.557+01	\N	\N	\N
3428	1	GET /vms	{"query":{}}	2025-08-14 03:50:24.603+01	\N	\N	\N
3429	1	GET /dashboard	{"query":{}}	2025-08-14 03:50:24.617+01	\N	\N	\N
3430	1	list_vms	{}	2025-08-14 03:50:24.637+01	\N	\N	\N
3431	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 03:50:44.264+01	\N	\N	\N
3432	1	logout	{"user_id":1}	2025-08-14 03:50:44.27+01	\N	\N	\N
3433	1	GET /dashboard	{"query":{}}	2025-08-14 03:50:47.196+01	\N	\N	\N
3434	1	GET /vms	{"query":{}}	2025-08-14 03:50:47.198+01	\N	\N	\N
3435	1	list_vms	{}	2025-08-14 03:50:47.334+01	\N	\N	\N
3436	1	GET /vms	{"query":{}}	2025-08-14 03:50:47.373+01	\N	\N	\N
3437	1	GET /dashboard	{"query":{}}	2025-08-14 03:50:47.374+01	\N	\N	\N
3438	1	list_vms	{}	2025-08-14 03:50:47.401+01	\N	\N	\N
3439	1	GET /dashboard	{"query":{}}	2025-08-14 03:50:49.714+01	\N	\N	\N
3440	1	GET /vms	{"query":{}}	2025-08-14 03:50:49.715+01	\N	\N	\N
3441	1	list_vms	{}	2025-08-14 03:50:49.792+01	\N	\N	\N
3442	1	GET /vms	{"query":{}}	2025-08-14 03:50:49.82+01	\N	\N	\N
3443	1	GET /dashboard	{"query":{}}	2025-08-14 03:50:49.821+01	\N	\N	\N
3444	1	list_vms	{}	2025-08-14 03:50:49.846+01	\N	\N	\N
3445	1	GET /dashboard/map	{"query":{}}	2025-08-14 03:50:56.803+01	\N	\N	\N
3446	1	GET /dashboard/map	{"query":{}}	2025-08-14 03:50:56.846+01	\N	\N	\N
3447	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin2023.","remember":false},"query":{}}	2025-08-14 04:03:24.46+01	\N	\N	\N
3448	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 04:03:37.336+01	\N	\N	\N
3449	1	login	{"user_id":1}	2025-08-14 04:03:37.525+01	\N	\N	\N
3450	1	GET /dashboard	{"query":{}}	2025-08-14 04:03:39.159+01	\N	\N	\N
3451	1	GET /vms	{"query":{}}	2025-08-14 04:03:39.16+01	\N	\N	\N
3452	1	list_vms	{}	2025-08-14 04:03:39.263+01	\N	\N	\N
3453	1	GET /vms	{"query":{}}	2025-08-14 04:03:39.292+01	\N	\N	\N
3454	1	GET /dashboard	{"query":{}}	2025-08-14 04:03:39.392+01	\N	\N	\N
3455	1	list_vms	{}	2025-08-14 04:03:39.41+01	\N	\N	\N
3456	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 04:17:33.362+01	\N	\N	\N
3457	1	login	{"user_id":1}	2025-08-14 04:17:33.559+01	\N	\N	\N
3458	1	GET /dashboard	{"query":{}}	2025-08-14 04:17:33.945+01	\N	\N	\N
3459	1	GET /vms	{"query":{}}	2025-08-14 04:17:33.946+01	\N	\N	\N
3460	1	list_vms	{}	2025-08-14 04:17:33.989+01	\N	\N	\N
3461	1	GET /vms	{"query":{}}	2025-08-14 04:17:34.018+01	\N	\N	\N
3462	1	GET /dashboard	{"query":{}}	2025-08-14 04:17:34.018+01	\N	\N	\N
3463	1	list_vms	{}	2025-08-14 04:17:34.046+01	\N	\N	\N
3464	1	GET /dashboard	{"query":{}}	2025-08-14 04:17:50.995+01	\N	\N	\N
3465	1	GET /vms	{"query":{}}	2025-08-14 04:17:50.996+01	\N	\N	\N
3466	1	list_vms	{}	2025-08-14 04:17:51.043+01	\N	\N	\N
3467	1	GET /vms	{"query":{}}	2025-08-14 04:17:51.067+01	\N	\N	\N
3468	1	GET /dashboard	{"query":{}}	2025-08-14 04:17:51.084+01	\N	\N	\N
3469	1	list_vms	{}	2025-08-14 04:17:51.1+01	\N	\N	\N
3470	1	GET /dashboard	{"query":{}}	2025-08-14 04:18:09.315+01	\N	\N	\N
3471	1	GET /vms	{"query":{}}	2025-08-14 04:18:09.316+01	\N	\N	\N
3472	1	list_vms	{}	2025-08-14 04:18:09.347+01	\N	\N	\N
3473	1	GET /vms	{"query":{}}	2025-08-14 04:18:09.372+01	\N	\N	\N
3474	1	GET /dashboard	{"query":{}}	2025-08-14 04:18:09.373+01	\N	\N	\N
3475	1	list_vms	{}	2025-08-14 04:18:09.395+01	\N	\N	\N
3476	1	GET /dashboard/insights?period=day	{"query":{"period":"day"}}	2025-08-14 04:18:13.16+01	\N	\N	\N
3477	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":null},"query":{}}	2025-08-14 04:20:46.287+01	\N	\N	\N
3478	1	logout	{"user_id":1}	2025-08-14 04:20:46.295+01	\N	\N	\N
3479	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 04:22:52.642+01	\N	\N	\N
3480	1	login	{"user_id":1}	2025-08-14 04:22:52.851+01	\N	\N	\N
3481	1	GET /dashboard	{"query":{}}	2025-08-14 04:22:53.413+01	\N	\N	\N
3482	1	GET /vms	{"query":{}}	2025-08-14 04:22:53.415+01	\N	\N	\N
3483	1	list_vms	{}	2025-08-14 04:22:53.451+01	\N	\N	\N
3484	1	GET /vms	{"query":{}}	2025-08-14 04:22:53.484+01	\N	\N	\N
3485	1	GET /dashboard	{"query":{}}	2025-08-14 04:22:53.485+01	\N	\N	\N
3486	1	list_vms	{}	2025-08-14 04:22:53.51+01	\N	\N	\N
3487	1	GET /dashboard	{"query":{}}	2025-08-14 04:23:21.936+01	\N	\N	\N
3488	1	GET /vms	{"query":{}}	2025-08-14 04:23:21.937+01	\N	\N	\N
3489	1	list_vms	{}	2025-08-14 04:23:22.022+01	\N	\N	\N
3490	1	GET /vms	{"query":{}}	2025-08-14 04:23:22.049+01	\N	\N	\N
3491	1	GET /dashboard	{"query":{}}	2025-08-14 04:23:22.064+01	\N	\N	\N
3492	1	list_vms	{}	2025-08-14 04:23:22.082+01	\N	\N	\N
3493	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":null},"query":{}}	2025-08-14 04:28:00.938+01	\N	\N	\N
3494	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"d9acbbe4-b48c-48eb-a534-fcc5e782ce2c"},"query":{}}	2025-08-14 04:28:00.958+01	\N	\N	\N
3495	1	logout	{"user_id":1}	2025-08-14 04:28:00.964+01	\N	\N	\N
3496	1	logout	{"user_id":1}	2025-08-14 04:28:00.969+01	\N	\N	\N
3497	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":null},"query":{}}	2025-08-14 04:28:01.021+01	\N	\N	\N
3498	1	logout	{"user_id":1}	2025-08-14 04:28:01.065+01	\N	\N	\N
3499	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 04:28:09.131+01	\N	\N	\N
3500	1	login	{"user_id":1}	2025-08-14 04:28:09.279+01	\N	\N	\N
3501	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 04:28:15.587+01	\N	\N	\N
3502	1	login	{"user_id":1}	2025-08-14 04:28:15.715+01	\N	\N	\N
3503	1	GET /dashboard	{"query":{}}	2025-08-14 04:28:50.57+01	\N	\N	\N
3504	1	GET /vms	{"query":{}}	2025-08-14 04:28:50.572+01	\N	\N	\N
3505	1	list_vms	{}	2025-08-14 04:28:50.631+01	\N	\N	\N
3506	1	GET /vms	{"query":{}}	2025-08-14 04:28:50.658+01	\N	\N	\N
3507	1	GET /dashboard	{"query":{}}	2025-08-14 04:28:50.713+01	\N	\N	\N
3508	1	list_vms	{}	2025-08-14 04:28:50.726+01	\N	\N	\N
3509	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 04:32:03.607+01	\N	\N	\N
3510	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 04:32:03.639+01	\N	\N	\N
3511	1	GET /roles	{"query":{}}	2025-08-14 04:32:03.654+01	\N	\N	\N
3512	1	GET /roles	{"query":{}}	2025-08-14 04:32:03.711+01	\N	\N	\N
3513	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:32:03.731+01	\N	\N	\N
3514	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:32:03.737+01	\N	\N	\N
3515	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:32:03.745+01	\N	\N	\N
3516	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:32:03.796+01	\N	\N	\N
3517	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:32:03.802+01	\N	\N	\N
3518	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:32:03.807+01	\N	\N	\N
3519	1	GET /permissions?page=1&limit=10&q=c&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"c","sort":"key","order":"asc"}}	2025-08-14 04:32:10.773+01	\N	\N	\N
3520	1	GET /roles	{"query":{}}	2025-08-14 04:32:10.809+01	\N	\N	\N
3521	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:32:10.843+01	\N	\N	\N
3522	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:32:10.849+01	\N	\N	\N
3523	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:32:10.858+01	\N	\N	\N
3524	1	GET /permissions?page=1&limit=10&q=ch&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"ch","sort":"key","order":"asc"}}	2025-08-14 04:32:10.975+01	\N	\N	\N
3525	1	GET /permissions?page=1&limit=10&q=cha&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"cha","sort":"key","order":"asc"}}	2025-08-14 04:32:11.469+01	\N	\N	\N
3526	1	GET /roles	{"query":{}}	2025-08-14 04:32:11.475+01	\N	\N	\N
3527	1	GET /roles	{"query":{}}	2025-08-14 04:32:11.516+01	\N	\N	\N
3528	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:32:11.527+01	\N	\N	\N
3529	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:32:11.535+01	\N	\N	\N
3530	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:32:11.543+01	\N	\N	\N
3531	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:32:11.74+01	\N	\N	\N
3532	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:32:11.745+01	\N	\N	\N
3533	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:32:11.751+01	\N	\N	\N
3534	1	GET /permissions?page=1&limit=10&q=chat&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"chat","sort":"key","order":"asc"}}	2025-08-14 04:32:12.672+01	\N	\N	\N
3535	1	GET /roles	{"query":{}}	2025-08-14 04:32:12.702+01	\N	\N	\N
3536	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:32:12.733+01	\N	\N	\N
3537	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:32:12.738+01	\N	\N	\N
3538	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:32:12.743+01	\N	\N	\N
3539	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[69]}],"query":{}}	2025-08-14 04:32:15.251+01	\N	\N	\N
3540	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":null},"query":{}}	2025-08-14 04:39:08.91+01	\N	\N	\N
3541	1	logout	{"user_id":1}	2025-08-14 04:39:08.929+01	\N	\N	\N
3542	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":true,"device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 04:39:23.293+01	\N	\N	\N
3543	1	login	{"user_id":1}	2025-08-14 04:39:23.465+01	\N	\N	\N
3544	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 04:39:24.095+01	\N	\N	\N
3545	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 04:39:24.135+01	\N	\N	\N
3546	1	GET /roles	{"query":{}}	2025-08-14 04:39:24.142+01	\N	\N	\N
3547	1	GET /roles	{"query":{}}	2025-08-14 04:39:24.191+01	\N	\N	\N
3548	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:39:24.219+01	\N	\N	\N
3549	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:39:24.226+01	\N	\N	\N
3550	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:39:24.234+01	\N	\N	\N
3551	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:39:24.466+01	\N	\N	\N
3552	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:39:24.474+01	\N	\N	\N
3553	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:39:24.48+01	\N	\N	\N
3554	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 04:41:50.504+01	\N	\N	\N
3555	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 04:42:17.376+01	\N	\N	\N
3556	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 04:42:30.931+01	\N	\N	\N
3557	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 04:46:00.271+01	\N	\N	\N
3558	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 04:51:12.182+01	\N	\N	\N
3559	1	GET /roles	{"query":{}}	2025-08-14 04:51:12.3+01	\N	\N	\N
3560	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 04:51:12.327+01	\N	\N	\N
3561	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:51:12.38+01	\N	\N	\N
3562	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:51:12.396+01	\N	\N	\N
3563	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:51:12.404+01	\N	\N	\N
3564	1	GET /roles	{"query":{}}	2025-08-14 04:51:12.416+01	\N	\N	\N
3565	1	GET /permissions/role/2	{"query":{}}	2025-08-14 04:51:12.691+01	\N	\N	\N
3566	1	GET /permissions/role/3	{"query":{}}	2025-08-14 04:51:12.698+01	\N	\N	\N
3567	1	GET /permissions/role/1	{"query":{}}	2025-08-14 04:51:12.707+01	\N	\N	\N
3568	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 05:02:29.28+01	\N	\N	\N
3569	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 05:02:42.244+01	\N	\N	\N
3570	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 05:02:58.167+01	\N	\N	\N
3571	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 05:03:23.047+01	\N	\N	\N
3572	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 05:04:04.915+01	\N	\N	\N
3573	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 05:04:05.025+01	\N	\N	\N
3574	1	GET /roles	{"query":{}}	2025-08-14 05:04:05.035+01	\N	\N	\N
3575	1	GET /roles	{"query":{}}	2025-08-14 05:04:05.132+01	\N	\N	\N
3576	1	GET /permissions/role/2	{"query":{}}	2025-08-14 05:04:05.139+01	\N	\N	\N
3577	1	GET /permissions/role/3	{"query":{}}	2025-08-14 05:04:05.147+01	\N	\N	\N
3578	1	GET /permissions/role/1	{"query":{}}	2025-08-14 05:04:05.154+01	\N	\N	\N
3579	1	GET /permissions/role/2	{"query":{}}	2025-08-14 05:04:05.221+01	\N	\N	\N
3580	1	GET /permissions/role/3	{"query":{}}	2025-08-14 05:04:05.231+01	\N	\N	\N
3581	1	GET /permissions/role/1	{"query":{}}	2025-08-14 05:04:05.239+01	\N	\N	\N
3582	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 09:10:22.107+01	\N	\N	\N
3583	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 09:10:40.775+01	\N	\N	\N
3584	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 09:10:44.209+01	\N	\N	\N
3666	1	GET /vms	{"query":{}}	2025-08-14 12:10:39.081+01	\N	\N	\N
3667	1	list_vms	{}	2025-08-14 12:10:39.175+01	\N	\N	\N
3668	1	GET /vms	{"query":{}}	2025-08-14 12:10:39.192+01	\N	\N	\N
3669	1	list_vms	{}	2025-08-14 12:10:39.211+01	\N	\N	\N
3670	1	POST /templates	{"body":{"name":"Monitoring setup","service_type":"monitoring_setup","category":"monitoring","description":"Installe les scripts de monitoring (statut système, services, logs) et les planifie via cron.","template_content":"#!/bin/bash\\nset -euo pipefail\\n\\n# Ensure monitoring directory exists with correct permissions\\nMONITOR_DIR=\\"${MONITOR_DIR:-/opt/monitoring}\\"\\nCRON_USER=\\"${CRON_USER:-nexus}\\"\\nsudo mkdir -p \\"$MONITOR_DIR\\"\\nsudo chown -R \\"$CRON_USER\\":\\"$CRON_USER\\" \\"$MONITOR_DIR\\"\\nsudo chmod 775 \\"$MONITOR_DIR\\"\\n\\n# Paths\\nSTATUS_SCRIPT_PATH=\\"${STATUS_SCRIPT_PATH:-$MONITOR_DIR/status.sh}\\"\\nSERVICES_SCRIPT_PATH=\\"${SERVICES_SCRIPT_PATH:-$MONITOR_DIR/services_status.sh}\\"\\nLOGS_SCRIPT_PATH=\\"${LOGS_SCRIPT_PATH:-$MONITOR_DIR/logs.sh}\\"\\n\\n# --- system status script ---\\ncat <<'EOS' > \\"$STATUS_SCRIPT_PATH\\"\\n#!/bin/bash\\nset -euo pipefail\\n\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s}\\",\\",\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > \\"$MONITOR_DIR/status.json\\"\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\nchmod +x \\"$STATUS_SCRIPT_PATH\\"\\n\\n# --- services status script ---\\ncat <<'EOS' > \\"$SERVICES_SCRIPT_PATH\\"\\n#!/bin/bash\\nset -euo pipefail\\n\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql mariadb postgresql docker kubelet redis-server mongod vsftpd proftpd php-fpm\\n)\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > \\"$MONITOR_DIR/services_status.json\\"\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\nchmod +x \\"$SERVICES_SCRIPT_PATH\\"\\n\\n# --- important logs script ---\\ncat <<'EOS' > \\"$LOGS_SCRIPT_PATH\\"\\n#!/bin/bash\\nset -euo pipefail\\n\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nLOG_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null | sed 's/\\"/\\\\\\\\\\"/g')\\nLOG_JSON=\\"\\"\\nwhile IFS= read -r line; do\\n  [ -z \\"$line\\" ] && continue\\n  LOG_JSON+=\\"\\\\\\"$line\\\\\\",\\"\\ndone <<< \\"$LOG_LINES\\"\\nLOG_JSON=\\"[${LOG_JSON%,}]\\"\\n\\ncat <<JSON > \\"$MONITOR_DIR/logs_status.json\\"\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"logs\\": ${LOG_JSON}\\n}\\nJSON\\nEOS\\nchmod +x \\"$LOGS_SCRIPT_PATH\\"\\n\\n# --- configure cron jobs ---\\nSTATUS_CRON_EXPR=\\"${STATUS_CRON_EXPR:-*/1 * * * *}\\"\\nSERVICES_CRON_EXPR=\\"${SERVICES_CRON_EXPR:-*/1 * * * *}\\"\\nLOGS_CRON_EXPR=\\"${LOGS_CRON_EXPR:-*/1 * * * *}\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\nMARK_LOGS=\\"# MONITORING_LOGS_CRON\\"\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nadd_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >$MONITOR_DIR/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nadd_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >$MONITOR_DIR/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nadd_cron_once \\"$LOGS_CRON_EXPR\\" \\"bash $LOGS_SCRIPT_PATH >$MONITOR_DIR/logs_status.log 2>&1\\" \\"$MARK_LOGS\\"\\n\\n# run once immediately\\nbash \\"$STATUS_SCRIPT_PATH\\" || true\\nbash \\"$SERVICES_SCRIPT_PATH\\" || true\\nbash \\"$LOGS_SCRIPT_PATH\\" || true\\n\\n# ensure cron service is enabled\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\nfi\\n\\nexit 0\\n","fields_schema":{"fields":[{"name":"MONITOR_DIR","label":"Dossier de monitoring","type":"text","required":true,"default":"/opt/monitoring"},{"name":"CRON_USER","label":"Utilisateur cron","type":"text","required":true,"default":"nexus"},{"name":"STATUS_SCRIPT_PATH","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT_PATH","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"LOGS_SCRIPT_PATH","label":"Chemin script logs","type":"text","required":true,"default":"/opt/monitoring/logs.sh"},{"name":"STATUS_CRON_EXPR","label":"Cron status","type":"text","required":true,"default":"*/1 * * * *"},{"name":"SERVICES_CRON_EXPR","label":"Cron services","type":"text","required":true,"default":"*/1 * * * *"},{"name":"LOGS_CRON_EXPR","label":"Cron logs","type":"text","required":true,"default":"*/1 * * * *"}]}},"query":{}}	2025-08-14 12:12:45.153+01	\N	\N	\N
3585	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 09:10:49.049+01	\N	\N	\N
3586	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 09:11:00.031+01	\N	\N	\N
3587	\N	POST /auth/refresh	{"body":{"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJsYXRpZm5qaW1vbHVoQGdtYWlsLmNvbSIsInJvbGVfaWQiOjEsImRldmljZV9pZCI6IjExMTY0MDA3LTJmNDYtNGU0NC05NWZiLWViMmY4MWI3ZmExYiIsImlhdCI6MTc1NTE0Mjc2MywiZXhwIjoxNzU1NzQ3NTYzLCJqdGkiOiIxOWUyYzdmMi1lYjAxLTRmYTItYjYwNi00MWNkMTdlYmU4MTYifQ.2Icgf7cT1w5_rm5YZP1pb6uPD4lJ3Bl_7Um6SLyiWX4","device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 09:11:03.711+01	\N	\N	\N
3588	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 09:16:38.189+01	\N	\N	\N
3589	1	login	{"user_id":1}	2025-08-14 09:16:38.419+01	\N	\N	\N
3590	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 09:16:39.011+01	\N	\N	\N
3591	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 09:16:39.049+01	\N	\N	\N
3592	1	GET /roles	{"query":{}}	2025-08-14 09:16:39.064+01	\N	\N	\N
3593	1	GET /roles	{"query":{}}	2025-08-14 09:16:39.11+01	\N	\N	\N
3594	1	GET /permissions/role/2	{"query":{}}	2025-08-14 09:16:39.136+01	\N	\N	\N
3595	1	GET /permissions/role/1	{"query":{}}	2025-08-14 09:16:39.143+01	\N	\N	\N
3596	1	GET /permissions/role/3	{"query":{}}	2025-08-14 09:16:39.155+01	\N	\N	\N
3597	1	GET /permissions/role/1	{"query":{}}	2025-08-14 09:16:39.195+01	\N	\N	\N
3598	1	GET /permissions/role/2	{"query":{}}	2025-08-14 09:16:39.204+01	\N	\N	\N
3599	1	GET /permissions/role/3	{"query":{}}	2025-08-14 09:16:39.237+01	\N	\N	\N
3600	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 09:41:56.138+01	\N	\N	\N
3601	1	login	{"user_id":1}	2025-08-14 09:41:56.382+01	\N	\N	\N
3602	1	GET /dashboard	{"query":{}}	2025-08-14 09:42:06.19+01	\N	\N	\N
3603	1	GET /vms	{"query":{}}	2025-08-14 09:42:06.192+01	\N	\N	\N
3604	1	list_vms	{}	2025-08-14 09:42:06.267+01	\N	\N	\N
3605	1	GET /vms	{"query":{}}	2025-08-14 09:42:06.394+01	\N	\N	\N
3606	1	GET /dashboard	{"query":{}}	2025-08-14 09:42:06.415+01	\N	\N	\N
3607	1	list_vms	{}	2025-08-14 09:42:06.439+01	\N	\N	\N
3608	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":null},"query":{}}	2025-08-14 10:13:12.246+01	\N	\N	\N
3609	1	logout	{"user_id":1}	2025-08-14 10:13:12.267+01	\N	\N	\N
3610	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 10:14:06.142+01	\N	\N	\N
3611	1	login	{"user_id":1}	2025-08-14 10:14:06.306+01	\N	\N	\N
3612	1	GET /dashboard	{"query":{}}	2025-08-14 10:14:06.877+01	\N	\N	\N
3613	1	GET /vms	{"query":{}}	2025-08-14 10:14:06.879+01	\N	\N	\N
3614	1	list_vms	{}	2025-08-14 10:14:06.99+01	\N	\N	\N
3615	1	GET /vms	{"query":{}}	2025-08-14 10:14:07.07+01	\N	\N	\N
3616	1	GET /dashboard	{"query":{}}	2025-08-14 10:14:07.08+01	\N	\N	\N
3617	1	list_vms	{}	2025-08-14 10:14:07.106+01	\N	\N	\N
3618	1	GET /dashboard	{"query":{}}	2025-08-14 10:27:34.676+01	\N	\N	\N
3619	1	GET /vms	{"query":{}}	2025-08-14 10:27:34.679+01	\N	\N	\N
3620	1	list_vms	{}	2025-08-14 10:27:34.747+01	\N	\N	\N
3621	1	GET /vms	{"query":{}}	2025-08-14 10:27:34.794+01	\N	\N	\N
3622	1	GET /dashboard	{"query":{}}	2025-08-14 10:27:34.797+01	\N	\N	\N
3623	1	list_vms	{}	2025-08-14 10:27:34.827+01	\N	\N	\N
3624	1	GET /dashboard	{"query":{}}	2025-08-14 10:28:02.453+01	\N	\N	\N
3625	1	GET /vms	{"query":{}}	2025-08-14 10:28:02.454+01	\N	\N	\N
3626	1	list_vms	{}	2025-08-14 10:28:02.535+01	\N	\N	\N
3627	1	GET /dashboard	{"query":{}}	2025-08-14 10:28:02.571+01	\N	\N	\N
3628	1	GET /vms	{"query":{}}	2025-08-14 10:28:02.573+01	\N	\N	\N
3629	1	list_vms	{}	2025-08-14 10:28:02.601+01	\N	\N	\N
3630	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 10:28:32.294+01	\N	\N	\N
3631	1	login	{"user_id":1}	2025-08-14 10:28:32.459+01	\N	\N	\N
3632	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 10:28:33.038+01	\N	\N	\N
3633	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 10:28:33.077+01	\N	\N	\N
3634	1	GET /roles	{"query":{}}	2025-08-14 10:28:33.091+01	\N	\N	\N
3635	1	GET /roles	{"query":{}}	2025-08-14 10:28:33.138+01	\N	\N	\N
3636	1	GET /permissions/role/3	{"query":{}}	2025-08-14 10:28:33.161+01	\N	\N	\N
3637	1	GET /permissions/role/1	{"query":{}}	2025-08-14 10:28:33.167+01	\N	\N	\N
3638	1	GET /permissions/role/2	{"query":{}}	2025-08-14 10:28:33.174+01	\N	\N	\N
3639	1	GET /permissions/role/2	{"query":{}}	2025-08-14 10:28:33.405+01	\N	\N	\N
3640	1	GET /permissions/role/3	{"query":{}}	2025-08-14 10:28:33.414+01	\N	\N	\N
3641	1	GET /permissions/role/1	{"query":{}}	2025-08-14 10:28:33.421+01	\N	\N	\N
3642	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 12:03:46.329+01	\N	\N	\N
3643	1	login	{"user_id":1}	2025-08-14 12:03:46.636+01	\N	\N	\N
3644	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 12:03:47.256+01	\N	\N	\N
3645	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 12:03:47.305+01	\N	\N	\N
3646	1	GET /roles	{"query":{}}	2025-08-14 12:03:47.32+01	\N	\N	\N
3647	1	GET /roles	{"query":{}}	2025-08-14 12:03:47.408+01	\N	\N	\N
3648	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:03:47.434+01	\N	\N	\N
3649	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:03:47.44+01	\N	\N	\N
3650	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:03:47.447+01	\N	\N	\N
3651	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:03:47.731+01	\N	\N	\N
3652	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:03:47.739+01	\N	\N	\N
3653	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:03:47.746+01	\N	\N	\N
3654	1	GET /vms	{"query":{}}	2025-08-14 12:04:21.39+01	\N	\N	\N
3655	1	list_vms	{}	2025-08-14 12:04:21.507+01	\N	\N	\N
3656	1	GET /vms	{"query":{}}	2025-08-14 12:04:21.527+01	\N	\N	\N
3657	1	list_vms	{}	2025-08-14 12:04:21.563+01	\N	\N	\N
3658	1	GET /vms	{"query":{}}	2025-08-14 12:09:58.55+01	\N	\N	\N
3659	1	list_vms	{}	2025-08-14 12:09:58.619+01	\N	\N	\N
3660	1	GET /vms	{"query":{}}	2025-08-14 12:09:58.639+01	\N	\N	\N
3661	1	list_vms	{}	2025-08-14 12:09:58.658+01	\N	\N	\N
3662	1	GET /vms	{"query":{}}	2025-08-14 12:10:16.959+01	\N	\N	\N
3663	1	list_vms	{}	2025-08-14 12:10:17.047+01	\N	\N	\N
3664	1	GET /vms	{"query":{}}	2025-08-14 12:10:17.065+01	\N	\N	\N
3665	1	list_vms	{}	2025-08-14 12:10:17.084+01	\N	\N	\N
3671	1	create_template:29	{}	2025-08-14 12:12:45.176+01	\N	\N	\N
3672	1	POST /templates/generate	{"body":{"template_id":29,"config_data":{"MONITOR_DIR":"/opt/monitoring","CRON_USER":"nexus","STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","LOGS_SCRIPT_PATH":"/opt/monitoring/logs.sh","STATUS_CRON_EXPR":"*/5 * * * *","SERVICES_CRON_EXPR":"*/5 * * * *","LOGS_CRON_EXPR":"*/10 * * * *"}},"query":{}}	2025-08-14 12:13:04.792+01	\N	\N	\N
3673	1	generate_template_file:29:monitoring_setup_monitoring_Monitoring_setup_script001.sh	{}	2025-08-14 12:13:04.811+01	\N	\N	\N
3674	1	GET /vms	{"query":{}}	2025-08-14 12:13:16.134+01	\N	\N	\N
3675	1	list_vms	{}	2025-08-14 12:13:16.201+01	\N	\N	\N
3676	1	GET /vms	{"query":{}}	2025-08-14 12:13:16.246+01	\N	\N	\N
3677	1	list_vms	{}	2025-08-14 12:13:16.265+01	\N	\N	\N
3678	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:13:41.162+01	\N	\N	\N
3679	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:13:41.193+01	\N	\N	\N
3680	1	DELETE /scripts/29	{"query":{}}	2025-08-14 12:13:51.899+01	\N	\N	\N
3681	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:15:37.855+01	\N	\N	\N
3682	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:15:37.912+01	\N	\N	\N
3683	1	DELETE /scripts/29	{"query":{}}	2025-08-14 12:15:46.604+01	\N	\N	\N
3684	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:15:53.876+01	\N	\N	\N
3685	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:15:53.958+01	\N	\N	\N
3686	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:19:39.352+01	\N	\N	\N
3687	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:19:39.422+01	\N	\N	\N
3688	1	DELETE /scripts/33	{"query":{}}	2025-08-14 12:19:47.295+01	\N	\N	\N
3689	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 12:21:20.883+01	\N	\N	\N
3690	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 12:21:20.918+01	\N	\N	\N
3691	1	GET /roles	{"query":{}}	2025-08-14 12:21:20.925+01	\N	\N	\N
3692	1	GET /roles	{"query":{}}	2025-08-14 12:21:20.962+01	\N	\N	\N
3693	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:21:20.981+01	\N	\N	\N
3694	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:21:20.989+01	\N	\N	\N
3695	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:21:20.995+01	\N	\N	\N
3696	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:21:21.043+01	\N	\N	\N
3697	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:21:21.049+01	\N	\N	\N
3698	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:21:21.069+01	\N	\N	\N
3699	1	POST /permissions	{"body":{"key":"script.delete","name":"script.delete","description":"script.delete"},"query":{}}	2025-08-14 12:25:19.476+01	\N	\N	\N
3700	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 12:25:19.506+01	\N	\N	\N
3701	1	GET /roles	{"query":{}}	2025-08-14 12:25:19.654+01	\N	\N	\N
3702	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:25:19.694+01	\N	\N	\N
3703	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:25:19.701+01	\N	\N	\N
3704	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:25:19.708+01	\N	\N	\N
3705	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:25:30.233+01	\N	\N	\N
3706	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:25:30.267+01	\N	\N	\N
3707	1	DELETE /scripts/33	{"query":{}}	2025-08-14 12:25:39.272+01	\N	\N	\N
3708	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:25:45.483+01	\N	\N	\N
3709	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:25:45.583+01	\N	\N	\N
3710	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 12:25:49.83+01	\N	\N	\N
3711	1	GET /permissions?page=1&limit=10&q=&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"","sort":"key","order":"asc"}}	2025-08-14 12:25:49.859+01	\N	\N	\N
3712	1	GET /roles	{"query":{}}	2025-08-14 12:25:49.866+01	\N	\N	\N
3713	1	GET /roles	{"query":{}}	2025-08-14 12:25:49.899+01	\N	\N	\N
3714	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:25:49.915+01	\N	\N	\N
3715	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:25:49.923+01	\N	\N	\N
3716	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:25:49.931+01	\N	\N	\N
3717	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:25:49.98+01	\N	\N	\N
3718	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:25:49.987+01	\N	\N	\N
3719	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:25:49.993+01	\N	\N	\N
3720	1	GET /permissions?page=1&limit=10&q=script.delete&sort=key&order=asc	{"query":{"page":"1","limit":"10","q":"script.delete","sort":"key","order":"asc"}}	2025-08-14 12:25:56.564+01	\N	\N	\N
3721	1	GET /roles	{"query":{}}	2025-08-14 12:25:56.598+01	\N	\N	\N
3722	1	GET /permissions/role/2	{"query":{}}	2025-08-14 12:25:56.63+01	\N	\N	\N
3723	1	GET /permissions/role/3	{"query":{}}	2025-08-14 12:25:56.635+01	\N	\N	\N
3724	1	GET /permissions/role/1	{"query":{}}	2025-08-14 12:25:56.641+01	\N	\N	\N
3725	1	POST /permissions/assign	{"body":[{"role_id":1,"permission_ids":[70]}],"query":{}}	2025-08-14 12:25:59.971+01	\N	\N	\N
3726	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:02.944+01	\N	\N	\N
3727	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:02.982+01	\N	\N	\N
3728	1	DELETE /scripts/33	{"query":{}}	2025-08-14 12:26:06.062+01	\N	\N	\N
3729	1	delete_script:33	{}	2025-08-14 12:26:06.076+01	\N	\N	\N
3730	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:06.104+01	\N	\N	\N
3731	1	DELETE /scripts/34	{"query":{}}	2025-08-14 12:26:09.91+01	\N	\N	\N
3732	1	delete_script:34	{}	2025-08-14 12:26:09.921+01	\N	\N	\N
3733	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:09.94+01	\N	\N	\N
3734	1	DELETE /templates/28	{"query":{}}	2025-08-14 12:26:18.333+01	\N	\N	\N
3735	1	delete_template:28	{}	2025-08-14 12:26:18.347+01	\N	\N	\N
3736	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:18.368+01	\N	\N	\N
3737	1	DELETE /templates/27	{"query":{}}	2025-08-14 12:26:21.156+01	\N	\N	\N
3738	1	delete_template:27	{}	2025-08-14 12:26:21.168+01	\N	\N	\N
3739	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:21.189+01	\N	\N	\N
3740	1	DELETE /templates/26	{"query":{}}	2025-08-14 12:26:25.413+01	\N	\N	\N
3741	1	delete_template:26	{}	2025-08-14 12:26:25.424+01	\N	\N	\N
3742	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:25.444+01	\N	\N	\N
3743	1	DELETE /templates/25	{"query":{}}	2025-08-14 12:26:26.723+01	\N	\N	\N
3744	1	delete_template:25	{}	2025-08-14 12:26:26.735+01	\N	\N	\N
3745	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:26.751+01	\N	\N	\N
3746	1	DELETE /scripts/29	{"query":{}}	2025-08-14 12:26:31.715+01	\N	\N	\N
3747	1	delete_script:29	{}	2025-08-14 12:26:31.723+01	\N	\N	\N
3748	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:31.742+01	\N	\N	\N
3749	1	DELETE /scripts/30	{"query":{}}	2025-08-14 12:26:37.641+01	\N	\N	\N
3750	1	delete_script:30	{}	2025-08-14 12:26:37.649+01	\N	\N	\N
3751	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:37.666+01	\N	\N	\N
3752	1	DELETE /scripts/31	{"query":{}}	2025-08-14 12:26:38.73+01	\N	\N	\N
3753	1	delete_script:31	{}	2025-08-14 12:26:38.739+01	\N	\N	\N
3754	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:38.758+01	\N	\N	\N
3755	1	DELETE /scripts/32	{"query":{}}	2025-08-14 12:26:40.404+01	\N	\N	\N
3756	1	delete_script:32	{}	2025-08-14 12:26:40.413+01	\N	\N	\N
3757	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:26:40.432+01	\N	\N	\N
3758	1	GET /templates	{"query":{}}	2025-08-14 12:27:04.988+01	\N	\N	\N
3759	1	GET /templates	{"query":{}}	2025-08-14 12:27:05.019+01	\N	\N	\N
3760	1	POST /templates/generate	{"body":{"template_id":29,"config_data":{"MONITOR_DIR":"/opt/monitoring","CRON_USER":"nexus","STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","LOGS_SCRIPT_PATH":"/opt/monitoring/logs.sh","STATUS_CRON_EXPR":"*/1 * * * *","SERVICES_CRON_EXPR":"*/1 * * * *","LOGS_CRON_EXPR":"*/1 * * * *"}},"query":{}}	2025-08-14 12:27:47.169+01	\N	\N	\N
3761	1	generate_template_file:29:monitoring_setup_monitoring_Monitoring_setup_script002.sh	{}	2025-08-14 12:27:47.184+01	\N	\N	\N
3762	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:27:49.932+01	\N	\N	\N
3763	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:27:49.961+01	\N	\N	\N
3764	1	POST /templates	{"body":{"name":"Web Server NGINX auto IP","service_type":"web_server_nginx_autoip","category":"web","description":"Installe NGINX et injecte automatiquement l’IP de la VM dans la page d’accueil.","template_content":"#!/bin/bash\\nset -euo pipefail\\n\\nDOMAIN_NAME=\\"${DOMAIN_NAME:-example.com}\\"\\nWEB_ROOT=\\"${WEB_ROOT:-/var/www/html}\\"\\nVM_NAME=\\"${VM_NAME:-vm1}\\"\\n\\n# Detect primary IP automatically\\nSERVER_IP=$(hostname -I | awk '{print $1}')\\n\\necho \\"🌐 Déploiement du serveur web NGINX (${DOMAIN_NAME})\\"\\n\\n# Install packages\\nsudo apt update\\nsudo apt install -y nginx curl\\n\\n# Prepare web directory\\nsudo mkdir -p \\"$WEB_ROOT\\"\\n\\nsudo tee \\"$WEB_ROOT/index.html\\" > /dev/null <<HTML\\n<!DOCTYPE html>\\n<html lang=\\"fr\\">\\n<head>\\n  <meta charset=\\"UTF-8\\" />\\n  <title>Camer-Web</title>\\n</head>\\n<body style=\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\">\\n  <h1>✅ Bienvenue sur Camer-Web</h1>\\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nHTML\\n\\n# Configure nginx vhost\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<NGINX\\nserver {\\n    listen 80;\\n    server_name ${DOMAIN_NAME};\\n    root ${WEB_ROOT};\\n    index index.html;\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\n    location / {\\n        try_files \\\\$uri \\\\$uri/ =404;\\n    }\\n}\\nNGINX\\n\\nsudo ln -sf /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/${DOMAIN_NAME}\\nsudo rm -f /etc/nginx/sites-enabled/default\\n\\nsudo systemctl restart nginx\\nsudo systemctl enable nginx\\n\\n# Firewall\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\n# Record instance ID if provided\\n: \\"${INSTANCE_ID:?INSTANCE_ID is required}\\"\\necho \\"INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log\\n","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}},"query":{}}	2025-08-14 12:31:32.199+01	\N	\N	\N
3765	1	create_template:30	{}	2025-08-14 12:31:32.214+01	\N	\N	\N
3766	1	POST /templates/generate	{"body":{"template_id":30,"config_data":{"DOMAIN_NAME":"demo.example.com","WEB_ROOT":"/var/www/demo","VM_NAME":"vm-demo","INSTANCE_ID":"abc123"}},"query":{}}	2025-08-14 12:32:34.133+01	\N	\N	\N
3767	1	generate_template_file:30:web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script001.sh	{}	2025-08-14 12:32:34.151+01	\N	\N	\N
3768	1	POST /templates	{"body":{"name":"Web Server Apache auto IP","service_type":"web_server_apache_autoip","category":"web","description":"Installe Apache et injecte automatiquement l’IP de la VM dans la page d’accueil.","template_content":"#!/bin/bash\\nset -euo pipefail\\n\\nDOMAIN_NAME=\\"${DOMAIN_NAME:-example.com}\\"\\nWEB_ROOT=\\"${WEB_ROOT:-/var/www/html}\\"\\nVM_NAME=\\"${VM_NAME:-vm1}\\"\\n\\n# Detect primary IP automatically\\nSERVER_IP=$(hostname -I | awk '{print $1}')\\n\\necho \\"🌐 Déploiement du serveur web Apache (${DOMAIN_NAME})\\"\\n\\n# Install packages\\nsudo apt update\\nsudo apt install -y apache2 curl\\n\\n# Prepare web directory\\nsudo mkdir -p \\"$WEB_ROOT\\"\\n\\nsudo tee \\"$WEB_ROOT/index.html\\" > /dev/null <<HTML\\n<!DOCTYPE html>\\n<html lang=\\"fr\\">\\n<head>\\n  <meta charset=\\"UTF-8\\" />\\n  <title>Camer-Web</title>\\n</head>\\n<body style=\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\">\\n  <h1>✅ Bienvenue sur Camer-Web</h1>\\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nHTML\\n\\n# Configure Apache virtual host\\nsudo tee /etc/apache2/sites-available/${DOMAIN_NAME}.conf > /dev/null <<APACHE\\n<VirtualHost *:80>\\n    ServerName ${DOMAIN_NAME}\\n    DocumentRoot ${WEB_ROOT}\\n    ErrorLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.error.log\\n    CustomLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.access.log combined\\n</VirtualHost>\\nAPACHE\\n\\nsudo a2ensite ${DOMAIN_NAME}.conf\\nsudo a2dissite 000-default.conf\\nsudo systemctl reload apache2\\nsudo systemctl enable apache2\\n\\n# Firewall\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\n# Record instance ID if provided\\n: \\"${INSTANCE_ID:?INSTANCE_ID is required}\\"\\necho \\"INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log\\n","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}},"query":{}}	2025-08-14 12:32:46.491+01	\N	\N	\N
3769	1	create_template:31	{}	2025-08-14 12:32:46.506+01	\N	\N	\N
3770	1	POST /templates/generate	{"body":{"template_id":32,"config_data":{"DOMAIN_NAME":"demo.example.com","WEB_ROOT":"/var/www/demo","VM_NAME":"vm-demo","INSTANCE_ID":"abc123"}},"query":{}}	2025-08-14 12:32:58.039+01	\N	\N	\N
3771	1	POST /templates/generate	{"body":{"template_id":31,"config_data":{"DOMAIN_NAME":"demo.example.com","WEB_ROOT":"/var/www/demo","VM_NAME":"vm-demo","INSTANCE_ID":"abc123"}},"query":{}}	2025-08-14 12:33:19.148+01	\N	\N	\N
3772	1	generate_template_file:31:web_server_apache_autoip_web_Web_Server_Apache_auto_IP_script001.sh	{}	2025-08-14 12:33:19.166+01	\N	\N	\N
3773	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:33:30.45+01	\N	\N	\N
3774	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:33:30.531+01	\N	\N	\N
3775	1	GET /vms	{"query":{}}	2025-08-14 12:34:44.409+01	\N	\N	\N
3776	1	list_vms	{}	2025-08-14 12:34:44.473+01	\N	\N	\N
3777	1	GET /vms	{"query":{}}	2025-08-14 12:34:44.491+01	\N	\N	\N
3778	1	list_vms	{}	2025-08-14 12:34:44.511+01	\N	\N	\N
3848	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:47.984+01	\N	\N	\N
3849	1	DELETE /templates/29	{"query":{}}	2025-08-14 13:27:49.788+01	\N	\N	\N
3850	1	delete_template:29	{}	2025-08-14 13:27:49.8+01	\N	\N	\N
3851	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:49.817+01	\N	\N	\N
3852	1	POST /templates	{"body":{"name":"Monitoring setup","service_type":"monitoring_setup","category":"monitoring","description":"Génère les scripts de statut système, services et logs importants et les planifie via cron.","template_content":"#!/bin/bash\\nset -euo pipefail\\n\\n# Ensure monitoring directory exists with correct permissions\\nMONITOR_DIR=\\"${MONITOR_DIR:-/opt/monitoring}\\"\\nCRON_USER=\\"${CRON_USER:-nexus}\\"\\nsudo mkdir -p \\"$MONITOR_DIR\\"\\nsudo chown -R \\"$CRON_USER\\":\\"$CRON_USER\\" \\"$MONITOR_DIR\\"\\nsudo chmod 775 \\"$MONITOR_DIR\\"\\n\\n# Paths\\nSTATUS_SCRIPT_PATH=\\"${STATUS_SCRIPT_PATH:-$MONITOR_DIR/status.sh}\\"\\nSERVICES_SCRIPT_PATH=\\"${SERVICES_SCRIPT_PATH:-$MONITOR_DIR/services_status.sh}\\"\\nLOGS_SCRIPT_PATH=\\"${LOGS_SCRIPT_PATH:-$MONITOR_DIR/logs.sh}\\"\\n\\n# --- system status script ---\\ncat <<'EOS' > \\"$STATUS_SCRIPT_PATH\\"\\n#!/bin/bash\\nset -euo pipefail\\n\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nHOSTNAME=$(hostname)\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\\\\\"pid\\\\\\\\\\":%s,\\\\\\\\\\"cmd\\\\\\\\\\":\\\\\\\\\\"%s\\\\\\\\\\",\\\\\\\\\\"cpu\\\\\\\\\\":%s}\\",\\",\\", $1, $2, $3}')\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\n\\ncat <<JSON > \\"$MONITOR_DIR/status.json\\"\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\n  \\"memory\\": {\\n    \\"total_kb\\": ${MEM_TOTAL},\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\n  },\\n  \\"disk\\": {\\n    \\"total_bytes\\": ${DISK_TOTAL},\\n    \\"used_bytes\\": ${DISK_USED},\\n    \\"available_bytes\\": ${DISK_AVAIL}\\n  },\\n  \\"network\\": {\\n    \\"interface\\": \\"${IFACE}\\",\\n    \\"rx_bytes\\": ${RX_BYTES},\\n    \\"tx_bytes\\": ${TX_BYTES}\\n  },\\n  \\"open_ports\\": [${OPEN_PORTS}],\\n  \\"top_processes\\": ${TOP_PROCESSES}\\n}\\nJSON\\nEOS\\nchmod +x \\"$STATUS_SCRIPT_PATH\\"\\n\\n# --- services status script ---\\ncat <<'EOS' > \\"$SERVICES_SCRIPT_PATH\\"\\n#!/bin/bash\\nset -euo pipefail\\n\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nSERVICES=(\\n  sshd ufw fail2ban cron crond nginx apache2 mysql mariadb postgresql docker kubelet redis-server mongod vsftpd proftpd php-fpm\\n)\\nSERVICE_STATUS_JSON=\\"\\"\\nfor svc in \\"${SERVICES[@]}\\"; do\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\n  fi\\ndone\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\n\\ncat <<JSON > \\"$MONITOR_DIR/services_status.json\\"\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\n}\\nJSON\\nEOS\\nchmod +x \\"$SERVICES_SCRIPT_PATH\\"\\n\\n# --- important logs script ---\\ncat <<'EOS' > \\"$LOGS_SCRIPT_PATH\\"\\n#!/bin/bash\\nset -euo pipefail\\n\\nif [ -f /etc/instance-info.conf ]; then\\n  source /etc/instance-info.conf\\nfi\\n\\nTIMESTAMP=$(date -Iseconds)\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\nLOG_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null | sed 's/\\"/\\\\\\\\\\"/g')\\nLOG_JSON=\\"\\"\\nwhile IFS= read -r line; do\\n  [ -z \\"$line\\" ] && continue\\n  LOG_JSON+=\\"\\\\\\"$line\\\\\\",\\"\\ndone <<< \\"$LOG_LINES\\"\\nLOG_JSON=\\"[${LOG_JSON%,}]\\"\\n\\ncat <<JSON > \\"$MONITOR_DIR/logs_status.json\\"\\n{\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\n  \\"logs\\": ${LOG_JSON}\\n}\\nJSON\\nEOS\\nchmod +x \\"$LOGS_SCRIPT_PATH\\"\\n\\n# --- configure cron jobs ---\\nSTATUS_CRON_EXPR=\\"${STATUS_CRON_EXPR:-*/1 * * * *}\\"\\nSERVICES_CRON_EXPR=\\"${SERVICES_CRON_EXPR:-*/1 * * * *}\\"\\nLOGS_CRON_EXPR=\\"${LOGS_CRON_EXPR:-*/1 * * * *}\\"\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\nMARK_LOGS=\\"# MONITORING_LOGS_CRON\\"\\n\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/null || true; }\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\nadd_cron_once() {\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\n  local current\\n  current=\\"$(crontab_get)\\"\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\n  fi\\n}\\n\\nadd_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >$MONITOR_DIR/status.log 2>&1\\" \\"$MARK_STATUS\\"\\nadd_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >$MONITOR_DIR/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\nadd_cron_once \\"$LOGS_CRON_EXPR\\" \\"bash $LOGS_SCRIPT_PATH >$MONITOR_DIR/logs_status.log 2>&1\\" \\"$MARK_LOGS\\"\\n\\n# run once immediately\\nbash \\"$STATUS_SCRIPT_PATH\\" || true\\nbash \\"$SERVICES_SCRIPT_PATH\\" || true\\nbash \\"$LOGS_SCRIPT_PATH\\" || true\\n\\n# ensure cron service is enabled\\nif command -v systemctl >/dev/null 2>&1; then\\n  systemctl enable --now cron 2>/null || systemctl enable --now crond 2>/null || true\\nfi\\n\\nexit 0\\n","fields_schema":{"fields":[{"name":"MONITOR_DIR","label":"Dossier de monitoring","type":"text","required":true,"default":"/opt/monitoring"},{"name":"CRON_USER","label":"Utilisateur cron","type":"text","required":true,"default":"nexus"},{"name":"STATUS_SCRIPT_PATH","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT_PATH","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"LOGS_SCRIPT_PATH","label":"Chemin script logs","type":"text","required":true,"default":"/opt/monitoring/logs.sh"},{"name":"STATUS_CRON_EXPR","label":"Cron status","type":"text","required":true,"default":"*/1 * * * *"},{"name":"SERVICES_CRON_EXPR","label":"Cron services","type":"text","required":true,"default":"*/1 * * * *"},{"name":"LOGS_CRON_EXPR","label":"Cron logs","type":"text","required":true,"default":"*/1 * * * *"}]}},"query":{}}	2025-08-14 13:42:04.45+01	\N	\N	\N
3853	1	create_template:34	{}	2025-08-14 13:42:04.472+01	\N	\N	\N
3854	1	POST /templates/generate	{"body":{"template_id":34,"config_data":{"MONITOR_DIR":"/opt/monitoring","CRON_USER":"nexus","STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","LOGS_SCRIPT_PATH":"/opt/monitoring/logs.sh","STATUS_CRON_EXPR":"*/2 * * * *","SERVICES_CRON_EXPR":"*/2 * * * *","LOGS_CRON_EXPR":"*/10 * * * *"}},"query":{}}	2025-08-14 13:42:47.733+01	\N	\N	\N
3855	1	generate_template_file:34:monitoring_setup_monitoring_Monitoring_setup_script003.sh	{}	2025-08-14 13:42:47.756+01	\N	\N	\N
3856	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:43:58.04+01	\N	\N	\N
3857	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:43:58.105+01	\N	\N	\N
3779	1	POST /templates	{"body":{"name":"API interne Node.js","service_type":"node_api","category":"api","description":"Déploie une API Express et configure un service systemd.","template_content":"#!/bin/bash\\n\\necho \\"🚀 Déploiement du serveur API Node.js - ${DOMAIN_NAME} (${IP_ADDRESS})\\"\\nAPP_DIR=\\"${APP_DIR}\\"\\nPROXY_IP=\\"${PROXY_IP}\\"\\nAPI_USER=\\"${API_USER}\\"\\nSYSTEMD_SERVICE=\\"${SYSTEMD_SERVICE}\\"\\n\\n# ✅ Ensure the API user exists\\nif ! id -u \\"$API_USER\\" >/dev/null 2>&1; then\\n  sudo useradd -m -s /bin/bash \\"$API_USER\\"\\nfi\\n\\n# 1. Mise à jour système & installation de Node.js\\necho \\"📦 Installation de Node.js et des dépendances...\\"\\nsudo apt update && sudo apt install -y nodejs npm ufw curl\\n\\n# 2. Création du dossier de l'application\\necho \\"📁 Création du dossier $APP_DIR...\\"\\nsudo mkdir -p \\"$APP_DIR\\"\\nsudo chown -R $API_USER:$API_USER \\"$APP_DIR\\"\\n\\n# 3. Création de l'application Express minimale\\nsudo -u $API_USER tee \\"$APP_DIR/package.json\\" > /dev/null <<'PKG'\\n{\\n  \\"name\\": \\"camer-api\\",\\n  \\"version\\": \\"1.0.0\\",\\n  \\"main\\": \\"server.js\\",\\n  \\"scripts\\": {\\n    \\"start\\": \\"node server.js\\"\\n  },\\n  \\"dependencies\\": {\\n    \\"express\\": \\"^4.18.2\\"\\n  }\\n}\\nPKG\\n\\nsudo -u $API_USER npm --prefix \\"$APP_DIR\\" install\\n\\nsudo -u $API_USER tee \\"$APP_DIR/server.js\\" > /dev/null <<'JS'\\nconst express = require('express');\\nconst app = express();\\napp.get('/', (req, res) => res.send('✅ Bienvenue sur l\\\\'API interne Camer!'));\\nconst port = process.env.PORT || 3000;\\napp.listen(port, () => console.log(`API listening on port ${port}`));\\nJS\\n\\n# 4. Configuration du service systemd\\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<'UNIT'\\n[Unit]\\nDescription=Service Node.js pour API (${DOMAIN_NAME})\\nAfter=network.target\\n\\n[Service]\\nUser=$API_USER\\nGroup=$API_USER\\nWorkingDirectory=$APP_DIR\\nExecStart=/usr/bin/npm --prefix $APP_DIR start\\nRestart=on-failure\\nEnvironment=PORT=3000\\n\\n[Install]\\nWantedBy=multi-user.target\\nUNIT\\n\\n# 5. Démarrage du service\\nsudo systemctl daemon-reload\\nsudo systemctl enable ${SYSTEMD_SERVICE}\\nsudo systemctl start ${SYSTEMD_SERVICE}\\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\\n\\n# 6. Sécurisation avec UFW\\nsudo ufw allow from $PROXY_IP proto tcp to any port 3000 comment \\"Autorise accès proxy vers API\\"\\nsudo ufw allow OpenSSH\\nsudo ufw --force enable\\nsudo ufw status verbose\\n\\n# 7. Test local\\ncurl -s http://127.0.0.1:3000 || echo \\"⚠️ API non accessible localement, vérifier les logs.\\"\\n\\necho \\"✅ Déploiement terminé. L’API Node.js écoute sur le port 3000 (LAN uniquement).\\"\\n","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"api.example.com"},{"name":"IP_ADDRESS","label":"Adresse IP","type":"text","required":true},{"name":"APP_DIR","label":"Dossier de l'application","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"IP du proxy autorisé","type":"text","required":true,"default":"192.168.0.10"},{"name":"API_USER","label":"Utilisateur API","type":"text","required":true,"default":"apiuser"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"node-api"}]}},"query":{}}	2025-08-14 12:36:59.678+01	\N	\N	\N
3780	1	create_template:32	{}	2025-08-14 12:36:59.693+01	\N	\N	\N
3781	1	Déploiement Terraform	{"vm_name":"testwebngnix","service_type":"web_server_nginx_autoip","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-cf8d9d32-1af0-472c-9800-8a74d4290c59.log"}	2025-08-14 12:39:10.207+01	\N	\N	\N
3782	1	GET /vms	{"query":{}}	2025-08-14 12:49:10.123+01	\N	\N	\N
3783	1	list_vms	{}	2025-08-14 12:49:10.198+01	\N	\N	\N
3784	1	GET /vms	{"query":{}}	2025-08-14 12:49:10.219+01	\N	\N	\N
3785	1	list_vms	{}	2025-08-14 12:49:10.239+01	\N	\N	\N
3786	1	GET /vms	{"query":{}}	2025-08-14 12:49:18.031+01	\N	\N	\N
3787	1	list_vms	{}	2025-08-14 12:49:18.127+01	\N	\N	\N
3788	1	GET /vms	{"query":{}}	2025-08-14 12:49:18.157+01	\N	\N	\N
3789	1	list_vms	{}	2025-08-14 12:49:18.185+01	\N	\N	\N
3790	1	GET /vms	{"query":{}}	2025-08-14 12:50:30.647+01	\N	\N	\N
3791	1	GET /dashboard	{"query":{}}	2025-08-14 12:50:30.648+01	\N	\N	\N
3792	1	list_vms	{}	2025-08-14 12:50:30.682+01	\N	\N	\N
3793	1	GET /vms	{"query":{}}	2025-08-14 12:50:30.711+01	\N	\N	\N
3794	1	GET /dashboard	{"query":{}}	2025-08-14 12:50:30.832+01	\N	\N	\N
3795	1	list_vms	{}	2025-08-14 12:50:30.846+01	\N	\N	\N
3796	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:55:11.553+01	\N	\N	\N
3797	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:55:11.581+01	\N	\N	\N
3798	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:55:26.094+01	\N	\N	\N
3799	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:55:26.118+01	\N	\N	\N
3800	1	PUT /templates/29	{"body":{"name":"Monitoring setup","category":"monitoring","service_type":"monitoring_setup","description":"","template_content":"#!/bin/bash\\r\\nset -euo pipefail\\r\\n\\r\\n# Ensure monitoring directory exists with correct permissions\\r\\nMONITOR_DIR=\\"/opt/monitoring\\"\\r\\nCRON_USER=\\"${CRON_USER:-nexus}\\"\\r\\nsudo mkdir -p \\"$MONITOR_DIR\\"\\r\\nsudo chown -R \\"$CRON_USER\\":\\"$CRON_USER\\" \\"$MONITOR_DIR\\"\\r\\nsudo chmod 775 \\"$MONITOR_DIR\\"\\r\\n\\r\\n# Paths\\r\\nSTATUS_SCRIPT_PATH=\\"${STATUS_SCRIPT_PATH:-$MONITOR_DIR/status.sh}\\"\\r\\nSERVICES_SCRIPT_PATH=\\"${SERVICES_SCRIPT_PATH:-$MONITOR_DIR/services_status.sh}\\"\\r\\nLOGS_SCRIPT_PATH=\\"${LOGS_SCRIPT_PATH:-$MONITOR_DIR/logs.sh}\\"\\r\\n\\r\\n# --- system status script ---\\r\\ncat <<'EOS' > \\"$STATUS_SCRIPT_PATH\\"\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\nMONITOR_DIR=\\"/opt/monitoring\\"\\r\\n\\r\\nif [ -f /etc/instance-info.conf ]; then\\r\\n  source /etc/instance-info.conf\\r\\nfi\\r\\n\\r\\nTIMESTAMP=$(date -Iseconds)\\r\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\r\\nHOSTNAME=$(hostname)\\r\\nIP_ADDR=$(hostname -I | awk '{print $1}')\\r\\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\\r\\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\\r\\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\\r\\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\\r\\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\\r\\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\\r\\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\\r\\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\\r\\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\\r\\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,\\":\\"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\\r\\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf \\"{\\\\\\"pid\\\\\\":%s,\\\\\\"cmd\\\\\\":\\\\\\"%s\\\\\\",\\\\\\"cpu\\\\\\":%s}\\",\\",\\", $1, $2, $3}')\\r\\nTOP_PROCESSES=\\"[${TOP_PROCESSES%,}]\\"\\r\\n\\r\\ncat <<JSON > \\"$MONITOR_DIR/status.json\\"\\r\\n{\\r\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\r\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\r\\n  \\"hostname\\": \\"${HOSTNAME}\\",\\r\\n  \\"ip_address\\": \\"${IP_ADDR}\\",\\r\\n  \\"load_average\\": \\"${LOAD_AVG}\\",\\r\\n  \\"memory\\": {\\r\\n    \\"total_kb\\": ${MEM_TOTAL},\\r\\n    \\"available_kb\\": ${MEM_AVAILABLE}\\r\\n  },\\r\\n  \\"disk\\": {\\r\\n    \\"total_bytes\\": ${DISK_TOTAL},\\r\\n    \\"used_bytes\\": ${DISK_USED},\\r\\n    \\"available_bytes\\": ${DISK_AVAIL}\\r\\n  },\\r\\n  \\"network\\": {\\r\\n    \\"interface\\": \\"${IFACE}\\",\\r\\n    \\"rx_bytes\\": ${RX_BYTES},\\r\\n    \\"tx_bytes\\": ${TX_BYTES}\\r\\n  },\\r\\n  \\"open_ports\\": [${OPEN_PORTS}],\\r\\n  \\"top_processes\\": ${TOP_PROCESSES}\\r\\n}\\r\\nJSON\\r\\nEOS\\r\\nchmod +x \\"$STATUS_SCRIPT_PATH\\"\\r\\n\\r\\n# --- services status script ---\\r\\ncat <<'EOS' > \\"$SERVICES_SCRIPT_PATH\\"\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\nMONITOR_DIR=\\"/opt/monitoring\\"\\r\\n\\r\\nif [ -f /etc/instance-info.conf ]; then\\r\\n  source /etc/instance-info.conf\\r\\nfi\\r\\n\\r\\nTIMESTAMP=$(date -Iseconds)\\r\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\r\\nSERVICES=(\\r\\n  sshd ufw fail2ban cron crond nginx apache2 mysql mariadb postgresql docker kubelet redis-server mongod vsftpd proftpd php-fpm\\r\\n)\\r\\nSERVICE_STATUS_JSON=\\"\\"\\r\\nfor svc in \\"${SERVICES[@]}\\"; do\\r\\n  if systemctl list-units --type=service --all | grep -q \\"$svc\\"; then\\r\\n    ACTIVE=$(systemctl is-active \\"$svc\\" 2>/dev/null)\\r\\n    ENABLED=$(systemctl is-enabled \\"$svc\\" 2>/dev/null)\\r\\n    SERVICE_STATUS_JSON+=\\"{\\\\\\"name\\\\\\":\\\\\\"$svc\\\\\\",\\\\\\"active\\\\\\":\\\\\\"$ACTIVE\\\\\\",\\\\\\"enabled\\\\\\":\\\\\\"$ENABLED\\\\\\"},\\"\\r\\n  fi\\r\\ndone\\r\\nSERVICE_STATUS_JSON=\\"[${SERVICE_STATUS_JSON%,}]\\"\\r\\n\\r\\ncat <<JSON > \\"$MONITOR_DIR/services_status.json\\"\\r\\n{\\r\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\r\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\r\\n  \\"services\\": ${SERVICE_STATUS_JSON}\\r\\n}\\r\\nJSON\\r\\nEOS\\r\\nchmod +x \\"$SERVICES_SCRIPT_PATH\\"\\r\\n\\r\\n# --- important logs script ---\\r\\ncat <<'EOS' > \\"$LOGS_SCRIPT_PATH\\"\\r\\n#!/bin/bash\\r\\nset -euo pipefail\\r\\nMONITOR_DIR=\\"/opt/monitoring\\"\\r\\n\\r\\nif [ -f /etc/instance-info.conf ]; then\\r\\n  source /etc/instance-info.conf\\r\\nfi\\r\\n\\r\\nTIMESTAMP=$(date -Iseconds)\\r\\nINSTANCE_ID=\\"${INSTANCE_ID:-undefined}\\"\\r\\nLOG_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null | sed 's/\\"/\\\\\\\\\\"/g')\\r\\nLOG_JSON=\\"\\"\\r\\nwhile IFS= read -r line; do\\r\\n  [ -z \\"$line\\" ] && continue\\r\\n  LOG_JSON+=\\"\\\\\\"$line\\\\\\",\\" \\r\\ndone <<< \\"$LOG_LINES\\"\\r\\nLOG_JSON=\\"[${LOG_JSON%,}]\\"\\r\\n\\r\\ncat <<JSON > \\"$MONITOR_DIR/logs_status.json\\"\\r\\n{\\r\\n  \\"timestamp\\": \\"${TIMESTAMP}\\",\\r\\n  \\"instance_id\\": \\"${INSTANCE_ID}\\",\\r\\n  \\"logs\\": ${LOG_JSON}\\r\\n}\\r\\nJSON\\r\\nEOS\\r\\nchmod +x \\"$LOGS_SCRIPT_PATH\\"\\r\\n\\r\\n# --- configure cron jobs ---\\r\\nSTATUS_CRON_EXPR=\\"${STATUS_CRON_EXPR:-*/1 * * * *}\\"\\r\\nSERVICES_CRON_EXPR=\\"${SERVICES_CRON_EXPR:-*/1 * * * *}\\"\\r\\nLOGS_CRON_EXPR=\\"${LOGS_CRON_EXPR:-*/1 * * * *}\\"\\r\\nMARK_STATUS=\\"# MONITORING_STATUS_CRON\\"\\r\\nMARK_SERVICES=\\"# MONITORING_SERVICES_CRON\\"\\r\\nMARK_LOGS=\\"# MONITORING_LOGS_CRON\\"\\r\\n\\r\\ncrontab_get() { crontab -u \\"$CRON_USER\\" -l 2>/dev/null || true; }\\r\\ncrontab_set() { crontab -u \\"$CRON_USER\\" -; }\\r\\nadd_cron_once() {\\r\\n  local expr=\\"$1\\" cmd=\\"$2\\" mark=\\"$3\\"\\r\\n  local current\\r\\n  current=\\"$(crontab_get)\\"\\r\\n  if ! echo \\"$current\\" | grep -Fq \\"$mark\\"; then\\r\\n    { echo \\"$current\\" | grep -Fv \\"$mark\\"; echo \\"$expr $cmd $mark\\"; } | crontab_set\\r\\n  fi\\r\\n}\\r\\n\\r\\nadd_cron_once \\"$STATUS_CRON_EXPR\\" \\"bash $STATUS_SCRIPT_PATH >$MONITOR_DIR/status.log 2>&1\\" \\"$MARK_STATUS\\"\\r\\nadd_cron_once \\"$SERVICES_CRON_EXPR\\" \\"bash $SERVICES_SCRIPT_PATH >$MONITOR_DIR/services_status.log 2>&1\\" \\"$MARK_SERVICES\\"\\r\\nadd_cron_once \\"$LOGS_CRON_EXPR\\" \\"bash $LOGS_SCRIPT_PATH >$MONITOR_DIR/logs_status.log 2>&1\\" \\"$MARK_LOGS\\"\\r\\n\\r\\n# run once immediately\\r\\nbash \\"$STATUS_SCRIPT_PATH\\" || true\\r\\nbash \\"$SERVICES_SCRIPT_PATH\\" || true\\r\\nbash \\"$LOGS_SCRIPT_PATH\\" || true\\r\\n\\r\\n# ensure cron service is enabled\\r\\nif command -v systemctl >/dev/null 2>&1; then\\r\\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\\r\\nfi\\r\\n\\r\\nexit 0","fields_schema":{"fields":[]}},"query":{}}	2025-08-14 12:55:37.507+01	\N	\N	\N
3801	1	update_template:29	{}	2025-08-14 12:55:37.639+01	\N	\N	\N
3802	1	POST /templates	{"body":{"name":"script_1755172556069.sh","service_type":"custom","category":"general","description":"","template_content":"#!/bin/bash\\n\\n# Nouveau script","fields_schema":{"fields":[]}},"query":{}}	2025-08-14 12:55:56.154+01	\N	\N	\N
3803	1	create_template:33	{}	2025-08-14 12:55:56.167+01	\N	\N	\N
3804	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:56:22.332+01	\N	\N	\N
3805	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:56:22.362+01	\N	\N	\N
3806	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:56:29.934+01	\N	\N	\N
3807	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 12:56:29.972+01	\N	\N	\N
3808	1	POST /auth/logout	{"body":{"refreshToken":null,"device_id":"11164007-2f46-4e44-95fb-eb2f81b7fa1b"},"query":{}}	2025-08-14 13:00:38.347+01	\N	\N	\N
3809	1	logout	{"user_id":1}	2025-08-14 13:00:38.36+01	\N	\N	\N
3810	\N	POST /auth/login	{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}	2025-08-14 13:01:31.873+01	\N	\N	\N
3811	1	login	{"user_id":1}	2025-08-14 13:01:32.092+01	\N	\N	\N
3812	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:01:32.45+01	\N	\N	\N
3813	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:01:32.571+01	\N	\N	\N
3814	1	GET /alerts	{"query":{}}	2025-08-14 13:01:46.656+01	\N	\N	\N
3815	1	GET /alerts	{"query":{}}	2025-08-14 13:01:46.691+01	\N	\N	\N
3816	1	GET /dashboard	{"query":{}}	2025-08-14 13:19:37.157+01	\N	\N	\N
3817	1	GET /vms	{"query":{}}	2025-08-14 13:19:37.158+01	\N	\N	\N
3818	1	list_vms	{}	2025-08-14 13:19:37.204+01	\N	\N	\N
3819	1	GET /vms	{"query":{}}	2025-08-14 13:19:37.235+01	\N	\N	\N
3820	1	GET /dashboard	{"query":{}}	2025-08-14 13:19:37.292+01	\N	\N	\N
3821	1	list_vms	{}	2025-08-14 13:19:37.309+01	\N	\N	\N
3822	1	GET /dashboard	{"query":{}}	2025-08-14 13:22:07.391+01	\N	\N	\N
3823	1	GET /vms	{"query":{}}	2025-08-14 13:22:07.392+01	\N	\N	\N
3824	1	list_vms	{}	2025-08-14 13:22:07.446+01	\N	\N	\N
3825	1	GET /logs?sort=timestamp&order=desc&page=1&limit=10	{"query":{"sort":"timestamp","order":"desc","page":"1","limit":"10"}}	2025-08-14 13:22:38.971+01	\N	\N	\N
3826	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:36.908+01	\N	\N	\N
3827	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:36.94+01	\N	\N	\N
3828	1	DELETE /scripts/35	{"query":{}}	2025-08-14 13:27:38.543+01	\N	\N	\N
3829	1	delete_script:35	{}	2025-08-14 13:27:38.561+01	\N	\N	\N
3830	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:38.578+01	\N	\N	\N
3831	1	DELETE /scripts/37	{"query":{}}	2025-08-14 13:27:40.23+01	\N	\N	\N
3832	1	delete_script:37	{}	2025-08-14 13:27:40.245+01	\N	\N	\N
3833	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:40.27+01	\N	\N	\N
3834	1	DELETE /scripts/36	{"query":{}}	2025-08-14 13:27:41.955+01	\N	\N	\N
3835	1	delete_script:36	{}	2025-08-14 13:27:41.962+01	\N	\N	\N
3836	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:41.982+01	\N	\N	\N
3837	1	DELETE /templates/33	{"query":{}}	2025-08-14 13:27:44.578+01	\N	\N	\N
3838	1	delete_template:33	{}	2025-08-14 13:27:44.586+01	\N	\N	\N
3839	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:44.606+01	\N	\N	\N
3840	1	DELETE /templates/32	{"query":{}}	2025-08-14 13:27:45.725+01	\N	\N	\N
3841	1	delete_template:32	{}	2025-08-14 13:27:45.737+01	\N	\N	\N
3842	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:45.76+01	\N	\N	\N
3843	1	DELETE /templates/31	{"query":{}}	2025-08-14 13:27:46.845+01	\N	\N	\N
3844	1	delete_template:31	{}	2025-08-14 13:27:46.855+01	\N	\N	\N
3845	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:27:46.871+01	\N	\N	\N
3846	1	DELETE /templates/30	{"query":{}}	2025-08-14 13:27:47.961+01	\N	\N	\N
3847	1	delete_template:30	{}	2025-08-14 13:27:47.968+01	\N	\N	\N
3858	1	POST /templates	{"body":{"name":"Web Server Apache auto IP","service_type":"web_server_apache_autoip","category":"web","description":"Installe Apache et injecte automatiquement l’IP de la VM dans la page d’accueil.","template_content":"#!/bin/bash\\nset -euo pipefail\\n\\nDOMAIN_NAME=\\"${DOMAIN_NAME:-example.com}\\"\\nWEB_ROOT=\\"${WEB_ROOT:-/var/www/html}\\"\\nVM_NAME=\\"${VM_NAME:-vm1}\\"\\n\\n# Detect primary IP automatically\\nSERVER_IP=$(hostname -I | awk '{print $1}')\\n\\necho \\"🌐 Déploiement du serveur web Apache (${DOMAIN_NAME})\\"\\n\\n# Install packages\\nsudo apt update\\nsudo apt install -y apache2 curl\\n\\n# Prepare web directory\\nsudo mkdir -p \\"$WEB_ROOT\\"\\n\\nsudo tee \\"$WEB_ROOT/index.html\\" > /dev/null <<HTML\\n<!DOCTYPE html>\\n<html lang=\\"fr\\">\\n<head>\\n  <meta charset=\\"UTF-8\\" />\\n  <title>Camer-Web</title>\\n</head>\\n<body style=\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\">\\n  <h1>✅ Bienvenue sur Camer-Web</h1>\\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nHTML\\n\\n# Configure Apache virtual host\\nsudo tee /etc/apache2/sites-available/${DOMAIN_NAME}.conf > /dev/null <<APACHE\\n<VirtualHost *:80>\\n    ServerName ${DOMAIN_NAME}\\n    DocumentRoot ${WEB_ROOT}\\n    ErrorLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.error.log\\n    CustomLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.access.log combined\\n</VirtualHost>\\nAPACHE\\n\\nsudo a2ensite ${DOMAIN_NAME}.conf\\nsudo a2dissite 000-default.conf\\nsudo systemctl reload apache2\\nsudo systemctl enable apache2\\n\\n# Firewall\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\n# Record instance ID if provided\\n: \\"${INSTANCE_ID:?INSTANCE_ID is required}\\"\\necho \\"INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log\\n","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}},"query":{}}	2025-08-14 13:46:45.838+01	\N	\N	\N
3859	1	create_template:35	{}	2025-08-14 13:46:45.853+01	\N	\N	\N
3860	1	POST /templates/generate	{"body":{"template_id":35,"config_data":{"DOMAIN_NAME":"demo.example.com","WEB_ROOT":"/var/www/demo","VM_NAME":"vm-demo","INSTANCE_ID":"abc123"}},"query":{}}	2025-08-14 13:47:02.565+01	\N	\N	\N
3861	1	generate_template_file:35:web_server_apache_autoip_web_Web_Server_Apache_auto_IP_script002.sh	{}	2025-08-14 13:47:02.581+01	\N	\N	\N
3862	1	POST /templates	{"body":{"name":"Web Server NGINX auto IP","service_type":"web_server_nginx_autoip","category":"web","description":"Installe NGINX et injecte automatiquement l’IP de la VM dans la page d’accueil.","template_content":"#!/bin/bash\\nset -euo pipefail\\n\\nDOMAIN_NAME=\\"${DOMAIN_NAME:-example.com}\\"\\nWEB_ROOT=\\"${WEB_ROOT:-/var/www/html}\\"\\nVM_NAME=\\"${VM_NAME:-vm1}\\"\\n\\n# Detect primary IP automatically\\nSERVER_IP=$(hostname -I | awk '{print $1}')\\n\\necho \\"🌐 Déploiement du serveur web NGINX (${DOMAIN_NAME})\\"\\n\\n# Install packages\\nsudo apt update\\nsudo apt install -y nginx curl\\n\\n# Prepare web directory\\nsudo mkdir -p \\"$WEB_ROOT\\"\\n\\nsudo tee \\"$WEB_ROOT/index.html\\" > /dev/null <<HTML\\n<!DOCTYPE html>\\n<html lang=\\"fr\\">\\n<head>\\n  <meta charset=\\"UTF-8\\" />\\n  <title>Camer-Web</title>\\n</head>\\n<body style=\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\">\\n  <h1>✅ Bienvenue sur Camer-Web</h1>\\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\\n</body>\\n</html>\\nHTML\\n\\n# Configure nginx vhost\\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<NGINX\\nserver {\\n    listen 80;\\n    server_name ${DOMAIN_NAME};\\n    root ${WEB_ROOT};\\n    index index.html;\\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\\n    location / {\\n        try_files \\\\$uri \\\\$uri/ =404;\\n    }\\n}\\nNGINX\\n\\nsudo ln -sf /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/${DOMAIN_NAME}\\nsudo rm -f /etc/nginx/sites-enabled/default\\n\\nsudo systemctl restart nginx\\nsudo systemctl enable nginx\\n\\n# Firewall\\nsudo ufw allow OpenSSH\\nsudo ufw allow 80/tcp\\nsudo ufw allow 443/tcp\\nsudo ufw --force enable\\n\\n# Record instance ID if provided\\n: \\"${INSTANCE_ID:?INSTANCE_ID is required}\\"\\necho \\"INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/instance-info.conf > /dev/null\\necho \\"export INSTANCE_ID=${INSTANCE_ID}\\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\\nsudo chmod +x /etc/profile.d/instance_id.sh\\n\\n# Log initialization\\necho \\"$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}\\" | sudo tee -a /var/log/init.log\\n","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}},"query":{}}	2025-08-14 13:49:16.069+01	\N	\N	\N
3863	1	create_template:36	{}	2025-08-14 13:49:16.082+01	\N	\N	\N
3864	1	POST /templates/generate	{"body":{"template_id":36,"config_data":{"DOMAIN_NAME":"demo.example.com","WEB_ROOT":"/var/www/demo","VM_NAME":"vm-demo","INSTANCE_ID":"abc123"}},"query":{}}	2025-08-14 13:49:47.516+01	\N	\N	\N
3865	1	generate_template_file:36:web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_script002.sh	{}	2025-08-14 13:49:47.534+01	\N	\N	\N
3866	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:50:28.742+01	\N	\N	\N
3867	1	GET /templates?status=actif	{"query":{"status":"actif"}}	2025-08-14 13:50:28.77+01	\N	\N	\N
3868	1	GET /dashboard	{"query":{}}	2025-08-14 13:50:38.345+01	\N	\N	\N
3869	1	GET /vms	{"query":{}}	2025-08-14 13:50:38.346+01	\N	\N	\N
3870	1	list_vms	{}	2025-08-14 13:50:38.375+01	\N	\N	\N
3871	1	GET /vms	{"query":{}}	2025-08-14 13:50:38.396+01	\N	\N	\N
3872	1	GET /dashboard	{"query":{}}	2025-08-14 13:50:38.418+01	\N	\N	\N
3873	1	list_vms	{}	2025-08-14 13:50:38.429+01	\N	\N	\N
3874	1	GET /vms	{"query":{}}	2025-08-14 13:50:50.447+01	\N	\N	\N
3875	1	list_vms	{}	2025-08-14 13:50:50.518+01	\N	\N	\N
3876	1	GET /vms	{"query":{}}	2025-08-14 13:50:50.536+01	\N	\N	\N
3877	1	list_vms	{}	2025-08-14 13:50:50.555+01	\N	\N	\N
3878	1	Déploiement Terraform	{"vm_name":"ngnix","service_type":"web_server_nginx_autoip","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-43be83b9-c408-4dc7-b538-ca23dd4908cf.log"}	2025-08-14 13:58:40.821+01	\N	\N	\N
3879	1	GET /vms	{"query":{}}	2025-08-14 13:59:17.362+01	\N	\N	\N
3880	1	list_vms	{}	2025-08-14 13:59:17.424+01	\N	\N	\N
3881	1	GET /vms	{"query":{}}	2025-08-14 13:59:17.443+01	\N	\N	\N
3882	1	list_vms	{}	2025-08-14 13:59:17.464+01	\N	\N	\N
3883	1	GET /vms	{"query":{}}	2025-08-14 13:59:26.075+01	\N	\N	\N
3884	1	list_vms	{}	2025-08-14 13:59:26.154+01	\N	\N	\N
3885	1	GET /vms	{"query":{}}	2025-08-14 13:59:26.198+01	\N	\N	\N
3886	1	list_vms	{}	2025-08-14 13:59:26.223+01	\N	\N	\N
3887	1	Déploiement Terraform	{"vm_name":"xertfyh","service_type":"web_server_apache_autoip","success":true,"log_path":"D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-back\\\\backend\\\\logs\\\\deploy-21a2a595-3add-401a-bc2a-4be46546b56b.log"}	2025-08-14 14:03:12.445+01	\N	\N	\N
\.


--
-- Data for Name: monitorings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monitorings (id, vm_ip, ip_address, instance_id, services_status, system_status, retrieved_at, created_at, updated_at, logs_status) FROM stdin;
8	192.168.24.130	192.168.24.130	c06d59eb-a650-4427-ba92-05b107a6fd81	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}	2025-08-11 10:18:06.38+01	2025-08-11 10:18:06.38+01	2025-08-11 10:18:06.38+01	\N
2	192.168.24.91	192.168.24.91	b10d3830-d27e-4cee-8166-4d36c27f8166	{"sshd":"active","ufw":"active","fail2ban":"inactive\\nabsent","cron":"active","crond":"inactive\\nabsent","nginx":"inactive\\nabsent","apache2":"inactive\\nabsent","mysql":"inactive\\nabsent","mariadb":"inactive\\nabsent","postgresql":"inactive\\nabsent","docker":"inactive\\nabsent","kubelet":"inactive\\nabsent","redis-server":"inactive\\nabsent","mongod":"inactive\\nabsent","vsftpd":"inactive\\nabsent","proftpd":"inactive\\nabsent","php-fpm":"inactive\\nabsent","timestamp":"2025-08-06T10:22:58+00:00","instance_id":"b10d3830-d27e-4cee-8166-4d36c27f8166"}	{"timestamp":"2025-08-06T10:22:58+00:00","instance_id":"b10d3830-d27e-4cee-8166-4d36c27f8166","hostname":"test","ip_address":"192.168.24.91","load_average":"1.17, 0.26, 0.09","memory":{"total_kb":2010676,"available_kb":1654228},"disk":{"total_bytes":10464022528,"used_bytes":5181259776,"available_bytes":4729114624},"network":{"interface":"eth0","rx_bytes":362655,"tx_bytes":43765},"open_ports":[22,53,68],"top_processes":[]}	2025-08-06 11:29:25.757+01	2025-08-06 11:29:25.758+01	2025-08-06 11:29:25.758+01	\N
3	192.168.24.94	192.168.24.94	505bb44b-f327-47f7-a2d2-5fb231456c2f	{"timestamp":"2025-08-06T11:20:01+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-06T11:20:01+00:00","instance_id":"undefined","hostname":"test1","ip_address":"192.168.24.94","load_average":"0.58 0.20 0.07","memory":{"total_kb":2010676,"available_kb":1670152},"disk":{"total_bytes":10464022528,"used_bytes":5183983616,"available_bytes":4726390784},"network":{"interface":"eth0","rx_bytes":2895596,"tx_bytes":118169},"open_ports":[22,53,68],"top_processes":[{"pid":1,"cmd":"systemd","cpu":5.5},{"pid":752,"cmd":"snapd","cpu":5.1},{"pid":1303,"cmd":"systemd","cpu":2.7},{"pid":9,"cmd":"kworker/u4:0-ev","cpu":1.7},{"pid":427,"cmd":"systemd-journal","cpu":0.9}]}	2025-08-06 12:22:47.44+01	2025-08-06 12:22:47.442+01	2025-08-06 12:22:47.442+01	\N
4	192.168.24.202	192.168.24.202	505bb44b-f327-47f7-a2d2-5fb231456c2f	{"timestamp":"2025-08-07T03:55:30+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"},{"name":"nginx","active":"active","enabled":"enabled"},{"name":"apache2","active":"failed","enabled":"enabled"}]}	{"timestamp":"2025-08-07T03:55:15+00:00","instance_id":"undefined","hostname":"Webapache","ip_address":"192.168.24.202","load_average":"0.01 0.02 0.00","memory":{"total_kb":2010676,"available_kb":1590624},"disk":{"total_bytes":10464022528,"used_bytes":6119256064,"available_bytes":3791118336},"network":{"interface":"eth0","rx_bytes":347193895,"tx_bytes":4059300},"open_ports":[22,53,68,80],"top_processes":[{"pid":747,"cmd":"qemu-ga","cpu":0.1},{"pid":19095,"cmd":"kworker/0:2-eve","cpu":0.1},{"pid":19251,"cmd":"kworker/1:2-eve","cpu":0.1},{"pid":1,"cmd":"systemd","cpu":0},{"pid":2,"cmd":"kthreadd","cpu":0}]}	2025-08-07 04:55:39.75+01	2025-08-07 04:55:39.751+01	2025-08-07 04:55:39.751+01	\N
5	192.168.24.130	192.168.24.130	c06d59eb-a650-4427-ba92-05b107a6fd81	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}	2025-08-10 22:01:33.247+01	2025-08-10 22:01:33.249+01	2025-08-10 22:01:33.249+01	\N
6	192.168.24.130	192.168.24.130	c06d59eb-a650-4427-ba92-05b107a6fd81	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}	2025-08-10 22:06:07.022+01	2025-08-10 22:06:07.022+01	2025-08-10 22:06:07.022+01	\N
7	192.168.24.130	192.168.24.130	c06d59eb-a650-4427-ba92-05b107a6fd81	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}	2025-08-10 22:36:20.124+01	2025-08-10 22:36:20.126+01	2025-08-10 22:36:20.126+01	\N
9	192.168.24.211	192.168.24.211	\N	{"timestamp":"2025-08-13T06:42:57+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-13T06:42:57+00:00","instance_id":"undefined","hostname":"dsfgdggd","ip_address":"192.168.24.211","load_average":"0.09 0.12 0.07","memory":{"total_kb":2010676,"available_kb":1653392},"disk":{"total_bytes":10464022528,"used_bytes":5181317120,"available_bytes":4729057280},"network":{"interface":"eth0","rx_bytes":977939,"tx_bytes":110041},"open_ports":[22,53,68,48904],"top_processes":[{"pid":752,"cmd":"snapd","cpu":2.2},{"pid":1,"cmd":"systemd","cpu":1.1},{"pid":352,"cmd":"jbd2/dm-0-8","cpu":0.1},{"pid":427,"cmd":"systemd-journal","cpu":0.1},{"pid":738,"cmd":"dbus-daemon","cpu":0.1}]}	2025-08-13 07:43:07.129+01	2025-08-13 07:43:07.13+01	2025-08-13 07:43:07.13+01	\N
10	192.168.24.211	192.168.24.211	\N	{"timestamp":"2025-08-13T06:42:57+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-13T06:42:57+00:00","instance_id":"undefined","hostname":"dsfgdggd","ip_address":"192.168.24.211","load_average":"0.09 0.12 0.07","memory":{"total_kb":2010676,"available_kb":1653392},"disk":{"total_bytes":10464022528,"used_bytes":5181317120,"available_bytes":4729057280},"network":{"interface":"eth0","rx_bytes":977939,"tx_bytes":110041},"open_ports":[22,53,68,48904],"top_processes":[{"pid":752,"cmd":"snapd","cpu":2.2},{"pid":1,"cmd":"systemd","cpu":1.1},{"pid":352,"cmd":"jbd2/dm-0-8","cpu":0.1},{"pid":427,"cmd":"systemd-journal","cpu":0.1},{"pid":738,"cmd":"dbus-daemon","cpu":0.1}]}	2025-08-13 07:46:24.562+01	2025-08-13 07:46:24.562+01	2025-08-13 07:46:24.562+01	\N
11	192.168.24.213	192.168.24.213	\N	{"timestamp":"2025-08-13T16:00:52+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-13T16:00:52+00:00","instance_id":"undefined","hostname":"testweb","ip_address":"192.168.24.213","load_average":"0.03 0.11 0.07","memory":{"total_kb":2010676,"available_kb":1662780},"disk":{"total_bytes":10464022528,"used_bytes":5404258304,"available_bytes":4506116096},"network":{"interface":"eth0","rx_bytes":59281,"tx_bytes":16782},"open_ports":[22,53,68],"top_processes":[{"pid":1,"cmd":"systemd","cpu":1.2},{"pid":726,"cmd":"snapd","cpu":1.2},{"pid":427,"cmd":"systemd-journal","cpu":0.1},{"pid":722,"cmd":"qemu-ga","cpu":0.1},{"pid":2,"cmd":"kthreadd","cpu":0}]}	2025-08-13 17:03:45.34+01	2025-08-13 17:03:45.341+01	2025-08-13 17:03:45.341+01	\N
12	192.168.24.214	192.168.24.214	\N	{"timestamp":"2025-08-13T16:14:01+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-13T16:14:01+00:00","instance_id":"undefined","hostname":"testwebserver","ip_address":"192.168.24.214","load_average":"0.31 0.25 0.09","memory":{"total_kb":2010676,"available_kb":1634908},"disk":{"total_bytes":10464022528,"used_bytes":5302833152,"available_bytes":4607541248},"network":{"interface":"eth0","rx_bytes":81569683,"tx_bytes":338677},"open_ports":[22,53,68,46871],"top_processes":[{"pid":1562,"cmd":"snapd","cpu":8.4},{"pid":1,"cmd":"systemd","cpu":3.9},{"pid":89,"cmd":"kworker/u4:1-ev","cpu":0.8},{"pid":427,"cmd":"systemd-journal","cpu":0.4},{"pid":468,"cmd":"systemd-udevd","cpu":0.3}]}	2025-08-13 17:14:23.153+01	2025-08-13 17:14:23.153+01	2025-08-13 17:14:23.153+01	\N
13	192.168.24.213	192.168.24.213	\N	{"timestamp":"2025-08-13T16:00:52+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-13T16:00:52+00:00","instance_id":"undefined","hostname":"testweb","ip_address":"192.168.24.213","load_average":"0.03 0.11 0.07","memory":{"total_kb":2010676,"available_kb":1662780},"disk":{"total_bytes":10464022528,"used_bytes":5404258304,"available_bytes":4506116096},"network":{"interface":"eth0","rx_bytes":59281,"tx_bytes":16782},"open_ports":[22,53,68],"top_processes":[{"pid":1,"cmd":"systemd","cpu":1.2},{"pid":726,"cmd":"snapd","cpu":1.2},{"pid":427,"cmd":"systemd-journal","cpu":0.1},{"pid":722,"cmd":"qemu-ga","cpu":0.1},{"pid":2,"cmd":"kthreadd","cpu":0}]}	2025-08-14 02:00:12.993+01	2025-08-14 02:00:12.993+01	2025-08-14 02:00:12.993+01	\N
14	192.168.24.213	192.168.24.213	\N	{"timestamp":"2025-08-14T03:21:01+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-14T03:21:02+00:00","instance_id":"undefined","hostname":"testweb","ip_address":"192.168.24.213","load_average":"0.02 0.05 0.01","memory":{"total_kb":2010676,"available_kb":1673776},"disk":{"total_bytes":10464022528,"used_bytes":5487300608,"available_bytes":4423073792},"network":{"interface":"eth0","rx_bytes":2122066,"tx_bytes":45948},"open_ports":[22,53,68],"top_processes":[{"pid":1,"cmd":"systemd","cpu":0.1},{"pid":750,"cmd":"qemu-ga","cpu":0.1},{"pid":2,"cmd":"kthreadd","cpu":0},{"pid":3,"cmd":"rcu_gp","cpu":0},{"pid":4,"cmd":"rcu_par_gp","cpu":0}]}	2025-08-14 04:21:41.181+01	2025-08-14 04:21:41.182+01	2025-08-14 04:21:41.182+01	\N
15	192.168.24.215	192.168.24.215	${INSTANCE_ID}	{"timestamp":"2025-08-14T11:42:01+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"},{"name":"nginx","active":"failed","enabled":"enabled"},{"name":"apache2","active":"active","enabled":"enabled"}]}	{"timestamp":"2025-08-14T11:42:01+00:00","instance_id":"undefined","hostname":"testweb-ngnix","ip_address":"192.168.24.215","load_average":"0.00 0.00 0.00","memory":{"total_kb":2010668,"available_kb":1662704},"disk":{"total_bytes":10464022528,"used_bytes":6131200000,"available_bytes":3779174400},"network":{"interface":"eth0","rx_bytes":543108,"tx_bytes":4973},"open_ports":[22,53,68,80],"top_processes":[{"pid":1,"cmd":"systemd","cpu":0.1},{"pid":808,"cmd":"qemu-ga","cpu":0.1},{"pid":2,"cmd":"kthreadd","cpu":0},{"pid":3,"cmd":"rcu_gp","cpu":0},{"pid":4,"cmd":"rcu_par_gp","cpu":0}]}	2025-08-14 12:42:38.444+01	2025-08-14 12:42:38.444+01	2025-08-14 12:42:38.444+01	\N
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, key, description, status, created_at, updated_at, name) FROM stdin;
68	script.update	script.update	actif	2025-08-13 17:56:32.082+01	2025-08-13 17:56:32.082+01	script.update
70	script.delete	script.delete	actif	2025-08-14 03:49:03.87+01	2025-08-14 03:49:03.87+01	script.delete
1	auth.reset-history	View password reset history	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	auth.reset-history
2	deployment.run	Run deployments	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	deployment.run
3	log.list	List logs	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	log.list
4	permission.assign	Assign permission to roles	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.assign
5	permission.byRole	List permissions by role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.byRole
6	permission.create	Create permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.create
7	permission.delete	Delete permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.delete
8	permission.list	List permissions	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.list
9	permission.read	Read permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.read
10	permission.unassign	Unassign permission from role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.unassign
11	permission.update	Update permission	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	permission.update
12	role.create	Create role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	role.create
13	role.delete	Delete role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	role.delete
14	role.list	List roles	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	role.list
15	role.read	Read role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	role.read
16	role.update	Update role	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	role.update
17	settings.create	Create settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	settings.create
18	settings.get	Get settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	settings.get
19	settings.list	List settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	settings.list
20	settings.update	Update settings	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	settings.update
21	template.create	Create template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	template.create
22	template.delete	Delete template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	template.delete
23	template.generate	Generate template script	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	template.generate
24	template.list	List templates	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	template.list
25	template.read	Read template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	template.read
26	template.update	Update template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	template.update
27	user.create	Create user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	user.create
28	user.delete	Delete user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	user.delete
29	user.list	List users	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	user.list
30	user.read	Read user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	user.read
31	user.search	Search users	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	user.search
32	user.update	Update user	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	user.update
33	monitoring.collect	Collect monitoring data	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	monitoring.collect
34	monitoring.list	List monitoring records	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	monitoring.list
35	monitoring.read	Read monitoring record	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	monitoring.read
36	monitoring.sync	Synchronize deployment IP	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	monitoring.sync
37	vm.conversion.list	List VM conversions	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	vm.conversion.list
38	vm.convert	Convert VM to template	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	vm.convert
39	vm.list	List VMs	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	vm.list
40	vm.start	Start VM	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	vm.start
41	vm.status.check	Check VM status	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	vm.status.check
42	vm.stop	Stop VM	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	vm.stop
43	vm.delete	Delete VM	actif	2025-08-06 04:39:32.311509+01	2025-08-06 04:39:32.311509+01	vm.delete
44	test	test posts	inactif	2025-08-06 04:45:33.679+01	2025-08-06 04:47:55.721+01	test
45	script.analyze	Analyser un script avec l’IA	actif	2025-08-06 15:31:31.112+01	2025-08-06 15:31:31.112+01	script.analyze
46	script.read	Lire les analyses de script IA	actif	2025-08-06 15:32:09.156+01	2025-08-06 15:32:09.156+01	script.read
47	template.analyze	Analyse du template	actif	2025-08-06 15:37:58.485+01	2025-08-06 15:37:58.485+01	template.analyze
48	template.audit	Auditer un script avec IA avant déploiement	actif	2025-08-06 17:05:38.346+01	2025-08-06 17:13:34.219+01	template.audit
49	template.explain	Explain script using AI	actif	2025-08-06 17:49:12.831+01	2025-08-06 17:49:12.831+01	template.explain
50	template.explainVariables	Explain template variables using AI	actif	2025-08-06 17:49:12.84+01	2025-08-06 17:49:12.84+01	template.explainVariables
51	template.summarizeLogs	Summarize deployment logs using AI	actif	2025-08-06 17:49:12.844+01	2025-08-06 17:49:12.844+01	template.summarizeLogs
52	template.suggestBundle	Suggest stack bundles using AI	actif	2025-08-06 17:49:12.848+01	2025-08-06 17:49:12.848+01	template.suggestBundle
53	template.simulateExecution	Simulate script execution using AI	actif	2025-08-06 17:49:12.851+01	2025-08-06 17:49:12.851+01	template.simulateExecution
54	aiCache.list	Liste des requete deja recu	actif	2025-08-07 04:59:05.047+01	2025-08-07 04:59:05.047+01	aiCache.list
55	dashboard.view	View dashboard data	actif	2025-08-07 07:02:52.51+01	2025-08-07 07:02:52.51+01	dashboard.view
56	alert.list	List alerts	actif	2025-08-07 07:02:52.515+01	2025-08-07 07:02:52.515+01	alert.list
57	alert.update	Update alert	actif	2025-08-07 07:02:52.519+01	2025-08-07 07:02:52.519+01	alert.update
58	servers.view	View servers	actif	2025-08-07 07:02:52.522+01	2025-08-07 07:02:52.522+01	servers.view
59	servers.add	Add server	actif	2025-08-07 07:02:52.525+01	2025-08-07 07:02:52.525+01	servers.add
60	servers.edit	Edit server	actif	2025-08-07 07:02:52.529+01	2025-08-07 07:02:52.529+01	servers.edit
61	servers.delete	Delete server	actif	2025-08-07 07:02:52.533+01	2025-08-07 07:02:52.533+01	servers.delete
62	test.analyse	testdanalyse	actif	2025-08-09 18:59:15.74+01	2025-08-09 18:59:15.74+01	test.analyse
63	script.servicetypes	Script type	actif	2025-08-12 12:54:10.55+01	2025-08-12 12:54:10.55+01	script.servicetypes
64	script.list	script.list	actif	2025-08-12 12:56:36.341+01	2025-08-12 12:56:36.341+01	script.list
65	template.restore	template.restore	actif	2025-08-12 13:15:51.899+01	2025-08-12 13:15:51.899+01	template.restore
66	test.permissionmodule	dhdh	actif	2025-08-13 08:02:48.412+01	2025-08-13 08:02:48.412+01	test.permissionmodule
67	testbe.dkjhd	jdhudj	actif	2025-08-13 08:03:07.904+01	2025-08-13 08:03:07.904+01	testbe.dkjhd
69	chatbot.use	chatbot.use	actif	2025-08-14 03:26:05.337+01	2025-08-14 03:26:05.337+01	chatbot.use
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (jti, user_id, device_id, revoked, expires_at) FROM stdin;
7b1d7245-72c4-400a-a5f7-2b3cb8486e76	1	d9acbbe4-b48c-48eb-a534-fcc5e782ce2c	t	2025-08-20 13:09:54+01
75b27d1b-b88e-4ee9-8506-c4f905c419c7	1	d9acbbe4-b48c-48eb-a534-fcc5e782ce2c	f	2025-08-20 15:11:26+01
7f5147dc-64f1-48cb-b3ac-ab02ce51e830	1	d9acbbe4-b48c-48eb-a534-fcc5e782ce2c	f	2025-08-21 01:56:09+01
d69c9c4e-6637-4636-a659-1ac3a239c892	1	d9acbbe4-b48c-48eb-a534-fcc5e782ce2c	f	2025-08-21 02:32:32+01
0249b02f-583b-4a37-a053-3de72a8e447a	1	d9acbbe4-b48c-48eb-a534-fcc5e782ce2c	f	2025-08-21 02:36:20+01
19e2c7f2-eb01-4fa2-b606-41cd17ebe816	1	11164007-2f46-4e44-95fb-eb2f81b7fa1b	f	2025-08-21 04:39:23+01
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, status, created_at, updated_at, description) FROM stdin;
1	superadmin	actif	2025-08-06 04:39:32.272046+01	2025-08-07 04:03:15.738+01	
2	admin	actif	2025-08-07 04:03:15.448+01	2025-08-07 04:48:21.141+01	
3	gdgdhd	actif	2025-08-09 17:36:35.914+01	2025-08-09 17:52:11.845+01	
\.


--
-- Data for Name: service_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_templates (id, name, service_type, category, description, template_content, script_path, fields_schema, status, created_at, updated_at, abs_path, deleted_at) FROM stdin;
25	Cron des scripts de monitoring	monitoring__cron	monitoring	Installe un cron job minuteur qui attend la présence des scripts de monitoring, les exécute, crée leurs crons définitifs puis se désinstalle.	#!/bin/bash\nset -euo pipefail\n\n# === Variables substituées par le moteur de template ===\nSCRIPT_PATH="${SCRIPT_PATH}"\nSTATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH}"\nSERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH}"\nSTATUS_CRON_EXPR='${STATUS_CRON_EXPR}'\nSERVICES_CRON_EXPR='${SERVICES_CRON_EXPR}'\nCRON_USER='${CRON_USER}'\n\nMONITOR_DIR="$(dirname "${STATUS_SCRIPT_PATH}")"\nMARK_BOOT="# MONITORING_CRON"\nMARK_STATUS="# MONITORING_STATUS_CRON"\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\n\nmkdir -p "${MONITOR_DIR}"\n\n# --- Génère le script  ---\ncat > "${SCRIPT_PATH}" <<'EOS'\n#!/bin/bash\nset -euo pipefail\n\nSTATUS_SCRIPT_PATH="__STATUS_SCRIPT_PATH__"\nSERVICES_SCRIPT_PATH="__SERVICES_SCRIPT_PATH__"\nSTATUS_CRON_EXPR='__STATUS_CRON_EXPR__'\nSERVICES_CRON_EXPR='__SERVICES_CRON_EXPR__'\nCRON_USER='__CRON_USER__'\nMARK_BOOT="# MONITORING_CRON"\nMARK_STATUS="# MONITORING_STATUS_CRON"\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\n\nexists_and_exec() {\n  local f="$1"\n  [[ -f "$f" ]] || return 1\n  [[ -x "$f" ]] || chmod +x "$f" || true\n  return 0\n}\n\ncrontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }\ncrontab_set() { crontab -u "$CRON_USER" -; }\n\nadd_cron_once() {\n  local expr="$1" cmd="$2" mark="$3"\n  local current\n  current="$(crontab_get)"\n  if ! echo "$current" | grep -Fq "$mark"; then\n    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set\n  fi\n}\n\nremove_mark() {\n  local mark="$1"\n  crontab_get | grep -Fv "$mark" | crontab_set\n}\n\nok=1\nif exists_and_exec "$STATUS_SCRIPT_PATH"; then\n  add_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1" "$MARK_STATUS"\nelse\n  ok=0\nfi\n\nif exists_and_exec "$SERVICES_SCRIPT_PATH"; then\n  add_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1" "$MARK_SERVICES"\nelse\n  ok=0\nfi\n\nif [[ "$ok" -eq 1 ]]; then\n  # Exécuter une première fois pour générer les JSON immédiatement\n  bash "$STATUS_SCRIPT_PATH" || true\n  bash "$SERVICES_SCRIPT_PATH" || true\n  # Se retirer du crontab\n  remove_mark "$MARK_BOOT"\nfi\nEOS\n\n# Injecte les variables réelles dans le \nsed -i \\\n  -e "s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\//\\\\/}#g" \\\n  -e "s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\//\\\\/}#g" \\\n  -e "s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\//\\\\/}#g" \\\n  -e "s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\//\\\\/}#g" \\\n  -e "s#__CRON_USER__#${CRON_USER}#g" \\\n  "${SCRIPT_PATH}"\n\nchmod +x "${SCRIPT_PATH}"\n\n# --- (Ré)active le service cron/ crond ---\nif command -v systemctl >/dev/null 2>&1; then\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\nfi\n\n# --- Installe le cron  (toutes les minutes) ---\ncurrent_cron="$(crontab -u "${CRON_USER}" -l 2>/dev/null || true)"\nif ! echo "$current_cron" | grep -Fq "$MARK_BOOT"; then\n  { echo "$current_cron" | grep -Fv "$MARK_BOOT"; echo "* * * * * ${SCRIPT_PATH} $MARK_BOOT"; } | crontab -u "${CRON_USER}" -\nfi\n\nexit 0\n	/scripts/templates/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_tpl001.sh	{"fields":[{"name":"SCRIPT_PATH","label":"Chemin du script ","type":"text","required":true,"default":"/opt/monitoring/monitoring.sh"},{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_EXPR","label":"Cron du script status","type":"text","required":true,"default":"*/1 * * * *"},{"name":"SERVICES_CRON_EXPR","label":"Cron du script services","type":"text","required":true,"default":"*/1 * * * *"},{"name":"CRON_USER","label":"Utilisateur cron","type":"text","required":true,"default":"root"}]}	supprime	2025-08-12 05:36:17.479+01	2025-08-14 12:26:26.733+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\monitoring\\monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_tpl001.sh	\N
27	Surveillance des services - Génération du script	service_monitoring_script	monitoring		#!/bin/bash\r\n\r\n# 📁 Créer le dossier de monitoring s’il n’existe pas\r\nmkdir -p /opt/monitoring\r\n\r\n# 📦 Créer le script de surveillance des services\r\ncat <<'EOS' > ${SERVICES_SCRIPT_PATH}\r\n#!/bin/bash\r\n\r\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\r\nif [ -f /etc/instance-info.conf ]; then\r\n  source /etc/instance-info.conf\r\nfi\r\n\r\nTIMESTAMP=$(date -Iseconds)\r\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\r\n\r\nSERVICES=(\r\n  sshd ufw fail2ban cron crond nginx apache2 mysql\r\n  mariadb postgresql docker kubelet redis-server\r\n  mongod vsftpd proftpd php-fpm\r\n)\r\n\r\nSERVICE_STATUS_JSON=""\r\nfor svc in "${SERVICES[@]}"; do\r\n  if systemctl list-units --type=service --all | grep -q "$svc"; then\r\n    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)\r\n    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)\r\n    SERVICE_STATUS_JSON+="{\\"name\\":\\"$svc\\",\\"active\\":\\"$ACTIVE\\",\\"enabled\\":\\"$ENABLED\\"},"\r\n  fi\r\ndone\r\n\r\nSERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"\r\n\r\ncat <<JSON > ${SERVICES_JSON_PATH}\r\n{\r\n  "timestamp": "${TIMESTAMP}",\r\n  "instance_id": "${INSTANCE_ID}",\r\n  "services": ${SERVICE_STATUS_JSON}\r\n}\r\nJSON\r\nEOS\r\n\r\nchmod +x ${SERVICES_SCRIPT_PATH}	/scripts/templates/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_tpl002.sh	{"fields":[]}	supprime	2025-08-12 05:37:03.501+01	2025-08-14 12:26:21.166+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\monitoring\\service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_tpl002.sh	\N
26	Surveillance système - Génération du script	system_monitoring_script	monitoring	Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh	#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance système\ncat <<'EOS' > ${STATUS_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l'INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk '{print $1}')\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\n\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\n\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\n\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\n\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "{\\"pid\\":%s,\\"cmd\\":\\"%s\\",\\"cpu\\":%s},", $1, $2, $3}')\nTOP_PROCESSES="[${TOP_PROCESSES%,}]"\n\ncat <<JSON > ${STATUS_JSON_PATH}\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "hostname": "${HOSTNAME}",\n  "ip_address": "${IP_ADDR}",\n  "load_average": "${LOAD_AVG}",\n  "memory": {\n    "total_kb": ${MEM_TOTAL},\n    "available_kb": ${MEM_AVAILABLE}\n  },\n  "disk": {\n    "total_bytes": ${DISK_TOTAL},\n    "used_bytes": ${DISK_USED},\n    "available_bytes": ${DISK_AVAIL}\n  },\n  "network": {\n    "interface": "${IFACE}",\n    "rx_bytes": ${RX_BYTES},\n    "tx_bytes": ${TX_BYTES}\n  },\n  "open_ports": [${OPEN_PORTS}],\n  "top_processes": ${TOP_PROCESSES}\n}\nJSON\nEOS\n\nchmod +x ${STATUS_SCRIPT_PATH}	/scripts/templates/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_tpl002.sh	{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}	supprime	2025-08-12 05:36:50.551+01	2025-08-14 12:26:25.422+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\monitoring\\system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_tpl002.sh	\N
29	Monitoring setup	monitoring_setup	monitoring		#!/bin/bash\r\nset -euo pipefail\r\n\r\n# Ensure monitoring directory exists with correct permissions\r\nMONITOR_DIR="/opt/monitoring"\r\nCRON_USER="${CRON_USER:-nexus}"\r\nsudo mkdir -p "$MONITOR_DIR"\r\nsudo chown -R "$CRON_USER":"$CRON_USER" "$MONITOR_DIR"\r\nsudo chmod 775 "$MONITOR_DIR"\r\n\r\n# Paths\r\nSTATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH:-$MONITOR_DIR/status.sh}"\r\nSERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH:-$MONITOR_DIR/services_status.sh}"\r\nLOGS_SCRIPT_PATH="${LOGS_SCRIPT_PATH:-$MONITOR_DIR/logs.sh}"\r\n\r\n# --- system status script ---\r\ncat <<'EOS' > "$STATUS_SCRIPT_PATH"\r\n#!/bin/bash\r\nset -euo pipefail\r\nMONITOR_DIR="/opt/monitoring"\r\n\r\nif [ -f /etc/instance-info.conf ]; then\r\n  source /etc/instance-info.conf\r\nfi\r\n\r\nTIMESTAMP=$(date -Iseconds)\r\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\r\nHOSTNAME=$(hostname)\r\nIP_ADDR=$(hostname -I | awk '{print $1}')\r\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\r\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\r\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\r\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\r\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\r\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\r\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\r\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\r\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\r\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\r\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "{\\"pid\\":%s,\\"cmd\\":\\"%s\\",\\"cpu\\":%s}",",", $1, $2, $3}')\r\nTOP_PROCESSES="[${TOP_PROCESSES%,}]"\r\n\r\ncat <<JSON > "$MONITOR_DIR/status.json"\r\n{\r\n  "timestamp": "${TIMESTAMP}",\r\n  "instance_id": "${INSTANCE_ID}",\r\n  "hostname": "${HOSTNAME}",\r\n  "ip_address": "${IP_ADDR}",\r\n  "load_average": "${LOAD_AVG}",\r\n  "memory": {\r\n    "total_kb": ${MEM_TOTAL},\r\n    "available_kb": ${MEM_AVAILABLE}\r\n  },\r\n  "disk": {\r\n    "total_bytes": ${DISK_TOTAL},\r\n    "used_bytes": ${DISK_USED},\r\n    "available_bytes": ${DISK_AVAIL}\r\n  },\r\n  "network": {\r\n    "interface": "${IFACE}",\r\n    "rx_bytes": ${RX_BYTES},\r\n    "tx_bytes": ${TX_BYTES}\r\n  },\r\n  "open_ports": [${OPEN_PORTS}],\r\n  "top_processes": ${TOP_PROCESSES}\r\n}\r\nJSON\r\nEOS\r\nchmod +x "$STATUS_SCRIPT_PATH"\r\n\r\n# --- services status script ---\r\ncat <<'EOS' > "$SERVICES_SCRIPT_PATH"\r\n#!/bin/bash\r\nset -euo pipefail\r\nMONITOR_DIR="/opt/monitoring"\r\n\r\nif [ -f /etc/instance-info.conf ]; then\r\n  source /etc/instance-info.conf\r\nfi\r\n\r\nTIMESTAMP=$(date -Iseconds)\r\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\r\nSERVICES=(\r\n  sshd ufw fail2ban cron crond nginx apache2 mysql mariadb postgresql docker kubelet redis-server mongod vsftpd proftpd php-fpm\r\n)\r\nSERVICE_STATUS_JSON=""\r\nfor svc in "${SERVICES[@]}"; do\r\n  if systemctl list-units --type=service --all | grep -q "$svc"; then\r\n    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)\r\n    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)\r\n    SERVICE_STATUS_JSON+="{\\"name\\":\\"$svc\\",\\"active\\":\\"$ACTIVE\\",\\"enabled\\":\\"$ENABLED\\"},"\r\n  fi\r\ndone\r\nSERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"\r\n\r\ncat <<JSON > "$MONITOR_DIR/services_status.json"\r\n{\r\n  "timestamp": "${TIMESTAMP}",\r\n  "instance_id": "${INSTANCE_ID}",\r\n  "services": ${SERVICE_STATUS_JSON}\r\n}\r\nJSON\r\nEOS\r\nchmod +x "$SERVICES_SCRIPT_PATH"\r\n\r\n# --- important logs script ---\r\ncat <<'EOS' > "$LOGS_SCRIPT_PATH"\r\n#!/bin/bash\r\nset -euo pipefail\r\nMONITOR_DIR="/opt/monitoring"\r\n\r\nif [ -f /etc/instance-info.conf ]; then\r\n  source /etc/instance-info.conf\r\nfi\r\n\r\nTIMESTAMP=$(date -Iseconds)\r\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\r\nLOG_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null | sed 's/"/\\\\"/g')\r\nLOG_JSON=""\r\nwhile IFS= read -r line; do\r\n  [ -z "$line" ] && continue\r\n  LOG_JSON+="\\"$line\\"," \r\ndone <<< "$LOG_LINES"\r\nLOG_JSON="[${LOG_JSON%,}]"\r\n\r\ncat <<JSON > "$MONITOR_DIR/logs_status.json"\r\n{\r\n  "timestamp": "${TIMESTAMP}",\r\n  "instance_id": "${INSTANCE_ID}",\r\n  "logs": ${LOG_JSON}\r\n}\r\nJSON\r\nEOS\r\nchmod +x "$LOGS_SCRIPT_PATH"\r\n\r\n# --- configure cron jobs ---\r\nSTATUS_CRON_EXPR="${STATUS_CRON_EXPR:-*/1 * * * *}"\r\nSERVICES_CRON_EXPR="${SERVICES_CRON_EXPR:-*/1 * * * *}"\r\nLOGS_CRON_EXPR="${LOGS_CRON_EXPR:-*/1 * * * *}"\r\nMARK_STATUS="# MONITORING_STATUS_CRON"\r\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\r\nMARK_LOGS="# MONITORING_LOGS_CRON"\r\n\r\ncrontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }\r\ncrontab_set() { crontab -u "$CRON_USER" -; }\r\nadd_cron_once() {\r\n  local expr="$1" cmd="$2" mark="$3"\r\n  local current\r\n  current="$(crontab_get)"\r\n  if ! echo "$current" | grep -Fq "$mark"; then\r\n    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set\r\n  fi\r\n}\r\n\r\nadd_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >$MONITOR_DIR/status.log 2>&1" "$MARK_STATUS"\r\nadd_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >$MONITOR_DIR/services_status.log 2>&1" "$MARK_SERVICES"\r\nadd_cron_once "$LOGS_CRON_EXPR" "bash $LOGS_SCRIPT_PATH >$MONITOR_DIR/logs_status.log 2>&1" "$MARK_LOGS"\r\n\r\n# run once immediately\r\nbash "$STATUS_SCRIPT_PATH" || true\r\nbash "$SERVICES_SCRIPT_PATH" || true\r\nbash "$LOGS_SCRIPT_PATH" || true\r\n\r\n# ensure cron service is enabled\r\nif command -v systemctl >/dev/null 2>&1; then\r\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\r\nfi\r\n\r\nexit 0	/scripts/templates/monitoring/monitoring_setup_monitoring_Monitoring_setup_tpl001.sh	{"fields":[]}	supprime	2025-08-14 12:12:45.166+01	2025-08-14 13:27:49.798+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\monitoring\\monitoring_setup_monitoring_Monitoring_setup_tpl001.sh	\N
28	Serveur_Web	Web_Ngnix	web		#!/bin/bash\r\nset -e\r\n\r\necho "🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})..."\r\n\r\n# 1. J' Installation des paquets\r\necho "📦 Installation de nginx et apache2 (optionnel)..."\r\nsudo apt update\r\nsudo apt install curl -y\r\nsudo apt install nginx apache2 -y\r\n\r\n# 2. Préparation du répertoire web\r\necho "📁 Création du site web ${WEB_ROOT}"\r\nsudo mkdir -p ${WEB_ROOT}\r\n\r\necho "📝 Création de la page d’accueil personnalisée..."\r\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\r\n<!DOCTYPE html>\r\n<html lang=\\"fr\\">\r\n<head>\r\n    <meta charset=\\"UTF-8\\">\r\n    <title>Camer-Web</title>\r\n</head>\r\n<body style=\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\">\r\n    <h1>✅ Bienvenue sur Camer-Web</h1>\r\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\r\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\r\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\r\n</body>\r\n</html>\r\nEOF\r\n\r\n# 3. Création du fichier NGINX vhost\r\necho "🔧 Configuration NGINX pour ${DOMAIN_NAME}..."\r\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\r\nserver {\r\n    listen 80;\r\n    server_name ${DOMAIN_NAME};\r\n\r\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\r\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\r\n\r\n    root ${WEB_ROOT};\r\n    index index.html;\r\n\r\n    location / {\r\n        try_files \\$uri \\$uri/ =404;\r\n    }\r\n}\r\nEOF\r\n\r\n# 4. Activation du site et désactivation du défaut\r\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\r\nsudo rm -f /etc/nginx/sites-enabled/default\r\n\r\n# 5. Redémarrage des services\r\necho "🚀 Redémarrage de NGINX..."\r\nsudo systemctl restart nginx\r\nsudo systemctl enable nginx\r\n\r\n# 6. Pare-feu\r\necho "🛡️ Configuration UFW pour NGINX..."\r\nsudo ufw allow OpenSSH\r\nsudo ufw allow 80/tcp\r\nsudo ufw allow 443/tcp\r\nsudo ufw --force enable\r\n\r\necho\r\necho "✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne."\r\n\r\n: "\\${INSTANCE_ID:?INSTANCE_ID is required}"\r\n\r\n# Save instance identifier\r\necho "INSTANCE_ID=\\${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null\r\necho "export INSTANCE_ID=\\${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\r\nsudo chmod +x /etc/profile.d/instance_id.sh\r\nexport INSTANCE_ID=\\${INSTANCE_ID}\r\n\r\n# Log initialization\r\necho "$(date --iso-8601=seconds) - Initialized instance with ID: \\${INSTANCE_ID}" | sudo tee -a /var/log/init.log	/scripts/templates/web/Web_Ngnix_web_Serveur_Web_tpl001.sh	{"fields":[]}	supprime	2025-08-14 02:09:36.824+01	2025-08-14 12:26:18.344+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\web\\Web_Ngnix_web_Serveur_Web_tpl001.sh	\N
33	script_1755172556069.sh	custom	general		#!/bin/bash\n\n# Nouveau script	/scripts/templates/general/custom_general_script_1755172556069_sh_tpl001.sh	{"fields":[]}	supprime	2025-08-14 12:55:56.165+01	2025-08-14 13:27:44.584+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\general\\custom_general_script_1755172556069_sh_tpl001.sh	\N
32	API interne Node.js	node_api	api	Déploie une API Express et configure un service systemd.	#!/bin/bash\n\necho "🚀 Déploiement du serveur API Node.js - ${DOMAIN_NAME} (${IP_ADDRESS})"\nAPP_DIR="${APP_DIR}"\nPROXY_IP="${PROXY_IP}"\nAPI_USER="${API_USER}"\nSYSTEMD_SERVICE="${SYSTEMD_SERVICE}"\n\n# ✅ Ensure the API user exists\nif ! id -u "$API_USER" >/dev/null 2>&1; then\n  sudo useradd -m -s /bin/bash "$API_USER"\nfi\n\n# 1. Mise à jour système & installation de Node.js\necho "📦 Installation de Node.js et des dépendances..."\nsudo apt update && sudo apt install -y nodejs npm ufw curl\n\n# 2. Création du dossier de l'application\necho "📁 Création du dossier $APP_DIR..."\nsudo mkdir -p "$APP_DIR"\nsudo chown -R $API_USER:$API_USER "$APP_DIR"\n\n# 3. Création de l'application Express minimale\nsudo -u $API_USER tee "$APP_DIR/package.json" > /dev/null <<'PKG'\n{\n  "name": "camer-api",\n  "version": "1.0.0",\n  "main": "server.js",\n  "scripts": {\n    "start": "node server.js"\n  },\n  "dependencies": {\n    "express": "^4.18.2"\n  }\n}\nPKG\n\nsudo -u $API_USER npm --prefix "$APP_DIR" install\n\nsudo -u $API_USER tee "$APP_DIR/server.js" > /dev/null <<'JS'\nconst express = require('express');\nconst app = express();\napp.get('/', (req, res) => res.send('✅ Bienvenue sur l\\'API interne Camer!'));\nconst port = process.env.PORT || 3000;\napp.listen(port, () => console.log(`API listening on port ${port}`));\nJS\n\n# 4. Configuration du service systemd\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<'UNIT'\n[Unit]\nDescription=Service Node.js pour API (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nExecStart=/usr/bin/npm --prefix $APP_DIR start\nRestart=on-failure\nEnvironment=PORT=3000\n\n[Install]\nWantedBy=multi-user.target\nUNIT\n\n# 5. Démarrage du service\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 6. Sécurisation avec UFW\nsudo ufw allow from $PROXY_IP proto tcp to any port 3000 comment "Autorise accès proxy vers API"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 7. Test local\ncurl -s http://127.0.0.1:3000 || echo "⚠️ API non accessible localement, vérifier les logs."\n\necho "✅ Déploiement terminé. L’API Node.js écoute sur le port 3000 (LAN uniquement)."\n	/scripts/templates/api/node_api_api_API_interne_Node_js_tpl001.sh	{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"api.example.com"},{"name":"IP_ADDRESS","label":"Adresse IP","type":"text","required":true},{"name":"APP_DIR","label":"Dossier de l'application","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"IP du proxy autorisé","type":"text","required":true,"default":"192.168.0.10"},{"name":"API_USER","label":"Utilisateur API","type":"text","required":true,"default":"apiuser"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"node-api"}]}	supprime	2025-08-14 12:36:59.687+01	2025-08-14 13:27:45.735+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\api\\node_api_api_API_interne_Node_js_tpl001.sh	\N
30	Web Server NGINX auto IP	web_server_nginx_autoip	web	Installe NGINX et injecte automatiquement l’IP de la VM dans la page d’accueil.	#!/bin/bash\nset -euo pipefail\n\nDOMAIN_NAME="${DOMAIN_NAME:-example.com}"\nWEB_ROOT="${WEB_ROOT:-/var/www/html}"\nVM_NAME="${VM_NAME:-vm1}"\n\n# Detect primary IP automatically\nSERVER_IP=$(hostname -I | awk '{print $1}')\n\necho "🌐 Déploiement du serveur web NGINX (${DOMAIN_NAME})"\n\n# Install packages\nsudo apt update\nsudo apt install -y nginx curl\n\n# Prepare web directory\nsudo mkdir -p "$WEB_ROOT"\n\nsudo tee "$WEB_ROOT/index.html" > /dev/null <<HTML\n<!DOCTYPE html>\n<html lang="fr">\n<head>\n  <meta charset="UTF-8" />\n  <title>Camer-Web</title>\n</head>\n<body style="font-family: sans-serif; text-align: center; margin-top: 100px;">\n  <h1>✅ Bienvenue sur Camer-Web</h1>\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\n</body>\n</html>\nHTML\n\n# Configure nginx vhost\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<NGINX\nserver {\n    listen 80;\n    server_name ${DOMAIN_NAME};\n    root ${WEB_ROOT};\n    index index.html;\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\n    location / {\n        try_files \\$uri \\$uri/ =404;\n    }\n}\nNGINX\n\nsudo ln -sf /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/${DOMAIN_NAME}\nsudo rm -f /etc/nginx/sites-enabled/default\n\nsudo systemctl restart nginx\nsudo systemctl enable nginx\n\n# Firewall\nsudo ufw allow OpenSSH\nsudo ufw allow 80/tcp\nsudo ufw allow 443/tcp\nsudo ufw --force enable\n\n# Record instance ID if provided\n: "${INSTANCE_ID:?INSTANCE_ID is required}"\necho "INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null\necho "export INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\nsudo chmod +x /etc/profile.d/instance_id.sh\n\n# Log initialization\necho "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log\n	/scripts/templates/web/web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_tpl001.sh	{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}	supprime	2025-08-14 12:31:32.211+01	2025-08-14 13:27:47.966+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\web\\web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_tpl001.sh	\N
31	Web Server Apache auto IP	web_server_apache_autoip	web	Installe Apache et injecte automatiquement l’IP de la VM dans la page d’accueil.	#!/bin/bash\nset -euo pipefail\n\nDOMAIN_NAME="${DOMAIN_NAME:-example.com}"\nWEB_ROOT="${WEB_ROOT:-/var/www/html}"\nVM_NAME="${VM_NAME:-vm1}"\n\n# Detect primary IP automatically\nSERVER_IP=$(hostname -I | awk '{print $1}')\n\necho "🌐 Déploiement du serveur web Apache (${DOMAIN_NAME})"\n\n# Install packages\nsudo apt update\nsudo apt install -y apache2 curl\n\n# Prepare web directory\nsudo mkdir -p "$WEB_ROOT"\n\nsudo tee "$WEB_ROOT/index.html" > /dev/null <<HTML\n<!DOCTYPE html>\n<html lang="fr">\n<head>\n  <meta charset="UTF-8" />\n  <title>Camer-Web</title>\n</head>\n<body style="font-family: sans-serif; text-align: center; margin-top: 100px;">\n  <h1>✅ Bienvenue sur Camer-Web</h1>\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\n</body>\n</html>\nHTML\n\n# Configure Apache virtual host\nsudo tee /etc/apache2/sites-available/${DOMAIN_NAME}.conf > /dev/null <<APACHE\n<VirtualHost *:80>\n    ServerName ${DOMAIN_NAME}\n    DocumentRoot ${WEB_ROOT}\n    ErrorLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.error.log\n    CustomLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.access.log combined\n</VirtualHost>\nAPACHE\n\nsudo a2ensite ${DOMAIN_NAME}.conf\nsudo a2dissite 000-default.conf\nsudo systemctl reload apache2\nsudo systemctl enable apache2\n\n# Firewall\nsudo ufw allow OpenSSH\nsudo ufw allow 80/tcp\nsudo ufw allow 443/tcp\nsudo ufw --force enable\n\n# Record instance ID if provided\n: "${INSTANCE_ID:?INSTANCE_ID is required}"\necho "INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null\necho "export INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\nsudo chmod +x /etc/profile.d/instance_id.sh\n\n# Log initialization\necho "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log\n	/scripts/templates/web/web_server_apache_autoip_web_Web_Server_Apache_auto_IP_tpl001.sh	{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}	supprime	2025-08-14 12:32:46.503+01	2025-08-14 13:27:46.853+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\web\\web_server_apache_autoip_web_Web_Server_Apache_auto_IP_tpl001.sh	\N
34	Monitoring setup	monitoring_setup	monitoring	Génère les scripts de statut système, services et logs importants et les planifie via cron.	#!/bin/bash\nset -euo pipefail\n\n# Ensure monitoring directory exists with correct permissions\nMONITOR_DIR="${MONITOR_DIR:-/opt/monitoring}"\nCRON_USER="${CRON_USER:-nexus}"\nsudo mkdir -p "$MONITOR_DIR"\nsudo chown -R "$CRON_USER":"$CRON_USER" "$MONITOR_DIR"\nsudo chmod 775 "$MONITOR_DIR"\n\n# Paths\nSTATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH:-$MONITOR_DIR/status.sh}"\nSERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH:-$MONITOR_DIR/services_status.sh}"\nLOGS_SCRIPT_PATH="${LOGS_SCRIPT_PATH:-$MONITOR_DIR/logs.sh}"\n\n# --- system status script ---\ncat <<'EOS' > "$STATUS_SCRIPT_PATH"\n#!/bin/bash\nset -euo pipefail\n\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk '{print $1}')\nLOAD_AVG=$(cut -d ' ' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')\nDISK_TOTAL=$(df -B1 / | tail -1 | awk '{print $2}')\nDISK_USED=$(df -B1 / | tail -1 | awk '{print $3}')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk '{print $4}')\nIFACE=$(ip route get 1.1.1.1 | awk '{print $5; exit}')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\nOPEN_PORTS=$(ss -tuln | awk 'NR>1 {split($5,a,":"); print a[length(a)]}' | sort -n | uniq | paste -sd, -)\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{printf "{\\\\"pid\\\\":%s,\\\\"cmd\\\\":\\\\"%s\\\\",\\\\"cpu\\\\":%s}",",", $1, $2, $3}')\nTOP_PROCESSES="[${TOP_PROCESSES%,}]"\n\ncat <<JSON > "$MONITOR_DIR/status.json"\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "hostname": "${HOSTNAME}",\n  "ip_address": "${IP_ADDR}",\n  "load_average": "${LOAD_AVG}",\n  "memory": {\n    "total_kb": ${MEM_TOTAL},\n    "available_kb": ${MEM_AVAILABLE}\n  },\n  "disk": {\n    "total_bytes": ${DISK_TOTAL},\n    "used_bytes": ${DISK_USED},\n    "available_bytes": ${DISK_AVAIL}\n  },\n  "network": {\n    "interface": "${IFACE}",\n    "rx_bytes": ${RX_BYTES},\n    "tx_bytes": ${TX_BYTES}\n  },\n  "open_ports": [${OPEN_PORTS}],\n  "top_processes": ${TOP_PROCESSES}\n}\nJSON\nEOS\nchmod +x "$STATUS_SCRIPT_PATH"\n\n# --- services status script ---\ncat <<'EOS' > "$SERVICES_SCRIPT_PATH"\n#!/bin/bash\nset -euo pipefail\n\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql mariadb postgresql docker kubelet redis-server mongod vsftpd proftpd php-fpm\n)\nSERVICE_STATUS_JSON=""\nfor svc in "${SERVICES[@]}"; do\n  if systemctl list-units --type=service --all | grep -q "$svc"; then\n    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)\n    SERVICE_STATUS_JSON+="{\\"name\\":\\"$svc\\",\\"active\\":\\"$ACTIVE\\",\\"enabled\\":\\"$ENABLED\\"},"\n  fi\ndone\nSERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"\n\ncat <<JSON > "$MONITOR_DIR/services_status.json"\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "services": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\nchmod +x "$SERVICES_SCRIPT_PATH"\n\n# --- important logs script ---\ncat <<'EOS' > "$LOGS_SCRIPT_PATH"\n#!/bin/bash\nset -euo pipefail\n\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID="${INSTANCE_ID:-undefined}"\nLOG_LINES=$(journalctl -p 3 -n 50 --no-pager 2>/dev/null | sed 's/"/\\\\"/g')\nLOG_JSON=""\nwhile IFS= read -r line; do\n  [ -z "$line" ] && continue\n  LOG_JSON+="\\"$line\\","\ndone <<< "$LOG_LINES"\nLOG_JSON="[${LOG_JSON%,}]"\n\ncat <<JSON > "$MONITOR_DIR/logs_status.json"\n{\n  "timestamp": "${TIMESTAMP}",\n  "instance_id": "${INSTANCE_ID}",\n  "logs": ${LOG_JSON}\n}\nJSON\nEOS\nchmod +x "$LOGS_SCRIPT_PATH"\n\n# --- configure cron jobs ---\nSTATUS_CRON_EXPR="${STATUS_CRON_EXPR:-*/1 * * * *}"\nSERVICES_CRON_EXPR="${SERVICES_CRON_EXPR:-*/1 * * * *}"\nLOGS_CRON_EXPR="${LOGS_CRON_EXPR:-*/1 * * * *}"\nMARK_STATUS="# MONITORING_STATUS_CRON"\nMARK_SERVICES="# MONITORING_SERVICES_CRON"\nMARK_LOGS="# MONITORING_LOGS_CRON"\n\ncrontab_get() { crontab -u "$CRON_USER" -l 2>/null || true; }\ncrontab_set() { crontab -u "$CRON_USER" -; }\nadd_cron_once() {\n  local expr="$1" cmd="$2" mark="$3"\n  local current\n  current="$(crontab_get)"\n  if ! echo "$current" | grep -Fq "$mark"; then\n    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set\n  fi\n}\n\nadd_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >$MONITOR_DIR/status.log 2>&1" "$MARK_STATUS"\nadd_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >$MONITOR_DIR/services_status.log 2>&1" "$MARK_SERVICES"\nadd_cron_once "$LOGS_CRON_EXPR" "bash $LOGS_SCRIPT_PATH >$MONITOR_DIR/logs_status.log 2>&1" "$MARK_LOGS"\n\n# run once immediately\nbash "$STATUS_SCRIPT_PATH" || true\nbash "$SERVICES_SCRIPT_PATH" || true\nbash "$LOGS_SCRIPT_PATH" || true\n\n# ensure cron service is enabled\nif command -v systemctl >/dev/null 2>&1; then\n  systemctl enable --now cron 2>/null || systemctl enable --now crond 2>/null || true\nfi\n\nexit 0\n	/scripts/templates/monitoring/monitoring_setup_monitoring_Monitoring_setup_tpl002.sh	{"fields":[{"name":"MONITOR_DIR","label":"Dossier de monitoring","type":"text","required":true,"default":"/opt/monitoring"},{"name":"CRON_USER","label":"Utilisateur cron","type":"text","required":true,"default":"nexus"},{"name":"STATUS_SCRIPT_PATH","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT_PATH","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"LOGS_SCRIPT_PATH","label":"Chemin script logs","type":"text","required":true,"default":"/opt/monitoring/logs.sh"},{"name":"STATUS_CRON_EXPR","label":"Cron status","type":"text","required":true,"default":"*/1 * * * *"},{"name":"SERVICES_CRON_EXPR","label":"Cron services","type":"text","required":true,"default":"*/1 * * * *"},{"name":"LOGS_CRON_EXPR","label":"Cron logs","type":"text","required":true,"default":"*/1 * * * *"}]}	actif	2025-08-14 13:42:04.466+01	2025-08-14 13:42:04.466+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\monitoring\\monitoring_setup_monitoring_Monitoring_setup_tpl002.sh	\N
35	Web Server Apache auto IP	web_server_apache_autoip	web	Installe Apache et injecte automatiquement l’IP de la VM dans la page d’accueil.	#!/bin/bash\nset -euo pipefail\n\nDOMAIN_NAME="${DOMAIN_NAME:-example.com}"\nWEB_ROOT="${WEB_ROOT:-/var/www/html}"\nVM_NAME="${VM_NAME:-vm1}"\n\n# Detect primary IP automatically\nSERVER_IP=$(hostname -I | awk '{print $1}')\n\necho "🌐 Déploiement du serveur web Apache (${DOMAIN_NAME})"\n\n# Install packages\nsudo apt update\nsudo apt install -y apache2 curl\n\n# Prepare web directory\nsudo mkdir -p "$WEB_ROOT"\n\nsudo tee "$WEB_ROOT/index.html" > /dev/null <<HTML\n<!DOCTYPE html>\n<html lang="fr">\n<head>\n  <meta charset="UTF-8" />\n  <title>Camer-Web</title>\n</head>\n<body style="font-family: sans-serif; text-align: center; margin-top: 100px;">\n  <h1>✅ Bienvenue sur Camer-Web</h1>\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\n</body>\n</html>\nHTML\n\n# Configure Apache virtual host\nsudo tee /etc/apache2/sites-available/${DOMAIN_NAME}.conf > /dev/null <<APACHE\n<VirtualHost *:80>\n    ServerName ${DOMAIN_NAME}\n    DocumentRoot ${WEB_ROOT}\n    ErrorLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.error.log\n    CustomLog ${APACHE_LOG_DIR}/${DOMAIN_NAME}.access.log combined\n</VirtualHost>\nAPACHE\n\nsudo a2ensite ${DOMAIN_NAME}.conf\nsudo a2dissite 000-default.conf\nsudo systemctl reload apache2\nsudo systemctl enable apache2\n\n# Firewall\nsudo ufw allow OpenSSH\nsudo ufw allow 80/tcp\nsudo ufw allow 443/tcp\nsudo ufw --force enable\n\n# Record instance ID if provided\n: "${INSTANCE_ID:?INSTANCE_ID is required}"\necho "INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null\necho "export INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\nsudo chmod +x /etc/profile.d/instance_id.sh\n\n# Log initialization\necho "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log\n	/scripts/templates/web/web_server_apache_autoip_web_Web_Server_Apache_auto_IP_tpl002.sh	{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}	actif	2025-08-14 13:46:45.849+01	2025-08-14 13:46:45.849+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\web\\web_server_apache_autoip_web_Web_Server_Apache_auto_IP_tpl002.sh	\N
36	Web Server NGINX auto IP	web_server_nginx_autoip	web	Installe NGINX et injecte automatiquement l’IP de la VM dans la page d’accueil.	#!/bin/bash\nset -euo pipefail\n\nDOMAIN_NAME="${DOMAIN_NAME:-example.com}"\nWEB_ROOT="${WEB_ROOT:-/var/www/html}"\nVM_NAME="${VM_NAME:-vm1}"\n\n# Detect primary IP automatically\nSERVER_IP=$(hostname -I | awk '{print $1}')\n\necho "🌐 Déploiement du serveur web NGINX (${DOMAIN_NAME})"\n\n# Install packages\nsudo apt update\nsudo apt install -y nginx curl\n\n# Prepare web directory\nsudo mkdir -p "$WEB_ROOT"\n\nsudo tee "$WEB_ROOT/index.html" > /dev/null <<HTML\n<!DOCTYPE html>\n<html lang="fr">\n<head>\n  <meta charset="UTF-8" />\n  <title>Camer-Web</title>\n</head>\n<body style="font-family: sans-serif; text-align: center; margin-top: 100px;">\n  <h1>✅ Bienvenue sur Camer-Web</h1>\n  <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\n  <p>📍 IP : <strong>${SERVER_IP}</strong></p>\n  <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\n</body>\n</html>\nHTML\n\n# Configure nginx vhost\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<NGINX\nserver {\n    listen 80;\n    server_name ${DOMAIN_NAME};\n    root ${WEB_ROOT};\n    index index.html;\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\n    location / {\n        try_files \\$uri \\$uri/ =404;\n    }\n}\nNGINX\n\nsudo ln -sf /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/${DOMAIN_NAME}\nsudo rm -f /etc/nginx/sites-enabled/default\n\nsudo systemctl restart nginx\nsudo systemctl enable nginx\n\n# Firewall\nsudo ufw allow OpenSSH\nsudo ufw allow 80/tcp\nsudo ufw allow 443/tcp\nsudo ufw --force enable\n\n# Record instance ID if provided\n: "${INSTANCE_ID:?INSTANCE_ID is required}"\necho "INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/instance-info.conf > /dev/null\necho "export INSTANCE_ID=${INSTANCE_ID}" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\nsudo chmod +x /etc/profile.d/instance_id.sh\n\n# Log initialization\necho "$(date --iso-8601=seconds) - Initialized instance with ID: ${INSTANCE_ID}" | sudo tee -a /var/log/init.log\n	/scripts/templates/web/web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_tpl002.sh	{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"example.com"},{"name":"WEB_ROOT","label":"Racine web","type":"text","required":true,"default":"/var/www/html"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"vm1"},{"name":"INSTANCE_ID","label":"Identifiant instance","type":"text","required":true}]}	actif	2025-08-14 13:49:16.078+01	2025-08-14 13:49:16.078+01	D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\scripts\\templates\\web\\web_server_nginx_autoip_web_Web_Server_NGINX_auto_IP_tpl002.sh	\N
\.


--
-- Data for Name: user_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_settings (id, user_id, cloudinit_user, cloudinit_password, proxmox_api_url, proxmox_api_token_id, proxmox_api_token_name, proxmox_api_token_secret, pm_user, pm_password, proxmox_node, vm_storage, vm_bridge, ssh_public_key_path, ssh_private_key_path, statuspath, servicespath, instanceinfopath, proxmox_host, proxmox_ssh_user, created_at, updated_at) FROM stdin;
1	1	nexus	Nexus2023.	https://192.168.24.134:8006/api2/json	root@pam	delete	0a804aa8-029e-4503-83a3-3fb51a804771	root@pam	Nexus2023.	pve	local-lvm	vmbr0	C:/Users/Nexus-PC/.ssh/id_rsa.pub	C:/Users/Nexus-PC/.ssh/id_rsa	/opt/monitoring/status.json	/opt/monitoring/services_status.json	/etc/instance-info.conf	192.168.24.134	root	2025-08-06 04:39:32.328273+01	2025-08-13 06:48:05.915+01
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, phone, password, status, reset_token, reset_expires_at, last_password_reset_at, role_id, created_at, updated_at) FROM stdin;
1	Nexus	Nexus Latif	latifnjimoluh@gmail.com	555-0100	$2b$10$/7k8y44BfxY.BBTDrtTNCuxR4jZ0B5oUNHUeBErGFxI.2amWvtb96	actif	531825	2025-08-09 19:16:21.196+01	2025-08-06 04:41:00.376+01	1	2025-08-06 04:39:32.324893+01	2025-08-09 19:01:21.196+01
3	tes3	test	res@gmail.com	555555555555	$2b$10$I1KNiIl4WYJ9sJKkxIHBie07cLSnSk/fy6IlFLUCIDhB2pefvxUxO	actif	\N	\N	\N	2	2025-08-09 18:54:53.372+01	2025-08-13 22:48:34.97+01
\.


--
-- Name: ai_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_cache_id_seq', 22, true);


--
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq', 3, true);


--
-- Name: converted_vms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.converted_vms_id_seq', 2, true);


--
-- Name: deletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deletes_id_seq', 40, true);


--
-- Name: deployments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deployments_id_seq', 46, true);


--
-- Name: generated_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.generated_scripts_id_seq', 40, true);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 3887, true);


--
-- Name: monitorings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitorings_id_seq', 15, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 70, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- Name: service_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_templates_id_seq', 36, true);


--
-- Name: user_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_settings_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


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
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


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
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: monitorings monitorings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitorings
    ADD CONSTRAINT monitorings_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_key_key UNIQUE (key);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (jti);


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
-- Name: idx_logs_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logs_action ON public.logs USING btree (action);


--
-- Name: idx_logs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logs_created_at ON public.logs USING btree (created_at);


--
-- Name: idx_logs_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logs_user_id ON public.logs USING btree (user_id);


--
-- Name: idx_refresh_tokens_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_refresh_tokens_user ON public.refresh_tokens USING btree (user_id);


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
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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

