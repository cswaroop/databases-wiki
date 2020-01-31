--
-- PostgreSQL database dump
--

-- Dumped from database version 12beta2
-- Dumped by pg_dump version 12beta2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: razorpay; Type: TABLE; Schema: public; Owner: razorpay
--

CREATE TABLE public.razorpay (
    id integer NOT NULL,
    doc_type text,
    doc jsonb
);


ALTER TABLE public.razorpay OWNER TO razorpay;

--
-- Name: razorpay_id_seq; Type: SEQUENCE; Schema: public; Owner: razorpay
--

CREATE SEQUENCE public.razorpay_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.razorpay_id_seq OWNER TO razorpay;

--
-- Name: razorpay_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: razorpay
--

ALTER SEQUENCE public.razorpay_id_seq OWNED BY public.razorpay.id;


--
-- Name: razorpay id; Type: DEFAULT; Schema: public; Owner: razorpay
--

ALTER TABLE ONLY public.razorpay ALTER COLUMN id SET DEFAULT nextval('public.razorpay_id_seq'::regclass);


--
-- Data for Name: razorpay; Type: TABLE DATA; Schema: public; Owner: razorpay
--

COPY public.razorpay (id, doc_type, doc) FROM stdin;
1	customer	{"id": "cust_0000000001", "name": "Cornelius", "email": "cornelius1990@gmail.com", "notes": {}, "entity": "customer", "contact": "9000000000", "created_at ": 1234567890}
2	order	{"id": "order_DaZlswtdcn9UNV", "notes": [], "amount": 50000, "entity": "order", "status": "created", "receipt": "Receipt #20", "attempts": 0, "currency": "INR", "amount_due": 50000, "created_at": 1572502745, "amount_paid": 0}
3	payment	{"id": "order_DaaS6LOUAASb7Y", "notes": {"key1": "value3", "key2": "value2"}, "amount": 2200, "entity": "order", "status": "attempted", "receipt": "Receipt #211", "attempts": 1, "currency": "INR", "offer_id": null, "amount_due": 2200, "created_at": 1572505143, "amount_paid": 0}
4	payment	{"id": "pay_29QQoUBi66xm2f", "fee": 1145, "tax": 145, "email": "gaurav.kumar@example.com", "notes": [], "amount": 5000, "entity": "payment", "method": "card", "status": "captured", "contact": "9364591752", "currency": "INR", "order_id": "order_CjCr5oKh4AVC51", "created_at": 1400826750, "error_code": null, "description": "Payment for Adidas shoes", "refund_status": null, "amount_refunded": 0, "error_description": null}
5	settlement	{"id": "pay_29QQoUBi66xm2f", "fee": 1145, "tax": 145, "email": "gaurav.kumar@example.com", "notes": [], "amount": 5000, "entity": "payment", "method": "card", "status": "captured", "contact": "9364591752", "currency": "INR", "order_id": "order_CjCr5oKh4AVC51", "created_at": 1400826750, "error_code": null, "description": "Payment for Adidas shoes", "refund_status": null, "amount_refunded": 0, "error_description": null}
6	settlement_recon	{"count": 2, "items": [{"fee": 1250, "tax": 0, "type": "payment", "debit": 0, "notes": "{}", "amount": 59900, "credit": 48750, "method": "card", "on_hold": false, "settled": true, "currency": "INR", "order_id": "order_9rvHBMFeGlrEp4", "card_type": "credit", "entity_id": "pay_9rvIMJo4sJkwB7", "created_at": 1478067659, "dispute_id": null, "payment_id": "pay_9rvIMJo4sJkwB7", "settled_at": 1478075346, "card_issuer": "YESB", "description": "Settlement based on the invoice no. #inv_9rvHBJrv2Oluwh", "card_network": "Visa", "order_receipt": "BILL13375649", "settlement_id": "setl_9uGt8OcMCeAEiR", "settlement_utr": "KKBKH14156891582"}, {"fee": 3, "tax": 0, "type": "payment", "debit": 0, "notes": "{}", "amount": 19900, "credit": 97, "method": "card", "on_hold": false, "settled": true, "currency": "INR", "order_id": "order_9ruGFg9yNKWjfS", "card_type": "credit", "entity_id": "pay_9ruIfMiMmbZ6fx", "created_at": 1478067659, "dispute_id": null, "payment_id": "pay_9ruIfMiMmbZ6fx", "settled_at": 1478075346, "card_issuer": "YESB", "description": "Invoice #inv_9ruFmsK63rBrG7", "card_network": "Visa", "order_receipt": "BILL13375640", "settlement_id": "setl_9uGt8OcMCeAEiR", "settlement_utr": "KKBKH14156891582"}], "entity": "collection"}
7	payment_refunds	{"count": 2, "items": [{"id": "rfnd_AABBdHIieexn5c", "notes": [], "amount": 100, "entity": "refund", "receipt": null, "currency": "INR", "created_at": 1500826750, "payment_id": "pay_29QQoUBi66xm2f", "acquirer_data": {"rrn": "931912812404"}}, {"id": "rfnd_19btGlBig6xZ2f", "notes": [], "amount": 100, "entity": "refund", "receipt": null, "currency": "INR", "created_at": 1500826750, "payment_id": "pay_29QQoUBi66xm2f", "acquirer_data": {"rrn": "931912812404"}}], "entity": "collection"}
8	subscription_plan	{"id": "plan_00000000000001", "item": {"name": "Test Weekly 1 plan", "type": "plan", "active": true, "amount": 600, "currency": "INR", "description": "Description for the weekly 1 plan"}, "notes": {"notes_key": "Beam me up Scotty"}, "entity": "plan", "period": "weekly", "interval": 1, "created_at": 1495995837}
9	subscriptions	{"id": "sub_00000000000001", "notes": {"notes_key": "Beam me up Scotty"}, "end_at": 1603737000, "entity": "subscription", "status": "active", "plan_id": "plan_00000000000001", "ended_at": null, "quantity": 1, "start_at": 1577385991, "charge_at": 1577385991, "expire_by": 1577485991, "short_url": "https://rzp.io/i/z3b1R61A9", "created_at": 1577356081, "paid_count": 1, "current_end": 1582655400, "customer_id": "cust_D00000000000001", "total_count": 6, "auth_attempts": 0, "current_start": 1577355871, "customer_notify": true, "remaining_count": 5, "change_scheduled_at": null, "has_scheduled_changes": false}
10	addon	{"id": "ao_00000000000001", "item": {"id": "item_00000000000001", "name": "Extra Chair", "type": "addon", "unit": null, "active": true, "amount": 30000, "tax_id": null, "currency": "INR", "created_at": 1507733751, "updated_at": 1507733751, "description": null, "unit_amount": 30000, "tax_group_id": null, "tax_inclusive": false}, "entity": "addon", "quantity": 2, "created_at": 1507733751, "invoice_id": null, "subscription_id": "sub_00000000000001"}
11	payment_links	{"id": "inv_8fZLnkhkbr74PA", "date": 1505907531, "type": "link", "notes": [], "terms": "Terms and condition of the service", "amount": 1000, "entity": "invoice", "status": "issued", "comment": null, "paid_at": null, "receipt": null, "user_id": null, "currency": "INR", "order_id": "order_8fZLnnY8WCti5v", "expire_by": null, "issued_at": 1505907531, "short_url": "https://rzp.io/i/ltnGtvf", "view_less": true, "amount_due": 1000, "created_at": 1505907531, "expired_at": null, "line_items": [], "payment_id": null, "sms_status": "pending", "tax_amount": 0, "amount_paid": 0, "customer_id": "cust_8fX1NZkgHRziE0", "description": "Cloud computing course fees", "cancelled_at": null, "email_status": "pending", "gross_amount": 1000, "partial_payment": false, "customer_details": {"name": null, "email": "gaurav.kumar@example.com", "contact": "9888888888", "billing_address": null}}
12	smart_collect	{"id": "va_4xbQrmEoA5WJ0G", "notes": {"reference_key": "reference_value"}, "entity": "virtual_account", "status": "active", "receivers": [{"id": "ba_4lsdkfldlteskf", "ifsc": "RZPB0000001", "name": "Merchant Billing Label", "entity": "bank_account", "account_number": "123321987789"}], "created_at": 1455696638, "amount_paid": 0, "customer_id": "cust_805c8oBQdBGPwS", "description": "First Virtual Account"}
13	routes	{"count": 2, "items": [{"id": "trf_6ydVYyzaICeIw5", "amount": 10000, "entity": "transfer", "source": "pay_6ydSup2U7aFMsA", "on_hold": false, "currency": "INR", "recipient": "acc_a1b2c3d4e5f6g7", "created_at": 1482996461, "amount_reversed": 0}, {"id": "trf_6ydVZ7a3z4q50q", "amount": 5000, "entity": "transfer", "source": "pay_6ydSup2U7aFMsA", "on_hold": false, "currency": "INR", "recipient": "acc_21t2c3gafu4sa2", "created_at": 1482996461, "amount_reversed": 0}], "entity": "collection"}
14	items	{"id": "item_7Oxp4hmm6T4SCn", "name": "Book / English August", "active": true, "amount": 20000, "currency": "INR", "description": "An indian story, Booker prize winner."}
15	invoice	{"id": "inv_gHQwerty123ggd", "date": 1505937098, "type": "invoice", "notes": [], "terms": null, "amount": 20000, "entity": "invoice", "status": "issued", "comment": null, "paid_at": null, "receipt": null, "user_id": null, "currency": "INR", "order_id": "order_gHQwerty123ggd", "expire_by": null, "issued_at": 1488446398, "short_url": "http://rzp.io/w4ahvtz", "view_less": true, "amount_due": 20000, "created_at": 1505935715, "expired_at": null, "line_items": [{"id": "li_gHQwerty123ggd", "name": "Book / English August", "type": "invoice", "unit": null, "taxes": [], "amount": 20000, "item_id": "item_gHQwerty123gg1", "currency": "INR", "quantity": 1, "net_amount": 20000, "tax_amount": 0, "description": "Funny story of an IAS officer wanting to be aything other than an IAS.", "unit_amount": 20000, "gross_amount": 20000, "tax_inclusive": false}, {"id": "li_gHQwerty123ggg", "name": "Book / A Wild Sheep Chase", "type": "invoice", "unit": null, "taxes": [], "amount": 20000, "item_id": "item_gHQwerty123gg2", "currency": "INR", "quantity": 1, "net_amount": 20000, "tax_amount": 0, "description": "A Wild Sheep Chase is the third novel by Japanese author Haruki Murakami.", "unit_amount": 20000, "gross_amount": 20000, "tax_inclusive": false}], "payment_id": null, "sms_status": "pending", "tax_amount": 0, "amount_paid": 0, "billing_end": null, "customer_id": "cust_gHQwerty123ggd", "description": null, "cancelled_at": null, "email_status": "pending", "gross_amount": 20000, "billing_start": null, "partial_payment": false, "customer_details": {"name": "Gaurav Kumar", "email": "gaurav.kumar@example.com", "contact": "9123456789", "customer_name": null, "customer_email": "gaurav.kumar@example.com", "billing_address": {"city": "West Mumbai", "line1": "318 C-Wing, Suyog Co. Housing Society Ltd., T.P.S Road, Vazira, Borivali", "state": "Maharashtra", "country": "India", "zipcode": "400092"}, "customer_contact": "9123456789"}, "group_taxes_discounts": false}
\.


--
-- Name: razorpay_id_seq; Type: SEQUENCE SET; Schema: public; Owner: razorpay
--

SELECT pg_catalog.setval('public.razorpay_id_seq', 15, true);


--
-- Name: razorpay razorpay_pkey; Type: CONSTRAINT; Schema: public; Owner: razorpay
--

ALTER TABLE ONLY public.razorpay
    ADD CONSTRAINT razorpay_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

