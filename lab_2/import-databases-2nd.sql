
CREATE TABLE public.art(
	art_code integer NOT NULL DEFAULT nextval('public.art_art_code_seq'::regclass),
	art_title text NOT NULL,
	artist_id integer NOT NULL,
	artist_name text NOT NULL,
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
	CONSTRAINT purchase_pk PRIMARY KEY (cust_no,art_code,pur_date)

);

ALTER TABLE public.purchase ADD CONSTRAINT purchase_cust_no_fk FOREIGN KEY (cust_no)
REFERENCES public.customer (custno) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE public.purchase ADD CONSTRAINT purchase_art_code_fk FOREIGN KEY (art_code)
REFERENCES public.art (art_code) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;


