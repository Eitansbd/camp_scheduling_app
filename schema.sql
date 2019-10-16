--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: ec2-user; Tablespace: 
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


ALTER TABLE public.activities OWNER TO "ec2-user";

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activities_id_seq OWNER TO "ec2-user";

--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: bunks; Type: TABLE; Schema: public; Owner: ec2-user; Tablespace: 
--

CREATE TABLE bunks (
    id integer NOT NULL,
    name character varying(10) NOT NULL,
    division_id integer NOT NULL,
    gender character(1) NOT NULL
);


ALTER TABLE public.bunks OWNER TO "ec2-user";

--
-- Name: bunks_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE bunks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bunks_id_seq OWNER TO "ec2-user";

--
-- Name: bunks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE bunks_id_seq OWNED BY bunks.id;


--
-- Name: days; Type: TABLE; Schema: public; Owner: ec2-user; Tablespace: 
--

CREATE TABLE days (
    id integer NOT NULL,
    calendar_date date NOT NULL
);


ALTER TABLE public.days OWNER TO "ec2-user";

--
-- Name: days_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.days_id_seq OWNER TO "ec2-user";

--
-- Name: days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE days_id_seq OWNED BY days.id;


--
-- Name: default_schedule; Type: TABLE; Schema: public; Owner: ec2-user; Tablespace: 
--

CREATE TABLE default_schedule (
    id integer NOT NULL,
    bunk_id integer NOT NULL,
    activity_id integer NOT NULL,
    time_slot_id integer NOT NULL
);


ALTER TABLE public.default_schedule OWNER TO "ec2-user";

--
-- Name: default_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE default_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.default_schedule_id_seq OWNER TO "ec2-user";

--
-- Name: default_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE default_schedule_id_seq OWNED BY default_schedule.id;


--
-- Name: divisions; Type: TABLE; Schema: public; Owner: ec2-user; Tablespace: 
--

CREATE TABLE divisions (
    id integer NOT NULL,
    name character varying(25) NOT NULL,
    age integer NOT NULL
);


ALTER TABLE public.divisions OWNER TO "ec2-user";

--
-- Name: divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.divisions_id_seq OWNER TO "ec2-user";

--
-- Name: divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE divisions_id_seq OWNED BY divisions.id;


--
-- Name: schedule; Type: TABLE; Schema: public; Owner: ec2-user; Tablespace: 
--

CREATE TABLE schedule (
    id integer NOT NULL,
    bunk_id integer NOT NULL,
    activity_id integer NOT NULL,
    time_slot_id integer NOT NULL,
    day_id integer NOT NULL
);


ALTER TABLE public.schedule OWNER TO "ec2-user";

--
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.schedule_id_seq OWNER TO "ec2-user";

--
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE schedule_id_seq OWNED BY schedule.id;


--
-- Name: time_slots; Type: TABLE; Schema: public; Owner: ec2-user; Tablespace: 
--

CREATE TABLE time_slots (
    id integer NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.time_slots OWNER TO "ec2-user";

--
-- Name: time_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: ec2-user
--

CREATE SEQUENCE time_slot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_slot_id_seq OWNER TO "ec2-user";

--
-- Name: time_slot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ec2-user
--

ALTER SEQUENCE time_slot_id_seq OWNED BY time_slots.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY bunks ALTER COLUMN id SET DEFAULT nextval('bunks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY days ALTER COLUMN id SET DEFAULT nextval('days_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY default_schedule ALTER COLUMN id SET DEFAULT nextval('default_schedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY divisions ALTER COLUMN id SET DEFAULT nextval('divisions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY schedule ALTER COLUMN id SET DEFAULT nextval('schedule_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY time_slots ALTER COLUMN id SET DEFAULT nextval('time_slot_id_seq'::regclass);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: ec2-user
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
31	Teva	L3	1	5	1	f
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('activities_id_seq', 31, true);


--
-- Data for Name: bunks; Type: TABLE DATA; Schema: public; Owner: ec2-user
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
-- Name: bunks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('bunks_id_seq', 97, true);


--
-- Data for Name: days; Type: TABLE DATA; Schema: public; Owner: ec2-user
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
-- Name: days_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('days_id_seq', 39, true);


--
-- Data for Name: default_schedule; Type: TABLE DATA; Schema: public; Owner: ec2-user
--

COPY default_schedule (id, bunk_id, activity_id, time_slot_id) FROM stdin;
\.


--
-- Name: default_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('default_schedule_id_seq', 2, true);


--
-- Data for Name: divisions; Type: TABLE DATA; Schema: public; Owner: ec2-user
--

COPY divisions (id, name, age) FROM stdin;
4	Gimmel	13
5	Daled	14
3	Bet	12
2	Aleph	11
1	Hey	10
\.


--
-- Name: divisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('divisions_id_seq', 5, true);


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: ec2-user
--

COPY schedule (id, bunk_id, activity_id, time_slot_id, day_id) FROM stdin;
179	96	27	18	6
181	50	12	18	6
182	51	23	18	6
183	52	18	18	6
184	53	26	18	6
185	54	24	18	6
187	56	14	18	6
188	57	11	18	6
189	58	19	18	6
190	59	29	18	6
191	60	15	18	6
192	61	17	18	6
193	62	13	18	6
194	64	22	18	6
195	65	20	18	6
196	66	25	18	6
197	67	16	18	6
198	63	28	18	6
200	49	23	19	6
201	50	25	19	6
202	51	16	19	6
203	52	13	19	6
204	53	11	19	6
206	55	27	19	6
207	56	22	19	6
208	57	14	19	6
209	58	28	19	6
210	59	12	19	6
211	60	18	19	6
212	61	26	19	6
213	62	20	19	6
214	64	15	19	6
215	65	29	19	6
216	66	17	19	6
217	67	19	19	6
218	63	24	19	6
219	96	11	20	6
220	49	19	20	6
221	50	13	20	6
222	51	26	20	6
223	52	14	20	6
224	53	12	20	6
225	54	20	20	6
226	55	28	20	6
227	56	29	20	6
228	57	27	20	6
230	59	24	20	6
231	60	22	20	6
232	61	23	20	6
233	62	15	20	6
234	64	25	20	6
235	65	18	20	6
236	66	16	20	6
237	67	17	20	6
239	49	20	21	6
240	50	26	21	6
241	51	29	21	6
242	52	27	21	6
243	53	17	21	6
244	54	11	21	6
245	55	25	21	6
246	56	18	21	6
247	57	16	21	6
248	58	23	21	6
249	59	28	21	6
250	60	19	21	6
251	61	14	21	6
252	62	24	21	6
253	64	12	21	6
254	65	15	21	6
255	66	22	21	6
256	67	13	21	6
257	96	15	22	6
258	49	12	22	6
259	50	14	22	6
261	52	11	22	6
262	53	16	22	6
263	54	28	22	6
264	55	29	22	6
265	56	13	22	6
266	57	17	22	6
267	58	18	22	6
268	59	26	22	6
269	60	24	22	6
270	61	19	22	6
271	62	23	22	6
272	64	20	22	6
273	65	27	22	6
275	67	22	22	6
276	70	25	22	6
277	96	13	23	6
278	49	15	23	6
279	50	29	23	6
280	51	24	23	6
281	52	23	23	6
282	53	22	23	6
283	54	14	23	6
284	55	20	23	6
285	56	17	23	6
286	57	25	23	6
287	58	11	23	6
288	59	18	23	6
289	60	27	23	6
291	62	28	23	6
292	64	19	23	6
293	65	16	23	6
294	66	26	23	6
295	67	12	23	6
296	96	28	24	6
297	49	18	24	6
298	50	19	24	6
299	51	22	24	6
300	52	25	24	6
302	54	17	24	6
303	55	11	24	6
304	56	23	24	6
305	57	13	24	6
306	58	20	24	6
307	59	15	24	6
308	60	12	24	6
309	61	29	24	6
310	62	14	24	6
311	64	26	24	6
312	65	24	24	6
313	67	27	24	6
314	63	16	24	6
315	96	19	25	6
316	49	29	25	6
317	50	20	25	6
318	51	15	25	6
319	52	17	25	6
320	53	25	25	6
321	54	23	25	6
322	55	16	25	6
324	57	12	25	6
325	58	22	25	6
326	59	11	25	6
327	60	13	25	6
328	61	18	25	6
330	64	28	25	6
331	65	14	25	6
332	67	24	25	6
333	63	26	25	6
334	70	27	25	6
335	96	14	26	6
336	49	24	26	6
338	51	18	26	6
339	52	20	26	6
340	53	29	26	6
341	54	13	26	6
342	55	22	26	6
343	56	12	26	6
345	58	16	26	6
346	59	23	26	6
347	60	28	26	6
348	61	25	26	6
349	62	27	26	6
350	64	11	26	6
351	65	19	26	6
352	63	15	26	6
353	70	17	26	6
354	71	26	26	6
355	96	20	27	6
356	49	13	27	6
357	50	15	27	6
358	51	11	27	6
359	52	19	27	6
361	54	27	27	6
362	55	14	27	6
363	56	25	27	6
364	57	18	27	6
365	58	17	27	6
367	60	23	27	6
368	61	22	27	6
369	62	12	27	6
370	64	16	27	6
371	65	28	27	6
372	66	29	27	6
373	71	24	27	6
374	68	26	27	6
375	96	19	18	7
376	49	26	18	7
377	50	24	18	7
378	51	29	18	7
379	52	13	18	7
381	53	25	18	7
382	54	23	18	7
383	55	14	18	7
384	56	27	18	7
385	57	28	18	7
386	58	16	18	7
387	59	22	18	7
388	60	20	18	7
389	61	15	18	7
390	62	31	18	7
391	64	12	18	7
392	65	18	18	7
393	66	17	18	7
394	96	20	19	7
395	49	17	19	7
396	50	12	19	7
397	51	28	19	7
398	52	25	19	7
400	53	27	19	7
401	54	26	19	7
402	55	11	19	7
403	56	14	19	7
404	57	29	19	7
405	58	31	19	7
406	59	18	19	7
407	60	13	19	7
408	61	22	19	7
409	62	23	19	7
410	64	19	19	7
411	65	24	19	7
412	66	16	19	7
413	96	16	20	7
414	49	13	20	7
415	50	20	20	7
416	51	12	20	7
417	52	23	20	7
419	53	28	20	7
420	54	25	20	7
421	55	27	20	7
422	56	17	20	7
423	57	22	20	7
424	58	26	20	7
425	59	14	20	7
426	60	18	20	7
427	61	19	20	7
428	62	24	20	7
429	64	11	20	7
430	65	29	20	7
431	67	15	20	7
432	96	18	21	7
433	49	24	21	7
434	50	19	21	7
435	51	26	21	7
436	52	27	21	7
438	53	15	21	7
439	54	14	21	7
440	55	22	21	7
441	56	20	21	7
442	57	25	21	7
443	58	29	21	7
444	59	13	21	7
445	60	17	21	7
446	61	31	21	7
447	62	12	21	7
448	64	28	21	7
449	65	16	21	7
450	66	11	21	7
451	96	29	22	7
452	49	22	22	7
453	50	23	22	7
454	51	17	22	7
455	52	18	22	7
457	53	14	22	7
458	54	19	22	7
459	55	31	22	7
460	56	13	22	7
461	57	11	22	7
462	58	25	22	7
463	59	28	22	7
464	60	27	22	7
465	61	26	22	7
466	62	20	22	7
467	64	15	22	7
468	65	12	22	7
469	67	16	22	7
470	96	28	23	7
471	49	11	23	7
472	50	16	23	7
473	51	24	23	7
474	52	15	23	7
476	53	20	23	7
477	54	31	23	7
478	55	12	23	7
479	56	18	23	7
480	57	17	23	7
481	58	23	23	7
482	59	19	23	7
483	60	29	23	7
484	61	14	23	7
485	62	26	23	7
486	64	22	23	7
487	65	13	23	7
488	66	25	23	7
489	96	24	24	7
490	49	28	24	7
491	50	17	24	7
492	51	13	24	7
493	52	16	24	7
495	53	31	24	7
496	54	15	24	7
497	55	18	24	7
498	56	25	24	7
499	57	27	24	7
500	58	19	24	7
501	59	23	24	7
502	60	22	24	7
503	61	20	24	7
504	62	29	24	7
505	64	26	24	7
506	65	11	24	7
507	66	14	24	7
508	96	23	25	7
509	49	31	25	7
510	50	29	25	7
511	51	20	25	7
512	52	11	25	7
514	53	16	25	7
515	54	22	25	7
516	55	13	25	7
517	56	19	25	7
518	57	12	25	7
519	58	17	25	7
520	59	26	25	7
521	60	24	25	7
522	61	18	25	7
523	62	15	25	7
524	64	14	25	7
525	65	27	25	7
526	67	25	25	7
527	96	17	26	7
528	49	20	26	7
529	50	18	26	7
530	51	16	26	7
531	52	29	26	7
533	53	19	26	7
534	54	11	26	7
535	55	15	26	7
536	56	28	26	7
537	57	14	26	7
538	58	13	26	7
539	59	31	26	7
540	60	23	26	7
541	61	24	26	7
542	64	25	26	7
543	66	12	26	7
544	67	26	26	7
545	63	27	26	7
546	96	26	27	7
547	49	29	27	7
548	50	31	27	7
549	51	14	27	7
550	52	12	27	7
552	53	23	27	7
553	54	20	27	7
554	55	28	27	7
555	56	11	27	7
556	57	18	27	7
557	58	22	27	7
558	59	17	27	7
559	60	19	27	7
560	61	16	27	7
561	65	15	27	7
562	66	27	27	7
563	63	24	27	7
564	70	25	27	7
\.


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('schedule_id_seq', 564, true);


--
-- Name: time_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ec2-user
--

SELECT pg_catalog.setval('time_slot_id_seq', 27, true);


--
-- Data for Name: time_slots; Type: TABLE DATA; Schema: public; Owner: ec2-user
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
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: bunks_name_key; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY bunks
    ADD CONSTRAINT bunks_name_key UNIQUE (name);


--
-- Name: bunks_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY bunks
    ADD CONSTRAINT bunks_pkey PRIMARY KEY (id);


--
-- Name: days_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY days
    ADD CONSTRAINT days_pkey PRIMARY KEY (id);


--
-- Name: default_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_pkey PRIMARY KEY (id);


--
-- Name: divisions_name_key; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY divisions
    ADD CONSTRAINT divisions_name_key UNIQUE (name);


--
-- Name: divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY divisions
    ADD CONSTRAINT divisions_pkey PRIMARY KEY (id);


--
-- Name: schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- Name: time_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY time_slots
    ADD CONSTRAINT time_slot_pkey PRIMARY KEY (id);


--
-- Name: time_slots_start_time_end_time_key; Type: CONSTRAINT; Schema: public; Owner: ec2-user; Tablespace: 
--

ALTER TABLE ONLY time_slots
    ADD CONSTRAINT time_slots_start_time_end_time_key UNIQUE (start_time, end_time);


--
-- Name: activities_oldest_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_oldest_division_fkey FOREIGN KEY (oldest_division_id) REFERENCES divisions(id);


--
-- Name: activities_youngest_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_youngest_division_fkey FOREIGN KEY (youngest_division_id) REFERENCES divisions(id);


--
-- Name: bunks_division_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY bunks
    ADD CONSTRAINT bunks_division_fkey FOREIGN KEY (division_id) REFERENCES divisions(id) ON DELETE CASCADE;


--
-- Name: default_schedule_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE;


--
-- Name: default_schedule_bunk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_bunk_id_fkey FOREIGN KEY (bunk_id) REFERENCES bunks(id) ON DELETE CASCADE;


--
-- Name: default_schedule_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY default_schedule
    ADD CONSTRAINT default_schedule_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES time_slots(id) ON DELETE CASCADE;


--
-- Name: schedule_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(id) ON DELETE CASCADE;


--
-- Name: schedule_bunk_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_bunk_id_fkey FOREIGN KEY (bunk_id) REFERENCES bunks(id) ON DELETE CASCADE;


--
-- Name: schedule_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_day_id_fkey FOREIGN KEY (day_id) REFERENCES days(id) ON DELETE CASCADE;


--
-- Name: schedule_time_slot_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ec2-user
--

ALTER TABLE ONLY schedule
    ADD CONSTRAINT schedule_time_slot_id_fkey FOREIGN KEY (time_slot_id) REFERENCES time_slots(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

