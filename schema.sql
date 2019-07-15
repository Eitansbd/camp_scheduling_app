--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    location character varying(50) NOT NULL,
    youngest_division_id integer,
    oldest_division_id integer,
    max_bunks integer,
    double boolean DEFAULT false
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: bunks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bunks (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    division_id integer NOT NULL,
    gender character(1) NOT NULL
);


--
-- Name: bunks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bunks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bunks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bunks_id_seq OWNED BY bunks.id;


--
-- Name: days; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE days (
    id integer NOT NULL,
    calendar_date date NOT NULL
);


--
-- Name: days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE days_id_seq OWNED BY days.id;


--
-- Name: default_schedule; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE default_schedule (
    id integer NOT NULL,
    bunk_id integer NOT NULL,
    activity_id integer NOT NULL,
    time_slot_id integer NOT NULL
);


--
-- Name: default_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE default_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: default_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE default_schedule_id_seq OWNED BY default_schedule.id;


--
-- Name: divisions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE divisions (
    id integer NOT NULL,
    name character varying(25) NOT NULL,
    age integer NOT NULL
);


--
-- Name: divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE divisions_id_seq OWNED BY divisions.id;


--
-- Name: schedule; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schedule (
    id integer NOT NULL,
    bunk_id integer NOT NULL,
    activity_id integer NOT NULL,
    time_slot_id integer NOT NULL,
    day_id integer NOT NULL
);


--
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedule_id_seq OWNED BY schedule.id;


--
-- Name: time_slots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE time_slots (
    id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    name character varying(25) NOT NULL
);


--
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE time_slot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE time_slot_id_seq OWNED BY time_slots.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bunks ALTER COLUMN id SET DEFAULT nextval('bunks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY days ALTER COLUMN id SET DEFAULT nextval('days_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY default_schedule ALTER COLUMN id SET DEFAULT nextval('default_schedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY divisions ALTER COLUMN id SET DEFAULT nextval('divisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule ALTER COLUMN id SET DEFAULT nextval('schedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY time_slots ALTER COLUMN id SET DEFAULT nextval('time_slot_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY activities (id, name, location, youngest_division_id, oldest_division_id, max_bunks, double) FROM stdin;
13	Mob	Behind Malon	1	5	1	f
14	Tennis	NCT	1	5	1	f
15	Hockey	NCH	1	5	2	f
16	Softball	Boys Field	1	5	1	f
17	Hockey	Pavilion	1	5	1	f
18	Basketball	NCB	1	5	1	f
19	Beach Volleyball	Beach Volleyball Court	1	5	1	f
20	Handball	Pavilion	1	5	1	f
21	Teva	L3	1	5	1	f
22	Zumba	Gefen	1	5	1	f
23	Tiedye	Behind Malon T	1	5	1	f
24	Soccer	New Field	1	5	1	f
25	Soccer	Boys Field	1	5	1	f
26	Melechet  Yad	L5	1	5	1	f
27	Melechet  Yad	Behind Beit Kneset	1	5	2	f
28	Dodge Ball	New Field	1	5	2	f
12	Music	L6	1	3	1	f
11	Gaga	Pit	1	4	1	f
29	Test	Test	1	3	1	f
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('activities_id_seq', 29, true);


--
-- Data for Name: bunks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY bunks (id, name, division_id, gender) FROM stdin;
19	B5	2	M
20	B6	2	M
21	B7	2	M
22	B8	2	M
23	B9	2	M
33	G4L	2	F
34	G4R	2	F
35	G5F	2	F
36	G5B	2	F
24	B14	3	M
25	B15	3	M
26	B16	3	M
27	B17	3	M
37	G1	4	F
38	G2	4	F
39	G3L	4	F
40	G3R	4	F
15	B1	1	M
16	B2	1	M
17	B3	1	M
18	B4	1	M
28	G7	1	F
29	G8	1	F
30	G9	1	F
31	G17	1	F
32	G18	1	F
\.


--
-- Name: bunks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bunks_id_seq', 46, true);


--
-- Data for Name: days; Type: TABLE DATA; Schema: public; Owner: -
--

COPY days (id, calendar_date) FROM stdin;
3	2019-08-04
4	2019-08-02
5	2019-07-28
6	2019-08-01
7	2019-08-02
8	2019-08-03
9	2019-08-04
10	2019-08-05
11	2019-08-06
12	2019-08-07
13	2019-08-08
14	2019-08-09
15	2019-08-10
16	2019-08-11
17	2019-08-12
18	2019-08-13
19	2019-08-14
20	2019-08-15
21	2019-08-16
22	2019-08-17
23	2019-08-18
24	2019-08-19
25	2019-08-20
26	2019-08-21
27	2019-08-22
28	2019-08-23
29	2019-08-24
30	2019-08-25
31	2019-08-26
32	2019-08-27
33	2019-08-28
34	2019-08-29
35	2019-08-30
36	2019-08-31
37	2019-09-01
38	2018-08-06
39	2019-07-05
\.


--
-- Name: days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('days_id_seq', 39, true);


--
-- Data for Name: default_schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY default_schedule (id, bunk_id, activity_id, time_slot_id) FROM stdin;
2	20	15	7
\.


--
-- Name: default_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('default_schedule_id_seq', 2, true);


--
-- Data for Name: divisions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY divisions (id, name, age) FROM stdin;
4	Gimmel	13
5	Daled	14
3	Bet	12
2	Aleph	11
1	Hey	10
\.


--
-- Name: divisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('divisions_id_seq', 5, true);


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schedule (id, bunk_id, activity_id, time_slot_id, day_id) FROM stdin;
10	20	14	7	3
12	20	16	10	3
14	20	17	10	4
15	20	21	7	5
16	20	22	11	3
17	20	17	10	6
18	20	17	10	38
19	15	29	10	3
20	24	25	10	3
21	25	15	10	3
22	26	23	10	3
23	27	28	10	3
24	16	24	10	3
25	17	16	10	3
26	18	18	10	3
27	19	14	10	3
28	20	26	10	3
29	21	20	10	3
30	22	22	10	3
31	23	27	10	3
32	37	11	10	3
33	31	19	10	3
34	32	17	10	3
35	38	13	10	3
36	39	21	10	3
37	33	12	10	3
38	15	17	7	3
39	24	20	7	3
40	25	18	7	3
41	26	26	7	3
42	27	11	7	3
43	16	19	7	3
44	17	24	7	3
45	18	16	7	3
46	19	22	7	3
47	20	15	7	3
48	21	25	7	3
49	22	12	7	3
50	23	29	7	3
51	37	28	7	3
52	31	23	7	3
53	32	27	7	3
54	38	21	7	3
55	39	14	7	3
56	40	13	7	3
57	15	12	11	3
58	24	14	11	3
59	25	20	11	3
60	26	16	11	3
61	27	17	11	3
62	16	15	11	3
63	17	13	11	3
64	18	23	11	3
65	19	29	11	3
66	20	18	11	3
67	21	28	11	3
68	22	24	11	3
69	23	25	11	3
70	37	22	11	3
71	31	27	11	3
72	32	19	11	3
73	38	26	11	3
74	39	11	11	3
75	40	21	11	3
76	15	22	10	17
77	24	19	10	17
78	25	29	10	17
79	26	16	10	17
80	27	24	10	17
81	16	14	10	17
82	17	18	10	17
83	18	11	10	17
84	19	26	10	17
85	20	12	10	17
86	21	25	10	17
87	22	13	10	17
88	23	28	10	17
89	37	20	10	17
90	31	15	10	17
91	32	27	10	17
92	38	21	10	17
93	39	17	10	17
94	40	23	10	17
95	15	11	7	17
96	24	27	7	17
97	25	18	7	17
98	26	24	7	17
99	27	21	7	17
100	16	12	7	17
101	17	29	7	17
102	18	23	7	17
103	19	14	7	17
104	20	15	7	17
105	21	20	7	17
106	22	26	7	17
107	23	13	7	17
108	37	17	7	17
109	31	16	7	17
110	32	19	7	17
111	38	22	7	17
112	39	25	7	17
113	40	28	7	17
114	15	19	11	17
115	24	21	11	17
116	25	14	11	17
117	26	20	11	17
118	27	22	11	17
119	16	16	11	17
120	17	15	11	17
121	18	24	11	17
122	19	29	11	17
123	20	18	11	17
124	21	12	11	17
125	22	11	11	17
126	23	25	11	17
127	37	26	11	17
128	31	23	11	17
129	32	17	11	17
130	38	28	11	17
131	39	13	11	17
132	40	27	11	17
\.


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('schedule_id_seq', 132, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('time_slot_id_seq', 11, true);


--
-- Data for Name: time_slots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY time_slots (id, start_time, end_time, name) FROM stdin;
7	11:00:00	12:00:00	Period 1
10	01:00:00	03:00:00	Period 3
11	12:04:00	14:32:00	Period 4
\.


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: bunks_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bunks
    ADD CONSTRAINT bunks_name_key UNIQUE (name);


--
-- Name: bunks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bunks
    ADD CONSTRAINT bunks_pkey PRIMARY KEY (id);


--
-- Name: days_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY days
    ADD CONSTRAINT days_pkey PRIMARY KEY (id);


--
-- Name: default_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_pkey PRIMARY KEY (id);


--
-- Name: divisions_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY divisions
    ADD CONSTRAINT divisions_name_key UNIQUE (name);


--
-- Name: divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);


--
-- Name: schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- Name: time_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY time_slots
    ADD CONSTRAINT time_slot_pkey PRIMARY KEY (id);


--
-- Name: time_slots_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY time_slots
    ADD CONSTRAINT time_slots_name_key UNIQUE (name);


--
-- Name: time_slots_start_time_end_time_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY time_slots
    ADD CONSTRAINT time_slots_start_time_end_time_key UNIQUE (start_time, end_time);


--
-- Name: activities_oldest_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_oldest_division_fkey FOREIGN KEY (oldest_division_id) REFERENCES divisions(id);


--
-- Name: activities_youngest_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_youngest_division_fkey FOREIGN KEY (youngest_division_id) REFERENCES divisions(id);


--
-- Name: bunks_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bunks
    ADD CONSTRAINT bunks_division_fkey FOREIGN KEY (division_id) REFERENCES divisions(id) ON DELETE CASCADE;


--
-- Name: default_schedule_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE;


--
-- Name: default_schedule_bunk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_bunk_id_fkey FOREIGN KEY (bunk_id) REFERENCES bunks(id) ON DELETE CASCADE;


--
-- Name: default_schedule_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES time_slots(id) ON DELETE CASCADE;


--
-- Name: schedule_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE;


--
-- Name: schedule_bunk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_bunk_id_fkey FOREIGN KEY (bunk_id) REFERENCES bunks(id) ON DELETE CASCADE;


--
-- Name: schedule_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_day_id_fkey FOREIGN KEY (day_id) REFERENCES days(id) ON DELETE CASCADE;


--
-- Name: schedule_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES time_slots(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

