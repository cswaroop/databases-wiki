
CREATE TABLE account (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    handle character varying(255),
    email character varying(255),
    crypted_password character varying(255),
    status_id integer DEFAULT 1,
    status_position integer,
    role_id integer,
    role_position integer
);




CREATE TABLE asset (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filename character varying(255),
    url character varying(255),
    content_type character varying(255),
    size integer,
    parent_id integer,
    description text,
    status_id integer DEFAULT 1,
    status_position integer
);



CREATE TABLE domain (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    description text,
    site_id integer,
    site_position integer,
    status_id integer DEFAULT 1,
    status_position integer
);




CREATE TABLE enumeration (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    entry character varying(255),
    field_id integer,
    field_position integer
);


CREATE TABLE field (
    id integer NOT NULL,
    name character varying(55) NOT NULL,
    slug character varying(55) NOT NULL,
    type character varying(256) NOT NULL,
    default_value character varying(256),
    link_id integer,
    model_id integer NOT NULL,
    model_position integer DEFAULT 0,
    target_id integer,
    target_type character varying(55) DEFAULT NULL::character varying,
    description text,
    "position" integer DEFAULT 0,
    required boolean DEFAULT false,
    disjoint boolean DEFAULT false,
    singular boolean DEFAULT false,
    locked boolean DEFAULT false,
    immutable boolean DEFAULT false,
    editable boolean DEFAULT true,
    searchable boolean DEFAULT false,
    dependent boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    format character varying(32) DEFAULT NULL::character varying,
    map boolean,
    localized boolean,
    uuid character varying(255)
);



CREATE TABLE i18n (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    resource_key character varying(255),
    value text,
    status_id integer DEFAULT 1,
    status_position integer
);



--
-- Name: locale; Type: TABLE; Schema: public; Owner: taiga
--

CREATE TABLE locale (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    language character varying(255),
    region character varying(255),
    code character varying(255),
    description text,
    status_id integer DEFAULT 1,
    status_position integer
);



CREATE TABLE location (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address character varying(255),
    address_two character varying(255),
    city character varying(255),
    postal_code character varying(255),
    state character varying(255),
    country character varying(255),
    lat numeric(20,10),
    lng numeric(20,10),
    status_id integer DEFAULT 1,
    status_position integer
);



CREATE TABLE migration (
    id integer NOT NULL,
    name character varying(55) NOT NULL,
    run_at timestamp without time zone DEFAULT now() NOT NULL
);



CREATE TABLE model (
    id integer NOT NULL,
    name character varying(55) NOT NULL,
    slug character varying(55) NOT NULL,
    description text,
    "position" integer DEFAULT 0,
    nested boolean DEFAULT false,
    locked boolean DEFAULT false,
    join_model boolean DEFAULT false,
    abstract boolean DEFAULT false,
    localized boolean DEFAULT false,
    searchable boolean DEFAULT false,
    ancestor_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    uuid character varying(255),
    display text
);


--
-- Name: page; Type: TABLE; Schema: public; Owner: taiga
--

CREATE TABLE page (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255),
    path character varying(255),
    controller character varying(255) NOT NULL,
    action character varying(255) NOT NULL,
    method character varying(255),
    template character varying(255),
    parent_id integer,
    site_id integer,
    site_position integer,
    status_id integer DEFAULT 1,
    status_position integer,
    protected boolean,
    username character varying(255),
    crypted_password character varying(255)
);



CREATE TABLE permission (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    mask integer,
    model_id integer,
    model_position integer,
    role_id integer,
    role_position integer
);


CREATE TABLE role (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    title character varying(255),
    default_mask integer
);


CREATE TABLE siphon (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status_id integer DEFAULT 1,
    status_position integer,
    spec text,
    page_id integer,
    page_position integer,
    page_key character varying(255)
);



CREATE TABLE site (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255),
    asset_id integer,
    description text,
    status_id integer DEFAULT 1,
    status_position integer
);


--
-- Name: status; Type: TABLE; Schema: public; Owner: taiga
--

CREATE TABLE status (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    slug character varying(255),
    description text,
    status_id integer DEFAULT 1,
    status_position integer
);


CREATE TABLE view (
    id integer NOT NULL,
    uuid character varying(255),
    "position" integer DEFAULT 0,
    env_id integer DEFAULT 1,
    locked boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    description text,
    status_id integer DEFAULT 1,
    status_position integer
);


--

COPY account (id, uuid, "position", env_id, locked, created_at, updated_at, first_name, last_name, handle, email, crypted_password, status_id, status_position, role_id, role_position) FROM stdin;
1	21b1d672-c58f-4d8a-a566-c8392967af10	0	1	f	2016-08-27 14:29:36.927	2016-08-27 14:29:42.81	Caribou	User	\N	caribou	3fa3efb969e5398eea42cd9ac3cac9ca32ac8fa9848165818eb466aeb26f7144	\N	\N	1	\N
\.


--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('account_id_seq', 1, true);


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY asset (id, uuid, "position", env_id, locked, created_at, updated_at, filename, url, content_type, size, parent_id, description, status_id, status_position) FROM stdin;
\.


--
-- Name: asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('asset_id_seq', 1, false);


--
-- Data for Name: domain; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY domain (id, uuid, "position", env_id, locked, created_at, updated_at, name, description, site_id, site_position, status_id, status_position) FROM stdin;
\.


--
-- Name: domain_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('domain_id_seq', 1, false);


--
-- Data for Name: enumeration; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY enumeration (id, uuid, "position", env_id, locked, created_at, updated_at, status_id, status_position, entry, field_id, field_position) FROM stdin;
1	096ae15b-8854-4f4b-bf4d-84f4b4c71509	0	1	f	2016-08-27 15:31:36.72	2016-08-27 15:31:36.72	1	0		\N	0
2	88f68ec1-2ab8-441f-867b-bbf81facbdd6	1	1	f	2016-08-27 15:37:02.371	2016-08-27 15:37:02.371	1	1	Standard	372	1
3	d567be58-739f-494f-aa7b-5d42672541ec	2	1	f	2016-08-27 15:37:02.376	2016-08-27 15:37:02.376	1	2	Arnold Clark	372	2
4	f4fc1499-0614-4da9-906c-fa72c7f1dff9	3	1	f	2016-08-27 15:38:05.538	2016-08-27 15:38:05.538	1	3	Customer	376	3
35	4d6795b8-81a4-4853-866b-8e67abbbe2ec	4	1	f	2016-08-27 16:03:53.560699	2016-08-27 16:03:53.559	1	4	Multi National Corporation	423	4
36	5046b7c9-2c78-4e00-ac43-903c1e7ff936	5	1	f	2016-08-27 16:03:53.566698	2016-08-27 16:03:53.566	1	5	Continent	423	5
37	5ab2606c-3852-41be-a7dc-cac069eff070	6	1	f	2016-08-27 16:03:53.570698	2016-08-27 16:03:53.57	1	6	Country	423	6
38	ae57e190-ce9d-4f0f-8fb8-3f2d5ef42506	7	1	f	2016-08-27 16:03:53.575697	2016-08-27 16:03:53.574	1	7	Region	423	7
39	8951ec96-0642-45cc-bfd9-5cf680e6503b	8	1	f	2016-08-27 16:05:52.519802	2016-08-27 16:05:52.518	1	8	Multinational Corporation	425	8
40	cee26764-cfcf-437f-b138-00531b62739c	9	1	f	2016-08-27 16:05:52.524801	2016-08-27 16:05:52.523	1	9	Continent	425	9
41	469ece75-876c-4c7b-8728-60eb980d37c1	10	1	f	2016-08-27 16:05:52.527801	2016-08-27 16:05:52.527	1	10	Country	425	10
42	38bc463f-91ba-4e0c-8ad1-124a254c5062	11	1	f	2016-08-27 16:05:52.5328	2016-08-27 16:05:52.532	1	11	Region	425	11
43	c0168aa4-ee5e-432a-8715-ef4c5420e58f	12	1	f	2016-08-27 16:05:52.5368	2016-08-27 16:05:52.536	1	12	Branch	425	12
44	045140bc-d53e-4614-b06e-29c84ee37ad3	13	1	f	2016-08-27 16:11:45.764	2016-08-27 16:11:45.764	1	13	Sole Trader	427	13
45	74d21f57-d19b-4374-89d0-9c1cc5893bcf	14	1	f	2016-08-27 16:11:45.769	2016-08-27 16:11:45.769	1	14	Private Individual	427	14
46	de8fbae7-eb05-490f-9566-5c1ae18ea044	15	1	f	2016-08-27 16:11:45.773	2016-08-27 16:11:45.773	1	15	Company	427	15
47	8d3846af-2800-4ba9-bec7-44d90597a113	16	1	f	2016-08-27 16:11:45.777	2016-08-27 16:11:45.776	1	16	Partnership	427	16
48	5d480d84-2213-4fe6-9949-db87f11309c1	17	1	f	2016-08-27 16:11:45.781	2016-08-27 16:11:45.781	1	17	PartnershipGT3	427	17
49	e4185d27-25cd-4a4b-89c0-93f1370389bf	18	1	f	2016-08-27 16:14:56.312745	2016-08-27 16:14:56.311	1	18	Individual	441	18
50	8a97182b-028b-4cc1-b8ad-b6bc58ee7c73	19	1	f	2016-08-27 16:14:56.316744	2016-08-27 16:14:56.316	1	19	Business	441	19
51	43b83ab4-8ccb-493f-8cf9-5c8ef51c8da3	20	1	f	2016-08-27 16:21:08.703187	2016-08-27 16:21:08.703	1	20	New	458	20
52	a7c5b61c-5df2-4fe9-8ea4-8295cb881721	21	1	f	2016-08-27 16:21:08.709186	2016-08-27 16:21:08.709	1	21	Used	458	21
53	a1865d50-958e-444c-9e87-1010798b5d85	22	1	f	2016-08-27 16:21:34.873569	2016-08-27 16:21:34.872	1	22	Car	460	22
55	d9c6a4fd-13c2-4aca-984d-bfb8958cf6a0	24	1	f	2016-08-27 16:23:55.832	2016-08-27 16:23:55.831	1	24	Yes	469	24
56	f9a900c9-37e5-47fe-828c-287ef49ef477	25	1	f	2016-08-27 16:23:55.836	2016-08-27 16:23:55.836	1	25	No	469	25
57	83341cc7-1460-44f7-86b9-a3c1720c2337	26	1	f	2016-08-27 16:37:13.201043	2016-08-27 16:37:13.2	1	26	Submitted	473	26
59	d765198e-86e3-4d1c-816b-b7a98c8f4d38	28	1	f	2016-08-27 16:37:13.211044	2016-08-27 16:37:13.211	1	28	Completed	473	28
62	1928c99f-b61e-4f41-820b-3d9f7846ce1c	31	1	f	2016-08-27 16:37:13.225046	2016-08-27 16:37:13.225	1	31	Pending Concurrence Review	473	31
63	b4ffce49-5318-4ed8-bffd-19a3df723916	32	1	f	2016-08-27 16:51:37.317059	2016-08-27 16:51:37.317	1	32	P	494	32
64	70c6baed-1ca0-4fa5-9787-1698fb249955	33	1	f	2016-08-27 16:52:22.239551	2016-08-27 16:52:22.239	1	33	Monthly	497	33
65	d78aba50-e455-4761-816b-1caae6262d18	34	1	f	2016-08-27 16:56:37.883201	2016-08-27 16:56:37.883	1	34	L	505	34
66	5bd658b8-1b0e-44d7-af08-1bf48ef8c130	35	1	f	2016-08-27 22:45:15.908445	2016-08-27 22:45:15.908	1	35	UK	525	35
67	176452ee-81e5-4b73-9404-633f03d5160e	36	1	f	2016-08-27 23:22:09.321042	2016-08-27 23:22:09.321	1	36		537	36
58	6e4df7ef-194d-4ef0-95f1-3e245e4b82f7	27	1	f	2016-08-27 16:37:13.206044	2016-08-27 23:43:32.605	1	27	Referral	473	27
68	cfb844c0-5809-432a-a1ba-b7ae1ee27330	37	1	f	2016-08-27 23:44:25.295528	2016-08-27 23:44:25.295	1	37	Pending Quality Check	473	37
69	3bb40efe-d2dc-498e-bebc-00ec36c8cb10	38	1	f	2016-08-27 23:44:45.472562	2016-08-27 23:44:45.472	1	38	Escalation	473	38
70	af611fca-1f27-4809-8ebe-c7ebd7b8b346	39	1	f	2016-08-28 07:57:40.999	2016-08-28 07:57:40.999	1	39	UK_EQUIFAX_CONSUMER	572	39
71	3316cf49-2c90-45be-a371-929dc43cd7aa	40	1	f	2016-08-28 07:57:41.005	2016-08-28 07:57:41.005	1	40	UK_EQUIFAX_COMMERCIAL	572	40
72	c7f8773d-8b21-4d0c-8a7e-c9d7ca785a20	41	1	f	2016-08-28 07:57:41.01	2016-08-28 07:57:41.009	1	41	UK_EXPERIAN_CONSUMER	572	41
73	c53500e9-d205-47e8-8669-2dce8a5d236c	42	1	f	2016-08-28 08:04:03.361	2016-08-28 08:04:03.361	1	42	XML	585	42
74	9614ee2e-4737-4de3-879b-304484a6c358	43	1	f	2016-08-28 08:04:03.368	2016-08-28 08:04:03.367	1	43	JSON	585	43
75	d5db6256-debe-4d9e-b395-88c62e65b122	44	1	f	2016-08-28 08:04:03.374	2016-08-28 08:04:03.373	1	44	CLOB	585	44
76	30106d36-e382-4767-a292-b78d7284d6a3	45	1	f	2016-08-28 08:04:03.377	2016-08-28 08:04:03.377	1	45	BLOB	585	45
77	806c67f0-808d-494a-9c5e-31b827a8371f	46	1	f	2016-08-28 09:26:16	2016-08-28 09:26:16	1	46	ParsedBureauDataExtension	694	46
78	a9146b90-f252-4a67-988f-7f376b00ea8a	47	1	f	2016-08-28 09:26:16.004	2016-08-28 09:26:16.003	1	47	HistoricSearchXML	694	47
79	55d8ff76-f116-4cd2-954b-802140d0184a	48	1	f	2016-08-28 09:26:16.006	2016-08-28 09:26:16.006	1	48	BureauRequest	694	48
80	42b24852-ff5d-4470-b568-c50d2ca1e1a6	49	1	f	2016-08-28 09:26:16.009	2016-08-28 09:26:16.009	1	49	CreditWorthinessXML	694	49
81	32d5a5b1-c6dc-4083-b603-b9f15a66ddf1	50	1	f	2016-08-28 09:26:16.014	2016-08-28 09:26:16.013	1	50	BureauResponse	694	50
82	e2a1cc48-21fe-4936-95f4-76161ecbc9c9	51	1	f	2016-08-28 09:26:16.02	2016-08-28 09:26:16.02	1	51	ComplianceInfo	694	51
83	edbd1523-1c10-4718-aab4-07a0dcd4fa0c	52	1	f	2016-08-28 09:26:16.024	2016-08-28 09:26:16.024	1	52	CustomerInfo	694	52
84	e3fe8c74-a0a0-45dc-a042-847aa19ee430	53	1	f	2016-08-28 09:26:16.028	2016-08-28 09:26:16.027	1	53	CreditWorthinessSummary	694	53
85	f064e98f-85c0-48c1-9708-7fa2f4dd9c66	54	1	f	2016-08-28 09:26:16.033	2016-08-28 09:26:16.032	1	54	ReadableResponse	694	54
86	d5de756d-c12d-4a95-bf42-11aafc4621ca	55	1	f	2016-08-28 09:26:16.036	2016-08-28 09:26:16.036	1	55	FraudInfo	694	55
87	450daec8-9927-4b26-88a7-2af7307220fd	56	1	f	2016-08-28 09:44:27.253	2016-08-28 09:44:27.253	1	56	Active	696	56
88	e8224b12-6c88-43bb-9627-3b0709fa2fe7	57	1	f	2016-08-28 11:20:46.125	2016-08-28 11:20:46.125	1	57	EVENT_TYPE	753	57
89	62ba3e5c-4e04-4936-94a7-ea6e746370be	58	1	f	2016-08-28 11:20:46.14	2016-08-28 11:20:46.139	1	58	ACTIVITY_TYPE	753	58
90	cccba67e-fdf3-47fe-85fa-ce928cf8a0ed	59	1	f	2016-08-28 14:12:24.686	2016-08-28 14:12:24.686	1	59	ApplicationSubmit	694	59
\.


--
-- Name: enumeration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('enumeration_id_seq', 90, true);


--
-- Data for Name: field; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY field (id, name, slug, type, default_value, link_id, model_id, model_position, target_id, target_type, description, "position", required, disjoint, singular, locked, immutable, editable, searchable, dependent, created_at, updated_at, status_id, status_position, format, map, localized, uuid) FROM stdin;
54	Id	id	id	\N	\N	4	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.165	2016-08-27 14:29:36.164	\N	\N	\N	\N	\N	0d8087b5-1eb1-474c-ab7e-331e185e20c8
5	Position	position	position	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.889	2016-08-27 14:29:35.888	\N	\N	\N	\N	\N	dec4bf1c-e1ea-4c59-ac30-0319d0da3d0a
6	Nested	nested	boolean	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.891	2016-08-27 14:29:35.89	\N	\N	\N	\N	\N	7b7af687-befc-472a-b68d-84566c06b962
9	Locked	locked	boolean	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.896	2016-08-27 14:29:35.895	\N	\N	\N	\N	\N	b0e11284-d73d-495b-b792-7d3b5cabdc8d
10	Abstract	abstract	boolean	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.898	2016-08-27 14:29:35.897	\N	\N	\N	\N	\N	33079f44-c18d-4a4d-9bd7-606474d398ef
11	Localized	localized	boolean	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.899	2016-08-27 14:29:35.899	\N	\N	\N	\N	\N	76310686-2259-4759-8ad0-5b787e556dd4
13	Ancestor Id	ancestor-id	integer	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.903	2016-08-27 14:29:35.902	\N	\N	\N	\N	\N	3ad993b3-1088-4082-b3e6-15fb392d2104
14	Created At	created-at	timestamp	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.904	2016-08-27 14:29:35.904	\N	\N	\N	\N	\N	c50a6b20-50f3-4e9f-a09c-249421460273
16	Id	id	integer	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.91	2016-08-27 14:29:35.91	\N	\N	\N	\N	\N	e0e49db6-ac97-4938-8aee-674f81c06210
18	Link Id	link-id	integer	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.913	2016-08-27 14:29:35.913	\N	\N	\N	\N	\N	557d16af-0dc0-4e6b-898f-034776344294
21	Type	type	string	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.918	2016-08-27 14:29:35.917	\N	\N	\N	\N	\N	74ab2925-512b-4303-ae4e-e42884b261d7
22	Default Value	default-value	string	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.92	2016-08-27 14:29:35.919	\N	\N	\N	\N	\N	1b0d1368-23cd-405e-a924-fbcaf3982bc4
24	Position	position	position	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.924	2016-08-27 14:29:35.923	\N	\N	\N	\N	\N	cd65ba29-db75-43ce-9f44-96e9e17b0dec
25	Model Id	model-id	integer	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.925	2016-08-27 14:29:35.925	\N	\N	\N	\N	\N	97985fe5-3c64-40ce-a3c2-29380f4c06e0
27	Model Position	model-position	position	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.928	2016-08-27 14:29:35.927	\N	\N	\N	\N	\N	ca6420c7-637f-4bbf-9bec-02cd0e9ca7e5
30	Disjoint	disjoint	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.932	2016-08-27 14:29:35.932	\N	\N	\N	\N	\N	d8103d38-4ecf-4301-a936-5b40a9719cca
31	Singular	singular	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.935	2016-08-27 14:29:35.934	\N	\N	\N	\N	\N	f72270eb-d4fd-4d3c-8b4b-6c434409bbd2
33	Immutable	immutable	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.94	2016-08-27 14:29:35.939	\N	\N	\N	\N	\N	caf6bccb-e488-4c08-bca8-56674eee1e64
34	Locked	locked	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.941	2016-08-27 14:29:35.941	\N	\N	\N	\N	\N	5f85ba82-b8d4-4db2-a03e-beeb2760047d
35	Searchable	searchable	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.943	2016-08-27 14:29:35.942	\N	\N	\N	\N	\N	953d73cc-b0bc-44ff-8d3c-48d79dede782
37	Created At	created-at	timestamp	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.946	2016-08-27 14:29:35.945	\N	\N	\N	\N	\N	f270c377-5bdf-4347-baba-e34ce77f805f
38	Updated At	updated-at	timestamp	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.948	2016-08-27 14:29:35.947	\N	\N	\N	\N	\N	27ea5e2f-0cad-4db9-b2d6-9e5615298781
28	Model	model	part	\N	8	2	0	1	\N	\N	0	f	f	f	t	f	t	f	t	2016-08-27 14:29:35.929	2016-08-27 14:29:35.929	\N	\N	\N	\N	\N	f522c4fe-599c-412a-9a76-4f04629c967e
39	Id	id	id	\N	\N	3	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.027	2016-08-27 14:29:36.026	\N	\N	\N	\N	\N	fcaf4e8c-d1c1-4383-b005-c8cc723e5cd9
40	UUID	uuid	string	\N	\N	3	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.028	2016-08-27 14:29:36.028	\N	\N	\N	\N	\N	c335c62c-19b1-4d46-84ed-26237fee5b8b
42	Env Id	env-id	integer	\N	\N	3	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.032	2016-08-27 14:29:36.031	\N	\N	\N	\N	\N	d717f331-d51e-40ae-88df-df622333571d
43	Locked	locked	boolean	false	\N	3	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.033	2016-08-27 14:29:36.033	\N	\N	\N	\N	\N	68bd4313-2e56-449f-a9b5-2c91e95aea61
44	Created At	created-at	timestamp	\N	\N	3	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.035	2016-08-27 14:29:36.034	\N	\N	\N	\N	\N	1d1bc3c9-b5b7-4ab5-b0d2-98117e7278ed
20	Slug	slug	dbslug	\N	19	2	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.916	2016-08-27 14:29:35.916	\N	\N	\N	\N	\N	87f85c3e-3514-4be0-b27f-6562272f40ae
55	UUID	uuid	string	\N	\N	4	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.167	2016-08-27 14:29:36.166	\N	\N	\N	\N	\N	c4783d91-9bbb-45c9-8ec0-fc5e89e59b27
57	Env Id	env-id	integer	\N	\N	4	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.17	2016-08-27 14:29:36.169	\N	\N	\N	\N	\N	66fea63a-6fd7-43d7-9234-0adf8de5d113
58	Locked	locked	boolean	false	\N	4	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.171	2016-08-27 14:29:36.171	\N	\N	\N	\N	\N	561d15b6-417d-4399-a5c2-2c6708ac74ee
60	Updated At	updated-at	timestamp	\N	\N	4	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.175	2016-08-27 14:29:36.174	\N	\N	\N	\N	\N	0bb08d26-5d88-4aac-997c-4d70621c8c5a
67	Id	id	id	\N	\N	5	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.278	2016-08-27 14:29:36.277	\N	\N	\N	\N	\N	806c9615-d487-4668-a117-bd776234a8f4
68	UUID	uuid	string	\N	\N	5	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.279	2016-08-27 14:29:36.279	\N	\N	\N	\N	\N	3ff9676d-3c91-4337-a1ee-ff2a12866db6
70	Env Id	env-id	integer	\N	\N	5	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.282	2016-08-27 14:29:36.282	\N	\N	\N	\N	\N	515758c5-8744-4855-9c72-a4d2f4e7baa4
71	Locked	locked	boolean	false	\N	5	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.284	2016-08-27 14:29:36.284	\N	\N	\N	\N	\N	f764a724-2c1c-4afa-bd48-5603daf25763
73	Updated At	updated-at	timestamp	\N	\N	5	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.287	2016-08-27 14:29:36.287	\N	\N	\N	\N	\N	32b48f7f-44b2-4427-ad1a-5107ce15be22
76	Id	id	id	\N	\N	6	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.347	2016-08-27 14:29:36.346	\N	\N	\N	\N	\N	c471a1bb-fa3f-4e63-a80f-1c9d3dece9d8
77	UUID	uuid	string	\N	\N	6	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.349	2016-08-27 14:29:36.348	\N	\N	\N	\N	\N	45b9d257-7842-42b7-8983-5414e7272a1e
3	Slug	slug	dbslug	\N	2	1	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.884	2016-08-27 14:29:35.883	\N	\N	\N	\N	\N	0236d183-1388-4060-878d-913bb658983c
47	Slug	slug	slug	\N	46	3	2	\N	\N	\N	2	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.07	2016-08-27 14:29:36.069	\N	\N	\N	\N	\N	3f0f1d30-d8d4-4cee-a7e6-bf82389a2976
49	Controller	controller	string	\N	\N	3	4	\N	\N	\N	4	t	f	f	t	f	t	f	f	2016-08-27 14:29:36.087	2016-08-27 14:29:36.087	\N	\N	\N	\N	\N	e0678d8c-6a2f-4595-917b-7c159e42d98c
50	Action	action	string	\N	\N	3	5	\N	\N	\N	5	t	f	f	t	f	t	f	f	2016-08-27 14:29:36.096	2016-08-27 14:29:36.096	\N	\N	\N	\N	\N	4a272da8-7ffa-4d94-b666-96b69e4c13b6
53	Parent Id	parent-id	integer	\N	\N	3	8	\N	\N	\N	8	f	f	f	f	f	t	f	f	2016-08-27 14:29:36.12	2016-08-27 14:29:36.12	\N	\N	\N	\N	\N	53fa81b4-72a0-4fd4-beab-6700ed4eb663
61	First Name	first-name	string	\N	\N	4	9	\N	\N	\N	9	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.177	2016-08-27 14:29:36.177	\N	\N	\N	\N	\N	7fac1e21-990c-478c-b2db-f2e18dfa276c
63	Handle	handle	string	\N	\N	4	11	\N	\N	\N	11	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.198	2016-08-27 14:29:36.197	\N	\N	\N	\N	\N	541b61a5-cda2-4efb-8622-3ed6ed39ee73
64	Email	email	string	\N	\N	4	12	\N	\N	\N	12	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.205	2016-08-27 14:29:36.205	\N	\N	\N	\N	\N	f90c0ffc-159e-4bad-b7d0-70b947f94a54
46	Name	name	string	\N	\N	3	1	\N	\N	\N	1	t	t	f	t	f	t	f	f	2016-08-27 14:29:36.042	2016-08-27 14:29:36.041	\N	\N	\N	\N	\N	50ecf816-c3b9-4c5b-931e-aa16e8f94142
65	Password	password	password	\N	\N	4	13	\N	\N	\N	13	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.213	2016-08-27 14:29:36.213	\N	\N	\N	\N	\N	08e4eb0a-f117-4aa1-800e-a039073b0029
74	Name	name	string	\N	\N	5	15	\N	\N	\N	15	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.29	2016-08-27 14:29:36.29	\N	\N	\N	\N	\N	84120f0b-8b3b-42f7-95eb-c6e4246684e9
75	Description	description	text	\N	\N	5	16	\N	\N	\N	16	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.305	2016-08-27 14:29:36.305	\N	\N	\N	\N	\N	81f7a8be-41b9-4718-813b-529c4f227ae5
17	Link	link	tie	\N	\N	2	0	2	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.912	2016-08-27 14:29:41.151	\N	\N	\N	\N	\N	92e9898b-de76-4566-889e-5e70ba497d3b
81	Created At	created-at	timestamp	\N	\N	6	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.357	2016-08-27 14:29:36.357	\N	\N	\N	\N	\N	bf303783-6ddd-453d-8a60-3215c88ad8d4
82	Updated At	updated-at	timestamp	\N	\N	6	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.358	2016-08-27 14:29:36.358	\N	\N	\N	\N	\N	8c19e75b-0e27-4667-822c-604769f8a89f
88	UUID	uuid	string	\N	\N	7	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.423	2016-08-27 14:29:36.423	\N	\N	\N	\N	\N	c87c93d8-19c5-42a4-b94e-eb33d517090d
85	Code	code	string	\N	\N	6	19	\N	\N	\N	19	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.378	2016-08-27 14:29:36.378	\N	\N	\N	\N	\N	b15e4654-4937-4e0b-a4ba-d0015ebe951b
86	Description	description	text	\N	\N	6	20	\N	\N	\N	20	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.384	2016-08-27 14:29:36.383	\N	\N	\N	\N	\N	dd5a0903-8050-4b48-9533-2aca3c70bbe7
95	Url	url	string	\N	\N	7	22	\N	\N	\N	22	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.445	2016-08-27 14:29:36.444	\N	\N	\N	\N	\N	98b7afee-dfab-4f36-976a-b9e09eec748e
96	Content Type	content-type	string	\N	\N	7	23	\N	\N	\N	23	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.451	2016-08-27 14:29:36.45	\N	\N	\N	\N	\N	ab9589a1-21ca-40e6-bd43-accdf5c91bb2
89	Position	position	position	\N	\N	7	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.425	2016-08-27 14:29:36.424	\N	\N	\N	\N	\N	ec5b2982-2e71-4419-b4f7-4c86b7c084b4
91	Locked	locked	boolean	false	\N	7	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.428	2016-08-27 14:29:36.427	\N	\N	\N	\N	\N	46488486-d717-434a-9da9-8e1916ac99aa
92	Created At	created-at	timestamp	\N	\N	7	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.429	2016-08-27 14:29:36.429	\N	\N	\N	\N	\N	8fc54910-2545-4aab-8db5-d7b9bfea3f97
100	Id	id	id	\N	\N	8	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.512	2016-08-27 14:29:36.512	\N	\N	\N	\N	\N	bad6d2e9-85a6-441e-a53f-3af3999c2b83
101	UUID	uuid	string	\N	\N	8	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.514	2016-08-27 14:29:36.513	\N	\N	\N	\N	\N	5a6e34c4-ed04-4d5c-a2ea-91c9fa77a794
102	Position	position	position	\N	\N	8	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.515	2016-08-27 14:29:36.515	\N	\N	\N	\N	\N	1948fb62-15f4-4df4-93dd-3f9e14ce1465
104	Locked	locked	boolean	false	\N	8	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.518	2016-08-27 14:29:36.517	\N	\N	\N	\N	\N	8aa41526-14d0-45f6-a8ad-0078a1666ed9
97	Size	size	integer	\N	\N	7	24	\N	\N	\N	24	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.457	2016-08-27 14:29:36.456	\N	\N	\N	\N	\N	152c639a-5405-402d-b446-028a7d090b71
99	Description	description	text	\N	\N	7	26	\N	\N	\N	26	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.468	2016-08-27 14:29:36.468	\N	\N	\N	\N	\N	06dd962f-529a-475b-99f7-d2eb1375e30e
107	Name	name	string	\N	\N	8	27	\N	\N	\N	27	t	f	f	t	f	t	f	f	2016-08-27 14:29:36.522	2016-08-27 14:29:36.522	\N	\N	\N	\N	\N	d92a821c-a436-43bc-93a7-3ed3a26a6e1a
109	Asset	asset	asset	\N	\N	8	29	\N	\N	\N	29	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.543	2016-08-27 14:29:36.542	\N	\N	\N	\N	\N	c8e639e2-c2e0-4ff5-9046-c8f1ae1f6269
110	Asset Id	asset-id	integer	\N	\N	8	30	\N	\N	\N	30	f	f	f	f	f	f	f	f	2016-08-27 14:29:36.553	2016-08-27 14:29:36.553	\N	\N	\N	\N	\N	3bdd4880-f9fa-402e-a98d-017dda6f0236
111	Description	description	text	\N	\N	8	31	\N	\N	\N	31	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.588	2016-08-27 14:29:36.588	\N	\N	\N	\N	\N	d215116c-bdad-4958-bc65-0e33a2e1357f
105	Created At	created-at	timestamp	\N	\N	8	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.519	2016-08-27 14:29:36.519	\N	\N	\N	\N	\N	e6d3983e-1b5c-4bc1-80a5-5503d36ab34d
112	Id	id	id	\N	\N	9	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.634	2016-08-27 14:29:36.633	\N	\N	\N	\N	\N	063a7567-39d4-4a1b-bd39-bdb32325576b
114	Position	position	position	\N	\N	9	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.636	2016-08-27 14:29:36.636	\N	\N	\N	\N	\N	1fea2a75-bdad-41b3-9a88-bec6054600fa
115	Env Id	env-id	integer	\N	\N	9	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.638	2016-08-27 14:29:36.637	\N	\N	\N	\N	\N	5f438f25-7425-4191-a2d6-3b4b4a5ab861
117	Created At	created-at	timestamp	\N	\N	9	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.64	2016-08-27 14:29:36.639	\N	\N	\N	\N	\N	f812049c-ee9f-45d3-bd3c-d7074e13ded1
118	Updated At	updated-at	timestamp	\N	\N	9	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.641	2016-08-27 14:29:36.641	\N	\N	\N	\N	\N	8e6084ad-69a7-40ca-af9a-190003a45e8a
120	Description	description	text	\N	\N	9	33	\N	\N	\N	33	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.656	2016-08-27 14:29:36.656	\N	\N	\N	\N	\N	dccb00c0-9ad1-4ff5-a864-fce326db1615
128	Address	address	string	\N	\N	10	34	\N	\N	\N	34	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.713	2016-08-27 14:29:36.712	\N	\N	\N	\N	\N	26999fc7-cb92-41e6-93f0-17e1fcf30411
130	City	city	string	\N	\N	10	36	\N	\N	\N	36	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.729	2016-08-27 14:29:36.728	\N	\N	\N	\N	\N	7e920d72-0f55-42e9-bb4e-3e48f81ced02
131	Postal Code	postal-code	string	\N	\N	10	37	\N	\N	\N	37	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.735	2016-08-27 14:29:36.734	\N	\N	\N	\N	\N	72d375a1-3264-43c2-a348-e9186ecda70b
132	State	state	string	\N	\N	10	38	\N	\N	\N	38	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.74	2016-08-27 14:29:36.74	\N	\N	\N	\N	\N	009070f1-f06a-41cc-8daa-25df9c947036
121	Id	id	id	\N	\N	10	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.703	2016-08-27 14:29:36.702	\N	\N	\N	\N	\N	b40b455e-98dc-4ec1-9650-5765843a96ec
123	Position	position	position	\N	\N	10	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.705	2016-08-27 14:29:36.705	\N	\N	\N	\N	\N	45f60159-faf0-4b3d-9178-7d6929c7549c
83	Language	language	string	\N	\N	6	17	\N	\N	\N	17	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.361	2016-08-27 14:29:36.361	\N	\N	\N	\N	\N	ffa8a34a-6cfc-4b31-a5ca-d08a19de304a
134	Lat	lat	decimal	\N	\N	10	40	\N	\N	\N	40	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.752	2016-08-27 14:29:36.752	\N	\N	\N	\N	\N	509e9f8e-9afc-423e-a8d8-58e5803d50b8
135	Lng	lng	decimal	\N	\N	10	41	\N	\N	\N	41	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.759	2016-08-27 14:29:36.758	\N	\N	\N	\N	\N	33b06347-6b75-4bb7-afcd-dfad2eac08b3
144	Value	value	text	\N	\N	11	43	\N	\N	\N	43	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.82	2016-08-27 14:29:36.82	\N	\N	\N	\N	\N	17b363eb-4180-45d2-97f4-730076759bcd
153	Slug	slug	slug	\N	152	12	44	\N	\N	\N	44	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.885	2016-08-27 14:29:36.884	\N	\N	\N	\N	\N	cf79186f-3fe6-4b30-b6e5-9d3914a3863b
154	Description	description	text	\N	\N	12	45	\N	\N	\N	45	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.893	2016-08-27 14:29:36.893	\N	\N	\N	\N	\N	61994ea0-7d1b-4180-bd50-6e90aefe639a
157	Site Id	site-id	integer	\N	\N	9	48	\N	\N	\N	48	f	f	f	f	f	f	f	t	2016-08-27 14:29:36.968	2016-08-27 14:29:36.968	\N	\N	\N	\N	\N	8d63490a-2741-41e7-92e9-92a27ef85913
125	Locked	locked	boolean	false	\N	10	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.708	2016-08-27 14:29:36.707	\N	\N	\N	\N	\N	12d876c0-3ea3-4377-b5ae-d322406dddb7
127	Updated At	updated-at	timestamp	\N	\N	10	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.71	2016-08-27 14:29:36.71	\N	\N	\N	\N	\N	1c8afb24-7710-4257-bfb6-78eed630e5f3
136	Id	id	id	\N	\N	11	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.802	2016-08-27 14:29:36.802	\N	\N	\N	\N	\N	14c5925d-f521-4f87-9c24-3a5ca258489f
138	Position	position	position	\N	\N	11	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.805	2016-08-27 14:29:36.804	\N	\N	\N	\N	\N	23dabb9a-4337-4949-9ed0-e7b22c58d79d
140	Locked	locked	boolean	false	\N	11	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.807	2016-08-27 14:29:36.807	\N	\N	\N	\N	\N	aef4581a-4c70-48c4-a26f-3a91d9e40d12
141	Created At	created-at	timestamp	\N	\N	11	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.809	2016-08-27 14:29:36.808	\N	\N	\N	\N	\N	471103fe-e5a0-4832-bcb0-a69b9d005bf8
145	Id	id	id	\N	\N	12	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.861	2016-08-27 14:29:36.86	\N	\N	\N	\N	\N	dfc2913b-e5d0-43c7-a89e-2900c36335c7
146	UUID	uuid	string	\N	\N	12	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.862	2016-08-27 14:29:36.861	\N	\N	\N	\N	\N	dcfd7ea2-6e96-4e74-8f48-68678a198ca2
147	Position	position	position	\N	\N	12	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.865	2016-08-27 14:29:36.864	\N	\N	\N	\N	\N	ea74ae61-3e56-41c5-b4d3-58849dfe4529
149	Locked	locked	boolean	false	\N	12	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.868	2016-08-27 14:29:36.868	\N	\N	\N	\N	\N	75ecb44e-74eb-4a46-8018-ad233a878f98
150	Created At	created-at	timestamp	\N	\N	12	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.871	2016-08-27 14:29:36.869	\N	\N	\N	\N	\N	6780d060-f2a6-4abd-8168-8342cb56704c
79	Env Id	env-id	integer	\N	\N	6	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.352	2016-08-27 14:29:36.352	\N	\N	\N	\N	\N	e54fea4c-cca3-4449-b96e-b710e3f0bc7a
124	Env Id	env-id	integer	\N	\N	10	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.706	2016-08-27 14:29:36.706	\N	\N	\N	\N	\N	901ba2ca-c609-412e-bc1f-196e100827be
160	Site	site	part	\N	159	3	51	8	\N	\N	51	f	f	f	f	f	t	f	f	2016-08-27 14:29:37.011	2016-08-27 14:29:37.011	\N	\N	\N	\N	\N	c7e8893d-6166-474f-bd57-109cd729e692
158	Site Position	site-position	position	\N	\N	9	49	\N	\N	\N	49	f	f	f	f	f	f	f	f	2016-08-27 14:29:36.978	2016-08-27 14:29:36.978	\N	\N	\N	\N	\N	553d5305-d6e0-4bb7-aee7-80a9f79f5c3a
161	Site Id	site-id	integer	\N	\N	3	52	\N	\N	\N	52	f	f	f	f	f	f	f	f	2016-08-27 14:29:37.018	2016-08-27 14:29:37.017	\N	\N	\N	\N	\N	2612fc75-53cb-41a5-9372-da76010ec9cd
163	Status	status	part	\N	164	1	54	12	\N	\N	54	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.102	2016-08-27 14:29:37.101	\N	\N	\N	\N	\N	52f91615-0ae0-4584-9815-609b41297f94
164	Model	model	collection	\N	163	12	55	1	\N	\N	55	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.107	2016-08-27 14:29:37.106	\N	\N	\N	\N	\N	076b23ed-c1e2-4a66-ab2b-fc0f897f7a1f
165	Status Id	status-id	integer	1	\N	1	56	\N	\N	\N	56	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.116	2016-08-27 14:29:37.205	\N	\N	\N	\N	\N	ed5e9539-496d-4ed0-a5ba-b7b763c4d08a
167	Status	status	part	\N	168	2	58	12	\N	\N	58	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.219	2016-08-27 14:29:37.218	\N	\N	\N	\N	\N	be47f3b7-a5dc-4a8b-909c-2a34d4565a0b
168	Field	field	collection	\N	167	12	59	2	\N	\N	59	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.223	2016-08-27 14:29:37.222	\N	\N	\N	\N	\N	d45edf10-2072-4d4f-88dd-ac828164e29e
169	Status Id	status-id	integer	1	\N	2	60	\N	\N	\N	60	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.23	2016-08-27 14:29:37.292	\N	\N	\N	\N	\N	6329158b-713b-4a6e-9f69-3e163dc7b7ff
171	Status	status	part	\N	172	3	62	12	\N	\N	62	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.303	2016-08-27 14:29:37.303	1	0	\N	\N	\N	7740460e-aed3-4323-9b1b-8a360572df38
172	Page	page	collection	\N	171	12	63	3	\N	\N	63	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.307	2016-08-27 14:29:37.306	1	1	\N	\N	\N	e4721c40-5a67-481b-9610-d85c0ab2b3ee
173	Status Id	status-id	integer	1	\N	3	64	\N	\N	\N	64	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.314	2016-08-27 14:29:37.388	1	2	\N	\N	\N	c07b1315-1900-49b1-8240-0121dff1068d
175	Status	status	part	\N	176	4	66	12	\N	\N	66	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.4	2016-08-27 14:29:37.4	1	4	\N	\N	\N	3a373e04-804f-4952-90b8-0d29dc19b3d6
176	Account	account	collection	\N	175	12	67	4	\N	\N	67	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.405	2016-08-27 14:29:37.405	1	5	\N	\N	\N	cf0585cf-4ef9-402f-84c7-7a6f4de89ea2
177	Status Id	status-id	integer	1	\N	4	68	\N	\N	\N	68	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.414	2016-08-27 14:29:37.482	1	6	\N	\N	\N	e3e4cfdb-c693-4de1-888b-e21be8cf18b5
179	Status	status	part	\N	180	5	70	12	\N	\N	70	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.494	2016-08-27 14:29:37.494	1	8	\N	\N	\N	bb75631f-6776-48c9-a68e-c22f3fc39353
180	View	view	collection	\N	179	12	71	5	\N	\N	71	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.499	2016-08-27 14:29:37.498	1	9	\N	\N	\N	4e59db20-4e4f-45c8-b1a7-21ff3fc522ba
181	Status Id	status-id	integer	1	\N	5	72	\N	\N	\N	72	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.51	2016-08-27 14:29:37.578	1	10	\N	\N	\N	e3a831e6-8a60-4fde-9a5e-cebd4fe50a8f
183	Status	status	part	\N	184	6	74	12	\N	\N	74	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.586	2016-08-27 14:29:37.586	1	12	\N	\N	\N	ddacc68b-2902-433e-ba08-8d904656278f
184	Locale	locale	collection	\N	183	12	75	6	\N	\N	75	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.59	2016-08-27 14:29:37.59	1	13	\N	\N	\N	e4fb9d14-6735-4e9a-a753-c6168aa0acf9
185	Status Id	status-id	integer	1	\N	6	76	\N	\N	\N	76	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.6	2016-08-27 14:29:37.665	1	14	\N	\N	\N	f6a24899-16bc-42ed-a76f-ecb2c56afcb9
187	Status	status	part	\N	188	7	78	12	\N	\N	78	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.674	2016-08-27 14:29:37.673	1	16	\N	\N	\N	7e7ed0d1-380d-4a6c-b79d-ba5a1eff4c13
188	Asset	asset	collection	\N	187	12	79	7	\N	\N	79	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.679	2016-08-27 14:29:37.678	1	17	\N	\N	\N	c6800be7-5a22-4819-b055-f1a5fb19c545
189	Status Id	status-id	integer	1	\N	7	80	\N	\N	\N	80	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.689	2016-08-27 14:29:37.763	1	18	\N	\N	\N	90b44d3c-fc15-41c5-ad5a-58db349ade14
191	Status	status	part	\N	192	8	82	12	\N	\N	82	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.775	2016-08-27 14:29:37.775	1	20	\N	\N	\N	705196c5-4d2e-43b5-8817-3818fe217942
192	Site	site	collection	\N	191	12	83	8	\N	\N	83	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.78	2016-08-27 14:29:37.78	1	21	\N	\N	\N	eb956fb2-78ba-472b-9b59-ca1d442bf07b
193	Status Id	status-id	integer	1	\N	8	84	\N	\N	\N	84	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.788	2016-08-27 14:29:37.869	1	22	\N	\N	\N	ddf8aa60-55c5-4c68-af0f-1ed41c6763c9
194	Status Position	status-position	position	\N	\N	8	85	\N	\N	\N	85	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.799	2016-08-27 14:29:37.799	1	23	\N	\N	\N	0c3f48b9-0150-4eae-a5c8-20dfb3cf1b55
196	Domain	domain	collection	\N	195	12	87	9	\N	\N	87	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.884	2016-08-27 14:29:37.883	1	25	\N	\N	\N	41371072-3d67-49f5-8c6c-5da96048fa36
197	Status Id	status-id	integer	1	\N	9	88	\N	\N	\N	88	f	f	f	t	f	f	f	\N	2016-08-27 14:29:37.894	2016-08-27 14:29:37.982	1	26	\N	\N	\N	a0f51673-9225-4479-98c7-a40c48c01151
199	Status	status	part	\N	200	10	90	12	\N	\N	90	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.996	2016-08-27 14:29:37.995	1	28	\N	\N	\N	2c7dd0f9-a59a-4fa3-8a98-24f793ae7bcc
200	Location	location	collection	\N	199	12	91	10	\N	\N	91	f	f	f	t	f	t	f	f	2016-08-27 14:29:38.001	2016-08-27 14:29:38.001	1	29	\N	\N	\N	7d15826a-7079-402b-9263-a6eadb923c19
201	Status Id	status-id	integer	1	\N	10	92	\N	\N	\N	92	f	f	f	t	f	f	f	\N	2016-08-27 14:29:38.012	2016-08-27 14:29:38.103	1	30	\N	\N	\N	1d2dbe14-e8d3-4ccf-93ca-74b0495d639d
202	Status Position	status-position	position	\N	\N	10	93	\N	\N	\N	93	f	f	f	t	f	f	f	f	2016-08-27 14:29:38.023	2016-08-27 14:29:38.023	1	31	\N	\N	\N	1e3830d2-47c7-4658-a452-63c5f04ed8c3
204	i18n	i18n	collection	\N	203	12	95	11	\N	\N	95	f	f	f	t	f	t	f	f	2016-08-27 14:29:38.12	2016-08-27 14:29:38.119	1	33	\N	\N	\N	a4013b18-2ec7-4926-a58a-dc9295ecab1c
205	Status Id	status-id	integer	1	\N	11	96	\N	\N	\N	96	f	f	f	t	f	f	f	\N	2016-08-27 14:29:38.133	2016-08-27 14:29:38.237	1	34	\N	\N	\N	0054072e-ea1e-4d01-9fbc-97d4cc10397e
207	Status	status	part	\N	208	12	98	12	\N	\N	98	f	f	f	t	f	t	f	f	2016-08-27 14:29:38.246	2016-08-27 14:29:38.246	1	36	\N	\N	\N	794707b9-38e0-4f78-9d10-3a0f93ace29b
209	Status Id	status-id	integer	1	\N	12	100	\N	\N	\N	100	f	f	f	t	f	f	f	\N	2016-08-27 14:29:38.261	2016-08-27 14:29:38.339	1	38	\N	\N	\N	5c8c50dc-be00-4c6f-a3d2-84087fa34f72
210	Status Position	status-position	position	\N	\N	12	101	\N	\N	\N	101	f	f	f	t	f	f	f	f	2016-08-27 14:29:38.27	2016-08-27 14:29:38.27	1	39	\N	\N	\N	066e1b71-7ac8-49ce-96b0-a3916e0eeb27
212	Username	username	string	\N	\N	3	103	\N	\N	\N	103	f	f	f	f	f	t	f	f	2016-08-27 14:29:38.521	2016-08-27 14:29:38.521	1	41	\N	\N	\N	e9f435fc-6ac4-47d5-8b56-0b6e9fae2d5c
213	Password	password	password	\N	\N	3	104	\N	\N	\N	104	f	f	f	f	f	t	f	f	2016-08-27 14:29:38.527	2016-08-27 14:29:38.527	1	42	\N	\N	\N	b7578c39-3dcb-4881-916b-f1586481381c
216	Map	map	boolean	\N	\N	2	106	\N	\N	\N	106	f	f	f	f	f	t	f	f	2016-08-27 14:29:39.277	2016-08-27 14:29:39.276	1	44	\N	\N	\N	ddf2cce2-075f-4ca9-a8a5-1b236c2d6f0c
208	Status Status	status-status	collection	\N	207	12	99	12	\N	\N	99	f	f	f	t	f	t	f	f	2016-08-27 14:29:38.251	2016-08-27 14:29:41.32	1	37	\N	\N	\N	756e3f12-e23c-4485-b8cc-1d6ccafdd5c4
52	Template	template	string	\N	\N	3	7	\N	\N	\N	7	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.112	2016-08-27 14:29:36.112	\N	\N	\N	\N	\N	c40163da-f41b-420d-8370-42103d60e3e8
2	Name	name	string	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.882	2016-08-27 14:29:35.881	\N	\N	\N	\N	\N	c49834ac-3143-4488-a093-faf55f42fd30
26	Target Id	target-id	integer	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.926	2016-08-27 14:29:35.926	\N	\N	\N	\N	\N	2ffcfde5-4d4b-43b9-abda-4798d39f0394
106	Updated At	updated-at	timestamp	\N	\N	8	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.52	2016-08-27 14:29:36.52	\N	\N	\N	\N	\N	7c995b39-0bd5-4fd2-a282-95e938a225ef
137	UUID	uuid	string	\N	\N	11	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.803	2016-08-27 14:29:36.803	\N	\N	\N	\N	\N	ae289aca-fe92-4255-843c-4cf13781af96
155	Domains	domains	collection	\N	156	8	46	9	\N	\N	46	f	f	f	f	f	t	f	t	2016-08-27 14:29:36.957	2016-08-27 14:29:36.957	\N	\N	\N	\N	\N	65f1346d-990a-4058-91b4-cbf3631649da
228	Spec	spec	structure	\N	\N	13	111	\N	\N	\N	111	f	f	f	f	f	t	f	f	2016-08-27 14:29:39.607	2016-08-27 14:29:39.607	1	49	\N	\N	\N	98c3058a-f77a-4f20-8e62-974001cb4163
230	Page	page	part	\N	229	13	113	3	\N	\N	113	f	f	f	f	f	t	f	f	2016-08-27 14:29:39.657	2016-08-27 14:29:39.657	1	51	\N	t	\N	8a984879-1ea7-47fb-a318-803313897a43
236	Enumeration	enumeration	collection	\N	235	12	119	14	\N	\N	119	f	f	f	t	f	t	f	f	2016-08-27 14:29:40.138	2016-08-27 14:29:40.138	1	57	\N	\N	f	82c1ab9f-5e31-49e8-a6fd-e7324a624727
246	entry	entry	string	\N	\N	14	122	\N	\N	\N	122	f	f	f	f	f	t	f	f	2016-08-27 14:29:40.264	2016-08-27 14:29:40.264	1	60	\N	\N	\N	1389d65c-3a00-4d6e-8a8e-130bc2719c47
248	Field	field	part	\N	247	14	124	2	\N	\N	124	f	f	f	t	f	t	f	f	2016-08-27 14:29:40.33	2016-08-27 14:29:40.329	1	62	\N	f	f	ff3bcf49-8a22-480a-a77a-8af24524a53d
152	Name	name	string	\N	\N	12	-1	\N	\N	\N	-1	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.874	2016-08-27 14:29:36.874	\N	\N	\N	\N	\N	7de06a53-6cda-4665-a27f-3952156f2b25
4	Description	description	text	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.886	2016-08-27 14:29:35.885	\N	\N	\N	\N	\N	0e4a4d02-6595-4dd6-b261-352b97ac43e1
7	Join Model	join-model	boolean	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.893	2016-08-27 14:29:35.892	\N	\N	\N	\N	\N	f385d96e-f7fa-41e8-b94c-910592ba80b6
12	Searchable	searchable	boolean	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.901	2016-08-27 14:29:35.9	\N	\N	\N	\N	\N	82da6029-b176-4368-999b-085e690986d5
15	Updated At	updated-at	timestamp	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:35.906	2016-08-27 14:29:35.906	\N	\N	\N	\N	\N	5fa11d99-d402-4b9f-9414-8ff1c8917ed1
19	Name	name	string	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.915	2016-08-27 14:29:35.914	\N	\N	\N	\N	\N	c5704e8c-bbd5-412c-816a-736f7ebc53eb
23	Description	description	text	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.922	2016-08-27 14:29:35.921	\N	\N	\N	\N	\N	de445432-675e-43b1-b174-508662dd699f
29	Required	required	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.931	2016-08-27 14:29:35.93	\N	\N	\N	\N	\N	63f9e011-e879-4e6c-9c25-a9f8e75da12d
32	Editable	editable	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.938	2016-08-27 14:29:35.937	\N	\N	\N	\N	\N	dc6bb9c5-ab5f-4acb-8718-3a0b887d5500
36	Dependent	dependent	boolean	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:35.944	2016-08-27 14:29:35.944	\N	\N	\N	\N	\N	b5a07d06-9c0d-486f-8316-163385ec1933
8	Fields	fields	collection	\N	28	1	0	2	\N	\N	0	f	f	f	t	f	t	f	t	2016-08-27 14:29:35.894	2016-08-27 14:29:35.894	\N	\N	\N	\N	\N	12a5d24b-dfaa-41b9-8d27-96204d9cb5ce
41	Position	position	position	\N	\N	3	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.03	2016-08-27 14:29:36.029	\N	\N	\N	\N	\N	3de1751d-61e6-4135-8651-8fdf64704b68
45	Updated At	updated-at	timestamp	\N	\N	3	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.037	2016-08-27 14:29:36.036	\N	\N	\N	\N	\N	ccf21fa4-62c6-4438-8ef6-51375508767f
221	Id	id	id	\N	\N	13	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:39.596	2016-08-27 14:29:39.596	1	\N	\N	\N	\N	e261b10c-63a2-4fb6-bcc4-d42a412b4dd2
126	Created At	created-at	timestamp	\N	\N	10	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.709	2016-08-27 14:29:36.709	\N	\N	\N	\N	\N	a9d25bfe-1d8a-437e-9708-3847f6055eef
245	Updated At	updated-at	timestamp	\N	\N	14	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:40.262	2016-08-27 14:29:40.261	1	\N	\N	\N	\N	63bbd390-7ee8-4ed2-bc86-28f5b09d074e
244	Created At	created-at	timestamp	\N	\N	14	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:40.261	2016-08-27 14:29:40.26	1	\N	\N	\N	\N	8d96b42f-55f0-4cfd-8765-cf9a883254c8
139	Env Id	env-id	integer	\N	\N	11	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.806	2016-08-27 14:29:36.806	\N	\N	\N	\N	\N	81f98985-26e2-4d57-ad48-8585bc4ed1b8
142	Updated At	updated-at	timestamp	\N	\N	11	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.81	2016-08-27 14:29:36.809	\N	\N	\N	\N	\N	36cdb0d2-8f46-4213-b9ef-beaf4adc81cf
243	Locked	locked	boolean	false	\N	14	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:40.259	2016-08-27 14:29:40.259	1	\N	\N	\N	\N	9683fbed-6fd1-4f77-85c8-3df40837de4f
242	Env Id	env-id	integer	\N	\N	14	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:40.258	2016-08-27 14:29:40.257	1	\N	\N	\N	\N	e0ebd9ee-2dfc-4649-91f2-00f3bdecb73d
148	Env Id	env-id	integer	\N	\N	12	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.867	2016-08-27 14:29:36.867	\N	\N	\N	\N	\N	86bed87e-2ed4-4b0a-bbf8-54b323cf3f40
151	Updated At	updated-at	timestamp	\N	\N	12	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.872	2016-08-27 14:29:36.872	\N	\N	\N	\N	\N	8dbc8362-f5b2-4523-81de-30eeac77c76f
241	Position	position	position	\N	\N	14	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:40.256	2016-08-27 14:29:40.256	1	\N	\N	\N	\N	ff545e82-b180-4559-8ef7-04ff55098054
240	UUID	uuid	string	\N	\N	14	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:40.255	2016-08-27 14:29:40.254	1	\N	\N	\N	\N	97c10df6-0bd7-4918-a61d-107da5b58b97
239	Id	id	id	\N	\N	14	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:40.253	2016-08-27 14:29:40.253	1	\N	\N	\N	\N	b88c4caa-a026-4ba3-ba67-d55c05f6998e
227	Updated At	updated-at	timestamp	\N	\N	13	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:39.605	2016-08-27 14:29:39.605	1	\N	\N	\N	\N	8ce21bef-ea48-40d8-9024-f33a705787bd
1	Id	id	integer	\N	\N	1	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:35.879	2016-08-27 14:29:35.878	\N	\N	\N	\N	\N	8f33f77d-9570-49e3-bb00-ccd2c8777718
80	Locked	locked	boolean	false	\N	6	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.356	2016-08-27 14:29:36.355	\N	\N	\N	\N	\N	cafe33f8-d695-4158-aae3-9e9d82e3bcb8
226	Created At	created-at	timestamp	\N	\N	13	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:39.603	2016-08-27 14:29:39.603	1	\N	\N	\N	\N	62fd5bbd-eeb0-47c6-828c-fcf1f3f0b48f
225	Locked	locked	boolean	false	\N	13	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:39.602	2016-08-27 14:29:39.602	1	\N	\N	\N	\N	c8a1da99-20c9-4673-a417-fc3386e00e1f
224	Env Id	env-id	integer	\N	\N	13	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:39.6	2016-08-27 14:29:39.6	1	\N	\N	\N	\N	a3b3728a-5624-4f32-b56d-a2fa1ac50a0d
223	Position	position	position	\N	\N	13	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:39.599	2016-08-27 14:29:39.599	1	\N	\N	\N	\N	0cc5b7b3-9dd2-4da4-bdd2-9379458b6509
222	UUID	uuid	string	\N	\N	13	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:39.598	2016-08-27 14:29:39.597	1	\N	\N	\N	\N	9fdd1981-8bbd-48af-9424-4d4258b85858
215	Format	format	string	\N	\N	2	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:38.785	2016-08-27 14:29:38.785	1	\N	\N	\N	\N	b5117773-1af9-41ca-9742-98fdc477f6b4
56	Position	position	position	\N	\N	4	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.168	2016-08-27 14:29:36.168	\N	\N	\N	\N	\N	c472cf7c-352b-4e86-970b-d1b1f5e71b93
218	Siphon	siphon	collection	\N	217	12	108	13	\N	\N	108	f	f	f	t	f	t	f	f	2016-08-27 14:29:39.498	2016-08-27 14:29:39.497	1	46	\N	\N	\N	944ebba8-2d89-406d-9365-e8c4c2e79192
219	Status Id	status-id	integer	1	\N	13	109	\N	\N	\N	109	f	f	f	t	f	f	f	\N	2016-08-27 14:29:39.506	2016-08-27 14:29:39.592	1	47	\N	\N	\N	631f98db-a493-4549-bf56-42b003c6c2e6
229	Siphons	siphons	collection	\N	230	3	112	13	\N	\N	112	f	f	f	f	f	t	f	f	2016-08-27 14:29:39.652	2016-08-27 14:29:39.652	1	50	\N	t	\N	0d680f3a-5d1d-4e69-b535-af945a27676b
232	Page Position	page-position	position	\N	\N	13	115	\N	\N	\N	115	f	f	f	f	f	f	f	f	2016-08-27 14:29:39.673	2016-08-27 14:29:39.672	1	53	\N	\N	\N	e14d7015-36b0-4945-ae94-f48bc3fca331
233	Page Key	page-key	string	\N	\N	13	116	\N	\N	\N	116	f	f	f	f	f	f	f	f	2016-08-27 14:29:39.678	2016-08-27 14:29:39.678	1	54	\N	\N	\N	cc154058-c27b-4d89-88b3-1471539c7b5f
235	Status	status	part	\N	236	14	118	12	\N	\N	118	f	f	f	t	f	t	f	f	2016-08-27 14:29:40.133	2016-08-27 14:29:40.132	1	56	\N	\N	\N	1c5a9a05-a77c-4e56-b3f7-fa1685ec77e0
237	Status Id	status-id	integer	1	\N	14	120	\N	\N	\N	120	f	f	f	t	f	f	f	\N	2016-08-27 14:29:40.147	2016-08-27 14:29:40.248	1	58	\N	\N	f	e6591edc-5443-45ec-b3b9-d7ead050fd46
247	Enumerations	enumerations	collection	\N	248	2	123	14	\N	\N	123	f	f	f	t	f	t	f	f	2016-08-27 14:29:40.324	2016-08-27 14:29:40.324	1	61	\N	\N	\N	3be1e222-0a9f-4717-943e-57165f253c36
249	Field Id	field-id	integer	\N	\N	14	125	\N	\N	\N	125	f	f	f	t	f	f	f	f	2016-08-27 14:29:40.338	2016-08-27 14:29:40.338	1	63	\N	\N	f	f00a352a-9e44-413e-8132-903bb2959710
251	UUID	uuid	string	\N	\N	1	127	\N	\N	\N	127	f	f	f	t	t	f	f	f	2016-08-27 14:29:40.792	2016-08-27 14:29:40.791	1	65	\N	\N	\N	46ef4698-e19d-4f1e-b8b7-b4473553682d
252	UUID	uuid	string	\N	\N	2	128	\N	\N	\N	128	f	f	f	t	t	f	f	f	2016-08-27 14:29:40.849	2016-08-27 14:29:40.849	1	66	\N	\N	\N	f1d8dab1-e3ef-451c-9159-311f30f145fe
59	Created At	created-at	timestamp	\N	\N	4	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.173	2016-08-27 14:29:36.173	\N	\N	\N	\N	\N	3dc2146b-a4cd-4e8a-a45b-2bf2759522a7
69	Position	position	position	\N	\N	5	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.281	2016-08-27 14:29:36.28	\N	\N	\N	\N	\N	05810ef3-2ffc-4e6e-b368-82d89f0e53b8
72	Created At	created-at	timestamp	\N	\N	5	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.286	2016-08-27 14:29:36.285	\N	\N	\N	\N	\N	248a539a-f4ea-4800-8577-cfe6d8f8a012
78	Position	position	position	\N	\N	6	0	\N	\N	\N	0	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.35	2016-08-27 14:29:36.35	\N	\N	\N	\N	\N	7ee7e51f-22fc-4e41-87df-a29f7e57fa54
87	Id	id	id	\N	\N	7	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.422	2016-08-27 14:29:36.421	\N	\N	\N	\N	\N	097ebe98-afad-4809-bd87-8599580963ba
90	Env Id	env-id	integer	\N	\N	7	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.426	2016-08-27 14:29:36.426	\N	\N	\N	\N	\N	51048c7f-d1f7-4d91-8c1c-c2d0ca575695
93	Updated At	updated-at	timestamp	\N	\N	7	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.43	2016-08-27 14:29:36.43	\N	\N	\N	\N	\N	6468cf62-7bff-4b52-b6ed-53a60044ac0d
103	Env Id	env-id	integer	\N	\N	8	0	\N	\N	\N	0	f	f	f	t	f	f	f	f	2016-08-27 14:29:36.517	2016-08-27 14:29:36.516	\N	\N	\N	\N	\N	11ba8229-6e33-4f4f-b431-63948e24b0ba
113	UUID	uuid	string	\N	\N	9	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.635	2016-08-27 14:29:36.635	\N	\N	\N	\N	\N	f304f110-0288-4170-859d-8d3d5059e6db
116	Locked	locked	boolean	false	\N	9	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.639	2016-08-27 14:29:36.638	\N	\N	\N	\N	\N	35cede73-44f5-430c-ae64-90f68574c4e4
122	UUID	uuid	string	\N	\N	10	0	\N	\N	\N	0	f	f	f	t	t	f	f	f	2016-08-27 14:29:36.704	2016-08-27 14:29:36.704	\N	\N	\N	\N	\N	f10675fa-df49-4631-8fde-b9a15077c8ff
48	Path	path	string	\N	\N	3	3	\N	\N	\N	3	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.079	2016-08-27 14:29:36.078	\N	\N	\N	\N	\N	aa4c28ca-3151-41d7-9354-f470fed74a68
51	Method	method	string	\N	\N	3	6	\N	\N	\N	6	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.105	2016-08-27 14:29:36.104	\N	\N	\N	\N	\N	0d5b4632-4134-4d49-8636-ce6d76ade0ef
62	Last Name	last-name	string	\N	\N	4	10	\N	\N	\N	10	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.19	2016-08-27 14:29:36.189	\N	\N	\N	\N	\N	fe1d6baa-8dc6-46b7-95be-9a28c85efc9d
66	Crypted Password	crypted-password	string	\N	\N	4	14	\N	\N	\N	14	f	f	f	f	f	f	f	f	2016-08-27 14:29:36.227	2016-08-27 14:29:36.227	\N	\N	\N	\N	\N	a8ec710e-b965-4a35-894b-5f9c6977dd78
84	Region	region	string	\N	\N	6	18	\N	\N	\N	18	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.372	2016-08-27 14:29:36.371	\N	\N	\N	\N	\N	35dc5244-093f-4176-a44b-38bf1ccf20ca
94	Filename	filename	string	\N	\N	7	21	\N	\N	\N	21	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.433	2016-08-27 14:29:36.433	\N	\N	\N	\N	\N	c5f1a33b-8dc3-41ca-8e8c-64ff59b1f286
98	Parent Id	parent-id	integer	\N	\N	7	25	\N	\N	\N	25	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.463	2016-08-27 14:29:36.462	\N	\N	\N	\N	\N	0bb16533-6281-4aed-a1a7-3024c90b847f
108	Slug	slug	slug	\N	107	8	28	\N	\N	\N	28	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.535	2016-08-27 14:29:36.535	\N	\N	\N	\N	\N	c46c3fe1-0e67-463d-9555-b81757aa291c
119	Name	name	string	\N	\N	9	32	\N	\N	\N	32	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.643	2016-08-27 14:29:36.643	\N	\N	\N	\N	\N	1587efcd-b2bb-4430-a01f-d3ed68691e70
129	Address Two	address-two	string	\N	\N	10	35	\N	\N	\N	35	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.723	2016-08-27 14:29:36.723	\N	\N	\N	\N	\N	088cb6b2-283d-442e-809d-45a8d4d7f52b
133	Country	country	string	\N	\N	10	39	\N	\N	\N	39	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.746	2016-08-27 14:29:36.746	\N	\N	\N	\N	\N	ff542f4e-ae7a-482c-b857-fb908aecac85
143	Resource Key	resource-key	string	\N	\N	11	42	\N	\N	\N	42	f	f	f	t	f	t	f	f	2016-08-27 14:29:36.812	2016-08-27 14:29:36.812	\N	\N	\N	\N	\N	54ef8cc7-b194-4180-8bc4-e9d060553ce3
156	Site	site	part	\N	155	9	47	8	\N	\N	47	f	f	f	f	f	t	f	t	2016-08-27 14:29:36.961	2016-08-27 14:29:36.961	\N	\N	\N	\N	\N	bb6136af-f9ff-4cf1-bf3d-1d603cec8c45
159	Pages	pages	collection	\N	160	8	50	3	\N	\N	50	f	f	f	f	f	t	f	f	2016-08-27 14:29:37.008	2016-08-27 14:29:37.007	\N	\N	\N	\N	\N	45abaa26-5edd-44d0-955f-6ba8e479b4b3
162	Site Position	site-position	position	\N	\N	3	53	\N	\N	\N	53	f	f	f	f	f	f	f	f	2016-08-27 14:29:37.029	2016-08-27 14:29:37.029	\N	\N	\N	\N	\N	e3ded09f-766f-4a33-ae3e-80a952699ff5
166	Status Position	status-position	position	\N	\N	1	57	\N	\N	\N	57	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.127	2016-08-27 14:29:37.127	\N	\N	\N	\N	\N	32f3c8c0-5da4-4b55-8631-ae93d37ec27b
170	Status Position	status-position	position	\N	\N	2	61	\N	\N	\N	61	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.238	2016-08-27 14:29:37.238	\N	\N	\N	\N	\N	53cf6d19-cb4e-4bc9-8146-df0184453555
174	Status Position	status-position	position	\N	\N	3	65	\N	\N	\N	65	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.322	2016-08-27 14:29:37.322	1	3	\N	\N	\N	f23a1802-71fa-4378-8184-e1b42f9a37af
178	Status Position	status-position	position	\N	\N	4	69	\N	\N	\N	69	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.423	2016-08-27 14:29:37.423	1	7	\N	\N	\N	58add3d3-f608-472e-871c-8a204328367c
182	Status Position	status-position	position	\N	\N	5	73	\N	\N	\N	73	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.518	2016-08-27 14:29:37.518	1	11	\N	\N	\N	876d8bd9-a35e-4cfe-aaa0-d9b0488f347f
186	Status Position	status-position	position	\N	\N	6	77	\N	\N	\N	77	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.608	2016-08-27 14:29:37.608	1	15	\N	\N	\N	cb68369e-800b-4ca7-8fdb-598c80950456
190	Status Position	status-position	position	\N	\N	7	81	\N	\N	\N	81	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.699	2016-08-27 14:29:37.699	1	19	\N	\N	\N	6f7c991e-0802-4e3c-91ff-f8e2e022a3e0
195	Status	status	part	\N	196	9	86	12	\N	\N	86	f	f	f	t	f	t	f	f	2016-08-27 14:29:37.879	2016-08-27 14:29:37.879	1	24	\N	\N	\N	f0d9e1ac-4987-4139-bfb0-f31421a63314
198	Status Position	status-position	position	\N	\N	9	89	\N	\N	\N	89	f	f	f	t	f	f	f	f	2016-08-27 14:29:37.906	2016-08-27 14:29:37.905	1	27	\N	\N	\N	01bb734b-1648-4e1c-8262-037e2374083b
203	Status	status	part	\N	204	11	94	12	\N	\N	94	f	f	f	t	f	t	f	f	2016-08-27 14:29:38.114	2016-08-27 14:29:38.114	1	32	\N	\N	\N	d1dba082-0432-49e6-983e-81f2e0ea824e
206	Status Position	status-position	position	\N	\N	11	97	\N	\N	\N	97	f	f	f	t	f	f	f	f	2016-08-27 14:29:38.145	2016-08-27 14:29:38.144	1	35	\N	\N	\N	a1061a51-1132-4e0d-9005-924b789f14f1
211	Protected	protected	boolean	\N	\N	3	102	\N	\N	\N	102	f	f	f	f	f	t	f	f	2016-08-27 14:29:38.515	2016-08-27 14:29:38.515	1	40	\N	\N	\N	32b9691b-cc9a-473c-bbd3-9032a8087755
214	Crypted Password	crypted-password	string	\N	\N	3	105	\N	\N	\N	105	f	f	f	f	f	f	f	f	2016-08-27 14:29:38.534	2016-08-27 14:29:38.534	1	43	\N	\N	\N	3f8d2d07-b6c6-4f83-8640-f582b92c53e2
217	Status	status	part	\N	218	13	107	12	\N	\N	107	f	f	f	t	f	t	f	f	2016-08-27 14:29:39.492	2016-08-27 14:29:39.492	1	45	\N	\N	\N	309d050e-e0d3-4629-ab22-35ee127d3c5a
220	Status Position	status-position	position	\N	\N	13	110	\N	\N	\N	110	f	f	f	t	f	f	f	f	2016-08-27 14:29:39.515	2016-08-27 14:29:39.515	1	48	\N	\N	\N	c057b388-f86c-404e-903c-99a228aca1a5
231	Page Id	page-id	integer	\N	\N	13	114	\N	\N	\N	114	f	f	f	f	f	f	f	f	2016-08-27 14:29:39.664	2016-08-27 14:29:39.664	1	52	\N	\N	\N	480cc025-a563-4ce9-b79f-fa3e88f85409
234	localized	localized	boolean	\N	\N	2	117	\N	\N	\N	117	f	f	f	f	f	t	f	f	2016-08-27 14:29:39.914	2016-08-27 14:29:39.913	1	55	\N	\N	\N	005f6425-8632-4a0d-9083-951def21a14d
238	Status Position	status-position	position	\N	\N	14	121	\N	\N	\N	121	f	f	f	t	f	f	f	f	2016-08-27 14:29:40.157	2016-08-27 14:29:40.157	1	59	\N	\N	f	a5429789-95cb-4b1b-ad96-68696b2f3acb
250	Field Position	field-position	position	\N	\N	14	126	\N	\N	\N	126	f	f	f	t	f	f	f	f	2016-08-27 14:29:40.349	2016-08-27 14:29:40.349	1	64	\N	\N	f	56db7d95-933a-43a8-a545-9fc90b28daec
253	Display	display	structure	\N	\N	1	129	\N	\N	\N	129	f	f	f	t	f	t	f	f	2016-08-27 14:29:41.506	2016-08-27 14:29:41.506	1	67	\N	\N	\N	6e63d9a6-22c5-4682-a83a-5847f735e4ca
255	Permission	permission	collection	\N	254	12	131	15	\N	\N	131	f	f	f	t	f	t	f	f	2016-08-27 14:29:41.976	2016-08-27 14:29:41.975	1	69	\N	\N	f	66ebc86d-47d1-49ad-a34a-bd6f929f24db
267	Permissions	permissions	collection	\N	266	1	136	15	\N	\N	136	f	f	f	f	f	t	f	f	2016-08-27 14:29:42.106	2016-08-27 14:29:42.106	1	74	\N	\N	f	a5617d18-4600-4c44-a927-f65a9c006ce4
271	Role	role	collection	\N	270	12	140	16	\N	\N	140	f	f	f	t	f	t	f	f	2016-08-27 14:29:42.24	2016-08-27 14:29:42.24	1	78	\N	\N	f	96790f0b-7a84-4233-ac9b-164fc8dc8107
287	Role	role	part	\N	288	4	149	16	\N	\N	149	f	f	f	f	f	t	f	f	2016-08-27 14:29:42.528	2016-08-27 14:29:42.528	1	87	\N	\N	\N	ffc41c8c-988b-4eed-a4ea-b200a136f52e
289	Role Id	role-id	integer	\N	\N	4	151	\N	\N	\N	151	f	f	f	f	f	f	f	\N	2016-08-27 14:29:42.543	2016-08-27 14:29:42.542	1	89	\N	\N	f	e0279190-6ca6-4702-8ba6-2db68df278e1
290	Role Position	role-position	position	\N	\N	4	152	\N	\N	\N	152	f	f	f	f	f	f	f	f	2016-08-27 14:29:42.552	2016-08-27 14:29:42.552	1	90	\N	\N	f	42626b1e-92c9-4765-9197-73f8a659f98b
301	Personapplicant	personapplicant	collection	\N	300	12	156	19	\N	\N	156	f	f	f	t	f	t	f	f	2016-08-27 15:13:30.272	2016-08-27 15:13:30.271	1	94	\N	\N	f	7a9dbd9d-9fb1-4584-b62a-704d11d4ee71
316	Businessapplicant	businessapplicant	collection	\N	315	12	164	20	\N	\N	164	f	f	f	t	f	t	f	f	2016-08-27 15:16:20.873	2016-08-27 15:16:20.873	1	102	\N	\N	f	cf0c13fc-c215-46e5-a93c-963567620bdd
360	Dealer	dealer	collection	\N	359	12	194	22	\N	\N	194	f	f	f	t	f	t	f	f	2016-08-27 15:25:47.798	2016-08-27 15:25:47.798	1	132	\N	\N	f	f3d0991c-a92b-4c56-b3dd-cabd0ba83bfd
408	Organization	organization	collection	\N	407	12	208	23	\N	\N	208	f	f	f	t	f	t	f	f	2016-08-27 16:00:16.478057	2016-08-27 16:00:16.477	1	146	\N	\N	f	b74dad53-58c8-4997-921d-bb2067a8310c
430	Product	product	collection	\N	429	12	221	24	\N	\N	221	f	f	f	t	f	t	f	f	2016-08-27 16:14:15.683004	2016-08-27 16:14:15.682	1	159	\N	\N	f	30d4e09b-e988-42c8-b637-93b65b722423
448	Collateral	collateral	collection	\N	447	12	232	26	\N	\N	232	f	f	f	t	f	t	f	f	2016-08-27 16:20:37.77628	2016-08-27 16:20:37.776	1	170	\N	\N	f	1f0e342f-3f61-49f0-8b20-93cc7823350d
476	Creditrequest	creditrequest	collection	\N	475	12	253	27	\N	\N	253	f	f	f	t	f	t	f	f	2016-08-27 16:47:21.177201	2016-08-27 16:47:21.177	1	191	\N	\N	f	4753cf31-45c2-4fb9-a8c1-a16bc283d47a
556	Creditreport	creditreport	collection	\N	555	12	300	28	\N	\N	326	f	f	f	t	f	t	f	f	2016-08-28 07:52:06.618	2016-08-28 07:52:06.618	1	264	\N	\N	f	892fa989-a221-4676-9bfe-f479a291cda6
575	Documents	documents	collection	\N	574	12	312	29	\N	\N	338	f	f	f	t	f	t	f	f	2016-08-28 08:01:46.135	2016-08-28 08:01:46.135	1	276	\N	\N	f	f3d9fb92-824f-4137-a679-37887a81f462
697	Creditline	creditline	collection	\N	696	12	360	35	\N	\N	386	f	f	f	t	f	t	f	f	2016-08-28 09:40:39.533	2016-08-28 09:40:39.532	1	324	\N	\N	f	246229de-8ce5-4b15-b497-698dd8a80d8e
715	Priorexperience	priorexperience	collection	\N	714	12	370	36	\N	\N	396	f	f	f	t	f	t	f	f	2016-08-28 10:25:53.097	2016-08-28 10:25:53.097	1	334	\N	\N	f	4f3d242f-c98b-4b94-b4e9-598bf8058183
762	Workflowhistory	workflowhistory	collection	\N	761	12	389	38	\N	\N	415	f	f	f	t	f	t	f	f	2016-08-28 11:29:43.952	2016-08-28 11:29:43.952	1	353	\N	\N	f	1a18e357-01d2-4382-b6b2-b00f61e128a0
782	Credit Report Personapplicant	credit-report-personapplicant	collection	\N	781	12	402	39	\N	\N	428	f	f	f	t	f	t	f	f	2016-08-28 15:15:24.405	2016-08-28 15:15:24.405	1	366	\N	\N	f	7189ef2f-7ac8-452e-aa4a-6dba0aa08bcc
803	Businessapplicant Credit Report	businessapplicant-credit-report	collection	\N	802	12	416	40	\N	\N	442	f	f	f	t	f	t	f	f	2016-08-28 15:16:51.31	2016-08-28 15:16:51.309	1	380	\N	\N	f	c57428ec-f429-44c8-b182-6bb14ac48eef
\.


--
-- Name: field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('field_id_seq', 822, true);


--
-- Data for Name: i18n; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY i18n (id, uuid, "position", env_id, locked, created_at, updated_at, resource_key, value, status_id, status_position) FROM stdin;
\.


--
-- Name: i18n_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('i18n_id_seq', 1, false);


--
-- Data for Name: locale; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY locale (id, uuid, "position", env_id, locked, created_at, updated_at, language, region, code, description, status_id, status_position) FROM stdin;
\.


--
-- Name: locale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('locale_id_seq', 1, false);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY location (id, uuid, "position", env_id, locked, created_at, updated_at, address, address_two, city, postal_code, state, country, lat, lng, status_id, status_position) FROM stdin;
1	ce90ae17-2b6b-4649-beaf-7ad9479591ac	0	1	f	2016-08-28 18:25:39.995	2016-08-28 18:25:39.994	Sandhills Lane	GU25 4BT Virginia Water	South East			England	\N	\N	1	0
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('location_id_seq', 1, true);


--
-- Data for Name: migration; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY migration (id, name, run_at) FROM stdin;
1	caribou.migrations.bootstrap	2016-08-27 14:29:38.343
2	caribou.migrations.page-protection	2016-08-27 14:29:38.607
3	caribou.migrations.add-text-format	2016-08-27 14:29:38.787
4	caribou.migrations.slugify-underscores	2016-08-27 14:29:39.126
5	caribou.migrations.field-map	2016-08-27 14:29:39.316
6	caribou.migrations.page-siphon	2016-08-27 14:29:39.75
7	caribou.migrations.field-localization	2016-08-27 14:29:39.958
8	caribou.migrations.enumeration	2016-08-27 14:29:40.448
9	caribou.migrations.model-field-dbslugs	2016-08-27 14:29:40.613
10	caribou.migrations.uuid	2016-08-27 14:29:41.155
11	caribou.migrations.field-unique-constraint	2016-08-27 14:29:41.336
12	caribou.migrations.model-display	2016-08-27 14:29:41.562
13	tundra2.migrations.default	2016-08-27 14:29:41.779
14	tundra2.migrations.admin	2016-08-27 14:29:42.814
\.


--
-- Name: migration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('migration_id_seq', 14, true);


--
-- Data for Name: model; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY model (id, name, slug, description, "position", nested, locked, join_model, abstract, localized, searchable, ancestor_id, created_at, updated_at, status_id, status_position, uuid, display) FROM stdin;
2	Field	field	a model that specifies what fields a model has	2	f	t	f	f	f	f	\N	2016-08-27 14:29:35.908	2016-08-27 14:29:40.844	\N	\N	544961f4-60bd-4c97-a6fd-10c11e1df451	\N
3	Page	page	center of all elements for a single request	3	t	t	f	f	f	f	\N	2016-08-27 14:29:36.002	2016-08-27 14:29:39.648	\N	\N	1dfc9e85-cbfc-4969-8004-5734d75de6e6	\N
5	View	view	a composition of content facets	5	f	t	f	f	f	f	\N	2016-08-27 14:29:36.275	2016-08-27 14:29:37.506	\N	\N	73bb4cdc-c556-4e6f-b319-5476b3b48da9	\N
6	Locale	locale	a collection of content for a particular geographical audience	6	f	t	f	f	f	f	\N	2016-08-27 14:29:36.342	2016-08-27 14:29:37.595	\N	\N	6fa79ba7-d9d5-464f-b29d-f38591cb46c9	\N
7	Asset	asset	a reference to some system resource	7	f	t	f	f	f	f	\N	2016-08-27 14:29:36.418	2016-08-27 14:29:37.684	\N	\N	69f2dd49-f4d0-4a93-bd62-9a1303d5f77f	\N
8	Site	site	maps to a particular set of pages	8	f	t	f	f	f	f	\N	2016-08-27 14:29:36.509	2016-08-27 14:29:37.785	\N	\N	ec11d7ba-231c-4d78-9b56-135ca36eefd5	\N
9	Domain	domain	each site may have several domain names that direct to its page set	9	f	t	f	f	f	f	\N	2016-08-27 14:29:36.631	2016-08-27 14:29:37.89	\N	\N	5de2180c-f745-4251-a01b-5fc5c65f3dac	\N
10	Location	location	a location somewhere on the planet	10	f	t	f	f	f	f	\N	2016-08-27 14:29:36.7	2016-08-27 14:29:38.008	\N	\N	b01b53a1-aa76-476c-9a69-fa92db86d970	\N
11	i18n	i18n	strings for internationalization	11	f	t	f	f	f	f	\N	2016-08-27 14:29:36.799	2016-08-27 14:29:38.127	\N	\N	aaf9b882-c7e4-4ab7-a6d6-10d521e13b71	\N
12	Status	status	all of the possible states a model can be in	12	f	t	f	f	f	f	\N	2016-08-27 14:29:36.858	2016-08-27 14:29:38.256	\N	\N	be7adb09-5c54-4be6-b7b2-85f0ae12e187	\N
13	Siphon	siphon	A specification of content that can be loaded in dynamically.	13	f	t	f	f	f	f	\N	2016-08-27 14:29:39.484	2016-08-27 14:29:39.66	1	0	961b4038-cb79-480e-9169-1a1bbab671b3	\N
14	Enumeration	enumeration	\N	14	f	t	f	f	f	f	\N	2016-08-27 14:29:40.122	2016-08-27 14:29:40.334	1	1	c7f21450-cf43-42f7-b98f-0c1bbdd30763	\N
1	Model	model	base model for models	1	f	t	f	f	f	f	\N	2016-08-27 14:29:35.861	2016-08-27 14:29:41.495	\N	\N	234a6f3b-6542-4bbd-91c9-ca7152c19bdb	\N
4	Account	account	representation of a person with a role and privileges	4	f	t	f	f	f	f	\N	2016-08-27 14:29:36.16	2016-08-27 14:29:42.538	\N	\N	69fa5b4e-dafb-451f-bb06-2c729cf1cec0	\N
\.


--
-- Name: model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('model_id_seq', 40, true);


--
-- Data for Name: page; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY page (id, uuid, "position", env_id, locked, created_at, updated_at, name, slug, path, controller, action, method, template, parent_id, site_id, site_position, status_id, status_position, protected, username, crypted_password) FROM stdin;
1	fea43c9c-51bb-427f-b377-ae2b1798289a	0	1	f	2016-08-27 14:29:41.776	2016-08-27 14:29:41.775	Home	home		home	home	\N	home.html	\N	\N	0	1	0	\N	\N	\N
\.


--
-- Name: page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('page_id_seq', 1, true);


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY permission (id, uuid, "position", env_id, locked, created_at, updated_at, status_id, status_position, mask, model_id, model_position, role_id, role_position) FROM stdin;
1	a639f490-9d33-46a7-8e43-2a7f2c85e8fb	0	1	f	2016-08-27 14:29:42.675	2016-08-27 14:29:42.68	1	0	15	1	0	1	0
2	bfce4700-2ba3-497a-83cd-5fbcf02f1140	1	1	f	2016-08-27 14:29:42.688	2016-08-27 14:29:42.691	1	1	15	2	1	1	1
3	c66e9502-36f5-441a-b5c1-d1ad7bc38921	2	1	f	2016-08-27 14:29:42.696	2016-08-27 14:29:42.699	1	2	15	3	2	1	2
4	c051b63c-02c3-4fa2-864f-9975ce0d01df	3	1	f	2016-08-27 14:29:42.705	2016-08-27 14:29:42.709	1	3	15	4	3	1	3
5	7f6a4ab9-ea5b-4d8b-89ae-8dbd9154a3b1	4	1	f	2016-08-27 14:29:42.713	2016-08-27 14:29:42.716	1	4	15	5	4	1	4
6	0addec8a-396a-4b90-82a3-86ac7f310972	5	1	f	2016-08-27 14:29:42.72	2016-08-27 14:29:42.723	1	5	15	6	5	1	5
7	4b83bbb0-0d27-4595-b915-1ee5407e9209	6	1	f	2016-08-27 14:29:42.728	2016-08-27 14:29:42.732	1	6	15	7	6	1	6
8	1dd1050c-4545-4c42-ae82-401bf649aeae	7	1	f	2016-08-27 14:29:42.736	2016-08-27 14:29:42.739	1	7	15	8	7	1	7
9	fa03b19d-b056-4927-a391-40c03456a7c9	8	1	f	2016-08-27 14:29:42.744	2016-08-27 14:29:42.746	1	8	15	9	8	1	8
10	4738f628-4d87-4d67-a762-9e682d4808c9	9	1	f	2016-08-27 14:29:42.75	2016-08-27 14:29:42.753	1	9	15	10	9	1	9
11	a4f9991d-dee0-48f0-af15-a6763d885cf8	10	1	f	2016-08-27 14:29:42.758	2016-08-27 14:29:42.762	1	10	15	11	10	1	10
12	a71265a2-02d1-4b07-a91e-460a6fbeb7cb	11	1	f	2016-08-27 14:29:42.768	2016-08-27 14:29:42.772	1	11	15	12	11	1	11
13	6b9971bf-7e32-40e7-a61c-d937a8135ae7	12	1	f	2016-08-27 14:29:42.776	2016-08-27 14:29:42.779	1	12	15	13	12	1	12
14	d4d3dfc2-cbf8-44fa-a6b0-f39243301886	13	1	f	2016-08-27 14:29:42.784	2016-08-27 14:29:42.788	1	13	15	14	13	1	13
15	546547ac-d795-47dd-83f7-77b603ebd691	14	1	f	2016-08-27 14:29:42.793	2016-08-27 14:29:42.795	1	14	15	15	14	1	14
16	f0371f94-c7ab-4ab4-861a-93cc333697c4	15	1	f	2016-08-27 14:29:42.8	2016-08-27 14:29:42.804	1	15	15	16	15	1	15
\.


--
-- Name: permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('permission_id_seq', 16, true);


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY role (id, uuid, "position", env_id, locked, created_at, updated_at, status_id, status_position, title, default_mask) FROM stdin;
1	5f71cd57-ae96-46a7-8d61-a820fd628fac	0	1	f	2016-08-27 14:29:42.668	2016-08-27 14:29:42.667	1	0	Admin	15
2	990c974b-5b42-4f2f-a2df-80d28106a4fc	1	1	f	2016-08-28 10:50:34.494	2016-08-28 10:50:34.494	1	1	Anonymous	\N
3	792e73b9-00a9-427b-9502-797313d06a10	2	1	f	2016-08-28 10:50:54.827	2016-08-28 10:50:54.827	1	2	RegisteredUser	\N
4	c4752b61-8a6b-4d01-aeff-060c8f7db5be	3	1	f	2016-08-28 10:53:24.489	2016-08-28 10:53:24.489	1	3	Retail Manager	\N
5	0c73d17a-6080-4799-8f34-9ecafd4994d4	4	1	f	2016-08-28 10:54:53.076	2016-08-28 10:54:53.076	1	4	Operations Director	\N
6	00fa4de3-ca2e-4013-b919-fd7be524355f	5	1	f	2016-08-28 10:55:22.689	2016-08-28 10:55:22.689	1	5	Underwriter	\N
7	be34da8e-2a4c-486a-8254-70f7fb454a2c	6	1	f	2016-08-28 10:55:23.902	2016-08-28 10:55:23.902	1	6	Underwriter	\N
8	90a9f626-a53a-47cc-9068-2d34627e6bf5	7	1	f	2016-08-28 10:55:35.296	2016-08-28 10:55:35.296	1	7	Senior Underwriter	\N
9	c66ec986-94d8-4354-839c-85b368f191ca	8	1	f	2016-08-28 10:56:04.73	2016-08-28 10:56:04.73	1	8	Concurrence Manager	\N
10	0159942c-d3c7-4724-baf5-0fa10b664ec7	9	1	f	2016-08-28 10:56:14.963	2016-08-28 10:56:14.963	1	9	Quality Reviewer	\N
\.


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('role_id_seq', 10, true);


--
-- Data for Name: siphon; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY siphon (id, uuid, "position", env_id, locked, created_at, updated_at, status_id, status_position, spec, page_id, page_position, page_key) FROM stdin;
\.


--
-- Name: siphon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('siphon_id_seq', 1, false);


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY site (id, uuid, "position", env_id, locked, created_at, updated_at, name, slug, asset_id, description, status_id, status_position) FROM stdin;
1	b67a17bd-dbb9-46a3-85f0-e94f9302377e	0	1	f	2016-08-27 14:29:41.763	2016-08-27 14:29:41.763	Site	site	\N	Frontend	1	0
\.


--
-- Name: site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('site_id_seq', 1, true);


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY status (id, uuid, "position", env_id, locked, created_at, updated_at, name, slug, description, status_id, status_position) FROM stdin;
1	fa8a4554-956b-4e00-b331-32e2bd5c3e57	0	1	t	2016-08-27 14:29:36.921	2016-08-27 14:29:36.921	Draft	draft	Draft status is not publicly visible	\N	\N
2	d7e5018d-4591-474f-9488-6212ce72f93d	0	1	t	2016-08-27 14:29:36.923	2016-08-27 14:29:36.923	Published	published	Published means visible to the public	\N	\N
\.


--
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('status_id_seq', 1, false);


--
-- Data for Name: view; Type: TABLE DATA; Schema: public; Owner: taiga
--

COPY view (id, uuid, "position", env_id, locked, created_at, updated_at, name, description, status_id, status_position) FROM stdin;
\.


--
-- Name: view_id_seq; Type: SEQUENCE SET; Schema: public; Owner: taiga
--

SELECT pg_catalog.setval('view_id_seq', 1, false);


--
-- Name: account_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: asset_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_pkey PRIMARY KEY (id);


--
-- Name: domain_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY domain
    ADD CONSTRAINT domain_pkey PRIMARY KEY (id);


--
-- Name: enumeration_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY enumeration
    ADD CONSTRAINT enumeration_pkey PRIMARY KEY (id);


--
-- Name: field_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY field
    ADD CONSTRAINT field_pkey PRIMARY KEY (id);


--
-- Name: i18n_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY i18n
    ADD CONSTRAINT i18n_pkey PRIMARY KEY (id);


--
-- Name: locale_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY locale
    ADD CONSTRAINT locale_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: migration_name_key; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_name_key UNIQUE (name);


--
-- Name: migration_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (id);


--
-- Name: model_id_slug_unique; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY field
    ADD CONSTRAINT model_id_slug_unique UNIQUE (model_id, slug);


--
-- Name: model_name_key; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY model
    ADD CONSTRAINT model_name_key UNIQUE (name);


--
-- Name: model_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY model
    ADD CONSTRAINT model_pkey PRIMARY KEY (id);


--
-- Name: model_slug_key; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY model
    ADD CONSTRAINT model_slug_key UNIQUE (slug);


--
-- Name: page_name_unique; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page_name_unique UNIQUE (name);


--
-- Name: page_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY page
    ADD CONSTRAINT page_pkey PRIMARY KEY (id);


--
-- Name: permission_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT permission_pkey PRIMARY KEY (id);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: siphon_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY siphon
    ADD CONSTRAINT siphon_pkey PRIMARY KEY (id);


--
-- Name: site_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pkey PRIMARY KEY (id);


--
-- Name: status_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- Name: view_pkey; Type: CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY view
    ADD CONSTRAINT view_pkey PRIMARY KEY (id);


--
-- Name: account_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX account_id_index ON account USING btree (id);


--
-- Name: account_role_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX account_role_id_index ON account USING btree (role_id);


--
-- Name: account_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX account_status_id_index ON account USING btree (status_id);


--
-- Name: account_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX account_uuid_index ON account USING btree (uuid);


--
-- Name: asset_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX asset_id_index ON asset USING btree (id);


--
-- Name: asset_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX asset_status_id_index ON asset USING btree (status_id);


--
-- Name: asset_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX asset_uuid_index ON asset USING btree (uuid);


--
-- Name: domain_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX domain_id_index ON domain USING btree (id);


--
-- Name: domain_site_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX domain_site_id_index ON domain USING btree (site_id);


--
-- Name: domain_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX domain_status_id_index ON domain USING btree (status_id);


--
-- Name: domain_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX domain_uuid_index ON domain USING btree (uuid);


--
-- Name: enumeration_field_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX enumeration_field_id_index ON enumeration USING btree (field_id);


--
-- Name: enumeration_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX enumeration_id_index ON enumeration USING btree (id);


--
-- Name: enumeration_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX enumeration_status_id_index ON enumeration USING btree (status_id);


--
-- Name: enumeration_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX enumeration_uuid_index ON enumeration USING btree (uuid);


--
-- Name: field_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX field_status_id_index ON field USING btree (status_id);


--
-- Name: field_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX field_uuid_index ON field USING btree (uuid);


--
-- Name: i18n_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX i18n_id_index ON i18n USING btree (id);


--
-- Name: i18n_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX i18n_status_id_index ON i18n USING btree (status_id);


--
-- Name: i18n_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX i18n_uuid_index ON i18n USING btree (uuid);


--
-- Name: locale_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX locale_id_index ON locale USING btree (id);


--
-- Name: locale_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX locale_status_id_index ON locale USING btree (status_id);


--
-- Name: locale_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX locale_uuid_index ON locale USING btree (uuid);


--
-- Name: location_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX location_id_index ON location USING btree (id);


--
-- Name: location_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX location_status_id_index ON location USING btree (status_id);


--
-- Name: location_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX location_uuid_index ON location USING btree (uuid);


--
-- Name: model_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX model_status_id_index ON model USING btree (status_id);


--
-- Name: model_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX model_uuid_index ON model USING btree (uuid);


--
-- Name: page_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX page_id_index ON page USING btree (id);


--
-- Name: page_site_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX page_site_id_index ON page USING btree (site_id);


--
-- Name: page_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX page_status_id_index ON page USING btree (status_id);


--
-- Name: page_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX page_uuid_index ON page USING btree (uuid);


--
-- Name: permission_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX permission_id_index ON permission USING btree (id);


--
-- Name: permission_model_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX permission_model_id_index ON permission USING btree (model_id);


--
-- Name: permission_role_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX permission_role_id_index ON permission USING btree (role_id);


--
-- Name: permission_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX permission_status_id_index ON permission USING btree (status_id);


--
-- Name: permission_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX permission_uuid_index ON permission USING btree (uuid);


--
-- Name: role_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX role_id_index ON role USING btree (id);


--
-- Name: role_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX role_status_id_index ON role USING btree (status_id);


--
-- Name: role_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX role_uuid_index ON role USING btree (uuid);


--
-- Name: siphon_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX siphon_id_index ON siphon USING btree (id);


--
-- Name: siphon_page_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX siphon_page_id_index ON siphon USING btree (page_id);


--
-- Name: siphon_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX siphon_status_id_index ON siphon USING btree (status_id);


--
-- Name: siphon_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX siphon_uuid_index ON siphon USING btree (uuid);


--
-- Name: site_asset_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX site_asset_id_index ON site USING btree (asset_id);


--
-- Name: site_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX site_id_index ON site USING btree (id);


--
-- Name: site_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX site_status_id_index ON site USING btree (status_id);


--
-- Name: site_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX site_uuid_index ON site USING btree (uuid);


--
-- Name: status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX status_id_index ON status USING btree (id);


--
-- Name: status_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX status_status_id_index ON status USING btree (status_id);


--
-- Name: status_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX status_uuid_index ON status USING btree (uuid);


--
-- Name: view_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX view_id_index ON view USING btree (id);


--
-- Name: view_status_id_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX view_status_id_index ON view USING btree (status_id);


--
-- Name: view_uuid_index; Type: INDEX; Schema: public; Owner: taiga
--

CREATE INDEX view_uuid_index ON view USING btree (uuid);


--
-- Name: field_model_id_model_fk; Type: FK CONSTRAINT; Schema: public; Owner: taiga
--

ALTER TABLE ONLY field
    ADD CONSTRAINT field_model_id_model_fk FOREIGN KEY (model_id) REFERENCES model(id) ON DELETE CASCADE;


--