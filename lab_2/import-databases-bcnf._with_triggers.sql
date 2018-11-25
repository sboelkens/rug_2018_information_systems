


DROP TABLE IF EXISTS "artist";
DROP SEQUENCE IF EXISTS artist_artist_id_seq;
CREATE SEQUENCE artist_artist_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."artist" (
    "artist_id" integer DEFAULT nextval('artist_artist_id_seq') NOT NULL,
    "artist_name" text NOT NULL,
    CONSTRAINT "artist_artist_id" PRIMARY KEY ("artist_id")
) WITH (oids = false);

DROP TABLE IF EXISTS "art";
DROP SEQUENCE IF EXISTS art_art_code_seq;
CREATE SEQUENCE art_art_code_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."art" (
    "art_code" integer DEFAULT nextval('art_art_code_seq') NOT NULL,
    "art_title" text NOT NULL,
    "artist_id" integer NOT NULL,
    CONSTRAINT "art_artist_id_fkey" FOREIGN KEY (artist_id) REFERENCES artist(artist_id) NOT DEFERRABLE
) WITH (oids = false);



DROP TABLE IF EXISTS "customer";
CREATE TABLE "public"."customer" (
    "custno" integer NOT NULL,
    "cust_name" text NOT NULL,
    CONSTRAINT "customer_custno" PRIMARY KEY ("custno")
) WITH (oids = false);

DROP TABLE IF EXISTS "address";
CREATE TABLE "public"."address" (
    "custno" integer NOT NULL,
    "cust_addr" text NOT NULL,
	CONSTRAINT "address_custno_fkey" FOREIGN KEY (custno) REFERENCES customer(custno) NOT DEFERRABLE
) WITH (oids = false);

DROP TABLE IF EXISTS "phone";
CREATE TABLE "public"."phone" (
    "custno" integer NOT NULL,
    "cust_phone" text NOT NULL,
	CONSTRAINT "phone_custno_fkey" FOREIGN KEY (custno) REFERENCES customer(custno) NOT DEFERRABLE
) WITH (oids = false);


DROP TABLE IF EXISTS "purchase";
CREATE TABLE "public"."purchase" (
    "cust_no" integer NOT NULL,
    "art_code" integer NOT NULL,
    "pur_date" date NOT NULL,
    "price" integer NOT NULL,
    CONSTRAINT "purchase_pkey" PRIMARY KEY ("cust_no", "art_code", "pur_date"),
    CONSTRAINT "purchase_cust_no_fkey" FOREIGN KEY (cust_no) REFERENCES customer(custno) NOT DEFERRABLE
) WITH (oids = false);


CREATE OR REPLACE FUNCTION uppercase_cust_name_on_insert() RETURNS trigger AS $uppercase_cust_name_on_insert$
    BEGIN        
        NEW.cust_name = UPPER(NEW.cust_name);
        RETURN NEW;
    END;
$uppercase_cust_name_on_insert$ LANGUAGE plpgsql;

CREATE TRIGGER uppercase_cust_name_on_insert BEFORE INSERT OR UPDATE ON customer
    FOR EACH ROW EXECUTE PROCEDURE uppercase_cust_name_on_insert();


CREATE OR REPLACE FUNCTION uppercase_artist_name_on_insert() RETURNS trigger AS $uppercase_artist_name_on_insert$
    BEGIN        
        NEW.artist_name = UPPER(NEW.artist_name);
        RETURN NEW;
    END;
$uppercase_artist_name_on_insert$ LANGUAGE plpgsql;

CREATE TRIGGER uppercase_artist_name_on_insert_trigger BEFORE INSERT OR UPDATE ON artist
    FOR EACH ROW EXECUTE PROCEDURE uppercase_artist_name_on_insert();


CREATE OR REPLACE FUNCTION validate_price_on_insert() 
RETURNS trigger AS $validate_price_on_insert$
    BEGIN
        IF NEW.price = 0 THEN
            RAISE EXCEPTION 'The price should not be %', NEW.price;
        END IF;
        RETURN NEW;
    END;
$validate_price_on_insert$ LANGUAGE plpgsql;

CREATE TRIGGER validate_price_on_insert_trigger BEFORE INSERT OR UPDATE ON purchase
    FOR EACH ROW EXECUTE PROCEDURE  validate_price_on_insert();




