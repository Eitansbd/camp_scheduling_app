--
-- PostgreSQL database dump
--

-- Dumped from database version 11.3
-- Dumped by pg_dump version 11.3

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

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    location character varying(50) NOT NULL,
    youngest_division_id integer,
    oldest_division_id integer,
    max_bunks integer
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: bunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bunks (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    division_id integer NOT NULL,
    gender character(1) NOT NULL
);


--
-- Name: bunks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bunks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bunks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bunks_id_seq OWNED BY public.bunks.id;


--
-- Name: days; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.days (
    id integer NOT NULL,
    calendar_date date NOT NULL
);


--
-- Name: days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.days_id_seq OWNED BY public.days.id;


--
-- Name: divisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.divisions (
    id integer NOT NULL,
    name character varying(25) NOT NULL,
    age integer NOT NULL
);


--
-- Name: divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.divisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.divisions_id_seq OWNED BY public.divisions.id;


--
-- Name: schedule; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule (
    id integer NOT NULL,
    bunk_id integer NOT NULL,
    activity_id integer NOT NULL,
    time_slot_id integer NOT NULL,
    day_id integer NOT NULL
);


--
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- Name: time_slots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.time_slots (
    id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    name character varying(25) NOT NULL
);


--
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.time_slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.time_slot_id_seq OWNED BY public.time_slots.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: bunks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bunks ALTER COLUMN id SET DEFAULT nextval('public.bunks_id_seq'::regclass);


--
-- Name: days id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.days ALTER COLUMN id SET DEFAULT nextval('public.days_id_seq'::regclass);


--
-- Name: divisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions ALTER COLUMN id SET DEFAULT nextval('public.divisions_id_seq'::regclass);


--
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- Name: time_slots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_slots ALTER COLUMN id SET DEFAULT nextval('public.time_slot_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.activities (id, name, location, youngest_division_id, oldest_division_id, max_bunks) FROM stdin;
13	Mob	Behind Malon	1	5	1
14	Tennis	NCT	1	5	1
15	Hockey	NCH	1	5	2
16	Softball	Boys Field	1	5	1
17	Hockey	Pavilion	1	5	1
18	Basketball	NCB	1	5	1
19	Beach Volleyball	Beach Volleyball Court	1	5	1
20	Handball	Pavilion	1	5	1
21	Teva	L3	1	5	1
22	Zumba	Gefen	1	5	1
23	Tiedye	Behind Malon T	1	5	1
24	Soccer	New Field	1	5	1
25	Soccer	Boys Field	1	5	1
26	Melechet  Yad	L5	1	5	1
27	Melechet  Yad	Behind Beit Kneset	1	5	2
28	Dodge Ball	New Field	1	5	2
12	Music	L6	1	3	1
11	Gaga	Pit	1	4	1
29	Test	Test	1	3	1
\.


--
-- Data for Name: bunks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bunks (id, name, division_id, gender) FROM stdin;
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
-- Data for Name: days; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.days (id, calendar_date) FROM stdin;
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
-- Data for Name: divisions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.divisions (id, name, age) FROM stdin;
4	Gimmel	13
5	Daled	14
3	Bet	12
2	Aleph	11
1	Hey	10
\.


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schedule (id, bunk_id, activity_id, time_slot_id, day_id) FROM stdin;
10	20	14	7	3
12	20	16	10	3
14	20	17	10	4
15	20	21	7	5
16	20	22	11	3
17	20	17	10	6
18	20	17	10	38
\.


--
-- Data for Name: time_slots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.time_slots (id, start_time, end_time, name) FROM stdin;
7	11:00:00	12:00:00	Period 1
10	01:00:00	03:00:00	Period 3
11	12:04:00	14:32:00	Period 4
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.activities_id_seq', 29, true);


--
-- Name: bunks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bunks_id_seq', 46, true);


--
-- Name: days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.days_id_seq', 39, true);


--
-- Name: divisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.divisions_id_seq', 5, true);


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.schedule_id_seq', 18, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.time_slot_id_seq', 11, true);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: bunks bunks_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bunks
    ADD CONSTRAINT bunks_name_key UNIQUE (name);


--
-- Name: bunks bunks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bunks
    ADD CONSTRAINT bunks_pkey PRIMARY KEY (id);


--
-- Name: days days_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.days
    ADD CONSTRAINT days_pkey PRIMARY KEY (id);


--
-- Name: divisions divisions_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_name_key UNIQUE (name);


--
-- Name: divisions divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);


--
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- Name: time_slots time_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_slots
    ADD CONSTRAINT time_slot_pkey PRIMARY KEY (id);


--
-- Name: time_slots time_slots_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_slots
    ADD CONSTRAINT time_slots_name_key UNIQUE (name);


--
-- Name: time_slots time_slots_start_time_end_time_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.time_slots
    ADD CONSTRAINT time_slots_start_time_end_time_key UNIQUE (start_time, end_time);


--
-- Name: activities activities_oldest_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_oldest_division_fkey FOREIGN KEY (oldest_division_id) REFERENCES public.divisions(id);


--
-- Name: activities activities_youngest_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_youngest_division_fkey FOREIGN KEY (youngest_division_id) REFERENCES public.divisions(id);


--
-- Name: bunks bunks_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bunks
    ADD CONSTRAINT bunks_division_fkey FOREIGN KEY (division_id) REFERENCES public.divisions(id) ON DELETE CASCADE;


--
-- Name: schedule schedule_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: schedule schedule_bunk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_bunk_id_fkey FOREIGN KEY (bunk_id) REFERENCES public.bunks(id) ON DELETE CASCADE;


--
-- Name: schedule schedule_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_day_id_fkey FOREIGN KEY (day_id) REFERENCES public.days(id) ON DELETE CASCADE;


--
-- Name: schedule schedule_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slots(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

