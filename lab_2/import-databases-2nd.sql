
DROP TABLE IF EXISTS "art";
DROP SEQUENCE IF EXISTS art_art_code_seq;
CREATE SEQUENCE art_art_code_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."art" (
    "art_code" integer DEFAULT nextval('art_art_code_seq') NOT NULL,
    "art_title" text NOT NULL,
    "artist_id" integer NOT NULL,
    "artist_name" text NOT NULL
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
    "price" integer NOT NULL
) WITH (oids = false);
