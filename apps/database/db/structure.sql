--
-- PostgreSQL database dump
--

-- Dumped from database version 13.10
-- Dumped by pg_dump version 14.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: build_notifications_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.build_notifications_type AS ENUM (
    'diff-rejected',
    'diff-accepted',
    'diff-detected',
    'no-diff-detected',
    'progress',
    'queued'
);


ALTER TYPE public.build_notifications_type OWNER TO postgres;

--
-- Name: job_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.job_status AS ENUM (
    'pending',
    'progress',
    'complete',
    'error',
    'aborted'
);


ALTER TYPE public.job_status OWNER TO postgres;

--
-- Name: service_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.service_type AS ENUM (
    'github'
);


ALTER TYPE public.service_type OWNER TO postgres;

--
-- Name: synchronization_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.synchronization_type AS ENUM (
    'user',
    'installation'
);


ALTER TYPE public.synchronization_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" bigint,
    "forcedPlanId" bigint,
    "stripeCustomerId" character varying(255),
    "teamId" bigint,
    CONSTRAINT accounts_only_one_owner CHECK ((num_nonnulls("userId", "teamId") = 1))
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO postgres;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accounts_id_seq OWNED BY public.accounts.id;


--
-- Name: build_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.build_notifications (
    id bigint NOT NULL,
    type public.build_notifications_type NOT NULL,
    "jobStatus" public.job_status NOT NULL,
    "buildId" bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public.build_notifications OWNER TO postgres;

--
-- Name: build_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.build_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.build_notifications_id_seq OWNER TO postgres;

--
-- Name: build_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.build_notifications_id_seq OWNED BY public.build_notifications.id;


--
-- Name: builds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.builds (
    id bigint NOT NULL,
    "baseScreenshotBucketId" bigint,
    "compareScreenshotBucketId" bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    number integer NOT NULL,
    "jobStatus" public.job_status,
    "externalId" character varying(255),
    "batchCount" integer,
    name character varying(255) DEFAULT 'default'::character varying NOT NULL,
    type text,
    "totalBatch" integer,
    "prNumber" integer,
    "projectId" bigint NOT NULL,
    CONSTRAINT builds_type_check CHECK ((type = ANY (ARRAY['reference'::text, 'check'::text, 'orphan'::text])))
);


ALTER TABLE public.builds OWNER TO postgres;

--
-- Name: builds_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.builds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.builds_id_seq OWNER TO postgres;

--
-- Name: builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.builds_id_seq OWNED BY public.builds.id;


--
-- Name: captures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.captures (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "jobStatus" public.job_status NOT NULL,
    "crawlId" bigint NOT NULL,
    "screenshotId" bigint,
    "fileId" bigint,
    url character varying(255) NOT NULL
);


ALTER TABLE public.captures OWNER TO postgres;

--
-- Name: captures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.captures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.captures_id_seq OWNER TO postgres;

--
-- Name: captures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.captures_id_seq OWNED BY public.captures.id;


--
-- Name: crawls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crawls (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "jobStatus" public.job_status NOT NULL,
    "buildId" bigint NOT NULL,
    "baseUrl" character varying(255) NOT NULL
);


ALTER TABLE public.crawls OWNER TO postgres;

--
-- Name: crawls_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crawls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crawls_id_seq OWNER TO postgres;

--
-- Name: crawls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crawls_id_seq OWNED BY public.crawls.id;


--
-- Name: files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.files (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    key character varying(255) NOT NULL,
    width integer,
    height integer
);


ALTER TABLE public.files OWNER TO postgres;

--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.files_id_seq OWNER TO postgres;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.files_id_seq OWNED BY public.files.id;


--
-- Name: github_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_accounts (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "githubUserId" bigint,
    "githubOrganizationId" bigint,
    CONSTRAINT github_accounts_only_one_owner CHECK ((num_nonnulls("githubUserId", "githubOrganizationId") = 1))
);


ALTER TABLE public.github_accounts OWNER TO postgres;

--
-- Name: github_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_accounts_id_seq OWNER TO postgres;

--
-- Name: github_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_accounts_id_seq OWNED BY public.github_accounts.id;


--
-- Name: github_installation_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_installation_users (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "githubInstallationId" bigint NOT NULL,
    "githubUserId" bigint NOT NULL
);


ALTER TABLE public.github_installation_users OWNER TO postgres;

--
-- Name: github_installation_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_installation_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_installation_users_id_seq OWNER TO postgres;

--
-- Name: github_installation_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_installation_users_id_seq OWNED BY public.github_installation_users.id;


--
-- Name: github_installations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_installations (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "githubId" integer NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    "githubToken" character varying(255),
    "githubTokenExpiresAt" timestamp with time zone
);


ALTER TABLE public.github_installations OWNER TO postgres;

--
-- Name: github_installations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_installations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_installations_id_seq OWNER TO postgres;

--
-- Name: github_installations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_installations_id_seq OWNED BY public.github_installations.id;


--
-- Name: github_organizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_organizations (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    login character varying(255) NOT NULL,
    "githubId" integer NOT NULL
);


ALTER TABLE public.github_organizations OWNER TO postgres;

--
-- Name: github_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_organizations_id_seq OWNER TO postgres;

--
-- Name: github_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_organizations_id_seq OWNED BY public.github_organizations.id;


--
-- Name: github_repositories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_repositories (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    private boolean NOT NULL,
    "defaultBranch" character varying(255) NOT NULL,
    "githubId" integer NOT NULL,
    "githubAccountId" bigint
);


ALTER TABLE public.github_repositories OWNER TO postgres;

--
-- Name: github_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_repositories_id_seq OWNER TO postgres;

--
-- Name: github_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_repositories_id_seq OWNED BY public.github_repositories.id;


--
-- Name: github_repository_installations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_repository_installations (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "githubRepositoryId" bigint NOT NULL,
    "githubInstallationId" bigint NOT NULL
);


ALTER TABLE public.github_repository_installations OWNER TO postgres;

--
-- Name: github_repository_installations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_repository_installations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_repository_installations_id_seq OWNER TO postgres;

--
-- Name: github_repository_installations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_repository_installations_id_seq OWNED BY public.github_repository_installations.id;


--
-- Name: github_synchronizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_synchronizations (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "jobStatus" public.job_status NOT NULL,
    "githubInstallationId" bigint
);


ALTER TABLE public.github_synchronizations OWNER TO postgres;

--
-- Name: github_synchronizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_synchronizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_synchronizations_id_seq OWNER TO postgres;

--
-- Name: github_synchronizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_synchronizations_id_seq OWNED BY public.github_synchronizations.id;


--
-- Name: github_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.github_users (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    email character varying(255),
    login character varying(255) NOT NULL,
    "githubId" integer NOT NULL
);


ALTER TABLE public.github_users OWNER TO postgres;

--
-- Name: github_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.github_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.github_users_id_seq OWNER TO postgres;

--
-- Name: github_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.github_users_id_seq OWNED BY public.github_users.id;


--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.knex_migrations OWNER TO postgres;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_id_seq OWNER TO postgres;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.knex_migrations_lock OWNER TO postgres;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_lock_index_seq OWNER TO postgres;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plans (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "screenshotsLimitPerMonth" integer NOT NULL,
    "githubId" integer NOT NULL,
    "stripePlanId" character varying(255)
);


ALTER TABLE public.plans OWNER TO postgres;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plans_id_seq OWNER TO postgres;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    private boolean,
    "baselineBranch" character varying(255),
    "accountId" bigint NOT NULL,
    "githubRepositoryId" bigint
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "planId" bigint NOT NULL,
    "accountId" bigint NOT NULL,
    "startDate" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    "endDate" timestamp with time zone,
    source character varying(255) NOT NULL,
    "purchaserId" bigint
);


ALTER TABLE public.purchases OWNER TO postgres;

--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchases_id_seq OWNER TO postgres;

--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchases_id_seq OWNED BY public.purchases.id;


--
-- Name: screenshot_buckets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.screenshot_buckets (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    commit character varying(255) NOT NULL,
    branch character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    complete boolean DEFAULT true,
    "projectId" bigint NOT NULL
);


ALTER TABLE public.screenshot_buckets OWNER TO postgres;

--
-- Name: screenshot_buckets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.screenshot_buckets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.screenshot_buckets_id_seq OWNER TO postgres;

--
-- Name: screenshot_buckets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.screenshot_buckets_id_seq OWNED BY public.screenshot_buckets.id;


--
-- Name: screenshot_diffs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.screenshot_diffs (
    id bigint NOT NULL,
    "buildId" bigint NOT NULL,
    "baseScreenshotId" bigint,
    "compareScreenshotId" bigint,
    score numeric(10,5),
    "jobStatus" public.job_status,
    "validationStatus" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "s3Id" character varying(255),
    "fileId" bigint,
    "stabilityScore" integer,
    "testId" bigint
);


ALTER TABLE public.screenshot_diffs OWNER TO postgres;

--
-- Name: screenshot_diffs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.screenshot_diffs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.screenshot_diffs_id_seq OWNER TO postgres;

--
-- Name: screenshot_diffs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.screenshot_diffs_id_seq OWNED BY public.screenshot_diffs.id;


--
-- Name: screenshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.screenshots (
    id bigint NOT NULL,
    "screenshotBucketId" bigint NOT NULL,
    name character varying(255) NOT NULL,
    "s3Id" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "fileId" bigint,
    "testId" bigint
);


ALTER TABLE public.screenshots OWNER TO postgres;

--
-- Name: screenshots_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.screenshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.screenshots_id_seq OWNER TO postgres;

--
-- Name: screenshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.screenshots_id_seq OWNED BY public.screenshots.id;


--
-- Name: team_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_users (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "userId" bigint NOT NULL,
    "teamId" bigint NOT NULL,
    "userLevel" text NOT NULL,
    CONSTRAINT "team_users_userLevel_check" CHECK (("userLevel" = ANY (ARRAY['member'::text, 'owner'::text])))
);


ALTER TABLE public.team_users OWNER TO postgres;

--
-- Name: team_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_users_id_seq OWNER TO postgres;

--
-- Name: team_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_users_id_seq OWNED BY public.team_users.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255),
    slug character varying(255) NOT NULL,
    "githubAccountId" bigint
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO postgres;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: test_activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_activities (
    "userId" character varying(255) NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    date timestamp with time zone,
    action character varying(255),
    data jsonb
);


ALTER TABLE public.test_activities OWNER TO postgres;

--
-- Name: tests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tests (
    id bigint NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    name character varying(255) NOT NULL,
    "buildName" character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    "resolvedDate" timestamp with time zone,
    "resolvedStabilityScore" integer,
    "muteUntil" timestamp with time zone,
    muted boolean DEFAULT false NOT NULL,
    "projectId" bigint NOT NULL
);


ALTER TABLE public.tests OWNER TO postgres;

--
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tests_id_seq OWNER TO postgres;

--
-- Name: tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tests_id_seq OWNED BY public.tests.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    "githubId" integer NOT NULL,
    name character varying(255),
    email character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "accessToken" character varying(255),
    slug character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts ALTER COLUMN id SET DEFAULT nextval('public.accounts_id_seq'::regclass);


--
-- Name: build_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.build_notifications ALTER COLUMN id SET DEFAULT nextval('public.build_notifications_id_seq'::regclass);


--
-- Name: builds id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.builds ALTER COLUMN id SET DEFAULT nextval('public.builds_id_seq'::regclass);


--
-- Name: captures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.captures ALTER COLUMN id SET DEFAULT nextval('public.captures_id_seq'::regclass);


--
-- Name: crawls id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crawls ALTER COLUMN id SET DEFAULT nextval('public.crawls_id_seq'::regclass);


--
-- Name: files id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files ALTER COLUMN id SET DEFAULT nextval('public.files_id_seq'::regclass);


--
-- Name: github_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_accounts ALTER COLUMN id SET DEFAULT nextval('public.github_accounts_id_seq'::regclass);


--
-- Name: github_installation_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_installation_users ALTER COLUMN id SET DEFAULT nextval('public.github_installation_users_id_seq'::regclass);


--
-- Name: github_installations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_installations ALTER COLUMN id SET DEFAULT nextval('public.github_installations_id_seq'::regclass);


--
-- Name: github_organizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_organizations ALTER COLUMN id SET DEFAULT nextval('public.github_organizations_id_seq'::regclass);


--
-- Name: github_repositories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repositories ALTER COLUMN id SET DEFAULT nextval('public.github_repositories_id_seq'::regclass);


--
-- Name: github_repository_installations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repository_installations ALTER COLUMN id SET DEFAULT nextval('public.github_repository_installations_id_seq'::regclass);


--
-- Name: github_synchronizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_synchronizations ALTER COLUMN id SET DEFAULT nextval('public.github_synchronizations_id_seq'::regclass);


--
-- Name: github_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_users ALTER COLUMN id SET DEFAULT nextval('public.github_users_id_seq'::regclass);


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: purchases id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases ALTER COLUMN id SET DEFAULT nextval('public.purchases_id_seq'::regclass);


--
-- Name: screenshot_buckets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_buckets ALTER COLUMN id SET DEFAULT nextval('public.screenshot_buckets_id_seq'::regclass);


--
-- Name: screenshot_diffs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_diffs ALTER COLUMN id SET DEFAULT nextval('public.screenshot_diffs_id_seq'::regclass);


--
-- Name: screenshots id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshots ALTER COLUMN id SET DEFAULT nextval('public.screenshots_id_seq'::regclass);


--
-- Name: team_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_users ALTER COLUMN id SET DEFAULT nextval('public.team_users_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: tests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests ALTER COLUMN id SET DEFAULT nextval('public.tests_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_userid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_userid_unique UNIQUE ("userId");


--
-- Name: build_notifications build_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.build_notifications
    ADD CONSTRAINT build_notifications_pkey PRIMARY KEY (id);


--
-- Name: builds builds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_pkey PRIMARY KEY (id);


--
-- Name: captures captures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.captures
    ADD CONSTRAINT captures_pkey PRIMARY KEY (id);


--
-- Name: crawls crawls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crawls
    ADD CONSTRAINT crawls_pkey PRIMARY KEY (id);


--
-- Name: files files_key_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_key_unique UNIQUE (key);


--
-- Name: files files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: github_accounts github_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_accounts
    ADD CONSTRAINT github_accounts_pkey PRIMARY KEY (id);


--
-- Name: github_installation_users github_installation_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_installation_users
    ADD CONSTRAINT github_installation_users_pkey PRIMARY KEY (id);


--
-- Name: github_installations github_installations_githubid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_installations
    ADD CONSTRAINT github_installations_githubid_unique UNIQUE ("githubId");


--
-- Name: github_installations github_installations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_installations
    ADD CONSTRAINT github_installations_pkey PRIMARY KEY (id);


--
-- Name: github_organizations github_organizations_githubid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_organizations
    ADD CONSTRAINT github_organizations_githubid_unique UNIQUE ("githubId");


--
-- Name: github_organizations github_organizations_login_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_organizations
    ADD CONSTRAINT github_organizations_login_unique UNIQUE (login);


--
-- Name: github_organizations github_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_organizations
    ADD CONSTRAINT github_organizations_pkey PRIMARY KEY (id);


--
-- Name: github_repositories github_repositories_githubid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repositories
    ADD CONSTRAINT github_repositories_githubid_unique UNIQUE ("githubId");


--
-- Name: github_repositories github_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repositories
    ADD CONSTRAINT github_repositories_pkey PRIMARY KEY (id);


--
-- Name: github_repository_installations github_repository_installations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repository_installations
    ADD CONSTRAINT github_repository_installations_pkey PRIMARY KEY (id);


--
-- Name: github_synchronizations github_synchronizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_synchronizations
    ADD CONSTRAINT github_synchronizations_pkey PRIMARY KEY (id);


--
-- Name: github_users github_users_githubid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_users
    ADD CONSTRAINT github_users_githubid_unique UNIQUE ("githubId");


--
-- Name: github_users github_users_login_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_users
    ADD CONSTRAINT github_users_login_unique UNIQUE (login);


--
-- Name: github_users github_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_users
    ADD CONSTRAINT github_users_pkey PRIMARY KEY (id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: projects projects_githubrepositoryid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_githubrepositoryid_unique UNIQUE ("githubRepositoryId");


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: screenshot_buckets screenshot_buckets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_buckets
    ADD CONSTRAINT screenshot_buckets_pkey PRIMARY KEY (id);


--
-- Name: screenshot_diffs screenshot_diffs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_diffs
    ADD CONSTRAINT screenshot_diffs_pkey PRIMARY KEY (id);


--
-- Name: screenshots screenshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshots
    ADD CONSTRAINT screenshots_pkey PRIMARY KEY (id);


--
-- Name: team_users team_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_users
    ADD CONSTRAINT team_users_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: accounts_forcedplanid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_forcedplanid_index ON public.accounts USING btree ("forcedPlanId");


--
-- Name: accounts_teamid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_teamid_index ON public.accounts USING btree ("teamId");


--
-- Name: accounts_userid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX accounts_userid_index ON public.accounts USING btree ("userId");


--
-- Name: build_notifications_buildid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX build_notifications_buildid_index ON public.build_notifications USING btree ("buildId");


--
-- Name: builds_basescreenshotbucketid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX builds_basescreenshotbucketid_index ON public.builds USING btree ("baseScreenshotBucketId");


--
-- Name: builds_comparescreenshotbucketid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX builds_comparescreenshotbucketid_index ON public.builds USING btree ("compareScreenshotBucketId");


--
-- Name: builds_externalid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX builds_externalid_index ON public.builds USING btree ("externalId");


--
-- Name: builds_number_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX builds_number_index ON public.builds USING btree (number);


--
-- Name: builds_projectid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX builds_projectid_index ON public.builds USING btree ("projectId");


--
-- Name: captures_crawlid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX captures_crawlid_index ON public.captures USING btree ("crawlId");


--
-- Name: captures_fileid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX captures_fileid_index ON public.captures USING btree ("fileId");


--
-- Name: captures_jobstatus_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX captures_jobstatus_index ON public.captures USING btree ("jobStatus");


--
-- Name: captures_screenshotid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX captures_screenshotid_index ON public.captures USING btree ("screenshotId");


--
-- Name: crawls_buildid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crawls_buildid_index ON public.crawls USING btree ("buildId");


--
-- Name: crawls_jobstatus_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crawls_jobstatus_index ON public.crawls USING btree ("jobStatus");


--
-- Name: github_accounts_githuborganizationid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_accounts_githuborganizationid_index ON public.github_accounts USING btree ("githubOrganizationId");


--
-- Name: github_accounts_githubuserid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_accounts_githubuserid_index ON public.github_accounts USING btree ("githubUserId");


--
-- Name: github_installation_users_githubinstallationid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_installation_users_githubinstallationid_index ON public.github_installation_users USING btree ("githubInstallationId");


--
-- Name: github_installation_users_githubuserid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_installation_users_githubuserid_index ON public.github_installation_users USING btree ("githubUserId");


--
-- Name: github_repositories_githubaccountid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_repositories_githubaccountid_index ON public.github_repositories USING btree ("githubAccountId");


--
-- Name: github_repositories_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_repositories_name_index ON public.github_repositories USING btree (name);


--
-- Name: github_repository_installations_githubinstallationid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_repository_installations_githubinstallationid_index ON public.github_repository_installations USING btree ("githubInstallationId");


--
-- Name: github_repository_installations_githubrepositoryid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_repository_installations_githubrepositoryid_index ON public.github_repository_installations USING btree ("githubRepositoryId");


--
-- Name: github_synchronizations_githubinstallationid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_synchronizations_githubinstallationid_index ON public.github_synchronizations USING btree ("githubInstallationId");


--
-- Name: github_synchronizations_jobstatus_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX github_synchronizations_jobstatus_index ON public.github_synchronizations USING btree ("jobStatus");


--
-- Name: plans_githubid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX plans_githubid_index ON public.plans USING btree ("githubId");


--
-- Name: projects_accountid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_accountid_index ON public.projects USING btree ("accountId");


--
-- Name: projects_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_name_index ON public.projects USING btree (name);


--
-- Name: projects_slug_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_slug_index ON public.projects USING btree (slug);


--
-- Name: projects_token_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_token_index ON public.projects USING btree (token);


--
-- Name: purchases_accountid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX purchases_accountid_index ON public.purchases USING btree ("accountId");


--
-- Name: purchases_planid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX purchases_planid_index ON public.purchases USING btree ("planId");


--
-- Name: screenshot_buckets_commit_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_buckets_commit_index ON public.screenshot_buckets USING btree (commit);


--
-- Name: screenshot_buckets_complete_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_buckets_complete_index ON public.screenshot_buckets USING btree (complete);


--
-- Name: screenshot_buckets_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_buckets_name_index ON public.screenshot_buckets USING btree (name);


--
-- Name: screenshot_buckets_projectid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_buckets_projectid_index ON public.screenshot_buckets USING btree ("projectId");


--
-- Name: screenshot_diffs_basescreenshotid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_diffs_basescreenshotid_index ON public.screenshot_diffs USING btree ("baseScreenshotId");


--
-- Name: screenshot_diffs_buildid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_diffs_buildid_index ON public.screenshot_diffs USING btree ("buildId");


--
-- Name: screenshot_diffs_comparescreenshotid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_diffs_comparescreenshotid_index ON public.screenshot_diffs USING btree ("compareScreenshotId");


--
-- Name: screenshot_diffs_fileid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_diffs_fileid_index ON public.screenshot_diffs USING btree ("fileId");


--
-- Name: screenshot_diffs_testid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshot_diffs_testid_index ON public.screenshot_diffs USING btree ("testId");


--
-- Name: screenshots_createdat; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshots_createdat ON public.screenshots USING btree ("createdAt" DESC);


--
-- Name: screenshots_fileid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshots_fileid_index ON public.screenshots USING btree ("fileId");


--
-- Name: screenshots_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshots_name_index ON public.screenshots USING btree (name);


--
-- Name: screenshots_s3id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshots_s3id_index ON public.screenshots USING btree ("s3Id");


--
-- Name: screenshots_screenshotbucketid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshots_screenshotbucketid_index ON public.screenshots USING btree ("screenshotBucketId");


--
-- Name: screenshots_testid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX screenshots_testid_index ON public.screenshots USING btree ("testId");


--
-- Name: team_users_teamid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX team_users_teamid_index ON public.team_users USING btree ("teamId");


--
-- Name: team_users_userid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX team_users_userid_index ON public.team_users USING btree ("userId");


--
-- Name: teams_githubaccountid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX teams_githubaccountid_index ON public.teams USING btree ("githubAccountId");


--
-- Name: teams_slug_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX teams_slug_index ON public.teams USING btree (slug);


--
-- Name: tests_projectid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tests_projectid_index ON public.tests USING btree ("projectId");


--
-- Name: users_githubid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_githubid_index ON public.users USING btree ("githubId");


--
-- Name: users_slug_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_slug_index ON public.users USING btree (slug);


--
-- Name: accounts accounts_forcedplanid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_forcedplanid_foreign FOREIGN KEY ("forcedPlanId") REFERENCES public.plans(id);


--
-- Name: accounts accounts_teamid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_teamid_foreign FOREIGN KEY ("teamId") REFERENCES public.teams(id);


--
-- Name: accounts accounts_userid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_userid_foreign FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: build_notifications build_notifications_buildid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.build_notifications
    ADD CONSTRAINT build_notifications_buildid_foreign FOREIGN KEY ("buildId") REFERENCES public.builds(id);


--
-- Name: builds builds_basescreenshotbucketid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_basescreenshotbucketid_foreign FOREIGN KEY ("baseScreenshotBucketId") REFERENCES public.screenshot_buckets(id);


--
-- Name: builds builds_comparescreenshotbucketid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_comparescreenshotbucketid_foreign FOREIGN KEY ("compareScreenshotBucketId") REFERENCES public.screenshot_buckets(id);


--
-- Name: builds builds_projectid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.builds
    ADD CONSTRAINT builds_projectid_foreign FOREIGN KEY ("projectId") REFERENCES public.projects(id);


--
-- Name: captures captures_crawlid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.captures
    ADD CONSTRAINT captures_crawlid_foreign FOREIGN KEY ("crawlId") REFERENCES public.crawls(id);


--
-- Name: captures captures_fileid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.captures
    ADD CONSTRAINT captures_fileid_foreign FOREIGN KEY ("fileId") REFERENCES public.files(id);


--
-- Name: captures captures_screenshotid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.captures
    ADD CONSTRAINT captures_screenshotid_foreign FOREIGN KEY ("screenshotId") REFERENCES public.screenshots(id);


--
-- Name: crawls crawls_buildid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crawls
    ADD CONSTRAINT crawls_buildid_foreign FOREIGN KEY ("buildId") REFERENCES public.builds(id);


--
-- Name: github_accounts github_accounts_githuborganizationid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_accounts
    ADD CONSTRAINT github_accounts_githuborganizationid_foreign FOREIGN KEY ("githubOrganizationId") REFERENCES public.github_organizations(id);


--
-- Name: github_accounts github_accounts_githubuserid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_accounts
    ADD CONSTRAINT github_accounts_githubuserid_foreign FOREIGN KEY ("githubUserId") REFERENCES public.github_users(id);


--
-- Name: github_installation_users github_installation_users_githubinstallationid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_installation_users
    ADD CONSTRAINT github_installation_users_githubinstallationid_foreign FOREIGN KEY ("githubInstallationId") REFERENCES public.github_installations(id);


--
-- Name: github_installation_users github_installation_users_githubuserid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_installation_users
    ADD CONSTRAINT github_installation_users_githubuserid_foreign FOREIGN KEY ("githubUserId") REFERENCES public.github_users(id);


--
-- Name: github_repositories github_repositories_githubaccountid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repositories
    ADD CONSTRAINT github_repositories_githubaccountid_foreign FOREIGN KEY ("githubAccountId") REFERENCES public.github_accounts(id);


--
-- Name: github_repository_installations github_repository_installations_githubinstallationid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repository_installations
    ADD CONSTRAINT github_repository_installations_githubinstallationid_foreign FOREIGN KEY ("githubInstallationId") REFERENCES public.github_installations(id);


--
-- Name: github_repository_installations github_repository_installations_githubrepositoryid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_repository_installations
    ADD CONSTRAINT github_repository_installations_githubrepositoryid_foreign FOREIGN KEY ("githubRepositoryId") REFERENCES public.github_repositories(id);


--
-- Name: github_synchronizations github_synchronizations_githubinstallationid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.github_synchronizations
    ADD CONSTRAINT github_synchronizations_githubinstallationid_foreign FOREIGN KEY ("githubInstallationId") REFERENCES public.github_installations(id);


--
-- Name: projects projects_accountid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_accountid_foreign FOREIGN KEY ("accountId") REFERENCES public.accounts(id);


--
-- Name: projects projects_githubrepositoryid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_githubrepositoryid_foreign FOREIGN KEY ("githubRepositoryId") REFERENCES public.github_repositories(id);


--
-- Name: purchases purchases_accountid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_accountid_foreign FOREIGN KEY ("accountId") REFERENCES public.accounts(id);


--
-- Name: purchases purchases_planid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_planid_foreign FOREIGN KEY ("planId") REFERENCES public.plans(id);


--
-- Name: purchases purchases_purchaserid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_purchaserid_foreign FOREIGN KEY ("purchaserId") REFERENCES public.users(id);


--
-- Name: screenshot_buckets screenshot_buckets_projectid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_buckets
    ADD CONSTRAINT screenshot_buckets_projectid_foreign FOREIGN KEY ("projectId") REFERENCES public.projects(id);


--
-- Name: screenshot_diffs screenshot_diffs_basescreenshotid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_diffs
    ADD CONSTRAINT screenshot_diffs_basescreenshotid_foreign FOREIGN KEY ("baseScreenshotId") REFERENCES public.screenshots(id);


--
-- Name: screenshot_diffs screenshot_diffs_buildid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_diffs
    ADD CONSTRAINT screenshot_diffs_buildid_foreign FOREIGN KEY ("buildId") REFERENCES public.builds(id);


--
-- Name: screenshot_diffs screenshot_diffs_comparescreenshotid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_diffs
    ADD CONSTRAINT screenshot_diffs_comparescreenshotid_foreign FOREIGN KEY ("compareScreenshotId") REFERENCES public.screenshots(id);


--
-- Name: screenshot_diffs screenshot_diffs_fileid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_diffs
    ADD CONSTRAINT screenshot_diffs_fileid_foreign FOREIGN KEY ("fileId") REFERENCES public.files(id);


--
-- Name: screenshot_diffs screenshot_diffs_testid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshot_diffs
    ADD CONSTRAINT screenshot_diffs_testid_foreign FOREIGN KEY ("testId") REFERENCES public.tests(id);


--
-- Name: screenshots screenshots_fileid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshots
    ADD CONSTRAINT screenshots_fileid_foreign FOREIGN KEY ("fileId") REFERENCES public.files(id);


--
-- Name: screenshots screenshots_screenshotbucketid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshots
    ADD CONSTRAINT screenshots_screenshotbucketid_foreign FOREIGN KEY ("screenshotBucketId") REFERENCES public.screenshot_buckets(id);


--
-- Name: screenshots screenshots_testid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screenshots
    ADD CONSTRAINT screenshots_testid_foreign FOREIGN KEY ("testId") REFERENCES public.tests(id);


--
-- Name: team_users team_users_teamid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_users
    ADD CONSTRAINT team_users_teamid_foreign FOREIGN KEY ("teamId") REFERENCES public.teams(id);


--
-- Name: team_users team_users_userid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_users
    ADD CONSTRAINT team_users_userid_foreign FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: teams teams_githubaccountid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_githubaccountid_foreign FOREIGN KEY ("githubAccountId") REFERENCES public.github_accounts(id);


--
-- Name: tests tests_projectid_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_projectid_foreign FOREIGN KEY ("projectId") REFERENCES public.projects(id);


--
-- PostgreSQL database dump complete
--

-- Knex migrations

INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20161217154940_init.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170128163909_screenshot_buckets_drop_column_jobStatus.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170128165351_builds_alter_column_baseScreenshotBucketId.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170128165352_screenshot_diffs_alter_column_score.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170128165353_screenshot_diffs_alter_column_score.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170129135917_link_repositories.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170129213906_screenshot_diffs_add_column_s3id.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170205204435_organization-repository.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170211133332_add_table_synchronizations.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170211153730_users_add_column_accessToken.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170211165500_create_table_user_organization_rights.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170211165501_create_table_user_repository_rights.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170212091412_users_email_remove_not_null.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170212092004_add_column_userId_to_repositories.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170212102433_repositories_alter_column_organization_id.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170222000548_users_name_login.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170222000549_builds_number.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170222222346_add_jobStatus_to_builds.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170304184220_add_constraints.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170304184221_remove_constraints.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170305095107_notifications.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170306205356_new-notifications.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170312191852_users_add_private_enabled.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170312202055_repositories_add_column_private.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170312230324_organizations_login.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170319114827_add_github_scopes_to_users.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170329213934_allow_null_baseScreenshotIds.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170402203440_repository_baseline_branch.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20170628232300_add_scopes_to_users.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20180323213911_screenshot_batches.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20181017110213_indexes.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20190919113147_bucket-status.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20190919154131_job_status_aborted.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20200329104003_github-app.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20200329194617_build-notifications.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20200616135126_build-name.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220803095315_add_plans.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220809113257_add_purchase_end_date.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220812142703_files.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220814071435_screenshot_diffs_indexes.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220902165449_repository_github_default_branch.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220905174153_remove_use_default_branch.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220909111750_add_build_type.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220912221410_add_build_parallel_total.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220918102241_fix_accounts_only_one_non_null_constraint.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220918153730_add_old_build_type.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220919175105_nullable_compare_screenshot_id.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220921142914_remove.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20220927074934_add_missing_accounts.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20221013113904_add_forced_plan.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20221104162900_add_files_dimensions.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20221123165000_add_indexes.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20221203103833_installation_token.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20221213130347_stripe.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20221228140518_add_missing_accounts.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230102064502_add_forced_private.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230103095309_add_pr_number.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230218100910_add_stability_score.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230313131422_add_tests_table.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230323071510_add_mute_to_tests.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230416201920_crawls.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230417193649_isolate.js', 1, NOW());
INSERT INTO public.knex_migrations(name, batch, migration_time) VALUES ('20230418095958_project-not-null.js', 1, NOW());