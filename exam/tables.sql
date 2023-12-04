--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Ubuntu 15.1-1.pgdg20.04+1)
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-04 20:21:57

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'WIN1251';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 10 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 10
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 1212 (class 1247 OID 28574)
-- Name: courier_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.courier_status_enum AS ENUM (
    'В очереди',
    'Выполняется',
    'Выполнено',
    'Отменен'
);


ALTER TYPE public.courier_status_enum OWNER TO postgres;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 269 (class 1259 OID 28592)
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public.account OWNER TO postgres;

CREATE TABLE public.contact (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    last_name character varying(20) NOT NULL,
    first_name character varying(15) NOT NULL,
    account_id uuid NOT NULL
);

CREATE TABLE public."user" (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    last_name character varying(20) NOT NULL,
    first_name character varying(15) NOT NULL,
    dismissed boolean DEFAULT false NOT NULL
);

CREATE TABLE public.courier (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    from_place character varying(80) NOT NULL,
    where_place character varying(80) NOT NULL,
    name character varying(30) NOT NULL,
    account_id uuid NOT NULL,
    contact_id uuid NOT NULL,
    description text,
    user_id uuid NOT NULL,
    status public.courier_status_enum DEFAULT 'В очереди'::public.courier_status_enum NOT NULL,
    created_date date DEFAULT now()
);

