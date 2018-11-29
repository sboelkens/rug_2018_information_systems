
CREATE SEQUENCE public.artist_artist_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

CREATE TABLE public.artist(
	artist_id integer NOT NULL DEFAULT nextval('public.artist_artist_id_seq'::regclass),
	artist_name text NOT NULL,
	CONSTRAINT artist_artist_id PRIMARY KEY (artist_id)

);
CREATE SEQUENCE public.art_art_code_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;

CREATE TABLE public.art(
	art_code integer NOT NULL DEFAULT nextval('public.art_art_code_seq'::regclass),
	art_title text NOT NULL,
	artist_id integer NOT NULL,
	CONSTRAINT art_pk PRIMARY KEY (art_code)

);
CREATE TABLE public.customer(
	custno integer NOT NULL,
	cust_name text NOT NULL,
	cust_addr text NOT NULL,
	cust_phone text NOT NULL,
	CONSTRAINT customer_custno PRIMARY KEY (custno)

);

CREATE TABLE public.purchase(
	cust_no integer NOT NULL,
	art_code integer NOT NULL,
	pur_date date NOT NULL,
	price integer NOT NULL,
	CONSTRAINT purchase_pkey PRIMARY KEY (cust_no,art_code,pur_date)

);

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

CREATE TRIGGER uppercase_cust_name_on_insert
	BEFORE INSERT OR UPDATE
	ON public.customer
	FOR EACH ROW
	EXECUTE PROCEDURE public.uppercase_cust_name_on_insert();

	
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

CREATE TRIGGER uppercase_artist_name_on_insert_trigger
	BEFORE INSERT OR UPDATE
	ON public.artist
	FOR EACH ROW
	EXECUTE PROCEDURE public.uppercase_artist_name_on_insert();

	
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

CREATE TRIGGER validate_price_on_insert_trigger
	BEFORE INSERT OR UPDATE
	ON public.purchase
	FOR EACH ROW
	EXECUTE PROCEDURE public.validate_price_on_insert();
	
ALTER TABLE public.art ADD CONSTRAINT art_artist_id_fkey FOREIGN KEY (artist_id)
REFERENCES public.artist (artist_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;


ALTER TABLE public.purchase ADD CONSTRAINT purchase_cust_no_fkey FOREIGN KEY (cust_no)
REFERENCES public.customer (custno) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;


ALTER TABLE public.purchase ADD CONSTRAINT purchase_art_code_fk FOREIGN KEY (art_code)
REFERENCES public.art (art_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;


