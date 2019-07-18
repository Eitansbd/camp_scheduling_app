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
30	Test 2	Test 2 field	1	1	1	f
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('activities_id_seq', 30, true);


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
19	15	25	10	3
20	24	11	10	3
21	25	15	10	3
22	26	12	10	3
23	27	23	10	3
24	16	24	10	3
25	17	21	10	3
26	18	13	10	3
27	19	16	10	3
28	20	27	10	3
29	21	28	10	3
30	22	14	10	3
31	23	17	10	3
32	37	22	10	3
33	31	29	10	3
34	32	26	10	3
35	38	18	10	3
36	39	19	10	3
37	40	20	10	3
38	28	30	10	3
39	15	22	12	3
40	24	20	12	3
41	25	21	12	3
42	26	23	12	3
43	27	27	12	3
44	16	13	12	3
45	17	29	12	3
46	18	11	12	3
47	19	14	12	3
48	20	25	12	3
49	21	15	12	3
50	22	28	12	3
51	23	12	12	3
52	37	26	12	3
53	31	19	12	3
54	32	17	12	3
55	38	16	12	3
56	39	24	12	3
57	40	18	12	3
58	29	30	12	3
59	15	30	7	3
60	24	23	7	3
61	25	24	7	3
62	26	21	7	3
63	27	13	7	3
64	16	11	7	3
65	17	16	7	3
66	18	22	7	3
67	19	20	7	3
68	20	15	7	3
69	21	26	7	3
70	22	25	7	3
71	23	18	7	3
72	37	19	7	3
73	31	12	7	3
74	32	29	7	3
75	38	28	7	3
76	39	27	7	3
77	40	14	7	3
78	33	17	7	3
79	15	18	11	3
80	24	21	11	3
81	25	14	11	3
82	26	25	11	3
83	27	29	11	3
84	16	15	11	3
85	17	23	11	3
86	18	16	11	3
87	19	17	11	3
88	20	22	11	3
89	21	13	11	3
90	22	20	11	3
91	23	28	11	3
92	37	11	11	3
93	31	30	11	3
94	32	12	11	3
95	38	27	11	3
96	40	24	11	3
97	33	26	11	3
98	34	19	11	3
\.


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('schedule_id_seq', 98, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('time_slot_id_seq', 12, true);


--
-- Data for Name: time_slots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY time_slots (id, start_time, end_time, name) FROM stdin;
7	11:00:00	12:00:00	Period 1
10	01:00:00	03:00:00	Period 3
11	12:04:00	14:32:00	Period 4
12	10:00:00	23:00:00	Period 0
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
    ADD CONSTRAINT schedule_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(id);


--
-- Name: schedule_bunk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_bunk_id_fkey FOREIGN KEY (bunk_id) REFERENCES bunks(id);


--
-- Name: schedule_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_day_id_fkey FOREIGN KEY (day_id) REFERENCES days(id);


--
-- Name: schedule_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES time_slots(id);


--
-- PostgreSQL database dump complete
--

