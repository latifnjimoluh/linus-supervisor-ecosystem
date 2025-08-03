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

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.config_template_services OWNER TO postgres;

--
-- Name: config_template_services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.config_template_services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.config_template_services_id_seq OWNER TO postgres;

--
-- Name: config_template_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.config_template_services_id_seq OWNED BY public.config_template_services.id;


--
-- Name: config_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    service_type character varying(255) NOT NULL,
    category character varying(255),
    description text,
    template_path text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.config_templates OWNER TO postgres;

--
-- Name: config_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.config_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.config_templates_id_seq OWNER TO postgres;

--
-- Name: config_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.config_templates_id_seq OWNED BY public.config_templates.id;


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
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(10) DEFAULT 'actif'::character varying
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
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    permission_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_permissions_id_seq OWNER TO postgres;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(10) DEFAULT 'actif'::character varying NOT NULL
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
    name character varying(100) NOT NULL,
    service_type character varying(50) NOT NULL,
    template_path text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
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
-- Name: user_action_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_action_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id integer NOT NULL,
    action character varying(255) NOT NULL,
    details text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_action_logs OWNER TO postgres;

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
    updated_at timestamp with time zone NOT NULL,
    role_id integer,
    reset_token character varying,
    reset_expires_at timestamp without time zone,
    last_password_reset_at timestamp without time zone
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

ALTER TABLE ONLY public.config_template_services ALTER COLUMN id SET DEFAULT nextval('public.config_template_services_id_seq'::regclass);


--
-- Name: config_templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_templates ALTER COLUMN id SET DEFAULT nextval('public.config_templates_id_seq'::regclass);


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
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


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
-- Data for Name: config_template_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_template_services (id, service_type, config_data, script_path, created_at, updated_at) FROM stdin;
1	dns	{"slave_ip": "192.168.20.20", "master_ip": "192.168.20.10", "zone_name": "camer.cm", "enable_checkzone": true, "monitoring_interval": "5min"}	D:\\\\Keyce_B3\\\\Soutenance\\\\linusupervisor-backend\\\\linusupervisor-backend\\\\generated-scripts\\\\dns_config\\\\config-dns-configuration-dns-bind9-maître-1753899748146.sh	2025-08-02 13:22:34.430452+01	2025-08-02 13:22:34.430452+01
\.


--
-- Data for Name: config_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_templates (id, name, service_type, category, description, template_path, created_at, updated_at) FROM stdin;
1	dns	dns	dns	Script Bash pour superviser dynamiquement l’état des services Linux (enabled / active) avec détection périodique via cron.	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-templates\\dns\\dns.tmpl.sh	2025-08-02 13:32:19.628+01	2025-08-02 13:32:19.628+01
\.


--
-- Data for Name: deletes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deletes (id, instance_id, vm_id, vm_name, vm_ip, log_path, user_id, user_email, deleted_at) FROM stdin;
84a1189f-98e5-457e-9dac-1ee6b4bd7f01	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	104	jbfsdhfds	192.168.24.26	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-30T16-45-45-365Z-1.log	1	admin@bunec.cm	2025-07-30 16:45:47.979
cb061868-3bcc-4e0b-b142-d15416f9f64f	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	104	testjeudi	192.168.24.29	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-31T12-40-12-357Z-1.log	1	admin@bunec.cm	2025-07-31 12:40:14.992
848a1d70-0657-49e9-81e0-1487693dcf47	90627c3a-b2e5-4f3f-9243-c11b902b6ad4	104	vm-104	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-31T12-40-22-557Z-1.log	1	admin@bunec.cm	2025-07-31 12:40:22.589
ff33673d-8418-49e8-8da5-9cf97e970f20	43881a0e-317e-4d19-bf59-1a6fad9dc1a6	101	testvm1	192.168.24.30	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-07-31T12-52-06-138Z-1.log	1	admin@bunec.cm	2025-07-31 12:52:08.802
3ce94694-38ef-44e1-ad92-9b4e04660f15	43881a0e-317e-4d19-bf59-1a6fad9dc1a6	101	yedg	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-14-39-279Z-1.log	1	admin@bunec.cm	2025-08-01 12:14:42.352
60b4dd12-faea-49d1-98a9-5dee4ca8df44	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	101	yedg	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-15-50-108Z-1.log	1	admin@bunec.cm	2025-08-01 12:15:53.068
5856def1-f075-41f3-8056-3d538d5bcaee	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	101	yedg	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-16-56-998Z-1.log	1	admin@bunec.cm	2025-08-01 12:16:57.226
015f6e0b-3645-42c8-b9e4-c95682414542	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	103	ydsbs	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-17-21-463Z-1.log	1	admin@bunec.cm	2025-08-01 12:17:21.634
a47fa63f-ec94-40fe-999c-f365de21be8f	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	104	eskfn	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-18-13-307Z-1.log	1	admin@bunec.cm	2025-08-01 12:18:13.484
d6cb65d2-0833-4a28-a575-e14902f557e2	361371c5-cef8-4fa4-819a-82b8cfddfdab	104	vm-104	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-26-02-640Z-1.log	1	admin@bunec.cm	2025-08-01 12:26:02.727
e75ca618-858d-4f0b-aebd-2a8831113b93	361371c5-cef8-4fa4-819a-82b8cfddfdab	101	eskfn	192.168.24.49	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-26-31-326Z-1.log	1	admin@bunec.cm	2025-08-01 12:26:33.731
fe1c807d-248a-4839-b53c-2eac5e297775	3662cca0-129c-4af0-8e59-f65f87cdc6d8	101	test1	192.168.24.50	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-01T12-34-49-121Z-1.log	1	admin@bunec.cm	2025-08-01 12:34:51.559
9effec6a-49af-4b11-bb53-7039ac21c69b	3662cca0-129c-4af0-8e59-f65f87cdc6d8	104	testrr3	192.168.24.53	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T10-38-47-129Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 10:38:49.518
d6aa75c8-3910-4330-82c4-539163d23bbf	3662cca0-129c-4af0-8e59-f65f87cdc6d8	105	trr3	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T10-44-04-499Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 10:44:04.625
e74f3b83-27ae-4f17-832d-2c6f2795755b	3662cca0-129c-4af0-8e59-f65f87cdc6d8	101	adse	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T10-44-40-706Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 10:44:40.821
ab5b5b46-73e4-4586-baf9-a4f244436e11	3662cca0-129c-4af0-8e59-f65f87cdc6d8	101	adse	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T10-44-59-083Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 10:44:59.237
923cef6e-db10-4dd2-8c12-f3f4a15fb6d8	3662cca0-129c-4af0-8e59-f65f87cdc6d8	103	tests	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T11-15-33-802Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 11:15:36.929
2033eebc-af55-41ed-b5eb-59fe600991c9	3662cca0-129c-4af0-8e59-f65f87cdc6d8	103	tests	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T11-16-16-047Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 11:16:16.164
77b81e81-2267-4646-9cc3-e0ccbdcfc47d	3662cca0-129c-4af0-8e59-f65f87cdc6d8	104	ysbg	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T11-16-20-579Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 11:16:20.697
4988fe9e-377f-47e1-ab51-9b632b390323	3662cca0-129c-4af0-8e59-f65f87cdc6d8	105	madjskhu	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T11-16-24-491Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 11:16:24.613
8424eb6a-8101-4467-9293-94a2a1b68f38	3662cca0-129c-4af0-8e59-f65f87cdc6d8	101	ets	192.168.24.58	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T11-39-30-021Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 11:39:32.437
b21cd500-5671-436b-a299-cb6736e58370	3662cca0-129c-4af0-8e59-f65f87cdc6d8	101	tes1	192.168.24.59	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T12-33-53-692Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 12:33:56.072
e1142682-af1d-4b2e-bbc8-bce4bc74bf7d	3662cca0-129c-4af0-8e59-f65f87cdc6d8	103	test3	192.168.24.60	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T12-34-00-634Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 12:34:03.079
b2e830c9-ae43-4740-9ac0-8e5eb1daf3d7	3662cca0-129c-4af0-8e59-f65f87cdc6d8	104	tesssdt3	192.168.24.61	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T12-34-05-527Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 12:34:07.816
179d274f-8598-491e-8428-6dcc7b8d6c82	3662cca0-129c-4af0-8e59-f65f87cdc6d8	105	bon	\N	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T12-34-17-997Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 12:34:18.122
3f8fd0b1-2760-4dd7-a4a8-ae4375bcbe88	8af66a2e-273c-4208-86fc-7265428871f8	101	bon	192.168.24.62	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T12-43-51-069Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 12:43:53.45
a9af84fa-6244-4375-a919-ab3a514ec634	8af66a2e-273c-4208-86fc-7265428871f8	101	bon	192.168.24.63	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T13-05-03-261Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 13:05:12.899
6a491811-93e3-4ebd-984b-f11103c51af9	8af66a2e-273c-4208-86fc-7265428871f8	103	bon3	192.168.24.64	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T13-05-15-371Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 13:05:17.829
2b0f667c-1e32-432a-8c9e-ae3dcd54f7b5	8af66a2e-273c-4208-86fc-7265428871f8	104	bon4	192.168.24.65	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T13-08-43-297Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 13:08:45.751
ddf94416-3fa7-4722-8a48-0ca0576098f1	8af66a2e-273c-4208-86fc-7265428871f8	103	bo6	192.168.24.67	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T13-44-29-541Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 13:44:32.023
199e81b8-4a9a-4e63-bdb4-cc562d361741	8af66a2e-273c-4208-86fc-7265428871f8	101	bon5	192.168.24.66	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-02T13-44-36-556Z-1.log	1	latifnjimoluh@gmail.com	2025-08-02 13:44:39.019
ca136d9f-8b0b-42dc-94a6-c304f0d3304d	8af66a2e-273c-4208-86fc-7265428871f8	104	bjho6	192.168.24.68	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\delete-2025-08-03T05-33-27-042Z-1.log	1	latifnjimoluh@gmail.com	2025-08-03 05:33:29.542
\.


--
-- Data for Name: deployments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deployments (id, user_id, user_email, vm_name, service_name, operation_type, started_at, ended_at, duration, success, log_path, vm_id, vm_ip, created_at, updated_at, instance_id, injected_files, vm_specs, status) FROM stdin;
15	1	admin@bunec.cm	testvm67	dns	apply	2025-07-31 15:11:40.452+01	2025-07-31 15:14:13.713+01	00:02:33.261	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T14-11-40-452Z-1.log	101	192.168.24.37	2025-07-31 15:14:13.717+01	2025-07-31 15:14:13.717+01	c6b7938a-1e85-4db9-b7de-8b7bfbcd1b91	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
16	1	admin@bunec.cm	testvm7	dns	apply	2025-07-31 15:18:47.766+01	2025-07-31 15:21:13.372+01	00:02:25.606	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T14-18-47-766Z-1.log	103	192.168.24.38	2025-07-31 15:21:13.376+01	2025-07-31 15:21:13.376+01	1f17200b-0465-4d93-88b5-df7573649fde	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
17	1	admin@bunec.cm	wqer	dns	apply	2025-07-31 15:58:35.372+01	2025-07-31 16:00:59.951+01	00:02:24.579	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T14-58-35-372Z-1.log	104	192.168.24.42	2025-07-31 16:00:59.954+01	2025-07-31 16:00:59.954+01	fbcbccc5-6819-4838-bf9b-e9a72c2e1112	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
18	1	admin@bunec.cm	khjg	dns	apply	2025-07-31 17:15:09.946+01	2025-07-31 17:17:24.906+01	00:02:14.96	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-15-09-946Z-1.log	101	192.168.24.45	2025-07-31 17:17:24.908+01	2025-07-31 17:17:24.908+01	fceeb525-5ec5-4a19-8172-2fa627828881	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
20	1	admin@bunec.cm	ydsbs	dns	apply	2025-07-31 17:34:36.908+01	2025-07-31 17:37:16.84+01	00:02:39.932	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-34-36-908Z-1.log	103	192.168.24.47	2025-07-31 17:37:16.844+01	2025-07-31 17:37:16.844+01	9dd888e9-b932-49d4-bbd0-9a74a8bd072e	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
21	1	admin@bunec.cm	eskfn	dns	apply	2025-07-31 17:41:22.242+01	2025-07-31 17:44:01.689+01	00:02:39.447	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-41-22-242Z-1.log	104	192.168.24.48	2025-07-31 17:44:01.694+01	2025-07-31 17:44:01.694+01	f2810f12-a837-47d7-a674-19046da07610	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
19	1	admin@bunec.cm	yedg	dns	destroy	2025-07-31 17:19:43.924+01	2025-07-31 17:22:08.127+01	00:02:24.203	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-07-31T16-19-43-924Z-1.log	101	192.168.24.46	2025-07-31 17:22:08.131+01	2025-08-01 13:16:57.136+01	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
22	1	admin@bunec.cm	eskfn	dns	destroy	2025-08-01 13:20:41.685+01	2025-08-01 13:23:43.882+01	00:03:02.197	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-01T12-20-41-685Z-1.log	101	192.168.24.49	2025-08-01 13:23:43.885+01	2025-08-01 13:26:33.723+01	361371c5-cef8-4fa4-819a-82b8cfddfdab	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
24	1	admin@bunec.cm	test1	dns	apply	2025-08-01 13:35:14.849+01	2025-08-01 13:38:27.878+01	00:03:13.029	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-01T12-35-14-849Z-1.log	101	192.168.24.51	2025-08-01 13:38:27.881+01	2025-08-01 13:38:27.881+01	9de92183-fb40-4595-999e-071e041f88f7	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
25	1	latifnjimoluh@gmail.com	testrr3	dns	apply	2025-08-01 18:36:31.089+01	2025-08-01 18:39:26.405+01	00:02:55.316	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-01T17-36-31-089Z-1.log	104	192.168.24.53	2025-08-01 18:39:26.407+01	2025-08-01 18:39:26.407+01	ed40ea8a-88e6-4095-a314-1c79a0387768	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
23	1	admin@bunec.cm	test1	dns	destroy	2025-08-01 13:27:35.781+01	2025-08-01 13:30:27.683+01	00:02:51.902	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-01T12-27-35-781Z-1.log	101	192.168.24.50	2025-08-01 13:30:27.685+01	2025-08-02 13:33:56.066+01	3662cca0-129c-4af0-8e59-f65f87cdc6d8	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
26	1	latifnjimoluh@gmail.com	adse	dns	apply	2025-08-02 11:45:16.425+01	2025-08-02 11:47:10.783+01	00:01:54.358	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-02T10-45-16-425Z-1.log	101	192.168.24.54	2025-08-02 11:47:10.786+01	2025-08-02 11:47:10.786+01	2fab8875-9b66-428b-a9a8-7188c2519497	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-d202dbc4-686f-40db-9205-6fba5b1f046e.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/dns_config/config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
28	1	latifnjimoluh@gmail.com	bon5	dns	apply	2025-08-02 14:08:30.907+01	2025-08-02 14:10:30.3+01	00:01:59.393	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-02T13-08-30-907Z-1.log	101	192.168.24.66	2025-08-02 14:10:30.301+01	2025-08-02 14:10:30.301+01	e247a837-02e7-4a67-8847-b0d8ef9180c9	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-f3dea2a8-2773-4dbc-a298-7cc0e7aeb498.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D://Keyce_B3//Soutenance//linusupervisor-backend//linusupervisor-backend//generated-scripts//dns_config//config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
29	1	latifnjimoluh@gmail.com	bo6	dns	apply	2025-08-02 14:34:40.967+01	2025-08-02 14:36:48.829+01	00:02:07.862	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-02T13-34-40-967Z-1.log	103	192.168.24.67	2025-08-02 14:36:48.832+01	2025-08-02 14:36:48.832+01	5b49bcba-9bd0-449a-a5a5-6c81a9d925c0	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-f3dea2a8-2773-4dbc-a298-7cc0e7aeb498.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D://Keyce_B3//Soutenance//linusupervisor-backend//linusupervisor-backend//generated-scripts//dns_config//config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
27	1	latifnjimoluh@gmail.com	bon	dns	destroy	2025-08-02 13:34:26.426+01	2025-08-02 13:36:26.774+01	00:02:00.348	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-02T12-34-26-426Z-1.log	101	192.168.24.62	2025-08-02 13:36:26.778+01	2025-08-02 14:44:39.01+01	8af66a2e-273c-4208-86fc-7265428871f8	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-f3dea2a8-2773-4dbc-a298-7cc0e7aeb498.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D://Keyce_B3//Soutenance//linusupervisor-backend//linusupervisor-backend//generated-scripts//dns_config//config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
30	1	latifnjimoluh@gmail.com	bjho6	dns	apply	2025-08-02 14:42:49.861+01	2025-08-02 14:46:01.371+01	00:03:11.51	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-02T13-42-49-861Z-1.log	104	192.168.24.68	2025-08-02 14:46:01.372+01	2025-08-02 14:46:01.372+01	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-f3dea2a8-2773-4dbc-a298-7cc0e7aeb498.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D://Keyce_B3//Soutenance//linusupervisor-backend//linusupervisor-backend//generated-scripts//dns_config//config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
31	1	latifnjimoluh@gmail.com	bjho6	dns	apply	2025-08-03 06:51:47.409+01	2025-08-03 06:59:42.377+01	00:07:54.968	t	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\logs\\deploy-2025-08-03T05-51-47-409Z-1.log	101	192.168.24.69	2025-08-03 06:59:42.38+01	2025-08-03 06:59:42.38+01	728bfbb8-446d-4d0f-b053-0daa8923654f	["D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/init-Init_Sécurité_Linux_Universel-f3dea2a8-2773-4dbc-a298-7cc0e7aeb498.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/monitor-dns-camer.cm-2925a4e4-20ca-4868-8ce3-43ab8f755fa4.sh", "D:/Keyce_B3/Soutenance/linusupervisor-backend/linusupervisor-backend/generated-scripts/detect-services-9e8277c1-7d33-40cf-af8b-604038d0cfc0.sh", "D://Keyce_B3//Soutenance//linusupervisor-backend//linusupervisor-backend//generated-scripts//dns_config//config-dns-configuration-dns-bind9-maître-1753899748146.sh"]	{"disk_size": "20G", "memory_mb": 2048, "vcpu_cores": 2, "vcpu_sockets": 1, "template_name": "ubuntu-template"}	deployed
\.


--
-- Data for Name: init_scripts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.init_scripts (id, name, script_path, service_type, created_at, updated_at) FROM stdin;
10	Init Sécurité Linux Universel	D:\\Keyce_B3\\Soutenance\\linusupervisor-backend\\linusupervisor-backend\\generated-scripts\\init-Init_Sécurité_Linux_Universel-f3dea2a8-2773-4dbc-a298-7cc0e7aeb498.sh	general	2025-08-02 11:49:08.666+01	2025-08-02 11:49:08.666+01
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
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, description, created_at, updated_at, status) FROM stdin;
3	template.update	Modifier un template	2025-08-01 17:28:16.869854	2025-08-01 17:28:16.869854	actif
5	vm.status	Vérifier l’état d’une VM	2025-08-01 17:29:25.004	2025-08-01 17:29:25.004	actif
12	auth.reset.password	Réinitialiser le mot de passe	2025-08-01 17:29:25.044	2025-08-01 17:29:25.044	actif
13	auth.reset.history	Lister les utilisateurs ayant réinitialisé	2025-08-01 17:29:25.048	2025-08-01 17:29:25.048	actif
15	users.update	Modifier un utilisateur	2025-08-01 17:29:25.055	2025-08-01 17:29:25.055	actif
21	userLogs.view	Voir l’historique d’un utilisateur	2025-08-01 17:29:25.072	2025-08-01 17:29:25.072	actif
30	initScript.generate	Générer un script d’initialisation	2025-08-01 17:29:25.098	2025-08-01 17:29:25.098	actif
34	supervision.save	Sauvegarde de la supervision de status	2025-08-02 10:57:18.53	2025-08-02 10:57:18.53	actif
35	test	yesu de la supervision de status	2025-08-02 11:07:48.032	2025-08-02 11:07:55.491	inactif
27	serviceConfig.configure	Configurer automatiquement un service avec un template	2025-08-01 17:29:25.089	2025-08-02 12:18:41.466485	actif
28	monitoringService.generate	G‚n‚rer un script de monitoring pour un service	2025-08-01 17:29:25.092	2025-08-02 12:18:41.469287	actif
29	monitoringScript.generate	G‚n‚rer un script de supervision systŠme complet	2025-08-01 17:29:25.095	2025-08-02 12:18:41.471548	actif
16	users.delete	Supprimer ou d‚sactiver un utilisateur	2025-08-01 17:29:25.058	2025-08-02 12:18:14.379675	actif
17	roles.read	Afficher les r“les disponibles	2025-08-01 17:29:25.062	2025-08-02 12:18:14.384007	actif
18	roles.create	Cr‚er un nouveau r“le utilisateur	2025-08-01 17:29:25.065	2025-08-02 12:18:14.386645	actif
19	roles.update	Modifier un r“le utilisateur existant	2025-08-01 17:29:25.067	2025-08-02 12:18:14.389509	actif
20	roles.delete	Supprimer un r“le utilisateur	2025-08-01 17:29:25.07	2025-08-02 12:18:14.392131	actif
32	vm.stop	Arrˆter une machine virtuelle	2025-08-02 10:34:13.609	2025-08-02 12:18:14.433936	actif
33	vm.start	D‚marrer une machine virtuelle arrˆt‚e	2025-08-02 10:35:33.289	2025-08-02 12:18:14.437532	actif
1	template.create	Cr‚er un template de configuration standardis‚	2025-08-01 17:28:16.869854	2025-08-02 12:18:27.896903	actif
2	template.view	Consulter les templates de configuration existants	2025-08-01 17:28:16.869854	2025-08-02 12:18:27.899724	actif
4	template.delete	Supprimer un template de configuration	2025-08-01 17:28:16.869854	2025-08-02 12:18:41.385326	actif
6	vm.deploy	D‚ployer une nouvelle machine virtuelle	2025-08-01 17:29:25.02	2025-08-02 12:18:41.401419	actif
7	vm.delete	Supprimer une machine virtuelle existante	2025-08-01 17:29:25.025	2025-08-02 12:18:41.404322	actif
8	template.convert	Convertir une VM en template r‚utilisable	2025-08-01 17:29:25.03	2025-08-02 12:18:41.406237	actif
9	auth.login	Se connecter … la plateforme	2025-08-01 17:29:25.033	2025-08-02 12:18:41.409094	actif
10	auth.register	Cr‚er un nouveau compte utilisateur	2025-08-01 17:29:25.037	2025-08-02 12:18:41.410996	actif
11	auth.reset.request	Faire une demande de r‚initialisation de mot de passe	2025-08-01 17:29:25.04	2025-08-02 12:18:41.412815	actif
14	users.read	Consulter la liste des utilisateurs	2025-08-01 17:29:25.051	2025-08-02 12:18:41.426443	actif
22	userSettings.read	Lire ses propres paramŠtres utilisateur	2025-08-01 17:29:25.076	2025-08-02 12:18:41.449648	actif
23	userSettings.update	Modifier ses propres paramŠtres utilisateur	2025-08-01 17:29:25.078	2025-08-02 12:18:41.452191	actif
24	userSettings.create	Cr‚er ses propres paramŠtres utilisateur	2025-08-01 17:29:25.08	2025-08-02 12:18:41.454144	actif
25	configTemplate.create	Cr‚er un template de configuration systŠme	2025-08-01 17:29:25.084	2025-08-02 12:18:41.457896	actif
26	supervision.fetch	Envoyer les donn‚es de supervision systŠme	2025-08-01 17:29:25.086	2025-08-02 12:18:41.461203	actif
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (id, role_id, permission_id, created_at, updated_at) FROM stdin;
125	3	2	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
126	3	5	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
127	3	6	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
128	3	7	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
129	3	8	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
130	3	9	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
131	3	25	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
132	3	26	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
133	3	27	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
134	3	28	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
135	3	29	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
136	3	30	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
137	3	32	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
138	3	33	2025-08-02 11:42:55.713139	2025-08-02 11:42:55.713139
139	1	1	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
140	1	2	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
141	1	3	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
142	1	4	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
143	1	5	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
144	1	6	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
145	1	7	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
146	1	8	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
147	1	9	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
148	1	10	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
149	1	11	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
150	1	12	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
151	1	13	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
152	1	14	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
153	1	15	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
154	1	16	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
155	1	17	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
156	1	18	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
157	1	19	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
158	1	20	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
159	1	21	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
160	1	22	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
161	1	23	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
162	1	24	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
163	1	25	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
164	1	26	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
165	1	27	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
166	1	28	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
167	1	29	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
168	1	30	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
169	1	32	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
170	1	33	2025-08-02 11:43:01.659454	2025-08-02 11:43:01.659454
171	4	2	2025-08-02 11:43:10.515482	2025-08-02 11:43:10.515482
172	4	5	2025-08-02 11:43:10.515482	2025-08-02 11:43:10.515482
173	4	9	2025-08-02 11:43:10.515482	2025-08-02 11:43:10.515482
174	4	26	2025-08-02 11:43:10.515482	2025-08-02 11:43:10.515482
175	6	2	2025-08-02 11:43:16.078852	2025-08-02 11:43:16.078852
176	6	14	2025-08-02 11:43:16.078852	2025-08-02 11:43:16.078852
177	6	21	2025-08-02 11:43:16.078852	2025-08-02 11:43:16.078852
178	6	26	2025-08-02 11:43:16.078852	2025-08-02 11:43:16.078852
179	6	28	2025-08-02 11:43:16.078852	2025-08-02 11:43:16.078852
180	6	29	2025-08-02 11:43:16.078852	2025-08-02 11:43:16.078852
181	1	34	2025-08-02 11:08:43.801	2025-08-02 11:08:43.801
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, created_at, updated_at, status) FROM stdin;
6	analystes	Peut consulter les données et générer des rapports	2025-08-02 00:47:31.466	2025-08-02 00:47:31.466	actif
5	Updated role	Peut consulter les données et générer des rapports	2025-08-01 12:59:31.454	2025-08-02 10:08:24.056	actif
7	Admin	Admin role	2025-08-02 10:07:55.69	2025-08-02 10:08:55.548	inactif
9	Updated Role	\N	2025-08-02 10:24:02.206	2025-08-02 10:25:56.717	inactif
1	superadmin	AccŠs complet … toutes les fonctionnalit‚s de la plateforme et des serveurs.	2025-08-01 13:46:09.684567	2025-08-02 11:52:37.291989	actif
3	technicien	Peut ex‚cuter des d‚ploiements, configurer des services, superviser et g‚rer les VMs.	2025-08-01 13:46:09.684567	2025-08-02 11:52:37.299558	actif
4	observateur	AccŠs en lecture seule aux journaux, statuts des VMs et informations systŠmes.	2025-08-01 13:46:09.684567	2025-08-02 11:52:37.309932	actif
\.


--
-- Data for Name: service_statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_statuses (id, hostname, "timestamp", created_at, updated_at, instance_id, formatted_data) FROM stdin;
0c5a470e-fb82-42f5-b306-bc827110b25e	testid	2025-07-30 17:01:01+01	2025-07-30 16:01:14.256	2025-07-30 16:01:14.256	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
a4e1d18e-6e2e-429a-b2c9-4c9930dd15f3	yedg	2025-07-31 17:53:01+01	2025-07-31 16:53:10.821	2025-07-31 16:53:10.821	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
fe86fb3f-0165-425f-a080-fb99f5e525e7	\N	\N	2025-08-02 11:33:49.374	2025-08-02 11:33:49.374	12ee688d-333b-4504-8ef7-da85b29fb9ee	[]
78b1debd-163c-40de-b10b-9071e9fb5c7e	bjho6	2025-08-03 06:22:01+01	2025-08-03 05:22:47.837	2025-08-03 05:22:47.837	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
57347511-4d57-4b6e-8788-021474f33065	bjho6	2025-08-03 06:27:01+01	2025-08-03 05:27:37.327	2025-08-03 05:27:37.327	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
e9c27810-4e9e-4a12-81d2-d9f6d521795c	bjho6	2025-08-03 06:28:01+01	2025-08-03 05:28:07.103	2025-08-03 05:28:07.103	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
e73eaa0a-c595-460a-bc36-41e0bbb203a3	bjho6	2025-08-03 07:00:01+01	2025-08-03 06:00:20.912	2025-08-03 06:00:20.912	728bfbb8-446d-4d0f-b053-0daa8923654f	[{"name": "sshd", "active": "active", "enabled": "alias"}, {"name": "bind9", "active": "active", "enabled": "alias"}]
\.


--
-- Data for Name: service_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.service_templates (id, name, service_type, template_path, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: status_snapshots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_snapshots (id, instance_id, hostname, "timestamp", "createdAt", "updatedAt", formatted_data) FROM stdin;
34f76e96-c437-4882-9baf-14f0055367cb	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	2025-07-30 17:00:02+01	2025-07-30 17:01:13.987+01	2025-07-30 17:01:13.987+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "ok"}, {"label": "dig_test_local", "value": "success"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "6"}, {"label": "ram_usage", "value": "12%"}, {"label": "disk_usage", "value": "62%"}]
12ee688d-333b-4504-8ef7-da85b29fb9ee	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	yedg	2025-07-31 17:50:01+01	2025-07-31 17:53:10.811+01	2025-07-31 17:53:10.811+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "fail"}, {"label": "dig_test_local", "value": "fail"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "3.1"}, {"label": "ram_usage", "value": "10%"}, {"label": "disk_usage", "value": "62%"}]
97bb8b60-8e5a-4059-a105-9af5adc84cc5	12ee688d-333b-4504-8ef7-da85b29fb9ee	\N	\N	2025-08-02 12:33:49.367+01	2025-08-02 12:33:49.367+01	[{"label": "0", "value": {"name": "sshd", "active": "active", "enabled": "alias"}}, {"label": "1", "value": {"name": "bind9", "active": "active", "enabled": "alias"}}]
19cbd895-9c73-481e-90f9-1258691bc38a	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	bjho6	2025-08-03 06:20:01+01	2025-08-03 06:22:47.829+01	2025-08-03 06:22:47.829+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "fail"}, {"label": "dig_test_local", "value": "fail"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "5.9"}, {"label": "ram_usage", "value": "10%"}, {"label": "disk_usage", "value": "63%"}]
16cf3cbe-91cd-4e80-8ead-c8889f0113c7	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	bjho6	2025-08-03 06:25:01+01	2025-08-03 06:27:37.322+01	2025-08-03 06:27:37.322+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "fail"}, {"label": "dig_test_local", "value": "fail"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "3.2"}, {"label": "ram_usage", "value": "10%"}, {"label": "disk_usage", "value": "63%"}]
537f5bcd-4e31-4040-85b0-87f77ab56b9d	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	bjho6	2025-08-03 06:25:01+01	2025-08-03 06:28:07.088+01	2025-08-03 06:28:07.088+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "fail"}, {"label": "dig_test_local", "value": "fail"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "3.2"}, {"label": "ram_usage", "value": "10%"}, {"label": "disk_usage", "value": "63%"}]
b5ac6e8f-f34b-47e4-98ad-fe34496747c9	728bfbb8-446d-4d0f-b053-0daa8923654f	bjho6	2025-08-03 07:00:01+01	2025-08-03 07:00:20.908+01	2025-08-03 07:00:20.908+01	[{"label": "bind9_status", "value": "active"}, {"label": "port_53", "value": "listening"}, {"label": "named_checkconf", "value": "ok"}, {"label": "zone_check", "value": "fail"}, {"label": "dig_test_local", "value": "fail"}, {"label": "open_ports", "value": "22,53"}, {"label": "scan_duration_seconds", "value": 0}, {"label": "cpu_load", "value": "6.2"}, {"label": "ram_usage", "value": "11%"}, {"label": "disk_usage", "value": "55%"}]
\.


--
-- Data for Name: user_action_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_action_logs (id, user_id, action, details, created_at) FROM stdin;
908a1101-ef18-4c9c-805f-035c3bb30a9d	1	Demande de réinitialisation		2025-08-01 16:15:43.662
5eab5087-b405-4057-b109-91be8bd676de	1	Réinitialisation de mot de passe		2025-08-01 16:16:31.997
b52bf973-2886-4885-83f1-de87d4453584	1	Consultation de l’historique des réinitialisations		2025-08-01 16:18:53.103
e1a2b8d9-0e65-4b82-930e-0bd593ff7a52	1	Demande de réinitialisation		2025-08-01 16:24:15.951
6ebf0924-6c2e-44df-8f2d-1d74e32a8365	1	Demande de réinitialisation		2025-08-01 16:26:45.735
dcb9ef7a-7dfc-48e7-9d73-08603aaed75b	1	Demande de réinitialisation		2025-08-01 16:34:37.407
d1e2f272-12b0-45fa-bdc2-5599d093d05d	1	Demande de réinitialisation	ℹ️ Aucune information détaillée fournie.	2025-08-01 16:45:08.172
4f9e9b69-9a51-4c02-9f81-21cd899656aa	1	Réinitialisation de mot de passe	ℹ️ Aucune information détaillée fournie.	2025-08-01 16:45:39.892
b4f9441e-b8af-4f2d-b417-6409d7d1a56b	1	Consultation de l’historique des réinitialisations	ℹ️ Aucune information détaillée fournie.	2025-08-01 16:45:42.83
ba0e6d35-7a39-4315-89df-783cab574a69	1	Création d’un compte utilisateur	Email créé: leo.teoikuyst@bunec.cm, Rôle ID: 5	2025-08-01 17:35:29.667
35834b00-4e46-4a0e-9b44-9c2e3a6eeee5	1	Modification utilisateur	ID: 3	2025-08-02 10:04:31.875
8d45601e-8d0e-40a5-9025-3ba407b1b2ed	1	Modification utilisateur	ID: 4	2025-08-02 10:05:01.809
bc4482fd-a82b-41f6-8541-b2b68142ff9a	1	Modification utilisateur	ID: 4	2025-08-02 10:05:38.016
fc79a458-e8d9-4478-afe7-21b0f103e9eb	1	Patch utilisateur	ID: 4	2025-08-02 10:06:24.871
e5af9e83-3cbe-4e7d-b5d8-c9057034e704	1	Suppression utilisateur	ID: 4	2025-08-02 10:06:32.383
17aaa467-a458-4417-9ded-58bfaf470477	1	Modification utilisateur	ID: 4	2025-08-02 10:10:06.608
ee488da8-c300-4bcb-9597-3b3466f2c251	1	Création d’un compte utilisateur	Email créé: new@example.com, Rôle ID: 1	2025-08-02 10:18:26.564
7297e2f0-17b0-44e1-a21a-01f6215c56a2	1	Création d’un compte utilisateur	Email créé: leo.sef@bunec.cm, Rôle ID: 1	2025-08-02 10:19:16.032
ca23b7d6-05c2-4464-a110-12fc1cfac52d	1	Demande de réinitialisation	ℹ️ Aucune information détaillée fournie.	2025-08-02 10:19:40.014
8b19b4a3-8708-4c3c-b598-9d9eb8dd6640	1	Réinitialisation de mot de passe	ℹ️ Aucune information détaillée fournie.	2025-08-02 10:20:50.221
8cb2cc5b-9cd5-4e86-b742-505aa9c59c67	1	Consultation de l’historique des réinitialisations	ℹ️ Aucune information détaillée fournie.	2025-08-02 10:21:41.444
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

COPY public.users (id, first_name, last_name, email, phone, password, role, status, created_at, updated_at, role_id, reset_token, reset_expires_at, last_password_reset_at) FROM stdin;
2	Super2	Admin2	admin2@bunec.cm	22222222	$2b$10$6J46r01.75D5FN7eZXWGrOKQj2nDcL16UWJwBbWzhcdzDKGhAOSZ6	superadmin	active	2025-07-31 15:23:32.2+01	2025-07-31 15:23:32.2+01	1	\N	\N	\N
3	Nina	Diatta	leo.kameni@bunec.cm	+237690000000	$2b$10$IY6Axd2YUoY6KX5bzG1SmuZMIXb6lZZwhVQ8bCWFNou77LrB18.ja	technicien	active	2025-08-01 15:20:48.512+01	2025-08-01 15:39:55.192+01	5	\N	\N	\N
5	telikst	test	leo.teoikuyst@bunec.cm	+555855	$2b$10$ya6nmR/Gi0EZbqNoLD6h1uG7ZApFiW7CJ91Ob1LQYnUrTCaabfGvG	technicien	active	2025-08-01 18:35:29.791+01	2025-08-01 18:35:29.791+01	5	\N	\N	\N
4	Alice	Doe	leo.kakljhmeni@bunec.cm	1234567890	$2b$10$PtfcKZ/xfvO13XvzjtwQBun614M4QYy26NBBKHiNbxp3zIIZ434Lq	technicien	active	2025-08-01 15:25:28.048+01	2025-08-02 11:10:06.621+01	4	\N	\N	\N
6	ewvre	dfe	leo.sef@bunec.cm	+8458	$2b$10$czcQiG7VwyXQ0rvPptWu5eujHhPdCtP7EvAKLjG5IRSgQHZLvv6gW	technicien	active	2025-08-02 11:19:16.153+01	2025-08-02 11:19:16.153+01	1	\N	\N	\N
1	Super	Admin	latifnjimoluh@gmail.com	000000000	$2b$10$eWe0C5WC6tAuaFJfCbJhle932CTSNPzHNFqhq2XwZkJ9XlvCRTDrm	superadmin	active	2025-07-22 22:47:42.169+01	2025-08-02 11:20:50.216+01	1	\N	\N	2025-08-02 10:20:50.216
\.


--
-- Data for Name: vm_instances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vm_instances (id, instance_id, hostname, ip_address, fetched_at) FROM stdin;
dbd9ea2e-9a64-4f86-b0ba-e28c08569cca	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 15:48:05.434
c6dd04fa-2b42-43e8-9ce5-4dc2cd2453cd	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 15:51:08.039
32efa064-9eca-4026-84eb-27635cabf20e	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 15:57:04.016
6430b289-db02-4653-a975-fbeb0235aab1	a45ae0f3-82c1-436d-b324-d5d3fc7d00bb	testid	192.168.24.21	2025-07-30 16:01:14.315
db8ecbc0-6807-4843-abbd-80687bdec8dc	07a9ec64-9b34-4f5f-b06d-e2e6b6989d99	yedg	192.168.24.46	2025-07-31 16:53:10.826
b1f7b85b-850f-4f1c-8639-72903fe2755a	12ee688d-333b-4504-8ef7-da85b29fb9ee	unknown	192.168.24.58	2025-08-02 11:33:49.378
1d12b94a-b224-42b1-9adb-620bdd17b4a3	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	bjho6	192.168.24.68	2025-08-03 05:22:47.843
bfc8bcf4-552c-490e-a14f-c5325a7a6257	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	bjho6	192.168.24.68	2025-08-03 05:27:37.331
6b81948e-dfd3-4d47-9092-6dab39452e77	6ad8dd63-e7c9-44d4-8f1d-a35fbd03308d	bjho6	192.168.24.68	2025-08-03 05:28:07.106
c21683e6-e2dc-45f9-b899-6e1622df4f5a	728bfbb8-446d-4d0f-b053-0daa8923654f	bjho6	192.168.24.69	2025-08-03 06:00:20.915
\.


--
-- Name: config_template_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_template_services_id_seq', 1, true);


--
-- Name: config_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_templates_id_seq', 1, true);


--
-- Name: deployments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deployments_id_seq', 31, true);


--
-- Name: init_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.init_scripts_id_seq', 10, true);


--
-- Name: monitoring_scripts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitoring_scripts_id_seq', 13, true);


--
-- Name: monitoring_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monitoring_services_id_seq', 3, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 35, true);


--
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 181, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 9, true);


--
-- Name: service_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.service_templates_id_seq', 1, false);


--
-- Name: user_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_settings_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: config_template_services config_template_services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_template_services
    ADD CONSTRAINT config_template_services_pkey PRIMARY KEY (id);


--
-- Name: config_templates config_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_templates
    ADD CONSTRAINT config_templates_pkey PRIMARY KEY (id);


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
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_role_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_permission_id_key UNIQUE (role_id, permission_id);


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
-- Name: service_statuses service_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.service_statuses
    ADD CONSTRAINT service_statuses_pkey PRIMARY KEY (id);


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
-- Name: user_action_logs user_action_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_action_logs
    ADD CONSTRAINT user_action_logs_pkey PRIMARY KEY (id);


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
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


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

