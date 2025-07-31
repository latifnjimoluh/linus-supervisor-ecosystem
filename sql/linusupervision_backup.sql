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
-- Name: config_template_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config_template_services (
    id integer NOT NULL,
    service_type character varying(255) NOT NULL,
    config_data jsonb NOT NULL,
    script_path character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.config_template_services OWNER TO postgres;

--
-- Name: config_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    description text,
    template_path character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    category character varying(50) DEFAULT 'configuration'::character varying NOT NULL
);


ALTER TABLE public.config_templates OWNER TO postgres;

--
-- Name: deletes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deletes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    instance_id uuid,
    vm_id integer,
    vm_name character varying(255),
    vm_ip character varying(100),
    log_path text,
    user_id integer,
    user_email character varying(255),
    deleted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.deletes OWNER TO postgres;

--
-- Name: deployments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deployments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    user_email character varying(255) NOT NULL,
    vm_name character varying(100) NOT NULL,
    service_name character varying(100) NOT NULL,
    operation_type character varying(50) NOT NULL,
    started_at timestamp with time zone NOT NULL,
    ended_at timestamp with time zone NOT NULL,
    duration interval,
    success boolean DEFAULT false NOT NULL,
    log_path text,
    vm_id integer,
    vm_ip inet,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    instance_id uuid NOT NULL,
    injected_files jsonb,
    vm_specs jsonb,
    status character varying(20) DEFAULT 'deployed'::character varying
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
-- Name: init_scripts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.init_scripts (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    script_path character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.init_scripts OWNER TO postgres;

--
-- Name: init_scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.init_scripts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.init_scripts_id_seq OWNER TO postgres;

--
-- Name: init_scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.init_scripts_id_seq OWNED BY public.init_scripts.id;


--
-- Name: monitoring_scripts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monitoring_scripts (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    script_path text NOT NULL,
    service_type character varying(50) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
-- Name: monitoring_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monitoring_services (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    config_data jsonb,
    script_path text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.monitoring_services OWNER TO postgres;

--
-- Name: monitoring_services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monitoring_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monitoring_services_id_seq OWNER TO postgres;

--
-- Name: monitoring_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monitoring_services_id_seq OWNED BY public.monitoring_services.id;


--
-- Name: service_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.service_configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.service_configurations_id_seq OWNER TO postgres;

--
-- Name: service_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.service_configurations_id_seq OWNED BY public.config_template_services.id;


--
-- Name: service_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_statuses (
    id uuid NOT NULL,
    hostname character varying(255),
    "timestamp" timestamp with time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    instance_id uuid,
    formatted_data jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE public.service_statuses OWNER TO postgres;

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

ALTER SEQUENCE public.service_templates_id_seq OWNED BY public.config_templates.id;


--
-- Name: status_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_snapshots (
    id uuid NOT NULL,
    instance_id uuid,
    hostname character varying(255),
    "timestamp" timestamp with time zone,
    "createdAt" timestamp with time zone DEFAULT now(),
    "updatedAt" timestamp with time zone DEFAULT now(),
    formatted_data jsonb
);


ALTER TABLE public.status_snapshots OWNER TO postgres;

--
-- Name: user_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_settings (
    id integer NOT NULL,
    user_id integer,
    cloudinit_user text DEFAULT 'nexus'::text,
    cloudinit_password text,
    proxmox_api_url text DEFAULT 'https://192.168.24.134:8006/api2/json'::text,
    proxmox_api_token_id text DEFAULT 'root@pam'::text,
    proxmox_api_token_name text DEFAULT 'delete'::text,
    proxmox_api_token_secret text,
    pm_user text DEFAULT 'root@pam'::text,
    pm_password text,
    proxmox_node text DEFAULT 'pve'::text,
    vm_storage text DEFAULT 'local-lvm'::text,
    vm_bridge text DEFAULT 'vmbr0'::text,
    ssh_public_key_path text DEFAULT 'C:/Users/Nexus-PC/.ssh/id_rsa.pub'::text,
    ssh_private_key_path text DEFAULT 'C:/Users/Nexus-PC/.ssh/id_rsa'::text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    statuspath text DEFAULT '/tmp/status.json'::text,
    servicespath text DEFAULT '/tmp/services_status.json'::text,
    instanceinfopath text DEFAULT '/etc/instance-info.conf'::text,
    proxmox_host character varying,
    proxmox_ssh_user character varying
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
    first_name character varying(100),
    last_name character varying(100),
    email character varying(255) NOT NULL,
    phone character varying(30),
    password text NOT NULL,
    role character varying(30) DEFAULT 'technicien'::character varying NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
-- Name: vm_instances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vm_instances (
    id uuid NOT NULL,
    instance_id uuid,
    hostname character varying,
    ip_address character varying,
    fetched_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.vm_instances OWNER TO postgres;

--
-- Name: config_template_services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_template_services ALTER COLUMN id SET DEFAULT nextval('public.service_configurations_id_seq'::regclass);


--
-- Name: config_templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_templates ALTER COLUMN id SET DEFAULT nextval('public.service_templates_id_seq'::regclass);


--
-- Name: deployments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deployments ALTER COLUMN id SET DEFAULT nextval('public.deployments_id_seq'::regclass);


--
-- Name: init_scripts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.init_scripts ALTER COLUMN id SET DEFAULT nextval('public.init_scripts_id_seq'::regclass);


--
-- Name: monitoring_scripts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring_scripts ALTER COLUMN id SET DEFAULT nextval('public.monitoring_scripts_id_seq'::regclass);


--
-- Name: monitoring_services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring_services ALTER COLUMN id SET DEFAULT nextval('public.monitoring_services_id_seq'::regclass);


--
-- Name: user_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_settings ALTER COLUMN id SET DEFAULT nextval('public.user_settings_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: config_template_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_template_services (id, service_type, config_data, script_path, created_at, updated_at) FROM stdin;
12	dns	{"SERIAL": "2025072901", "FQDN_NS": "ns1.camer.cm.", "records": [{"name": "@", "type": "NS", "value": "ns1.camer.cm."}, {"name": "@", "type": "NS", "value": "ns2.camer.cm."}, {"name": "ns1", "type": "A", "value": "192.168.20.10"}, {"name": "ns2", "type": "A", "value": "192.168.20.20"}, {"name": "www", "type": "A", "value": "192.168.24.163"}], "ZONE_NAME": "camer.cm", "ADMIN_EMAIL": "admin.camer.cm."}	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\dns_config\\config-dns-configuration-dns-bind9-maître-1753898872310.sh	2025-07-30 19:07:52.311+01	2025-07-30 19:07:52.311+01
13	dns	{"SERIAL": "2025072901", "FQDN_NS": "ns1.camer.cm.", "records": [{"name": "@", "type": "NS", "value": "ns1.camer.cm."}, {"name": "@", "type": "NS", "value": "ns2.camer.cm."}, {"name": "ns1", "type": "A", "value": "192.168.20.10"}, {"name": "ns2", "type": "A", "value": "192.168.20.20"}, {"name": "www", "type": "A", "value": "192.168.24.163"}], "ZONE_NAME": "camer.cm", "ADMIN_EMAIL": "admin.camer.cm."}	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\dns_config\\config-dns-configuration-dns-bind9-maître-1753899748146.sh	2025-07-30 19:22:28.148+01	2025-07-30 19:22:28.148+01
\.


--
-- Data for Name: config_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_templates (id, name, service_type, description, template_path, created_at, updated_at, category) FROM stdin;
21	Agent Supervision Services	monitoring	Script Bash permettant de superviser dynamiquement les services système à l’aide de cron, avec enregistrement JSON.	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-templates\\monitoring_services\\agent_supervision_services.tmpl.sh	2025-07-30 19:00:41.133+01	2025-07-30 19:00:41.133+01	monitoring_services
22	Configuration DNS Bind9 maître	dns	Script Bash pour installer et configurer Bind9 en tant que serveur DNS maître, avec génération de fichier de zone dynamique.	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-templates\\dns_config\\configuration_dns_bind9_maître.tmpl.sh	2025-07-30 19:01:44.231+01	2025-07-30 19:01:44.231+01	dns_config
23	Agent de supervision DNS	dns	Script d'installation et de supervision avancée pour le service DNS (bind9), incluant vérifications système, test dig, checkzone, ports ouverts et consommation ressources.	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-templates\\monitoring_dns\\agent_de_supervision_dns.tmpl.sh	2025-07-30 19:03:11.027+01	2025-07-30 19:03:11.027+01	monitoring_dns
24	Agent de supervision services système	supervision	Script Bash pour superviser dynamiquement l’état des services Linux (enabled / active) avec détection périodique via cron.	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-templates\\monitoring_services\\agent_de_supervision_services_système.tmpl.sh	2025-07-30 19:04:56.428+01	2025-07-30 19:04:56.428+01	monitoring_services
\.


--
-- Data for Name: deletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deletes (id, instance_id, vm_id, vm_name, vm_ip, log_path, user_id, user_email, deleted_at) FROM stdin;
84a1189f-98e5-457e-9dac-1ee6b4bd7f01	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	104	jbfsdhfds	192.168.24.26	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-30T16-45-45-365Z-1.log	1	admin@bunec.cm	2025-07-30 16:45:47.979
cb061868-3bcc-4e0b-b142-d15416f9f64f	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	104	testjeudi	192.168.24.29	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-31T12-40-12-357Z-1.log	1	admin@bunec.cm	2025-07-31 12:40:14.992
848a1d70-0657-49e9-81e0-1487693dcf47	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	104	vm-104	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-31T12-40-22-557Z-1.log	1	admin@bunec.cm	2025-07-31 12:40:22.589
ff33673d-8418-49e8-8da5-9cf97e970f20	43881a0e-317e-4d19-bf59-1a6fad9dc1a6	101	testvm1	192.168.24.30	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-31T12-52-06-138Z-1.log	1	admin@bunec.cm	2025-07-31 12:52:08.802
\.


--
-- Data for Name: deployments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deployments (id, user_id, user_email, vm_name, service_name, operation_type, started_at, ended_at, duration, success, log_path, vm_id, vm_ip, created_at, updated_at, instance_id, injected_files, vm_specs, status) FROM stdin;
15	1	admin@bunec.cm	testvm67	dns	apply	2025-07-31 15:11:40.452+01	2025-07-31 15:14:13.713+01	00:02:33.261	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T14-11-40-452Z-1.log	101	192.168.24.37	2025-07-31 15:14:13.717+01	2025-07-31 15:14:13.717+01	c6b7938a-1e85-4db9-b7de-8b7bfbcd1b91	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
16	1	admin@bunec.cm	testvm7	dns	apply	2025-07-31 15:18:47.766+01	2025-07-31 15:21:13.372+01	00:02:25.606	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T14-18-47-766Z-1.log	103	192.168.24.38	2025-07-31 15:21:13.376+01	2025-07-31 15:21:13.376+01	1f17200b-0465-4d93-88b5-df7573649fde	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
17	1	admin@bunec.cm	wqer	dns	apply	2025-07-31 15:58:35.372+01	2025-07-31 16:00:59.951+01	00:02:24.579	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T14-58-35-372Z-1.log	104	192.168.24.42	2025-07-31 16:00:59.954+01	2025-07-31 16:00:59.954+01	fbcbccc5-6819-4838-bf9b-e9a72c2e1112	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
18	1	admin@bunec.cm	khjg	dns	apply	2025-07-31 17:15:09.946+01	2025-07-31 17:17:24.906+01	00:02:14.96	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-15-09-946Z-1.log	101	192.168.24.45	2025-07-31 17:17:24.908+01	2025-07-31 17:17:24.908+01	fceeb525-5ec5-4a19-8172-2fa627828881	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
19	1	admin@bunec.cm	yedg	dns	apply	2025-07-31 17:19:43.924+01	2025-07-31 17:22:08.127+01	00:02:24.203	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-19-43-924Z-1.log	101	192.168.24.46	2025-07-31 17:22:08.131+01	2025-07-31 17:22:08.131+01	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
20	1	admin@bunec.cm	ydsbs	dns	apply	2025-07-31 17:34:36.908+01	2025-07-31 17:37:16.84+01	00:02:39.932	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-34-36-908Z-1.log	103	192.168.24.47	2025-07-31 17:37:16.844+01	2025-07-31 17:37:16.844+01	9dd888e9-b932-49d4-bbd0-9a74a8bd072e	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
21	1	admin@bunec.cm	eskfn	dns	apply	2025-07-31 17:41:22.242+01	2025-07-31 17:44:01.689+01	00:02:39.447	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-41-22-242Z-1.log	104	192.168.24.48	2025-07-31 17:44:01.694+01	2025-07-31 17:44:01.694+01	f2810f12-a837-47d7-a674-19046da07610	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
\.


--
-- Data for Name: init_scripts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.init_scripts (id, name, script_path, service_type, created_at, updated_at) FROM stdin;
9	Init Sécurité Linux Universel	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh	general	2025-07-30 00:37:58.32+01	2025-07-30 00:37:58.32+01
\.


--
-- Data for Name: monitoring_scripts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monitoring_scripts (id, name, script_path, service_type, created_at, updated_at) FROM stdin;
13	Agent DNS - camer.cm	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh	dns	2025-07-30 00:38:15.265+01	2025-07-30 00:38:15.265+01
\.


--
-- Data for Name: monitoring_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monitoring_services (id, name, service_type, config_data, script_path, created_at, updated_at) FROM stdin;
3	Service Watcher - d9080a7d	services	{"services": ["sshd", "bind9", "postgresql", "nginx"], "cron_interval": "1"}	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh	2025-07-30 00:39:21.38+01	2025-07-30 00:39:21.38+01
\.


--
-- Data for Name: service_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_statuses (id, hostname, "timestamp", created_at, updated_at, instance_id, formatted_data) FROM stdin;
0c5a470e-fb82-42f5-b306-bc827110b25e	testid	2025-07-30 17:01:01+01	2025-07-30 16:01:14.256	2025-07-30 16:01:14.256	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
\.


--
-- Data for Name: status_snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_snapshots (id, instance_id, hostname, "timestamp", "createdAt", "updatedAt", formatted_data) FROM stdin;
34f76e96-c437-4882-9baf-14f0055367cb	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	2025-07-30 17:00:02+01	2025-07-30 17:01:13.987+01	2025-07-30 17:01:13.987+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "ok"}, {"label": "dig_test_local", "value": "success"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "6"}, {"label": "ram_usage", "value": "12%"}, {"label": "disk_usage", "value": "62%"}]
\.


--
-- Data for Name: user_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_settings (id, user_id, cloudinit_user, cloudinit_password, proxmox_api_url, proxmox_api_token_id, proxmox_api_token_name, proxmox_api_token_secret, pm_user, pm_password, proxmox_node, vm_storage, vm_bridge, ssh_public_key_path, ssh_private_key_path, created_at, updated_at, statuspath, servicespath, instanceinfopath, proxmox_host, proxmox_ssh_user) FROM stdin;
2	2	nexus	Nexus2023.	https://192.168.24.134:8006/api2/json	root@pam	delete	0a804aa8-029e-4503-83a3-3fb51a804771	root@pam	Nexus2023.	pve	local-lvm	vmbr0	C:/Users/Nexus-PC/.ssh/id_rsa.pub	C:/Users/Nexus-PC/.ssh/id_rsa	2025-07-31 14:41:36.584	2025-07-31 14:41:36.584	/tmp/status.json	/tmp/services_status.json	/etc/instance-info.conf	\N	\N
1	1	nexus	Nexus2023.	https://192.168.24.134:8006/api2/json	root@pam	delete	0a804aa8-029e-4503-83a3-3fb51a804771	root@pam	Nexus2023.	pve	local-lvm	vmbr0	C:/Users/Nexus-PC/.ssh/id_rsa.pub	C:/Users/Nexus-PC/.ssh/id_rsa	2025-07-31 14:37:46.783851	2025-07-31 16:13:18.187	/tmp/status.json	/tmp/services_status.json	/etc/instance-info.conf	192.168.24.134	root
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, phone, password, role, status, created_at, updated_at) FROM stdin;
1	Super	Admin	admin@bunec.cm	000000000	$2b$10$2ntFW.kEPKJLm8psncrVNeCIRh5l32TIQ2AsbZaj9ufrSZeJtNkKW	superadmin	active	2025-07-22 22:47:42.169+01	2025-07-22 22:47:42.169+01
2	Super2	Admin2	admin2@bunec.cm	22222222	$2b$10$6J46r01.75D5FN7eZXWGrOKQj2nDcL16UWJwBbWzhcdzDKGhAOSZ6	superadmin	active	2025-07-31 15:23:32.2+01	2025-07-31 15:23:32.2+01
\.


--
-- Data for Name: vm_instances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vm_instances (id, instance_id, hostname, ip_address, fetched_at) FROM stdin;
dbd9ea2e-9a64-4f86-b0ba-e28c08569cca	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 15:48:05.434
c6dd04fa-2b42-43e8-9ce5-4dc2cd2453cd	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 15:51:08.039
32efa064-9eca-4026-84eb-27635cabf20e	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 15:57:04.016
6430b289-db02-4653-a975-fbeb0235aab1	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 16:01:14.315
\.


--
-- Name: deployments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deployments_id_seq', 21, true);


--
-- Name: init_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.init_scripts_id_seq', 9, true);


--
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitoring_scripts_id_seq', 13, true);


--
-- Name: monitoring_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitoring_services_id_seq', 3, true);


--
-- Name: service_configurations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_configurations_id_seq', 13, true);


--
-- Name: service_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_templates_id_seq', 24, true);


--
-- Name: user_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_settings_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


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
-- Name: init_scripts init_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.init_scripts
    ADD CONSTRAINT init_scripts_pkey PRIMARY KEY (id);


--
-- Name: monitoring_scripts monitoring_scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring_scripts
    ADD CONSTRAINT monitoring_scripts_pkey PRIMARY KEY (id);


--
-- Name: monitoring_services monitoring_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitoring_services
    ADD CONSTRAINT monitoring_services_pkey PRIMARY KEY (id);


--
-- Name: config_template_services service_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_template_services
    ADD CONSTRAINT service_configurations_pkey PRIMARY KEY (id);


--
-- Name: service_statuses service_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_statuses
    ADD CONSTRAINT service_statuses_pkey PRIMARY KEY (id);


--
-- Name: config_templates service_templates_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_templates
    ADD CONSTRAINT service_templates_name_key UNIQUE (name);


--
-- Name: config_templates service_templates_name_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_templates
    ADD CONSTRAINT service_templates_name_key1 UNIQUE (name);


--
-- Name: config_templates service_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_templates
    ADD CONSTRAINT service_templates_pkey PRIMARY KEY (id);


--
-- Name: status_snapshots status_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_snapshots
    ADD CONSTRAINT status_snapshots_pkey PRIMARY KEY (id);


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
-- Name: users users_email_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key1 UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vm_instances vm_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vm_instances
    ADD CONSTRAINT vm_instances_pkey PRIMARY KEY (id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: user_settings user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_settings
    ADD CONSTRAINT user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

