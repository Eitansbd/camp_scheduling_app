--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

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
49	B13	1	M
50	B14	1	M
51	B15	1	M
52	B16	1	M
53	G11	1	F
54	G12	1	F
55	G13	1	F
56	G14	1	F
57	G15	1	F
58	G16	1	F
59	B4	2	M
60	B5	2	M
61	B6	2	M
62	B7	2	M
63	Gwhiz	2	F
64	G0	2	F
65	G0.5	2	F
66	G1	2	F
67	G2	2	F
68	B8	3	M
69	B9	3	M
70	B10	3	M
71	B11	3	M
72	G3R	3	F
73	G3L	3	F
74	G4R	3	F
75	G4L	3	F
76	B17	4	M
77	B18	4	M
78	B19	4	M
79	B20	4	M
80	G4.5	4	F
81	G9	4	F
82	G10	4	F
83	G17	4	F
84	G18	4	F
85	B1	5	M
86	B1.5	5	M
87	B2	5	M
88	B2.5	5	M
89	B3	5	M
90	G6.25	5	F
91	G6.5	5	F
92	G8	5	F
93	G7	5	F
94	G6.75	5	F
96	B12	1	M
\.


--
-- Name: bunks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('bunks_id_seq', 96, true);


--
-- Data for Name: days; Type: TABLE DATA; Schema: public; Owner: -
--

COPY days (id, calendar_date) FROM stdin;
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
\.


--
-- Name: days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('days_id_seq', 39, true);


--
-- Data for Name: time_slots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY time_slots (id, start_time, end_time) FROM stdin;
18	09:00:00	09:55:00
19	10:05:00	10:55:00
20	11:05:00	11:55:00
21	12:05:00	12:55:00
22	13:05:00	13:55:00
23	14:05:00	14:55:00
24	15:05:00	15:55:00
25	16:05:00	16:55:00
26	17:05:00	17:55:00
27	18:00:00	18:40:00
\.


--
-- Data for Name: default_schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY default_schedule (id, bunk_id, activity_id, time_slot_id) FROM stdin;
\.


--
-- Name: default_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('default_schedule_id_seq', 2, true);


--
-- Name: divisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('divisions_id_seq', 5, true);


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schedule (id, bunk_id, activity_id, time_slot_id, day_id) FROM stdin;
\.


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('schedule_id_seq', 178, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('time_slot_id_seq', 27, true);


--
-- PostgreSQL database dump complete
--

