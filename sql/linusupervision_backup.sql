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
-- Name: service_configurations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_configurations (
    id integer NOT NULL,
    service_type character varying(255) NOT NULL,
    config_data jsonb NOT NULL,
    script_path character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.service_configurations OWNER TO postgres;

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

ALTER SEQUENCE public.service_configurations_id_seq OWNED BY public.service_configurations.id;


--
-- Name: service_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_statuses (
    id uuid NOT NULL,
    hostname character varying(255) NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    enabled character varying(255),
    active character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.service_statuses OWNER TO postgres;

--
-- Name: service_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.service_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    description text,
    template_path character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
-- Name: supervision_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supervision_statuses (
    id uuid NOT NULL,
    hostname character varying(255),
    "timestamp" timestamp with time zone,
    bind9_status character varying(255),
    port_53 character varying(255),
    named_checkconf character varying(255),
    zone_check character varying(255),
    dig_test_local character varying(255),
    open_ports character varying(255),
    scan_duration_seconds integer,
    cpu_load character varying(255),
    ram_usage character varying(255),
    disk_usage character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.supervision_statuses OWNER TO postgres;

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
-- Name: service_configurations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_configurations ALTER COLUMN id SET DEFAULT nextval('public.service_configurations_id_seq'::regclass);


--
-- Name: service_templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_templates ALTER COLUMN id SET DEFAULT nextval('public.service_templates_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: deployments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deployments (id, user_id, user_email, vm_name, service_name, operation_type, started_at, ended_at, duration, success, log_path, vm_id, vm_ip, created_at, updated_at, instance_id, injected_files, vm_specs, status) FROM stdin;
1	1	admin@bunec.cm	dns3	dns3	apply	2025-07-30 14:30:20.656+01	2025-07-30 14:33:09.303+01	00:02:48.647	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T13-30-20-656Z-1.log	101	192.168.24.15	2025-07-30 14:33:09.309+01	2025-07-30 14:33:09.309+01	bd44fa67-69dd-41c5-a988-d5f6db3c3709	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
2	1	admin@bunec.cm	test	test	apply	2025-07-30 14:36:40.263+01	2025-07-30 14:38:38.085+01	00:01:57.822	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T13-36-40-263Z-1.log	103	192.168.24.16	2025-07-30 14:38:38.087+01	2025-07-30 14:38:38.087+01	b693b10f-dc14-4d81-9762-07ebc4e258f9	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
3	1	admin@bunec.cm	nexusvm	nexusvm	apply	2025-07-30 14:40:06.509+01	2025-07-30 14:42:48.651+01	00:02:42.142	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T13-40-06-509Z-1.log	101	192.168.24.17	2025-07-30 14:42:48.654+01	2025-07-30 14:42:48.654+01	a173dc3c-55f6-4b8e-8205-f8f37b6f4850	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
4	1	admin@bunec.cm	nexusvms	nexusvms	apply	2025-07-30 14:44:45.261+01	2025-07-30 14:47:44.391+01	00:02:59.13	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T13-44-45-261Z-1.log	101	192.168.24.18	2025-07-30 14:47:44.393+01	2025-07-30 14:47:44.393+01	50a9580c-d553-49b6-995d-6223d9637b3c	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
5	1	admin@bunec.cm	nexu	web	apply	2025-07-30 14:54:16.173+01	2025-07-30 14:57:16.504+01	00:03:00.331	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T13-54-16-173Z-1.log	103	192.168.24.19	2025-07-30 14:57:16.509+01	2025-07-30 14:57:16.509+01	f5ae6e0f-1766-40b4-a78c-8614e497af30	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
6	1	admin@bunec.cm	nexu	web	apply	2025-07-30 15:09:26.958+01	2025-07-30 15:11:06.462+01	00:01:39.504	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T14-09-26-958Z-1.log	103	192.168.24.19	2025-07-30 15:11:06.468+01	2025-07-30 15:11:06.468+01	acf524f3-08eb-4572-a578-862253092c6b	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
7	1	admin@bunec.cm	nexuws	web	apply	2025-07-30 15:16:15.245+01	2025-07-30 15:19:04.86+01	00:02:49.615	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T14-16-15-245Z-1.log	104	192.168.24.20	2025-07-30 15:19:04.863+01	2025-07-30 15:19:04.863+01	6fd1a8ec-10ad-45ea-9348-5acda170a4d8	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
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
-- Data for Name: service_configurations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_configurations (id, service_type, config_data, script_path, created_at, updated_at) FROM stdin;
10	dns	{"SERIAL": "2025072901", "FQDN_NS": "ns1.camer.cm.", "records": [{"name": "@", "type": "NS", "value": "ns1.camer.cm."}, {"name": "@", "type": "NS", "value": "ns2.camer.cm."}, {"name": "ns1", "type": "A", "value": "192.168.20.10"}, {"name": "ns2", "type": "A", "value": "192.168.20.20"}, {"name": "www", "type": "A", "value": "192.168.24.163"}], "ZONE_NAME": "camer.cm", "ADMIN_EMAIL": "admin.camer.cm."}	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\dns-install-1753832252525.sh	2025-07-30 00:37:32.529+01	2025-07-30 00:37:32.529+01
11	web	{"SERIAL": "2025072901", "FQDN_NS": "ns1.camer.cm.", "records": [{"name": "@", "type": "NS", "value": "ns1.camer.cm."}, {"name": "@", "type": "NS", "value": "ns2.camer.cm."}, {"name": "ns1", "type": "A", "value": "192.168.20.10"}, {"name": "ns2", "type": "A", "value": "192.168.20.20"}, {"name": "www", "type": "A", "value": "192.168.24.163"}], "ZONE_NAME": "camer.cm", "ADMIN_EMAIL": "admin.camer.cm."}	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\dns-install-1753832252525.sh	2025-07-30 00:37:32.529+01	2025-07-30 00:37:32.529+01
\.


--
-- Data for Name: service_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_statuses (id, hostname, "timestamp", name, enabled, active, "createdAt", "updatedAt") FROM stdin;
349e4d9a-a069-48a9-b7bd-0127e55e5977	dns	2025-07-29 17:13:01+01	sshd	alias	active	2025-07-29 17:13:42.363+01	2025-07-29 17:13:42.363+01
112b6b0d-479b-4a8e-a52f-cc356fcd67e6	dns	2025-07-29 17:13:01+01	bind9	alias	active	2025-07-29 17:13:42.363+01	2025-07-29 17:13:42.363+01
000871d3-a4c2-49c0-bd7d-d721b3ddd48e	dns	2025-07-29 17:31:01+01	sshd	alias	active	2025-07-29 17:31:09.438+01	2025-07-29 17:31:09.438+01
d83ad7ce-c934-416b-a2bb-c88e53f1f119	dns	2025-07-29 17:31:01+01	bind9	alias	active	2025-07-29 17:31:09.439+01	2025-07-29 17:31:09.439+01
462ec56c-3349-4b2e-b8d2-709e5ec155c2	dns	2025-07-30 00:40:01+01	sshd	alias	active	2025-07-30 00:40:17.147+01	2025-07-30 00:40:17.147+01
033e5ed9-e7be-4170-96e9-3df3cc8d4881	dns	2025-07-30 00:40:01+01	bind9	alias	active	2025-07-30 00:40:17.147+01	2025-07-30 00:40:17.147+01
4a5b8482-8120-43c6-9c9a-f6e28ec50ecb	dns	2025-07-30 13:33:01+01	sshd	alias	active	2025-07-30 13:33:44.316+01	2025-07-30 13:33:44.316+01
8fcfb977-0d13-4e1c-865a-eace9f0bb92d	dns	2025-07-30 13:33:01+01	bind9	alias	active	2025-07-30 13:33:44.316+01	2025-07-30 13:33:44.316+01
\.


--
-- Data for Name: service_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_templates (id, name, service_type, description, template_path, created_at, updated_at) FROM stdin;
12	S	supervision2	Template .	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-templates\\s.tmpl.sh	2025-07-30 00:39:08.458+01	2025-07-30 00:39:08.458+01
\.


--
-- Data for Name: supervision_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supervision_statuses (id, hostname, "timestamp", bind9_status, port_53, named_checkconf, zone_check, dig_test_local, open_ports, scan_duration_seconds, cpu_load, ram_usage, disk_usage, "createdAt", "updatedAt") FROM stdin;
259db4b4-9236-43ba-9fae-0e7e612607c6	dns	2025-07-29 17:10:01+01	active	listening	ok	ok	success	22,53	0	5.9	15%	56%	2025-07-29 17:13:48.783+01	2025-07-29 17:13:48.783+01
72ad5efd-6254-496a-8354-d6f9791b2ff5	dns	2025-07-30 13:30:01+01	active	listening	ok	ok	success	22,53	0	3.1	11%	62%	2025-07-30 13:33:57.166+01	2025-07-30 13:33:57.166+01
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, phone, password, role, status, created_at, updated_at) FROM stdin;
1	Super	Admin	admin@bunec.cm	000000000	$2b$10$2ntFW.kEPKJLm8psncrVNeCIRh5l32TIQ2AsbZaj9ufrSZeJtNkKW	superadmin	active	2025-07-22 22:47:42.169+01	2025-07-22 22:47:42.169+01
\.


--
-- Name: deployments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deployments_id_seq', 7, true);


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

SELECT pg_catalog.setval('public.service_configurations_id_seq', 10, true);


--
-- Name: service_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_templates_id_seq', 12, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


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
-- Name: service_configurations service_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_configurations
    ADD CONSTRAINT service_configurations_pkey PRIMARY KEY (id);


--
-- Name: service_statuses service_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_statuses
    ADD CONSTRAINT service_statuses_pkey PRIMARY KEY (id);


--
-- Name: service_templates service_templates_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_templates
    ADD CONSTRAINT service_templates_name_key UNIQUE (name);


--
-- Name: service_templates service_templates_name_key1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_templates
    ADD CONSTRAINT service_templates_name_key1 UNIQUE (name);


--
-- Name: service_templates service_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_templates
    ADD CONSTRAINT service_templates_pkey PRIMARY KEY (id);


--
-- Name: supervision_statuses supervision_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervision_statuses
    ADD CONSTRAINT supervision_statuses_pkey PRIMARY KEY (id);


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
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_users_email ON public.users USING btree (email);


--
-- PostgreSQL database dump complete
--

