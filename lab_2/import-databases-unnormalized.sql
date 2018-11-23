-- Adminer 4.6.3 PostgreSQL dump


DROP TABLE IF EXISTS "customer";
CREATE TABLE "public"."customer" (
    "custno" integer NOT NULL,
    "cust_name" text NOT NULL,
    "cust_addr" text NOT NULL,
    "cust_phone" text NOT NULL,
    "artist_id" integer NOT NULL,
    "artist_name" text NOT NULL,
    "art_code" integer NOT NULL,
    "art_title" text NOT NULL,
    "pur_date" date NOT NULL,
    "price" integer NOT NULL
) WITH (oids = false);
