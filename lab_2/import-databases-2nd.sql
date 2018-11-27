-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.0-beta
-- PostgreSQL version: 9.4
-- Project Site: pgmodeler.com.br
-- Model Author: ---

-- object: homestead | type: ROLE --
-- DROP ROLE IF EXISTS homestead;
CREATE ROLE homestead WITH 
	SUPERUSER
	CREATEDB
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD '********';
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: gil_art_2nd_nf | type: DATABASE --
-- -- DROP DATABASE IF EXISTS gil_art_2nd_nf;
-- CREATE DATABASE gil_art_2nd_nf
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'en_US.UTF-8'
-- 	LC_CTYPE = 'en_US.UTF-8'
-- 	TABLESPACE = pg_default
-- 	OWNER = homestead
-- ;
-- -- ddl-end --
-- 

-- object: public.art_art_code_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.art_art_code_seq CASCADE;
CREATE SEQUENCE public.art_art_code_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.art_art_code_seq OWNER TO homestead;
-- ddl-end --

-- object: public.art | type: TABLE --
-- DROP TABLE IF EXISTS public.art CASCADE;
CREATE TABLE public.art(
	art_code integer NOT NULL DEFAULT nextval('public.art_art_code_seq'::regclass),
	art_title text NOT NULL,
	artist_id integer NOT NULL,
	artist_name text NOT NULL,
	CONSTRAINT art_pk PRIMARY KEY (art_code)

);
-- ddl-end --
ALTER TABLE public.art OWNER TO homestead;
-- ddl-end --

-- object: public.customer | type: TABLE --
-- DROP TABLE IF EXISTS public.customer CASCADE;
CREATE TABLE public.customer(
	custno integer NOT NULL,
	cust_name text NOT NULL,
	cust_addr text NOT NULL,
	cust_phone text NOT NULL,
	CONSTRAINT customer_custno PRIMARY KEY (custno)

);
-- ddl-end --
ALTER TABLE public.customer OWNER TO homestead;
-- ddl-end --

-- object: public.purchase | type: TABLE --
-- DROP TABLE IF EXISTS public.purchase CASCADE;
CREATE TABLE public.purchase(
	cust_no integer NOT NULL,
	art_code integer NOT NULL,
	pur_date date NOT NULL,
	price integer NOT NULL,
	CONSTRAINT purchase_pk PRIMARY KEY (cust_no,art_code,pur_date)

);
-- ddl-end --
ALTER TABLE public.purchase OWNER TO homestead;
-- ddl-end --

-- object: purchase_cust_no_fk | type: CONSTRAINT --
-- ALTER TABLE public.purchase DROP CONSTRAINT IF EXISTS purchase_cust_no_fk CASCADE;
ALTER TABLE public.purchase ADD CONSTRAINT purchase_cust_no_fk FOREIGN KEY (cust_no)
REFERENCES public.customer (custno) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: purchase_art_code_fk | type: CONSTRAINT --
-- ALTER TABLE public.purchase DROP CONSTRAINT IF EXISTS purchase_art_code_fk CASCADE;
ALTER TABLE public.purchase ADD CONSTRAINT purchase_art_code_fk FOREIGN KEY (art_code)
REFERENCES public.art (art_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


