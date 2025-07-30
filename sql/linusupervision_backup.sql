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
    hostname character varying(255),
    "timestamp" timestamp with time zone,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    instance_id uuid,
    formatted_data jsonb DEFAULT '[]'::jsonb NOT NULL
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
-- Data for Name: deletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deletes (id, instance_id, vm_id, vm_name, vm_ip, log_path, user_id, user_email, deleted_at) FROM stdin;
84a1189f-98e5-457e-9dac-1ee6b4bd7f01	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	104	jbfsdhfds	192.168.24.26	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-30T16-45-45-365Z-1.log	1	admin@bunec.cm	2025-07-30 16:45:47.979
\.


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
8	1	admin@bunec.cm	testid	web	destroy	2025-07-30 15:36:18.957+01	2025-07-30 15:39:11.697+01	00:02:52.74	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T14-36-18-957Z-1.log	101	192.168.24.21	2025-07-30 15:39:11.702+01	2025-07-30 17:26:41.334+01	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
11	1	admin@bunec.cm	test1	web	apply	2025-07-30 17:37:22.892+01	2025-07-30 17:40:14.209+01	00:02:51.317	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T16-37-22-892Z-1.log	103	192.168.24.25	2025-07-30 17:40:14.21+01	2025-07-30 17:40:14.21+01	e8f7bd3a-6f36-41eb-a0e7-69eedad262cb	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
9	1	admin@bunec.cm	testid	web	destroy	2025-07-30 17:27:07.041+01	2025-07-30 17:30:03.981+01	00:02:56.94	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T16-27-07-041Z-1.log	101	192.168.24.22	2025-07-30 17:30:03.983+01	2025-07-30 17:33:46.395+01	f27fdf99-e765-4f3e-88f5-d836728d0c3d	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
10	1	admin@bunec.cm	oiuf	web	destroy	2025-07-30 17:30:27.015+01	2025-07-30 17:33:22.91+01	00:02:55.895	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T16-30-27-015Z-1.log	103	192.168.24.23	2025-07-30 17:33:22.912+01	2025-07-30 17:36:50.08+01	f440c70d-5ad2-4e52-9ee7-bc4e87ee0d24	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
12	1	admin@bunec.cm	jbfsdhfds	web	destroy	2025-07-30 17:40:31.964+01	2025-07-30 17:43:30.404+01	00:02:58.44	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-30T16-40-31-964Z-1.log	104	192.168.24.26	2025-07-30 17:43:30.406+01	2025-07-30 17:45:47.832+01	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns-install-1753832252525.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
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

COPY public.service_statuses (id, hostname, "timestamp", created_at, updated_at, instance_id, formatted_data) FROM stdin;
0c5a470e-fb82-42f5-b306-bc827110b25e	testid	2025-07-30 17:01:01+01	2025-07-30 16:01:14.256	2025-07-30 16:01:14.256	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
\.


--
-- Data for Name: service_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_templates (id, name, service_type, description, template_path, created_at, updated_at) FROM stdin;
12	S	supervision2	Template .	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-templates\\s.tmpl.sh	2025-07-30 00:39:08.458+01	2025-07-30 00:39:08.458+01
\.


--
-- Data for Name: status_snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_snapshots (id, instance_id, hostname, "timestamp", "createdAt", "updatedAt", formatted_data) FROM stdin;
34f76e96-c437-4882-9baf-14f0055367cb	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	2025-07-30 17:00:02+01	2025-07-30 17:01:13.987+01	2025-07-30 17:01:13.987+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "ok"}, {"label": "dig_test_local", "value": "success"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "6"}, {"label": "ram_usage", "value": "12%"}, {"label": "disk_usage", "value": "62%"}]
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, first_name, last_name, email, phone, password, role, status, created_at, updated_at) FROM stdin;
1	Super	Admin	admin@bunec.cm	000000000	$2b$10$2ntFW.kEPKJLm8psncrVNeCIRh5l32TIQ2AsbZaj9ufrSZeJtNkKW	superadmin	active	2025-07-22 22:47:42.169+01	2025-07-22 22:47:42.169+01
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

SELECT pg_catalog.setval('public.deployments_id_seq', 12, true);


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
-- Name: status_snapshots status_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_snapshots
    ADD CONSTRAINT status_snapshots_pkey PRIMARY KEY (id);


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
-- PostgreSQL database dump complete
--

