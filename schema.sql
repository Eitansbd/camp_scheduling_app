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
-- Name: activities; Type: TABLE; Schema: public; Owner: jresnick3
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    location character varying(50) NOT NULL
);


ALTER TABLE public.activities OWNER TO jresnick3;

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: jresnick3
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activities_id_seq OWNER TO jresnick3;

--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jresnick3
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: bunks; Type: TABLE; Schema: public; Owner: jresnick3
--

CREATE TABLE public.bunks (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    division character varying(20) NOT NULL,
    gender character(1) NOT NULL
);


ALTER TABLE public.bunks OWNER TO jresnick3;

--
-- Name: bunks_id_seq; Type: SEQUENCE; Schema: public; Owner: jresnick3
--

CREATE SEQUENCE public.bunks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bunks_id_seq OWNER TO jresnick3;

--
-- Name: bunks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jresnick3
--

ALTER SEQUENCE public.bunks_id_seq OWNED BY public.bunks.id;


--
-- Name: days; Type: TABLE; Schema: public; Owner: jresnick3
--

CREATE TABLE public.days (
    id integer NOT NULL,
    calendar_date date NOT NULL
);


ALTER TABLE public.days OWNER TO jresnick3;

--
-- Name: days_id_seq; Type: SEQUENCE; Schema: public; Owner: jresnick3
--

CREATE SEQUENCE public.days_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.days_id_seq OWNER TO jresnick3;

--
-- Name: days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jresnick3
--

ALTER SEQUENCE public.days_id_seq OWNED BY public.days.id;


--
-- Name: schedule; Type: TABLE; Schema: public; Owner: jresnick3
--

CREATE TABLE public.schedule (
    id integer NOT NULL,
    bunk_id integer NOT NULL,
    activity_id integer NOT NULL,
    time_slot_id integer NOT NULL,
    day_id integer NOT NULL
);


ALTER TABLE public.schedule OWNER TO jresnick3;

--
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: jresnick3
--

CREATE SEQUENCE public.schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.schedule_id_seq OWNER TO jresnick3;

--
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jresnick3
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- Name: time_slots; Type: TABLE; Schema: public; Owner: jresnick3
--

CREATE TABLE public.time_slots (
    id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.time_slots OWNER TO jresnick3;

--
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: jresnick3
--

CREATE SEQUENCE public.time_slot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_slot_id_seq OWNER TO jresnick3;

--
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jresnick3
--

ALTER SEQUENCE public.time_slot_id_seq OWNED BY public.time_slots.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: bunks id; Type: DEFAULT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.bunks ALTER COLUMN id SET DEFAULT nextval('public.bunks_id_seq'::regclass);


--
-- Name: days id; Type: DEFAULT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.days ALTER COLUMN id SET DEFAULT nextval('public.days_id_seq'::regclass);


--
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- Name: time_slots id; Type: DEFAULT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.time_slots ALTER COLUMN id SET DEFAULT nextval('public.time_slot_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: jresnick3
--

COPY public.activities (id, name, location) FROM stdin;
3	basketball	gym
\.


--
-- Data for Name: bunks; Type: TABLE DATA; Schema: public; Owner: jresnick3
--

COPY public.bunks (id, name, division, gender) FROM stdin;
4	b1	2	M
\.


--
-- Data for Name: days; Type: TABLE DATA; Schema: public; Owner: jresnick3
--

COPY public.days (id, calendar_date) FROM stdin;
\.


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: jresnick3
--

COPY public.schedule (id, bunk_id, activity_id, time_slot_id, day_id) FROM stdin;
\.


--
-- Data for Name: time_slots; Type: TABLE DATA; Schema: public; Owner: jresnick3
--

COPY public.time_slots (id, start_time, end_time) FROM stdin;
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jresnick3
--

SELECT pg_catalog.setval('public.activities_id_seq', 3, true);


--
-- Name: bunks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jresnick3
--

SELECT pg_catalog.setval('public.bunks_id_seq', 4, true);


--
-- Name: days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jresnick3
--

SELECT pg_catalog.setval('public.days_id_seq', 2, true);


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jresnick3
--

SELECT pg_catalog.setval('public.schedule_id_seq', 7, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jresnick3
--

SELECT pg_catalog.setval('public.time_slot_id_seq', 4, true);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: bunks bunks_name_key; Type: CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.bunks
    ADD CONSTRAINT bunks_name_key UNIQUE (name);


--
-- Name: bunks bunks_pkey; Type: CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.bunks
    ADD CONSTRAINT bunks_pkey PRIMARY KEY (id);


--
-- Name: days days_pkey; Type: CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.days
    ADD CONSTRAINT days_pkey PRIMARY KEY (id);


--
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- Name: time_slots time_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.time_slots
    ADD CONSTRAINT time_slot_pkey PRIMARY KEY (id);


--
-- Name: time_slots time_slots_start_time_end_time_key; Type: CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.time_slots
    ADD CONSTRAINT time_slots_start_time_end_time_key UNIQUE (start_time, end_time);


--
-- Name: schedule schedule_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id) ON DELETE CASCADE;


--
-- Name: schedule schedule_bunk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_bunk_id_fkey FOREIGN KEY (bunk_id) REFERENCES public.bunks(id) ON DELETE CASCADE;


--
-- Name: schedule schedule_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_day_id_fkey FOREIGN KEY (day_id) REFERENCES public.days(id) ON DELETE CASCADE;


--
-- Name: schedule schedule_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jresnick3
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES public.time_slots(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--
