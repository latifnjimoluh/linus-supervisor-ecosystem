--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5

-- Started on 2025-08-13 05:05:54

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

--
-- TOC entry 5 (class 2615 OID 16668)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- TOC entry 217 (class 1259 OID 17171)
-- Name: ai_cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."ai_cache" (
    "id" integer NOT NULL,
    "type" character varying(255) NOT NULL,
    "hash" character varying(64) NOT NULL,
    "input_text" "text" NOT NULL,
    "response_text" "text" NOT NULL,
    "entity_type" character varying(255),
    "entity_id" integer,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 17178)
-- Name: ai_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."ai_cache_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 218
-- Name: ai_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."ai_cache_id_seq" OWNED BY "public"."ai_cache"."id";


--
-- TOC entry 219 (class 1259 OID 17179)
-- Name: alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."alerts" (
    "id" integer NOT NULL,
    "server" character varying(255),
    "service" character varying(255),
    "severity" character varying(50),
    "status" character varying(50) DEFAULT 'en_cours'::character varying,
    "description" character varying(255),
    "comment" "text",
    "started_at" timestamp with time zone DEFAULT "now"(),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 17188)
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."alerts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 220
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."alerts_id_seq" OWNED BY "public"."alerts"."id";


--
-- TOC entry 221 (class 1259 OID 17190)
-- Name: assigned_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."assigned_permissions" (
    "role_id" integer NOT NULL,
    "permission_id" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 222 (class 1259 OID 17193)
-- Name: converted_vms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."converted_vms" (
    "id" integer NOT NULL,
    "vm_name" character varying(255) NOT NULL,
    "vm_id" character varying(255) NOT NULL,
    "user_id" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 17200)
-- Name: converted_vms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."converted_vms_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 223
-- Name: converted_vms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."converted_vms_id_seq" OWNED BY "public"."converted_vms"."id";


--
-- TOC entry 224 (class 1259 OID 17201)
-- Name: deletes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."deletes" (
    "id" integer NOT NULL,
    "vm_id" character varying(255) NOT NULL,
    "instance_id" character varying(255),
    "vm_name" character varying(255),
    "vm_ip" character varying(255),
    "log_path" character varying(255),
    "user_id" integer,
    "user_email" character varying(255),
    "deleted_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 17208)
-- Name: deletes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."deletes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 225
-- Name: deletes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."deletes_id_seq" OWNED BY "public"."deletes"."id";


--
-- TOC entry 226 (class 1259 OID 17209)
-- Name: deployments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."deployments" (
    "id" integer NOT NULL,
    "user_id" integer,
    "user_email" character varying(255),
    "vm_name" character varying(255),
    "service_name" character varying(255),
    "zone" character varying(50),
    "operation_type" character varying(50),
    "started_at" timestamp with time zone,
    "ended_at" timestamp with time zone,
    "duration" character varying(50),
    "success" boolean,
    "log_path" character varying(255),
    "vm_id" character varying(255),
    "vm_ip" character varying(255),
    "instance_id" character varying(255),
    "injected_files" json,
    "vm_specs" json,
    "status" character varying(50),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 17216)
-- Name: deployments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."deployments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 227
-- Name: deployments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."deployments_id_seq" OWNED BY "public"."deployments"."id";


--
-- TOC entry 228 (class 1259 OID 17217)
-- Name: generated_scripts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."generated_scripts" (
    "id" integer NOT NULL,
    "template_id" integer NOT NULL,
    "category" character varying(255) NOT NULL,
    "service_type" character varying(255) NOT NULL,
    "script_path" "text" NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "abs_path" character varying,
    "status" character varying(20) DEFAULT 'actif'::character varying
);


--
-- TOC entry 229 (class 1259 OID 17225)
-- Name: generated_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."generated_scripts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 229
-- Name: generated_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."generated_scripts_id_seq" OWNED BY "public"."generated_scripts"."id";


--
-- TOC entry 230 (class 1259 OID 17226)
-- Name: initialization_scripts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."initialization_scripts" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "script_path" character varying(255) NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 17233)
-- Name: initialization_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."initialization_scripts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 231
-- Name: initialization_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."initialization_scripts_id_seq" OWNED BY "public"."initialization_scripts"."id";


--
-- TOC entry 232 (class 1259 OID 17234)
-- Name: logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."logs" (
    "id" integer NOT NULL,
    "user_id" integer,
    "action" character varying(255) NOT NULL,
    "details" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 17240)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."logs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 233
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."logs_id_seq" OWNED BY "public"."logs"."id";


--
-- TOC entry 234 (class 1259 OID 17241)
-- Name: monitored_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."monitored_services" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "script_path" character varying(255) NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 17248)
-- Name: monitored_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."monitored_services_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 235
-- Name: monitored_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."monitored_services_id_seq" OWNED BY "public"."monitored_services"."id";


--
-- TOC entry 236 (class 1259 OID 17249)
-- Name: monitoring_scripts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."monitoring_scripts" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "script_path" character varying(255) NOT NULL,
    "description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 17256)
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."monitoring_scripts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 237
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."monitoring_scripts_id_seq" OWNED BY "public"."monitoring_scripts"."id";


--
-- TOC entry 238 (class 1259 OID 17257)
-- Name: monitorings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."monitorings" (
    "id" integer NOT NULL,
    "vm_ip" character varying(255),
    "ip_address" character varying(255),
    "instance_id" character varying(255),
    "services_status" json,
    "system_status" json,
    "retrieved_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 239 (class 1259 OID 17265)
-- Name: monitorings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."monitorings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 239
-- Name: monitorings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."monitorings_id_seq" OWNED BY "public"."monitorings"."id";


--
-- TOC entry 240 (class 1259 OID 17266)
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."permissions" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "description" character varying(255),
    "status" character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 17274)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."permissions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 241
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."permissions_id_seq" OWNED BY "public"."permissions"."id";


--
-- TOC entry 242 (class 1259 OID 17275)
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."roles" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "status" character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "description" "text"
);


--
-- TOC entry 243 (class 1259 OID 17281)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."roles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 243
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."roles_id_seq" OWNED BY "public"."roles"."id";


--
-- TOC entry 244 (class 1259 OID 17282)
-- Name: service_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."service_templates" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "service_type" character varying(255) NOT NULL,
    "category" character varying(255) NOT NULL,
    "description" "text",
    "template_content" "text" NOT NULL,
    "script_path" character varying(255),
    "fields_schema" json,
    "status" character varying(10) DEFAULT 'actif'::character varying NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "abs_path" character varying,
    "deleted_at" timestamp without time zone
);


--
-- TOC entry 245 (class 1259 OID 17290)
-- Name: service_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."service_templates_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 245
-- Name: service_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."service_templates_id_seq" OWNED BY "public"."service_templates"."id";


--
-- TOC entry 246 (class 1259 OID 17291)
-- Name: user_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."user_settings" (
    "id" integer NOT NULL,
    "user_id" integer NOT NULL,
    "cloudinit_user" character varying(255),
    "cloudinit_password" character varying(255),
    "proxmox_api_url" character varying(255),
    "proxmox_api_token_id" character varying(255),
    "proxmox_api_token_name" character varying(255),
    "proxmox_api_token_secret" character varying(255),
    "pm_user" character varying(255),
    "pm_password" character varying(255),
    "proxmox_node" character varying(255),
    "vm_storage" character varying(255),
    "vm_bridge" character varying(255),
    "ssh_public_key_path" character varying(255),
    "ssh_private_key_path" character varying(255),
    "statuspath" character varying(255),
    "servicespath" character varying(255),
    "instanceinfopath" character varying(255),
    "proxmox_host" character varying(255),
    "proxmox_ssh_user" character varying(255),
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 247 (class 1259 OID 17298)
-- Name: user_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."user_settings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 247
-- Name: user_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."user_settings_id_seq" OWNED BY "public"."user_settings"."id";


--
-- TOC entry 248 (class 1259 OID 17299)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."users" (
    "id" integer NOT NULL,
    "first_name" character varying(255) NOT NULL,
    "last_name" character varying(255) NOT NULL,
    "email" character varying(255) NOT NULL,
    "phone" character varying(255),
    "password" character varying(255) NOT NULL,
    "status" character varying(10) DEFAULT 'actif'::character varying,
    "reset_token" character varying(255),
    "reset_expires_at" timestamp with time zone,
    "last_password_reset_at" timestamp with time zone,
    "role_id" integer,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- TOC entry 249 (class 1259 OID 17307)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 249
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";


--
-- TOC entry 3293 (class 2604 OID 17308)
-- Name: ai_cache id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ai_cache" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ai_cache_id_seq"'::"regclass");


--
-- TOC entry 3296 (class 2604 OID 17309)
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."alerts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."alerts_id_seq"'::"regclass");


--
-- TOC entry 3303 (class 2604 OID 17310)
-- Name: converted_vms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."converted_vms" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."converted_vms_id_seq"'::"regclass");


--
-- TOC entry 3306 (class 2604 OID 17311)
-- Name: deletes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deletes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."deletes_id_seq"'::"regclass");


--
-- TOC entry 3309 (class 2604 OID 17312)
-- Name: deployments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deployments" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."deployments_id_seq"'::"regclass");


--
-- TOC entry 3312 (class 2604 OID 17313)
-- Name: generated_scripts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generated_scripts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."generated_scripts_id_seq"'::"regclass");


--
-- TOC entry 3316 (class 2604 OID 17314)
-- Name: initialization_scripts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."initialization_scripts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."initialization_scripts_id_seq"'::"regclass");


--
-- TOC entry 3319 (class 2604 OID 17315)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."logs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."logs_id_seq"'::"regclass");


--
-- TOC entry 3321 (class 2604 OID 17316)
-- Name: monitored_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."monitored_services" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."monitored_services_id_seq"'::"regclass");


--
-- TOC entry 3324 (class 2604 OID 17317)
-- Name: monitoring_scripts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."monitoring_scripts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."monitoring_scripts_id_seq"'::"regclass");


--
-- TOC entry 3327 (class 2604 OID 17318)
-- Name: monitorings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."monitorings" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."monitorings_id_seq"'::"regclass");


--
-- TOC entry 3331 (class 2604 OID 17319)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."permissions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."permissions_id_seq"'::"regclass");


--
-- TOC entry 3335 (class 2604 OID 17320)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."roles_id_seq"'::"regclass");


--
-- TOC entry 3339 (class 2604 OID 17321)
-- Name: service_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."service_templates" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."service_templates_id_seq"'::"regclass");


--
-- TOC entry 3343 (class 2604 OID 17322)
-- Name: user_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."user_settings" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."user_settings_id_seq"'::"regclass");


--
-- TOC entry 3346 (class 2604 OID 17323)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_id_seq"'::"regclass");


--
-- TOC entry 3546 (class 0 OID 17171)
-- Dependencies: 217
-- Data for Name: ai_cache; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (1, 'analyze_script', '9765050c14cece2be366e3c64f639b94e05c42a7d2c3218e0d63c813ba30e746', '#!/bin/bash
sudo apt update', 'Absolument. Voici une analyse détaillée et des propositions d''amélioration pour ce script.

---

### 1. Analyse du script et améliorations possibles

Le script est simple et fonctionnel pour son objectif unique : lancer `apt update`. Cependant, il lui manque plusieurs caractéristiques d''un script robuste et bien conçu.

**Problèmes et points d''amélioration :**

1.  **Gestion des erreurs :** Si la commande `apt update` échoue (par exemple, pas de connexion Internet, un dépôt est inaccessible), le script s''arrêtera, mais sans indiquer explicitement qu''une erreur s''est produite. Un bon script doit capturer les erreurs et se terminer proprement.
2.  **Gestion des privilèges :** Le script utilise `sudo` à l''intérieur. La pratique standard est plutôt de vérifier si le script est lancé avec les privilèges nécessaires (en tant que `root`) et de laisser l''utilisateur le lancer avec `sudo` (`sudo ./mon_script.sh`). Cela rend le comportement plus prévisible.
3.  **Portabilité du Shebang :** `#!/bin/bash` suppose que l''interpréteur bash se trouve toujours dans `/bin/bash`. Sur certains systèmes, il peut être dans `/usr/bin/bash` ou ailleurs. L''utilisation de `#!/usr/bin/env bash` est plus portable car elle cherche `bash` dans le `PATH` de l''utilisateur.
4.  **Feedback utilisateur :** Le script s''exécute sans informer l''utilisateur de ce qu''il fait. Ajouter des messages simples (`echo`) pour indiquer le début et la fin des opérations est une bonne pratique.
5.  **Non-interactivité :** Bien que `apt update` ne soit généralement pas interactif, si vous étendiez ce script pour inclure `apt upgrade`, le système demanderait une confirmation (Y/n), bloquant l''exécution. Il est donc sage de prévoir des options non interactives comme `-y`.

---

### 2. Alternatives ou pratiques modernes

Exécuter manuellement un script pour les mises à jour est une méthode viable, mais pour des environnements de serveurs ou pour une gestion rigoureuse, des approches plus modernes et automatisées sont préférables.

1.  **Tâches planifiées (Cron / Systemd Timers)**
    *   **Cron :** L''approche classique. On peut ajouter une tâche au `crontab` pour exécuter le script de mise à jour automatiquement (par exemple, tous les jours à 3h du matin).
        ```bash
        # crontab -e
        0 3 * * * /chemin/vers/votre/script_optimise.sh > /var/log/update.log 2>&1
        ```
    *   **Systemd Timers :** L''alternative moderne à `cron` sur la plupart des distributions Linux récentes (dont Ubuntu). Ils offrent plus de flexibilité et une meilleure intégration avec le système de journalisation (`journalctl`).

2.  **Le paquet `unattended-upgrades`**
    *   C''est **la solution native et recommandée** sur les systèmes Debian/Ubuntu pour automatiser les mises à jour, en particulier celles de sécurité. Une fois configuré, il gère le téléchargement et l''installation des mises à jour de manière autonome et sécurisée, sans nécessiter de script personnalisé.
    *   Pour l''installer et l''activer :
        ```bash
        sudo apt install unattended-upgrades
        sudo dpkg-reconfigure -plow unattended-upgrades
        ```

3.  **Outils de gestion de configuration (Ansible, Puppet, Chef)**
    *   Pour gérer un parc de plusieurs serveurs, ces outils sont la norme. Ils permettent de décrire l''état souhaité d''un système ("le paquet `nginx` doit être installé et le système à jour") de manière déclarative.
    *   **Exemple avec Ansible :** On n''écrit pas un script bash, mais un "playbook" en YAML.
        ```yaml
        ---
        - hosts: all
          become: yes  # Équivalent de sudo
          tasks:
            - name: Update apt repo and cache
              apt:
                update_cache: yes
                cache_valid_time: 3600 # Met à jour si le cache a plus d''une heure

            - name: Upgrade all apt packages to the latest version
              apt:
                upgrade: dist # "dist" est plus prudent que "full"
        ```
    Cette approche est idempotente (l''exécuter plusieurs fois produit le même résultat), plus lisible et scalable.

---

### 3. Version optimisée du script

Voici une version du script initial qui intègre les améliorations discutées. Ce script est plus robuste, plus sûr et plus informatif.

```bash
#!/usr/bin/env bash

#
# script_update_system.sh
#
# Description : Met à jour la liste des paquets disponibles (apt update).
# Auteur : [Votre Nom]
# Date : [Date du jour]
#
# Utilisation : sudo ./script_update_system.sh
#

# --- Configuration de la sécurité du script ---
# set -e : Quitte immédiatement si une commande échoue.
# set -u : Traite les variables non définies comme une erreur.
# set -o pipefail : Fait échouer un pipeline si l''une de ses commandes échoue.
set -euo pipefail

# --- Fonctions ---

# Affiche un message d''information
log_info() {
    echo "[INFO] $(date ''+%Y-%m-%d %H:%M:%S'') - $1"
}

# Affiche un message d''erreur et quitte
log_error() {
    echo "[ERREUR] $(date ''+%Y-%m-%d %H:%M:%S'') - $1" >&2
    exit 1
}

# --- Script principal ---

main() {
    # 1. Vérifier si le script est exécuté avec les privilèges root (sudo)
    if [[ "${EUID}" -ne 0 ]]; then
        log_error "Ce script doit être exécuté avec les privilèges root. Utilisez ''sudo''."
    fi

    # 2. Informer l''utilisateur du début du processus
    log_info "Lancement de la mise à jour des listes de paquets..."

    # 3. Exécuter la commande de mise à jour
    # L''option -y n''est pas nécessaire pour `update` mais est une bonne pratique si on ajoute `upgrade`.
    # Nous redirigeons la sortie vers /dev/null pour un affichage propre,
    # mais en cas d''erreur, `set -e` arrêtera le script.
    if apt-get update -y >/dev/null; then
        log_info "Mise à jour des listes de paquets terminée avec succès."
    else
        # Cette partie n''est atteinte que si `set -e` est désactivé,
        # mais c''est une bonne pratique pour la robustesse.
        log_error "La commande ''apt-get update'' a échoué."
    fi

    # 4. Message de fin
    log_info "Script terminé."
}

# Lancement de la fonction principale
main
```

#### Qu''est-ce que cette version optimisée apporte ?

1.  **Robustesse** : `set -euo pipefail` assure que le script s''arrête proprement à la moindre erreur.
2.  **Sécurité** : La vérification `[[ "${EUID}" -ne 0 ]]` garantit que le script ne s''exécute que s''il a les bons privilèges.
3.  **Clarté** : Les fonctions `log_info` et `log_error` et les messages `echo` rendent le script lisible et facile à déboguer.
4.  **Bonnes pratiques** : Utilisation de `apt-get` (souvent préféré dans les scripts pour sa stabilité d''interface), et commentaires expliquant l''objectif et l''utilisation du script.
5.  **Extensibilité** : La structure avec une fonction `main` facilite l''ajout de nouvelles fonctionnalités (par exemple, une fonction pour `apt upgrade`, une autre pour le nettoyage avec `autoremove`, etc.).', NULL, NULL, '2025-08-07 03:16:53.819+00', '2025-08-07 03:16:53.819+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (2, 'explain_variables', '970f8684676a8125a124a348f9d5cfa28ffaae7f85e2fffae2626f632ddbf657', '#!/bin/bash
export VAR={{VALUE}}', 'Bien sûr. Voici l''explication concise pour ce template.

---

Dans ce template, vous devez renseigner deux éléments :

*   `VAR` : Le **nom** de la variable d''environnement que vous souhaitez créer.
*   `{{VALUE}}` : La **valeur** que vous voulez assigner à cette variable.

La commande `export` rend cette variable accessible à tous les programmes ou scripts qui seront lancés depuis ce terminal après l''exécution du script.

**Exemple :**

Si vous remplacez `VAR` par `API_KEY` et `{{VALUE}}` par `"abc123xyz"`, le script deviendra :

```bash
#!/bin/bash
export API_KEY="abc123xyz"
```', NULL, NULL, '2025-08-07 03:19:31.251+00', '2025-08-07 03:19:31.251+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (3, 'analyze_script', '5d0429fa78461a77fb3b71dc686c3572350b9e8fb7b3c9bc2cb48a4870670434', '#!/bin/bash\nsudo apt update', '', NULL, NULL, '2025-08-07 03:58:08.369+00', '2025-08-07 03:58:08.369+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (4, 'explain_script', '93ffd60cb15071cd624f3381f7ae9b5d607a3fb5e3db0c08583a6c88187bc878', '#!/bin/bash
echo hello', 'Absolument ! Voici une analyse et des conseils pour ce script.

---

### 1. Explication du script

Ce script est un exemple très simple de script shell Bash.

*   `#!/bin/bash` : C''est ce qu''on appelle un **shebang**. Il indique au système d''exploitation que le fichier doit être exécuté avec l''interpréteur `/bin/bash`. C''est la première ligne standard de la plupart des scripts shell pour garantir qu''ils sont interprétés correctement.
*   `echo hello` : C''est la commande principale. `echo` est une commande intégrée au shell qui affiche le texte qui la suit (ici, le mot "hello") sur la **sortie standard**, qui est généralement votre terminal.

**En résumé :** Lorsqu''il est exécuté, ce script affiche simplement le mot "hello" dans le terminal.

---

### 2. Conseils et alternatives après le déploiement

Même pour un script aussi simple, le "déploiement" implique de penser à la manière dont il sera utilisé, maintenu et intégré dans un environnement plus large. Voici plusieurs pistes d''amélioration et alternatives.

#### Améliorations de base du script

1.  **Rendre le script exécutable**
    Pour pouvoir exécuter le script directement (par ex. `./mon_script.sh`), vous devez lui donner les permissions d''exécution.
    ```bash
    chmod +x mon_script.sh
    ```

2.  **Utiliser des variables**
    Au lieu d''écrire le texte en dur ("hardcoding"), utilisez des variables. C''est une bonne pratique qui rend le script plus flexible et facile à maintenir.
    ```bash
    #!/bin/bash
    
    # Définir une variable pour le message
    MESSAGE="Hello, World!"
    
    # Afficher le contenu de la variable
    # Les guillemets protègent les espaces et caractères spéciaux
    echo "$MESSAGE"
    ```

3.  **Gestion des erreurs**
    Un script robuste doit s''arrêter si une commande échoue. Pour cela, on ajoute généralement `set -e`.
    *   `set -e` : Le script s''arrête immédiatement si une commande renvoie un code d''erreur non nul.
    *   `set -o pipefail` : S''assure que si une étape dans un pipeline (`|`) échoue, toute la ligne est considérée comme un échec.
    ```bash
    #!/bin/bash
    set -e
    set -o pipefail
    
    echo "Cette commande va fonctionner"
    commande_qui_n_existe_pas # Le script s''arrêtera ici
    echo "Cette ligne ne sera jamais atteinte"
    ```

#### Intégration et automatisation (Vision DevOps)

4.  **Journalisation (Logging)**
    Au lieu de simplement afficher sur le terminal, un script en production devrait écrire dans un fichier de log, avec des informations de date/heure.
    ```bash
    #!/bin/bash
    
    LOG_FILE="/var/log/mon_app.log"
    
    # Redirige la sortie vers le fichier de log en ajoutant la date
    echo "$(date ''+%Y-%m-%d %H:%M:%S'') - Script démarré" >> "$LOG_FILE"
    echo "$(date ''+%Y-%m-%d %H:%M:%S'') - Hello" >> "$LOG_FILE"
    ```
    Pour une journalisation plus avancée, on peut utiliser l''utilitaire `logger` pour envoyer les messages vers `syslog`.

5.  **Planification (Scheduling)**
    Le script est-il destiné à être exécuté manuellement ou automatiquement ? Pour une exécution récurrente, on utilise un **cron job**.
    Par exemple, pour exécuter le script tous les jours à 2h du matin :
    ```crontab
    # Éditer la crontab avec "crontab -e"
    0 2 * * * /chemin/vers/mon_script.sh
    ```

6.  **Intégration dans un pipeline CI/CD**
    Ce script pourrait être une étape dans un pipeline de déploiement (avec GitLab CI, GitHub Actions, Jenkins...). Dans ce contexte, son **code de sortie** est crucial.
    *   Un code de sortie de `0` signifie "succès".
    *   Tout autre code (de 1 à 255) signifie "échec".
    Le pipeline utilisera ce code pour décider de passer à l''étape suivante ou d''arrêter le déploiement.

#### Alternatives au script Bash

7.  **Quand choisir un autre langage ?**
    Bash est parfait pour enchaîner des commandes système, manipuler des fichiers ou pour des scripts simples. Cependant, si la logique devient complexe (structures de données, appels API, tests unitaires...), il est préférable d''utiliser un langage plus puissant.

    *   **Python** : Excellent pour la manipulation de données (JSON, YAML), les interactions avec des API web et une gestion des erreurs plus fine. C''est un choix très courant en DevOps.
      ```python
      # equivalent.py
      import sys
      
      def main():
          print("Hello from Python!")
          # En cas de succès, le script termine avec un code de sortie 0 par défaut
          # En cas d''erreur : sys.exit(1)
      
      if __name__ == "__main__":
          main()
      ```

    *   **Go** : Idéal si vous avez besoin de créer un binaire statique (un seul fichier exécutable sans dépendances) pour une performance maximale et une distribution facile.

    *   **Outils de gestion de configuration (Ansible, Puppet, Chef)** : Si le but du script est de configurer un état sur un serveur (installer un paquet, vérifier qu''un service tourne...), un outil comme Ansible est souvent plus approprié. Il est déclaratif ("je veux que cet état soit atteint") plutôt qu''impératif ("exécute cette commande, puis celle-ci...").

**Conclusion :** Votre script `echo hello` est le point de départ de toute automatisation. La vision DevOps consiste à immédiatement se demander : "Comment rendre ce script robuste, maintenable, sécurisé et l''intégrer dans un processus automatisé et surveillé ?".', NULL, NULL, '2025-08-08 16:00:35.438+00', '2025-08-08 16:00:35.438+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (5, 'simulate_execution', '7ddcdac408524ea60559302ca1c25f13db1eac8ee0d03e16990595889b0e76f3', '#!/bin/bash
systemctl restart nginx', 'Absolument. Voici une description détaillée de ce qui se passera lors de l''exécution de ce script.

---

### Description de l''exécution du script

Ce script exécute une seule commande : `systemctl restart nginx`. Pour que cette commande réussisse, elle doit être exécutée par un utilisateur avec des privilèges suffisants (généralement l''utilisateur `root` ou via `sudo`).

Voici la réponse détaillée à vos questions :

#### 1. Quelles ressources seront créées ou modifiées ?

Le script ne **crée** pas de nouveaux fichiers de configuration de manière permanente, mais il **modifie** l''état de plusieurs ressources système de manière temporaire ou cyclique :

*   **Processus Nginx :** C''est la modification la plus importante.
    *   Tous les processus `nginx` existants (le processus maître et ses processus "workers") seront terminés (signal `SIGTERM`, puis `SIGKILL` si nécessaire).
    *   De nouveaux processus `nginx` seront lancés. Le nouveau processus maître lira les fichiers de configuration actuels (situés par défaut dans `/etc/nginx/`) pour déterminer son comportement.

*   **Fichier PID :** Le fichier contenant l''identifiant du processus maître Nginx (généralement `/var/run/nginx.pid` ou `/run/nginx.pid`) sera supprimé lorsque l''ancien processus s''arrête, puis recréé avec le nouvel identifiant de processus.

*   **Sockets réseau :**
    *   Les sockets réseau sur lesquels Nginx écoutait (typiquement le port 80 pour HTTP et 443 pour HTTPS) seront fermés.
    *   Ils seront immédiatement rouverts par le nouveau processus Nginx. Pendant cette micro-seconde de transition, les nouvelles connexions entrantes peuvent être refusées.

*   **Fichiers journaux (Logs) :** Nginx va rouvrir ses fichiers journaux (par exemple, `access.log` et `error.log`) et commencer à y écrire les nouvelles requêtes et les éventuelles erreurs du nouveau processus. Aucune nouvelle entrée ne sera ajoutée par les anciens processus.

#### 2. Quels services seront redémarrés ?

*   **Un seul service : `nginx`**.

L''action `restart` indique à `systemd` (le gestionnaire de services du système) d''effectuer deux étapes :
1.  **Arrêter (`stop`)** complètement le service `nginx`.
2.  Puis **démarrer (`start`)** le service `nginx`.

Cela provoque une **brève interruption de service**. Toutes les connexions existantes sont coupées et pendant un court instant, le serveur web n''est pas disponible. C''est différent de la commande `systemctl reload nginx`, qui demande à Nginx de recharger sa configuration sans couper les connexions existantes.

#### 3. Un redémarrage du système est-il nécessaire ?

*   **Non, absolument pas.**

La commande `systemctl` est conçue spécifiquement pour gérer des services individuels **sans avoir à redémarrer l''ensemble du système d''exploitation**. Le système d''exploitation (le noyau Linux) et tous les autres services (base de données, SSH, etc.) continueront de fonctionner normalement sans aucune interruption.

### En résumé

Ce script effectue une opération de maintenance ciblée et courante sur le serveur web Nginx. Il l''arrête complètement et le relance, ce qui a pour effet d''appliquer les changements de configuration qui auraient été faits dans ses fichiers. Cette opération provoque une interruption de service très brève pour Nginx uniquement et n''a **aucun impact** sur le reste du système.', NULL, NULL, '2025-08-08 16:01:29.628+00', '2025-08-08 16:01:29.628+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (6, 'simulate_execution', '073b681ddf253bc154979e1a52a9d1a787c7301ee0f92116b37fd019010f8e51', '#!/bin/bash

# 📍 Ce script centralise l’installation des cronjobs de monitoring

# 🔐 Vérifie que les scripts à exécuter existent
STATUS_SCRIPT="${STATUS_SCRIPT}"
SERVICES_SCRIPT="${SERVICES_SCRIPT}"

# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà
if [ -f "$STATUS_SCRIPT" ]; then
  grep -q "$STATUS_SCRIPT" /etc/crontab || echo "*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour status.sh"
else
  echo "❌ Script $STATUS_SCRIPT introuvable"
fi

if [ -f "$SERVICES_SCRIPT" ]; then
  grep -q "$SERVICES_SCRIPT" /etc/crontab || echo "*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT" >> /etc/crontab
  echo "✅ Cron job ajouté pour services_status.sh"
else
  echo "❌ Script $SERVICES_SCRIPT introuvable"
fi', 'Absolument ! Voici une description détaillée de ce que fera ce script lors de son exécution.

### Que se passera-t-il lors de son exécution ?

Le but principal de ce script est d''ajouter deux tâches planifiées (cron jobs) au système, mais de manière "intelligente" et sécurisée. Il le fait en suivant une logique précise pour chaque tâche :

1.  **Dépendance à des variables d''environnement** : Le script suppose que des variables d''environnement (`STATUS_SCRIPT`, `SERVICES_SCRIPT`, `STATUS_CRON_INTERVAL`, `SERVICES_CRON_INTERVAL`) ont été définies *avant* son lancement. Par exemple, il pourrait être exécuté comme ceci :
    ```bash
    STATUS_SCRIPT="/opt/monitoring/status.sh" \
    SERVICES_SCRIPT="/opt/monitoring/services_status.sh" \
    STATUS_CRON_INTERVAL=5 \
    SERVICES_CRON_INTERVAL=10 \
    ./votre_script.sh
    ```

2.  **Vérification du premier script (`status.sh`)** :
    *   Il vérifie si le fichier spécifié par la variable `$STATUS_SCRIPT` existe (`if [ -f "$STATUS_SCRIPT" ]`).
    *   **Si le fichier existe** :
        *   Il lit le fichier `/etc/crontab` et cherche (`grep -q`) si une ligne contient déjà le chemin du script (`$STATUS_SCRIPT`). Le `-q` signifie "silencieux", il ne fait que renvoyer un statut de succès ou d''échec.
        *   Si le chemin n''est **pas trouvé** (`||` signifie "OU"), il ajoute une nouvelle ligne à la fin du fichier `/etc/crontab`. Cette ligne sera, par exemple : `*/5 * * * * root /opt/monitoring/status.sh`.
        *   Si le chemin est **déjà trouvé**, il ne fait rien.
        *   Dans les deux cas (ajout ou déjà présent), il affiche le message : `✅ Cron job ajouté pour status.sh`.
    *   **Si le fichier n''existe pas** :
        *   Il affiche un message d''erreur : `❌ Script $STATUS_SCRIPT introuvable`.

3.  **Vérification du second script (`services_status.sh`)** :
    *   Il répète exactement la même logique pour le script défini dans `$SERVICES_SCRIPT` et l''intervalle `$SERVICES_CRON_INTERVAL`.

En résumé, le script s''assure que les scripts de monitoring existent avant de tenter d''ajouter une tâche cron, et il évite de créer des doublons dans le fichier `crontab`.

---

### Quelles ressources seront créées ou modifiées ?

La seule ressource système qui sera potentiellement modifiée est le fichier :
*   **/etc/crontab**

Ce fichier sera modifié par l''**ajout de nouvelles lignes** (une pour chaque script), mais uniquement si deux conditions sont remplies pour chaque ligne :
1.  Le script à exécuter existe bien sur le disque.
2.  Une tâche cron pour ce même script n''existe pas déjà dans `/etc/crontab`.

Aucun nouveau fichier n''est créé par le script lui-même (il s''attend à ce que les scripts de monitoring existent déjà).

---

### Quels services seront redémarrés ?

**Aucun service n''est explicitement redémarré par ce script.**

Cependant, le service `cron` (ou `crond` selon la distribution Linux) est conçu pour surveiller les changements dans ses fichiers de configuration, y compris `/etc/crontab`. Lorsqu''il détecte une modification, il **recharge automatiquement sa configuration** pour prendre en compte les nouvelles tâches.

Ce processus est transparent et automatique, il n''y a donc pas besoin d''une commande comme `systemctl restart cron`.

---

### Un redémarrage du système est-il nécessaire ?

**Non, absolument pas.**

Les modifications apportées au fichier `/etc/crontab` sont prises en compte "à chaud" par le service cron sans nécessiter le redémarrage ni du service lui-même, ni du système d''exploitation. Les nouvelles tâches planifiées deviendront actives dès que le service cron aura rechargé sa configuration (ce qui prend généralement moins d''une minute).', NULL, NULL, '2025-08-10 12:04:40.037+00', '2025-08-10 12:04:40.037+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (7, 'analyze_deployment_plan', '3aa37fcb7b5984fe4e84e0867b011ecc0d84d0a51cfe0f70f62b1ca20c5532c0', '{"vm_names":["ds-a-a-aa-a-a-a"],"template_name":"ubuntu-template","service_type":"monitoring__cron","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":10,"scripts":["monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]}', '', 'deployment_plan', NULL, '2025-08-12 12:06:23.209+00', '2025-08-12 12:06:23.209+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (8, 'analyze_deployment_plan', '0b026fab405433bd77bc1bab30b1c29604086ce973dc429ca7033e1b9ebbc249', '{"vm_names":["ds-a-a-aa-a-a-a-2"],"template_name":"ubuntu-template","service_type":"monitoring__cron","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":10,"scripts":["monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]}', 'Absolument. Voici une analyse détaillée de la configuration de la VM, accompagnée de suggestions d''améliorations et de recommandations.

---

### Analyse et Recommandations pour le Déploiement de la VM

Basé sur les paramètres fournis, la VM est destinée à exécuter des scripts de monitoring via des tâches planifiées (cron). C''est un cas d''usage courant mais qui nécessite une attention particulière pour être fiable et efficace.

#### 1. Analyse de la configuration actuelle

Globalement, la configuration est un point de départ fonctionnel, mais elle n''est pas optimale et présente plusieurs points de friction potentiels.

*   **Type de service (`monitoring__cron`)** :
    *   **Analyse** : Le rôle est clair. Il s''agit d''un serveur dédié à l''orchestration de scripts. La charge de travail sera probablement **périodique et en rafale** (pics d''utilisation lors de l''exécution des scripts) plutôt que constante.

*   **Ressources (2 vCPU, 2 Go de RAM)** :
    *   **Analyse** : C''est une configuration **prudente, voire surdimensionnée**. Les tâches cron, même si elles exécutent des scripts de monitoring, consomment rarement autant de ressources en continu. La plupart du temps, la VM sera inactive.
    *   **Verdict** : **Potentiellement sur-alloué.** On pourrait probablement démarrer avec moins et ajuster si nécessaire.

*   **Taille du disque (10 Go)** :
    *   **Analyse** : **Ceci est le point le plus critique et problématique de la configuration.** Une taille de 10 Go est extrêmement faible pour un serveur moderne.
        *   Un système d''exploitation Ubuntu Server de base occupe déjà entre 4 et 6 Go.
        *   Les scripts de monitoring vont générer des **logs**. Si la rotation des logs n''est pas gérée agressivement, le disque se remplira très rapidement, provoquant l''arrêt des services ou même du système.
        *   Il ne reste quasiment aucune marge pour les mises à jour du système, les paquets additionnels, ou les fichiers temporaires.
    *   **Verdict** : **Fortement sous-dimensionné et risqué.**

*   **Template (`ubuntu-template`)** :
    *   **Analyse** : Ubuntu est un excellent choix, stable et très répandu. Il est crucial de s''assurer que ce template est basé sur une version **LTS (Long-Term Support)**, comme Ubuntu 22.04 LTS, pour bénéficier de mises à jour de sécurité sur le long terme.
    *   **Verdict** : **Approprié**, à condition que la version soit LTS.

*   **Scripts** :
    *   **Analyse** : Les noms des scripts indiquent des tâches de surveillance système et de services. Il est important de savoir ce que ces scripts font exactement : collectent-ils des métriques ? Font-ils des appels API ? Écrivent-ils beaucoup de données ? La complexité de ces scripts est le facteur principal qui déterminera les besoins réels en CPU/RAM.
    *   **Verdict** : **Cohérent avec le rôle**, mais leur impact sur les ressources est une inconnue à valider.

---

#### 2. Suggestions d''améliorations (Pré-déploiement)

Voici des actions concrètes pour optimiser la configuration avant de lancer le déploiement.

##### Optimisation des ressources :

1.  **Augmenter la taille du disque (Priorité #1)** :
    *   **Recommandation** : Passer à **30 Go minimum**. 20 Go est un strict minimum acceptable. Cela offre une marge de manœuvre pour les logs, les mises à jour, et de potentiels outils supplémentaires. Le coût additionnel est marginal par rapport à la stabilité gagnée.

2.  **Réduire les vCPU et la RAM (pour commencer)** :
    *   **Recommandation** : Commencer avec **1 vCPU et 1 Go de RAM**. La plupart des plateformes de virtualisation permettent d''augmenter les ressources à chaud ou après un redémarrage rapide.
    *   **Justification** : C''est une approche "start small" (commencer petit). Il est plus économique et efficace de surveiller la charge réelle et d''ajouter des ressources si nécessaire, plutôt que de payer pour des ressources inutilisées.

##### Configurations alternatives :

1.  **Utiliser les Timers `systemd` au lieu de `cron`** :
    *   **Suggestion** : `systemd` (le gestionnaire de services et de système par défaut sur Ubuntu) propose des "timers" qui sont une alternative moderne et plus puissante à cron.
    *   **Avantages** :
        *   **Meilleure intégration** avec le système de logs (`journalctl`). Il est très facile de voir la sortie et les erreurs de chaque exécution.
        *   **Contrôle plus fin** sur l''environnement d''exécution (ressources, permissions).
        *   Dépendances entre les tâches plus faciles à gérer.

2.  **Envisager une approche "Serverless" (Fonctions Cloud)** :
    *   **Suggestion** : Si les scripts sont simples et s''exécutent périodiquement, l''utilisation de services comme **AWS Lambda, Google Cloud Functions ou Azure Functions** serait bien plus optimale.
    *   **Avantages** :
        *   **Pas de serveur à gérer** (mises à jour, sécurité, etc.).
        *   **Paiement à l''usage** (uniquement pour le temps d''exécution du script, souvent gratuit dans la limite d''un certain quota).
        *   Scalabilité automatique.

##### Services complémentaires :

1.  **Gestion centralisée des logs** :
    *   Ne laissez pas les logs sur la VM. Envoyez-les vers un service centralisé (ex: Graylog, ELK Stack, ou les services natifs du cloud provider comme AWS CloudWatch Logs). Cela évite de remplir le disque et facilite l''analyse et l''alerte.

2.  **Gestion de la configuration (IaC)** :
    *   Utilisez un outil comme **Ansible** ou **Terraform** pour déployer et configurer la VM. Cela garantit que le déploiement est reproductible, documenté et facile à mettre à jour.

---

#### 3. Recommandations Post-Déploiement

Une fois la VM déployée (avec les améliorations suggérées), voici les bonnes pratiques à mettre en place.

##### Performance :

1.  **Monitorer le moniteur** : Mettez en place un agent de monitoring (ex: `node_exporter` pour Prometheus, Datadog Agent) sur cette VM pour suivre sa propre consommation (CPU, RAM, disque, I/O).
2.  **Analyser les pics de charge** : Observez l''utilisation des ressources spécifiquement pendant l''exécution des scripts. Si le CPU atteint 100% pendant de longues périodes ou si la RAM est saturée, il sera temps d''augmenter les ressources.
3.  **Surveiller l''exécution des scripts** : Mettez en place un système de "heartbeat" (pulsation). À la fin d''une exécution réussie, le script "ping" une URL externe (ex: un service comme Healthchecks.io, Uptime Kuma). Si le ping n''est pas reçu dans le temps imparti, cela signifie que le cron n''a pas tourné ou a échoué, et une alerte est déclenchée. **C''est crucial pour la fiabilité d''un système basé sur cron.**

##### Sécurité :

1.  **Principe du moindre privilège** :
    *   Créez un **utilisateur dédié** pour exécuter les scripts. Ne les exécutez **jamais en tant que `root`**.
    *   Donnez à cet utilisateur les permissions minimales requises pour fonctionner (`sudo` uniquement pour les commandes qui en ont absolument besoin).
2.  **Mises à jour régulières** : Configurez les mises à jour de sécurité automatiques (`unattended-upgrades`) pour que le système soit toujours protégé contre les vulnérabilités connues.
3.  **Hardening du système** :
    *   Configurez le pare-feu (`ufw`) pour n''autoriser que le trafic nécessaire (ex: SSH depuis des IP de confiance).
    *   Sécurisez l''accès SSH : désactivez l''authentification par mot de passe au profit des clés SSH, et désactivez la connexion de l''utilisateur `root`.
4.  **Gestion des secrets** : Si les scripts utilisent des clés d''API, des mots de passe ou des tokens, ne les stockez **jamais en clair** dans les fichiers. Utilisez un gestionnaire de secrets comme **HashiCorp Vault** ou les services de gestion de secrets de votre fournisseur cloud (ex: AWS Secrets Manager, Azure Key Vault).

En résumé, la configuration proposée est un brouillon qui nécessite une **révision critique de la taille du disque** et une **optimisation des ressources CPU/RAM**. L''adoption de pratiques modernes (timers systemd, monitoring du moniteur, gestion de la configuration) transformera ce simple déploiement en une solution de monitoring robuste et professionnelle.', 'deployment_plan', NULL, '2025-08-12 12:09:05.077+00', '2025-08-12 12:09:05.077+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (9, 'analyze_dashboard', 'c02907bfd4c4d0e1722584970e2af40832c8a14dcc10ab54fdc935e754ac00bf', '{"totals":{"deployed":27,"success":17,"failed":6,"deleted":35},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":14,"deleted":2,"success":4,"failed":6}]}', 'Absolument. Voici une analyse de ces données destinée à un administrateur système, axée sur l''interprétation, les conclusions et les actions à entreprendre.

---

### **Analyse des déploiements et suppressions de VM**

Cette analyse porte sur la période du 6 au 12 août 2025.

#### **1. Tendances Marquantes et Points d''Attention**

L''analyse de la timeline révèle plusieurs tendances critiques qui nécessitent une attention immédiate.

*   **Pic d''échecs critique le 12/08 :** La journée du 12 août est un signal d''alarme majeur.
    *   **Activité :** C''est la journée avec le plus grand nombre de déploiements tentés (14).
    *   **Performance :** Le taux de succès s''est effondré à seulement **28%** (4 réussites sur 14 déploiements). Le taux d''échec confirmé est de **43%** (6 échecs).
    *   **Interprétation :** Le système de déploiement, qui était parfaitement fiable en début de période (100% de succès les 6, 8 et 9 août), a connu une défaillance sévère sous une charge plus élevée. **Quelque chose a changé** entre le 9 et le 12 août (nouvelle image, mise à jour de l''hyperviseur, changement de configuration réseau/stockage ?).

*   **Incohérence dans les métriques :**
    *   Au total, **27 VM** sont listées comme "déployées", mais la somme des succès (17) et des échecs (6) n''est que de **23**.
    *   Cette incohérence est particulièrement visible le 12/08 : 14 déploiements lancés, pour seulement 4 succès et 6 échecs. **Qu''est-il advenu des 4 VM restantes ?** Sont-elles dans un état "en attente", "inconnu" ou perdu ? Cela représente un risque potentiel de "VMs fantômes" consommant des ressources sans être suivies.

*   **Forte activité de suppression ("nettoyage") :**
    *   Avec **35 suppressions** pour seulement 27 déploiements, la tendance globale est à la réduction du parc de VM.
    *   Le 6/08 a vu un nettoyage massif (27 suppressions), ce qui suggère la fin d''un projet, une migration ou une opération de maintenance planifiée. Ce contexte est important : l''activité n''est pas chaotique mais semble dictée par des événements spécifiques.

#### **2. Conclusion sur l''État Global**

L''état des déploiements est **préoccupant et instable**.

Bien que le système ait prouvé sa capacité à fonctionner parfaitement, sa fiabilité s''est brutalement dégradée. Un taux d''échec global de **26%** (6 échecs sur 23 déploiements terminés) est inacceptable pour un environnement de production.

Le problème principal n''est pas le volume, mais **la fragilité du processus de déploiement face à une charge ou à un changement récent**. La confiance dans l''automatisation est actuellement rompue.

#### **3. Recommandations et Plan d''Action**

Voici les actions recommandées, classées par ordre de priorité.

**A. Investigation Immédiate (Urgent)**

1.  **Analyser les 6 échecs du 12/08 :**
    *   **Action :** Plongez dans les logs (orchestrateur, hyperviseur, stockage) pour ces 6 déploiements. Identifiez la cause racine : timeout, erreur de configuration, problème d''accès au stockage, quota dépassé, bug dans le script de post-installation ?
2.  **Identifier les "VMs fantômes" :**
    *   **Action :** Retrouvez la trace des 4 déploiements non comptabilisés du 12/08. Sont-ils bloqués en cours de création ? Ont-ils été créés mais l''outil de reporting n''a pas reçu la confirmation ? Il est crucial de clarifier leur état pour éviter une consommation de ressources cachée.
3.  **Identifier le "facteur X" du 12/08 :**
    *   **Action :** Passez en revue le journal des changements (changelog). Qu''est-ce qui a été modifié entre le 9 et le 12 août ? Une nouvelle image de VM a-t-elle été utilisée ? Un patch de sécurité a-t-il été appliqué à l''infrastructure ? C''est le suspect principal.

**B. Améliorations à Moyen Terme**

4.  **Fiabiliser le reporting :**
    *   **Action :** Modifiez le script ou l''outil de monitoring pour qu''il n''y ait plus de déploiements non suivis. Chaque tentative doit se terminer par un statut clair : `succès`, `échec`, ou `annulé`.
5.  **Mettre en place des tests de validation d''image :**
    *   **Action :** Avant de mettre une nouvelle image ou un nouveau template en production, faites-lui passer une batterie de tests automatisés, incluant un déploiement test. Cela aurait probablement intercepté le problème avant le 12/08.
6.  **Renforcer l''alerting :**
    *   **Action :** Configurez des alertes qui se déclenchent si le taux d''échec des déploiements dépasse un certain seuil (ex: >10%) sur une période donnée (ex: 1 heure). Vous auriez ainsi été notifié en temps réel de la dégradation le 12/08.

**C. Stratégie à Long Terme**

7.  **Implémenter un mécanisme de Rollback automatique :**
    *   **Action :** Pour les déploiements critiques, mettez en place une procédure qui, en cas d''échec, nettoie automatiquement les ressources partiellement créées (IP, disque, VM) pour revenir à un état propre.
8.  **Effectuer des tests de charge :**
    *   **Action :** La défaillance ayant eu lieu lors d''un pic d''activité, planifiez des tests de charge trimestriels sur votre infrastructure de déploiement pour identifier les goulots d''étranglement avant qu''ils n''impactent la production.', NULL, NULL, '2025-08-12 12:12:39.36+00', '2025-08-12 12:12:39.36+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (10, 'analyze_script', '48df1a645e4f6104c66f0e367b39e5633b2854bd7b88e7a3798b052df8716135', '#!/bin/bash
set -euo pipefail

# === Variables substituées par le moteur de template ===
SCRIPT_PATH="/opt/monitoring/monitoring.sh"
STATUS_SCRIPT_PATH="/opt/monitoring/status.sh"
SERVICES_SCRIPT_PATH="/opt/monitoring/services_status.sh"
STATUS_CRON_EXPR=''*/1 * * * *''
SERVICES_CRON_EXPR=''*/1 * * * *''
CRON_USER=''nexus''

MONITOR_DIR="$(dirname "/opt/monitoring/status.sh")"
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

mkdir -p "${MONITOR_DIR}"

# --- Génère le script  ---
cat > "/opt/monitoring/monitoring.sh" <<''EOS''
#!/bin/bash
set -euo pipefail

STATUS_SCRIPT_PATH="__STATUS_SCRIPT_PATH__"
SERVICES_SCRIPT_PATH="__SERVICES_SCRIPT_PATH__"
STATUS_CRON_EXPR=''__STATUS_CRON_EXPR__''
SERVICES_CRON_EXPR=''__SERVICES_CRON_EXPR__''
CRON_USER=''__CRON_USER__''
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

exists_and_exec() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  [[ -x "$f" ]] || chmod +x "$f" || true
  return 0
}

crontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }
crontab_set() { crontab -u "$CRON_USER" -; }

add_cron_once() {
  local expr="$1" cmd="$2" mark="$3"
  local current
  current="$(crontab_get)"
  if ! echo "$current" | grep -Fq "$mark"; then
    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set
  fi
}

remove_mark() {
  local mark="$1"
  crontab_get | grep -Fv "$mark" | crontab_set
}

ok=1
if exists_and_exec "$STATUS_SCRIPT_PATH"; then
  add_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1" "$MARK_STATUS"
else
  ok=0
fi

if exists_and_exec "$SERVICES_SCRIPT_PATH"; then
  add_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1" "$MARK_SERVICES"
else
  ok=0
fi

if [[ "$ok" -eq 1 ]]; then
  # Exécuter une première fois pour générer les JSON immédiatement
  bash "$STATUS_SCRIPT_PATH" || true
  bash "$SERVICES_SCRIPT_PATH" || true
  # Se retirer du crontab
  remove_mark "$MARK_BOOT"
fi
EOS

# Injecte les variables réelles dans le 
sed -i \
  -e "s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\//\\/}#g" \
  -e "s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\//\\/}#g" \
  -e "s#__CRON_USER__#nexus#g" \
  "/opt/monitoring/monitoring.sh"

chmod +x "/opt/monitoring/monitoring.sh"

# --- (Ré)active le service cron/ crond ---
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true
fi

# --- Installe le cron  (toutes les minutes) ---
current_cron="$(crontab -u "nexus" -l 2>/dev/null || true)"
if ! echo "$current_cron" | grep -Fq "$MARK_BOOT"; then
  { echo "$current_cron" | grep -Fv "$MARK_BOOT"; echo "* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT"; } | crontab -u "nexus" -
fi

exit 0
', 'Absolument. Voici une analyse détaillée, des alternatives et une version améliorée de votre script.

---

### 1. Analyse du script original

Ce script a un objectif clair : mettre en place de manière asynchrone des tâches cron pour monitorer une application, mais seulement lorsque les scripts de monitoring (`status.sh`, `services_status.sh`) sont effectivement présents sur le système.

**Points forts :**
*   **Idempotence :** L''utilisation de marqueurs (`# MONITORING_...`) dans le crontab est une bonne pratique pour éviter d''ajouter des tâches en double. Le script peut être exécuté plusieurs fois sans causer de problèmes.
*   **Séparation des privilèges :** Le cron final est configuré pour s''exécuter avec un utilisateur non-privilégié (`nexus`), ce qui est excellent pour la sécurité.
*   **Robustesse de base :** L''utilisation de `set -euo pipefail` est une très bonne pratique pour rendre les scripts plus sûrs.
*   **Logique de "bootstrap" :** Le script d''installation (`monitoring.sh`) se retire lui-même du crontab une fois sa mission accomplie. C''est une conception intelligente pour une tâche de configuration unique.

**Points faibles et améliorations possibles :**
1.  **Complexité inutile :** Le script génère un autre script (`monitoring.sh`) via un *heredoc* puis utilise `sed` pour substituer les variables. C''est une approche fonctionnelle mais complexe et sujette aux erreurs (caractères spéciaux dans les variables, etc.).
2.  **Manipulation directe du crontab :** L''enchaînement `crontab -l | ... | crontab -` est une pratique courante mais fragile. Elle n''est pas atomique et peut être sujette à des "race conditions" (conditions de concurrence) si un autre processus modifie le crontab au même moment. Les modifications peuvent être perdues.
3.  **Polling intensif :** Le script de "bootstrap" (`monitoring.sh`) est exécuté toutes les minutes. C''est beaucoup pour une tâche de configuration qui ne réussira qu''une seule fois. Cela génère une charge et des logs inutiles en attendant que les scripts dépendants soient déployés.
4.  **Nom de fonction ambigu :** La fonction `exists_and_exec` ne fait pas ce que son nom indique. Elle vérifie l''existence et *rend* le fichier exécutable (`chmod +x`), mais ne l''exécute pas. Un nom comme `ensure_is_executable` serait plus clair.
5.  **Gestion des erreurs masquée :** L''utilisation de `|| true` à plusieurs endroits (ex: `systemctl ... || true`) peut masquer des problèmes de configuration réels (par exemple, si le service cron n''existe vraiment pas sous les noms `cron` ou `crond`).
6.  **Dépendance à `crontab` :** Le script suppose que l''utilisateur `nexus` a le droit d''utiliser `crontab` et que le binaire est disponible.

---

### 2. Alternatives et pratiques modernes

1.  **Utiliser `/etc/cron.d/` (Alternative la plus simple et robuste) :**
    *   Au lieu de manipuler le crontab d''un utilisateur, on peut déposer des fichiers de configuration directement dans le répertoire `/etc/cron.d/`.
    *   **Avantages :**
        *   **Atomicité :** La création de fichier est atomique (on peut écrire dans un fichier temporaire puis le renommer avec `mv`).
        *   **Clarté :** Les tâches cron sont visibles par les administrateurs système dans un emplacement standard.
        *   **Gestion centralisée :** Facile à gérer avec des outils de configuration comme Ansible, Puppet, etc.
        *   **Pas de `crontab -e` :** On n''interfère pas avec les modifications manuelles que l''utilisateur pourrait faire sur son propre crontab.
    *   Le format est légèrement différent, il inclut le nom de l''utilisateur : `* * * * * <utilisateur> <commande>`.

2.  **Systemd Timers (Alternative moderne sur les systèmes récents) :**
    *   Sur la plupart des distributions Linux modernes, `systemd` a remplacé cron. Les *timers* sont plus flexibles et plus puissants.
    *   **Avantages :**
        *   **Journalisation intégrée :** La sortie de chaque exécution est capturée par `journald` (`journalctl -u mon-service.service`).
        *   **Flexibilité :** Déclenchements plus complexes (ex: "5 minutes après le démarrage", "toutes les 15 minutes entre 9h et 17h").
        *   **Gestion des dépendances :** Peut être lié à des services réseau ou à d''autres unités systemd.
    *   **Inconvénient :** Un peu plus verbeux à mettre en place (nécessite un fichier `.timer` et un fichier `.service`).

3.  **Simplification du Script (Approche générale) :**
    *   Éviter la génération de script en deux temps. Le script d''installation peut contenir toute la logique. Si une variable est nécessaire, elle peut être passée en paramètre ou lue depuis un fichier de configuration. Le *heredoc* avec expansion de variable (`<<EOF` au lieu de `<<''EOF''`) est beaucoup plus simple que la substitution avec `sed`.

---

### 3. Version optimisée du script

Cette version révisée applique les meilleures pratiques discutées :
*   Elle n''utilise **qu''un seul script**.
*   Elle utilise **`/etc/cron.d/`** pour une gestion robuste et atomique des tâches cron.
*   La logique est simplifiée et plus facile à lire.
*   Elle s''exécute en tant que `root` (nécessaire pour écrire dans `/etc/cron.d/`) mais s''assure que les tâches finales s''exécutent en tant que `nexus`.

```bash
#!/bin/bash
set -euo pipefail

# === Variables de configuration ===
# Le script doit être exécuté en tant que root.

# Scripts à surveiller et à exécuter
STATUS_SCRIPT_PATH="/opt/monitoring/status.sh"
SERVICES_SCRIPT_PATH="/opt/monitoring/services_status.sh"

# Configuration des tâches Cron finales
STATUS_CRON_EXPR=''*/1 * * * *''
SERVICES_CRON_EXPR=''*/1 * * * *''
CRON_USER=''nexus''

# Fichiers Cron gérés par ce script
# Le fichier de bootstrap sera supprimé une fois la configuration terminée.
CRON_BOOTSTRAP_FILE="/etc/cron.d/app-monitoring-setup"
CRON_FINAL_FILE="/etc/cron.d/app-monitoring"

# --- Fonctions utilitaires ---

# Affiche un message et quitte avec un code d''erreur.
fail() {
  echo "ERREUR: $*" >&2
  exit 1
}

# S''assure qu''un fichier existe et est exécutable.
ensure_executable() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  # Ne change les permissions que si nécessaire.
  [[ -x "$f" ]] || chmod +x "$f"
}

# --- Début du script ---

# 1. Vérification des prérequis
if [[ "$(id -u)" -ne 0 ]]; then
  fail "Ce script doit être exécuté en tant que root pour gérer les fichiers dans /etc/cron.d/"
fi

# 2. Création du répertoire de monitoring
mkdir -p "$(dirname "$STATUS_SCRIPT_PATH")"

# 3. Logique principale : vérifier si la configuration finale peut être appliquée
if ensure_executable "$STATUS_SCRIPT_PATH" && ensure_executable "$SERVICES_SCRIPT_PATH"; then
  # CAS 1 : Les deux scripts de monitoring existent. On peut finaliser l''installation.
  
  echo "Scripts de monitoring détectés. Configuration finale en cours..."

  # Création du fichier cron final avec les tâches de monitoring.
  # L''utilisation de `tee` permet de gérer les permissions sans `sudo` dans un heredoc.
  tee "$CRON_FINAL_FILE" > /dev/null <<EOF
# Fichier Cron pour le monitoring de l''application - Géré automatiquement
# Tâche de statut global
$STATUS_CRON_EXPR $CRON_USER bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1

# Tâche de statut des services
$SERVICES_CRON_EXPR $CRON_USER bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1
EOF
  # S''assure que le fichier cron a les bonnes permissions (lecture pour tous)
  chmod 0644 "$CRON_FINAL_FILE"

  echo "Tâches Cron finales installées dans $CRON_FINAL_FILE."

  # Exécuter une première fois pour générer les JSON immédiatement
  # On utilise `sudo -u` pour lancer la commande en tant que l''utilisateur cible
  echo "Exécution initiale des scripts..."
  sudo -u "$CRON_USER" bash "$STATUS_SCRIPT_PATH" || echo "Avertissement: l''exécution initiale de status.sh a échoué."
  sudo -u "$CRON_USER" bash "$SERVICES_SCRIPT_PATH" || echo "Avertissement: l''exécution initiale de services_status.sh a échoué."

  # Supprimer le cron de bootstrap, car il n''est plus nécessaire.
  if [[ -f "$CRON_BOOTSTRAP_FILE" ]]; then
    rm -f "$CRON_BOOTSTRAP_FILE"
    echo "Le cron de bootstrap a été supprimé."
  fi

  echo "Configuration du monitoring terminée."

else
  # CAS 2 : Au moins un des scripts de monitoring est manquant. On met en place le polling.

  # Ne crée le fichier de bootstrap que s''il n''existe pas déjà.
  if [[ ! -f "$CRON_FINAL_FILE" ]]; then
    echo "Scripts de monitoring non trouvés. Mise en place d''une vérification périodique."
    
    # Le cron exécute ce même script en tant que root toutes les minutes.
    # `flock` empêche les exécutions multiples si le script prend plus d''une minute.
    tee "$CRON_BOOTSTRAP_FILE" > /dev/null <<EOF
# Fichier Cron pour installer le monitoring de l''application - Géré automatiquement
# Ce fichier sera supprimé une fois l''installation terminée.
* * * * * root flock -n /tmp/monitoring-setup.lock bash $0
EOF
    chmod 0644 "$CRON_BOOTSTRAP_FILE"
    echo "Ce script sera ré-exécuté toutes les minutes jusqu''à ce que les dépendances soient satisfaites."
  else
    echo "La configuration finale est déjà en place. Aucune action requise."
  fi
fi

# 4. (Ré)activer le service cron/crond si possible
if command -v systemctl >/dev/null 2>&1; then
  if ! systemctl is-active --quiet cron && ! systemctl is-active --quiet crond; then
    echo "Activation du service cron..."
    systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || \
      echo "Avertissement: Impossible de démarrer le service ''cron'' ou ''crond''."
  fi
fi

exit 0
```

### Résumé des améliorations de la nouvelle version :

1.  **Simplicité :** Un seul script, pas de génération de code ni de `sed`. La logique est linéaire et plus facile à suivre.
2.  **Robustesse :** Utilise `/etc/cron.d/` pour éviter les conditions de concurrence et pour une gestion plus propre. L''ajout de `flock` dans le cron de bootstrap empêche que le script ne s''exécute plusieurs fois en parallèle s''il venait à être long.
3.  **Clarté :** Les noms de variables et les commentaires expliquent l''intention. Le script informe l''utilisateur de ce qu''il fait.
4.  **Sécurité :** Vérifie qu''il est exécuté en tant que `root` (une nécessité pour cette approche), mais délègue bien l''exécution finale à l''utilisateur non-privilégié.
5.  **Moins de "bruit" :** Le cron de bootstrap ne se recrée pas à chaque exécution, et la logique de polling est clairement séparée du cas de succès.', 'script', 29, '2025-08-12 12:19:37.531+00', '2025-08-12 12:19:37.531+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (11, 'analyze_dashboard', '3e9248198b7429a42e1131f5e5c7a1ad13e1f5e75701d0a18c73892f2e19c90a', '{"totals":{"deployed":29,"success":17,"failed":9,"deleted":35},"timeline":[{"period":"2025-08-06","deployed":10,"deleted":27,"success":10,"failed":0},{"period":"2025-08-08","deployed":2,"deleted":3,"success":2,"failed":0},{"period":"2025-08-09","deployed":1,"deleted":0,"success":1,"failed":0},{"period":"2025-08-11","deployed":0,"deleted":3,"success":0,"failed":0},{"period":"2025-08-12","deployed":16,"deleted":2,"success":4,"failed":9}]}', '', NULL, NULL, '2025-08-12 14:24:00.448+00', '2025-08-12 14:24:00.448+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (12, 'analyze_script', '9ac31ca7d453411c34005540a32232db56f18235581c0968c018fa73796a9a1e', '#!/bin/bash

# 📁 Créer le dossier de monitoring s’il n’existe pas
mkdir -p /opt/monitoring

# 📦 Créer le script de surveillance des services
cat <<''EOS'' > ${SERVICES_SCRIPT_PATH}
#!/bin/bash

# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent
if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"

SERVICES=(
  sshd ufw fail2ban cron crond nginx apache2 mysql
  mariadb postgresql docker kubelet redis-server
  mongod vsftpd proftpd php-fpm
)

SERVICE_STATUS_JSON=""
for svc in "${SERVICES[@]}"; do
  if systemctl list-units --type=service --all | grep -q "$svc"; then
    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)
    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)
    SERVICE_STATUS_JSON+="{\"name\":\"$svc\",\"active\":\"$ACTIVE\",\"enabled\":\"$ENABLED\"},"
  fi
done

SERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"

cat <<JSON > ${SERVICES_JSON_PATH}
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "services": ${SERVICE_STATUS_JSON}
}
JSON
EOS

chmod +x ${SERVICES_SCRIPT_PATH}', '', 'template', 27, '2025-08-12 15:18:23.628+00', '2025-08-12 15:18:23.628+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (13, 'analyze_script', '7db4448cb4b589027a8f905cc2af52058124164c84a5ab152f8ff758ac4293c4', '#!/bin/bash

# 📁 Créer le dossier de monitoring s’il n’existe pas
mkdir -p /opt/monitoring

# 📦 Créer le script de surveillance système
cat <<''EOS'' > ${STATUS_SCRIPT_PATH}
#!/bin/bash

# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent
if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk ''{print $1}'')
LOAD_AVG=$(cut -d '' '' -f1-3 /proc/loadavg)
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk ''{print $2}'')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk ''{print $2}'')

DISK_TOTAL=$(df -B1 / | tail -1 | awk ''{print $2}'')
DISK_USED=$(df -B1 / | tail -1 | awk ''{print $3}'')
DISK_AVAIL=$(df -B1 / | tail -1 | awk ''{print $4}'')

IFACE=$(ip route get 1.1.1.1 | awk ''{print $5; exit}'')
RX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

OPEN_PORTS=$(ss -tuln | awk ''NR>1 {split($5,a,":"); print a[length(a)]}'' | sort -n | uniq | paste -sd, -)

TOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk ''{printf "{\"pid\":%s,\"cmd\":\"%s\",\"cpu\":%s},", $1, $2, $3}'')
TOP_PROCESSES="[${TOP_PROCESSES%,}]"

cat <<JSON > ${STATUS_JSON_PATH}
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "hostname": "${HOSTNAME}",
  "ip_address": "${IP_ADDR}",
  "load_average": "${LOAD_AVG}",
  "memory": {
    "total_kb": ${MEM_TOTAL},
    "available_kb": ${MEM_AVAILABLE}
  },
  "disk": {
    "total_bytes": ${DISK_TOTAL},
    "used_bytes": ${DISK_USED},
    "available_bytes": ${DISK_AVAIL}
  },
  "network": {
    "interface": "${IFACE}",
    "rx_bytes": ${RX_BYTES},
    "tx_bytes": ${TX_BYTES}
  },
  "open_ports": [${OPEN_PORTS}],
  "top_processes": ${TOP_PROCESSES}
}
JSON
EOS

chmod +x ${STATUS_SCRIPT_PATH}', 'Absolument ! Voici une analyse détaillée, des alternatives modernes, et une version optimisée de votre script.

### 1. Analyse et Améliorations Possibles

Votre script est un bon point de départ, typique de ce qu''on trouve dans les scripts de *bootstrap* ou *user-data* pour des instances cloud. Cependant, plusieurs points peuvent être améliorés en termes de robustesse, d''efficacité et de bonnes pratiques.

**Points forts :**

*   **Idempotence :** `mkdir -p` est une bonne pratique, car il ne génère pas d''erreur si le dossier existe déjà.
*   **Heredoc avec guillemets simples :** `cat <<''EOS''` est excellent. L''utilisation des guillemets simples `''''` autour de `EOS` empêche le shell *externe* d''interpréter les variables (`${...}`) à l''intérieur du bloc, les laissant pour le script *interne*, ce qui est l''intention ici.
*   **Portabilité :** L''utilisation d''outils standards (`cut`, `awk`, `grep`, `df`, `ss`) le rend assez portable sur la plupart des systèmes Linux.

**Points faibles et axes d''amélioration :**

1.  **Variables non définies :** Les variables `${STATUS_SCRIPT_PATH}` et `${STATUS_JSON_PATH}` sont utilisées mais jamais définies dans le script de template. C''est le bug le plus critique. Le script échouera tel quel.
2.  **Inefficacité des commandes :**
    *   `grep` et `awk` sont appelés deux fois pour lire `/proc/meminfo`. Un seul appel à `awk` peut extraire les deux valeurs.
    *   `df` est appelé trois fois pour obtenir trois colonnes de la même ligne. Un seul appel suffit.
3.  **Fragilité du parsing :**
    *   **`TOP_PROCESSES` est très fragile :** La commande `awk ''{printf "{\"pid\":%s,\"cmd\":\"%s\",\"cpu\":%s},", $1, $2, $3}''` suppose que le nom de la commande (`comm`) ne contient pas d''espaces. Si un processus s''appelle', 'template', 26, '2025-08-12 15:26:43.364+00', '2025-08-12 15:26:43.364+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (14, 'analyze_script', 'dfe259700db150048a8ef9085c096591423d29d4814c61444642089562c67d97', '#!/bin/bash
set -euo pipefail

# === Variables substituées par le moteur de template ===
SCRIPT_PATH="${SCRIPT_PATH}"
STATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH}"
SERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH}"
STATUS_CRON_EXPR=''${STATUS_CRON_EXPR}''
SERVICES_CRON_EXPR=''${SERVICES_CRON_EXPR}''
CRON_USER=''${CRON_USER}''

MONITOR_DIR="$(dirname "${STATUS_SCRIPT_PATH}")"
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

mkdir -p "${MONITOR_DIR}"

# --- Génère le script  ---
cat > "${SCRIPT_PATH}" <<''EOS''
#!/bin/bash
set -euo pipefail

STATUS_SCRIPT_PATH="__STATUS_SCRIPT_PATH__"
SERVICES_SCRIPT_PATH="__SERVICES_SCRIPT_PATH__"
STATUS_CRON_EXPR=''__STATUS_CRON_EXPR__''
SERVICES_CRON_EXPR=''__SERVICES_CRON_EXPR__''
CRON_USER=''__CRON_USER__''
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

exists_and_exec() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  [[ -x "$f" ]] || chmod +x "$f" || true
  return 0
}

crontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }
crontab_set() { crontab -u "$CRON_USER" -; }

add_cron_once() {
  local expr="$1" cmd="$2" mark="$3"
  local current
  current="$(crontab_get)"
  if ! echo "$current" | grep -Fq "$mark"; then
    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set
  fi
}

remove_mark() {
  local mark="$1"
  crontab_get | grep -Fv "$mark" | crontab_set
}

ok=1
if exists_and_exec "$STATUS_SCRIPT_PATH"; then
  add_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1" "$MARK_STATUS"
else
  ok=0
fi

if exists_and_exec "$SERVICES_SCRIPT_PATH"; then
  add_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1" "$MARK_SERVICES"
else
  ok=0
fi

if [[ "$ok" -eq 1 ]]; then
  # Exécuter une première fois pour générer les JSON immédiatement
  bash "$STATUS_SCRIPT_PATH" || true
  bash "$SERVICES_SCRIPT_PATH" || true
  # Se retirer du crontab
  remove_mark "$MARK_BOOT"
fi
EOS

# Injecte les variables réelles dans le 
sed -i \
  -e "s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\//\\/}#g" \
  -e "s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\//\\/}#g" \
  -e "s#__CRON_USER__#${CRON_USER}#g" \
  "${SCRIPT_PATH}"

chmod +x "${SCRIPT_PATH}"

# --- (Ré)active le service cron/ crond ---
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true
fi

# --- Installe le cron  (toutes les minutes) ---
current_cron="$(crontab -u "${CRON_USER}" -l 2>/dev/null || true)"
if ! echo "$current_cron" | grep -Fq "$MARK_BOOT"; then
  { echo "$current_cron" | grep -Fv "$MARK_BOOT"; echo "* * * * * ${SCRIPT_PATH} $MARK_BOOT"; } | crontab -u "${CRON_USER}" -
fi

exit 0
', '', 'template', 25, '2025-08-12 15:27:39.943+00', '2025-08-12 15:27:39.943+00');
INSERT INTO "public"."ai_cache" ("id", "type", "hash", "input_text", "response_text", "entity_type", "entity_id", "created_at", "updated_at") VALUES (15, 'summarize_logs', '7f287a07cd8c65322d1ce7831bf571c920fc26daf6b2953e4b5aca15141638ef', '==== DÉPLOIEMENT monitoring__cron ====
📅 Début : 2025-08-12T15:35:17.365Z
👤 User: latifnjimoluh@gmail.com
🔧 VM: webytest

==== LANCEMENT Terraform (runId=20) ====
CWD: D:\Keyce_B3\Soutenance\linusupervisor-back\backend\terraform\deployments\20
CMD: terraform init -input=false -upgrade=false && terraform apply -auto-approve -var-file=variables.tfvars.json

[0m[1mInitializing the backend...[0m
[0m[1mInitializing provider plugins...[0m
- Finding latest version of hashicorp/local...
- Finding latest version of hashicorp/null...
- Finding telmate/proxmox versions matching "3.0.2-rc01"...
- Installing hashicorp/local v2.5.3...
- Installed hashicorp/local v2.5.3 (signed by HashiCorp)
- Installing hashicorp/null v3.2.4...
- Installed hashicorp/null v3.2.4 (signed by HashiCorp)
- Installing telmate/proxmox v3.0.2-rc01...
- Installed telmate/proxmox v3.0.2-rc01 (self-signed, key ID [0m[1mA9EBBE091B35AFCE[0m[0m)
Partner and community providers are signed by their developers.
If you''d like to know more about provider signing, you can read about it here:
https://developer.hashicorp.com/terraform/cli/plugins/signing
Terraform has created a lock file [1m.terraform.lock.hcl[0m to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.[0m

[0m[1m[32mTerraform has been successfully initialized![0m[32m[0m
[0m[32m
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.[0m

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  [32m+[0m create[0m

Terraform will perform the following actions:

[1m  # null_resource.run_scripts["webytest"][0m will be created
[0m  [32m+[0m[0m resource "null_resource" "run_scripts" {
      [32m+[0m[0m id       = (known after apply)
      [32m+[0m[0m triggers = {
          [32m+[0m[0m "always_run" = (known after apply)
        }
    }

[1m  # proxmox_vm_qemu.vm["webytest"][0m will be created
[0m  [32m+[0m[0m resource "proxmox_vm_qemu" "vm" {
      [32m+[0m[0m additional_wait        = 5
      [32m+[0m[0m agent                  = 1
      [32m+[0m[0m agent_timeout          = 90
      [32m+[0m[0m automatic_reboot       = true
      [32m+[0m[0m balloon                = 0
      [32m+[0m[0m bios                   = "seabios"
      [32m+[0m[0m boot                   = (known after apply)
      [32m+[0m[0m bootdisk               = "scsi0"
      [32m+[0m[0m cipassword             = (sensitive value)
      [32m+[0m[0m ciupgrade              = false
      [32m+[0m[0m ciuser                 = "nexus"
      [32m+[0m[0m clone                  = "ubuntu-template"
      [32m+[0m[0m clone_wait             = 10
      [32m+[0m[0m current_node           = (known after apply)
      [32m+[0m[0m default_ipv4_address   = (known after apply)
      [32m+[0m[0m default_ipv6_address   = (known after apply)
      [32m+[0m[0m define_connection_info = true
      [32m+[0m[0m desc                   = "Managed by Terraform."
      [32m+[0m[0m force_create           = false
      [32m+[0m[0m full_clone             = true
      [32m+[0m[0m hotplug                = "network,disk,usb"
      [32m+[0m[0m id                     = (known after apply)
      [32m+[0m[0m ipconfig0              = "ip=dhcp"
      [32m+[0m[0m kvm                    = true
      [32m+[0m[0m linked_vmid            = (known after apply)
      [32m+[0m[0m memory                 = 2048
      [32m+[0m[0m name                   = "webytest"
      [32m+[0m[0m onboot                 = true
      [32m+[0m[0m os_type                = "cloud-init"
      [32m+[0m[0m protection             = false
      [32m+[0m[0m reboot_required        = (known after apply)
      [32m+[0m[0m scsihw                 = "virtio-scsi-single"
      [32m+[0m[0m skip_ipv4              = false
      [32m+[0m[0m skip_ipv6              = false
      [32m+[0m[0m ssh_host               = (known after apply)
      [32m+[0m[0m ssh_port               = (known after apply)
      [32m+[0m[0m sshkeys                = <<-EOT
            ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDpzZk553L5CBy6MxS0pfsMDBXDgwI/W7jDVt6LOTrmz8Mn9L0ekk9op6xrJZqxOnnDYMV/VdWnZs9mJ06lSgvvOzzsbvjklu9UwxNJFtOjjBSrpCz7nD5M3N0oAD301kYHdDoeLai7DB27VAZiGkItJYIi6wtfa7CKy21z+lM9qE7n91u4PY2fMNskFVg9vdtDjxmTjp6cbalA3i8iL/vZJ2bUSkmCIsCEtoij/LdzixbcJRKMfXsfNJh2zoxt6GSOx5/rRZbgu0OOgKmJlRAn77OMAAnEqOieDZ4nna2B72CNfTOnkY2cc0/iytr5cZkBWHbfq9xYBsETVuw/6A7rZGiFFMTvxtFYuQhQUKJ/cLaVFR+RJ7BvSUZyd6jG40mG51+LWoOwf6N+38yljFItb5QEowek3ra5ycAGbnimeu3PcDvEIWDNsrAqGzWtGYaQin/DrHZZtmAL2L+5qBIdFd/jo1xlIrFRRSiCEEcPU5zBMycTZnVsXtn6QNZUzemGRtWkSMZB9yu/YgAT2EL1xHo76ai0o3VmI7LxZvBRIzaf3ejQpXLfd15XR8thHFGha4lPQ9T75fWZW/NtKTQ0b0UYdfxHJqAZc+fy71rTqQ7E0CkIieXuRsA5JMOjmcXjQtnoBrP+0hNIHMpThKTsA1BQsxZ7UU6w7bI4vIfbYw== nexus-pc@Nexus-PC-Victus
        EOT
      [32m+[0m[0m tablet                 = true
      [32m+[0m[0m tags                   = (known after apply)
      [32m+[0m[0m target_node            = "pve"
      [32m+[0m[0m unused_disk            = (known after apply)
      [32m+[0m[0m vm_state               = "running"
      [32m+[0m[0m vmid                   = (known after apply)

      [32m+[0m[0m cpu {
          [32m+[0m[0m cores   = 2
          [32m+[0m[0m limit   = 0
          [32m+[0m[0m numa    = false
          [32m+[0m[0m sockets = 1
          [32m+[0m[0m type    = "host"
          [32m+[0m[0m units   = 0
          [32m+[0m[0m vcores  = 0
        }

      [32m+[0m[0m disk {
          [32m+[0m[0m backup               = true
          [32m+[0m[0m id                   = (known after apply)
          [32m+[0m[0m iops_r_burst         = 0
          [32m+[0m[0m iops_r_burst_length  = 0
          [32m+[0m[0m iops_r_concurrent    = 0
          [32m+[0m[0m iops_wr_burst        = 0
          [32m+[0m[0m iops_wr_burst_length = 0
          [32m+[0m[0m iops_wr_concurrent   = 0
          [32m+[0m[0m iothread             = true
          [32m+[0m[0m linked_disk_id       = (known after apply)
          [32m+[0m[0m mbps_r_burst         = 0
          [32m+[0m[0m mbps_r_concurrent    = 0
          [32m+[0m[0m mbps_wr_burst        = 0
          [32m+[0m[0m mbps_wr_concurrent   = 0
          [32m+[0m[0m passthrough          = false
          [32m+[0m[0m size                 = "18G"
          [32m+[0m[0m slot                 = "scsi0"
          [32m+[0m[0m storage              = "local-lvm"
          [32m+[0m[0m type                 = "disk"
        }
      [32m+[0m[0m disk {
          [32m+[0m[0m backup               = true
          [32m+[0m[0m id                   = (known after apply)
          [32m+[0m[0m iops_r_burst         = 0
          [32m+[0m[0m iops_r_burst_length  = 0
          [32m+[0m[0m iops_r_concurrent    = 0
          [32m+[0m[0m iops_wr_burst        = 0
          [32m+[0m[0m iops_wr_burst_length = 0
          [32m+[0m[0m iops_wr_concurrent   = 0
          [32m+[0m[0m linked_disk_id       = (known after apply)
          [32m+[0m[0m mbps_r_burst         = 0
          [32m+[0m[0m mbps_r_concurrent    = 0
          [32m+[0m[0m mbps_wr_burst        = 0
          [32m+[0m[0m mbps_wr_concurrent   = 0
          [32m+[0m[0m passthrough          = false
          [32m+[0m[0m size                 = (known after apply)
          [32m+[0m[0m slot                 = "sata0"
          [32m+[0m[0m storage              = "local-lvm"
          [32m+[0m[0m type                 = "cloudinit"
        }
      [32m+[0m[0m disk {
          [32m+[0m[0m backup               = true
          [32m+[0m[0m id                   = (known after apply)
          [32m+[0m[0m iops_r_burst         = 0
          [32m+[0m[0m iops_r_burst_length  = 0
          [32m+[0m[0m iops_r_concurrent    = 0
          [32m+[0m[0m iops_wr_burst        = 0
          [32m+[0m[0m iops_wr_burst_length = 0
          [32m+[0m[0m iops_wr_concurrent   = 0
          [32m+[0m[0m linked_disk_id       = (known after apply)
          [32m+[0m[0m mbps_r_burst         = 0
          [32m+[0m[0m mbps_r_concurrent    = 0
          [32m+[0m[0m mbps_wr_burst        = 0
          [32m+[0m[0m mbps_wr_concurrent   = 0
          [32m+[0m[0m passthrough          = false
          [32m+[0m[0m size                 = (known after apply)
          [32m+[0m[0m slot                 = "ide2"
          [32m+[0m[0m type                 = "cdrom"
        }

      [32m+[0m[0m network {
          [32m+[0m[0m bridge    = "vmbr0"
          [32m+[0m[0m firewall  = false
          [32m+[0m[0m id        = 0
          [32m+[0m[0m link_down = false
          [32m+[0m[0m macaddr   = (known after apply)
          [32m+[0m[0m model     = "virtio"
        }

      [32m+[0m[0m smbios (known after apply)

      [32m+[0m[0m timeouts {
          [32m+[0m[0m create = "10m"
        }
    }

[1mPlan:[0m 2 to add, 0 to change, 0 to destroy.
[0m
Changes to Outputs:
  [32m+[0m[0m ssh_commands = {
      [32m+[0m[0m webytest = (known after apply)
    }
  [32m+[0m[0m status       = <<-EOT
        ✅ 1 VM(s) déployée(s)
        📄 Scripts injectés :
        - webytest : D:\Keyce_B3\Soutenance\linusupervisor-back\backend\terraform\deployments\20\webytest-script-1.sh, D:\Keyce_B3\Soutenance\linusupervisor-back\backend\terraform\deployments\20\webytest-script-2.sh, D:\Keyce_B3\Soutenance\linusupervisor-back\backend\terraform\deployments\20\webytest-script-3.sh
    EOT
  [32m+[0m[0m vm_ids       = {
      [32m+[0m[0m webytest = (known after apply)
    }
  [32m+[0m[0m vm_ips       = {
      [32m+[0m[0m webytest = (known after apply)
    }
  [32m+[0m[0m vm_names     = [
      [32m+[0m[0m "webytest",
    ]
[0m[1mproxmox_vm_qemu.vm["webytest"]: Creating...[0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m10s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m20s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m30s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m40s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [00m50s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m00s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m10s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m20s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m30s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m40s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [01m50s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m00s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m10s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m20s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Still creating... [02m30s elapsed][0m[0m
[0m[1mproxmox_vm_qemu.vm["webytest"]: Creation complete after 2m33s [id=pve/qemu/101][0m
[0m[1mnull_resource.run_scripts["webytest"]: Creating...[0m[0m
[0m[1mnull_resource.run_scripts["webytest"]: Provisioning with ''local-exec''...[0m[0m
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0mExecuting: ["cmd" "/C" "scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-1.sh nexus@:/tmp/script_1.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-2.sh nexus@:/tmp/script_2.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o StrictHostKeyChecking=no D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\20\\webytest-script-3.sh nexus@:/tmp/script_3.sh"]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0mYou must specify a subsystem to invoke.
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0musage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface] [-b bind_address]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-c cipher_spec] [-D [bind_address:]port] [-E log_file]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-e escape_char] [-F configfile] [-I pkcs11] [-i identity_file]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-J destination] [-L address] [-l login_name] [-m mac_spec]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-O ctl_cmd] [-o option] [-P tag] [-p port] [-Q query_option]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           [-R address] [-S ctl_path] [-W host:port] [-w local_tun[:remote_tun]]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0m           destination [command [argument ...]]
[0m[1mnull_resource.run_scripts["webytest"] (local-exec):[0m [0mscp: Connection closed
[33m╷[0m[0m
[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m
[33m│[0m [0m
[33m│[0m [0m[0mThe root module does not declare a variable named "proxmox_api_token_id"
[33m│[0m [0mbut a value was found in file "variables.tfvars.json". If you meant to use
[33m│[0m [0mthis value, add a "variable" block to the configuration.
[33m│[0m [0m
[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide
[33m│[0m [0mcertain "global" settings to all configurations in your organization. To
[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.
[33m╵[0m[0m
[33m╷[0m[0m
[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValue for undeclared variable[0m
[33m│[0m [0m
[33m│[0m [0m[0mThe root module does not declare a variable named "_meta" but a value was
[33m│[0m [0mfound in file "variables.tfvars.json". If you meant to use this value, add
[33m│[0m [0ma "variable" block to the configuration.
[33m│[0m [0m
[33m│[0m [0mTo silence these warnings, use TF_VAR_... environment variables to provide
[33m│[0m [0mcertain "global" settings to all configurations in your organization. To
[33m│[0m [0mreduce the verbosity of these warnings, use the -compact-warnings option.
[33m╵[0m[0m
[31m╷[0m[0m
[31m│[0m [0m[1m[31mError: [0m[0m[1mlocal-exec provisioner error[0m
[31m│[0m [0m
[31m│[0m [0m[0m  with null_resource.run_scripts["webytest"],
[31m│[0m [0m  on main.tf line 111, in resource "null_resource" "run_scripts":
[31m│[0m [0m 111:   provisioner "local-exec" [4m{[0m[0m
[31m│[0m [0m
[31m│[0m [0mError running command ''scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o
[31m│[0m [0mStrictHostKeyChecking=no
[31m│[0m [0mD:\Keyce_B3\Soutenance\linusupervisor-back\backend\terraform\deployments\20\webytest-script-1.sh
[31m│[0m [0mnexus@:/tmp/script_1.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o
[31m│[0m [0mStrictHostKeyChecking=no
[31m│[0m [0mD:\Keyce_B3\Soutenance\linusupervisor-back\backend\terraform\deployments\20\webytest-script-2.sh
[31m│[0m [0mnexus@:/tmp/script_2.sh && scp -i C:/Users/Nexus-PC/.ssh/id_rsa -o
[31m│[0m [0mStrictHostKeyChecking=no
[31m│[0m [0mD:\Keyce_B3\Soutenance\linusupervisor-back\backend\terraform\deployments\20\webytest-script-3.sh
[31m│[0m [0mnexus@:/tmp/script_3.sh'': exit status 255. Output: You must specify a
[31m│[0m [0msubsystem to invoke.
[31m│[0m [0musage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface] [-b bind_address]
[31m│[0m [0m           [-c cipher_spec] [-D [bind_address:]port] [-E log_file]
[31m│[0m [0m           [-e escape_char] [-F configfile] [-I pkcs11] [-i identity_file]
[31m│[0m [0m           [-J destination] [-L address] [-l login_name] [-m mac_spec]
[31m│[0m [0m           [-O ctl_cmd] [-o option] [-P tag] [-p port] [-Q query_option]
[31m│[0m [0m           [-R address] [-S ctl_path] [-W host:port] [-w local_tun[:remote_tun]]
[31m│[0m [0m           destination [command [argument ...]]
[31m│[0m [0mscp: Connection closed
[31m│[0m [0m
[31m╵[0m[0m
[33m╷[0m[0m
[33m│[0m [0m[1m[33mWarning: [0m[0m[1mValues for undeclared variables[0m
[33m│[0m [0m
[33m│[0m [0m[0mIn addition to the other similar warnings shown, 3 other variable(s)
[33m│[0m [0mdefined without being declared.
[33m╵[0m[0m
[33m╷[0m[0m
[33m│[0m [0m[1m[33mWarning: [0m[0m[1mQemu Guest Agent is enabled but not working[0m
[33m│[0m [0m
[33m│[0m [0m[0m  with proxmox_vm_qemu.vm["webytest"],
[33m│[0m [0m  on main.tf line 35, in resource "proxmox_vm_qemu" "vm":
[33m│[0m [0m  35: resource "proxmox_vm_qemu" "vm" [4m{[0m[0m
[33m│[0m [0m
[33m│[0m [0merror from PVE: "500 QEMU guest agent is not running"
[33m│[0m [0m, Qemu Guest Agent is enabled in you configuration but non installed/not
[33m│[0m [0mworking on your vm
[33m╵[0m[0m

❌ Échec: SSH_HOST_MISSING - Impossible de copier les scripts : l''hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez.
', 'Absolument. Voici une analyse détaillée de ces logs de déploiement.

### 1. Résumé des événements principaux

Ce log retrace une tentative de déploiement automatisé d''une machine virtuelle (VM) nommée `webytest` sur un hyperviseur Proxmox à l''aide de Terraform.

Voici le déroulement chronologique des événements :

1.  **Initialisation (Succès) :**
    *   Le déploiement démarre le 12 août 2025 à 15:35 UTC.
    *   Terraform s''initialise correctement, téléchargeant les fournisseurs nécessaires (`local`, `null`, `proxmox`).

2.  **Planification (Succès) :**
    *   Terraform planifie la création de 2 ressources :
        *   Une machine virtuelle Proxmox (`proxmox_vm_qemu.vm["webytest"]`).
        *   Une ressource `null_resource` destinée à exécuter des scripts après la création de la VM.

3.  **Création de la VM (Succès) :**
    *   La création de la VM `webytest` est lancée. Elle est clonée à partir d''un template nommé `ubuntu-template`.
    *   Après 2 minutes et 33 secondes, **la VM est créée avec succès** sur le nœud Proxmox `pve` avec l''ID `101`.

4.  **Exécution des scripts (Échec) :**
    *   La deuxième ressource (`null_resource`) tente de copier 3 scripts (`.sh`) depuis la machine locale vers la nouvelle VM via la commande `scp`.
    *   **Cette étape échoue.** La commande `scp` est mal formée car il manque l''adresse IP (ou le nom d''hôte) de la VM de destination (`nexus@:/tmp/...` au lieu de `nexus@<IP_DE_LA_VM>:/tmp/...`).

5.  **Diagnostic de l''échec :**
    *   **Cause directe :** L''adresse IP de la VM n''a pas pu être récupérée par Terraform.
    *   **Cause racine :** Un avertissement critique dans les logs révèle le problème : `Warning: Qemu Guest Agent is enabled but not working`. Terraform était configuré pour utiliser le "Qemu Guest Agent" afin d''obtenir l''IP de la VM, mais cet agent n''était pas installé ou ne fonctionnait pas dans le template `ubuntu-template` utilisé pour le clonage.

**Conclusion :** Le déploiement a réussi à créer l''infrastructure de base (la VM), mais a échoué à la configurer (copie des scripts), rendant le déploiement global infructueux.

---

### 2. Analyse de la configuration utilisée

La configuration est **bien intentionnée mais inadaptée** en l''état, car elle repose sur une hypothèse qui s''est avérée fausse.

**Points positifs :**

*   **Infrastructure as Code (IaC) :** L''utilisation de Terraform est une excellente pratique pour automatiser et versionner l''infrastructure.
*   **Utilisation de templates :** Cloner une VM à partir d''un template (`ubuntu-template`) est bien plus efficace que de construire une VM à partir de zéro à chaque fois.
*   **Cloud-Init :** L''utilisation de Cloud-Init est la méthode standard et robuste pour la configuration initiale des VM dans le cloud et les environnements virtualisés.
*   **Intention correcte :** Tenter d''utiliser le Qemu Guest Agent (`agent = 1`) est la bonne façon de récupérer dynamiquement des informations sur la VM, comme son adresse IP DHCP.

**Points faibles (causes de l''échec) :**

*   **Dépendance non satisfaite :** Le principal problème est le décalage entre la configuration Terraform (qui attend le Guest Agent) et l''état du template de la VM (qui ne l''a pas).
*   **Manque de robustesse :** Le processus de déploiement n''a pas de plan B. Si l''agent ne répond pas, tout s''arrête. Il n''y a pas de tentative de re-vérification ou de mécanisme de secours (comme l''attribution d''une IP statique en cas d''échec).
*   **Qualité du code Terraform :** Les nombreux avertissements (`Warning: Value for undeclared variable`) indiquent que des variables sont passées au script Terraform sans y être formellement déclarées. C''est une mauvaise pratique qui rend le code plus difficile à maintenir et à comprendre.

---

### 3. Optimisations possibles

Voici des propositions d''amélioration classées par catégorie.

#### A. Correction immédiate (pour que ça marche)

1.  **Fixer le template :** La solution la plus propre est de modifier le template `ubuntu-template`. Démarrez une VM à partir de ce template, installez et activez le Qemu Guest Agent, puis convertissez cette VM en un nouveau template.
    ```bash
    # Sur la VM Ubuntu/Debian
    sudo apt-get update
    sudo apt-get install qemu-guest-agent
    sudo systemctl start qemu-guest-agent
    sudo systemctl enable qemu-guest-agent
    ```
2.  **Nettoyer le code Terraform :** Déclarez toutes les variables utilisées dans un fichier `variables.tf` pour éliminer les avertissements et améliorer la lisibilité du code.

#### B. Optimisations de performance

1.  **Clonage lié (Linked Clone) :** Le log indique `full_clone = true`. Pour des déploiements beaucoup plus rapides, passez à `full_clone = false`. Cela crée un "clone lié" qui ne duplique pas le disque entier mais utilise le disque du template comme base. **Inconvénient :** cela crée une dépendance forte avec le template, qui ne doit plus être modifié ou supprimé.
2.  **Ajustement des ressources :** Le nom du déploiement (`monitoring__cron`) suggère une charge de travail potentiellement légère. Il faudrait monitorer l''utilisation réelle des 2 Go de RAM et des 2 vCPU pour vérifier s''ils peuvent être réduits afin d''économiser des ressources.

#### C. Optimisations de sécurité

1.  **Gestion des secrets :** La clé SSH (`ssh-rsa AAAAB...`) est visible en clair dans les logs. C''est une faille de sécurité majeure. Elle devrait être gérée via un gestionnaire de secrets (comme HashiCorp Vault ou les secrets d''un CI/CD) et passée à Terraform de manière sécurisée, sans être affichée dans les logs.
2.  **Activer le pare-feu :** Le paramètre `firewall = false` sur l''interface réseau est une mauvaise pratique. Il faudrait le passer à `true` et gérer les règles de sécurité soit au niveau de Proxmox, soit directement dans la VM avec `ufw` ou `iptables`.
3.  **Utilisateur avec moins de privilèges :** Le provisionnement se fait avec l''utilisateur `nexus`. Il faut s''assurer que cet utilisateur dispose du minimum de privilèges nécessaires et n''est pas, par exemple, un super-utilisateur sur la VM.

#### D. Optimisations de monitoring et de robustesse

1.  **Provisioning amélioré :** Au lieu d''enchaîner des commandes `scp` dans un `local-exec`, il serait plus robuste et lisible d''utiliser un outil de gestion de configuration comme **Ansible**. Terraform peut être configuré pour appeler un playbook Ansible après la création de la VM. Ansible gère mieux les erreurs de connexion, les réessais et la complexité de la configuration.
2.  **Monitoring de la VM :** Puisque le but est le "monitoring", il faudrait inclure dans le processus de provisioning l''installation d''un agent de monitoring (ex: Prometheus Node Exporter, Zabbix Agent) sur la VM `webytest` elle-même pour qu''elle puisse être supervisée.
3.  **Gestion centralisée des logs :** Configurer la nouvelle VM pour qu''elle envoie ses propres logs système et applicatifs vers une solution centralisée (comme ELK Stack, Graylog ou Loki) afin de faciliter le dépannage futur.', 'deployment', 32, '2025-08-12 15:48:32.724+00', '2025-08-12 15:48:32.724+00');


--
-- TOC entry 3548 (class 0 OID 17179)
-- Dependencies: 219
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3550 (class 0 OID 17190)
-- Dependencies: 221
-- Data for Name: assigned_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 1, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 2, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 3, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 4, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 5, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 6, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 7, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 8, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 9, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 10, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 11, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 12, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 13, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 14, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 15, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 16, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 17, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 18, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 19, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 20, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 21, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 22, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 23, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 24, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 25, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 26, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 27, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 28, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 29, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 30, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 31, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 32, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 33, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 34, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 35, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 36, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 37, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 38, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 39, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 40, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 41, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 42, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 43, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 45, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 46, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 47, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 48, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 49, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 50, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 51, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 52, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 53, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 54, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 55, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 56, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 57, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 58, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 59, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 60, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 61, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (2, 54, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (3, 36, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (3, 5, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (3, 6, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (3, 4, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 63, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 64, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');
INSERT INTO "public"."assigned_permissions" ("role_id", "permission_id", "created_at", "updated_at") VALUES (1, 65, '2025-08-13 03:33:58.823508+00', '2025-08-13 03:33:58.823508+00');


--
-- TOC entry 3551 (class 0 OID 17193)
-- Dependencies: 222
-- Data for Name: converted_vms; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."converted_vms" ("id", "vm_name", "vm_id", "user_id", "created_at", "updated_at") VALUES (1, 'vm1', '101', 1, '2025-08-06 03:39:32.331972+00', '2025-08-06 03:39:32.331972+00');
INSERT INTO "public"."converted_vms" ("id", "vm_name", "vm_id", "user_id", "created_at", "updated_at") VALUES (2, 'vm_104', '104', 1, '2025-08-06 04:27:07.096+00', '2025-08-06 04:27:07.096+00');


--
-- TOC entry 3553 (class 0 OID 17201)
-- Dependencies: 224
-- Data for Name: deletes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (1, '101', 'inst-0001', 'vm-101', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T03-43-31-880Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 03:43:34.934+00', '2025-08-06 03:43:34.935+00', '2025-08-06 03:43:34.935+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (2, '101', 'inst-0001', 'web-01', '192.168.24.76', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T03-43-53-746Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 03:43:56.205+00', '2025-08-06 03:43:56.205+00', '2025-08-06 03:43:56.205+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (3, '103', 'inst-0001', 'web-02', '192.168.24.77', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T03-44-07-921Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 03:44:10.386+00', '2025-08-06 03:44:10.386+00', '2025-08-06 03:44:10.386+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (4, '101', 'inst-0001', 'web-01', '192.168.24.79', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T03-59-51-944Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 03:59:54.39+00', '2025-08-06 03:59:54.39+00', '2025-08-06 03:59:54.39+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (5, '101', 'inst-0001', 'web-001', '192.168.24.80', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-02-33-675Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:02:36.107+00', '2025-08-06 04:02:36.108+00', '2025-08-06 04:02:36.108+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (6, '101', 'inst-0001', 'web-0001', '192.168.24.81', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-26-19-168Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:26:21.56+00', '2025-08-06 04:26:21.56+00', '2025-08-06 04:26:21.56+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (7, '103', 'inst-0001', 'web-01', '192.168.24.82', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-26-28-228Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:26:30.604+00', '2025-08-06 04:26:30.604+00', '2025-08-06 04:26:30.604+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (8, '104', 'inst-0001', 'web-03', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-34-10-718Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:34:10.837+00', '2025-08-06 04:34:10.837+00', '2025-08-06 04:34:10.837+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (9, '101', 'inst-0001', 'web-02', '192.168.24.83', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-34-15-743Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:34:18.157+00', '2025-08-06 04:34:18.157+00', '2025-08-06 04:34:18.157+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (10, '101', 'inst-0001', 'web-10', '192.168.24.84', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-52-43-649Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:52:46.064+00', '2025-08-06 04:52:46.064+00', '2025-08-06 04:52:46.064+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (11, '103', 'inst-0001', 'web-110', '192.168.24.85', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-52-47-779Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:52:50.159+00', '2025-08-06 04:52:50.159+00', '2025-08-06 04:52:50.159+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (12, '104', 'inst-0001', 'w0', '192.168.24.86', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T04-52-52-124Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 04:52:54.498+00', '2025-08-06 04:52:54.499+00', '2025-08-06 04:52:54.499+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (13, '103', 'inst-0001', 'tss', '192.168.24.88', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T05-11-44-433Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 05:11:46.937+00', '2025-08-06 05:11:46.937+00', '2025-08-06 05:11:46.937+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (14, '101', 'inst-0001', 'ts', '192.168.24.87', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T05-11-51-976Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 05:11:54.374+00', '2025-08-06 05:11:54.375+00', '2025-08-06 05:11:54.375+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (15, '101', 'inst-0001', 'tes2023', '192.168.24.89', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T10-21-11-818Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 10:21:14.204+00', '2025-08-06 10:21:14.205+00', '2025-08-06 10:21:14.205+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (16, '103', 'inst-0001', 'tes20273', '192.168.24.90', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T10-21-16-593Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 10:21:19.041+00', '2025-08-06 10:21:19.041+00', '2025-08-06 10:21:19.041+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (17, '101', 'inst-0001', 'test', '192.168.24.91', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T11-12-42-906Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 11:12:45.278+00', '2025-08-06 11:12:45.278+00', '2025-08-06 11:12:45.278+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (18, '103', 'inst-0001', 'sdsf', '192.168.24.92', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T11-12-50-373Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 11:12:52.751+00', '2025-08-06 11:12:52.751+00', '2025-08-06 11:12:52.751+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (19, '104', 'inst-0001', 'yedb', '192.168.24.93', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T11-12-54-994Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 11:12:57.36+00', '2025-08-06 11:12:57.36+00', '2025-08-06 11:12:57.36+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (20, '101', 'inst-0001', 'test1', '192.168.24.94', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T11-31-47-067Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 11:31:49.479+00', '2025-08-06 11:31:49.479+00', '2025-08-06 11:31:49.479+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (21, '103', 'inst-0001', 'web1', '192.168.24.95', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T11-31-51-422Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 11:31:53.84+00', '2025-08-06 11:31:53.84+00', '2025-08-06 11:31:53.84+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (22, '101', 'inst-0001', 'web12', '192.168.24.96', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T12-34-36-613Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 12:34:39.091+00', '2025-08-06 12:34:39.091+00', '2025-08-06 12:34:39.091+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (23, '103', 'inst-0001', 'webtest', '192.168.24.97', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T12-34-44-004Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 12:34:46.398+00', '2025-08-06 12:34:46.398+00', '2025-08-06 12:34:46.398+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (24, '104', 'inst-0001', 'webtes2t', '192.168.24.98', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T12-34-48-088Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 12:34:50.432+00', '2025-08-06 12:34:50.432+00', '2025-08-06 12:34:50.432+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (25, '101', 'inst-0001', 'webtes2t', '192.168.24.99', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T12-51-32-270Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 12:51:34.668+00', '2025-08-06 12:51:34.669+00', '2025-08-06 12:51:34.669+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (26, '101', 'inst-0001', 'web', '192.168.24.200', 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T13-05-23-736Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 13:05:26.178+00', '2025-08-06 13:05:26.178+00', '2025-08-06 13:05:26.178+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (27, '103', 'inst-0001', 'we02b', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\delete-2025-08-06T13-05-28-775Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-06 13:05:28.898+00', '2025-08-06 13:05:28.898+00', '2025-08-06 13:05:28.898+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (28, '101', 'inst-0001', 'Webapache', '192.168.24.202', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-08T12-40-58-723Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-08 12:41:05.964+00', '2025-08-08 12:41:05.964+00', '2025-08-08 12:41:05.964+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (29, '104', 'inst-0001', 'we0w2b', '192.168.24.201', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-08T12-41-10-978Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-08 12:41:13.268+00', '2025-08-08 12:41:13.268+00', '2025-08-08 12:41:13.268+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (30, '101', 'inst-0001', 'Webapache', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-08T12-43-05-739Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-08 12:43:05.852+00', '2025-08-08 12:43:05.852+00', '2025-08-08 12:43:05.852+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (31, '101', 'c8f4a86e-ca73-44b8-bfca-edf40641cc99', 'Webapache', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-11T13-17-46-528Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-11 13:17:46.629+00', '2025-08-11 13:17:46.63+00', '2025-08-11 13:17:46.63+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (32, '104', 'd45d414b-a18d-4f3a-9a97-c84d8d4417c5', 'testweb', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-11T13-30-33-735Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-11 13:30:33.819+00', '2025-08-11 13:30:33.82+00', '2025-08-11 13:30:33.82+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (33, '103', 'c06d59eb-a650-4427-ba92-05b107a6fd81', 'monitoring', '192.168.24.130', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-11T13-30-31-727Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-11 13:30:34.054+00', '2025-08-11 13:30:34.055+00', '2025-08-11 13:30:34.055+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (34, '101', '88966679-e8a2-4c48-b948-75ca879e7343', 'testwebserver', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-12T11-35-15-613Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-12 11:35:20.823+00', '2025-08-12 11:35:20.824+00', '2025-08-12 11:35:20.824+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (35, '103', '793826a0-2600-40a4-bdd8-2fd2209e4df9', 'testweb20122', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-12T11-35-18-649Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-12 11:35:23.876+00', '2025-08-12 11:35:23.876+00', '2025-08-12 11:35:23.876+00');
INSERT INTO "public"."deletes" ("id", "vm_id", "instance_id", "vm_name", "vm_ip", "log_path", "user_id", "user_email", "deleted_at", "created_at", "updated_at") VALUES (36, '101', '88966679-e8a2-4c48-b948-75ca879e7343', 'web301', NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\delete-2025-08-12T14-25-17-922Z-1.log', 1, 'latifnjimoluh@gmail.com', '2025-08-12 14:25:23.134+00', '2025-08-12 14:25:23.134+00', '2025-08-12 14:25:23.134+00');


--
-- TOC entry 3555 (class 0 OID 17209)
-- Dependencies: 226
-- Data for Name: deployments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (2, 1, 'latifnjimoluh@gmail.com', 'tes2023', 'web', 'LAN', 'apply', '2025-08-06 08:59:32.654+00', '2025-08-06 09:01:27.024+00', '114.37s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T08-59-32-654Z-1.log', '101', '192.168.24.89', '90c1de06-5101-4ed7-a500-0ad0006cb3cb', '["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 09:01:27.025+00', '2025-08-06 09:01:27.025+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (3, 1, 'latifnjimoluh@gmail.com', 'yedb', 'web', 'LAN', 'apply', '2025-08-06 11:08:15.284+00', '2025-08-06 11:10:16.111+00', '120.827s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T11-08-15-284Z-1.log', '104', '192.168.24.93', '387b2866-50c6-4c89-98f0-8db4125d137d', '["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 11:10:16.117+00', '2025-08-06 11:10:16.117+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (4, 1, 'latifnjimoluh@gmail.com', 'test1', 'web', 'LAN', 'apply', '2025-08-06 11:17:15.327+00', '2025-08-06 11:19:19.158+00', '123.831s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T11-17-15-327Z-1.log', '101', '192.168.24.94', '505bb44b-f327-47f7-a2d2-5fb231456c2f', '["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 11:19:19.159+00', '2025-08-06 11:19:19.159+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (5, 1, 'latifnjimoluh@gmail.com', 'web1', 'web', 'LAN', 'apply', '2025-08-06 11:21:48.614+00', '2025-08-06 11:26:23.835+00', '275.221s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T11-21-48-614Z-1.log', '103', '192.168.24.95', '9a9db055-86a2-4dff-a5be-f963756614c7', '["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 11:26:23.837+00', '2025-08-06 11:26:23.837+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (6, 1, 'latifnjimoluh@gmail.com', 'web12', 'web', 'LAN', 'apply', '2025-08-06 11:31:32.685+00', '2025-08-06 11:35:01.198+00', '208.513s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T11-31-32-685Z-1.log', '101', '192.168.24.96', '9fb15047-d841-4d06-b4ac-861ac93fe350', '["scripts/monitor.sh","scripts/service.sh","scripts/init.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 11:35:01.2+00', '2025-08-06 11:35:01.2+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (7, 1, 'latifnjimoluh@gmail.com', 'webtest', 'web', 'LAN', 'apply', '2025-08-06 12:23:42.706+00', '2025-08-06 12:25:42.865+00', '120.159s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T12-23-42-706Z-1.log', '103', '192.168.24.97', '3c634098-a504-4bcf-a13d-f0f807a7e0e7', '["/scripts/generated/web/web_server_nginx_web_D_ploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_G_n_ration_du_script_script001.sh","/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_syst_me_-_G_n_ration_du_script_script001.sh","/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 12:25:42.869+00', '2025-08-06 12:25:42.869+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (8, 1, 'latifnjimoluh@gmail.com', 'webtes2t', 'web', 'LAN', 'apply', '2025-08-06 12:28:12.098+00', '2025-08-06 12:30:11.48+00', '119.382s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T12-28-12-098Z-1.log', '104', '192.168.24.98', '77f999e8-8948-4a8b-8254-c51f6adbdfdb', '["/scripts/generated/web/004.sh","/scripts/generated/monitoring/003.sh","/scripts/generated/monitoring/002.sh","/scripts/generated/monitoring/001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 12:30:11.482+00', '2025-08-06 12:30:11.482+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (9, 1, 'latifnjimoluh@gmail.com', 'webtes2t', 'web', 'LAN', 'apply', '2025-08-06 12:49:13.238+00', '2025-08-06 12:51:06.001+00', '112.763s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T12-49-13-238Z-1.log', '101', '192.168.24.99', '8cc9e726-5696-4665-a7fc-3db9b56c84f6', '["/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 12:51:06.003+00', '2025-08-06 12:51:06.003+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (11, 1, 'latifnjimoluh@gmail.com', 'Webapache', 'web', 'LAN', 'apply', '2025-08-06 13:16:15.333+00', '2025-08-06 13:19:38.683+00', '203.35s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T13-16-15-333Z-1.log', '101', '192.168.24.202', '64072c58-458d-4b76-a264-ad763d3be64c', '["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 13:19:38.687+00', '2025-08-06 13:19:38.687+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (10, 1, 'latifnjimoluh@gmail.com', 'we0w2b', 'web', 'LAN', 'destroy', '2025-08-06 13:02:25.881+00', '2025-08-06 13:05:44.292+00', '198.411s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\logs\deploy-2025-08-06T13-02-25-881Z-1.log', '104', '192.168.24.201', 'd45d414b-a18d-4f3a-9a97-c84d8d4417c5', '["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-06 13:05:44.296+00', '2025-08-11 13:30:33.816+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (13, 1, 'latifnjimoluh@gmail.com', 'testVM', 'web', 'LAN', 'apply', '2025-08-08 12:45:23.974+00', '2025-08-08 12:47:25.654+00', '121.68s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-2025-08-08T12-45-23-974Z-1.log', '103', '192.168.24.204', '10727005-f0aa-49d9-9d2a-519e7a93770f', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-08 12:47:25.656+00', '2025-08-08 12:47:25.656+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (17, 1, 'latifnjimoluh@gmail.com', 'web-test2', 'monitoring_cron', 'LAN', 'apply', '2025-08-12 03:02:24.141+00', '2025-08-12 03:02:25.846+00', '2s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-3c5c7c1e-50f6-4b90-a6da-15f5ee9cbb39.log', NULL, NULL, '3c5c7c1e-50f6-4b90-a6da-15f5ee9cbb39', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'failed', '2025-08-12 03:02:24.192+00', '2025-08-12 03:02:25.847+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (12, 1, 'latifnjimoluh@gmail.com', 'Webapache', 'web', 'LAN', 'destroy', '2025-08-08 12:41:55.026+00', '2025-08-08 12:44:36.081+00', '161.055s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-2025-08-08T12-41-55-026Z-1.log', '101', '192.168.24.203', 'c8f4a86e-ca73-44b8-bfca-edf40641cc99', '["D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-08 12:44:36.084+00', '2025-08-11 13:17:46.623+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (15, 1, 'latifnjimoluh@gmail.com', 'monitoring', 'web_server_nginx', 'LAN', 'destroy', '2025-08-09 18:04:11.8+00', '2025-08-09 18:07:31.875+00', '200.075s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-2025-08-09T18-04-11-800Z-1.log', '103', '192.168.24.130', 'c06d59eb-a650-4427-ba92-05b107a6fd81', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-09 18:07:31.877+00', '2025-08-11 13:30:34.052+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (16, 1, 'latifnjimoluh@gmail.com', 'testweb', 'web_server_nginx', 'LAN', 'apply', '2025-08-12 02:17:32.683+00', '2025-08-12 02:19:37.224+00', '124.541s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-2025-08-12T02-17-32-683Z-1.log', '101', '192.168.24.206', 'b588f5d0-0045-403d-ae1c-71dd0135d23f', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'deployed', '2025-08-12 02:19:37.226+00', '2025-08-12 02:19:37.226+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (18, 1, 'latifnjimoluh@gmail.com', 'web-test2', 'web_server_nginx', 'LAN', 'apply', '2025-08-12 03:08:30.833+00', '2025-08-12 03:08:30.909+00', '0s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-bdeeb806-8146-404d-aef8-e7fd0a8f5f56.log', NULL, NULL, 'bdeeb806-8146-404d-aef8-e7fd0a8f5f56', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'failed', '2025-08-12 03:08:30.895+00', '2025-08-12 03:08:30.91+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (19, 1, 'latifnjimoluh@gmail.com', 'testwebserver2', 'web_server_nginx', 'LAN', 'apply', '2025-08-12 03:11:16.41+00', NULL, NULL, NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-aa38c0b4-30a3-45a2-867b-cb11e051c369.log', NULL, NULL, 'aa38c0b4-30a3-45a2-867b-cb11e051c369', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'in_progress', '2025-08-12 03:11:16.471+00', '2025-08-12 03:11:16.471+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (20, 1, 'latifnjimoluh@gmail.com', 'testweb3', 'web_server_nginx', 'LAN', 'apply', '2025-08-12 03:19:52.244+00', '2025-08-12 03:22:05.323+00', '133s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-12ca649c-5815-4412-97b7-4298b2a83444.log', '104', '192.168.24.208', '12ca649c-5815-4412-97b7-4298b2a83444', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'completed', '2025-08-12 03:19:52.297+00', '2025-08-12 03:22:05.324+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (21, 1, 'latifnjimoluh@gmail.com', 'web777', 'web_server_nginx', 'LAN', 'apply', '2025-08-12 03:25:56.156+00', NULL, NULL, NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-960b605f-d928-4cdd-b370-1046cf552394.log', NULL, NULL, '960b605f-d928-4cdd-b370-1046cf552394', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/web/web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'in_progress', '2025-08-12 03:25:56.187+00', '2025-08-12 03:25:56.187+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (22, 1, 'latifnjimoluh@gmail.com', 'testweb88', 'web_server_nginx', 'LAN', 'apply', '2025-08-12 03:40:47.044+00', '2025-08-12 03:44:36.609+00', '230s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-0c50c329-4400-49b2-9fdb-077d0523e1cd.log', NULL, NULL, '0c50c329-4400-49b2-9fdb-077d0523e1cd', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'failed', '2025-08-12 03:40:47.095+00', '2025-08-12 03:44:36.61+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (23, 1, 'latifnjimoluh@gmail.com', 'testwebdsfgfd', 'service_monitoring_script', 'DMZ', 'apply', '2025-08-12 03:45:06.547+00', '2025-08-12 03:45:30.64+00', '24s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-d9c6028f-9b25-4d96-a056-be2a0120979b.log', NULL, NULL, 'd9c6028f-9b25-4d96-a056-be2a0120979b', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'failed', '2025-08-12 03:45:06.572+00', '2025-08-12 03:45:30.64+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (25, 1, 'latifnjimoluh@gmail.com', 'testweb20122', 'monitoring_cron', 'LAN', 'destroy', '2025-08-12 04:20:35.804+00', '2025-08-12 04:22:34.771+00', '119s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-793826a0-2600-40a4-bdd8-2fd2209e4df9.log', '103', '192.168.24.210', '793826a0-2600-40a4-bdd8-2fd2209e4df9', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'completed', '2025-08-12 04:20:35.827+00', '2025-08-12 11:35:23.873+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (26, 1, 'latifnjimoluh@gmail.com', 'test monitoring', 'monitoring__cron', 'LAN', 'apply', '2025-08-12 04:39:22.455+00', '2025-08-12 04:39:45.791+00', '23s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-96ed7722-3a83-4528-a610-390fdafc1f89.log', NULL, NULL, '96ed7722-3a83-4528-a610-390fdafc1f89', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'failed', '2025-08-12 04:39:22.481+00', '2025-08-12 04:39:45.792+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (27, 1, 'latifnjimoluh@gmail.com', 'test-web', 'monitoring__cron', 'LAN', 'apply', '2025-08-12 04:47:17.126+00', NULL, NULL, NULL, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-964520ce-24f3-4c19-9e0b-b510125c2bfe.log', NULL, NULL, '964520ce-24f3-4c19-9e0b-b510125c2bfe', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'in_progress', '2025-08-12 04:47:17.149+00', '2025-08-12 04:47:17.149+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (28, 1, 'latifnjimoluh@gmail.com', 'webser-tts-fgj', 'monitoring__cron', 'LAN', 'apply', '2025-08-12 04:49:56.282+00', '2025-08-12 04:53:22.233+00', '206s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-3b7f7818-5b11-4552-ac40-5b428ddce60e.log', NULL, NULL, '3b7f7818-5b11-4552-ac40-5b428ddce60e', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'failed', '2025-08-12 04:49:56.333+00', '2025-08-12 04:53:22.233+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (24, 1, 'latifnjimoluh@gmail.com', 'testwebserver', 'monitoring_cron', 'LAN', 'destroy', '2025-08-12 03:52:49.611+00', '2025-08-12 03:54:43.848+00', '114s', true, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-88966679-e8a2-4c48-b948-75ca879e7343.log', '101', '192.168.24.209', '88966679-e8a2-4c48-b948-75ca879e7343', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"20G"}', 'completed', '2025-08-12 03:52:49.65+00', '2025-08-12 14:25:23.128+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (29, 1, 'latifnjimoluh@gmail.com', 'ds-a-a-aa-a-a-a-2', 'monitoring__cron', 'LAN', 'apply', '2025-08-12 12:09:46.849+00', '2025-08-12 12:22:35.824+00', '769s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-a6dd007c-ac3d-4504-bfd0-1bc1d93c5d9b.log', NULL, NULL, 'a6dd007c-ac3d-4504-bfd0-1bc1d93c5d9b', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"10G"}', 'failed', '2025-08-12 12:09:47.055+00', '2025-08-12 12:22:35.824+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (30, 1, 'latifnjimoluh@gmail.com', 'testweb2', 'monitoring__cron', 'LAN', 'apply', '2025-08-12 12:27:58.777+00', '2025-08-12 12:42:15.629+00', '857s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-7d8ac446-0660-4f98-bb3a-4c5f206477f1.log', NULL, NULL, '7d8ac446-0660-4f98-bb3a-4c5f206477f1', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"10G"}', 'failed', '2025-08-12 12:27:58.945+00', '2025-08-12 12:42:15.63+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (31, 1, 'latifnjimoluh@gmail.com', 'web301', 'monitoring__cron', 'WAN', 'apply', '2025-08-12 13:24:47.554+00', '2025-08-12 13:35:21.505+00', '634s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-ffb7b8c4-0040-47a2-bd2f-7b0809387fef.log', NULL, NULL, 'ffb7b8c4-0040-47a2-bd2f-7b0809387fef', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"10G"}', 'failed', '2025-08-12 13:24:47.744+00', '2025-08-12 13:35:21.505+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (32, 1, 'latifnjimoluh@gmail.com', 'webytest', 'monitoring__cron', 'LAN', 'apply', '2025-08-12 15:35:17.365+00', '2025-08-12 15:38:33.343+00', '196s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-9a40f8b7-993e-4fcd-b548-2d230a942134.log', NULL, NULL, '9a40f8b7-993e-4fcd-b548-2d230a942134', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"18G"}', 'failed', '2025-08-12 15:35:17.572+00', '2025-08-12 15:38:33.344+00');
INSERT INTO "public"."deployments" ("id", "user_id", "user_email", "vm_name", "service_name", "zone", "operation_type", "started_at", "ended_at", "duration", "success", "log_path", "vm_id", "vm_ip", "instance_id", "injected_files", "vm_specs", "status", "created_at", "updated_at") VALUES (33, 1, 'latifnjimoluh@gmail.com', 'test23-4', 'monitoring__cron', 'LAN', 'apply', '2025-08-12 15:54:08.689+00', '2025-08-12 15:57:24.103+00', '195s', false, 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\logs\deploy-cd0af94f-89dd-42ab-adf4-e109d1e9aadf.log', NULL, NULL, 'cd0af94f-89dd-42ab-adf4-e109d1e9aadf', '["D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh","D:/Keyce_B3/Soutenance/linusupervisor-back/backend/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh"]', '{"template_name":"ubuntu-template","memory_mb":2048,"vcpu_cores":2,"vcpu_sockets":1,"disk_size":"13G"}', 'failed', '2025-08-12 15:54:08.897+00', '2025-08-12 15:57:24.103+00');


--
-- TOC entry 3557 (class 0 OID 17217)
-- Dependencies: 228
-- Data for Name: generated_scripts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."generated_scripts" ("id", "template_id", "category", "service_type", "script_path", "description", "created_at", "updated_at", "abs_path", "status") VALUES (29, 25, 'monitoring', 'monitoring__cron', '/scripts/generated/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh', 'Installe un cron job minuteur qui attend la présence des scripts de monitoring, les exécute, crée leurs crons définitifs puis se désinstalle.', '2025-08-12 04:37:40.624+00', '2025-08-12 04:37:40.624+00', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\scripts\generated\monitoring\monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh', 'actif');
INSERT INTO "public"."generated_scripts" ("id", "template_id", "category", "service_type", "script_path", "description", "created_at", "updated_at", "abs_path", "status") VALUES (30, 26, 'monitoring', 'system_monitoring_script', '/scripts/generated/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh', 'Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh', '2025-08-12 04:37:54.864+00', '2025-08-12 04:37:54.864+00', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\scripts\generated\monitoring\system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh', 'actif');
INSERT INTO "public"."generated_scripts" ("id", "template_id", "category", "service_type", "script_path", "description", "created_at", "updated_at", "abs_path", "status") VALUES (31, 27, 'monitoring', 'service_monitoring_script', '/scripts/generated/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh', 'Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh', '2025-08-12 04:38:00.056+00', '2025-08-12 04:38:00.056+00', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\scripts\generated\monitoring\service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh', 'actif');


--
-- TOC entry 3559 (class 0 OID 17226)
-- Dependencies: 230
-- Data for Name: initialization_scripts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."initialization_scripts" ("id", "name", "script_path", "description", "created_at", "updated_at") VALUES (1, 'Ubuntu Base Setup', 'scripts/init.sh', 'Update packages and install base utilities', '2025-08-06 03:39:32.352314+00', '2025-08-06 03:39:32.352314+00');


--
-- TOC entry 3561 (class 0 OID 17234)
-- Dependencies: 232
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1, 1, 'login', 'User logged in', '2025-08-06 03:39:32.335271+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2, NULL, 'POST /auth/request-reset', '{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}', '2025-08-06 03:40:00.778+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (3, 1, 'request_reset_code', '{"user_id":1}', '2025-08-06 03:40:05.894+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (4, NULL, 'POST /auth/reset-password', '{"body":{"code":"803327","password":"admin123."},"query":{}}', '2025-08-06 03:41:00.176+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (5, 1, 'reset_password', '{"user_id":1}', '2025-08-06 03:41:00.381+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (6, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-06 03:41:20.772+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (7, 1, 'login', '{"user_id":1}', '2025-08-06 03:41:20.984+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (8, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 03:42:51.187+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (9, 1, 'PUT /settings/me', '{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"mytoken","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/tmp/status.json","servicespath":"/tmp/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}', '2025-08-06 03:43:25.502+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (10, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 03:43:31.871+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (11, 1, 'PUT /settings/me', '{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"delete","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/tmp/status.json","servicespath":"/tmp/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}', '2025-08-06 03:43:50.307+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (12, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 03:43:53.736+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (13, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 03:44:07.91+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (14, 1, 'GET /auth/reset-history', '{"query":{}}', '2025-08-06 03:44:41.003+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (15, 1, 'view_reset_history', '{}', '2025-08-06 03:44:41.015+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (16, 1, 'GET /roles', '{"query":{}}', '2025-08-06 03:44:58.142+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (17, 1, 'GET /roles/1', '{"query":{}}', '2025-08-06 03:45:04.94+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (18, 1, 'POST /permissions', '{"body":{"name":"test","description":"test posts"},"query":{}}', '2025-08-06 03:45:33.666+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (19, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}', '2025-08-06 03:45:50.077+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (20, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-06 03:46:00.952+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (21, 1, 'POST /permissions/unassign', '{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}', '2025-08-06 03:46:16.479+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (22, 1, 'POST /permissions/unassign', '{"body":[{"role_id":1,"permission_ids":44}],"query":{}}', '2025-08-06 03:46:51.809+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (23, 1, 'DELETE /permissions/44', '{"query":{}}', '2025-08-06 03:47:55.707+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (24, 1, 'GET /logs', '{"query":{}}', '2025-08-06 03:48:09.209+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (25, 1, 'GET /settings/me', '{"query":{}}', '2025-08-06 03:48:24.116+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (26, 1, 'GET /vms', '{"query":{}}', '2025-08-06 03:48:30.921+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (27, 1, 'list_vms', '{}', '2025-08-06 03:48:30.945+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (28, 1, 'POST /vms/check-status', '{"body":{"vm_id":104},"query":{}}', '2025-08-06 03:50:00.417+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (29, 1, 'POST /vms/check-status', '{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}', '2025-08-06 03:50:36.826+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (30, 1, 'check_vm_status', '{"vm_id":104,"vm_status":"running","ping_ok":true}', '2025-08-06 03:50:36.948+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (31, 1, 'POST /vms/104/stop', '{"query":{}}', '2025-08-06 03:51:02.049+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (32, 1, 'stop_vm:104', '{}', '2025-08-06 03:51:02.099+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (33, 1, 'POST /vms/check-status', '{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}', '2025-08-06 03:51:16.897+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (34, 1, 'check_vm_status', '{"vm_id":104,"vm_status":"stopped","ping_ok":false}', '2025-08-06 03:51:21.552+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (35, 1, 'POST /vms/104/start', '{"query":{}}', '2025-08-06 03:51:34.177+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (36, 1, 'start_vm:104', '{}', '2025-08-06 03:51:34.234+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (37, 1, 'POST /vms/check-status', '{"body":{"vm_id":104,"ip_address":"192.168.24.78"},"query":{}}', '2025-08-06 03:51:37.87+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (38, 1, 'check_vm_status', '{"vm_id":104,"vm_status":"running","ping_ok":false}', '2025-08-06 03:51:40.548+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (39, 1, 'GET /templates', '{"query":{}}', '2025-08-06 03:51:52.614+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (40, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 03:59:51.934+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (41, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:00:13.147+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (42, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:02:33.657+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (43, 1, 'POST /permissions/unassign', '{"body":[{"role_id":1,"permission_ids":[44]}],"query":{}}', '2025-08-06 04:10:04.108+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (44, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:26:19.154+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (45, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:26:28.221+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (46, 1, 'POST /vms/convert', '{"body":{"vm_id":104},"query":{}}', '2025-08-06 04:26:44.785+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (47, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:26:49.252+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (48, 1, 'convert_vm_template', '{"vm_id":104}', '2025-08-06 04:27:07.192+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (49, 1, 'POST /vms/delete', '{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:34:10.707+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (50, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:34:15.734+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (51, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:34:27.3+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (52, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:34:35.77+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (53, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:36:34.655+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (54, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-06 04:43:26.289+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (55, 1, 'login', '{"user_id":1}', '2025-08-06 04:43:26.497+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (56, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:52:43.634+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (57, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:52:47.77+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (58, 1, 'POST /vms/delete', '{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 04:52:52.116+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (59, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:53:04.254+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (60, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:53:09.288+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (61, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 04:53:15.962+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (62, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 05:10:43.953+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (63, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 05:11:02.051+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (64, 1, 'Échec Déploiement Terraform', '{"error":"initCmd is not defined"}', '2025-08-06 05:11:27.723+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (65, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 05:11:44.41+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (66, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 05:11:51.965+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (67, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-06 08:52:25.362+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (68, 1, 'login', '{"user_id":1}', '2025-08-06 08:52:25.737+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (69, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 08:53:08.949+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (70, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 08:56:53.324+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (71, 1, 'Déploiement Terraform', '{"vm_name":"tes2023","service_type":"web","success":true}', '2025-08-06 09:01:27.107+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (72, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-06 10:03:19.433+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (73, 1, 'login', '{"user_id":1}', '2025-08-06 10:03:19.669+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (74, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 10:21:11.799+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (75, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 10:21:16.586+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (76, 1, 'Déploiement Terraform', '{"vm_name":"yedb","service_type":"web","success":true}', '2025-08-06 11:10:16.223+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (77, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 11:12:42.896+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (78, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 11:12:50.365+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (79, 1, 'POST /vms/delete', '{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 11:12:54.986+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (80, 1, 'Échec Déploiement Terraform', '{}', '2025-08-06 11:13:11.409+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (81, 1, 'PUT /settings/me', '{"body":{"cloudinit_user":"nexus","cloudinit_password":"Nexus2023.","proxmox_api_url":"https://192.168.24.134:8006/api2/json","proxmox_api_token_id":"root@pam","proxmox_api_token_name":"delete","proxmox_api_token_secret":"0a804aa8-029e-4503-83a3-3fb51a804771","pm_user":"root@pam","pm_password":"Nexus2023.","proxmox_node":"pve","vm_storage":"local-lvm","vm_bridge":"vmbr0","ssh_public_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa.pub","ssh_private_key_path":"C:/Users/Nexus-PC/.ssh/id_rsa","statuspath":"/opt/monitoring/status.json","servicespath":"/opt/monitoring/services_status.json","instanceinfopath":"/etc/instance-info.conf","proxmox_host":"192.168.24.134","proxmox_ssh_user":"root"},"query":{}}', '2025-08-06 11:17:39.926+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (82, 1, 'Déploiement Terraform', '{"vm_name":"test1","service_type":"web","success":true}', '2025-08-06 11:19:19.232+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (83, 1, 'Déploiement Terraform', '{"vm_name":"web1","service_type":"web","success":true}', '2025-08-06 11:26:23.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (84, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 11:31:47.053+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (85, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 11:31:51.41+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (86, 1, 'POST /templates', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute les tâches planifiées pour exécuter les scripts de surveillance système et services toutes les 5 minutes.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"/opt/monitoring/status.sh\"\nSERVICES_SCRIPT=\"/opt/monitoring/services_status.sh\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/5 * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/5 * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[]}},"query":{}}', '2025-08-06 11:34:12.22+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (87, 1, 'create_template:2', '{}', '2025-08-06 11:34:12.256+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (88, 1, 'Déploiement Terraform', '{"vm_name":"web12","service_type":"web","success":true}', '2025-08-06 11:35:01.288+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (89, 1, 'POST /templates/generate', '{"body":{"template_id":2,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 11:37:17.191+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (90, 1, 'generate_template:2', '{}', '2025-08-06 11:37:17.206+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (91, 1, 'PUT /templates/2', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 11:42:51.517+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (92, 1, 'update_template:2', '{}', '2025-08-06 11:42:51.563+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (93, 1, 'POST /templates', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 11:49:24.336+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (94, 1, 'create_template:3', '{}', '2025-08-06 11:49:24.388+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (130, 1, 'POST /templates', '{"body":{"name":"Déploiement de l''API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\n\necho \"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\"\nAPP_DIR=\"${APP_DIR}\"\nVENVDIR=\"$APP_DIR/venv\"\nPROXY_IP=\"${PROXY_IP}\"\nAPI_USER=\"${API_USER}\"\n\n# 1. Mise à jour système & dépendances\necho \"📦 Installation des paquets requis...\"\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\nsudo apt install curl -y\n\n# 2. Création du dossier de l''application\necho \"📁 Création du dossier $APP_DIR...\"\nsudo mkdir -p \"$APP_DIR\"\nsudo chown -R $API_USER:$API_USER \"$APP_DIR\"\n\n# 3. Création d''un environnement virtuel Python\necho \"🐍 Initialisation de l’environnement virtuel...\"\nsudo -u $API_USER python3 -m venv \"$VENVDIR\"\nsource \"$VENVDIR/bin/activate\"\n\n# 4. Installation de Flask et Gunicorn\necho \"📦 Installation de Flask & Gunicorn...\"\n\"$VENVDIR/bin/pip\" install flask gunicorn\n\n# 5. Création d’une application Flask minimaliste\necho \"📝 Déploiement de l''application Flask (hello.py)\"\nsudo tee \"$APP_DIR/app.py\" > /dev/null <<EOF\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route(\"/\")\ndef home():\n    return \"✅ Bienvenue sur l’API interne Camer!\"\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 6. Création du fichier WSGI\necho \"🧩 Création du fichier WSGI (wsgi.py)\"\nsudo tee \"$APP_DIR/wsgi.py\" > /dev/null <<EOF\nfrom app import app\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 7. Configuration du service systemd\necho \"⚙️ Création du service systemd gunicorn\"\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\n[Unit]\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nEnvironment=\"PATH=$VENVDIR/bin\"\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\n# 8. Démarrage du service\necho \"🔄 Activation et lancement du service\"\nsudo systemctl daemon-reexec\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 9. Sécurisation avec UFW\necho \"🛡️ Configuration du pare-feu (UFW)\"\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \"Autorise accès proxy vers API\"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 10. Test local\necho \"🔎 Test local sur http://127.0.0.1:5000\"\ncurl -s http://127.0.0.1:5000 || echo \"⚠️ API non accessible localement, vérifier les logs.\"\n\necho \"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l''API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d''installation de l''app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}', '2025-08-06 12:35:09.553+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (95, 1, 'POST /templates/generate', '{"body":{"template_id":3,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 11:50:16.472+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (96, 1, 'generate_template_file:3:Activation_des_cronjobs_de_supervision_2025-08-06T11-50-16-492Z.sh', '{}', '2025-08-06 11:50:16.495+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (97, 1, 'POST /templates', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 12:08:22.441+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (98, 1, 'create_template:4', '{}', '2025-08-06 12:08:22.487+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (99, 1, 'POST /templates/generate', '{"body":{"template_id":4,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 12:08:32.157+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (100, 1, 'generate_template_file:4:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervisionscript001.sh', '{}', '2025-08-06 12:08:32.187+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (101, 1, 'POST /templates', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 12:10:52.966+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (102, 1, 'create_template:5', '{}', '2025-08-06 12:10:53.01+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (103, 1, 'POST /templates/generate', '{"body":{"template_id":5,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 12:11:03.204+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (104, 1, 'generate_template_file:5:Activation_des_cronjobs_de_supervisionscript001.sh', '{}', '2025-08-06 12:11:03.232+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (105, 1, 'POST /templates', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 12:15:14.931+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (106, 1, 'create_template:6', '{}', '2025-08-06 12:15:14.976+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (107, 1, 'POST /templates/generate', '{"body":{"template_id":5,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 12:15:20.043+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (108, 1, 'generate_template_file:5:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh', '{}', '2025-08-06 12:15:20.074+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (131, 1, 'POST /templates', '{"body":{"name":"Déploiement de l''API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\n\necho \"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\"\nAPP_DIR=\"${APP_DIR}\"\nVENVDIR=\"$APP_DIR/venv\"\nPROXY_IP=\"${PROXY_IP}\"\nAPI_USER=\"${API_USER}\"\n\n# 1. Mise à jour système & dépendances\necho \"📦 Installation des paquets requis...\"\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\nsudo apt install curl -y\n\n# 2. Création du dossier de l''application\necho \"📁 Création du dossier $APP_DIR...\"\nsudo mkdir -p \"$APP_DIR\"\nsudo chown -R $API_USER:$API_USER \"$APP_DIR\"\n\n# 3. Création d''un environnement virtuel Python\necho \"🐍 Initialisation de l’environnement virtuel...\"\nsudo -u $API_USER python3 -m venv \"$VENVDIR\"\nsource \"$VENVDIR/bin/activate\"\n\n# 4. Installation de Flask et Gunicorn\necho \"📦 Installation de Flask & Gunicorn...\"\n\"$VENVDIR/bin/pip\" install flask gunicorn\n\n# 5. Création d’une application Flask minimaliste\necho \"📝 Déploiement de l''application Flask (hello.py)\"\nsudo tee \"$APP_DIR/app.py\" > /dev/null <<EOF\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route(\"/\")\ndef home():\n    return \"✅ Bienvenue sur l’API interne Camer!\"\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 6. Création du fichier WSGI\necho \"🧩 Création du fichier WSGI (wsgi.py)\"\nsudo tee \"$APP_DIR/wsgi.py\" > /dev/null <<EOF\nfrom app import app\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 7. Configuration du service systemd\necho \"⚙️ Création du service systemd gunicorn\"\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\n[Unit]\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nEnvironment=\"PATH=$VENVDIR/bin\"\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\n# 8. Démarrage du service\necho \"🔄 Activation et lancement du service\"\nsudo systemctl daemon-reexec\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 9. Sécurisation avec UFW\necho \"🛡️ Configuration du pare-feu (UFW)\"\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \"Autorise accès proxy vers API\"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 10. Test local\necho \"🔎 Test local sur http://127.0.0.1:5000\"\ncurl -s http://127.0.0.1:5000 || echo \"⚠️ API non accessible localement, vérifier les logs.\"\n\necho \"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l''API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d''installation de l''app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}', '2025-08-06 12:35:40.771+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (132, 1, 'POST /templates', '{"body":{"name":"Déploiement de l''API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\n\necho \"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\"\nAPP_DIR=\"${APP_DIR}\"\nVENVDIR=\"$APP_DIR/venv\"\nPROXY_IP=\"${PROXY_IP}\"\nAPI_USER=\"${API_USER}\"\n\n# 1. Mise à jour système & dépendances\necho \"📦 Installation des paquets requis...\"\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\nsudo apt install curl -y\n\n# 2. Création du dossier de l''application\necho \"📁 Création du dossier $APP_DIR...\"\nsudo mkdir -p \"$APP_DIR\"\nsudo chown -R $API_USER:$API_USER \"$APP_DIR\"\n\n# 3. Création d''un environnement virtuel Python\necho \"🐍 Initialisation de l’environnement virtuel...\"\nsudo -u $API_USER python3 -m venv \"$VENVDIR\"\nsource \"$VENVDIR/bin/activate\"\n\n# 4. Installation de Flask et Gunicorn\necho \"📦 Installation de Flask & Gunicorn...\"\n\"$VENVDIR/bin/pip\" install flask gunicorn\n\n# 5. Création d’une application Flask minimaliste\necho \"📝 Déploiement de l''application Flask (hello.py)\"\nsudo tee \"$APP_DIR/app.py\" > /dev/null <<EOF\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route(\"/\")\ndef home():\n    return \"✅ Bienvenue sur l’API interne Camer!\"\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 6. Création du fichier WSGI\necho \"🧩 Création du fichier WSGI (wsgi.py)\"\nsudo tee \"$APP_DIR/wsgi.py\" > /dev/null <<EOF\nfrom app import app\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 7. Configuration du service systemd\necho \"⚙️ Création du service systemd gunicorn\"\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\n[Unit]\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nEnvironment=\"PATH=$VENVDIR/bin\"\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\n# 8. Démarrage du service\necho \"🔄 Activation et lancement du service\"\nsudo systemctl daemon-reexec\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 9. Sécurisation avec UFW\necho \"🛡️ Configuration du pare-feu (UFW)\"\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \"Autorise accès proxy vers API\"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 10. Test local\necho \"🔎 Test local sur http://127.0.0.1:5000\"\ncurl -s http://127.0.0.1:5000 || echo \"⚠️ API non accessible localement, vérifier les logs.\"\n\necho \"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l''API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d''installation de l''app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}', '2025-08-06 12:37:28.738+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (133, 1, 'create_template:11', '{}', '2025-08-06 12:37:28.839+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (134, 1, 'POST /templates/generate', '{"body":{"template_id":11,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}', '2025-08-06 12:37:37.614+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (135, 1, 'generate_template_file:11:flask_api_api_D_ploiement_de_l_API_interne_Flask__api_camer_cm__script002.sh', '{}', '2025-08-06 12:37:37.637+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (136, 1, 'POST /templates', '{"body":{"name":"Déploiement de l''API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\n\necho \"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\"\nAPP_DIR=\"${APP_DIR}\"\nVENVDIR=\"$APP_DIR/venv\"\nPROXY_IP=\"${PROXY_IP}\"\nAPI_USER=\"${API_USER}\"\n\n# 1. Mise à jour système & dépendances\necho \"📦 Installation des paquets requis...\"\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\nsudo apt install curl -y\n\n# 2. Création du dossier de l''application\necho \"📁 Création du dossier $APP_DIR...\"\nsudo mkdir -p \"$APP_DIR\"\nsudo chown -R $API_USER:$API_USER \"$APP_DIR\"\n\n# 3. Création d''un environnement virtuel Python\necho \"🐍 Initialisation de l’environnement virtuel...\"\nsudo -u $API_USER python3 -m venv \"$VENVDIR\"\nsource \"$VENVDIR/bin/activate\"\n\n# 4. Installation de Flask et Gunicorn\necho \"📦 Installation de Flask & Gunicorn...\"\n\"$VENVDIR/bin/pip\" install flask gunicorn\n\n# 5. Création d’une application Flask minimaliste\necho \"📝 Déploiement de l''application Flask (hello.py)\"\nsudo tee \"$APP_DIR/app.py\" > /dev/null <<EOF\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route(\"/\")\ndef home():\n    return \"✅ Bienvenue sur l’API interne Camer!\"\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 6. Création du fichier WSGI\necho \"🧩 Création du fichier WSGI (wsgi.py)\"\nsudo tee \"$APP_DIR/wsgi.py\" > /dev/null <<EOF\nfrom app import app\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 7. Configuration du service systemd\necho \"⚙️ Création du service systemd gunicorn\"\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\n[Unit]\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nEnvironment=\"PATH=$VENVDIR/bin\"\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\n# 8. Démarrage du service\necho \"🔄 Activation et lancement du service\"\nsudo systemctl daemon-reexec\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 9. Sécurisation avec UFW\necho \"🛡️ Configuration du pare-feu (UFW)\"\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \"Autorise accès proxy vers API\"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 10. Test local\necho \"🔎 Test local sur http://127.0.0.1:5000\"\ncurl -s http://127.0.0.1:5000 || echo \"⚠️ API non accessible localement, vérifier les logs.\"\n\necho \"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l''API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d''installation de l''app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}', '2025-08-06 12:38:35.52+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (137, 1, 'create_template:12', '{}', '2025-08-06 12:38:35.612+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (189, 1, 'POST /templates/generate', '{"body":{"template_id":20,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}', '2025-08-06 13:14:28.568+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (109, 1, 'POST /templates', '{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance système\ncat <<''EOS'' > ${STATUS_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk ''{print $1}'')\nLOAD_AVG=$(cut -d '' '' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk ''{print $2}'')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk ''{print $2}'')\n\nDISK_TOTAL=$(df -B1 / | tail -1 | awk ''{print $2}'')\nDISK_USED=$(df -B1 / | tail -1 | awk ''{print $3}'')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk ''{print $4}'')\n\nIFACE=$(ip route get 1.1.1.1 | awk ''{print $5; exit}'')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\n\nOPEN_PORTS=$(ss -tuln | awk ''NR>1 {split($5,a,\":\"); print a[length(a)]}'' | sort -n | uniq | paste -sd, -)\n\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk ''{printf \"{\\\"pid\\\":%s,\\\"cmd\\\":\\\"%s\\\",\\\"cpu\\\":%s},\", $1, $2, $3}'')\nTOP_PROCESSES=\"[${TOP_PROCESSES%,}]\"\n\ncat <<JSON > ${STATUS_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"hostname\": \"${HOSTNAME}\",\n  \"ip_address\": \"${IP_ADDR}\",\n  \"load_average\": \"${LOAD_AVG}\",\n  \"memory\": {\n    \"total_kb\": ${MEM_TOTAL},\n    \"available_kb\": ${MEM_AVAILABLE}\n  },\n  \"disk\": {\n    \"total_bytes\": ${DISK_TOTAL},\n    \"used_bytes\": ${DISK_USED},\n    \"available_bytes\": ${DISK_AVAIL}\n  },\n  \"network\": {\n    \"interface\": \"${IFACE}\",\n    \"rx_bytes\": ${RX_BYTES},\n    \"tx_bytes\": ${TX_BYTES}\n  },\n  \"open_ports\": [${OPEN_PORTS}],\n  \"top_processes\": ${TOP_PROCESSES}\n}\nJSON\nEOS\n\nchmod +x ${STATUS_SCRIPT_PATH}","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}', '2025-08-06 12:18:17.291+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (110, 1, 'create_template:7', '{}', '2025-08-06 12:18:17.351+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (111, 1, 'POST /templates/generate', '{"body":{"template_id":7,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}', '2025-08-06 12:18:45.73+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (112, 1, 'generate_template_file:7:system_monitoring_script_monitoring_Surveillance_syst_me_-_G_n_ration_du_script_script001.sh', '{}', '2025-08-06 12:18:45.757+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (113, 1, 'POST /templates', '{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}', '2025-08-06 12:19:40.204+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (114, 1, 'create_template:8', '{}', '2025-08-06 12:19:40.26+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (115, 1, 'POST /templates/generate', '{"body":{"template_id":8,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}', '2025-08-06 12:20:09.364+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (116, 1, 'generate_template_file:8:service_monitoring_script_monitoring_Surveillance_des_services_-_G_n_ration_du_script_script001.sh', '{}', '2025-08-06 12:20:09.384+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (117, 1, 'POST /templates', '{"body":{"name":"Déploiement du serveur Web Camer-Web (web2.camer.cm)","service_type":"web_server_nginx","category":"web","description":"Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.","template_content":"#!/bin/bash\nset -e\n\necho \"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\"\n\n# 1. Installation des paquets\necho \"📦 Installation de nginx et apache2 (optionnel)...\"\nsudo apt update\nsudo apt install curl -y\nsudo apt install nginx apache2 -y\n\n# 2. Préparation du répertoire web\necho \"📁 Création du site web ${WEB_ROOT}\"\nsudo mkdir -p ${WEB_ROOT}\n\necho \"📝 Création de la page d’accueil personnalisée...\"\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\n<!DOCTYPE html>\n<html lang=\\\"fr\\\">\n<head>\n    <meta charset=\\\"UTF-8\\\">\n    <title>Camer-Web</title>\n</head>\n<body style=\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\">\n    <h1>✅ Bienvenue sur Camer-Web</h1>\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\n</body>\n</html>\nEOF\n\n# 3. Création du fichier NGINX vhost\necho \"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\"\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\nserver {\n    listen 80;\n    server_name ${DOMAIN_NAME};\n\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\n\n    root ${WEB_ROOT};\n    index index.html;\n\n    location / {\n        try_files \\$uri \\$uri/ =404;\n    }\n}\nEOF\n\n# 4. Activation du site et désactivation du défaut\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\nsudo rm -f /etc/nginx/sites-enabled/default\n\n# 5. Redémarrage des services\necho \"🚀 Redémarrage de NGINX...\"\nsudo systemctl restart nginx\nsudo systemctl enable nginx\n\n# 6. Pare-feu\necho \"🛡️ Configuration UFW pour NGINX...\"\nsudo ufw allow OpenSSH\nsudo ufw allow 80/tcp\nsudo ufw allow 443/tcp\nsudo ufw --force enable\n\necho\necho \"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\"\n\n: \"\\${INSTANCE_ID:?INSTANCE_ID is required}\"\n\n# Save instance identifier\necho \"INSTANCE_ID=\\${INSTANCE_ID}\" | sudo tee /etc/instance-info.conf > /dev/null\necho \"export INSTANCE_ID=\\${INSTANCE_ID}\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\nsudo chmod +x /etc/profile.d/instance_id.sh\nexport INSTANCE_ID=\\${INSTANCE_ID}\n\n# Log initialization\necho \"$(date --iso-8601=seconds) - Initialized instance with ID: \\${INSTANCE_ID}\" | sudo tee -a /var/log/init.log","script_path":"/scripts/deploy_web2.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web2.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.20.21"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"Camer-Web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}},"query":{}}', '2025-08-06 12:20:32.527+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (118, 1, 'create_template:9', '{}', '2025-08-06 12:20:32.594+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (119, 1, 'POST /templates/generate', '{"body":{"template_id":9,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}', '2025-08-06 12:20:43.435+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (120, 1, 'generate_template_file:9:web_server_nginx_web_D_ploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh', '{}', '2025-08-06 12:20:43.46+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (121, 1, 'POST /templates', '{"body":{"name":"Déploiement de l''API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\n\necho \"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\"\nAPP_DIR=\"${APP_DIR}\"\nVENVDIR=\"$APP_DIR/venv\"\nPROXY_IP=\"${PROXY_IP}\"\nAPI_USER=\"${API_USER}\"\n\n# 1. Mise à jour système & dépendances\necho \"📦 Installation des paquets requis...\"\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\nsudo apt install curl -y\n\n# 2. Création du dossier de l''application\necho \"📁 Création du dossier $APP_DIR...\"\nsudo mkdir -p \"$APP_DIR\"\nsudo chown -R $API_USER:$API_USER \"$APP_DIR\"\n\n# 3. Création d''un environnement virtuel Python\necho \"🐍 Initialisation de l’environnement virtuel...\"\nsudo -u $API_USER python3 -m venv \"$VENVDIR\"\nsource \"$VENVDIR/bin/activate\"\n\n# 4. Installation de Flask et Gunicorn\necho \"📦 Installation de Flask & Gunicorn...\"\n\"$VENVDIR/bin/pip\" install flask gunicorn\n\n# 5. Création d’une application Flask minimaliste\necho \"📝 Déploiement de l''application Flask (hello.py)\"\nsudo tee \"$APP_DIR/app.py\" > /dev/null <<EOF\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route(\"/\")\ndef home():\n    return \"✅ Bienvenue sur l’API interne Camer!\"\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 6. Création du fichier WSGI\necho \"🧩 Création du fichier WSGI (wsgi.py)\"\nsudo tee \"$APP_DIR/wsgi.py\" > /dev/null <<EOF\nfrom app import app\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 7. Configuration du service systemd\necho \"⚙️ Création du service systemd gunicorn\"\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\n[Unit]\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nEnvironment=\"PATH=$VENVDIR/bin\"\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\n# 8. Démarrage du service\necho \"🔄 Activation et lancement du service\"\nsudo systemctl daemon-reexec\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 9. Sécurisation avec UFW\necho \"🛡️ Configuration du pare-feu (UFW)\"\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \"Autorise accès proxy vers API\"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 10. Test local\necho \"🔎 Test local sur http://127.0.0.1:5000\"\ncurl -s http://127.0.0.1:5000 || echo \"⚠️ API non accessible localement, vérifier les logs.\"\n\necho \"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l''API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d''installation de l''app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}', '2025-08-06 12:23:12.691+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (122, 1, 'create_template:10', '{}', '2025-08-06 12:23:12.766+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (123, 1, 'POST /templates/generate', '{"body":{"template_id":10,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}', '2025-08-06 12:23:29.346+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (124, 1, 'generate_template_file:10:flask_api_api_D_ploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh', '{}', '2025-08-06 12:23:29.369+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (125, 1, 'Déploiement Terraform', '{"vm_name":"webtest","service_type":"web","success":true}', '2025-08-06 12:25:42.947+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (126, 1, 'Déploiement Terraform', '{"vm_name":"webtes2t","service_type":"web","success":true}', '2025-08-06 12:30:11.554+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (127, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 12:34:36.59+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (128, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 12:34:43.994+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (129, 1, 'POST /vms/delete', '{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 12:34:48.079+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (138, 1, 'POST /templates', '{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\n\necho \"📦 Installation du serveur NFS...\"\nsudo apt update && sudo apt install -y nfs-kernel-server\n\necho \"📁 Création du dossier partagé ${SHARE_DIR}...\"\nsudo mkdir -p ${SHARE_DIR}\nsudo chown nobody:nogroup ${SHARE_DIR}\nsudo chmod 777 ${SHARE_DIR}\n\necho \"📝 Configuration du fichier /etc/exports...\"\necho \"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\" | sudo tee -a /etc/exports\n\necho \"🔄 Redémarrage du service NFS...\"\nsudo systemctl restart nfs-kernel-server\n\necho \"🔍 Vérification de l’export actif...\"\nsudo exportfs -v\n\necho \"✅ Serveur NFS configuré avec succès.\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.10.0/24"}]}},"query":{}}', '2025-08-06 12:44:18.132+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (139, 1, 'create_template:13', '{}', '2025-08-06 12:44:18.176+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (140, 1, 'PUT /templates/2', '{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\n\necho \"📦 Installation du serveur NFS...\"\nsudo apt update && sudo apt install -y nfs-kernel-server\n\necho \"📁 Création du dossier partagé ${SHARE_DIR}...\"\nsudo mkdir -p ${SHARE_DIR}\nsudo chown nobody:nogroup ${SHARE_DIR}\nsudo chmod 777 ${SHARE_DIR}\n\necho \"📝 Configuration du fichier /etc/exports...\"\necho \"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\" | sudo tee -a /etc/exports\n\necho \"🔄 Redémarrage du service NFS...\"\nsudo systemctl restart nfs-kernel-server\n\necho \"🔍 Vérification de l’export actif...\"\nsudo exportfs -v\n\necho \"✅ Serveur NFS configuré avec succès.\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.24.0/24"}]}},"query":{}}', '2025-08-06 12:44:32.062+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (141, 1, 'PUT /templates/13', '{"body":{"name":"Configuration du serveur NFS","service_type":"nfs_server","category":"file_sharing","description":"Installe et configure un serveur NFS avec un dossier partagé sur /srv/nfs_share accessible au réseau local.","template_content":"#!/bin/bash\n# 🎯 Script de configuration du serveur NFS - nfs.camer.cm\n\necho \"📦 Installation du serveur NFS...\"\nsudo apt update && sudo apt install -y nfs-kernel-server\n\necho \"📁 Création du dossier partagé ${SHARE_DIR}...\"\nsudo mkdir -p ${SHARE_DIR}\nsudo chown nobody:nogroup ${SHARE_DIR}\nsudo chmod 777 ${SHARE_DIR}\n\necho \"📝 Configuration du fichier /etc/exports...\"\necho \"${SHARE_DIR} ${CLIENT_SUBNET}(rw,sync,no_subtree_check)\" | sudo tee -a /etc/exports\n\necho \"🔄 Redémarrage du service NFS...\"\nsudo systemctl restart nfs-kernel-server\n\necho \"🔍 Vérification de l’export actif...\"\nsudo exportfs -v\n\necho \"✅ Serveur NFS configuré avec succès.\"","script_path":"/scripts/nfs_server_setup.sh","fields_schema":{"fields":[{"name":"SHARE_DIR","label":"Dossier partagé","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"CLIENT_SUBNET","label":"Sous-réseau autorisé","type":"text","required":true,"default":"192.168.24.0/24"}]}},"query":{}}', '2025-08-06 12:44:38.468+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (142, 1, 'update_template:13', '{}', '2025-08-06 12:44:38.499+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (143, 1, 'POST /templates', '{"body":{"name":"Configuration du client NFS","service_type":"nfs_client","category":"file_sharing","description":"Installe le client NFS et monte un partage distant automatiquement.","template_content":"#!/bin/bash\n# 🎯 Script de configuration client NFS pour montage du dossier partagé\n\necho \"📦 Installation du client NFS...\"\nsudo apt update && sudo apt install -y nfs-common\n\necho \"📁 Création du dossier local ${MOUNT_DIR}...\"\nsudo mkdir -p ${MOUNT_DIR}\n\necho \"🔗 Montage du partage NFS depuis ${NFS_SERVER}:${SHARE_DIR}\"\nsudo mount ${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR}\n\necho \"🔒 Optionnel : ajout dans /etc/fstab pour montage permanent...\"\necho \"${NFS_SERVER}:${SHARE_DIR} ${MOUNT_DIR} nfs defaults 0 0\" | sudo tee -a /etc/fstab\n\necho \"✅ Client NFS configuré et monté.\"","script_path":"/scripts/nfs_client_setup.sh","fields_schema":{"fields":[{"name":"NFS_SERVER","label":"Adresse IP du serveur NFS","type":"text","required":true,"default":"192.168.10.10"},{"name":"SHARE_DIR","label":"Répertoire exporté par le serveur","type":"text","required":true,"default":"/srv/nfs_share"},{"name":"MOUNT_DIR","label":"Point de montage local","type":"text","required":true,"default":"/mnt/nfs_share"}]}},"query":{}}', '2025-08-06 12:44:51.872+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (144, 1, 'create_template:14', '{}', '2025-08-06 12:44:51.903+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (145, 1, 'POST /templates/generate', '{"body":{"template_id":14,"config_data":{"NFS_SERVER":"192.168.10.10","SHARE_DIR":"/srv/nfs_share","MOUNT_DIR":"/mnt/nfs_share"}},"query":{}}', '2025-08-06 12:45:14.582+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (146, 1, 'generate_template_file:14:nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh', '{}', '2025-08-06 12:45:14.607+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (147, 1, 'POST /templates/generate', '{"body":{"template_id":13,"config_data":{"SHARE_DIR":"/srv/nfs_share","CLIENT_SUBNET":"192.168.10.0/24"}},"query":{}}', '2025-08-06 12:45:30.711+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (148, 1, 'generate_template_file:13:nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh', '{}', '2025-08-06 12:45:30.738+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (149, 1, 'POST /templates', '{"body":{"name":"Configuration DNS Esclave avec BIND9 (dns2)","service_type":"dns_slave","category":"dns","description":"Installe et configure un serveur DNS esclave avec BIND9, prêt à recevoir les zones depuis le DNS maître.","template_content":"#!/bin/bash\n\necho \"📦 Installation de BIND9 sur le DNS slave...\"\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\nsudo apt install curl -y\n\necho \"👤 Ajout de l''utilisateur courant au groupe bind...\"\nsudo usermod -aG bind \"$USER\"\n\necho \"🔄 Activation du nouveau groupe pour cette session...\"\nnewgrp bind <<EONG\n\necho \"📁 Vérification du répertoire de cache BIND...\"\nsudo mkdir -p /var/cache/bind\nsudo chown bind:bind /var/cache/bind\nsudo chmod 770 /var/cache/bind\n\necho \"⚙️ Configuration des options globales dans /etc/bind/named.conf.options...\"\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\noptions {\n    directory \"/var/cache/bind\";\n\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\n    recursion no;\n\n    dnssec-validation auto;\n\n    listen-on { 127.0.0.1; ${SLAVE_IP}; };\n    listen-on-v6 { none; };\n};\nEOF\n\necho \"📌 Configuration des zones esclaves dans /etc/bind/named.conf.local...\"\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\n${ZONE_CONFIGS}\nEOF\n\necho \"🔓 Autorisation du trafic DNS depuis le maître (si UFW est actif)...\"\nsudo ufw allow from ${MASTER_IP} to any port 53 proto udp\nsudo ufw allow from ${MASTER_IP} to any port 53 proto tcp\n\necho \"🚀 Redémarrage de BIND9...\"\nsudo systemctl restart bind9\nsudo systemctl enable bind9\n\necho \"✅ Configuration terminée. Le slave attend les transferts du maître.\"\n\nEONG","script_path":"/scripts/dns_slave_setup.sh","fields_schema":{"fields":[{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"MASTER_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones esclaves (bloc brut)","type":"textarea","required":true,"default":"zone \"camer.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.camer.cm\";\n};\n\nzone \"bunec.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.bunec.cm\";\n};\n\nzone \"etatcivil.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.etatcivil.cm\";\n};\n\nzone \"civilstatus.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.civilstatus.cm\";\n};"}]}},"query":{}}', '2025-08-06 12:45:42.973+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (150, 1, 'create_template:15', '{}', '2025-08-06 12:45:43.023+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (184, 1, 'generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script002.sh', '{}', '2025-08-06 13:09:09.578+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (190, 1, 'generate_template_file:20:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh', '{}', '2025-08-06 13:14:28.603+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (151, 1, 'POST /templates/generate', '{"body":{"template_id":15,"config_data":{"SLAVE_IP":"192.168.20.20","MASTER_IP":"192.168.20.10","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \"camer.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.camer.cm\";\n};\n\nzone \"bunec.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.bunec.cm\";\n};\n\nzone \"etatcivil.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.etatcivil.cm\";\n};\n\nzone \"civilstatus.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.civilstatus.cm\";\n};"}},"query":{}}', '2025-08-06 12:45:52.896+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (152, 1, 'generate_template_file:15:dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh', '{}', '2025-08-06 12:45:52.93+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (153, 1, 'POST /templates', '{"body":{"name":"Configuration DNS Maître avec BIND9 (dns1)","service_type":"dns_master","category":"dns","description":"Installe et configure un serveur DNS maître avec BIND9, en définissant plusieurs zones et en autorisant le transfert vers le serveur esclave.","template_content":"#!/bin/bash\n# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})\n\necho \"📦 Installation de BIND9...\"\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\nsudo apt install curl -y\n\necho \"📁 Création du répertoire des zones...\"\nsudo mkdir -p /etc/bind/zones\nsudo chown bind:bind /etc/bind/zones\n\necho \"🔧 Configuration des options globales dans /etc/bind/named.conf.options...\"\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\noptions {\n    directory \"/var/cache/bind\";\n\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\n    recursion no;\n\n    allow-transfer { ${SLAVE_IP}; };\n    dnssec-validation auto;\n\n    listen-on { 127.0.0.1; ${DNS_IP}; };\n    listen-on-v6 { none; };\n};\nEOF\n\necho \"📌 Définition des zones dans /etc/bind/named.conf.local...\"\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\n${ZONE_CONFIGS}\nEOF\n\necho \"🔓 Autorisation du trafic DNS depuis le slave...\"\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto udp\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp\n\necho \"🚀 Redémarrage du service BIND9...\"\nsudo systemctl restart bind9\nsudo systemctl enable bind9\n\necho \"✅ Configuration du DNS Maître terminée.\"","script_path":"/scripts/dns_master_setup.sh","fields_schema":{"fields":[{"name":"DNS_HOSTNAME","label":"Nom du serveur DNS maître","type":"text","required":true,"default":"dns1.camer.cm"},{"name":"OS_VERSION","label":"Version du système","type":"text","required":true,"default":"Ubuntu 22.04"},{"name":"DNS_IP","label":"Adresse IP du DNS maître","type":"text","required":true,"default":"192.168.20.10"},{"name":"SLAVE_IP","label":"Adresse IP du DNS esclave","type":"text","required":true,"default":"192.168.20.20"},{"name":"ALLOWED_QUERY_SUBNET","label":"Sous-réseau autorisé à interroger","type":"text","required":true,"default":"192.168.0.0/16"},{"name":"ZONE_CONFIGS","label":"Définition des zones BIND (bloc brut)","type":"textarea","required":true,"default":"zone \"camer.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.camer.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"bunec.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.bunec.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"etatcivil.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.etatcivil.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"civilstatus.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.civilstatus.cm\";\n    allow-transfer { 192.168.20.20; };\n};"}]}},"query":{}}', '2025-08-06 12:46:04.833+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (154, 1, 'create_template:16', '{}', '2025-08-06 12:46:04.88+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (155, 1, 'POST /templates/generate', '{"body":{"template_id":16,"config_data":{"DNS_HOSTNAME":"dns1.camer.cm","OS_VERSION":"Ubuntu 22.04","DNS_IP":"192.168.20.10","SLAVE_IP":"192.168.20.20","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \"camer.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.camer.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"bunec.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.bunec.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"etatcivil.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.etatcivil.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"civilstatus.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.civilstatus.cm\";\n    allow-transfer { 192.168.20.20; };\n};"}},"query":{}}', '2025-08-06 12:46:16.588+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (156, 1, 'generate_template_file:16:dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh', '{}', '2025-08-06 12:46:16.621+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (157, 1, 'POST /templates', '{"body":{"name":"Déploiement de l''API interne Flask (api.camer.cm)","service_type":"flask_api","category":"api","description":"Installe et configure automatiquement une API interne en Flask avec Gunicorn et un service systemd, accessible via un reverse proxy.","template_content":"#!/bin/bash\n\necho \"🚀 Déploiement du serveur API - ${DOMAIN_NAME} (${IP_ADDRESS})\"\nAPP_DIR=\"${APP_DIR}\"\nVENVDIR=\"$APP_DIR/venv\"\nPROXY_IP=\"${PROXY_IP}\"\nAPI_USER=\"${API_USER}\"\n\n# 1. Mise à jour système & dépendances\necho \"📦 Installation des paquets requis...\"\nsudo apt update && sudo apt install -y python3-pip python3-venv ufw\nsudo apt install curl -y\n\n# 2. Création du dossier de l''application\necho \"📁 Création du dossier $APP_DIR...\"\nsudo mkdir -p \"$APP_DIR\"\nsudo chown -R $API_USER:$API_USER \"$APP_DIR\"\n\n# 3. Création d''un environnement virtuel Python\necho \"🐍 Initialisation de l’environnement virtuel...\"\nsudo -u $API_USER python3 -m venv \"$VENVDIR\"\nsource \"$VENVDIR/bin/activate\"\n\n# 4. Installation de Flask et Gunicorn\necho \"📦 Installation de Flask & Gunicorn...\"\n\"$VENVDIR/bin/pip\" install flask gunicorn\n\n# 5. Création d’une application Flask minimaliste\necho \"📝 Déploiement de l''application Flask (hello.py)\"\nsudo tee \"$APP_DIR/app.py\" > /dev/null <<EOF\nfrom flask import Flask\napp = Flask(__name__)\n\n@app.route(\"/\")\ndef home():\n    return \"✅ Bienvenue sur l’API interne Camer!\"\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 6. Création du fichier WSGI\necho \"🧩 Création du fichier WSGI (wsgi.py)\"\nsudo tee \"$APP_DIR/wsgi.py\" > /dev/null <<EOF\nfrom app import app\n\nif __name__ == \"__main__\":\n    app.run()\nEOF\n\n# 7. Configuration du service systemd\necho \"⚙️ Création du service systemd gunicorn\"\nsudo tee /etc/systemd/system/${SYSTEMD_SERVICE}.service > /dev/null <<EOF\n[Unit]\nDescription=Service Gunicorn pour API Flask (${DOMAIN_NAME})\nAfter=network.target\n\n[Service]\nUser=$API_USER\nGroup=$API_USER\nWorkingDirectory=$APP_DIR\nEnvironment=\"PATH=$VENVDIR/bin\"\nExecStart=$VENVDIR/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 wsgi:app\nRestart=on-failure\n\n[Install]\nWantedBy=multi-user.target\nEOF\n\n# 8. Démarrage du service\necho \"🔄 Activation et lancement du service\"\nsudo systemctl daemon-reexec\nsudo systemctl daemon-reload\nsudo systemctl enable ${SYSTEMD_SERVICE}\nsudo systemctl start ${SYSTEMD_SERVICE}\nsudo systemctl status ${SYSTEMD_SERVICE} --no-pager\n\n# 9. Sécurisation avec UFW\necho \"🛡️ Configuration du pare-feu (UFW)\"\nsudo ufw allow from $PROXY_IP proto tcp to any port 5000 comment \"Autorise accès proxy vers API\"\nsudo ufw allow OpenSSH\nsudo ufw --force enable\nsudo ufw status verbose\n\n# 10. Test local\necho \"🔎 Test local sur http://127.0.0.1:5000\"\ncurl -s http://127.0.0.1:5000 || echo \"⚠️ API non accessible localement, vérifier les logs.\"\n\necho \"✅ Déploiement terminé. L’API écoute sur le port 5000 (LAN uniquement).\"","script_path":"/scripts/deploy_api.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine de l''API","type":"text","required":true,"default":"api.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.10.17"},{"name":"APP_DIR","label":"Répertoire d''installation de l''app","type":"text","required":true,"default":"/opt/api"},{"name":"PROXY_IP","label":"Adresse IP du reverse proxy autorisé","type":"text","required":true,"default":"192.168.20.14"},{"name":"API_USER","label":"Utilisateur Linux de l’API","type":"text","required":true,"default":"www-data"},{"name":"SYSTEMD_SERVICE","label":"Nom du service systemd","type":"text","required":true,"default":"api-camer-cm"}]}},"query":{}}', '2025-08-06 12:46:35.221+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (158, 1, 'create_template:17', '{}', '2025-08-06 12:46:35.289+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (159, 1, 'POST /templates/generate', '{"body":{"template_id":17,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.10.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.20.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}', '2025-08-06 12:46:53.507+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (160, 1, 'generate_template_file:17:flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh', '{}', '2025-08-06 12:46:53.531+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (161, 1, 'POST /templates', '{"body":{"name":"Déploiement du serveur Web Camer-Web (web2.camer.cm)","service_type":"web_server_nginx","category":"web","description":"Installe NGINX, déploie un site web de test sur la VM web2.camer.cm et configure UFW.","template_content":"#!/bin/bash\nset -e\n\necho \"🌐 Déploiement du serveur Web Camer-Web (${DOMAIN_NAME})...\"\n\n# 1. Installation des paquets\necho \"📦 Installation de nginx et apache2 (optionnel)...\"\nsudo apt update\nsudo apt install curl -y\nsudo apt install nginx apache2 -y\n\n# 2. Préparation du répertoire web\necho \"📁 Création du site web ${WEB_ROOT}\"\nsudo mkdir -p ${WEB_ROOT}\n\necho \"📝 Création de la page d’accueil personnalisée...\"\nsudo tee ${WEB_ROOT}/index.html > /dev/null <<EOF\n<!DOCTYPE html>\n<html lang=\\\"fr\\\">\n<head>\n    <meta charset=\\\"UTF-8\\\">\n    <title>Camer-Web</title>\n</head>\n<body style=\\\"font-family: sans-serif; text-align: center; margin-top: 100px;\\\">\n    <h1>✅ Bienvenue sur Camer-Web</h1>\n    <p>🌐 Vous êtes sur : <strong>${DOMAIN_NAME}</strong></p>\n    <p>📍 IP : <strong>${IP_ADDRESS}</strong></p>\n    <p>🧭 Cette page est hébergée sur la VM <strong>${VM_NAME}</strong></p>\n</body>\n</html>\nEOF\n\n# 3. Création du fichier NGINX vhost\necho \"🔧 Configuration NGINX pour ${DOMAIN_NAME}...\"\nsudo tee /etc/nginx/sites-available/${DOMAIN_NAME} > /dev/null <<EOF\nserver {\n    listen 80;\n    server_name ${DOMAIN_NAME};\n\n    access_log /var/log/nginx/${DOMAIN_NAME}.access.log;\n    error_log /var/log/nginx/${DOMAIN_NAME}.error.log;\n\n    root ${WEB_ROOT};\n    index index.html;\n\n    location / {\n        try_files \\$uri \\$uri/ =404;\n    }\n}\nEOF\n\n# 4. Activation du site et désactivation du défaut\nsudo ln -s /etc/nginx/sites-available/${DOMAIN_NAME} /etc/nginx/sites-enabled/\nsudo rm -f /etc/nginx/sites-enabled/default\n\n# 5. Redémarrage des services\necho \"🚀 Redémarrage de NGINX...\"\nsudo systemctl restart nginx\nsudo systemctl enable nginx\n\n# 6. Pare-feu\necho \"🛡️ Configuration UFW pour NGINX...\"\nsudo ufw allow OpenSSH\nsudo ufw allow 80/tcp\nsudo ufw allow 443/tcp\nsudo ufw --force enable\n\necho\necho \"✅ Camer-Web est prêt. Teste http://${DOMAIN_NAME} depuis le reverse proxy ou le client interne.\"\n\n: \"\\${INSTANCE_ID:?INSTANCE_ID is required}\"\n\n# Save instance identifier\necho \"INSTANCE_ID=\\${INSTANCE_ID}\" | sudo tee /etc/instance-info.conf > /dev/null\necho \"export INSTANCE_ID=\\${INSTANCE_ID}\" | sudo tee /etc/profile.d/instance_id.sh > /dev/null\nsudo chmod +x /etc/profile.d/instance_id.sh\nexport INSTANCE_ID=\\${INSTANCE_ID}\n\n# Log initialization\necho \"$(date --iso-8601=seconds) - Initialized instance with ID: \\${INSTANCE_ID}\" | sudo tee -a /var/log/init.log","script_path":"/scripts/deploy_web2.sh","fields_schema":{"fields":[{"name":"DOMAIN_NAME","label":"Nom de domaine","type":"text","required":true,"default":"web2.camer.cm"},{"name":"IP_ADDRESS","label":"Adresse IP de la VM","type":"text","required":true,"default":"192.168.20.21"},{"name":"VM_NAME","label":"Nom de la VM","type":"text","required":true,"default":"Camer-Web"},{"name":"WEB_ROOT","label":"Chemin du répertoire web","type":"text","required":true,"default":"/var/www/web2.camer.cm"}]}},"query":{}}', '2025-08-06 12:47:06.158+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (162, 1, 'create_template:18', '{}', '2025-08-06 12:47:06.234+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (163, 1, 'POST /templates/generate', '{"body":{"template_id":18,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}', '2025-08-06 12:47:14.817+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (164, 1, 'generate_template_file:18:web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh', '{}', '2025-08-06 12:47:14.854+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (185, 1, 'POST /templates/generate', '{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 13:13:15.179+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (186, 1, 'generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script003.sh', '{}', '2025-08-06 13:13:15.218+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (187, 1, 'POST /templates/generate', '{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 13:13:48.273+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (188, 1, 'generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh', '{}', '2025-08-06 13:13:48.307+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (191, 1, 'POST /templates/generate', '{"body":{"template_id":19,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}', '2025-08-06 13:14:49.003+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (192, 1, 'generate_template_file:19:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh', '{}', '2025-08-06 13:14:49.026+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (193, 1, 'POST /templates/generate', '{"body":{"template_id":18,"config_data":{"DOMAIN_NAME":"web2.camer.cm","IP_ADDRESS":"192.168.20.21","VM_NAME":"Camer-Web","WEB_ROOT":"/var/www/web2.camer.cm"}},"query":{}}', '2025-08-06 13:15:06.195+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (194, 1, 'generate_template_file:18:web_server_nginx_web_Deploiement_du_serveur_Web_Camer-Web__web2_camer_cm__script001.sh', '{}', '2025-08-06 13:15:06.225+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (165, 1, 'POST /templates', '{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","script_path":"/scripts/install_services_monitoring.sh","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}', '2025-08-06 12:47:28.027+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (166, 1, 'create_template:19', '{}', '2025-08-06 12:47:28.062+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (167, 1, 'POST /templates/generate', '{"body":{"template_id":19,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}', '2025-08-06 12:47:41.342+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (168, 1, 'generate_template_file:19:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script001.sh', '{}', '2025-08-06 12:47:41.362+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (169, 1, 'POST /templates', '{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance système\ncat <<''EOS'' > ${STATUS_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk ''{print $1}'')\nLOAD_AVG=$(cut -d '' '' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk ''{print $2}'')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk ''{print $2}'')\n\nDISK_TOTAL=$(df -B1 / | tail -1 | awk ''{print $2}'')\nDISK_USED=$(df -B1 / | tail -1 | awk ''{print $3}'')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk ''{print $4}'')\n\nIFACE=$(ip route get 1.1.1.1 | awk ''{print $5; exit}'')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\n\nOPEN_PORTS=$(ss -tuln | awk ''NR>1 {split($5,a,\":\"); print a[length(a)]}'' | sort -n | uniq | paste -sd, -)\n\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk ''{printf \"{\\\"pid\\\":%s,\\\"cmd\\\":\\\"%s\\\",\\\"cpu\\\":%s},\", $1, $2, $3}'')\nTOP_PROCESSES=\"[${TOP_PROCESSES%,}]\"\n\ncat <<JSON > ${STATUS_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"hostname\": \"${HOSTNAME}\",\n  \"ip_address\": \"${IP_ADDR}\",\n  \"load_average\": \"${LOAD_AVG}\",\n  \"memory\": {\n    \"total_kb\": ${MEM_TOTAL},\n    \"available_kb\": ${MEM_AVAILABLE}\n  },\n  \"disk\": {\n    \"total_bytes\": ${DISK_TOTAL},\n    \"used_bytes\": ${DISK_USED},\n    \"available_bytes\": ${DISK_AVAIL}\n  },\n  \"network\": {\n    \"interface\": \"${IFACE}\",\n    \"rx_bytes\": ${RX_BYTES},\n    \"tx_bytes\": ${TX_BYTES}\n  },\n  \"open_ports\": [${OPEN_PORTS}],\n  \"top_processes\": ${TOP_PROCESSES}\n}\nJSON\nEOS\n\nchmod +x ${STATUS_SCRIPT_PATH}","script_path":"/scripts/install_status_monitoring.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}', '2025-08-06 12:47:52.513+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (170, 1, 'create_template:20', '{}', '2025-08-06 12:47:52.57+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (171, 1, 'POST /templates/generate', '{"body":{"template_id":20,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}', '2025-08-06 12:48:01.882+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (172, 1, 'generate_template_file:20:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script001.sh', '{}', '2025-08-06 12:48:01.898+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (173, 1, 'POST /templates', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 12:48:14.792+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (174, 1, 'create_template:21', '{}', '2025-08-06 12:48:14.824+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (175, 1, 'POST /templates/generate', '{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 12:48:27.974+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (176, 1, 'generate_template_file:21:monitoring_cron_monitoring_Activation_des_cronjobs_de_supervision_script001.sh', '{}', '2025-08-06 12:48:27.993+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (177, 1, 'Déploiement Terraform', '{"vm_name":"webtes2t","service_type":"web","success":true}', '2025-08-06 12:51:06.197+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (178, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 12:51:32.259+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (179, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 13:05:23.713+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (180, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"inst-0001"},"query":{}}', '2025-08-06 13:05:28.766+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (181, 1, 'Déploiement Terraform', '{"vm_name":"we0w2b","service_type":"web","success":true}', '2025-08-06 13:05:44.363+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (182, 1, 'POST /templates/generate', '{"body":{"template_id":17,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 13:08:57.92+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (183, 1, 'POST /templates/generate', '{"body":{"template_id":21,"config_data":{"STATUS_SCRIPT":"/opt/monitoring/status.sh","SERVICES_SCRIPT":"/opt/monitoring/services_status.sh","STATUS_CRON_INTERVAL":"5","SERVICES_CRON_INTERVAL":"5"}},"query":{}}', '2025-08-06 13:09:09.547+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (369, 1, 'GET /logs?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:51:39.062+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (195, 1, 'POST /templates/generate', '{"body":{"template_id":17,"config_data":{"DOMAIN_NAME":"api.camer.cm","IP_ADDRESS":"192.168.24.17","APP_DIR":"/opt/api","PROXY_IP":"192.168.24.14","API_USER":"www-data","SYSTEMD_SERVICE":"api-camer-cm"}},"query":{}}', '2025-08-06 13:17:04.714+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (196, 1, 'generate_template_file:17:flask_api_api_Deploiement_de_l_API_interne_Flask__api_camer_cm__script001.sh', '{}', '2025-08-06 13:17:04.741+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (197, 1, 'POST /templates/generate', '{"body":{"template_id":16,"config_data":{"DNS_HOSTNAME":"dns1.camer.cm","OS_VERSION":"Ubuntu 22.04","DNS_IP":"192.168.24.10","SLAVE_IP":"192.168.24.20","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \"camer.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.camer.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"bunec.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.bunec.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"etatcivil.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.etatcivil.cm\";\n    allow-transfer { 192.168.20.20; };\n};\n\nzone \"civilstatus.cm\" {\n    type master;\n    file \"/etc/bind/zones/db.civilstatus.cm\";\n    allow-transfer { 192.168.20.20; };\n};"}},"query":{}}', '2025-08-06 13:18:10.466+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (198, 1, 'generate_template_file:16:dns_master_dns_Configuration_DNS_Maitre_avec_BIND9__dns1__script001.sh', '{}', '2025-08-06 13:18:10.505+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (199, 1, 'POST /templates/generate', '{"body":{"template_id":15,"config_data":{"SLAVE_IP":"192.168.24.20","MASTER_IP":"192.168.24.10","ALLOWED_QUERY_SUBNET":"192.168.0.0/16","ZONE_CONFIGS":"zone \"camer.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.camer.cm\";\n};\n\nzone \"bunec.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.bunec.cm\";\n};\n\nzone \"etatcivil.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.etatcivil.cm\";\n};\n\nzone \"civilstatus.cm\" {\n    type slave;\n    masters { 192.168.20.10; };\n    file \"/var/cache/bind/db.civilstatus.cm\";\n};"}},"query":{}}', '2025-08-06 13:18:31.816+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (200, 1, 'generate_template_file:15:dns_slave_dns_Configuration_DNS_Esclave_avec_BIND9__dns2__script001.sh', '{}', '2025-08-06 13:18:31.858+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (201, 1, 'POST /templates/generate', '{"body":{"template_id":13,"config_data":{"SHARE_DIR":"/srv/nfs_share","CLIENT_SUBNET":"192.168.10.0/24"}},"query":{}}', '2025-08-06 13:18:50.516+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (202, 1, 'generate_template_file:13:nfs_server_file_sharing_Configuration_du_serveur_NFS_script001.sh', '{}', '2025-08-06 13:18:50.54+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (203, 1, 'POST /templates/generate', '{"body":{"template_id":14,"config_data":{"NFS_SERVER":"192.168.10.10","SHARE_DIR":"/srv/nfs_share","MOUNT_DIR":"/mnt/nfs_share"}},"query":{}}', '2025-08-06 13:19:05.422+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (204, 1, 'generate_template_file:14:nfs_client_file_sharing_Configuration_du_client_NFS_script001.sh', '{}', '2025-08-06 13:19:05.442+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (205, 1, 'Déploiement Terraform', '{"vm_name":"Webapache","service_type":"web","success":true}', '2025-08-06 13:19:38.764+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (206, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-06 14:31:11.598+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (207, 1, 'login', '{"user_id":1}', '2025-08-06 14:31:11.839+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (208, 1, 'POST /permissions', '{"body":{"name":"script.analyze","description":"Analyser un script avec l’IA"},"query":{}}', '2025-08-06 14:31:31.092+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (209, 1, 'POST /permissions', '{"body":{"name":"script.read","description":"Lire les analyses de script IA"},"query":{}}', '2025-08-06 14:32:09.144+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (210, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[45,46]}],"query":{}}', '2025-08-06 14:32:20.15+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (211, 1, 'POST /permissions', '{"body":{"name":"template.analyze","description":"Analyse du template"},"query":{}}', '2025-08-06 14:37:58.465+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (212, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[47]}],"query":{}}', '2025-08-06 14:38:07.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (213, 1, 'POST /templates', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 14:38:16.339+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (214, 1, 'create_template:22', '{}', '2025-08-06 14:38:16.378+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (215, 1, 'POST /templates/analyze', '{"body":{"name":"Activation des cronjobs de supervision","service_type":"monitoring_cron","category":"monitoring","description":"Ajoute dynamiquement les tâches cron pour exécuter les scripts de supervision.","template_content":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi","script_path":"/scripts/register_cronjobs.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT","label":"Chemin script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT","label":"Chemin script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_INTERVAL","label":"Fréquence status (min)","type":"number","required":true,"default":5},{"name":"SERVICES_CRON_INTERVAL","label":"Fréquence services (min)","type":"number","required":true,"default":5}]}},"query":{}}', '2025-08-06 14:41:17.661+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (216, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt install bind9 -y\nsystemctl enable bind9"},"query":{}}', '2025-08-06 14:41:46.993+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (217, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt install bind9 -y\nsystemctl enable bind9"},"query":{}}', '2025-08-06 14:42:47.183+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (218, 1, 'POST /templates/analyze', '{"body":{"script_content":"#!/bin/bash\nsudo apt update"},"query":{}}', '2025-08-06 14:44:39.688+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (370, 1, 'GET /logs?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:51:39.109+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (219, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 14:44:58.763+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (220, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 14:45:55.51+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (221, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 14:48:59.019+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (222, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:01:12.237+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (223, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:21:45.518+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (224, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:27:34.396+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (225, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:29:40.83+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (226, 1, 'GET /templates//2/assistant-help', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:50:04.094+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (227, 1, 'GET /templates/2/assistant-help', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:50:23.733+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (228, 1, 'GET /templates/9/assistant-help', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:50:32.887+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (229, 1, 'GET /templates/9/assistant-help', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 15:51:07.676+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (230, 1, 'POST /permissions', '{"body":{"name":"template.audit","description":"template.audit"},"query":{}}', '2025-08-06 16:05:38.324+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (231, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[48]}],"query":{}}', '2025-08-06 16:05:46.202+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (232, 1, 'POST /templates/audit', '{"body":{"script":"#!/bin/bash\nsudo apt update && sudo apt install nginx"},"query":{}}', '2025-08-06 16:06:30.268+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (233, 1, 'POST /templates/audit', '{"body":{"script":"#!/bin/bash\n# 🧠 Script de configuration du DNS Maître - ${DNS_HOSTNAME} (${OS_VERSION})\n\necho \"📦 Installation de BIND9...\"\nsudo apt update && sudo apt install bind9 bind9utils bind9-doc -y\nsudo apt install curl -y\n\necho \"📁 Création du répertoire des zones...\"\nsudo mkdir -p /etc/bind/zones\nsudo chown bind:bind /etc/bind/zones\n\necho \"🔧 Configuration des options globales dans /etc/bind/named.conf.options...\"\nsudo tee /etc/bind/named.conf.options > /dev/null <<EOF\noptions {\n    directory \"/var/cache/bind\";\n\n    allow-query { 127.0.0.1; ${ALLOWED_QUERY_SUBNET}; };\n    recursion no;\n\n    allow-transfer { ${SLAVE_IP}; };\n    dnssec-validation auto;\n\n    listen-on { 127.0.0.1; ${DNS_IP}; };\n    listen-on-v6 { none; };\n};\nEOF\n\necho \"📌 Définition des zones dans /etc/bind/named.conf.local...\"\nsudo tee /etc/bind/named.conf.local > /dev/null <<EOF\n${ZONE_CONFIGS}\nEOF\n\necho \"🔓 Autorisation du trafic DNS depuis le slave...\"\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto udp\nsudo ufw allow from ${SLAVE_IP} to any port 53 proto tcp\n\necho \"🚀 Redémarrage du service BIND9...\"\nsudo systemctl restart bind9\nsudo systemctl enable bind9\n\necho \"✅ Configuration du DNS Maître terminée.\""},"query":{}}', '2025-08-06 16:08:17.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (234, 1, 'PUT /permissions/48', '{"body":{"name":"template.audit","description":"Auditer un script avec IA avant déploiement"},"query":{}}', '2025-08-06 16:13:34.202+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (235, 1, 'POST /permissions', '{"body":[{"name":"template.explain","description":"Explain script using AI"},{"name":"template.analyze","description":"Analyze script using AI"},{"name":"template.explainVariables","description":"Explain template variables using AI"},{"name":"template.summarizeLogs","description":"Summarize deployment logs using AI"},{"name":"template.suggestBundle","description":"Suggest stack bundles using AI"},{"name":"template.simulateExecution","description":"Simulate script execution using AI"}],"query":{}}', '2025-08-06 16:49:12.794+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (236, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[49,50,51,52,53]}],"query":{}}', '2025-08-06 16:49:30.121+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (237, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-06 16:50:25.232+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (238, 1, 'login', '{"user_id":1}', '2025-08-06 16:50:25.418+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (239, 1, 'POST /templates/explain', '{"body":{"script":"#!/bin/bash\necho hello"},"query":{}}', '2025-08-06 16:50:59.816+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (240, 1, 'POST /templates/logs/summarize', '{"body":{"logs":"Log line 1\nLog line 2"},"query":{}}', '2025-08-06 16:51:51.723+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (241, 1, 'POST /templates/bundle', '{"body":{"needs":"Hébergement web"},"query":{}}', '2025-08-06 16:54:19.826+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (242, 1, 'POST /templates/simulate', '{"body":{"script":"#!/bin/bash\nsystemctl restart nginx"},"query":{}}', '2025-08-06 16:54:22.25+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (243, 1, 'POST /templates/variables/explain', '{"body":{"template":"#!/bin/bash\nexport VAR={{VALUE}}"},"query":{}}', '2025-08-06 16:54:30.585+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (244, 1, 'POST /templates/variables/explain', '{"body":{"template":"#!/bin/bash\nexport VAR={{VALUE}}"},"query":{}}', '2025-08-06 16:56:08.844+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (245, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:03:09.024+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (246, 1, 'login', '{"user_id":1}', '2025-08-07 03:03:09.233+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (247, 1, 'POST /auth/register', '{"body":{"first_name":"John","last_name":"Doe","email":"john@example.com","password":"secret","role_id":1},"query":{}}', '2025-08-07 03:03:09.407+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (248, NULL, 'POST /auth/request-reset', '{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}', '2025-08-07 03:03:09.503+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (249, 1, 'request_reset_code', '{"user_id":1}', '2025-08-07 03:03:13.63+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (250, NULL, 'POST /auth/reset-password', '{"body":{"code":"803327","password":"admin123."},"query":{}}', '2025-08-07 03:03:13.707+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (251, 1, 'GET /auth/reset-history', '{"query":{}}', '2025-08-07 03:03:13.848+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (252, 1, 'view_reset_history', '{}', '2025-08-07 03:03:13.859+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (253, 1, 'POST /users', '{"body":{"first_name":"Jane","last_name":"Doe","email":"jane@example.com","password":"secret","role_id":2},"query":{}}', '2025-08-07 03:03:13.991+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (254, 1, 'DELETE /users/1', '{"query":{}}', '2025-08-07 03:03:14.311+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (255, 1, 'GET /users/1', '{"query":{}}', '2025-08-07 03:03:14.45+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (256, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:03:14.593+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (257, 1, 'PATCH /users/1', '{"body":{"last_name":"Smith"},"query":{}}', '2025-08-07 03:03:14.753+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (258, 1, 'GET /users/search?query=Jane', '{"query":{"query":"Jane"}}', '2025-08-07 03:03:14.886+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (259, 1, 'PUT /users/1', '{"body":{"first_name":"Jane"},"query":{}}', '2025-08-07 03:03:15.03+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (260, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:03:15.17+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (261, 1, 'GET /roles/1', '{"query":{}}', '2025-08-07 03:03:15.314+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (262, 1, 'POST /roles', '{"body":{"name":"editor","description":"Content editor"},"query":{}}', '2025-08-07 03:03:15.442+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (263, 1, 'PUT /roles/1', '{"body":{"description":"Updated role"},"query":{}}', '2025-08-07 03:03:15.581+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (264, 1, 'DELETE /roles/1', '{"query":{}}', '2025-08-07 03:03:15.729+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (265, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:09:17.691+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (266, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:09:51.167+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (267, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:10:03.561+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (268, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:12:07.792+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (643, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:13:34.036+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (269, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:12:29.238+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (270, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:13:16.518+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (271, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:14:13.131+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (272, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:15:40.803+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (273, 1, 'login', '{"user_id":1}', '2025-08-07 03:15:40.976+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (274, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update"},"query":{}}', '2025-08-07 03:16:00.784+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (275, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update"},"query":{}}', '2025-08-07 03:17:37.36+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (276, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update"},"query":{}}', '2025-08-07 03:18:02.041+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (277, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nsudo apt update"},"query":{}}', '2025-08-07 03:18:05.707+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (278, 1, 'POST /templates/variables/explain', '{"body":{"template":"#!/bin/bash\nexport VAR={{VALUE}}"},"query":{}}', '2025-08-07 03:19:12.44+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (279, 1, 'POST /templates/variables/explain', '{"body":{"template":"#!/bin/bash\nexport VAR={{VALUE}}"},"query":{}}', '2025-08-07 03:20:30.172+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (280, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 03:46:47.538+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (281, 1, 'login', '{"user_id":1}', '2025-08-07 03:46:47.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (282, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:46:47.939+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (283, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:46:47.982+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (284, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:46:48.027+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (285, 1, 'GET /logs', '{"query":{}}', '2025-08-07 03:46:48.07+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (286, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:46:48.114+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (287, 1, 'GET /vms', '{"query":{}}', '2025-08-07 03:46:48.181+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (288, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:46:48.38+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (289, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:46:48.42+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (290, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:46:48.456+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (291, 1, 'GET /logs', '{"query":{}}', '2025-08-07 03:46:48.514+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (292, 1, 'list_vms', '{}', '2025-08-07 03:46:48.539+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (293, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:46:48.663+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (294, 1, 'GET /vms', '{"query":{}}', '2025-08-07 03:46:48.72+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (295, 1, 'list_vms', '{}', '2025-08-07 03:46:48.762+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (296, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:47:19.782+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (297, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:47:19.825+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (298, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:47:19.898+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (299, 1, 'GET /logs', '{"query":{}}', '2025-08-07 03:47:19.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (300, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:47:19.977+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (301, 1, 'GET /vms', '{"query":{}}', '2025-08-07 03:47:20.034+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (302, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:47:20.167+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (303, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:47:20.203+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (304, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:47:20.245+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (305, 1, 'GET /logs', '{"query":{}}', '2025-08-07 03:47:20.334+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (306, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:47:20.417+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (307, 1, 'list_vms', '{}', '2025-08-07 03:47:20.423+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (308, 1, 'GET /vms', '{"query":{}}', '2025-08-07 03:47:20.526+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (309, 1, 'list_vms', '{}', '2025-08-07 03:47:20.554+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (310, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:47:34.542+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (311, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:47:34.615+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (312, 1, 'GET /users/1', '{"query":{}}', '2025-08-07 03:47:38.112+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (313, 1, 'GET /users/1', '{"query":{}}', '2025-08-07 03:47:38.172+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (314, 1, 'PUT /users/1', '{"body":{"first_name":"Nexus","last_name":"Nexus Latif","email":"latifnjimoluh@gmail.com","role_id":1},"query":{}}', '2025-08-07 03:47:46.951+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (315, 1, 'GET /users/1', '{"query":{}}', '2025-08-07 03:47:47.021+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (316, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:47:49.696+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (317, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:47:49.766+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (318, 1, 'GET /users/1', '{"query":{}}', '2025-08-07 03:47:52.53+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (319, 1, 'GET /users/1', '{"query":{}}', '2025-08-07 03:47:52.591+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (320, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:48:00.218+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (321, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:48:00.277+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (322, 1, 'GET /roles/2', '{"query":{}}', '2025-08-07 03:48:05.624+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (323, 1, 'GET /roles/2', '{"query":{}}', '2025-08-07 03:48:05.682+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (324, 1, 'PUT /roles/2', '{"body":{"name":"Admin","description":""},"query":{}}', '2025-08-07 03:48:11.306+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (325, 1, 'GET /roles/2', '{"query":{}}', '2025-08-07 03:48:11.373+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (326, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:48:13.639+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (327, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:48:13.701+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (328, 1, 'GET /roles/2', '{"query":{}}', '2025-08-07 03:48:16.991+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (329, 1, 'GET /roles/2', '{"query":{}}', '2025-08-07 03:48:17.05+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (330, 1, 'PUT /roles/2', '{"body":{"name":"admin","description":""},"query":{}}', '2025-08-07 03:48:21.129+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (331, 1, 'GET /roles/2', '{"query":{}}', '2025-08-07 03:48:21.199+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (332, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:48:32.494+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (333, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:48:32.554+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (334, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:50:13.516+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (335, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:50:13.549+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (336, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:50:13.58+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (337, 1, 'GET /logs', '{"query":{}}', '2025-08-07 03:50:13.613+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (338, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:50:13.652+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (339, 1, 'GET /vms', '{"query":{}}', '2025-08-07 03:50:13.701+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (340, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:50:13.825+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (341, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:50:13.868+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (342, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:50:13.913+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (343, 1, 'GET /logs', '{"query":{}}', '2025-08-07 03:50:13.979+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (344, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:50:14.049+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (345, 1, 'list_vms', '{}', '2025-08-07 03:50:14.063+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (346, 1, 'GET /vms', '{"query":{}}', '2025-08-07 03:50:14.162+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (347, 1, 'list_vms', '{}', '2025-08-07 03:50:14.183+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (348, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:50:14.853+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (349, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:50:14.911+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (350, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:50:16.04+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (351, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:50:16.083+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (352, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:50:17.186+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (353, 1, 'GET /users', '{"query":{}}', '2025-08-07 03:50:17.242+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (354, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:50:19.396+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (355, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:50:19.446+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (356, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:50:20.599+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (357, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:50:20.668+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (358, 1, 'GET /auth/reset-history', '{"query":{}}', '2025-08-07 03:51:25.443+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (359, 1, 'view_reset_history', '{}', '2025-08-07 03:51:25.453+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (360, 1, 'GET /auth/reset-history', '{"query":{}}', '2025-08-07 03:51:25.498+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (361, 1, 'view_reset_history', '{}', '2025-08-07 03:51:25.502+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (362, 1, 'GET /logs?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:51:28.104+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (363, 1, 'GET /logs?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:51:28.163+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (364, 1, 'GET /logs?page=2&q=', '{"query":{"page":"2","q":""}}', '2025-08-07 03:51:31.657+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (365, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:51:34.803+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (366, 1, 'GET /roles', '{"query":{}}', '2025-08-07 03:51:34.853+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (367, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:51:36.595+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (368, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:51:36.643+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (644, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:14:27.594+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (371, 1, 'GET /logs?page=2&q=', '{"query":{"page":"2","q":""}}', '2025-08-07 03:51:42.444+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (373, 1, 'GET /settings/me', '{"query":{}}', '2025-08-07 03:51:45.462+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (376, 1, 'GET /settings', '{"query":{}}', '2025-08-07 03:51:45.603+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1233, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:34:04.158+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1234, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:34:04.222+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1244, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:00:55.089+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1245, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:00:55.155+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1257, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:14:05.147+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1272, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:22.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1273, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:22.985+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1283, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:26:46.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1296, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:27.459+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1297, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:27.539+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1308, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 11:51:22.828+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1309, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 11:51:28.608+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1329, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:59:21.93+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1338, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-10 12:07:22.961+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1350, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 12:52:18.942+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1351, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 12:52:19.015+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1362, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 13:23:37.559+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1363, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 13:23:37.626+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1378, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:40:11.931+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1386, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:48:11.914+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1394, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:56:11.972+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1402, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:04:11.926+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1410, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:12:11.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1418, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:20:11.935+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1426, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:28:12.024+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1434, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:36:11.949+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1442, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:44:11.926+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1450, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:52:11.927+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1458, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 15:00:11.921+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1482, 1, 'GET /templates', '{"query":{}}', '2025-08-10 22:40:39.502+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1500, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:04:27.421+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1511, 1, 'GET /roles', '{"query":{}}', '2025-08-11 07:09:10.922+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1513, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-11 07:09:14.34+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1515, 1, 'GET /roles', '{"query":{}}', '2025-08-11 07:09:14.446+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1535, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:11:13.786+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1536, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:11:13.843+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1549, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-11 09:19:51.325+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1566, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:22:07.3+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1581, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 09:45:20.485+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1582, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 09:45:20.554+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1600, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:25:52.369+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1601, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:25:52.439+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1612, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 10:45:33.72+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1613, 1, 'list_vms', '{}', '2025-08-11 10:45:33.782+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1614, 1, 'GET /vms', '{"query":{}}', '2025-08-11 10:45:33.859+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1629, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:49:31.633+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1630, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:49:31.684+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1656, 1, 'GET /vms', '{"query":{}}', '2025-08-11 10:57:43.104+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1659, 1, 'GET /vms', '{"query":{}}', '2025-08-11 10:57:43.231+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1672, 1, 'terminal_list_vms', '{}', '2025-08-11 11:46:26.322+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1673, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 11:46:26.373+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1694, 1, 'Échec Déploiement Terraform', '{}', '2025-08-11 12:47:22.579+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1708, 1, 'list_vms', '{}', '2025-08-11 13:28:15.683+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1731, 1, 'POST /vms/105/start', '{"query":{}}', '2025-08-11 13:36:30.742+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1732, 1, 'start_vm:105', '{}', '2025-08-11 13:36:30.786+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1751, 1, 'GET /templates', '{"query":{}}', '2025-08-11 14:24:54.137+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1759, 1, 'GET /vms', '{"query":{}}', '2025-08-12 01:59:44.936+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1768, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 03:22:29.153+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1769, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 03:22:29.229+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1770, 1, 'GET /roles', '{"query":{}}', '2025-08-12 03:22:29.27+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1772, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 03:22:29.393+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1775, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 03:22:29.547+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1777, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 03:22:29.629+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1797, 1, 'list_vms', '{}', '2025-08-12 03:25:00.446+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1807, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 04:33:14.348+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1809, 1, 'list_vms', '{}', '2025-08-12 04:33:14.401+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1810, 1, 'GET /vms', '{"query":{}}', '2025-08-12 04:33:14.462+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1814, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:33:22.313+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1817, 1, 'POST /templates', '{"body":{"name":"Surveillance système - Génération du script","service_type":"system_monitoring_script","category":"monitoring","description":"Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh","template_content":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance système\ncat <<''EOS'' > ${STATUS_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk ''{print $1}'')\nLOAD_AVG=$(cut -d '' '' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk ''{print $2}'')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk ''{print $2}'')\n\nDISK_TOTAL=$(df -B1 / | tail -1 | awk ''{print $2}'')\nDISK_USED=$(df -B1 / | tail -1 | awk ''{print $3}'')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk ''{print $4}'')\n\nIFACE=$(ip route get 1.1.1.1 | awk ''{print $5; exit}'')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\n\nOPEN_PORTS=$(ss -tuln | awk ''NR>1 {split($5,a,\":\"); print a[length(a)]}'' | sort -n | uniq | paste -sd, -)\n\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk ''{printf \"{\\\"pid\\\":%s,\\\"cmd\\\":\\\"%s\\\",\\\"cpu\\\":%s},\", $1, $2, $3}'')\nTOP_PROCESSES=\"[${TOP_PROCESSES%,}]\"\n\ncat <<JSON > ${STATUS_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"hostname\": \"${HOSTNAME}\",\n  \"ip_address\": \"${IP_ADDR}\",\n  \"load_average\": \"${LOAD_AVG}\",\n  \"memory\": {\n    \"total_kb\": ${MEM_TOTAL},\n    \"available_kb\": ${MEM_AVAILABLE}\n  },\n  \"disk\": {\n    \"total_bytes\": ${DISK_TOTAL},\n    \"used_bytes\": ${DISK_USED},\n    \"available_bytes\": ${DISK_AVAIL}\n  },\n  \"network\": {\n    \"interface\": \"${IFACE}\",\n    \"rx_bytes\": ${RX_BYTES},\n    \"tx_bytes\": ${TX_BYTES}\n  },\n  \"open_ports\": [${OPEN_PORTS}],\n  \"top_processes\": ${TOP_PROCESSES}\n}\nJSON\nEOS\n\nchmod +x ${STATUS_SCRIPT_PATH}","script_path":"/scripts/install_status_monitoring.sh","fields_schema":{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}},"query":{}}', '2025-08-12 04:36:50.541+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1818, 1, 'create_template:26', '{}', '2025-08-12 04:36:50.555+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1833, 1, 'Échec Déploiement Terraform', '{"code":"TF_APPLY_FAILED","message":"Le déploiement a échoué."}', '2025-08-12 04:53:22.307+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1847, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-12 11:09:21.637+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1848, 1, 'login', '{"user_id":1}', '2025-08-12 11:09:21.833+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1849, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 11:09:23.927+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1850, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:09:23.93+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1851, 1, 'list_vms', '{}', '2025-08-12 11:09:23.999+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1852, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:09:24.08+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1853, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 11:09:24.133+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1854, 1, 'list_vms', '{}', '2025-08-12 11:09:24.153+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1865, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 11:22:57.767+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (372, 1, 'GET /logs?page=3&q=', '{"query":{"page":"3","q":""}}', '2025-08-07 03:51:43.446+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (374, 1, 'GET /settings', '{"query":{}}', '2025-08-07 03:51:45.503+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (375, 1, 'GET /settings/me', '{"query":{}}', '2025-08-07 03:51:45.57+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (377, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:51:55.445+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (378, 1, 'GET /templates', '{"query":{}}', '2025-08-07 03:51:55.505+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (379, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:55:55.451+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (380, 1, 'list_vms', '{}', '2025-08-07 03:55:55.475+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (381, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:55:55.522+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (382, 1, 'list_vms', '{}', '2025-08-07 03:55:55.54+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (383, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:56:47.99+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (384, 1, 'list_vms', '{}', '2025-08-07 03:56:48.017+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (385, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:56:48.059+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (386, 1, 'list_vms', '{}', '2025-08-07 03:56:48.086+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (387, 1, 'GET /vms/conversions', '{"query":{}}', '2025-08-07 03:56:51.219+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (388, 1, 'view_conversion_history', '{}', '2025-08-07 03:56:51.231+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (389, 1, 'GET /vms/conversions', '{"query":{}}', '2025-08-07 03:56:51.291+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (390, 1, 'view_conversion_history', '{}', '2025-08-07 03:56:51.3+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (391, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:56:53.739+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (392, 1, 'list_vms', '{}', '2025-08-07 03:56:53.769+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (393, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 03:56:53.816+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (394, 1, 'list_vms', '{}', '2025-08-07 03:56:53.843+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (395, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 03:57:15.579+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (396, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 03:57:15.627+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (397, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}', '2025-08-07 03:57:55.603+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (398, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\\nsudo apt update"},"query":{}}', '2025-08-07 03:58:28.733+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (399, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 03:58:33.417+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (400, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 03:58:33.462+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (401, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:58:47.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (402, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:58:47.809+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (403, 1, 'POST /permissions', '{"body":{"name":"aiCache.list","description":"Liste des requete deja recu"},"query":{}}', '2025-08-07 03:59:05.036+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (404, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 03:59:05.097+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (405, 1, 'GET /permissions/54', '{"query":{}}', '2025-08-07 03:59:11.889+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (406, 1, 'GET /permissions/54', '{"query":{}}', '2025-08-07 03:59:11.946+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (407, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[54]}],"query":{}}', '2025-08-07 03:59:26.833+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (408, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 03:59:29.477+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (409, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 03:59:29.526+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (410, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}', '2025-08-07 04:09:27.443+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (411, 1, 'login', '{"user_id":1}', '2025-08-07 04:09:27.647+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (412, 1, 'GET /users', '{"query":{}}', '2025-08-07 04:09:27.822+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (413, 1, 'GET /roles', '{"query":{}}', '2025-08-07 04:09:27.88+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (414, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 04:09:27.96+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (415, 1, 'GET /logs', '{"query":{}}', '2025-08-07 04:09:27.999+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (416, 1, 'GET /templates', '{"query":{}}', '2025-08-07 04:09:28.038+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (417, 1, 'GET /vms', '{"query":{}}', '2025-08-07 04:09:28.055+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (418, 1, 'GET /users', '{"query":{}}', '2025-08-07 04:09:28.223+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (419, 1, 'GET /roles', '{"query":{}}', '2025-08-07 04:09:28.26+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (420, 1, 'GET /permissions', '{"query":{}}', '2025-08-07 04:09:28.302+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (421, 1, 'list_vms', '{}', '2025-08-07 04:09:28.312+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (422, 1, 'GET /logs', '{"query":{}}', '2025-08-07 04:09:28.36+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (423, 1, 'GET /templates', '{"query":{}}', '2025-08-07 04:09:28.42+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (424, 1, 'GET /vms', '{"query":{}}', '2025-08-07 04:09:28.552+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (425, 1, 'list_vms', '{}', '2025-08-07 04:09:28.588+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (426, 1, 'POST /permissions', '{"body":[{"name":"dashboard.view","description":"View dashboard data"},{"name":"alert.list","description":"List alerts"},{"name":"alert.update","description":"Update alert"},{"name":"servers.view","description":"View servers"},{"name":"servers.add","description":"Add server"},{"name":"servers.edit","description":"Edit server"},{"name":"servers.delete","description":"Delete server"}],"query":{}}', '2025-08-07 06:02:52.482+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (427, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[55,56,57,58,59,60,61]}],"query":{}}', '2025-08-07 06:03:20.174+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (428, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:03:32.109+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (429, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:03:32.111+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (430, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:03:32.248+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (431, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:03:32.252+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (432, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 06:03:41.947+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (433, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 06:03:42.08+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (434, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 06:03:44.151+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (435, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 06:03:44.276+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (436, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 06:03:46.016+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (437, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 06:03:46.127+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (438, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:03:54.854+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (439, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:03:54.855+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (440, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:03:54.958+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (441, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:03:54.96+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (442, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:01.579+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (443, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:01.641+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (444, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:05.787+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (445, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:05.843+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (446, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:09.674+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (447, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:09.729+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (448, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:14.29+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (449, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:14.346+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (450, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:18.832+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (451, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:18.887+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (452, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:19.62+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (453, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:04:19.63+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (454, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:04:19.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (455, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:04:19.775+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (456, 1, 'GET /templates', '{"query":{}}', '2025-08-07 06:04:21.654+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (457, 1, 'GET /templates', '{"query":{}}', '2025-08-07 06:04:21.715+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (458, 1, 'GET /templates/22', '{"query":{}}', '2025-08-07 06:04:25.352+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (459, 1, 'GET /templates/22', '{"query":{}}', '2025-08-07 06:04:25.413+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (536, 1, 'POST /templates/explain', '{"body":{"script":"#!/bin/bash\necho hello"},"query":{}}', '2025-08-08 15:59:58.155+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (537, 1, 'POST /templates/simulate', '{"body":{"script":"#!/bin/bash\nsystemctl restart nginx"},"query":{}}', '2025-08-08 16:01:00.672+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (538, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-08 16:02:57.723+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (539, 1, 'GET /ai-cache/1', '{"query":{}}', '2025-08-08 16:03:26.527+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (540, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:53:32.325+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (541, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:53:32.398+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (645, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:14:27.634+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (460, 1, 'POST /templates/audit', '{"body":{"script":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi"},"query":{}}', '2025-08-07 06:04:31.384+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (461, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 06:04:58.74+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (462, 1, 'GET /ai-cache', '{"query":{}}', '2025-08-07 06:04:58.794+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (463, 1, 'GET /auth/me', '{"query":{}}', '2025-08-07 06:05:10.653+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (464, 1, 'GET /auth/me', '{"query":{}}', '2025-08-07 06:05:10.7+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (465, 1, 'GET /settings/me', '{"query":{}}', '2025-08-07 06:05:14.751+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (466, 1, 'GET /settings', '{"query":{}}', '2025-08-07 06:05:14.789+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (467, 1, 'GET /settings/me', '{"query":{}}', '2025-08-07 06:05:14.872+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (468, 1, 'GET /settings', '{"query":{}}', '2025-08-07 06:05:14.91+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (469, 1, 'GET /settings/notifications', '{"query":{}}', '2025-08-07 06:05:16.949+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (470, 1, 'GET /settings/notifications', '{"query":{}}', '2025-08-07 06:05:17.021+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (471, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:05:19.845+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (472, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:05:19.847+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (473, 1, 'GET /dashboard/servers', '{"query":{}}', '2025-08-07 06:05:19.945+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (474, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-07 06:05:19.946+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (475, 1, 'GET /templates', '{"query":{}}', '2025-08-07 06:05:21.4+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (476, 1, 'GET /templates', '{"query":{}}', '2025-08-07 06:05:21.453+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (477, 1, 'GET /servers', '{"query":{}}', '2025-08-07 06:05:27.726+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (478, 1, 'GET /servers', '{"query":{}}', '2025-08-07 06:05:27.773+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (479, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 06:05:31.202+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (480, 1, 'list_vms', '{}', '2025-08-07 06:05:31.243+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (481, 1, 'GET /vms?page=1&q=', '{"query":{"page":"1","q":""}}', '2025-08-07 06:05:31.292+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (482, 1, 'list_vms', '{}', '2025-08-07 06:05:31.316+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (483, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}', '2025-08-07 10:42:40.938+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (484, 1, 'login', '{"user_id":1}', '2025-08-07 10:42:41.07+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (485, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:42:54.798+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (486, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:42:54.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (487, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:42:58.575+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (488, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:42:58.718+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (489, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:43:01.469+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (490, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:43:01.609+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (491, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:43:04.287+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (492, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:43:04.389+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (493, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:43:06.875+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (494, 1, 'GET /alerts', '{"query":{}}', '2025-08-07 10:43:06.976+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (495, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-07 10:56:25.969+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (496, 1, 'login', '{"user_id":1}', '2025-08-07 10:56:26.15+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (497, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 06:48:55.587+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (498, 1, 'login', '{"user_id":1}', '2025-08-08 06:48:55.791+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (499, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}', '2025-08-08 06:56:07.52+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (500, 1, 'login', '{"user_id":1}', '2025-08-08 06:56:07.73+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (501, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}', '2025-08-08 07:26:38.966+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (502, 1, 'login', '{"user_id":1}', '2025-08-08 07:26:39.167+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (503, 1, 'GET /users/1', '{"query":{}}', '2025-08-08 07:30:07.969+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (504, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-08 12:40:58.698+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (505, 1, 'POST /vms/delete', '{"body":{"vm_id":104,"instance_id":"inst-0001"},"query":{}}', '2025-08-08 12:41:10.961+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (506, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"inst-0001"},"query":{}}', '2025-08-08 12:43:05.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (507, 1, 'Déploiement Terraform', '{"vm_name":"Webapache","service_type":"web","success":true}', '2025-08-08 12:44:36.162+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (508, 1, 'Déploiement Terraform', '{"vm_name":"testVM","service_type":"web","success":true}', '2025-08-08 12:47:25.735+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (509, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123.","remember":false},"query":{}}', '2025-08-08 13:21:53.639+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (510, 1, 'login', '{"user_id":1}', '2025-08-08 13:21:53.819+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (511, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:39:16.057+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (512, 1, 'login', '{"user_id":1}', '2025-08-08 13:39:16.205+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (513, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:40:38.377+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (514, 1, 'login', '{"user_id":1}', '2025-08-08 13:40:38.504+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (515, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:42:02.045+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (516, 1, 'login', '{"user_id":1}', '2025-08-08 13:42:02.204+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (517, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:42:14.969+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (518, 1, 'login', '{"user_id":1}', '2025-08-08 13:42:15.097+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (519, NULL, 'POST /auth/login', '{"body":{"identifier":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:44:46.654+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (520, NULL, 'POST /auth/login', '{"body":{"identifier":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:50:32.773+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (521, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:53:03.857+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (522, 1, 'login', '{"user_id":1}', '2025-08-08 13:53:04.035+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (523, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 13:57:20.048+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (524, 1, 'login', '{"user_id":1}', '2025-08-08 13:57:20.233+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (525, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 14:04:17.014+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (526, 1, 'login', '{"user_id":1}', '2025-08-08 14:04:17.186+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (527, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 14:49:29.659+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (528, 1, 'login', '{"user_id":1}', '2025-08-08 14:49:29.805+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (529, NULL, 'POST /auth/request-reset', '{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}', '2025-08-08 14:49:42.933+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (530, 1, 'request_reset_code', '{"user_id":1}', '2025-08-08 14:49:46.243+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (531, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-08 15:23:33.494+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (532, 1, 'login', '{"user_id":1}', '2025-08-08 15:23:33.699+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (533, 1, 'GET /auth/me', '{"query":{}}', '2025-08-08 15:23:50.763+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (534, 1, 'GET /auth/me', '{"query":{}}', '2025-08-08 15:23:50.838+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (535, 1, 'POST /templates/explain', '{"body":{"script":"#!/bin/bash\necho hello"},"query":{}}', '2025-08-08 15:59:06.832+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (542, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:53:45.3+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (543, 1, 'GET /settings/me', '{"query":{}}', '2025-08-08 16:54:14.304+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (544, 1, 'GET /settings/me', '{"query":{}}', '2025-08-08 16:54:14.382+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (545, 1, 'GET /templates', '{"query":{}}', '2025-08-08 16:54:21.856+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (546, 1, 'GET /templates', '{"query":{}}', '2025-08-08 16:54:21.918+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (547, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:54:33.56+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (548, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:54:33.634+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (549, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:54:43.531+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (550, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:54:53.61+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (551, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:55:03.672+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (552, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:55:13.542+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (553, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:55:23.866+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (554, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:55:33.851+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (555, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:55:44.057+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (556, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:55:53.837+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (557, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:56:03.834+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (558, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:56:13.837+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (559, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:57:19.991+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (560, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:58:19.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (561, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 16:59:19.897+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (562, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:00:19.951+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (563, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:01:08.046+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (564, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:01:13.537+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (565, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:01:14.759+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (566, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:01:15.842+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (567, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:01:23.58+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (568, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:01:33.836+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (569, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:01:43.556+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (570, 1, 'GET /templates', '{"query":{}}', '2025-08-08 17:01:59.064+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (571, 1, 'GET /users', '{"query":{}}', '2025-08-08 17:02:11.489+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (572, 1, 'GET /roles', '{"query":{}}', '2025-08-08 17:02:11.534+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (573, 1, 'GET /servers', '{"query":{}}', '2025-08-08 17:02:34.484+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (574, 1, 'POST /servers', '{"body":{"name":"test","ip":" ddd","zone":"LAN"},"query":{}}', '2025-08-08 17:02:42.9+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (575, 1, 'DELETE /servers/4fff5737-ea6a-4806-aaa6-05936daa9924', '{"query":{}}', '2025-08-08 17:02:50+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (576, 1, 'GET /auth/me', '{"query":{}}', '2025-08-08 17:09:17.862+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (577, 1, 'GET /settings/me', '{"query":{}}', '2025-08-08 17:09:26.747+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (578, 1, 'GET /settings/me', '{"query":{}}', '2025-08-08 17:09:26.82+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (579, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:09:53.011+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (580, 1, 'GET /dashboard/summary', '{"query":{}}', '2025-08-08 17:09:53.07+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (581, 1, 'GET /servers', '{"query":{}}', '2025-08-08 17:09:57.277+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (582, 1, 'GET /servers', '{"query":{}}', '2025-08-08 17:09:57.332+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (583, 1, 'GET /servers', '{"query":{}}', '2025-08-08 17:10:25.996+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (584, 1, 'GET /servers', '{"query":{}}', '2025-08-08 17:10:26.05+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (585, 1, 'GET /alerts', '{"query":{}}', '2025-08-08 17:10:32.474+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (586, 1, 'GET /alerts', '{"query":{}}', '2025-08-08 17:10:32.534+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (587, 1, 'GET /auth/me', '{"query":{}}', '2025-08-08 17:10:38.363+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (588, 1, 'GET /servers', '{"query":{}}', '2025-08-08 17:10:38.464+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (589, 1, 'GET /templates', '{"query":{}}', '2025-08-08 17:10:46.994+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (590, 1, 'GET /templates', '{"query":{}}', '2025-08-08 17:10:47.052+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (591, 1, 'GET /templates', '{"query":{}}', '2025-08-08 17:11:14.256+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (592, 1, 'GET /templates', '{"query":{}}', '2025-08-08 17:11:14.328+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (593, 1, 'GET /auth/me', '{"query":{}}', '2025-08-08 17:11:20.378+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (594, 1, 'GET /templates', '{"query":{}}', '2025-08-08 17:11:20.593+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (595, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 15:09:36.722+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (596, 1, 'login', '{"user_id":1}', '2025-08-09 15:09:36.921+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (597, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 15:14:10.705+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (598, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 15:14:10.784+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (599, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 15:14:49.609+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (600, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 15:14:49.676+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (601, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 15:15:16.933+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (602, 1, 'GET /auth/me', '{"query":{}}', '2025-08-09 15:16:30.315+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (603, 1, 'GET /auth/me', '{"query":{}}', '2025-08-09 15:16:30.369+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (604, 1, 'Échec Déploiement Terraform', '{}', '2025-08-09 15:18:33.143+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (605, 1, 'GET /roles', '{"query":{}}', '2025-08-09 15:27:49.553+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (606, 1, 'GET /roles', '{"query":{}}', '2025-08-09 15:27:49.612+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (607, 1, 'GET /permissions', '{"query":{}}', '2025-08-09 15:31:03.993+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (608, 1, 'GET /roles', '{"query":{}}', '2025-08-09 15:31:04.033+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (609, 1, 'GET /permissions', '{"query":{}}', '2025-08-09 15:31:04.103+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (610, 1, 'GET /roles', '{"query":{}}', '2025-08-09 15:31:04.148+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (611, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 15:31:04.195+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (612, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 15:31:04.236+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (613, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 15:31:04.358+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (614, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 15:31:04.41+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (615, 1, 'POST /permissions/assign', '{"body":[{"role_id":2,"permission_ids":[54]}],"query":{}}', '2025-08-09 15:31:18.138+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (616, 1, 'GET /permissions', '{"query":{}}', '2025-08-09 15:31:38.236+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (617, 1, 'GET /roles', '{"query":{}}', '2025-08-09 15:31:38.279+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (618, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 15:31:38.379+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (619, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 15:31:38.421+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (620, 1, 'GET /users', '{"query":{}}', '2025-08-09 15:32:38.898+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (621, 1, 'GET /roles', '{"query":{}}', '2025-08-09 15:32:38.948+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (622, 1, 'GET /users', '{"query":{}}', '2025-08-09 15:32:39.036+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (623, 1, 'GET /roles', '{"query":{}}', '2025-08-09 15:32:39.089+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (624, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 16:08:33.486+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (625, 1, 'login', '{"user_id":1}', '2025-08-09 16:08:33.688+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (626, 1, 'GET /settings/account', '{"query":{}}', '2025-08-09 16:08:45.412+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (627, 1, 'GET /settings/account', '{"query":{}}', '2025-08-09 16:08:45.491+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (628, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:10:23.961+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (629, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:10:24.027+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (630, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:10:41.429+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (631, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:10:41.488+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (632, 1, 'GET /auth/me', '{"query":{}}', '2025-08-09 16:11:04.898+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (633, 1, 'GET /auth/me', '{"query":{}}', '2025-08-09 16:11:04.961+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (634, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:12:19.131+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (635, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:12:19.194+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (636, 1, 'GET /settings/account', '{"query":{}}', '2025-08-09 16:12:47.967+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (637, 1, 'GET /settings/account', '{"query":{}}', '2025-08-09 16:12:48.029+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (638, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:13:25.454+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (639, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 16:13:25.511+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (640, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:13:33.86+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (641, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:13:33.896+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (642, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:13:33.989+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (646, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:14:27.699+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1235, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:34:08.109+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1246, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:30.212+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1247, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:30.28+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1258, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:15:58.3+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1259, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:15:58.358+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1274, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:27.24+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1284, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:26:58.844+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1285, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:26:58.908+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1298, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:45.344+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1299, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:45.411+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1310, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:54:57.619+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1311, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:54:57.705+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1312, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:55:07.538+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1313, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:55:16.191+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1314, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:55:17.537+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1315, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 11:55:25.344+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1316, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 11:55:25.401+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1330, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:00:16.772+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1339, 1, 'terminal_list_vms', '{}', '2025-08-10 12:07:23.034+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1352, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:01:50.372+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1353, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:01:50.442+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1364, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:32:18.719+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1365, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:32:18.789+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1366, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:32:28.868+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1367, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:32:38.993+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1368, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:32:48.871+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1369, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:32:58.866+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1370, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:33:08.888+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1371, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:33:18.834+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1379, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:41:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1387, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:49:11.953+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1395, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:57:11.957+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1403, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:05:11.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1411, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:13:11.923+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1419, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:21:11.935+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1427, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:29:11.944+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1435, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:37:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1443, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:45:11.942+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1451, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:53:11.917+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1459, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 15:01:11.909+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1483, 1, 'GET /templates', '{"query":{}}', '2025-08-11 06:48:54.728+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1501, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:04:27.486+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1518, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-11 07:09:14.583+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1520, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-11 07:09:14.697+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1537, 1, 'PUT /templates/20', '{"body":{"name":"monitor.sh","template_content":"#!/bin/bash\r\n\r\n# 📁 Créer le dossier de monitoring s’il n’existe pas\r\nmkdir -p /opt/monitoring\r\n\r\n# 📦 Créer le script de surveillance système\r\ncat <<''EOS'' > /opt/monitoring/status.sh\r\n#!/bin/bash\r\n\r\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\r\nif [ -f /etc/instance-info.conf ]; then\r\n  source /etc/instance-info.conf\r\nfi\r\n\r\nTIMESTAMP=$(date -Iseconds)\r\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\r\nHOSTNAME=$(hostname)\r\nIP_ADDR=$(hostname -I | awk ''{print $1}'')\r\nLOAD_AVG=$(cut -d '' '' -f1-3 /proc/loadavg)\r\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk ''{print $2}'')\r\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk ''{print $2}'')\r\n\r\nDISK_TOTAL=$(df -B1 / | tail -1 | awk ''{print $2}'')\r\nDISK_USED=$(df -B1 / | tail -1 | awk ''{print $3}'')\r\nDISK_AVAIL=$(df -B1 / | tail -1 | awk ''{print $4}'')\r\n\r\nIFACE=$(ip route get 1.1.1.1 | awk ''{print $5; exit}'')\r\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\r\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\r\n\r\nOPEN_PORTS=$(ss -tuln | awk ''NR>1 {split($5,a,\":\"); print a[length(a)]}'' | sort -n | uniq | paste -sd, -)\r\n\r\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk ''{printf \"{\\\"pid\\\":%s,\\\"cmd\\\":\\\"%s\\\",\\\"cpu\\\":%s},\", $1, $2, $3}'')\r\nTOP_PROCESSES=\"[${TOP_PROCESSES%,}]\"\r\n\r\ncat <<JSON > /opt/monitoring/status.json\r\n{\r\n  \"timestamp\": \"${TIMESTAMP}\",\r\n  \"instance_id\": \"${INSTANCE_ID}\",\r\n  \"hostname\": \"${HOSTNAME}\",\r\n  \"ip_address\": \"${IP_ADDR}\",\r\n  \"load_average\": \"${LOAD_AVG}\",\r\n  \"memory\": {\r\n    \"total_kb\": ${MEM_TOTAL},\r\n    \"available_kb\": ${MEM_AVAILABLE}\r\n  },\r\n  \"disk\": {\r\n    \"total_bytes\": ${DISK_TOTAL},\r\n    \"used_bytes\": ${DISK_USED},\r\n    \"available_bytes\": ${DISK_AVAIL}\r\n  },\r\n  \"network\": {\r\n    \"interface\": \"${IFACE}\",\r\n    \"rx_bytes\": ${RX_BYTES},\r\n    \"tx_bytes\": ${TX_BYTES}\r\n  },\r\n  \"open_ports\": [${OPEN_PORTS}],\r\n  \"top_processes\": ${TOP_PROCESSES}\r\n}\r\nJSON\r\nEOS\r\n\r\nchmod +x /opt/monitoring/status.sh\r\n\r\n# 🕔 Ajout au cron (évite les doublons)\r\ngrep -q \"status.sh\" /etc/crontab || echo \"*/5 * * * * root /opt/monitoring/status.sh\" >> /etc/crontab\r\n"},"query":{}}', '2025-08-11 07:11:55.207+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1538, 1, 'update_template:20', '{}', '2025-08-11 07:11:55.259+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1550, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 09:20:01.141+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1567, 1, 'GET /auth/me', '{"query":{}}', '2025-08-11 09:25:40.478+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1568, 1, 'GET /auth/me', '{"query":{}}', '2025-08-11 09:25:40.522+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1583, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:15:35.421+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1584, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:15:35.484+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1602, 1, 'GET /users', '{"query":{}}', '2025-08-11 10:25:57.42+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1617, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 10:45:47.42+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1618, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 10:45:47.499+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1631, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-11 10:49:55.261+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1632, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-11 10:49:55.321+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1633, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:49:55.357+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1635, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-11 10:49:55.472+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1636, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-11 10:49:55.508+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1638, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-11 10:49:55.64+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1639, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-11 10:49:55.681+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1660, 1, 'list_vms', '{}', '2025-08-11 10:57:43.26+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1677, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 12:01:26.569+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1695, 1, 'GET /templates', '{"query":{}}', '2025-08-11 12:55:28.471+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1696, 1, 'GET /templates', '{"query":{}}', '2025-08-11 12:55:28.532+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1709, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 13:28:19.246+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1710, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 13:28:19.311+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1711, 1, 'GET /templates', '{"query":{}}', '2025-08-11 13:28:27.762+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1712, 1, 'GET /templates', '{"query":{}}', '2025-08-11 13:28:27.829+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1733, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-11 13:36:42.489+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1734, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-11 13:36:54.638+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1735, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-11 13:36:59.495+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1752, 1, 'GET /templates', '{"query":{}}', '2025-08-11 15:19:58.136+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1761, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 02:00:02.274+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1762, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 02:00:02.341+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1771, 1, 'GET /roles', '{"query":{}}', '2025-08-12 03:22:29.348+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1773, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 03:22:29.431+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1774, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 03:22:29.47+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1776, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 03:22:29.587+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1798, 1, 'Échec Déploiement Terraform', '{}', '2025-08-12 03:44:36.616+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1823, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:37:14.281+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1834, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 07:26:45.377+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1836, 1, 'list_vms', '{}', '2025-08-12 07:26:45.494+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1838, 1, 'GET /vms', '{"query":{}}', '2025-08-12 07:26:51.289+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1855, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 11:09:42.207+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (647, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:14:27.751+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (648, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:15:58.358+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (649, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:15:58.414+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (650, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:15:58.499+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (651, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:15:58.567+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (652, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:16:09.072+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (653, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:16:09.115+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (654, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 16:19:20.468+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (655, 1, 'login', '{"user_id":1}', '2025-08-09 16:19:20.646+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (656, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 16:33:03.918+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (657, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:33:04.007+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (658, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 16:33:04.093+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (659, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 16:33:04.137+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (660, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 16:34:02.37+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (661, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:34:02.448+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (662, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 16:34:02.555+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (663, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 16:34:02.6+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (664, 1, 'GET /permissions?page=2&limit=10', '{"query":{"page":"2","limit":"10"}}', '2025-08-09 16:35:06.146+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (665, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:35:06.222+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (666, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 16:35:06.299+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (667, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 16:35:06.34+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (668, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:36:12.974+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (669, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:36:13.051+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (670, 1, 'POST /roles', '{"body":{"name":"supertest","description":"testeur de roles"},"query":{}}', '2025-08-09 16:36:35.905+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (671, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:51:52.397+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (672, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:52:02.464+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (673, 1, 'PUT /roles/3', '{"body":{"name":"gdgdhd","description":"ajaja"},"query":{}}', '2025-08-09 16:52:11.835+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (674, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:52:21.011+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (675, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 16:53:11.717+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (676, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 16:53:11.773+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (677, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:11.823+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (678, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:11.896+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (679, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 16:53:11.94+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (680, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 16:53:11.984+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (681, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 16:53:12.028+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (682, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 16:53:12.116+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (683, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 16:53:12.156+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (684, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 16:53:12.191+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (685, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:15.244+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (686, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:15.322+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (687, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 16:53:17.266+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (688, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 16:53:17.322+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (689, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:17.364+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (690, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:17.424+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (691, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 16:53:17.498+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (692, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 16:53:17.56+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (693, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 16:53:17.611+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (694, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 16:53:17.694+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (695, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 16:53:17.737+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (696, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 16:53:17.779+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (697, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:53:28.238+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (698, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:28.286+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (699, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:53:28.372+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (700, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:28.433+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (701, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:53:59.849+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (702, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:53:59.886+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (703, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:53:59.951+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (704, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:54:00.007+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (705, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:54:18.547+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (706, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:54:18.583+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (707, 1, 'GET /users', '{"query":{}}', '2025-08-09 16:55:59.35+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (708, 1, 'GET /roles', '{"query":{}}', '2025-08-09 16:55:59.391+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (709, 1, 'Échec Déploiement Terraform', '{}', '2025-08-09 16:59:47.274+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (710, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:02:15.803+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (711, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:02:15.897+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (712, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:52:10.334+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (713, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:52:21.681+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (714, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 17:52:32.181+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (715, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 17:52:32.261+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (716, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:52:32.305+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (717, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:52:32.38+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (718, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:52:32.449+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (719, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:52:32.508+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (720, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:52:32.571+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (721, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:52:32.668+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (722, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:52:32.727+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (723, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:52:32.778+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (724, 1, 'GET /permissions?page=2&limit=10', '{"query":{"page":"2","limit":"10"}}', '2025-08-09 17:52:36.809+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (725, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:52:36.874+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (726, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:52:36.933+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (727, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:52:36.973+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (728, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:52:37.016+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (729, 1, 'POST /permissions/assign', '{"body":[{"role_id":3,"permission_ids":[36]}],"query":{}}', '2025-08-09 17:52:48.969+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (730, 1, 'POST /permissions/assign', '{"body":[{"role_id":3,"permission_ids":[5]}],"query":{}}', '2025-08-09 17:52:56.654+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (731, 1, 'POST /permissions/assign', '{"body":[{"role_id":3,"permission_ids":[6]}],"query":{}}', '2025-08-09 17:52:57.793+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (732, 1, 'POST /permissions/assign', '{"body":[{"role_id":3,"permission_ids":[4]}],"query":{}}', '2025-08-09 17:52:59.864+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (733, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:53:05.826+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (734, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:53:05.899+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (735, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:53:31.459+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (736, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:53:31.505+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (737, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:53:31.583+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (738, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:53:31.64+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (739, 1, 'GET /users/1', '{"query":{}}', '2025-08-09 17:53:48.888+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (740, 1, 'GET /users/1', '{"query":{}}', '2025-08-09 17:54:34.516+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (741, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:54:37.042+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (742, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:54:37.149+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (743, 1, 'POST /users', '{"body":{"first_name":"tes","last_name":"test","email":"res@gmail.com","password":"Nexus2023.","role_id":2},"query":{}}', '2025-08-09 17:54:53.264+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (744, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:54:53.628+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (745, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:54:53.679+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (746, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:54:53.736+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (747, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:54:53.781+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (748, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:55:03.703+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (749, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:03.744+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (750, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 17:55:11.472+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (751, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:11.506+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (752, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 17:55:11.552+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (753, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:11.591+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (754, 1, 'PUT /users/3', '{"body":{"first_name":"tes3","last_name":"test","phone":"","status":"","role_id":2},"query":{}}', '2025-08-09 17:55:17.934+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (755, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:55:18.144+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (756, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:18.175+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (757, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:55:18.224+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (758, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:18.271+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (759, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 17:55:21.83+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (760, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 17:55:25.027+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (761, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:25.062+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (762, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 17:55:25.109+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (763, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:25.151+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (764, 1, 'PUT /users/3', '{"body":{"first_name":"tes3","last_name":"test","phone":"","status":"inactif","role_id":2},"query":{}}', '2025-08-09 17:55:28.751+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (765, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:28.984+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (766, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:55:29.032+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (767, 1, 'GET /users', '{"query":{}}', '2025-08-09 17:55:29.117+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (768, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:55:29.151+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (769, 1, 'PATCH /users/3', '{"body":{"status":"actif"},"query":{}}', '2025-08-09 17:55:35.624+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (770, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:03.818+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (771, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:03.889+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (772, 1, 'PUT /roles/3', '{"body":{"name":"gdgdhd","description":"de"},"query":{}}', '2025-08-09 17:58:14.456+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (773, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 17:58:29.306+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (774, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 17:58:29.373+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (775, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:29.413+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (776, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:29.502+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (777, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:58:29.573+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (778, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:58:29.621+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (779, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:58:29.683+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (780, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:58:29.82+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (781, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:58:29.858+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (782, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:58:29.894+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (783, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:35.731+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (784, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:35.784+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (785, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 17:58:42.27+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (786, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 17:58:42.324+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (787, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:42.365+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (788, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:58:42.419+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (789, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:58:42.477+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (790, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:58:42.53+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (791, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:58:42.596+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (792, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:58:42.661+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (793, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:58:42.697+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (794, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:58:42.745+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (795, 1, 'POST /permissions', '{"body":{"name":"test.analyse","description":"testdanalyse"},"query":{}}', '2025-08-09 17:59:15.73+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (796, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 17:59:33.607+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (797, 1, 'GET /roles', '{"query":{}}', '2025-08-09 17:59:33.662+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (798, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 17:59:33.741+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (799, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 17:59:33.776+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (800, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 17:59:33.809+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (801, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:00:32.058+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (802, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:00:32.101+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (803, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:00:32.173+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (804, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:00:32.222+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (805, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:00:36.911+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (806, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:00:42.009+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (807, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:00:42.052+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (808, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:00:42.11+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (809, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:00:42.171+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (810, 1, 'PUT /users/3', '{"body":{"first_name":"tes3","last_name":"test","phone":"55555555555","status":"actif","role_id":2},"query":{}}', '2025-08-09 18:00:46.67+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (811, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:00:46.932+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (812, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:00:46.969+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (813, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:00:47.044+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (814, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:00:47.09+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (815, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:00:48.827+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (816, 1, 'GET /auth/me', '{"query":{}}', '2025-08-09 18:01:05.346+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (817, 1, 'GET /auth/me', '{"query":{}}', '2025-08-09 18:01:05.397+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (818, 1, 'GET /settings/account', '{"query":{}}', '2025-08-09 18:01:15.575+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (819, 1, 'GET /settings/account', '{"query":{}}', '2025-08-09 18:01:15.633+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (820, NULL, 'POST /auth/request-reset', '{"body":{"email":"latifnjimoluh@gmail.com"},"query":{}}', '2025-08-09 18:01:21.189+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (821, 1, 'request_reset_code', '{"user_id":1}', '2025-08-09 18:01:26.991+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (822, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 18:01:48.441+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (823, 1, 'GET /settings/me', '{"query":{}}', '2025-08-09 18:01:48.49+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (824, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:02:25.586+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (825, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:02:25.621+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (826, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:02:25.692+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (827, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:02:25.741+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (828, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:02:28.441+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (829, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:02:28.493+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (830, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:02:28.56+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (831, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:02:28.604+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (832, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:02:29.742+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (833, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:02:29.784+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (834, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:02:29.846+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (835, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:02:29.894+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (836, 1, 'DELETE /users/3', '{"query":{}}', '2025-08-09 18:02:34.055+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (837, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:03:00.721+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (838, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:03:00.762+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (839, 1, 'PATCH /users/3', '{"body":{"status":"actif"},"query":{}}', '2025-08-09 18:03:07.26+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (840, 1, 'Déploiement Terraform', '{"vm_name":"testweb","service_type":"web_server_nginx","success":true}', '2025-08-09 18:07:31.949+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (841, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 18:42:40.324+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (842, 1, 'login', '{"user_id":1}', '2025-08-09 18:42:40.531+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (843, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:42:59.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (844, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:42:59.795+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (845, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:42:59.904+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1236, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:34:08.208+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1248, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:50.785+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1249, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:50.85+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1260, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:05.805+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1262, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:14.917+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1264, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:22.381+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1275, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:27.293+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1286, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:27:00.51+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1288, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:27:10.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1289, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:27:10.987+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1300, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:46.299+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1317, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:55:38.616+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1318, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:55:38.676+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1331, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:03:36.231+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1332, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:03:36.303+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1340, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:07:39.895+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1341, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:07:39.966+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1354, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:02:05.064+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1355, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:02:05.127+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1372, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:34:11.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1380, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:42:12.045+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1388, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:50:11.915+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1396, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:58:11.942+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1404, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:06:11.912+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1412, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:14:11.942+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1420, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:22:11.925+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1428, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:30:11.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1436, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:38:11.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1444, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:46:11.917+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1452, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:54:11.922+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1460, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 15:02:11.922+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1484, 1, 'GET /templates', '{"query":{}}', '2025-08-11 06:48:57.359+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1502, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:08:49.738+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1503, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:08:49.791+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1522, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-11 07:09:42.7+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1539, 1, 'GET /settings/account', '{"query":{}}', '2025-08-11 07:13:40.795+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1540, 1, 'GET /settings/account', '{"query":{}}', '2025-08-11 07:13:40.85+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1551, 1, 'terminal_list_vms', '{}', '2025-08-11 09:20:02.892+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1552, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 09:20:02.954+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1569, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 09:26:05.958+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1585, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:23:48.184+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1586, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:23:48.231+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1603, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:25:57.452+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1605, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:25:57.535+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1619, 1, 'POST /vms/104/stop', '{"query":{}}', '2025-08-11 10:46:52.501+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1620, 1, 'stop_vm:104', '{}', '2025-08-11 10:46:52.545+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1634, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:49:55.433+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1637, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-11 10:49:55.548+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1640, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-11 10:49:55.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1641, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:50:04.145+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1643, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 10:50:10.881+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1644, 1, 'terminal_list_vms', '{}', '2025-08-11 10:50:10.957+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1645, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 10:50:10.995+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1661, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 11:08:37.994+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1662, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 11:08:38.064+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1678, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 12:02:58.859+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1680, 1, 'list_vms', '{}', '2025-08-11 12:02:58.93+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1681, 1, 'GET /vms', '{"query":{}}', '2025-08-11 12:02:59.003+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1697, 1, 'POST /vms/105/start', '{"query":{}}', '2025-08-11 12:57:50.604+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1698, 1, 'start_vm:105', '{}', '2025-08-11 12:57:50.642+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1713, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 13:29:03.203+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1714, 1, 'GET /vms', '{"query":{}}', '2025-08-11 13:29:03.205+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1715, 1, 'list_vms', '{}', '2025-08-11 13:29:03.264+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1716, 1, 'GET /vms', '{"query":{}}', '2025-08-11 13:29:03.318+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1736, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-11 13:37:44.224+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1753, 1, 'GET /templates', '{"query":{}}', '2025-08-11 15:20:55.742+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1763, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 02:16:24.296+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1778, 1, 'GET /roles', '{"query":{}}', '2025-08-12 03:22:59.174+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1779, 1, 'GET /roles', '{"query":{}}', '2025-08-12 03:22:59.246+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1799, 1, 'Échec Déploiement Terraform', '{}', '2025-08-12 03:45:30.723+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1815, 1, 'POST /templates', '{"body":{"name":"Cron des scripts de monitoring","service_type":"monitoring__cron","category":"monitoring","description":"Installe un cron job minuteur qui attend la présence des scripts de monitoring, les exécute, crée leurs crons définitifs puis se désinstalle.","template_content":"#!/bin/bash\nset -euo pipefail\n\n# === Variables substituées par le moteur de template ===\nSCRIPT_PATH=\"${SCRIPT_PATH}\"\nSTATUS_SCRIPT_PATH=\"${STATUS_SCRIPT_PATH}\"\nSERVICES_SCRIPT_PATH=\"${SERVICES_SCRIPT_PATH}\"\nSTATUS_CRON_EXPR=''${STATUS_CRON_EXPR}''\nSERVICES_CRON_EXPR=''${SERVICES_CRON_EXPR}''\nCRON_USER=''${CRON_USER}''\n\nMONITOR_DIR=\"$(dirname \"${STATUS_SCRIPT_PATH}\")\"\nMARK_BOOT=\"# MONITORING_CRON\"\nMARK_STATUS=\"# MONITORING_STATUS_CRON\"\nMARK_SERVICES=\"# MONITORING_SERVICES_CRON\"\n\nmkdir -p \"${MONITOR_DIR}\"\n\n# --- Génère le script  ---\ncat > \"${SCRIPT_PATH}\" <<''EOS''\n#!/bin/bash\nset -euo pipefail\n\nSTATUS_SCRIPT_PATH=\"__STATUS_SCRIPT_PATH__\"\nSERVICES_SCRIPT_PATH=\"__SERVICES_SCRIPT_PATH__\"\nSTATUS_CRON_EXPR=''__STATUS_CRON_EXPR__''\nSERVICES_CRON_EXPR=''__SERVICES_CRON_EXPR__''\nCRON_USER=''__CRON_USER__''\nMARK_BOOT=\"# MONITORING_CRON\"\nMARK_STATUS=\"# MONITORING_STATUS_CRON\"\nMARK_SERVICES=\"# MONITORING_SERVICES_CRON\"\n\nexists_and_exec() {\n  local f=\"$1\"\n  [[ -f \"$f\" ]] || return 1\n  [[ -x \"$f\" ]] || chmod +x \"$f\" || true\n  return 0\n}\n\ncrontab_get() { crontab -u \"$CRON_USER\" -l 2>/dev/null || true; }\ncrontab_set() { crontab -u \"$CRON_USER\" -; }\n\nadd_cron_once() {\n  local expr=\"$1\" cmd=\"$2\" mark=\"$3\"\n  local current\n  current=\"$(crontab_get)\"\n  if ! echo \"$current\" | grep -Fq \"$mark\"; then\n    { echo \"$current\" | grep -Fv \"$mark\"; echo \"$expr $cmd $mark\"; } | crontab_set\n  fi\n}\n\nremove_mark() {\n  local mark=\"$1\"\n  crontab_get | grep -Fv \"$mark\" | crontab_set\n}\n\nok=1\nif exists_and_exec \"$STATUS_SCRIPT_PATH\"; then\n  add_cron_once \"$STATUS_CRON_EXPR\" \"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\" \"$MARK_STATUS\"\nelse\n  ok=0\nfi\n\nif exists_and_exec \"$SERVICES_SCRIPT_PATH\"; then\n  add_cron_once \"$SERVICES_CRON_EXPR\" \"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\" \"$MARK_SERVICES\"\nelse\n  ok=0\nfi\n\nif [[ \"$ok\" -eq 1 ]]; then\n  # Exécuter une première fois pour générer les JSON immédiatement\n  bash \"$STATUS_SCRIPT_PATH\" || true\n  bash \"$SERVICES_SCRIPT_PATH\" || true\n  # Se retirer du crontab\n  remove_mark \"$MARK_BOOT\"\nfi\nEOS\n\n# Injecte les variables réelles dans le \nsed -i \\\n  -e \"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\//\\\\/}#g\" \\\n  -e \"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\//\\\\/}#g\" \\\n  -e \"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\//\\\\/}#g\" \\\n  -e \"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\//\\\\/}#g\" \\\n  -e \"s#__CRON_USER__#${CRON_USER}#g\" \\\n  \"${SCRIPT_PATH}\"\n\nchmod +x \"${SCRIPT_PATH}\"\n\n# --- (Ré)active le service cron/ crond ---\nif command -v systemctl >/dev/null 2>&1; then\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\nfi\n\n# --- Installe le cron  (toutes les minutes) ---\ncurrent_cron=\"$(crontab -u \"${CRON_USER}\" -l 2>/dev/null || true)\"\nif ! echo \"$current_cron\" | grep -Fq \"$MARK_BOOT\"; then\n  { echo \"$current_cron\" | grep -Fv \"$MARK_BOOT\"; echo \"* * * * * ${SCRIPT_PATH} $MARK_BOOT\"; } | crontab -u \"${CRON_USER}\" -\nfi\n\nexit 0\n","script_path":"/scripts/install_monitoring_cron.sh","fields_schema":{"fields":[{"name":"SCRIPT_PATH","label":"Chemin du script ","type":"text","required":true,"default":"/opt/monitoring/monitoring.sh"},{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_EXPR","label":"Cron du script status","type":"text","required":true,"default":"*/1 * * * *"},{"name":"SERVICES_CRON_EXPR","label":"Cron du script services","type":"text","required":true,"default":"*/1 * * * *"},{"name":"CRON_USER","label":"Utilisateur cron","type":"text","required":true,"default":"root"}]}},"query":{}}', '2025-08-12 04:36:17.465+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1816, 1, 'create_template:25', '{}', '2025-08-12 04:36:17.485+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1824, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:37:14.332+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1835, 1, 'GET /vms', '{"query":{}}', '2025-08-12 07:26:45.387+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1837, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 07:26:51.287+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1839, 1, 'list_vms', '{}', '2025-08-12 07:26:51.321+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1856, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 11:09:42.279+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1866, 1, 'GET /templates?status=supprime', '{"query":{"status":"supprime"}}', '2025-08-12 11:23:28.764+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1869, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 11:23:38.788+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1875, 1, 'POST /vms/105/start', '{"query":{}}', '2025-08-12 11:36:45.318+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1876, 1, 'start_vm:105', '{}', '2025-08-12 11:36:45.363+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (846, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:42:59.956+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (847, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:43:43.522+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (848, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:43:43.566+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (849, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:09.256+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (850, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:09.31+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (851, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:12.389+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (852, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:12.451+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (853, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:23.442+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (854, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:23.493+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (855, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:26.287+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (856, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:26.356+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (857, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:43.33+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (858, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:43.38+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (859, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:44.923+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (860, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:44.967+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (861, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:47.968+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (862, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:48.017+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (863, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:48:51.168+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (864, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:48:51.21+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (865, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:49:11.946+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (866, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:49:11.993+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (867, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:49:17.453+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (868, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:49:17.509+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (869, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:49:46.174+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (870, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:49:46.212+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (871, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:49:53.648+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (872, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:50:00.861+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (873, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:00.899+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (874, 1, 'GET /users/3', '{"query":{}}', '2025-08-09 18:50:00.977+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (875, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:01.02+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (876, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:05.521+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (877, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:50:05.568+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (878, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:05.637+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (879, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:50:05.673+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (880, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:19.985+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (881, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:20.07+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (882, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:21.212+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (883, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:50:21.244+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (884, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:21.302+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (885, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:50:21.341+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (886, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:23.773+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (887, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:23.827+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (888, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:50:27.016+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (889, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:27.055+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (890, 1, 'GET /users', '{"query":{}}', '2025-08-09 18:50:27.114+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (891, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:27.165+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (892, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:31.963+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (893, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:32.007+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (894, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 18:50:37.81+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (895, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 18:50:37.859+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (896, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:37.902+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (897, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:37.954+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (898, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 18:50:37.997+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (899, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 18:50:38.045+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (900, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 18:50:38.083+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (901, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 18:50:38.185+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (902, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 18:50:38.23+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (903, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 18:50:38.276+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (904, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:39.345+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (905, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:50:39.405+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (906, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 18:55:20.23+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (907, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:55:20.315+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (908, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 18:55:20.421+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (909, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 18:55:20.465+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (910, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 18:55:20.527+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (911, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:55:43.074+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (912, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:56:34.441+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (913, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 18:56:55.077+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (914, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 18:56:55.135+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (915, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:56:55.179+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (916, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:56:55.252+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (917, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 18:56:55.304+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (918, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 18:56:55.342+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (919, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 18:56:55.379+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (920, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 18:56:55.449+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (921, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 18:56:55.493+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (922, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 18:56:55.554+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (923, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 18:57:31.843+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (924, 1, 'GET /roles', '{"query":{}}', '2025-08-09 18:57:31.949+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (925, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 18:57:32.06+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (926, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 18:57:32.103+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (927, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 18:57:32.146+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (928, 1, 'GET /permissions?page=2&limit=10', '{"query":{"page":"2","limit":"10"}}', '2025-08-09 19:00:05.999+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (929, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:00:06.078+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (930, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 19:00:06.187+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (931, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 19:00:06.23+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (932, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 19:00:06.278+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (933, 1, 'GET /permissions?page=3&limit=10', '{"query":{"page":"3","limit":"10"}}', '2025-08-09 19:00:07.525+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (934, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:00:07.592+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (935, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 19:00:07.661+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (936, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 19:00:07.7+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (937, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 19:00:07.74+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (938, 1, 'GET /permissions?page=4&limit=10', '{"query":{"page":"4","limit":"10"}}', '2025-08-09 19:00:08.788+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (939, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:00:08.854+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (940, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 19:00:08.916+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (941, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 19:00:08.953+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (942, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 19:00:08.996+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (943, 1, 'GET /permissions?page=5&limit=10', '{"query":{"page":"5","limit":"10"}}', '2025-08-09 19:00:09.922+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (944, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:00:09.985+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (945, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 19:00:10.047+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (946, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 19:00:10.088+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (947, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 19:00:10.127+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (948, 1, 'GET /permissions?page=6&limit=10', '{"query":{"page":"6","limit":"10"}}', '2025-08-09 19:00:10.637+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (949, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:00:10.693+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (950, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 19:00:10.755+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (955, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 19:00:11.748+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (960, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 19:00:14.297+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1237, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:40:01.212+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1238, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:40:01.305+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1250, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:51.745+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1252, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:57.042+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1261, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:05.862+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1263, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:14.967+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1265, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:22.453+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1276, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:23:08.812+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1277, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:23:08.878+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1287, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:27:00.578+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1301, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:46.369+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1319, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:57:44.861+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1320, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:57:44.93+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1321, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 11:57:54.795+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1333, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:03:46.172+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1342, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:08:14.153+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1343, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:08:14.226+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1356, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:02:13.068+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1373, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:35:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1381, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:43:11.962+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1389, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:51:11.945+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1397, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:59:11.933+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1405, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:07:11.973+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1413, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:15:11.958+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1421, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:23:11.99+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1429, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:31:12.023+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1437, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:39:11.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1445, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:47:11.94+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1453, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:55:11.932+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1461, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 15:03:11.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1464, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-10 19:33:07.371+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1465, 1, 'login', '{"user_id":1}', '2025-08-10 19:33:07.572+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1466, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 19:33:08.067+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1467, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 19:33:08.176+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1468, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 19:33:18.127+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1469, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 19:33:28.076+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1470, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 19:33:28.949+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1471, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 19:33:29.002+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1485, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123"},"query":{}}', '2025-08-11 06:50:48.889+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1486, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-11 06:50:58.551+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1487, 1, 'login', '{"user_id":1}', '2025-08-11 06:50:58.662+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1488, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 06:51:00.62+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1489, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 06:51:00.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1490, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 06:51:10.627+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1491, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 06:51:10.775+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1492, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 06:51:10.832+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1504, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:08:55.594+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1523, 1, 'GET /logs?page=1&pageSize=50', '{"query":{"page":"1","pageSize":"50"}}', '2025-08-11 07:10:03.571+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1541, 1, 'GET /settings/account', '{"query":{}}', '2025-08-11 09:09:09.541+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1553, 1, 'terminal_list_vms', '{}', '2025-08-11 09:20:03.897+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1554, 1, 'POST /terminal/ssh/test', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus"},"query":{}}', '2025-08-11 09:20:09.485+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1555, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ip a"},"query":{}}', '2025-08-11 09:20:15.858+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1556, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-11 09:20:19.21+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1557, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /etc"},"query":{}}', '2025-08-11 09:20:25.823+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1558, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-11 09:20:31.112+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1570, 1, 'terminal_list_vms', '{}', '2025-08-11 09:26:07.884+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1571, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 09:26:07.933+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1587, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:23:55.189+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1589, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:23:55.392+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1604, 1, 'GET /users', '{"query":{}}', '2025-08-11 10:25:57.503+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1621, 1, 'POST /vms/101/stop', '{"query":{}}', '2025-08-11 10:47:13.996+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1622, 1, 'stop_vm:101', '{}', '2025-08-11 10:47:14.041+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1642, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:50:04.205+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1663, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 11:10:46.541+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1664, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 11:10:46.61+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1679, 1, 'GET /vms', '{"query":{}}', '2025-08-11 12:02:58.864+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1682, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 12:02:59.059+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1683, 1, 'list_vms', '{}', '2025-08-11 12:02:59.074+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1699, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"c8f4a86e-ca73-44b8-bfca-edf40641cc99"},"query":{}}', '2025-08-11 13:17:46.513+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1717, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 13:29:03.363+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1737, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-11 14:01:47.153+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1738, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 14:01:53.822+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1739, 1, 'GET /vms', '{"query":{}}', '2025-08-11 14:01:53.823+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1740, 1, 'list_vms', '{}', '2025-08-11 14:01:53.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1741, 1, 'GET /vms', '{"query":{}}', '2025-08-11 14:01:53.981+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1754, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 01:57:30.23+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1780, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 03:23:06.625+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1782, 1, 'GET /roles', '{"query":{}}', '2025-08-12 03:23:06.742+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1785, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 03:23:06.895+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1787, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 03:23:07.031+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1800, 1, 'Déploiement Terraform', '{"vm_name":"testwebserver","service_type":"monitoring_cron","success":true,"log_path":"D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-88966679-e8a2-4c48-b948-75ca879e7343.log"}', '2025-08-12 03:54:43.917+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1825, 1, 'POST /templates/generate', '{"body":{"template_id":25,"config_data":{"SCRIPT_PATH":"/opt/monitoring/monitoring.sh","STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","STATUS_CRON_EXPR":"*/1 * * * *","SERVICES_CRON_EXPR":"*/1 * * * *","CRON_USER":"nexus"}},"query":{}}', '2025-08-12 04:37:40.615+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1826, 1, 'generate_template_file:25:monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_script001.sh', '{}', '2025-08-12 04:37:40.629+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1840, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 08:25:23.403+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1841, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 08:25:23.505+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1857, 1, 'GET /dashboard/stats?period=day', '{"query":{"period":"day"}}', '2025-08-12 11:12:04.497+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (951, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 19:00:10.797+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (954, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:00:11.684+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (956, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 19:00:11.81+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (959, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:00:14.231+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (961, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 19:00:14.335+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1239, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:59:54.239+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1251, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:51.814+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1253, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:01:57.1+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1266, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:39.615+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1267, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:16:39.675+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1278, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:23:13.017+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1290, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-10 10:46:55.435+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1302, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:49:44.165+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1303, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:49:44.232+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1322, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:58:12.66+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1323, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:58:12.73+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1334, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:03:46.238+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1344, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:08:21.348+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1357, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:02:13.132+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1374, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:36:11.926+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1382, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:44:11.927+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1390, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:52:11.944+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1398, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:00:11.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1406, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:08:11.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1414, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:16:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1422, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:24:11.932+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1430, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:32:11.934+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1438, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:40:11.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1446, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:48:11.941+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1454, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:56:11.915+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1462, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 15:04:11.923+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1472, 1, 'GET /settings/me', '{"query":{}}', '2025-08-10 21:08:35.699+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1473, 1, 'GET /settings/me', '{"query":{}}', '2025-08-10 21:08:35.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1474, 1, 'GET /settings/account', '{"query":{}}', '2025-08-10 21:08:42.217+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1475, 1, 'GET /settings/account', '{"query":{}}', '2025-08-10 21:08:42.269+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1493, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 06:52:00.584+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1494, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 06:52:00.638+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1505, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:08:55.648+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1524, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 07:10:13.532+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1542, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 09:09:42.538+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1543, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 09:09:42.657+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1559, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:20:42.094+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1560, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:20:42.151+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1572, 1, 'terminal_list_vms', '{}', '2025-08-11 09:26:09.889+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1588, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:23:55.255+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1606, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-11 10:27:00.085+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1623, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:48:10.015+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1624, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:48:10.072+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1646, 1, 'terminal_list_vms', '{}', '2025-08-11 10:50:11.053+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1647, 1, 'POST /terminal/ssh/test', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus"},"query":{}}', '2025-08-11 10:50:17.725+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1648, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ip a"},"query":{}}', '2025-08-11 10:50:24.506+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1649, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /tmp"},"query":{}}', '2025-08-11 10:50:28.74+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1650, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-11 10:50:32.474+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1665, 1, 'GET /templates', '{"query":{}}', '2025-08-11 11:34:24.254+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1666, 1, 'GET /templates', '{"query":{}}', '2025-08-11 11:34:24.308+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1684, 1, 'GET /templates', '{"query":{}}', '2025-08-11 12:05:48.008+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1685, 1, 'GET /templates', '{"query":{}}', '2025-08-11 12:05:48.084+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1700, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 13:25:16.533+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1702, 1, 'list_vms', '{}', '2025-08-11 13:25:16.58+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1718, 1, 'list_vms', '{}', '2025-08-11 13:29:03.376+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1719, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 13:29:04.845+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1720, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 13:29:04.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1742, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 14:01:54.022+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1755, 1, 'GET /vms', '{"query":{}}', '2025-08-12 01:57:30.236+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1764, 1, 'Déploiement Terraform', '{"vm_name":"testweb","service_type":"web_server_nginx","success":true,"log_path":"D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-2025-08-12T02-17-32-683Z-1.log","stdout":"\u001b[0m\u001b[1m\u001b[33mWarning: \u001b[0m\u001b[0m\u001b[1mValues for undeclared variables\u001b[0m\n\u001b[33m│\u001b[0m \u001b[0m\n\u001b[33m│\u001b[0m \u001b[0m\u001b[0mIn addition to the other similar warnings shown, 2 other variable(s)\n\u001b[33m│\u001b[0m \u001b[0mdefined without being declared.\n\u001b[33m╵\u001b[0m\u001b[0m\n\u001b[0m\u001b[1m\u001b[32m\nApply complete! Resources: 2 added, 0 changed, 0 destroyed.\n\u001b[0m\u001b[0m\u001b[1m\u001b[32m\nOutputs:\n\n\u001b[0mssh_commands = {\n  \"testweb\" = \"ssh -i C:/Users/Nexus-PC/.ssh/id_rsa nexus@192.168.24.206\"\n}\nstatus = <<EOT\n✅ 1 VM(s) déployée(s)\r\n📄 Scripts injectés :\r\n- testweb : D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\5\\testweb-script-1.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\5\\testweb-script-2.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\5\\testweb-script-3.sh, D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\terraform\\deployments\\5\\testweb-script-4.sh\r\n\nEOT\nvm_ids = {\n  \"testweb\" = 101\n}\nvm_ips = {\n  \"testweb\" = \"192.168.24.206\"\n}\nvm_names = [\n  \"testweb\",\n]\n","stderr":""}', '2025-08-12 02:19:37.285+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1781, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 03:23:06.704+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1784, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 03:23:06.841+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1788, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 03:23:07.082+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1801, 1, 'Déploiement Terraform', '{"vm_name":"testweb20122","service_type":"monitoring_cron","success":true,"log_path":"D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-793826a0-2600-40a4-bdd8-2fd2209e4df9.log"}', '2025-08-12 04:22:34.95+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1827, 1, 'POST /templates/generate', '{"body":{"template_id":26,"config_data":{"STATUS_SCRIPT_PATH":"/opt/monitoring/status.sh","STATUS_JSON_PATH":"/opt/monitoring/status.json"}},"query":{}}', '2025-08-12 04:37:54.853+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1828, 1, 'generate_template_file:26:system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_script002.sh', '{}', '2025-08-12 04:37:54.867+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1829, 1, 'POST /templates/generate', '{"body":{"template_id":27,"config_data":{"SERVICES_SCRIPT_PATH":"/opt/monitoring/services_status.sh","SERVICES_JSON_PATH":"/opt/monitoring/services_status.json"}},"query":{}}', '2025-08-12 04:38:00.05+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1842, 1, 'GET /templates', '{"query":{}}', '2025-08-12 08:26:06.513+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (952, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 19:00:10.843+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (953, 1, 'GET /permissions?page=7&limit=10', '{"query":{"page":"7","limit":"10"}}', '2025-08-09 19:00:11.624+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (957, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 19:00:11.858+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (958, 1, 'GET /permissions?page=6&limit=10', '{"query":{"page":"6","limit":"10"}}', '2025-08-09 19:00:14.176+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (962, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 19:00:14.375+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (963, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:03:10.33+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (964, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:03:10.404+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (965, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:03:12.648+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (966, 1, 'GET /users', '{"query":{}}', '2025-08-09 19:03:12.685+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (967, 1, 'GET /users', '{"query":{}}', '2025-08-09 19:03:12.737+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (968, 1, 'GET /roles', '{"query":{}}', '2025-08-09 19:03:12.77+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (969, 1, 'GET /terminal/vms', '{"query":{}}', '2025-08-09 19:03:42.526+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (970, 1, 'terminal_list_vms', '{}', '2025-08-09 19:03:42.576+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (971, 1, 'GET /terminal/vms', '{"query":{}}', '2025-08-09 19:03:42.644+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (972, 1, 'terminal_list_vms', '{}', '2025-08-09 19:03:42.668+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (973, 1, 'GET /terminal/vms', '{"query":{}}', '2025-08-09 19:16:58.078+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (974, 1, 'GET /vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 19:34:07.252+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (975, 1, 'list_vms', '{}', '2025-08-09 19:34:07.313+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (976, 1, 'GET /vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 19:39:00.628+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (977, 1, 'list_vms', '{}', '2025-08-09 19:39:00.689+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (978, 1, 'GET /vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 19:50:15.159+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (979, 1, 'list_vms', '{}', '2025-08-09 19:50:15.214+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (980, 1, 'GET /terminal/vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 19:54:56.108+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (981, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 19:55:31.188+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (982, 1, 'login', '{"user_id":1}', '2025-08-09 19:55:31.394+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (983, 1, 'GET /terminal/vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 19:55:53.844+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (984, 1, 'GET /terminal/vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 19:56:07.254+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (985, 1, 'GET /terminal/vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 20:38:10.629+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (986, 1, 'GET /terminal/vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 20:39:21.741+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (987, 1, 'terminal_list_vms', '{}', '2025-08-09 20:39:21.819+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (988, 1, 'GET /terminal/vms', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-09 20:44:14.088+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (989, 1, 'terminal_list_vms', '{}', '2025-08-09 20:44:14.289+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (990, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-09 20:52:07.002+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (991, 1, 'terminal_list_vms', '{}', '2025-08-09 20:52:07.173+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (992, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-09 21:00:32.731+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (993, 1, 'terminal_list_vms', '{}', '2025-08-09 21:00:32.865+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (994, 1, 'POST /terminal/ssh/test', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus"},"query":{}}', '2025-08-09 21:00:40.97+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (995, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ip a"},"query":{}}', '2025-08-09 21:00:59.419+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (996, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"systemctl status bind9"},"query":{}}', '2025-08-09 21:01:27.362+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (997, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /tmp"},"query":{}}', '2025-08-09 21:01:42.641+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (998, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:01:46.111+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (999, 1, 'POST /terminal/ssh/test', '{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus"},"query":{}}', '2025-08-09 21:02:26.182+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1000, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"cd /tmp"},"query":{}}', '2025-08-09 21:02:32.758+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1001, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:02:36.472+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1002, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"cd /opt"},"query":{}}', '2025-08-09 21:02:43.759+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1003, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"101","ip":"192.168.24.203","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:02:47.043+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1004, 1, 'POST /terminal/ssh/test', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus"},"query":{}}', '2025-08-09 21:02:54.63+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1005, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /etc"},"query":{}}', '2025-08-09 21:03:01.652+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1006, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:03:04.968+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1007, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"mkdir test"},"query":{}}', '2025-08-09 21:04:38.588+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1008, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:04:45.023+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1009, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd test"},"query":{}}', '2025-08-09 21:04:51.726+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1010, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:04:58.15+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1011, 1, 'GET /users', '{"query":{}}', '2025-08-09 21:09:54.178+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1012, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:09:54.226+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1013, 1, 'GET /users', '{"query":{}}', '2025-08-09 21:09:54.309+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1014, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:09:54.377+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1015, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:10:01.182+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1016, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:10:01.253+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1017, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 21:10:04.158+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1018, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-09 21:10:04.221+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1019, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:10:04.279+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1020, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:10:04.365+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1021, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 21:10:04.439+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1022, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 21:10:04.508+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1023, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 21:10:04.56+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1024, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 21:10:04.637+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1025, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 21:10:04.68+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1026, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 21:10:04.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1027, 1, 'GET /permissions?page=2&limit=10', '{"query":{"page":"2","limit":"10"}}', '2025-08-09 21:11:14.035+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1028, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:11:14.098+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1029, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 21:11:14.179+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1030, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 21:11:14.216+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1031, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 21:11:14.255+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1032, 1, 'GET /permissions?page=3&limit=10', '{"query":{"page":"3","limit":"10"}}', '2025-08-09 21:11:15.14+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1033, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:11:15.203+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1034, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 21:11:15.27+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1039, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 21:11:16.244+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1044, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-09 21:11:17.107+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1240, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:00:16.404+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1241, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:00:16.468+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1254, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:07:13.102+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1268, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:00.549+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1269, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:00.612+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1279, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:23:13.086+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1291, 1, 'terminal_list_vms', '{}', '2025-08-10 10:46:55.572+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1292, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-10 10:46:55.632+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1304, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:58:57.658+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1305, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:58:57.733+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1324, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:59:00.649+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1325, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:59:00.718+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1335, 1, 'POST /templates/simulate', '{"body":{"script":"#!/bin/bash\n\n# 📍 Ce script centralise l’installation des cronjobs de monitoring\n\n# 🔐 Vérifie que les scripts à exécuter existent\nSTATUS_SCRIPT=\"${STATUS_SCRIPT}\"\nSERVICES_SCRIPT=\"${SERVICES_SCRIPT}\"\n\n# 🧩 Crée les cronjobs uniquement s’ils n’existent pas déjà\nif [ -f \"$STATUS_SCRIPT\" ]; then\n  grep -q \"$STATUS_SCRIPT\" /etc/crontab || echo \"*/${STATUS_CRON_INTERVAL} * * * * root $STATUS_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour status.sh\"\nelse\n  echo \"❌ Script $STATUS_SCRIPT introuvable\"\nfi\n\nif [ -f \"$SERVICES_SCRIPT\" ]; then\n  grep -q \"$SERVICES_SCRIPT\" /etc/crontab || echo \"*/${SERVICES_CRON_INTERVAL} * * * * root $SERVICES_SCRIPT\" >> /etc/crontab\n  echo \"✅ Cron job ajouté pour services_status.sh\"\nelse\n  echo \"❌ Script $SERVICES_SCRIPT introuvable\"\nfi"},"query":{}}', '2025-08-10 12:04:07.412+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1345, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:08:21.405+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1358, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:23:14.936+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1359, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:23:15.004+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1375, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:37:11.925+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1383, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:45:11.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1391, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:53:11.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1399, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:01:11.948+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1407, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:09:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1415, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:17:11.931+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1423, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:25:11.938+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1431, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:33:11.951+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1439, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:41:11.926+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1447, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:49:11.912+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1455, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:57:12.019+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1463, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 15:05:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1476, 1, 'GET /templates', '{"query":{}}', '2025-08-10 22:27:52.357+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1477, 1, 'GET /templates', '{"query":{}}', '2025-08-10 22:27:52.436+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1495, 1, 'GET /templates', '{"query":{}}', '2025-08-11 06:54:52.087+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1496, 1, 'GET /templates', '{"query":{}}', '2025-08-11 06:54:52.148+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1506, 1, 'GET /users', '{"query":{}}', '2025-08-11 07:09:05.932+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1508, 1, 'GET /users', '{"query":{}}', '2025-08-11 07:09:06.052+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1525, 1, 'terminal_list_vms', '{}', '2025-08-11 07:10:15.39+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1526, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 07:10:15.44+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1544, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:10:18.299+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1545, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:10:18.382+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1561, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:21:46.043+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1562, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:21:46.106+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1573, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:36:59.508+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1574, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:36:59.589+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1590, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-11 10:25:29.601+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1591, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-11 10:25:29.673+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1592, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:25:29.728+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1593, 1, 'GET /roles', '{"query":{}}', '2025-08-11 10:25:29.805+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1596, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-11 10:25:29.937+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1599, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-11 10:25:30.088+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1607, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:27:11.629+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1608, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:27:11.682+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1625, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:48:45.541+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1626, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:48:45.601+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1651, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:50:46.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1652, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:50:46.832+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1667, 1, 'GET /users', '{"query":{}}', '2025-08-11 11:46:25.347+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1670, 1, 'GET /roles', '{"query":{}}', '2025-08-11 11:46:25.512+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1686, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 12:26:49.606+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1687, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 12:26:49.67+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1688, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 12:26:59.997+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1689, 1, 'GET /vms', '{"query":{}}', '2025-08-11 12:27:00+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1692, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 12:27:00.219+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1701, 1, 'GET /vms', '{"query":{}}', '2025-08-11 13:25:16.534+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1721, 1, 'GET /settings/account', '{"query":{}}', '2025-08-11 13:29:18.356+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1722, 1, 'GET /settings/account', '{"query":{}}', '2025-08-11 13:29:18.407+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1723, 1, 'GET /settings/me', '{"query":{}}', '2025-08-11 13:29:22.017+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1724, 1, 'GET /settings/me', '{"query":{}}', '2025-08-11 13:29:22.071+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1725, 1, 'GET /templates', '{"query":{}}', '2025-08-11 13:29:28.444+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1726, 1, 'GET /templates', '{"query":{}}', '2025-08-11 13:29:28.511+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1743, 1, 'list_vms', '{}', '2025-08-11 14:01:54.036+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1744, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 14:01:59.391+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1746, 1, 'list_vms', '{}', '2025-08-11 14:01:59.419+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1756, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 01:57:50.224+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1765, 1, 'Échec Déploiement Terraform', '{"error":"Terraform apply a échoué"}', '2025-08-12 03:02:25.852+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1783, 1, 'GET /roles', '{"query":{}}', '2025-08-12 03:23:06.801+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1789, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 03:23:07.131+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1802, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:24:07.409+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1803, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:24:07.483+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1830, 1, 'generate_template_file:27:service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_script002.sh', '{}', '2025-08-12 04:38:00.058+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1843, 1, 'GET /templates', '{"query":{}}', '2025-08-12 08:26:06.591+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1858, 1, 'GET /dashboard/stats?period=day', '{"query":{"period":"day"}}', '2025-08-12 11:12:04.557+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1867, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 11:23:36.016+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1868, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 11:23:36.076+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1870, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 11:23:38.853+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1877, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:37:40.389+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1881, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:37:57.138+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1883, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:38:49.628+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1885, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:53:16.726+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1889, 1, 'GET /roles', '{"query":{}}', '2025-08-12 11:53:27.293+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1035, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 21:11:15.311+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1038, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:11:16.185+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1040, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 21:11:16.282+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1043, 1, 'GET /roles', '{"query":{}}', '2025-08-09 21:11:17.044+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1045, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-09 21:11:17.149+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1242, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:00:26.113+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1255, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:08:48.49+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1270, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:04.77+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1280, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:26:40.235+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1281, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:26:40.308+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1293, 1, 'terminal_list_vms', '{}', '2025-08-10 10:46:55.705+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1306, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:58:59.474+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1326, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:59:12.994+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1327, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:59:13.073+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1336, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-10 12:07:22.785+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1346, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:08:35.896+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1347, 1, 'GET /templates', '{"query":{}}', '2025-08-10 12:08:35.955+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1360, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:23:22.757+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1376, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:38:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1384, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:46:11.924+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1392, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:54:11.939+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1400, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:02:11.961+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1408, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:10:11.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1416, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:18:12.013+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1424, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:26:11.938+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1432, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:34:11.917+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1440, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:42:11.923+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1448, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:50:11.934+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1456, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:58:11.913+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1478, 1, 'GET /templates', '{"query":{}}', '2025-08-10 22:37:49.98+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1479, 1, 'GET /templates', '{"query":{}}', '2025-08-10 22:37:50.048+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1497, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:03:14.525+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1507, 1, 'GET /roles', '{"query":{}}', '2025-08-11 07:09:05.972+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1509, 1, 'GET /roles', '{"query":{}}', '2025-08-11 07:09:06.1+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1512, 1, 'GET /permissions?page=1&limit=10', '{"query":{"page":"1","limit":"10"}}', '2025-08-11 07:09:14.286+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1514, 1, 'GET /roles', '{"query":{}}', '2025-08-11 07:09:14.388+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1516, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-11 07:09:14.49+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1519, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-11 07:09:14.653+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1527, 1, 'terminal_list_vms', '{}', '2025-08-11 07:10:16.39+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1528, 1, 'POST /terminal/ssh/test', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus"},"query":{}}', '2025-08-11 07:10:21.453+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1529, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ip a"},"query":{}}', '2025-08-11 07:10:26.478+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1530, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-11 07:10:30.251+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1531, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /tmp"},"query":{}}', '2025-08-11 07:10:36.674+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1532, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-11 07:10:41.053+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1546, 1, 'POST /vms/103/start', '{"query":{}}', '2025-08-11 09:15:10.722+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1547, 1, 'start_vm:103', '{}', '2025-08-11 09:15:10.776+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1563, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:21:58.86+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1564, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:21:58.917+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1575, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:42:03.358+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1576, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:42:03.434+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1577, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:42:06.719+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1578, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:42:06.78+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1594, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-11 10:25:29.856+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1597, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-11 10:25:30.009+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1609, 1, 'GET /auth/me', '{"query":{}}', '2025-08-11 10:30:51.046+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1610, 1, 'GET /auth/me', '{"query":{}}', '2025-08-11 10:30:51.089+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1627, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:48:56.302+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1653, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:52:40.848+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1654, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:52:40.947+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1668, 1, 'GET /roles', '{"query":{}}', '2025-08-11 11:46:25.392+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1669, 1, 'GET /users', '{"query":{}}', '2025-08-11 11:46:25.457+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1674, 1, 'terminal_list_vms', '{}', '2025-08-11 11:46:26.446+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1675, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 11:46:36.52+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1676, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 11:46:36.588+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1690, 1, 'list_vms', '{}', '2025-08-11 12:27:00.084+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1691, 1, 'GET /vms', '{"query":{}}', '2025-08-11 12:27:00.218+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1703, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 13:28:15.52+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1704, 1, 'GET /vms', '{"query":{}}', '2025-08-11 13:28:15.521+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1705, 1, 'list_vms', '{}', '2025-08-11 13:28:15.572+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1706, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 13:28:15.656+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1727, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"c06d59eb-a650-4427-ba92-05b107a6fd81"},"query":{}}', '2025-08-11 13:30:31.718+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1728, 1, 'POST /vms/delete', '{"body":{"vm_id":104,"instance_id":"d45d414b-a18d-4f3a-9a97-c84d8d4417c5"},"query":{}}', '2025-08-11 13:30:33.728+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1729, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-11 13:30:45.157+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1745, 1, 'GET /vms', '{"query":{}}', '2025-08-11 14:01:59.392+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1747, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 14:02:04.804+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1748, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-11 14:02:04.859+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1757, 1, 'GET /vms', '{"query":{}}', '2025-08-12 01:57:50.225+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1766, 1, 'Échec Déploiement Terraform', '{"error":"runTerraformApplyStream is not a function"}', '2025-08-12 03:08:30.915+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1786, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 03:23:06.938+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1804, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:32:20.087+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1805, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:32:20.16+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1831, 1, 'Échec Déploiement Terraform', '{"code":"TF_APPLY_FAILED","message":"Le déploiement a échoué."}', '2025-08-12 04:39:45.861+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1844, 1, 'GET /templates', '{"query":{}}', '2025-08-12 08:26:13.957+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1846, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-12 08:26:23.559+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1859, 1, 'GET /dashboard/stats?period=week', '{"query":{"period":"week"}}', '2025-08-12 11:13:09.164+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1860, 1, 'GET /dashboard/stats?period=month', '{"query":{"period":"month"}}', '2025-08-12 11:13:12.213+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1861, 1, 'GET /dashboard/stats?period=week', '{"query":{"period":"week"}}', '2025-08-12 11:13:14.967+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1862, 1, 'GET /dashboard/stats?period=day', '{"query":{"period":"day"}}', '2025-08-12 11:13:22.447+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1871, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"88966679-e8a2-4c48-b948-75ca879e7343"},"query":{}}', '2025-08-12 11:35:15.602+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1872, 1, 'POST /vms/delete', '{"body":{"vm_id":103,"instance_id":"793826a0-2600-40a4-bdd8-2fd2209e4df9"},"query":{}}', '2025-08-12 11:35:18.64+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1873, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-12 11:35:38.213+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1878, 1, 'list_vms', '{}', '2025-08-12 11:37:40.42+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1879, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:37:40.476+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1036, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 21:11:15.35+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1037, 1, 'GET /permissions?page=4&limit=10', '{"query":{"page":"4","limit":"10"}}', '2025-08-09 21:11:16.11+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1041, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 21:11:16.319+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1042, 1, 'GET /permissions?page=5&limit=10', '{"query":{"page":"5","limit":"10"}}', '2025-08-09 21:11:16.992+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1046, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-09 21:11:17.186+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1047, 1, 'GET /templates', '{"query":{}}', '2025-08-09 21:51:30.643+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1048, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-09 21:51:48.591+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1049, 1, 'terminal_list_vms', '{}', '2025-08-09 21:51:48.811+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1050, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-09 21:51:48.912+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1051, 1, 'terminal_list_vms', '{}', '2025-08-09 21:51:49.037+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1052, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-09 21:52:24.386+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1053, 1, 'terminal_list_vms', '{}', '2025-08-09 21:52:24.595+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1054, 1, 'POST /terminal/ssh/test', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus"},"query":{}}', '2025-08-09 21:53:01.721+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1055, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:53:06.845+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1056, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /tmp"},"query":{}}', '2025-08-09 21:53:16.52+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1057, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:53:19.759+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1058, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"curl localhost"},"query":{}}', '2025-08-09 21:53:45.779+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1059, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /var"},"query":{}}', '2025-08-09 21:54:21.521+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1060, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /var"},"query":{}}', '2025-08-09 21:54:28.263+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1061, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"cd /etc"},"query":{}}', '2025-08-09 21:54:32.846+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1062, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"104","ip":"192.168.24.205","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-09 21:54:39.114+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1063, 1, 'GET /logs', '{"query":{}}', '2025-08-09 21:54:59.826+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1064, 1, 'GET /logs', '{"query":{}}', '2025-08-09 21:54:59.905+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1065, 1, 'GET /logs', '{"query":{}}', '2025-08-09 21:55:59.714+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1066, 1, 'GET /logs', '{"query":{}}', '2025-08-09 21:56:59.666+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1067, 1, 'GET /logs', '{"query":{}}', '2025-08-09 21:57:59.671+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1068, 1, 'GET /logs', '{"query":{}}', '2025-08-09 21:58:59.69+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1069, 1, 'GET /templates', '{"query":{}}', '2025-08-09 21:59:57.261+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1070, 1, 'GET /templates', '{"query":{}}', '2025-08-09 21:59:57.373+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1071, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:03:49.704+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1072, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:04:06.78+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1073, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:05:25.779+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1074, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:05:25.841+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1075, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:05:40.648+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1076, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:05:40.715+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1077, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:09:23.234+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1078, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:09:23.309+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1079, 1, 'POST /templates', '{"body":{"name":"script_1754777375273.sh","service_type":"custom","category":"general","description":"","template_content":"#!/bin/bash\n\n# Nouveau script","fields_schema":{"fields":[]}},"query":{}}', '2025-08-09 22:09:35.381+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1080, 1, 'create_template:23', '{}', '2025-08-09 22:09:35.393+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1081, 1, 'PUT /templates/23', '{"body":{"name":"script_de_test.sh","template_content":"#!/bin/bash\n\n# Nouveau script"},"query":{}}', '2025-08-09 22:10:07.056+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1082, 1, 'update_template:23', '{}', '2025-08-09 22:10:07.082+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1083, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:22:12.552+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1084, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:22:12.613+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1085, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:05.921+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1086, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:05.979+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1087, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:11.489+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1088, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:11.573+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1089, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:13.609+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1090, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:13.661+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1091, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:15.191+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1092, 1, 'GET /templates', '{"query":{}}', '2025-08-09 22:23:15.249+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1093, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:00:36.636+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1094, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:00:36.725+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1095, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:01:02.681+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1096, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:01:02.75+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1097, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-09 23:01:54.943+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1098, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:02:01.968+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1099, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:03:01.886+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1100, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:04:01.745+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1101, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:05:01.74+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1102, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:06:01.731+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1103, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:07:01.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1104, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:08:01.735+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1105, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:09:01.731+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1106, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:10:01.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1107, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:11:01.732+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1108, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:12:01.755+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1109, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:13:01.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1110, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:14:01.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1111, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:15:01.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1112, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:16:01.761+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1113, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:17:01.773+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1114, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:18:01.735+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1115, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:19:01.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1116, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:20:01.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1117, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:21:01.735+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1118, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:22:01.751+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1119, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:23:03.823+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1120, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:24:01.738+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1121, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:25:01.742+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1122, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:26:01.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1123, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:27:01.765+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1124, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:28:01.735+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1125, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:29:01.737+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1126, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:30:01.84+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1127, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:31:01.751+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1128, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:32:01.739+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1129, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:33:01.744+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1130, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:34:01.73+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1131, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:35:01.752+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1132, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:36:01.738+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1133, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:37:01.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1134, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:38:01.731+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1135, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:39:01.75+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1136, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:40:01.745+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1137, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:41:01.738+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1138, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:42:01.733+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1139, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:43:01.762+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1140, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:44:01.726+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1141, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:45:01.739+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1142, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:46:01.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1143, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:47:01.742+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1144, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:48:01.746+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1145, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:49:01.733+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1146, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:50:01.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1147, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:51:01.762+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1148, 1, 'GET /logs?page=2&pageSize=10', '{"query":{"page":"2","pageSize":"10"}}', '2025-08-09 23:52:01.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1149, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:54:33.66+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1150, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:54:33.731+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1151, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:54:46.352+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1152, 1, 'GET /templates', '{"query":{}}', '2025-08-09 23:54:46.421+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1153, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:05:46.113+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1154, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:06:03.285+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1155, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:07:03.886+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1156, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:07:03.953+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1157, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:08:22.437+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1158, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:08:22.505+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1159, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:39:23.455+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1160, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:39:30.103+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1161, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:39:30.192+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1162, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:39:50.962+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1163, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:41:27.879+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1164, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:41:27.947+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1165, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:41:38.433+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1166, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:41:51.223+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1167, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:41:51.284+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1168, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:42:05.11+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1169, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:42:05.166+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1170, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:42:10.3+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1171, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:42:10.385+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1172, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:42:26.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1173, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:42:26.984+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1174, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:43:01.708+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1175, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:43:05.223+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1176, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:43:05.301+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1177, 1, 'POST /templates', '{"body":{"name":"script_1754815397604.sh","service_type":"custom","category":"general","description":"","template_content":"#!/bin/bash\n\n# Nouveau script","fields_schema":{"fields":[]}},"query":{}}', '2025-08-10 08:43:17.743+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1178, 1, 'create_template:24', '{}', '2025-08-10 08:43:17.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1179, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:53:30.905+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1180, 1, 'GET /templates', '{"query":{}}', '2025-08-10 08:53:30.968+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1181, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:19.257+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1182, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:19.343+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1183, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:24.586+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1184, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:24.658+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1185, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:30.69+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1186, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:30.759+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1187, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:42.725+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1188, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:03:42.861+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1189, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:04:33.927+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1190, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:04:33.997+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1191, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:04:41.029+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1192, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:04:41.099+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1193, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:21:36.88+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1194, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:21:45.748+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1195, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:21:45.822+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1196, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:22:24.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1197, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:05.791+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1198, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:05.861+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1199, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:09.878+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1200, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:09.954+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1201, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:14.979+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1202, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:15.041+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1203, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:21.523+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1204, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:21.583+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1205, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:28.11+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1206, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:28.172+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1207, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:43.889+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1208, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:43.964+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1209, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:54.935+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1210, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:55.001+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1211, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:57.847+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1212, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:24:57.91+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1213, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:07.606+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1214, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:07.691+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1215, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:11.191+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1216, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:11.256+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1217, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:39.793+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1218, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:39.873+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1219, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:47.639+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1220, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:47.721+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1221, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:51.675+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1222, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:25:51.736+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1223, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:29:20.976+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1224, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:29:21.042+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1225, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:30:02.801+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1226, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:30:02.858+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1227, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:30:18.374+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1228, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:30:18.46+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1229, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:32:44.048+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1230, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:32:44.106+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1231, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:32:46.008+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1232, 1, 'GET /templates', '{"query":{}}', '2025-08-10 09:32:46.07+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1243, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:00:26.169+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1256, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:12:06.216+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1271, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:17:04.824+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1282, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:26:46.862+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1294, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:06.302+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1295, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:48:06.39+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1307, 1, 'GET /templates', '{"query":{}}', '2025-08-10 10:58:59.54+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1328, 1, 'GET /templates', '{"query":{}}', '2025-08-10 11:59:21.86+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1337, 1, 'terminal_list_vms', '{}', '2025-08-10 12:07:22.908+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1348, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 12:51:45.035+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1349, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-10 12:51:45.112+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1361, 1, 'GET /templates', '{"query":{}}', '2025-08-10 13:23:22.833+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1377, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:39:11.942+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1385, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:47:11.95+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1393, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 13:55:11.933+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1401, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:03:11.934+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1409, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:11:11.944+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1417, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:19:11.918+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1425, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:27:11.923+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1433, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:35:11.919+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1441, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:43:11.936+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1449, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:51:11.926+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1457, 1, 'GET /dashboard', '{"query":{}}', '2025-08-10 14:59:11.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1480, 1, 'GET /templates', '{"query":{}}', '2025-08-10 22:40:06.186+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1481, 1, 'GET /templates', '{"query":{}}', '2025-08-10 22:40:06.253+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1498, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:04:22.161+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1499, 1, 'GET /templates', '{"query":{}}', '2025-08-11 07:04:22.218+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1510, 1, 'GET /roles', '{"query":{}}', '2025-08-11 07:09:10.864+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1517, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-11 07:09:14.543+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1521, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-11 07:09:14.733+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1533, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"cd /etc"},"query":{}}', '2025-08-11 07:10:53.556+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1534, 1, 'POST /terminal/ssh/exec', '{"body":{"vm_id":"103","ip":"192.168.24.130","ssh_user":"nexus","command":"ls"},"query":{}}', '2025-08-11 07:10:55.603+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1548, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-11 09:19:39.969+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1565, 1, 'GET /templates', '{"query":{}}', '2025-08-11 09:22:07.248+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1579, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:42:08.167+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1580, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 09:42:08.231+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1595, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-11 10:25:29.896+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1598, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-11 10:25:30.047+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1611, 1, 'GET /vms', '{"query":{}}', '2025-08-11 10:45:33.712+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1615, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 10:45:33.918+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1616, 1, 'list_vms', '{}', '2025-08-11 10:45:33.939+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1628, 1, 'GET /templates', '{"query":{}}', '2025-08-11 10:48:56.356+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1655, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 10:57:43.103+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1657, 1, 'list_vms', '{}', '2025-08-11 10:57:43.152+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1658, 1, 'GET /dashboard', '{"query":{}}', '2025-08-11 10:57:43.231+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1671, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-11 11:46:26.248+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1693, 1, 'list_vms', '{}', '2025-08-11 12:27:00.243+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1707, 1, 'GET /vms', '{"query":{}}', '2025-08-11 13:28:15.658+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1730, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-11 13:36:18.002+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1749, 1, 'GET /templates', '{"query":{}}', '2025-08-11 14:03:01.857+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1750, 1, 'GET /templates', '{"query":{}}', '2025-08-11 14:03:01.938+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1758, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 01:59:44.934+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1760, 1, 'list_vms', '{}', '2025-08-12 01:59:44.966+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1767, 1, 'Déploiement Terraform', '{"vm_name":"testweb3","service_type":"web_server_nginx","success":true,"log_path":"D:\\Keyce_B3\\Soutenance\\linusupervisor-back\\backend\\logs\\deploy-12ca649c-5815-4412-97b7-4298b2a83444.log"}', '2025-08-12 03:22:05.33+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1790, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-12 03:24:57.518+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1791, 1, 'login', '{"user_id":1}', '2025-08-12 03:24:57.79+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1792, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 03:25:00.287+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1793, 1, 'GET /vms', '{"query":{}}', '2025-08-12 03:25:00.288+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1794, 1, 'list_vms', '{}', '2025-08-12 03:25:00.328+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1795, 1, 'GET /vms', '{"query":{}}', '2025-08-12 03:25:00.418+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1796, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 03:25:00.422+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1806, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:33:10.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1808, 1, 'GET /vms', '{"query":{}}', '2025-08-12 04:33:14.349+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1811, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 04:33:14.517+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1812, 1, 'list_vms', '{}', '2025-08-12 04:33:14.531+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1813, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:33:22.253+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1832, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-12 04:51:09.576+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1845, 1, 'GET /templates', '{"query":{}}', '2025-08-12 08:26:14.021+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1863, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 11:20:10.102+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1864, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 11:20:10.245+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1874, 1, 'POST /vms/delete', '{"body":{"vm_id":105,"instance_id":""},"query":{}}', '2025-08-12 11:36:20.587+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1880, 1, 'list_vms', '{}', '2025-08-12 11:37:40.496+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1882, 1, 'list_vms', '{}', '2025-08-12 11:37:57.169+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1884, 1, 'list_vms', '{}', '2025-08-12 11:38:49.704+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1886, 1, 'list_vms', '{}', '2025-08-12 11:53:16.801+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1887, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 11:53:27.153+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1819, 1, 'POST /templates', '{"body":{"name":"Surveillance des services - Génération du script","service_type":"service_monitoring_script","category":"monitoring","description":"Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh","template_content":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","script_path":"/scripts/install_services_monitoring.sh","fields_schema":{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}},"query":{}}', '2025-08-12 04:37:03.49+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1820, 1, 'create_template:27', '{}', '2025-08-12 04:37:03.504+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1821, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:37:08.556+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1822, 1, 'GET /templates', '{"query":{}}', '2025-08-12 04:37:08.609+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1888, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 11:53:27.239+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1890, 1, 'GET /roles', '{"query":{}}', '2025-08-12 11:53:27.356+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1891, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 11:53:27.404+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1894, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 11:53:27.571+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1892, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 11:53:27.454+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1893, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 11:53:27.493+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1895, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 11:53:27.629+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1896, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 11:53:27.673+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1897, 1, 'POST /permissions', '{"body":{"name":"script.servicetypes","description":"Script type"},"query":{}}', '2025-08-12 11:54:10.529+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1898, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[63]}],"query":{}}', '2025-08-12 11:54:25.988+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1899, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:54:31.204+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1900, 1, 'list_vms', '{}', '2025-08-12 11:54:31.325+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1901, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:54:31.412+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1902, 1, 'list_vms', '{}', '2025-08-12 11:54:31.45+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1903, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:54:38.367+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1904, 1, 'list_vms', '{}', '2025-08-12 11:54:38.392+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1905, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 11:55:12.739+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1906, 1, 'GET /roles', '{"query":{}}', '2025-08-12 11:55:12.81+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1907, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 11:55:12.889+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1908, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 11:55:12.925+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1909, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 11:55:12.963+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1910, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:55:49.254+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1911, 1, 'list_vms', '{}', '2025-08-12 11:55:49.304+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1912, 1, 'POST /permissions', '{"body":{"name":"script.list","description":"script.list"},"query":{}}', '2025-08-12 11:56:36.328+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1913, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[64]}],"query":{}}', '2025-08-12 11:56:39.513+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1914, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:56:45.835+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1915, 1, 'list_vms', '{}', '2025-08-12 11:56:45.868+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1916, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-12 11:58:09.279+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1917, 1, 'login', '{"user_id":1}', '2025-08-12 11:58:09.454+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1918, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 11:58:12.171+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1919, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:58:12.173+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1920, 1, 'list_vms', '{}', '2025-08-12 11:58:12.2+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1921, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:58:12.279+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1922, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 11:58:12.339+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1923, 1, 'list_vms', '{}', '2025-08-12 11:58:12.354+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1924, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:58:20.623+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1925, 1, 'list_vms', '{}', '2025-08-12 11:58:20.647+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1926, 1, 'GET /vms', '{"query":{}}', '2025-08-12 11:58:20.7+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1927, 1, 'list_vms', '{}', '2025-08-12 11:58:20.719+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1928, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:00:56.964+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1929, 1, 'list_vms', '{}', '2025-08-12 12:00:57.029+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1930, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:03:00.802+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1931, 1, 'list_vms', '{}', '2025-08-12 12:03:00.852+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1932, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:04:29.807+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1933, 1, 'list_vms', '{}', '2025-08-12 12:04:29.87+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1934, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:04:57.212+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1935, 1, 'list_vms', '{}', '2025-08-12 12:04:57.278+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1936, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:05:20.686+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1937, 1, 'list_vms', '{}', '2025-08-12 12:05:20.723+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1938, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:05:44.012+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1939, 1, 'list_vms', '{}', '2025-08-12 12:05:44.093+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1940, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 12:11:48.901+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1941, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:11:48.902+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1942, 1, 'list_vms', '{}', '2025-08-12 12:11:48.947+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1943, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:11:49.052+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1944, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 12:11:49.056+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1945, 1, 'list_vms', '{}', '2025-08-12 12:11:49.075+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1946, 1, 'GET /dashboard/insights', '{"query":{}}', '2025-08-12 12:11:55.037+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1947, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 12:15:11.45+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1948, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 12:15:11.532+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1949, 1, 'DELETE /templates/27', '{"query":{}}', '2025-08-12 12:15:16.59+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1950, 1, 'delete_template:27', '{}', '2025-08-12 12:15:16.605+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1951, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 12:15:16.664+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1952, 1, 'GET /templates?status=supprime', '{"query":{"status":"supprime"}}', '2025-08-12 12:15:20.342+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1953, 1, 'POST /templates/27/restore', '{"query":{}}', '2025-08-12 12:15:22.971+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1954, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 12:15:40.656+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1955, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 12:15:40.729+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1956, 1, 'GET /roles', '{"query":{}}', '2025-08-12 12:15:40.781+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1957, 1, 'GET /roles', '{"query":{}}', '2025-08-12 12:15:40.87+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1958, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 12:15:40.93+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1959, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 12:15:40.972+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1960, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 12:15:41.032+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1961, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 12:15:41.108+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1962, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 12:15:41.15+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2201, 1, 'GET /roles', '{"query":{}}', '2025-08-13 03:35:47.943+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1963, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 12:15:41.193+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1964, 1, 'POST /permissions', '{"body":{"name":"template.restore","description":"template.restore"},"query":{}}', '2025-08-12 12:15:51.888+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1965, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 12:17:50.356+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1966, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 12:17:50.416+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1967, 1, 'GET /templates?status=supprime', '{"query":{"status":"supprime"}}', '2025-08-12 12:17:53.368+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1968, 1, 'POST /templates/27/restore', '{"query":{}}', '2025-08-12 12:17:55.903+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1969, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 12:18:01.828+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1970, 1, 'GET /templates?status=supprime', '{"query":{"status":"supprime"}}', '2025-08-12 12:18:05.57+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1971, 1, 'POST /templates/27/restore', '{"query":{}}', '2025-08-12 12:18:07.377+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1972, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 12:18:23.797+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1973, 1, 'POST /scripts/29/analyze', '{"body":{"script":"#!/bin/bash\nset -euo pipefail\n\n# === Variables substituées par le moteur de template ===\nSCRIPT_PATH=\"/opt/monitoring/monitoring.sh\"\nSTATUS_SCRIPT_PATH=\"/opt/monitoring/status.sh\"\nSERVICES_SCRIPT_PATH=\"/opt/monitoring/services_status.sh\"\nSTATUS_CRON_EXPR=''*/1 * * * *''\nSERVICES_CRON_EXPR=''*/1 * * * *''\nCRON_USER=''nexus''\n\nMONITOR_DIR=\"$(dirname \"/opt/monitoring/status.sh\")\"\nMARK_BOOT=\"# MONITORING_CRON\"\nMARK_STATUS=\"# MONITORING_STATUS_CRON\"\nMARK_SERVICES=\"# MONITORING_SERVICES_CRON\"\n\nmkdir -p \"${MONITOR_DIR}\"\n\n# --- Génère le script  ---\ncat > \"/opt/monitoring/monitoring.sh\" <<''EOS''\n#!/bin/bash\nset -euo pipefail\n\nSTATUS_SCRIPT_PATH=\"__STATUS_SCRIPT_PATH__\"\nSERVICES_SCRIPT_PATH=\"__SERVICES_SCRIPT_PATH__\"\nSTATUS_CRON_EXPR=''__STATUS_CRON_EXPR__''\nSERVICES_CRON_EXPR=''__SERVICES_CRON_EXPR__''\nCRON_USER=''__CRON_USER__''\nMARK_BOOT=\"# MONITORING_CRON\"\nMARK_STATUS=\"# MONITORING_STATUS_CRON\"\nMARK_SERVICES=\"# MONITORING_SERVICES_CRON\"\n\nexists_and_exec() {\n  local f=\"$1\"\n  [[ -f \"$f\" ]] || return 1\n  [[ -x \"$f\" ]] || chmod +x \"$f\" || true\n  return 0\n}\n\ncrontab_get() { crontab -u \"$CRON_USER\" -l 2>/dev/null || true; }\ncrontab_set() { crontab -u \"$CRON_USER\" -; }\n\nadd_cron_once() {\n  local expr=\"$1\" cmd=\"$2\" mark=\"$3\"\n  local current\n  current=\"$(crontab_get)\"\n  if ! echo \"$current\" | grep -Fq \"$mark\"; then\n    { echo \"$current\" | grep -Fv \"$mark\"; echo \"$expr $cmd $mark\"; } | crontab_set\n  fi\n}\n\nremove_mark() {\n  local mark=\"$1\"\n  crontab_get | grep -Fv \"$mark\" | crontab_set\n}\n\nok=1\nif exists_and_exec \"$STATUS_SCRIPT_PATH\"; then\n  add_cron_once \"$STATUS_CRON_EXPR\" \"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\" \"$MARK_STATUS\"\nelse\n  ok=0\nfi\n\nif exists_and_exec \"$SERVICES_SCRIPT_PATH\"; then\n  add_cron_once \"$SERVICES_CRON_EXPR\" \"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\" \"$MARK_SERVICES\"\nelse\n  ok=0\nfi\n\nif [[ \"$ok\" -eq 1 ]]; then\n  # Exécuter une première fois pour générer les JSON immédiatement\n  bash \"$STATUS_SCRIPT_PATH\" || true\n  bash \"$SERVICES_SCRIPT_PATH\" || true\n  # Se retirer du crontab\n  remove_mark \"$MARK_BOOT\"\nfi\nEOS\n\n# Injecte les variables réelles dans le \nsed -i \\\n  -e \"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\//\\\\/}#g\" \\\n  -e \"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\//\\\\/}#g\" \\\n  -e \"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\//\\\\/}#g\" \\\n  -e \"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\//\\\\/}#g\" \\\n  -e \"s#__CRON_USER__#nexus#g\" \\\n  \"/opt/monitoring/monitoring.sh\"\n\nchmod +x \"/opt/monitoring/monitoring.sh\"\n\n# --- (Ré)active le service cron/ crond ---\nif command -v systemctl >/dev/null 2>&1; then\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\nfi\n\n# --- Installe le cron  (toutes les minutes) ---\ncurrent_cron=\"$(crontab -u \"nexus\" -l 2>/dev/null || true)\"\nif ! echo \"$current_cron\" | grep -Fq \"$MARK_BOOT\"; then\n  { echo \"$current_cron\" | grep -Fv \"$MARK_BOOT\"; echo \"* * * * * /opt/monitoring/monitoring.sh $MARK_BOOT\"; } | crontab -u \"nexus\" -\nfi\n\nexit 0\n","entity_type":"script","entity_id":29},"query":{}}', '2025-08-12 12:18:29.516+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1974, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 12:21:18.616+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1975, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:21:18.616+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1976, 1, 'list_vms', '{}', '2025-08-12 12:21:18.661+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1977, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:21:18.717+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1978, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 12:21:18.767+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1979, 1, 'list_vms', '{}', '2025-08-12 12:21:18.783+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1980, 1, 'Échec Déploiement Terraform', '{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l''hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}', '2025-08-12 12:22:35.894+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1981, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:26:16.714+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1982, 1, 'list_vms', '{}', '2025-08-12 12:26:16.868+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1983, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:26:16.933+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1984, 1, 'list_vms', '{}', '2025-08-12 12:26:16.957+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1985, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:26:45.694+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1986, 1, 'list_vms', '{}', '2025-08-12 12:26:45.813+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1987, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:26:45.875+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1988, 1, 'list_vms', '{}', '2025-08-12 12:26:45.899+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1989, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:26:49.559+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1990, 1, 'list_vms', '{}', '2025-08-12 12:26:49.586+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1991, 1, 'GET /vms', '{"query":{}}', '2025-08-12 12:27:39.533+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1992, 1, 'list_vms', '{}', '2025-08-12 12:27:39.571+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1993, 1, 'Échec Déploiement Terraform', '{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l''hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}', '2025-08-12 12:42:15.693+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1994, 1, 'GET /vms', '{"query":{}}', '2025-08-12 13:24:19.573+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1995, 1, 'list_vms', '{}', '2025-08-12 13:24:19.703+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1996, 1, 'GET /vms', '{"query":{}}', '2025-08-12 13:24:19.758+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1997, 1, 'list_vms', '{}', '2025-08-12 13:24:19.783+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1998, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:29:55.066+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (1999, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:29:55.141+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2000, 1, 'GET /templates', '{"query":{}}', '2025-08-12 13:30:27.644+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2001, 1, 'GET /templates', '{"query":{}}', '2025-08-12 13:30:27.714+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2002, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:30:41.534+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2003, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:30:41.592+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2004, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:31:14.632+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2005, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:31:14.693+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2006, 1, 'GET /templates', '{"query":{}}', '2025-08-12 13:33:42.53+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2007, 1, 'GET /templates', '{"query":{}}', '2025-08-12 13:33:42.629+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2008, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:33:44.818+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2009, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:33:44.881+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2010, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:33:48.604+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2011, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:33:48.66+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2012, 1, 'GET /auth/me', '{"query":{}}', '2025-08-12 13:34:17.679+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2013, 1, 'GET /auth/me', '{"query":{}}', '2025-08-12 13:34:17.748+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2014, 1, 'GET /vms', '{"query":{}}', '2025-08-12 13:34:41.248+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2015, 1, 'list_vms', '{}', '2025-08-12 13:34:41.376+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2016, 1, 'GET /vms', '{"query":{}}', '2025-08-12 13:34:41.432+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2017, 1, 'list_vms', '{}', '2025-08-12 13:34:41.451+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2018, 1, 'Échec Déploiement Terraform', '{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l''hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}', '2025-08-12 13:35:21.572+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2019, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:35:28.353+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2020, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:35:28.406+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2021, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:35:30.438+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2022, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:35:30.499+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2023, 1, 'GET /templates', '{"query":{}}', '2025-08-12 13:39:29.596+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2024, 1, 'GET /templates', '{"query":{}}', '2025-08-12 13:39:29.663+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2025, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:39:32.049+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2026, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 13:39:32.116+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2027, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:39:34.466+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2028, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:39:34.534+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2029, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:40:57.887+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2030, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 13:40:57.948+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2031, 1, 'GET /vms', '{"query":{}}', '2025-08-12 13:49:09.487+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2032, 1, 'list_vms', '{}', '2025-08-12 13:49:09.614+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2033, 1, 'GET /vms', '{"query":{}}', '2025-08-12 13:49:09.674+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2034, 1, 'list_vms', '{}', '2025-08-12 13:49:09.696+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2035, 1, 'GET /vms', '{"query":{}}', '2025-08-12 14:14:57.666+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2036, 1, 'list_vms', '{}', '2025-08-12 14:14:57.696+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2037, 1, 'GET /vms', '{"query":{}}', '2025-08-12 14:22:50.517+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2038, 1, 'list_vms', '{}', '2025-08-12 14:22:50.649+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2039, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 14:23:19.725+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2040, 1, 'GET /vms', '{"query":{}}', '2025-08-12 14:23:19.727+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2041, 1, 'list_vms', '{}', '2025-08-12 14:23:19.775+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2042, 1, 'GET /vms', '{"query":{}}', '2025-08-12 14:23:19.861+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2043, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 14:23:19.918+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2044, 1, 'list_vms', '{}', '2025-08-12 14:23:19.936+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2045, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 14:23:32.754+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2046, 1, 'GET /dashboard/map', '{"query":{}}', '2025-08-12 14:23:32.838+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2047, 1, 'GET /dashboard/stats?period=day', '{"query":{"period":"day"}}', '2025-08-12 14:23:47.406+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2048, 1, 'GET /dashboard/stats?period=day', '{"query":{"period":"day"}}', '2025-08-12 14:23:47.467+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2049, 1, 'GET /dashboard/insights?period=day', '{"query":{"period":"day"}}', '2025-08-12 14:23:51.739+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2050, 1, 'GET /dashboard/insights?period=day', '{"query":{"period":"day"}}', '2025-08-12 14:24:08.287+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2051, 1, 'POST /vms/delete', '{"body":{"vm_id":101,"instance_id":"88966679-e8a2-4c48-b948-75ca879e7343"},"query":{}}', '2025-08-12 14:25:17.913+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2052, 1, 'GET /vms', '{"query":{}}', '2025-08-12 14:25:51.194+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2053, 1, 'list_vms', '{}', '2025-08-12 14:25:51.324+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2054, 1, 'GET /vms', '{"query":{}}', '2025-08-12 14:25:51.384+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2055, 1, 'list_vms', '{}', '2025-08-12 14:25:51.406+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2056, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 14:26:36.858+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2057, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 14:26:36.928+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2058, 1, 'GET /templates?status=all', '{"query":{"status":"all"}}', '2025-08-12 14:26:42.711+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2059, 1, 'POST /templates/27/restore', '{"query":{}}', '2025-08-12 14:26:44.923+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2060, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 14:26:55.118+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2061, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 14:26:55.191+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2062, 1, 'GET /roles', '{"query":{}}', '2025-08-12 14:26:55.241+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2063, 1, 'GET /roles', '{"query":{}}', '2025-08-12 14:26:55.359+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2064, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 14:26:55.426+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2065, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 14:26:55.472+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2066, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 14:26:55.517+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2067, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 14:26:55.692+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2068, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 14:26:55.734+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2069, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 14:26:55.781+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2070, 1, 'POST /permissions/assign', '{"body":[{"role_id":1,"permission_ids":[65]}],"query":{}}', '2025-08-12 14:27:25.37+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2071, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 14:27:30.499+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2072, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 14:27:30.565+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2073, 1, 'GET /templates?status=all', '{"query":{"status":"all"}}', '2025-08-12 14:27:33.692+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2074, 1, 'POST /templates/27/restore', '{"query":{}}', '2025-08-12 14:27:35.305+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2075, 1, 'restore_template:27', '{}', '2025-08-12 14:27:35.316+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2076, 1, 'GET /templates?status=all', '{"query":{"status":"all"}}', '2025-08-12 14:27:35.376+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2077, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 14:27:46.069+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2078, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 14:27:46.136+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2079, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 14:28:02.806+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2080, 1, 'GET /vms/nodes', '{"query":{}}', '2025-08-12 14:28:02.816+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2081, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 14:28:02.902+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2082, 1, 'GET /vms/nodes', '{"query":{}}', '2025-08-12 14:28:03.021+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2083, 1, 'GET /vms/system?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:28:03.071+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2084, 1, 'GET /vms/storages?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:28:03.075+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2085, 1, 'GET /vms/system?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:28:03.237+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2086, 1, 'GET /vms/storages?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:28:03.238+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2087, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 14:28:19.45+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2088, 1, 'GET /vms/nodes', '{"query":{}}', '2025-08-12 14:28:19.517+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2089, 1, 'GET /vms/storages?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:28:19.703+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2090, 1, 'GET /vms/system?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:28:19.704+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2091, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 14:57:51.371+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2092, 1, 'GET /vms/nodes', '{"query":{}}', '2025-08-12 14:57:51.411+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2093, 1, 'GET /vms/system?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:57:51.531+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2094, 1, 'GET /vms/storages?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 14:57:51.532+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2095, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 15:03:44.556+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2096, 1, 'GET /vms/nodes', '{"query":{}}', '2025-08-12 15:03:44.618+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2097, 1, 'GET /vms/system?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 15:03:44.767+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2098, 1, 'GET /vms/storages?node=pve', '{"query":{"node":"pve"}}', '2025-08-12 15:03:44.769+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2099, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 15:04:13.334+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2100, 1, 'GET /vms', '{"query":{}}', '2025-08-12 15:04:13.336+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2101, 1, 'list_vms', '{}', '2025-08-12 15:04:13.389+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2102, 1, 'GET /vms', '{"query":{}}', '2025-08-12 15:04:13.497+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2103, 1, 'GET /dashboard', '{"query":{}}', '2025-08-12 15:04:13.505+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2104, 1, 'list_vms', '{}', '2025-08-12 15:04:13.534+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2105, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 15:10:13.23+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2106, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 15:10:13.29+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2107, 1, 'GET /templates', '{"query":{}}', '2025-08-12 15:11:47.645+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2108, 1, 'GET /templates', '{"query":{}}', '2025-08-12 15:11:47.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2109, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 15:11:49.979+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2110, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 15:11:50.043+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2111, 1, 'GET /vms/storages', '{"query":{}}', '2025-08-12 15:11:50.097+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2112, 1, 'GET /vms/storages', '{"query":{}}', '2025-08-12 15:11:50.164+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2113, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 15:11:53.277+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2114, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 15:11:53.328+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2115, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 15:11:54.585+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2116, 1, 'GET /settings/me', '{"query":{}}', '2025-08-12 15:11:54.655+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2117, 1, 'GET /vms/storages', '{"query":{}}', '2025-08-12 15:11:54.707+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2118, 1, 'GET /vms/storages', '{"query":{}}', '2025-08-12 15:11:54.777+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2119, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 15:12:11.239+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2120, 1, 'GET /settings/account', '{"query":{}}', '2025-08-12 15:12:11.291+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2121, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:12:21.747+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2122, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:12:21.864+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2123, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-12 15:12:35.008+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2124, 1, 'terminal_list_vms', '{}', '2025-08-12 15:12:35.037+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2125, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-12 15:12:35.096+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2126, 1, 'terminal_list_vms', '{}', '2025-08-12 15:12:35.12+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2127, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-12 15:12:44.05+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2128, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 15:13:26.963+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2129, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-12 15:13:27.027+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2130, 1, 'GET /roles', '{"query":{}}', '2025-08-12 15:13:27.068+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2131, 1, 'GET /roles', '{"query":{}}', '2025-08-12 15:13:27.14+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2132, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 15:13:27.197+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2133, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 15:13:27.236+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2134, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 15:13:27.273+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2135, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-12 15:13:27.349+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2136, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-12 15:13:27.386+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2137, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-12 15:13:27.441+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2138, 1, 'GET /roles', '{"query":{}}', '2025-08-12 15:14:31.705+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2139, 1, 'GET /roles', '{"query":{}}', '2025-08-12 15:14:31.767+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2140, 1, 'GET /users', '{"query":{}}', '2025-08-12 15:14:39.685+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2141, 1, 'GET /roles', '{"query":{}}', '2025-08-12 15:14:39.724+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2142, 1, 'GET /users', '{"query":{}}', '2025-08-12 15:14:39.78+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2143, 1, 'GET /roles', '{"query":{}}', '2025-08-12 15:14:39.823+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2144, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:14:48.255+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2145, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:14:48.317+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2146, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:14:57.645+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2147, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:18:11.458+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2148, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:25:23.297+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2149, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:25:45.135+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2150, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:25:57.013+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2151, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance système\ncat <<''EOS'' > ${STATUS_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\nHOSTNAME=$(hostname)\nIP_ADDR=$(hostname -I | awk ''{print $1}'')\nLOAD_AVG=$(cut -d '' '' -f1-3 /proc/loadavg)\nMEM_TOTAL=$(grep MemTotal /proc/meminfo | awk ''{print $2}'')\nMEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk ''{print $2}'')\n\nDISK_TOTAL=$(df -B1 / | tail -1 | awk ''{print $2}'')\nDISK_USED=$(df -B1 / | tail -1 | awk ''{print $3}'')\nDISK_AVAIL=$(df -B1 / | tail -1 | awk ''{print $4}'')\n\nIFACE=$(ip route get 1.1.1.1 | awk ''{print $5; exit}'')\nRX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)\nTX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)\n\nOPEN_PORTS=$(ss -tuln | awk ''NR>1 {split($5,a,\":\"); print a[length(a)]}'' | sort -n | uniq | paste -sd, -)\n\nTOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk ''{printf \"{\\\"pid\\\":%s,\\\"cmd\\\":\\\"%s\\\",\\\"cpu\\\":%s},\", $1, $2, $3}'')\nTOP_PROCESSES=\"[${TOP_PROCESSES%,}]\"\n\ncat <<JSON > ${STATUS_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"hostname\": \"${HOSTNAME}\",\n  \"ip_address\": \"${IP_ADDR}\",\n  \"load_average\": \"${LOAD_AVG}\",\n  \"memory\": {\n    \"total_kb\": ${MEM_TOTAL},\n    \"available_kb\": ${MEM_AVAILABLE}\n  },\n  \"disk\": {\n    \"total_bytes\": ${DISK_TOTAL},\n    \"used_bytes\": ${DISK_USED},\n    \"available_bytes\": ${DISK_AVAIL}\n  },\n  \"network\": {\n    \"interface\": \"${IFACE}\",\n    \"rx_bytes\": ${RX_BYTES},\n    \"tx_bytes\": ${TX_BYTES}\n  },\n  \"open_ports\": [${OPEN_PORTS}],\n  \"top_processes\": ${TOP_PROCESSES}\n}\nJSON\nEOS\n\nchmod +x ${STATUS_SCRIPT_PATH}","entity_type":"template","entity_id":26},"query":{}}', '2025-08-12 15:26:01.769+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2183, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-13 03:18:08.85+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2184, 1, 'login', '{"user_id":1}', '2025-08-13 03:18:09.318+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2189, 1, 'GET /auth/me', '{"query":{}}', '2025-08-13 03:31:02.654+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2191, 1, 'GET /settings/account', '{"query":{}}', '2025-08-13 03:34:06.996+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2152, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\nset -euo pipefail\n\n# === Variables substituées par le moteur de template ===\nSCRIPT_PATH=\"${SCRIPT_PATH}\"\nSTATUS_SCRIPT_PATH=\"${STATUS_SCRIPT_PATH}\"\nSERVICES_SCRIPT_PATH=\"${SERVICES_SCRIPT_PATH}\"\nSTATUS_CRON_EXPR=''${STATUS_CRON_EXPR}''\nSERVICES_CRON_EXPR=''${SERVICES_CRON_EXPR}''\nCRON_USER=''${CRON_USER}''\n\nMONITOR_DIR=\"$(dirname \"${STATUS_SCRIPT_PATH}\")\"\nMARK_BOOT=\"# MONITORING_CRON\"\nMARK_STATUS=\"# MONITORING_STATUS_CRON\"\nMARK_SERVICES=\"# MONITORING_SERVICES_CRON\"\n\nmkdir -p \"${MONITOR_DIR}\"\n\n# --- Génère le script  ---\ncat > \"${SCRIPT_PATH}\" <<''EOS''\n#!/bin/bash\nset -euo pipefail\n\nSTATUS_SCRIPT_PATH=\"__STATUS_SCRIPT_PATH__\"\nSERVICES_SCRIPT_PATH=\"__SERVICES_SCRIPT_PATH__\"\nSTATUS_CRON_EXPR=''__STATUS_CRON_EXPR__''\nSERVICES_CRON_EXPR=''__SERVICES_CRON_EXPR__''\nCRON_USER=''__CRON_USER__''\nMARK_BOOT=\"# MONITORING_CRON\"\nMARK_STATUS=\"# MONITORING_STATUS_CRON\"\nMARK_SERVICES=\"# MONITORING_SERVICES_CRON\"\n\nexists_and_exec() {\n  local f=\"$1\"\n  [[ -f \"$f\" ]] || return 1\n  [[ -x \"$f\" ]] || chmod +x \"$f\" || true\n  return 0\n}\n\ncrontab_get() { crontab -u \"$CRON_USER\" -l 2>/dev/null || true; }\ncrontab_set() { crontab -u \"$CRON_USER\" -; }\n\nadd_cron_once() {\n  local expr=\"$1\" cmd=\"$2\" mark=\"$3\"\n  local current\n  current=\"$(crontab_get)\"\n  if ! echo \"$current\" | grep -Fq \"$mark\"; then\n    { echo \"$current\" | grep -Fv \"$mark\"; echo \"$expr $cmd $mark\"; } | crontab_set\n  fi\n}\n\nremove_mark() {\n  local mark=\"$1\"\n  crontab_get | grep -Fv \"$mark\" | crontab_set\n}\n\nok=1\nif exists_and_exec \"$STATUS_SCRIPT_PATH\"; then\n  add_cron_once \"$STATUS_CRON_EXPR\" \"bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1\" \"$MARK_STATUS\"\nelse\n  ok=0\nfi\n\nif exists_and_exec \"$SERVICES_SCRIPT_PATH\"; then\n  add_cron_once \"$SERVICES_CRON_EXPR\" \"bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1\" \"$MARK_SERVICES\"\nelse\n  ok=0\nfi\n\nif [[ \"$ok\" -eq 1 ]]; then\n  # Exécuter une première fois pour générer les JSON immédiatement\n  bash \"$STATUS_SCRIPT_PATH\" || true\n  bash \"$SERVICES_SCRIPT_PATH\" || true\n  # Se retirer du crontab\n  remove_mark \"$MARK_BOOT\"\nfi\nEOS\n\n# Injecte les variables réelles dans le \nsed -i \\\n  -e \"s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\\//\\\\/}#g\" \\\n  -e \"s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\\//\\\\/}#g\" \\\n  -e \"s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\\//\\\\/}#g\" \\\n  -e \"s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\\//\\\\/}#g\" \\\n  -e \"s#__CRON_USER__#${CRON_USER}#g\" \\\n  \"${SCRIPT_PATH}\"\n\nchmod +x \"${SCRIPT_PATH}\"\n\n# --- (Ré)active le service cron/ crond ---\nif command -v systemctl >/dev/null 2>&1; then\n  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true\nfi\n\n# --- Installe le cron  (toutes les minutes) ---\ncurrent_cron=\"$(crontab -u \"${CRON_USER}\" -l 2>/dev/null || true)\"\nif ! echo \"$current_cron\" | grep -Fq \"$MARK_BOOT\"; then\n  { echo \"$current_cron\" | grep -Fv \"$MARK_BOOT\"; echo \"* * * * * ${SCRIPT_PATH} $MARK_BOOT\"; } | crontab -u \"${CRON_USER}\" -\nfi\n\nexit 0\n","entity_type":"template","entity_id":25},"query":{}}', '2025-08-12 15:27:33.836+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2153, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:28:09.553+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2154, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:30:53.133+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2155, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:30:55.771+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2156, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:30:57.749+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2157, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:31:05.78+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2158, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:31:24.199+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2159, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:31:24.283+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2160, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:32:34.01+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2161, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-12 15:32:34.092+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2162, 1, 'POST /templates/analyze', '{"body":{"script":"#!/bin/bash\n\n# 📁 Créer le dossier de monitoring s’il n’existe pas\nmkdir -p /opt/monitoring\n\n# 📦 Créer le script de surveillance des services\ncat <<''EOS'' > ${SERVICES_SCRIPT_PATH}\n#!/bin/bash\n\n# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent\nif [ -f /etc/instance-info.conf ]; then\n  source /etc/instance-info.conf\nfi\n\nTIMESTAMP=$(date -Iseconds)\nINSTANCE_ID=\"${INSTANCE_ID:-undefined}\"\n\nSERVICES=(\n  sshd ufw fail2ban cron crond nginx apache2 mysql\n  mariadb postgresql docker kubelet redis-server\n  mongod vsftpd proftpd php-fpm\n)\n\nSERVICE_STATUS_JSON=\"\"\nfor svc in \"${SERVICES[@]}\"; do\n  if systemctl list-units --type=service --all | grep -q \"$svc\"; then\n    ACTIVE=$(systemctl is-active \"$svc\" 2>/dev/null)\n    ENABLED=$(systemctl is-enabled \"$svc\" 2>/dev/null)\n    SERVICE_STATUS_JSON+=\"{\\\"name\\\":\\\"$svc\\\",\\\"active\\\":\\\"$ACTIVE\\\",\\\"enabled\\\":\\\"$ENABLED\\\"},\"\n  fi\ndone\n\nSERVICE_STATUS_JSON=\"[${SERVICE_STATUS_JSON%,}]\"\n\ncat <<JSON > ${SERVICES_JSON_PATH}\n{\n  \"timestamp\": \"${TIMESTAMP}\",\n  \"instance_id\": \"${INSTANCE_ID}\",\n  \"services\": ${SERVICE_STATUS_JSON}\n}\nJSON\nEOS\n\nchmod +x ${SERVICES_SCRIPT_PATH}","entity_type":"template","entity_id":27},"query":{}}', '2025-08-12 15:32:42.441+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2163, 1, 'GET /vms', '{"query":{}}', '2025-08-12 15:33:07.089+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2164, 1, 'list_vms', '{}', '2025-08-12 15:33:07.35+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2165, 1, 'GET /vms', '{"query":{}}', '2025-08-12 15:33:07.429+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2166, 1, 'list_vms', '{}', '2025-08-12 15:33:07.453+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2185, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-13 03:25:06.892+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2186, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-13 03:25:15.313+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2167, 1, 'Échec Déploiement Terraform', '{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l''hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}', '2025-08-12 15:38:33.423+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2168, 1, 'GET /vms', '{"query":{}}', '2025-08-12 15:53:23.948+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2169, 1, 'list_vms', '{}', '2025-08-12 15:53:24.066+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2170, 1, 'GET /vms', '{"query":{}}', '2025-08-12 15:53:24.125+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2171, 1, 'list_vms', '{}', '2025-08-12 15:53:24.146+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2172, 1, 'Échec Déploiement Terraform', '{"code":"SSH_HOST_MISSING","message":"Impossible de copier les scripts : l''hôte SSH est vide (IP non détectée). Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez."}', '2025-08-12 15:57:24.188+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2173, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-13 02:40:19.648+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2174, 1, 'login', '{"user_id":1}', '2025-08-13 02:40:19.77+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2175, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-13 02:46:43.358+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2176, 1, 'login', '{"user_id":1}', '2025-08-13 02:46:43.527+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2177, 1, 'GET /dashboard', '{"query":{}}', '2025-08-13 02:46:46.47+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2178, 1, 'GET /vms', '{"query":{}}', '2025-08-13 02:46:46.472+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2179, 1, 'list_vms', '{}', '2025-08-13 02:46:46.573+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2180, 1, 'GET /vms', '{"query":{}}', '2025-08-13 02:46:46.647+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2181, 1, 'GET /dashboard', '{"query":{}}', '2025-08-13 02:46:46.712+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2182, 1, 'list_vms', '{}', '2025-08-13 02:46:46.755+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2187, NULL, 'POST /auth/login', '{"body":{"email":"latifnjimoluh@gmail.com","password":"admin123."},"query":{}}', '2025-08-13 03:26:48.208+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2188, 1, 'login', '{"user_id":1}', '2025-08-13 03:26:48.712+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2190, 1, 'GET /settings/account', '{"query":{}}', '2025-08-13 03:31:17.545+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2192, 1, 'GET /settings/me', '{"query":{}}', '2025-08-13 03:34:21.183+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2193, 1, 'GET /vms/storages', '{"query":{}}', '2025-08-13 03:34:21.837+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2194, 1, 'GET /settings/me', '{"query":{}}', '2025-08-13 03:34:32.577+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2195, 1, 'GET /vms/nodes', '{"query":{}}', '2025-08-13 03:34:32.882+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2196, 1, 'GET /settings/me', '{"query":{}}', '2025-08-13 03:35:07.638+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2197, 1, 'GET /vms/nodes', '{"query":{}}', '2025-08-13 03:35:07.654+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2198, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-13 03:35:19.469+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2199, 1, 'GET /terminal/vms?onlyConnectable=false', '{"query":{"onlyConnectable":"false"}}', '2025-08-13 03:35:38.821+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2200, 1, 'GET /logs?page=1&pageSize=10', '{"query":{"page":"1","pageSize":"10"}}', '2025-08-13 03:35:42.845+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2202, 1, 'GET /users', '{"query":{}}', '2025-08-13 03:35:47.947+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2203, 1, 'GET /roles', '{"query":{}}', '2025-08-13 03:35:51.587+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2204, 1, 'GET /permissions?page=1&limit=100', '{"query":{"page":"1","limit":"100"}}', '2025-08-13 03:35:59.742+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2205, 1, 'GET /roles', '{"query":{}}', '2025-08-13 03:36:00.166+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2206, 1, 'GET /permissions/role/3', '{"query":{}}', '2025-08-13 03:36:01.06+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2207, 1, 'GET /permissions/role/1', '{"query":{}}', '2025-08-13 03:36:01.117+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2208, 1, 'GET /permissions/role/2', '{"query":{}}', '2025-08-13 03:36:01.121+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2209, 1, 'GET /templates?status=actif', '{"query":{"status":"actif"}}', '2025-08-13 03:36:07.289+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2210, 1, 'GET /vms', '{"query":{}}', '2025-08-13 03:36:10.608+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2211, 1, 'GET /dashboard', '{"query":{}}', '2025-08-13 03:37:26.993+00');
INSERT INTO "public"."logs" ("id", "user_id", "action", "details", "created_at") VALUES (2212, 1, 'GET /vms', '{"query":{}}', '2025-08-13 03:37:46.96+00');


--
-- TOC entry 3563 (class 0 OID 17241)
-- Dependencies: 234
-- Data for Name: monitored_services; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."monitored_services" ("id", "name", "script_path", "description", "created_at", "updated_at") VALUES (1, 'Nginx Provisioning', 'scripts/service.sh', 'Configure Nginx and record service states', '2025-08-06 03:39:32.364024+00', '2025-08-06 03:39:32.364024+00');


--
-- TOC entry 3565 (class 0 OID 17249)
-- Dependencies: 236
-- Data for Name: monitoring_scripts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."monitoring_scripts" ("id", "name", "script_path", "description", "created_at", "updated_at") VALUES (1, 'System Metrics Monitor', 'scripts/monitor.sh', 'Collect CPU, memory, disk and network metrics', '2025-08-06 03:39:32.356362+00', '2025-08-06 03:39:32.356362+00');


--
-- TOC entry 3567 (class 0 OID 17257)
-- Dependencies: 238
-- Data for Name: monitorings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."monitorings" ("id", "vm_ip", "ip_address", "instance_id", "services_status", "system_status", "retrieved_at", "created_at", "updated_at") VALUES (8, '192.168.24.130', '192.168.24.130', 'c06d59eb-a650-4427-ba92-05b107a6fd81', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}', '2025-08-11 09:18:06.38+00', '2025-08-11 09:18:06.38+00', '2025-08-11 09:18:06.38+00');
INSERT INTO "public"."monitorings" ("id", "vm_ip", "ip_address", "instance_id", "services_status", "system_status", "retrieved_at", "created_at", "updated_at") VALUES (2, '192.168.24.91', '192.168.24.91', 'b10d3830-d27e-4cee-8166-4d36c27f8166', '{"sshd":"active","ufw":"active","fail2ban":"inactive\nabsent","cron":"active","crond":"inactive\nabsent","nginx":"inactive\nabsent","apache2":"inactive\nabsent","mysql":"inactive\nabsent","mariadb":"inactive\nabsent","postgresql":"inactive\nabsent","docker":"inactive\nabsent","kubelet":"inactive\nabsent","redis-server":"inactive\nabsent","mongod":"inactive\nabsent","vsftpd":"inactive\nabsent","proftpd":"inactive\nabsent","php-fpm":"inactive\nabsent","timestamp":"2025-08-06T10:22:58+00:00","instance_id":"b10d3830-d27e-4cee-8166-4d36c27f8166"}', '{"timestamp":"2025-08-06T10:22:58+00:00","instance_id":"b10d3830-d27e-4cee-8166-4d36c27f8166","hostname":"test","ip_address":"192.168.24.91","load_average":"1.17, 0.26, 0.09","memory":{"total_kb":2010676,"available_kb":1654228},"disk":{"total_bytes":10464022528,"used_bytes":5181259776,"available_bytes":4729114624},"network":{"interface":"eth0","rx_bytes":362655,"tx_bytes":43765},"open_ports":[22,53,68],"top_processes":[]}', '2025-08-06 10:29:25.757+00', '2025-08-06 10:29:25.758+00', '2025-08-06 10:29:25.758+00');
INSERT INTO "public"."monitorings" ("id", "vm_ip", "ip_address", "instance_id", "services_status", "system_status", "retrieved_at", "created_at", "updated_at") VALUES (3, '192.168.24.94', '192.168.24.94', '505bb44b-f327-47f7-a2d2-5fb231456c2f', '{"timestamp":"2025-08-06T11:20:01+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}', '{"timestamp":"2025-08-06T11:20:01+00:00","instance_id":"undefined","hostname":"test1","ip_address":"192.168.24.94","load_average":"0.58 0.20 0.07","memory":{"total_kb":2010676,"available_kb":1670152},"disk":{"total_bytes":10464022528,"used_bytes":5183983616,"available_bytes":4726390784},"network":{"interface":"eth0","rx_bytes":2895596,"tx_bytes":118169},"open_ports":[22,53,68],"top_processes":[{"pid":1,"cmd":"systemd","cpu":5.5},{"pid":752,"cmd":"snapd","cpu":5.1},{"pid":1303,"cmd":"systemd","cpu":2.7},{"pid":9,"cmd":"kworker/u4:0-ev","cpu":1.7},{"pid":427,"cmd":"systemd-journal","cpu":0.9}]}', '2025-08-06 11:22:47.44+00', '2025-08-06 11:22:47.442+00', '2025-08-06 11:22:47.442+00');
INSERT INTO "public"."monitorings" ("id", "vm_ip", "ip_address", "instance_id", "services_status", "system_status", "retrieved_at", "created_at", "updated_at") VALUES (4, '192.168.24.202', '192.168.24.202', '505bb44b-f327-47f7-a2d2-5fb231456c2f', '{"timestamp":"2025-08-07T03:55:30+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"},{"name":"nginx","active":"active","enabled":"enabled"},{"name":"apache2","active":"failed","enabled":"enabled"}]}', '{"timestamp":"2025-08-07T03:55:15+00:00","instance_id":"undefined","hostname":"Webapache","ip_address":"192.168.24.202","load_average":"0.01 0.02 0.00","memory":{"total_kb":2010676,"available_kb":1590624},"disk":{"total_bytes":10464022528,"used_bytes":6119256064,"available_bytes":3791118336},"network":{"interface":"eth0","rx_bytes":347193895,"tx_bytes":4059300},"open_ports":[22,53,68,80],"top_processes":[{"pid":747,"cmd":"qemu-ga","cpu":0.1},{"pid":19095,"cmd":"kworker/0:2-eve","cpu":0.1},{"pid":19251,"cmd":"kworker/1:2-eve","cpu":0.1},{"pid":1,"cmd":"systemd","cpu":0},{"pid":2,"cmd":"kthreadd","cpu":0}]}', '2025-08-07 03:55:39.75+00', '2025-08-07 03:55:39.751+00', '2025-08-07 03:55:39.751+00');
INSERT INTO "public"."monitorings" ("id", "vm_ip", "ip_address", "instance_id", "services_status", "system_status", "retrieved_at", "created_at", "updated_at") VALUES (5, '192.168.24.130', '192.168.24.130', 'c06d59eb-a650-4427-ba92-05b107a6fd81', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}', '2025-08-10 21:01:33.247+00', '2025-08-10 21:01:33.249+00', '2025-08-10 21:01:33.249+00');
INSERT INTO "public"."monitorings" ("id", "vm_ip", "ip_address", "instance_id", "services_status", "system_status", "retrieved_at", "created_at", "updated_at") VALUES (6, '192.168.24.130', '192.168.24.130', 'c06d59eb-a650-4427-ba92-05b107a6fd81', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}', '2025-08-10 21:06:07.022+00', '2025-08-10 21:06:07.022+00', '2025-08-10 21:06:07.022+00');
INSERT INTO "public"."monitorings" ("id", "vm_ip", "ip_address", "instance_id", "services_status", "system_status", "retrieved_at", "created_at", "updated_at") VALUES (7, '192.168.24.130', '192.168.24.130', 'c06d59eb-a650-4427-ba92-05b107a6fd81', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","services":[{"name":"sshd","active":"active","enabled":"alias"},{"name":"ufw","active":"active","enabled":"enabled"},{"name":"cron","active":"active","enabled":"enabled"}]}', '{"timestamp":"2025-08-10T19:51:55+00:00","instance_id":"undefined","hostname":"monitoring","ip_address":"192.168.24.130","load_average":"0.56 0.60 0.28","memory":{"total_kb":2010676,"available_kb":1613768},"disk":{"total_bytes":10464022528,"used_bytes":6222831616,"available_bytes":3687542784},"network":{"interface":"eth0","rx_bytes":333176473,"tx_bytes":1903783},"open_ports":[22,53],"top_processes":[{"pid":16162,"cmd":"snapd","cpu":2.9},{"pid":1,"cmd":"systemd","cpu":1.6},{"pid":7,"cmd":"kworker/0:0-eve","cpu":0.3},{"pid":491,"cmd":"kworker/1:3-ino","cpu":0.2},{"pid":12266,"cmd":"kworker/1:51-ev","cpu":0.2}]}', '2025-08-10 21:36:20.124+00', '2025-08-10 21:36:20.126+00', '2025-08-10 21:36:20.126+00');


--
-- TOC entry 3569 (class 0 OID 17266)
-- Dependencies: 240
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (1, 'auth.reset-history', 'View password reset history', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (2, 'deployment.run', 'Run deployments', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (3, 'log.list', 'List logs', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (4, 'permission.assign', 'Assign permission to roles', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (5, 'permission.byRole', 'List permissions by role', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (6, 'permission.create', 'Create permission', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (7, 'permission.delete', 'Delete permission', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (8, 'permission.list', 'List permissions', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (9, 'permission.read', 'Read permission', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (10, 'permission.unassign', 'Unassign permission from role', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (11, 'permission.update', 'Update permission', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (12, 'role.create', 'Create role', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (13, 'role.delete', 'Delete role', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (14, 'role.list', 'List roles', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (15, 'role.read', 'Read role', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (16, 'role.update', 'Update role', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (17, 'settings.create', 'Create settings', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (18, 'settings.get', 'Get settings', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (19, 'settings.list', 'List settings', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (20, 'settings.update', 'Update settings', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (21, 'template.create', 'Create template', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (22, 'template.delete', 'Delete template', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (23, 'template.generate', 'Generate template script', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (24, 'template.list', 'List templates', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (25, 'template.read', 'Read template', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (26, 'template.update', 'Update template', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (27, 'user.create', 'Create user', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (28, 'user.delete', 'Delete user', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (29, 'user.list', 'List users', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (30, 'user.read', 'Read user', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (31, 'user.search', 'Search users', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (32, 'user.update', 'Update user', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (33, 'monitoring.collect', 'Collect monitoring data', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (34, 'monitoring.list', 'List monitoring records', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (35, 'monitoring.read', 'Read monitoring record', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (36, 'monitoring.sync', 'Synchronize deployment IP', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (37, 'vm.conversion.list', 'List VM conversions', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (38, 'vm.convert', 'Convert VM to template', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (39, 'vm.list', 'List VMs', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (40, 'vm.start', 'Start VM', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (41, 'vm.status.check', 'Check VM status', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (42, 'vm.stop', 'Stop VM', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (43, 'vm.delete', 'Delete VM', 'actif', '2025-08-06 03:39:32.311509+00', '2025-08-06 03:39:32.311509+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (44, 'test', 'test posts', 'inactif', '2025-08-06 03:45:33.679+00', '2025-08-06 03:47:55.721+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (45, 'script.analyze', 'Analyser un script avec l’IA', 'actif', '2025-08-06 14:31:31.112+00', '2025-08-06 14:31:31.112+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (46, 'script.read', 'Lire les analyses de script IA', 'actif', '2025-08-06 14:32:09.156+00', '2025-08-06 14:32:09.156+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (47, 'template.analyze', 'Analyse du template', 'actif', '2025-08-06 14:37:58.485+00', '2025-08-06 14:37:58.485+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (48, 'template.audit', 'Auditer un script avec IA avant déploiement', 'actif', '2025-08-06 16:05:38.346+00', '2025-08-06 16:13:34.219+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (49, 'template.explain', 'Explain script using AI', 'actif', '2025-08-06 16:49:12.831+00', '2025-08-06 16:49:12.831+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (50, 'template.explainVariables', 'Explain template variables using AI', 'actif', '2025-08-06 16:49:12.84+00', '2025-08-06 16:49:12.84+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (51, 'template.summarizeLogs', 'Summarize deployment logs using AI', 'actif', '2025-08-06 16:49:12.844+00', '2025-08-06 16:49:12.844+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (52, 'template.suggestBundle', 'Suggest stack bundles using AI', 'actif', '2025-08-06 16:49:12.848+00', '2025-08-06 16:49:12.848+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (53, 'template.simulateExecution', 'Simulate script execution using AI', 'actif', '2025-08-06 16:49:12.851+00', '2025-08-06 16:49:12.851+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (54, 'aiCache.list', 'Liste des requete deja recu', 'actif', '2025-08-07 03:59:05.047+00', '2025-08-07 03:59:05.047+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (55, 'dashboard.view', 'View dashboard data', 'actif', '2025-08-07 06:02:52.51+00', '2025-08-07 06:02:52.51+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (56, 'alert.list', 'List alerts', 'actif', '2025-08-07 06:02:52.515+00', '2025-08-07 06:02:52.515+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (57, 'alert.update', 'Update alert', 'actif', '2025-08-07 06:02:52.519+00', '2025-08-07 06:02:52.519+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (58, 'servers.view', 'View servers', 'actif', '2025-08-07 06:02:52.522+00', '2025-08-07 06:02:52.522+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (59, 'servers.add', 'Add server', 'actif', '2025-08-07 06:02:52.525+00', '2025-08-07 06:02:52.525+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (60, 'servers.edit', 'Edit server', 'actif', '2025-08-07 06:02:52.529+00', '2025-08-07 06:02:52.529+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (61, 'servers.delete', 'Delete server', 'actif', '2025-08-07 06:02:52.533+00', '2025-08-07 06:02:52.533+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (62, 'test.analyse', 'testdanalyse', 'actif', '2025-08-09 17:59:15.74+00', '2025-08-09 17:59:15.74+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (63, 'script.servicetypes', 'Script type', 'actif', '2025-08-12 11:54:10.55+00', '2025-08-12 11:54:10.55+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (64, 'script.list', 'script.list', 'actif', '2025-08-12 11:56:36.341+00', '2025-08-12 11:56:36.341+00');
INSERT INTO "public"."permissions" ("id", "name", "description", "status", "created_at", "updated_at") VALUES (65, 'template.restore', 'template.restore', 'actif', '2025-08-12 12:15:51.899+00', '2025-08-12 12:15:51.899+00');


--
-- TOC entry 3571 (class 0 OID 17275)
-- Dependencies: 242
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."roles" ("id", "name", "status", "created_at", "updated_at", "description") VALUES (1, 'superadmin', 'actif', '2025-08-06 03:39:32.272046+00', '2025-08-07 03:03:15.738+00', '');
INSERT INTO "public"."roles" ("id", "name", "status", "created_at", "updated_at", "description") VALUES (2, 'admin', 'actif', '2025-08-07 03:03:15.448+00', '2025-08-07 03:48:21.141+00', '');
INSERT INTO "public"."roles" ("id", "name", "status", "created_at", "updated_at", "description") VALUES (3, 'gdgdhd', 'actif', '2025-08-09 16:36:35.914+00', '2025-08-09 16:52:11.845+00', '');


--
-- TOC entry 3573 (class 0 OID 17282)
-- Dependencies: 244
-- Data for Name: service_templates; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."service_templates" ("id", "name", "service_type", "category", "description", "template_content", "script_path", "fields_schema", "status", "created_at", "updated_at", "abs_path", "deleted_at") VALUES (25, 'Cron des scripts de monitoring', 'monitoring__cron', 'monitoring', 'Installe un cron job minuteur qui attend la présence des scripts de monitoring, les exécute, crée leurs crons définitifs puis se désinstalle.', '#!/bin/bash
set -euo pipefail

# === Variables substituées par le moteur de template ===
SCRIPT_PATH="${SCRIPT_PATH}"
STATUS_SCRIPT_PATH="${STATUS_SCRIPT_PATH}"
SERVICES_SCRIPT_PATH="${SERVICES_SCRIPT_PATH}"
STATUS_CRON_EXPR=''${STATUS_CRON_EXPR}''
SERVICES_CRON_EXPR=''${SERVICES_CRON_EXPR}''
CRON_USER=''${CRON_USER}''

MONITOR_DIR="$(dirname "${STATUS_SCRIPT_PATH}")"
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

mkdir -p "${MONITOR_DIR}"

# --- Génère le script  ---
cat > "${SCRIPT_PATH}" <<''EOS''
#!/bin/bash
set -euo pipefail

STATUS_SCRIPT_PATH="__STATUS_SCRIPT_PATH__"
SERVICES_SCRIPT_PATH="__SERVICES_SCRIPT_PATH__"
STATUS_CRON_EXPR=''__STATUS_CRON_EXPR__''
SERVICES_CRON_EXPR=''__SERVICES_CRON_EXPR__''
CRON_USER=''__CRON_USER__''
MARK_BOOT="# MONITORING_CRON"
MARK_STATUS="# MONITORING_STATUS_CRON"
MARK_SERVICES="# MONITORING_SERVICES_CRON"

exists_and_exec() {
  local f="$1"
  [[ -f "$f" ]] || return 1
  [[ -x "$f" ]] || chmod +x "$f" || true
  return 0
}

crontab_get() { crontab -u "$CRON_USER" -l 2>/dev/null || true; }
crontab_set() { crontab -u "$CRON_USER" -; }

add_cron_once() {
  local expr="$1" cmd="$2" mark="$3"
  local current
  current="$(crontab_get)"
  if ! echo "$current" | grep -Fq "$mark"; then
    { echo "$current" | grep -Fv "$mark"; echo "$expr $cmd $mark"; } | crontab_set
  fi
}

remove_mark() {
  local mark="$1"
  crontab_get | grep -Fv "$mark" | crontab_set
}

ok=1
if exists_and_exec "$STATUS_SCRIPT_PATH"; then
  add_cron_once "$STATUS_CRON_EXPR" "bash $STATUS_SCRIPT_PATH >/opt/monitoring/status.log 2>&1" "$MARK_STATUS"
else
  ok=0
fi

if exists_and_exec "$SERVICES_SCRIPT_PATH"; then
  add_cron_once "$SERVICES_CRON_EXPR" "bash $SERVICES_SCRIPT_PATH >/opt/monitoring/services_status.log 2>&1" "$MARK_SERVICES"
else
  ok=0
fi

if [[ "$ok" -eq 1 ]]; then
  # Exécuter une première fois pour générer les JSON immédiatement
  bash "$STATUS_SCRIPT_PATH" || true
  bash "$SERVICES_SCRIPT_PATH" || true
  # Se retirer du crontab
  remove_mark "$MARK_BOOT"
fi
EOS

# Injecte les variables réelles dans le 
sed -i \
  -e "s#__STATUS_SCRIPT_PATH__#${STATUS_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__SERVICES_SCRIPT_PATH__#${SERVICES_SCRIPT_PATH//\//\\/}#g" \
  -e "s#__STATUS_CRON_EXPR__#${STATUS_CRON_EXPR//\//\\/}#g" \
  -e "s#__SERVICES_CRON_EXPR__#${SERVICES_CRON_EXPR//\//\\/}#g" \
  -e "s#__CRON_USER__#${CRON_USER}#g" \
  "${SCRIPT_PATH}"

chmod +x "${SCRIPT_PATH}"

# --- (Ré)active le service cron/ crond ---
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable --now cron 2>/dev/null || systemctl enable --now crond 2>/dev/null || true
fi

# --- Installe le cron  (toutes les minutes) ---
current_cron="$(crontab -u "${CRON_USER}" -l 2>/dev/null || true)"
if ! echo "$current_cron" | grep -Fq "$MARK_BOOT"; then
  { echo "$current_cron" | grep -Fv "$MARK_BOOT"; echo "* * * * * ${SCRIPT_PATH} $MARK_BOOT"; } | crontab -u "${CRON_USER}" -
fi

exit 0
', '/scripts/templates/monitoring/monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_tpl001.sh', '{"fields":[{"name":"SCRIPT_PATH","label":"Chemin du script ","type":"text","required":true,"default":"/opt/monitoring/monitoring.sh"},{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script status","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script services","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"STATUS_CRON_EXPR","label":"Cron du script status","type":"text","required":true,"default":"*/1 * * * *"},{"name":"SERVICES_CRON_EXPR","label":"Cron du script services","type":"text","required":true,"default":"*/1 * * * *"},{"name":"CRON_USER","label":"Utilisateur cron","type":"text","required":true,"default":"root"}]}', 'actif', '2025-08-12 04:36:17.479+00', '2025-08-12 04:36:17.479+00', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\scripts\templates\monitoring\monitoring__cron_monitoring_Cron_des_scripts_de_monitoring_tpl001.sh', NULL);
INSERT INTO "public"."service_templates" ("id", "name", "service_type", "category", "description", "template_content", "script_path", "fields_schema", "status", "created_at", "updated_at", "abs_path", "deleted_at") VALUES (26, 'Surveillance système - Génération du script', 'system_monitoring_script', 'monitoring', 'Crée le script de supervision système (CPU, RAM, disque, réseau, ports, processus) dans /opt/monitoring/status.sh', '#!/bin/bash

# 📁 Créer le dossier de monitoring s’il n’existe pas
mkdir -p /opt/monitoring

# 📦 Créer le script de surveillance système
cat <<''EOS'' > ${STATUS_SCRIPT_PATH}
#!/bin/bash

# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent
if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"
HOSTNAME=$(hostname)
IP_ADDR=$(hostname -I | awk ''{print $1}'')
LOAD_AVG=$(cut -d '' '' -f1-3 /proc/loadavg)
MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk ''{print $2}'')
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk ''{print $2}'')

DISK_TOTAL=$(df -B1 / | tail -1 | awk ''{print $2}'')
DISK_USED=$(df -B1 / | tail -1 | awk ''{print $3}'')
DISK_AVAIL=$(df -B1 / | tail -1 | awk ''{print $4}'')

IFACE=$(ip route get 1.1.1.1 | awk ''{print $5; exit}'')
RX_BYTES=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_BYTES=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

OPEN_PORTS=$(ss -tuln | awk ''NR>1 {split($5,a,":"); print a[length(a)]}'' | sort -n | uniq | paste -sd, -)

TOP_PROCESSES=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk ''{printf "{\"pid\":%s,\"cmd\":\"%s\",\"cpu\":%s},", $1, $2, $3}'')
TOP_PROCESSES="[${TOP_PROCESSES%,}]"

cat <<JSON > ${STATUS_JSON_PATH}
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "hostname": "${HOSTNAME}",
  "ip_address": "${IP_ADDR}",
  "load_average": "${LOAD_AVG}",
  "memory": {
    "total_kb": ${MEM_TOTAL},
    "available_kb": ${MEM_AVAILABLE}
  },
  "disk": {
    "total_bytes": ${DISK_TOTAL},
    "used_bytes": ${DISK_USED},
    "available_bytes": ${DISK_AVAIL}
  },
  "network": {
    "interface": "${IFACE}",
    "rx_bytes": ${RX_BYTES},
    "tx_bytes": ${TX_BYTES}
  },
  "open_ports": [${OPEN_PORTS}],
  "top_processes": ${TOP_PROCESSES}
}
JSON
EOS

chmod +x ${STATUS_SCRIPT_PATH}', '/scripts/templates/monitoring/system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_tpl002.sh', '{"fields":[{"name":"STATUS_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/status.sh"},{"name":"STATUS_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/status.json"}]}', 'actif', '2025-08-12 04:36:50.551+00', '2025-08-12 04:36:50.551+00', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\scripts\templates\monitoring\system_monitoring_script_monitoring_Surveillance_systeme_-_Generation_du_script_tpl002.sh', NULL);
INSERT INTO "public"."service_templates" ("id", "name", "service_type", "category", "description", "template_content", "script_path", "fields_schema", "status", "created_at", "updated_at", "abs_path", "deleted_at") VALUES (27, 'Surveillance des services - Génération du script', 'service_monitoring_script', 'monitoring', 'Crée le script de supervision des services critiques dans /opt/monitoring/services_status.sh', '#!/bin/bash

# 📁 Créer le dossier de monitoring s’il n’existe pas
mkdir -p /opt/monitoring

# 📦 Créer le script de surveillance des services
cat <<''EOS'' > ${SERVICES_SCRIPT_PATH}
#!/bin/bash

# 🔐 Charger l''INSTANCE_ID depuis /etc/instance-info.conf si présent
if [ -f /etc/instance-info.conf ]; then
  source /etc/instance-info.conf
fi

TIMESTAMP=$(date -Iseconds)
INSTANCE_ID="${INSTANCE_ID:-undefined}"

SERVICES=(
  sshd ufw fail2ban cron crond nginx apache2 mysql
  mariadb postgresql docker kubelet redis-server
  mongod vsftpd proftpd php-fpm
)

SERVICE_STATUS_JSON=""
for svc in "${SERVICES[@]}"; do
  if systemctl list-units --type=service --all | grep -q "$svc"; then
    ACTIVE=$(systemctl is-active "$svc" 2>/dev/null)
    ENABLED=$(systemctl is-enabled "$svc" 2>/dev/null)
    SERVICE_STATUS_JSON+="{\"name\":\"$svc\",\"active\":\"$ACTIVE\",\"enabled\":\"$ENABLED\"},"
  fi
done

SERVICE_STATUS_JSON="[${SERVICE_STATUS_JSON%,}]"

cat <<JSON > ${SERVICES_JSON_PATH}
{
  "timestamp": "${TIMESTAMP}",
  "instance_id": "${INSTANCE_ID}",
  "services": ${SERVICE_STATUS_JSON}
}
JSON
EOS

chmod +x ${SERVICES_SCRIPT_PATH}', '/scripts/templates/monitoring/service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_tpl002.sh', '{"fields":[{"name":"SERVICES_SCRIPT_PATH","label":"Chemin du script généré","type":"text","required":true,"default":"/opt/monitoring/services_status.sh"},{"name":"SERVICES_JSON_PATH","label":"Chemin du fichier JSON de sortie","type":"text","required":true,"default":"/opt/monitoring/services_status.json"}]}', 'actif', '2025-08-12 04:37:03.501+00', '2025-08-12 14:27:35.314+00', 'D:\Keyce_B3\Soutenance\linusupervisor-back\backend\scripts\templates\monitoring\service_monitoring_script_monitoring_Surveillance_des_services_-_Generation_du_script_tpl002.sh', NULL);


--
-- TOC entry 3575 (class 0 OID 17291)
-- Dependencies: 246
-- Data for Name: user_settings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."user_settings" ("id", "user_id", "cloudinit_user", "cloudinit_password", "proxmox_api_url", "proxmox_api_token_id", "proxmox_api_token_name", "proxmox_api_token_secret", "pm_user", "pm_password", "proxmox_node", "vm_storage", "vm_bridge", "ssh_public_key_path", "ssh_private_key_path", "statuspath", "servicespath", "instanceinfopath", "proxmox_host", "proxmox_ssh_user", "created_at", "updated_at") VALUES (1, 1, 'nexus', 'Nexus2023.', 'https://192.168.24.134:8006/api2/json', 'root@pam', 'delete', '0a804aa8-029e-4503-83a3-3fb51a804771', 'root@pam', 'Nexus2023.', 'pve', 'local-lvm', 'vmbr0', 'C:/Users/Nexus-PC/.ssh/id_rsa.pub', 'C:/Users/Nexus-PC/.ssh/id_rsa', '/opt/monitoring/status.json', '/opt/monitoring/services_status.json', '/etc/instance-info.conf', '192.168.24.134', 'root', '2025-08-06 03:39:32.328273+00', '2025-08-06 11:17:39.951+00');


--
-- TOC entry 3577 (class 0 OID 17299)
-- Dependencies: 248
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."users" ("id", "first_name", "last_name", "email", "phone", "password", "status", "reset_token", "reset_expires_at", "last_password_reset_at", "role_id", "created_at", "updated_at") VALUES (3, 'tes3', 'test', 'res@gmail.com', '55555555555', '$2b$10$I1KNiIl4WYJ9sJKkxIHBie07cLSnSk/fy6IlFLUCIDhB2pefvxUxO', 'active', NULL, NULL, NULL, 2, '2025-08-09 17:54:53.372+00', '2025-08-09 18:03:07.269+00');
INSERT INTO "public"."users" ("id", "first_name", "last_name", "email", "phone", "password", "status", "reset_token", "reset_expires_at", "last_password_reset_at", "role_id", "created_at", "updated_at") VALUES (1, 'Nexus', 'Nexus Latif', 'latifnjimoluh@gmail.com', '555-0100', '$2b$10$/7k8y44BfxY.BBTDrtTNCuxR4jZ0B5oUNHUeBErGFxI.2amWvtb96', 'active', '531825', '2025-08-09 18:16:21.196+00', '2025-08-06 03:41:00.376+00', 1, '2025-08-06 03:39:32.324893+00', '2025-08-09 18:01:21.196+00');


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 218
-- Name: ai_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."ai_cache_id_seq"', 15, true);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 220
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."alerts_id_seq"', 1, false);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 223
-- Name: converted_vms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."converted_vms_id_seq"', 2, true);


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 225
-- Name: deletes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."deletes_id_seq"', 36, true);


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 227
-- Name: deployments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."deployments_id_seq"', 33, true);


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 229
-- Name: generated_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."generated_scripts_id_seq"', 31, true);


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 231
-- Name: initialization_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."initialization_scripts_id_seq"', 1, true);


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 233
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."logs_id_seq"', 2212, true);


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 235
-- Name: monitored_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."monitored_services_id_seq"', 1, true);


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 237
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."monitoring_scripts_id_seq"', 1, true);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 239
-- Name: monitorings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."monitorings_id_seq"', 8, true);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 241
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."permissions_id_seq"', 65, true);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 243
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."roles_id_seq"', 3, true);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 245
-- Name: service_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."service_templates_id_seq"', 27, true);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 247
-- Name: user_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."user_settings_id_seq"', 1, true);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 249
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."users_id_seq"', 3, true);


--
-- TOC entry 3351 (class 2606 OID 17342)
-- Name: ai_cache ai_cache_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ai_cache"
    ADD CONSTRAINT "ai_cache_hash_key" UNIQUE ("hash");


--
-- TOC entry 3353 (class 2606 OID 17344)
-- Name: ai_cache ai_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ai_cache"
    ADD CONSTRAINT "ai_cache_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3355 (class 2606 OID 17346)
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."alerts"
    ADD CONSTRAINT "alerts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3357 (class 2606 OID 17348)
-- Name: assigned_permissions assigned_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."assigned_permissions"
    ADD CONSTRAINT "assigned_permissions_pkey" PRIMARY KEY ("role_id", "permission_id");


--
-- TOC entry 3359 (class 2606 OID 17350)
-- Name: converted_vms converted_vms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."converted_vms"
    ADD CONSTRAINT "converted_vms_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3361 (class 2606 OID 17352)
-- Name: deletes deletes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deletes"
    ADD CONSTRAINT "deletes_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3363 (class 2606 OID 17354)
-- Name: deployments deployments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deployments"
    ADD CONSTRAINT "deployments_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3365 (class 2606 OID 17356)
-- Name: generated_scripts generated_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generated_scripts"
    ADD CONSTRAINT "generated_scripts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3367 (class 2606 OID 17358)
-- Name: initialization_scripts initialization_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."initialization_scripts"
    ADD CONSTRAINT "initialization_scripts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3369 (class 2606 OID 17360)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."logs"
    ADD CONSTRAINT "logs_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3371 (class 2606 OID 17362)
-- Name: monitored_services monitored_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."monitored_services"
    ADD CONSTRAINT "monitored_services_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3373 (class 2606 OID 17364)
-- Name: monitoring_scripts monitoring_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."monitoring_scripts"
    ADD CONSTRAINT "monitoring_scripts_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3375 (class 2606 OID 17366)
-- Name: monitorings monitorings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."monitorings"
    ADD CONSTRAINT "monitorings_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3377 (class 2606 OID 17368)
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."permissions"
    ADD CONSTRAINT "permissions_name_key" UNIQUE ("name");


--
-- TOC entry 3379 (class 2606 OID 17370)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."permissions"
    ADD CONSTRAINT "permissions_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3381 (class 2606 OID 17372)
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_name_key" UNIQUE ("name");


--
-- TOC entry 3383 (class 2606 OID 17374)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3385 (class 2606 OID 17376)
-- Name: service_templates service_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."service_templates"
    ADD CONSTRAINT "service_templates_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3387 (class 2606 OID 17378)
-- Name: user_settings user_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."user_settings"
    ADD CONSTRAINT "user_settings_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3389 (class 2606 OID 17380)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");


--
-- TOC entry 3391 (class 2606 OID 17382)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3392 (class 2606 OID 17383)
-- Name: assigned_permissions assigned_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."assigned_permissions"
    ADD CONSTRAINT "assigned_permissions_permission_id_fkey" FOREIGN KEY ("permission_id") REFERENCES "public"."permissions"("id") ON DELETE CASCADE;


--
-- TOC entry 3393 (class 2606 OID 17388)
-- Name: assigned_permissions assigned_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."assigned_permissions"
    ADD CONSTRAINT "assigned_permissions_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE CASCADE;


--
-- TOC entry 3394 (class 2606 OID 17393)
-- Name: converted_vms converted_vms_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."converted_vms"
    ADD CONSTRAINT "converted_vms_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;


--
-- TOC entry 3395 (class 2606 OID 17398)
-- Name: deletes deletes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deletes"
    ADD CONSTRAINT "deletes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL;


--
-- TOC entry 3396 (class 2606 OID 17403)
-- Name: deployments deployments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deployments"
    ADD CONSTRAINT "deployments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL;


--
-- TOC entry 3397 (class 2606 OID 17408)
-- Name: generated_scripts generated_scripts_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generated_scripts"
    ADD CONSTRAINT "generated_scripts_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "public"."service_templates"("id") ON DELETE CASCADE;


--
-- TOC entry 3398 (class 2606 OID 17413)
-- Name: logs logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."logs"
    ADD CONSTRAINT "logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE SET NULL;


--
-- TOC entry 3399 (class 2606 OID 17418)
-- Name: user_settings user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."user_settings"
    ADD CONSTRAINT "user_settings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;


--
-- TOC entry 3400 (class 2606 OID 17423)
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id");


-- Completed on 2025-08-13 05:06:55

--
-- PostgreSQL database dump complete
--

