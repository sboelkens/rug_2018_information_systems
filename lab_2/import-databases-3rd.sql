
DROP TABLE IF EXISTS "art";
DROP SEQUENCE IF EXISTS art_art_code_seq;
CREATE SEQUENCE art_art_code_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."art" (
    "art_code" integer DEFAULT nextval('art_art_code_seq') NOT NULL,
    "art_title" text NOT NULL,
    "artist_id" integer NOT NULL,
    CONSTRAINT "art_artist_id_fkey" FOREIGN KEY (artist_id) REFERENCES artist(artist_id) NOT DEFERRABLE
) WITH (oids = false);


DROP TABLE IF EXISTS "artist";
DROP SEQUENCE IF EXISTS artist_artist_id_seq;
CREATE SEQUENCE artist_artist_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."artist" (
    "artist_id" integer DEFAULT nextval('artist_artist_id_seq') NOT NULL,
    "artist_name" text NOT NULL,
    CONSTRAINT "artist_artist_id" PRIMARY KEY ("artist_id")
) WITH (oids = false);


DROP TABLE IF EXISTS "customer";
CREATE TABLE "public"."customer" (
    "custno" integer NOT NULL,
    "cust_name" text NOT NULL,
    "cust_addr" text NOT NULL,
    "cust_phone" text NOT NULL,
    CONSTRAINT "customer_custno" PRIMARY KEY ("custno")
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


