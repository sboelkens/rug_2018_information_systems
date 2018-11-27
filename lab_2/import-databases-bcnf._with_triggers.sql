-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.0-beta
-- PostgreSQL version: 9.4
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --

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
-- -- object: gil_art_3rd_nf | type: DATABASE --
-- -- DROP DATABASE IF EXISTS gil_art_3rd_nf;
-- CREATE DATABASE gil_art_3rd_nf
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'en_US.UTF-8'
-- 	LC_CTYPE = 'en_US.UTF-8'
-- 	TABLESPACE = pg_default
-- 	OWNER = homestead
-- ;
-- -- ddl-end --
-- 

-- object: public.artist_artist_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.artist_artist_id_seq CASCADE;
CREATE SEQUENCE public.artist_artist_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE public.artist_artist_id_seq OWNER TO homestead;
-- ddl-end --

-- object: public.artist | type: TABLE --
-- DROP TABLE IF EXISTS public.artist CASCADE;
CREATE TABLE public.artist(
	artist_id integer NOT NULL DEFAULT nextval('public.artist_artist_id_seq'::regclass),
	artist_name text NOT NULL,
	CONSTRAINT artist_artist_id PRIMARY KEY (artist_id)

);
-- ddl-end --
ALTER TABLE public.artist OWNER TO homestead;
-- ddl-end --

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
	CONSTRAINT purchase_pkey PRIMARY KEY (cust_no,art_code,pur_date)

);
-- ddl-end --
ALTER TABLE public.purchase OWNER TO homestead;
-- ddl-end --

-- object: public.uppercase_cust_name_on_insert | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.uppercase_cust_name_on_insert() CASCADE;
CREATE FUNCTION public.uppercase_cust_name_on_insert ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

    BEGIN        
        NEW.cust_name = UPPER(NEW.cust_name);
        RETURN NEW;
    END;

$$;
-- ddl-end --
ALTER FUNCTION public.uppercase_cust_name_on_insert() OWNER TO homestead;
-- ddl-end --

-- object: uppercase_cust_name_on_insert | type: TRIGGER --
-- DROP TRIGGER IF EXISTS uppercase_cust_name_on_insert ON public.customer CASCADE;
CREATE TRIGGER uppercase_cust_name_on_insert
	BEFORE INSERT OR UPDATE
	ON public.customer
	FOR EACH ROW
	EXECUTE PROCEDURE public.uppercase_cust_name_on_insert();
-- ddl-end --

-- object: public.uppercase_artist_name_on_insert | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.uppercase_artist_name_on_insert() CASCADE;
CREATE FUNCTION public.uppercase_artist_name_on_insert ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

    BEGIN        
        NEW.artist_name = UPPER(NEW.artist_name);
        RETURN NEW;
    END;

$$;
-- ddl-end --
ALTER FUNCTION public.uppercase_artist_name_on_insert() OWNER TO homestead;
-- ddl-end --

-- object: uppercase_artist_name_on_insert_trigger | type: TRIGGER --
-- DROP TRIGGER IF EXISTS uppercase_artist_name_on_insert_trigger ON public.artist CASCADE;
CREATE TRIGGER uppercase_artist_name_on_insert_trigger
	BEFORE INSERT OR UPDATE
	ON public.artist
	FOR EACH ROW
	EXECUTE PROCEDURE public.uppercase_artist_name_on_insert();
-- ddl-end --

-- object: public.validate_price_on_insert | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.validate_price_on_insert() CASCADE;
CREATE FUNCTION public.validate_price_on_insert ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

    BEGIN
        IF NEW.price = 0 THEN
            RAISE EXCEPTION 'The price should not be %', NEW.price;
        END IF;
        RETURN NEW;
    END;

$$;
-- ddl-end --
ALTER FUNCTION public.validate_price_on_insert() OWNER TO homestead;
-- ddl-end --

-- object: validate_price_on_insert_trigger | type: TRIGGER --
-- DROP TRIGGER IF EXISTS validate_price_on_insert_trigger ON public.purchase CASCADE;
CREATE TRIGGER validate_price_on_insert_trigger
	BEFORE INSERT OR UPDATE
	ON public.purchase
	FOR EACH ROW
	EXECUTE PROCEDURE public.validate_price_on_insert();
-- ddl-end --

-- object: art_artist_id_fkey | type: CONSTRAINT --
-- ALTER TABLE public.art DROP CONSTRAINT IF EXISTS art_artist_id_fkey CASCADE;
ALTER TABLE public.art ADD CONSTRAINT art_artist_id_fkey FOREIGN KEY (artist_id)
REFERENCES public.artist (artist_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: purchase_cust_no_fkey | type: CONSTRAINT --
-- ALTER TABLE public.purchase DROP CONSTRAINT IF EXISTS purchase_cust_no_fkey CASCADE;
ALTER TABLE public.purchase ADD CONSTRAINT purchase_cust_no_fkey FOREIGN KEY (cust_no)
REFERENCES public.customer (custno) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: purchase_art_code_fk | type: CONSTRAINT --
-- ALTER TABLE public.purchase DROP CONSTRAINT IF EXISTS purchase_art_code_fk CASCADE;
ALTER TABLE public.purchase ADD CONSTRAINT purchase_art_code_fk FOREIGN KEY (art_code)
REFERENCES public.art (art_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


