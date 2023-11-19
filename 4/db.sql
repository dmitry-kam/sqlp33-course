--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

-- Started on 2023-11-15 21:56:19

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 17309)
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    id integer NOT NULL,
    city_id integer,
    address character varying,
    coordinates point
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17308)
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.addresses ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 216 (class 1259 OID 17292)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 17291)
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cities ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 252 (class 1259 OID 17569)
-- Name: decommissioned_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.decommissioned_product (
    id integer NOT NULL,
    product_fact_id integer,
    dec_date timestamp without time zone,
    dec_by integer
);


ALTER TABLE public.decommissioned_product OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17568)
-- Name: decommissioned_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.decommissioned_product ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.decommissioned_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 17337)
-- Name: pharmacies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pharmacies (
    id integer NOT NULL,
    name character varying,
    boss_id integer,
    address_id integer
);


ALTER TABLE public.pharmacies OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17336)
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pharmacies ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 17506)
-- Name: drug_analogs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drug_analogs (
    drug_id integer,
    drug_id_analog integer
);


ALTER TABLE public.drug_analogs OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17451)
-- Name: drugs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drugs (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.drugs OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17460)
-- Name: product_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_list (
    id integer NOT NULL,
    drug_id integer,
    manufacture_id integer NOT NULL,
    barcode bigint NOT NULL,
    description text
);


ALTER TABLE public.product_list OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17459)
-- Name: drugs_goods_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.product_list ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.drugs_goods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 17450)
-- Name: drugs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.drugs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.drugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 17355)
-- Name: employee_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_addresses (
    id integer NOT NULL,
    emp_id integer,
    address_id integer,
    date_start date,
    active boolean,
    changedate timestamp without time zone DEFAULT now()
);


ALTER TABLE public.employee_addresses OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17354)
-- Name: employee_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employee_addresses ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.employee_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 17396)
-- Name: employee_positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_positions (
    id integer NOT NULL,
    emp_id integer,
    position_id integer,
    datestart date,
    dateend date,
    pharmacy_id integer
);


ALTER TABLE public.employee_positions OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17395)
-- Name: employee_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employee_positions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.employee_positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 17372)
-- Name: employee_salary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_salary (
    emp_id integer NOT NULL,
    salary integer
);


ALTER TABLE public.employee_salary OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 17624)
-- Name: employee_salary_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_salary_history (
    id integer NOT NULL,
    emp_id integer,
    salary integer,
    change_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.employee_salary_history OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 17623)
-- Name: employee_salary_4scd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employee_salary_history ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.employee_salary_4scd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 17322)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    lastname character varying,
    firstname character varying,
    email character varying NOT NULL,
    birthdate date,
    id integer NOT NULL,
    phone numeric(10,0),
    education character varying
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17321)
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.employees ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 248 (class 1259 OID 17535)
-- Name: loyalty_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loyalty_cards (
    id integer NOT NULL,
    number numeric(10,0) NOT NULL,
    purchases_amount integer,
    valid_until timestamp without time zone,
    discount_percent integer
);


ALTER TABLE public.loyalty_cards OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17534)
-- Name: loyalty_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.loyalty_cards ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.loyalty_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 17443)
-- Name: manufactures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufactures (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.manufactures OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17442)
-- Name: manufactures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.manufactures ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.manufactures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 17383)
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17382)
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.positions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.positions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 17501)
-- Name: product_fact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_fact (
    id integer NOT NULL,
    product_id integer NOT NULL,
    purchase_id integer NOT NULL,
    release_date date NOT NULL,
    expiration_date date NOT NULL,
    amount_purchase integer NOT NULL,
    amount_plan integer,
    discounted boolean
);


ALTER TABLE public.product_fact OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 17500)
-- Name: product_fact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.product_fact ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.product_fact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 241 (class 1259 OID 17478)
-- Name: purchases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases (
    id integer NOT NULL,
    pharmacy_id integer,
    storage_id integer,
    delivery_time timestamp without time zone,
    accepted_by integer,
    order_time timestamp without time zone DEFAULT now(),
    rating integer,
    delivery_amount real
);


ALTER TABLE public.purchases OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17477)
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.purchases ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.purchases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 17530)
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id integer NOT NULL,
    date timestamp without time zone DEFAULT now(),
    sold_by integer,
    loyalty_card_id integer
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17529)
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sales ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 256 (class 1259 OID 17611)
-- Name: shift_statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shift_statuses (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.shift_statuses OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 17610)
-- Name: shift_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.shift_statuses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.shift_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 250 (class 1259 OID 17551)
-- Name: sold_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sold_products (
    id integer NOT NULL,
    sale_id integer,
    product_fact_id integer,
    amount real
);


ALTER TABLE public.sold_products OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17550)
-- Name: sold_products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sold_products ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sold_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 17425)
-- Name: storages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.storages (
    id integer NOT NULL,
    name character varying,
    sup_id integer,
    address_id integer
);


ALTER TABLE public.storages OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17424)
-- Name: storages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.storages ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.storages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 17417)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    name character varying,
    phone numeric(10,0),
    email character varying,
    rating real
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 17635)
-- Name: suppliers_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers_history (
    id integer NOT NULL,
    name character varying,
    phone numeric(10,0),
    email character varying,
    rating real,
    change_date timestamp without time zone DEFAULT now(),
    sup_id integer
);


ALTER TABLE public.suppliers_history OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 17634)
-- Name: suppliers_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.suppliers_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.suppliers_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 17416)
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.suppliers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 254 (class 1259 OID 17595)
-- Name: work_days; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.work_days (
    id integer NOT NULL,
    pharmacy_id integer,
    emp_id integer,
    start timestamp without time zone,
    duration integer,
    shift_status_id integer
);


ALTER TABLE public.work_days OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 17594)
-- Name: work_days_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.work_days ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.work_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 215
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_seq', 1, false);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 251
-- Name: decommissioned_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.decommissioned_product_id_seq', 1, false);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 221
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 1, false);


--
-- TOC entry 5086 (class 0 OID 0)
-- Dependencies: 238
-- Name: drugs_goods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.drugs_goods_id_seq', 1, false);


--
-- TOC entry 5087 (class 0 OID 0)
-- Dependencies: 236
-- Name: drugs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.drugs_id_seq', 1, false);


--
-- TOC entry 5088 (class 0 OID 0)
-- Dependencies: 223
-- Name: employee_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_addresses_id_seq', 1, false);


--
-- TOC entry 5089 (class 0 OID 0)
-- Dependencies: 228
-- Name: employee_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_positions_id_seq', 1, false);


--
-- TOC entry 5090 (class 0 OID 0)
-- Dependencies: 257
-- Name: employee_salary_4scd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_salary_4scd_id_seq', 2, true);


--
-- TOC entry 5091 (class 0 OID 0)
-- Dependencies: 219
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_id_seq', 1, false);


--
-- TOC entry 5092 (class 0 OID 0)
-- Dependencies: 247
-- Name: loyalty_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loyalty_cards_id_seq', 1, false);


--
-- TOC entry 5093 (class 0 OID 0)
-- Dependencies: 234
-- Name: manufactures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manufactures_id_seq', 1, false);


--
-- TOC entry 5094 (class 0 OID 0)
-- Dependencies: 226
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.positions_id_seq', 1, false);


--
-- TOC entry 5095 (class 0 OID 0)
-- Dependencies: 242
-- Name: product_fact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_fact_id_seq', 1, false);


--
-- TOC entry 5096 (class 0 OID 0)
-- Dependencies: 240
-- Name: purchases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchases_id_seq', 1, false);


--
-- TOC entry 5097 (class 0 OID 0)
-- Dependencies: 245
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_id_seq', 1, false);


--
-- TOC entry 5098 (class 0 OID 0)
-- Dependencies: 255
-- Name: shift_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shift_statuses_id_seq', 1, false);


--
-- TOC entry 5099 (class 0 OID 0)
-- Dependencies: 249
-- Name: sold_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sold_products_id_seq', 1, false);


--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 232
-- Name: storages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.storages_id_seq', 1, false);


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 259
-- Name: suppliers_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_history_id_seq', 2, true);


--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 230
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 1, true);


--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 253
-- Name: work_days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_days_id_seq', 1, false);


--
-- TOC entry 4811 (class 2606 OID 17315)
-- Name: addresses addresses_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pk PRIMARY KEY (id);


--
-- TOC entry 4853 (class 2606 OID 17629)
-- Name: employee_salary_history career_pk_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_salary_history
    ADD CONSTRAINT career_pk_1 PRIMARY KEY (id);


--
-- TOC entry 4809 (class 2606 OID 17298)
-- Name: cities cities_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pk PRIMARY KEY (id);


--
-- TOC entry 4847 (class 2606 OID 17575)
-- Name: decommissioned_product decommissioned_product_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decommissioned_product
    ADD CONSTRAINT decommissioned_product_pk PRIMARY KEY (id);


--
-- TOC entry 4817 (class 2606 OID 17343)
-- Name: pharmacies departments_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pharmacies
    ADD CONSTRAINT departments_pk PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 17464)
-- Name: product_list drugs_goods_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_list
    ADD CONSTRAINT drugs_goods_pk PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 17457)
-- Name: drugs drugs_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drugs
    ADD CONSTRAINT drugs_pk PRIMARY KEY (id);


--
-- TOC entry 4819 (class 2606 OID 17360)
-- Name: employee_addresses employee_addresses_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_addresses
    ADD CONSTRAINT employee_addresses_pk PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 17400)
-- Name: employee_positions employee_positions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_positions
    ADD CONSTRAINT employee_positions_pk PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 17633)
-- Name: employee_salary employee_salary_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_salary
    ADD CONSTRAINT employee_salary_pk PRIMARY KEY (emp_id);


--
-- TOC entry 4813 (class 2606 OID 17328)
-- Name: employees employees_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pk PRIMARY KEY (id);


--
-- TOC entry 4815 (class 2606 OID 17330)
-- Name: employees employees_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_un UNIQUE (email);


--
-- TOC entry 4843 (class 2606 OID 17539)
-- Name: loyalty_cards loyalty_cards_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loyalty_cards
    ADD CONSTRAINT loyalty_cards_pk PRIMARY KEY (id);


--
-- TOC entry 4831 (class 2606 OID 17449)
-- Name: manufactures manufactures_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufactures
    ADD CONSTRAINT manufactures_pk PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 17389)
-- Name: positions positions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pk PRIMARY KEY (id);


--
-- TOC entry 4839 (class 2606 OID 17505)
-- Name: product_fact product_fact_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_fact
    ADD CONSTRAINT product_fact_pk PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 17483)
-- Name: purchases purchases_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_pk PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 17562)
-- Name: sales sales_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);


--
-- TOC entry 4851 (class 2606 OID 17617)
-- Name: shift_statuses shift_statuses_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_statuses
    ADD CONSTRAINT shift_statuses_pk PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 17555)
-- Name: sold_products sold_products_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sold_products
    ADD CONSTRAINT sold_products_pk PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 17431)
-- Name: storages storages_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_pk PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 17423)
-- Name: suppliers suppliers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 17642)
-- Name: suppliers_history suppliers_pk_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers_history
    ADD CONSTRAINT suppliers_pk_1 PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 17599)
-- Name: work_days work_days_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_days
    ADD CONSTRAINT work_days_pk PRIMARY KEY (id);


--
-- TOC entry 4856 (class 2606 OID 17316)
-- Name: addresses addresses_fk_city; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_fk_city FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- TOC entry 4880 (class 2606 OID 17585)
-- Name: decommissioned_product decommissioned_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decommissioned_product
    ADD CONSTRAINT decommissioned_product_fk FOREIGN KEY (product_fact_id) REFERENCES public.product_fact(id);


--
-- TOC entry 4881 (class 2606 OID 17576)
-- Name: decommissioned_product decommissioned_product_fk_emp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.decommissioned_product
    ADD CONSTRAINT decommissioned_product_fk_emp FOREIGN KEY (dec_by) REFERENCES public.employees(id);


--
-- TOC entry 4857 (class 2606 OID 17344)
-- Name: pharmacies departments_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pharmacies
    ADD CONSTRAINT departments_fk FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- TOC entry 4858 (class 2606 OID 17349)
-- Name: pharmacies departments_fk_boss; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pharmacies
    ADD CONSTRAINT departments_fk_boss FOREIGN KEY (boss_id) REFERENCES public.employees(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4874 (class 2606 OID 17509)
-- Name: drug_analogs drug_analogs_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug_analogs
    ADD CONSTRAINT drug_analogs_fk_1 FOREIGN KEY (drug_id) REFERENCES public.drugs(id);


--
-- TOC entry 4875 (class 2606 OID 17514)
-- Name: drug_analogs drug_analogs_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drug_analogs
    ADD CONSTRAINT drug_analogs_fk_2 FOREIGN KEY (drug_id_analog) REFERENCES public.drugs(id);


--
-- TOC entry 4867 (class 2606 OID 17470)
-- Name: product_list drugs_goods_fk_drug; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_list
    ADD CONSTRAINT drugs_goods_fk_drug FOREIGN KEY (drug_id) REFERENCES public.drugs(id);


--
-- TOC entry 4868 (class 2606 OID 17465)
-- Name: product_list drugs_goods_fk_man; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_list
    ADD CONSTRAINT drugs_goods_fk_man FOREIGN KEY (manufacture_id) REFERENCES public.manufactures(id);


--
-- TOC entry 4859 (class 2606 OID 17361)
-- Name: employee_addresses employee_addresses_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_addresses
    ADD CONSTRAINT employee_addresses_fk FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- TOC entry 4860 (class 2606 OID 17366)
-- Name: employee_addresses employee_addresses_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_addresses
    ADD CONSTRAINT employee_addresses_fk_1 FOREIGN KEY (emp_id) REFERENCES public.employees(id);


--
-- TOC entry 4862 (class 2606 OID 17401)
-- Name: employee_positions employee_positions_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_positions
    ADD CONSTRAINT employee_positions_fk FOREIGN KEY (position_id) REFERENCES public.positions(id);


--
-- TOC entry 4863 (class 2606 OID 17406)
-- Name: employee_positions employee_positions_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_positions
    ADD CONSTRAINT employee_positions_fk_1 FOREIGN KEY (emp_id) REFERENCES public.employees(id);


--
-- TOC entry 4864 (class 2606 OID 17411)
-- Name: employee_positions employee_positions_fk_pharm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_positions
    ADD CONSTRAINT employee_positions_fk_pharm FOREIGN KEY (pharmacy_id) REFERENCES public.pharmacies(id);


--
-- TOC entry 4861 (class 2606 OID 17377)
-- Name: employee_salary employee_salary_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_salary
    ADD CONSTRAINT employee_salary_fk FOREIGN KEY (emp_id) REFERENCES public.employees(id);


--
-- TOC entry 4872 (class 2606 OID 17519)
-- Name: product_fact product_fact_fk_prod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_fact
    ADD CONSTRAINT product_fact_fk_prod FOREIGN KEY (product_id) REFERENCES public.product_list(id);


--
-- TOC entry 4873 (class 2606 OID 17524)
-- Name: product_fact product_fact_fk_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_fact
    ADD CONSTRAINT product_fact_fk_purchase FOREIGN KEY (purchase_id) REFERENCES public.purchases(id);


--
-- TOC entry 4869 (class 2606 OID 17484)
-- Name: purchases purchases_fk_emp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_fk_emp FOREIGN KEY (accepted_by) REFERENCES public.employees(id);


--
-- TOC entry 4870 (class 2606 OID 17494)
-- Name: purchases purchases_fk_ph; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_fk_ph FOREIGN KEY (pharmacy_id) REFERENCES public.pharmacies(id);


--
-- TOC entry 4871 (class 2606 OID 17489)
-- Name: purchases purchases_fk_store; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchases_fk_store FOREIGN KEY (storage_id) REFERENCES public.storages(id);


--
-- TOC entry 4876 (class 2606 OID 17540)
-- Name: sales sales_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_fk FOREIGN KEY (sold_by) REFERENCES public.employees(id);


--
-- TOC entry 4877 (class 2606 OID 17545)
-- Name: sales sales_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_fk_1 FOREIGN KEY (loyalty_card_id) REFERENCES public.loyalty_cards(id);


--
-- TOC entry 4878 (class 2606 OID 17556)
-- Name: sold_products sold_products_fk_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sold_products
    ADD CONSTRAINT sold_products_fk_product FOREIGN KEY (product_fact_id) REFERENCES public.product_fact(id);


--
-- TOC entry 4879 (class 2606 OID 17563)
-- Name: sold_products sold_products_fk_sale; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sold_products
    ADD CONSTRAINT sold_products_fk_sale FOREIGN KEY (sale_id) REFERENCES public.sales(id);


--
-- TOC entry 4865 (class 2606 OID 17437)
-- Name: storages storages_fk_addr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_fk_addr FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- TOC entry 4866 (class 2606 OID 17432)
-- Name: storages storages_fk_sup; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_fk_sup FOREIGN KEY (sup_id) REFERENCES public.suppliers(id);


--
-- TOC entry 4882 (class 2606 OID 17600)
-- Name: work_days work_days_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_days
    ADD CONSTRAINT work_days_fk FOREIGN KEY (pharmacy_id) REFERENCES public.pharmacies(id);


--
-- TOC entry 4883 (class 2606 OID 17605)
-- Name: work_days work_days_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_days
    ADD CONSTRAINT work_days_fk_1 FOREIGN KEY (emp_id) REFERENCES public.employees(id);


--
-- TOC entry 4884 (class 2606 OID 17618)
-- Name: work_days work_days_fk_shift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.work_days
    ADD CONSTRAINT work_days_fk_shift FOREIGN KEY (shift_status_id) REFERENCES public.shift_statuses(id);


-- Completed on 2023-11-15 21:56:20

--
-- PostgreSQL database dump complete
--
