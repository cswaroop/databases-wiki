set search_path=junk, public;
set client_encoding='UTF8';


COPY timezone (id, timezoneid, displayname, "offset", isindst, doesobservedst) FROM stdin;
264	Africa/Casablanca	Western European Time	0	1	1
265	Africa/Conakry	Greenwich Mean Time	0	0	0
266	Africa/Dakar	Greenwich Mean Time	0	0	0
267	Africa/El_Aaiun	Western European Time	0	1	1
268	Africa/Freetown	Greenwich Mean Time	0	0	0
269	Africa/Lome	Greenwich Mean Time	0	0	0
270	Africa/Monrovia	Greenwich Mean Time	0	0	0
271	Africa/Nouakchott	Greenwich Mean Time	0	0	0
272	Africa/Ouagadougou	Greenwich Mean Time	0	0	0
273	Africa/Sao_Tome	Greenwich Mean Time	0	0	0
274	Africa/Timbuktu	Greenwich Mean Time	0	0	0
275	America/Danmarkshavn	Greenwich Mean Time	0	0	0
276	Antarctica/Troll	Coordinated Universal Time	0	1	1
277	Atlantic/Canary	Western European Time	0	1	1
278	Atlantic/Faeroe	Western European Time	0	1	1
279	Atlantic/Faroe	Western European Time	0	1	1
280	Atlantic/Madeira	Western European Time	0	1	1
281	Atlantic/Reykjavik	Greenwich Mean Time	0	0	0
282	Atlantic/St_Helena	Greenwich Mean Time	0	0	0
283	Eire	Greenwich Mean Time	0	1	1
284	Etc/GMT	GMT+00:00	0	0	0
285	Etc/GMT+0	GMT+00:00	0	0	0
286	Etc/GMT-0	GMT+00:00	0	0	0
287	Etc/GMT0	GMT+00:00	0	0	0
288	Etc/Greenwich	Greenwich Mean Time	0	0	0
289	Etc/UCT	Coordinated Universal Time	0	0	0
290	Etc/UTC	Coordinated Universal Time	0	0	0
291	Etc/Universal	Coordinated Universal Time	0	0	0
292	Etc/Zulu	Coordinated Universal Time	0	0	0
293	Europe/Belfast	Greenwich Mean Time	0	1	1
294	Europe/Dublin	Greenwich Mean Time	0	1	1
295	Europe/Guernsey	Greenwich Mean Time	0	1	1
296	Europe/Isle_of_Man	Greenwich Mean Time	0	1	1
297	Europe/Jersey	Greenwich Mean Time	0	1	1
298	Europe/Lisbon	Western European Time	0	1	1
299	Europe/London	Greenwich Mean Time	0	1	1
300	GB	Greenwich Mean Time	0	1	1
301	GB-Eire	Greenwich Mean Time	0	1	1
302	GMT	Greenwich Mean Time	0	0	0
303	GMT0	GMT+00:00	0	0	0
304	Greenwich	Greenwich Mean Time	0	0	0
305	Iceland	Greenwich Mean Time	0	0	0
306	Portugal	Western European Time	0	1	1
307	UCT	Coordinated Universal Time	0	0	0
308	UTC	Coordinated Universal Time	0	0	0
309	Universal	Coordinated Universal Time	0	0	0
310	WET	Western European Time	0	1	1
311	Zulu	Coordinated Universal Time	0	0	0
312	Africa/Algiers	Central European Time	3600000	0	0
313	Africa/Bangui	Western African Time	3600000	0	0
314	Africa/Brazzaville	Western African Time	3600000	0	0
315	Africa/Ceuta	Central European Time	3600000	1	1
316	Africa/Douala	Western African Time	3600000	0	0
317	Africa/Kinshasa	Western African Time	3600000	0	0
318	Africa/Lagos	Western African Time	3600000	0	0
319	Africa/Libreville	Western African Time	3600000	0	0
320	Africa/Luanda	Western African Time	3600000	0	0
321	Africa/Malabo	Western African Time	3600000	0	0
322	Africa/Ndjamena	Western African Time	3600000	0	0
323	Africa/Niamey	Western African Time	3600000	0	0
324	Africa/Porto-Novo	Western African Time	3600000	0	0
325	Africa/Tunis	Central European Time	3600000	0	0
326	Africa/Windhoek	Western African Time	3600000	1	1
327	Arctic/Longyearbyen	Central European Time	3600000	1	1
328	Atlantic/Jan_Mayen	Central European Time	3600000	1	1
329	CET	Central European Time	3600000	1	1
330	ECT	Central European Time	3600000	1	1
331	Etc/GMT-1	GMT+01:00	3600000	0	0
332	Europe/Amsterdam	Central European Time	3600000	1	1
333	Europe/Andorra	Central European Time	3600000	1	1
334	Europe/Belgrade	Central European Time	3600000	1	1
335	Europe/Berlin	Central European Time	3600000	1	1
336	Europe/Bratislava	Central European Time	3600000	1	1
337	Europe/Brussels	Central European Time	3600000	1	1
338	Europe/Budapest	Central European Time	3600000	1	1
339	Europe/Busingen	Central European Time	3600000	1	1
340	Europe/Copenhagen	Central European Time	3600000	1	1
341	Europe/Gibraltar	Central European Time	3600000	1	1
342	Europe/Ljubljana	Central European Time	3600000	1	1
343	Europe/Luxembourg	Central European Time	3600000	1	1
344	Europe/Madrid	Central European Time	3600000	1	1
345	Europe/Malta	Central European Time	3600000	1	1
346	Europe/Monaco	Central European Time	3600000	1	1
347	Europe/Oslo	Central European Time	3600000	1	1
348	Europe/Paris	Central European Time	3600000	1	1
349	Europe/Podgorica	Central European Time	3600000	1	1
350	Europe/Prague	Central European Time	3600000	1	1
351	Europe/Rome	Central European Time	3600000	1	1
352	Europe/San_Marino	Central European Time	3600000	1	1
353	Europe/Sarajevo	Central European Time	3600000	1	1
354	Europe/Skopje	Central European Time	3600000	1	1
355	Europe/Stockholm	Central European Time	3600000	1	1
356	Europe/Tirane	Central European Time	3600000	1	1
357	Europe/Vaduz	Central European Time	3600000	1	1
358	Europe/Vatican	Central European Time	3600000	1	1
359	Europe/Vienna	Central European Time	3600000	1	1
360	Europe/Warsaw	Central European Time	3600000	1	1
361	Europe/Zagreb	Central European Time	3600000	1	1
362	Europe/Zurich	Central European Time	3600000	1	1
363	MET	Middle Europe Time	3600000	1	1
364	Poland	Central European Time	3600000	1	1
365	ART	Eastern European Time	7200000	0	1
366	Africa/Blantyre	Central African Time	7200000	0	0
367	Africa/Bujumbura	Central African Time	7200000	0	0
368	Africa/Cairo	Eastern European Time	7200000	0	1
369	Africa/Gaborone	Central African Time	7200000	0	0
370	Africa/Harare	Central African Time	7200000	0	0
371	Africa/Johannesburg	South Africa Standard Time	7200000	0	0
372	Africa/Kigali	Central African Time	7200000	0	0
373	Africa/Lubumbashi	Central African Time	7200000	0	0
374	Africa/Lusaka	Central African Time	7200000	0	0
375	Africa/Maputo	Central African Time	7200000	0	0
376	Africa/Maseru	South Africa Standard Time	7200000	0	0
377	Africa/Mbabane	South Africa Standard Time	7200000	0	0
378	Africa/Tripoli	Eastern European Time	7200000	0	0
379	Asia/Amman	Eastern European Time	7200000	1	1
380	Asia/Beirut	Eastern European Time	7200000	1	1
381	Asia/Damascus	Eastern European Time	7200000	1	1
382	Asia/Gaza	Eastern European Time	7200000	0	1
383	Asia/Hebron	Eastern European Time	7200000	0	1
384	Asia/Istanbul	Eastern European Time	7200000	1	1
385	Asia/Jerusalem	Israel Standard Time	7200000	1	1
386	Asia/Nicosia	Eastern European Time	7200000	1	1
387	Asia/Tel_Aviv	Israel Standard Time	7200000	1	1
388	CAT	Central African Time	7200000	0	0
389	EET	Eastern European Time	7200000	1	1
390	Egypt	Eastern European Time	7200000	0	1
391	Etc/GMT-2	GMT+02:00	7200000	0	0
392	Europe/Athens	Eastern European Time	7200000	1	1
393	Europe/Bucharest	Eastern European Time	7200000	1	1
394	Europe/Chisinau	Eastern European Time	7200000	1	1
395	Europe/Helsinki	Eastern European Time	7200000	1	1
396	Europe/Istanbul	Eastern European Time	7200000	1	1
397	Europe/Kiev	Eastern European Time	7200000	1	1
398	Europe/Mariehamn	Eastern European Time	7200000	1	1
399	Europe/Nicosia	Eastern European Time	7200000	1	1
400	Europe/Riga	Eastern European Time	7200000	1	1
401	Europe/Sofia	Eastern European Time	7200000	1	1
402	Europe/Tallinn	Eastern European Time	7200000	1	1
403	Europe/Tiraspol	Eastern European Time	7200000	1	1
404	Europe/Uzhgorod	Eastern European Time	7200000	1	1
405	Europe/Vilnius	Eastern European Time	7200000	1	1
406	Europe/Zaporozhye	Eastern European Time	7200000	1	1
407	Israel	Israel Standard Time	7200000	1	1
408	Libya	Eastern European Time	7200000	0	0
409	Turkey	Eastern European Time	7200000	1	1
410	Africa/Addis_Ababa	Eastern African Time	10800000	0	0
411	Africa/Asmara	Eastern African Time	10800000	0	0
412	Africa/Asmera	Eastern African Time	10800000	0	0
413	Africa/Dar_es_Salaam	Eastern African Time	10800000	0	0
414	Africa/Djibouti	Eastern African Time	10800000	0	0
415	Africa/Juba	Eastern African Time	10800000	0	0
416	Africa/Kampala	Eastern African Time	10800000	0	0
417	Africa/Khartoum	Eastern African Time	10800000	0	0
418	Africa/Mogadishu	Eastern African Time	10800000	0	0
419	Africa/Nairobi	Eastern African Time	10800000	0	0
420	Antarctica/Syowa	Syowa Time	10800000	0	0
421	Asia/Aden	Arabia Standard Time	10800000	0	0
422	Asia/Baghdad	Arabia Standard Time	10800000	0	0
423	Asia/Bahrain	Arabia Standard Time	10800000	0	0
424	Asia/Kuwait	Arabia Standard Time	10800000	0	0
425	Asia/Qatar	Arabia Standard Time	10800000	0	0
426	Asia/Riyadh	Arabia Standard Time	10800000	0	0
427	EAT	Eastern African Time	10800000	0	0
428	Etc/GMT-3	GMT+03:00	10800000	0	0
429	Europe/Kaliningrad	Further-eastern European Time	10800000	0	0
430	Europe/Minsk	Further-eastern European Time	10800000	0	0
431	Indian/Antananarivo	Eastern African Time	10800000	0	0
432	Indian/Comoro	Eastern African Time	10800000	0	0
433	Indian/Mayotte	Eastern African Time	10800000	0	0
434	Asia/Riyadh87	GMT+03:07	11224000	0	0
435	Asia/Riyadh88	GMT+03:07	11224000	0	0
436	Asia/Riyadh89	GMT+03:07	11224000	0	0
437	Mideast/Riyadh87	GMT+03:07	11224000	0	0
438	Mideast/Riyadh88	GMT+03:07	11224000	0	0
439	Mideast/Riyadh89	GMT+03:07	11224000	0	0
440	Asia/Tehran	Iran Standard Time	12600000	0	1
441	Iran	Iran Standard Time	12600000	0	1
442	Asia/Baku	Azerbaijan Time	14400000	1	1
443	Asia/Dubai	Gulf Standard Time	14400000	0	0
444	Asia/Muscat	Gulf Standard Time	14400000	0	0
445	Asia/Tbilisi	Georgia Time	14400000	0	0
446	Asia/Yerevan	Armenia Time	14400000	0	0
447	Etc/GMT-4	GMT+04:00	14400000	0	0
448	Europe/Moscow	Moscow Standard Time	14400000	0	0
449	Europe/Samara	Samara Time	14400000	0	0
450	Europe/Simferopol	Moscow Standard Time	14400000	0	0
451	Europe/Volgograd	Volgograd Time	14400000	0	0
452	Indian/Mahe	Seychelles Time	14400000	0	0
453	Indian/Mauritius	Mauritius Time	14400000	0	0
454	Indian/Reunion	Reunion Time	14400000	0	0
455	NET	Armenia Time	14400000	0	0
456	W-SU	Moscow Standard Time	14400000	0	0
457	Asia/Kabul	Afghanistan Time	16200000	0	0
458	Antarctica/Mawson	Mawson Time	18000000	0	0
459	Asia/Aqtau	Aqtau Time	18000000	0	0
460	Asia/Aqtobe	Aqtobe Time	18000000	0	0
461	Asia/Ashgabat	Turkmenistan Time	18000000	0	0
462	Asia/Ashkhabad	Turkmenistan Time	18000000	0	0
463	Asia/Dushanbe	Tajikistan Time	18000000	0	0
464	Asia/Karachi	Pakistan Time	18000000	0	0
465	Asia/Oral	Oral Time	18000000	0	0
466	Asia/Samarkand	Uzbekistan Time	18000000	0	0
467	Asia/Tashkent	Uzbekistan Time	18000000	0	0
468	Etc/GMT-5	GMT+05:00	18000000	0	0
469	Indian/Kerguelen	French Southern & Antarctic Lands Time	18000000	0	0
470	Indian/Maldives	Maldives Time	18000000	0	0
471	PLT	Pakistan Time	18000000	0	0
472	Asia/Calcutta	India Standard Time	19800000	0	0
473	Asia/Colombo	India Standard Time	19800000	0	0
474	Asia/Kolkata	India Standard Time	19800000	0	0
475	IST	India Standard Time	19800000	0	0
476	Asia/Kathmandu	Nepal Time	20700000	0	0
477	Asia/Katmandu	Nepal Time	20700000	0	0
478	Antarctica/Vostok	Vostok Time	21600000	0	0
479	Asia/Almaty	Alma-Ata Time	21600000	0	0
480	Asia/Bishkek	Kirgizstan Time	21600000	0	0
481	Asia/Dacca	Bangladesh Time	21600000	0	0
482	Asia/Dhaka	Bangladesh Time	21600000	0	0
483	Asia/Qyzylorda	Qyzylorda Time	21600000	0	0
484	Asia/Thimbu	Bhutan Time	21600000	0	0
485	Asia/Thimphu	Bhutan Time	21600000	0	0
486	Asia/Yekaterinburg	Yekaterinburg Time	21600000	0	0
487	BST	Bangladesh Time	21600000	0	0
488	Etc/GMT-6	GMT+06:00	21600000	0	0
489	Indian/Chagos	Indian Ocean Territory Time	21600000	0	0
490	Asia/Rangoon	Myanmar Time	23400000	0	0
491	Indian/Cocos	Cocos Islands Time	23400000	0	0
492	Antarctica/Davis	Davis Time	25200000	0	0
493	Asia/Bangkok	Indochina Time	25200000	0	0
494	Asia/Ho_Chi_Minh	Indochina Time	25200000	0	0
495	Asia/Hovd	Hovd Time	25200000	0	0
496	Asia/Jakarta	West Indonesia Time	25200000	0	0
497	Asia/Novokuznetsk	Novosibirsk Time	25200000	0	0
498	Asia/Novosibirsk	Novosibirsk Time	25200000	0	0
499	Asia/Omsk	Omsk Time	25200000	0	0
500	Asia/Phnom_Penh	Indochina Time	25200000	0	0
501	Asia/Pontianak	West Indonesia Time	25200000	0	0
502	Asia/Saigon	Indochina Time	25200000	0	0
503	Asia/Vientiane	Indochina Time	25200000	0	0
504	Etc/GMT-7	GMT+07:00	25200000	0	0
505	Indian/Christmas	Christmas Island Time	25200000	0	0
506	VST	Indochina Time	25200000	0	0
507	Antarctica/Casey	Western Standard Time (Australia)	28800000	0	0
508	Asia/Brunei	Brunei Time	28800000	0	0
509	Asia/Choibalsan	Choibalsan Time	28800000	0	0
510	Asia/Chongqing	China Standard Time	28800000	0	0
511	Asia/Chungking	China Standard Time	28800000	0	0
512	Asia/Harbin	China Standard Time	28800000	0	0
513	Asia/Hong_Kong	Hong Kong Time	28800000	0	0
514	Asia/Kashgar	China Standard Time	28800000	0	0
515	Asia/Krasnoyarsk	Krasnoyarsk Time	28800000	0	0
516	Asia/Kuala_Lumpur	Malaysia Time	28800000	0	0
517	Asia/Kuching	Malaysia Time	28800000	0	0
518	Asia/Macao	China Standard Time	28800000	0	0
519	Asia/Macau	China Standard Time	28800000	0	0
520	Asia/Makassar	Central Indonesia Time	28800000	0	0
521	Asia/Manila	Philippines Time	28800000	0	0
522	Asia/Shanghai	China Standard Time	28800000	0	0
523	Asia/Singapore	Singapore Time	28800000	0	0
524	Asia/Taipei	China Standard Time	28800000	0	0
525	Asia/Ujung_Pandang	Central Indonesia Time	28800000	0	0
526	Asia/Ulaanbaatar	Ulaanbaatar Time	28800000	0	0
527	Asia/Ulan_Bator	Ulaanbaatar Time	28800000	0	0
528	Asia/Urumqi	China Standard Time	28800000	0	0
529	Australia/Perth	Western Standard Time (Australia)	28800000	0	0
530	Australia/West	Western Standard Time (Australia)	28800000	0	0
531	CTT	China Standard Time	28800000	0	0
532	Etc/GMT-8	GMT+08:00	28800000	0	0
533	Hongkong	Hong Kong Time	28800000	0	0
534	PRC	China Standard Time	28800000	0	0
535	Singapore	Singapore Time	28800000	0	0
536	Australia/Eucla	Central Western Standard Time (Australia)	31500000	0	0
537	Asia/Dili	Timor-Leste Time	32400000	0	0
538	Asia/Irkutsk	Irkutsk Time	32400000	0	0
539	Asia/Jayapura	East Indonesia Time	32400000	0	0
540	Asia/Pyongyang	Korea Standard Time	32400000	0	0
541	Asia/Seoul	Korea Standard Time	32400000	0	0
542	Asia/Tokyo	Japan Standard Time	32400000	0	0
543	Etc/GMT-9	GMT+09:00	32400000	0	0
544	JST	Japan Standard Time	32400000	0	0
545	Japan	Japan Standard Time	32400000	0	0
546	Pacific/Palau	Palau Time	32400000	0	0
547	ROK	Korea Standard Time	32400000	0	0
548	ACT	Central Standard Time (Northern Territory)	34200000	0	0
549	Australia/Adelaide	Central Standard Time (South Australia)	34200000	1	1
550	Australia/Broken_Hill	Central Standard Time (South Australia/New South Wales)	34200000	1	1
551	Australia/Darwin	Central Standard Time (Northern Territory)	34200000	0	0
552	Australia/North	Central Standard Time (Northern Territory)	34200000	0	0
553	Australia/South	Central Standard Time (South Australia)	34200000	1	1
554	Australia/Yancowinna	Central Standard Time (South Australia/New South Wales)	34200000	1	1
555	AET	Eastern Standard Time (New South Wales)	36000000	1	1
556	Antarctica/DumontDUrville	Dumont-d'Urville Time	36000000	0	0
557	Asia/Khandyga	Khandyga Time	36000000	0	0
558	Asia/Yakutsk	Yakutsk Time	36000000	0	0
559	Australia/ACT	Eastern Standard Time (New South Wales)	36000000	1	1
560	Australia/Brisbane	Eastern Standard Time (Queensland)	36000000	0	0
561	Australia/Canberra	Eastern Standard Time (New South Wales)	36000000	1	1
562	Australia/Currie	Eastern Standard Time (New South Wales)	36000000	1	1
563	Australia/Hobart	Eastern Standard Time (Tasmania)	36000000	1	1
564	Australia/Lindeman	Eastern Standard Time (Queensland)	36000000	0	0
565	Australia/Melbourne	Eastern Standard Time (Victoria)	36000000	1	1
566	Australia/NSW	Eastern Standard Time (New South Wales)	36000000	1	1
567	Australia/Queensland	Eastern Standard Time (Queensland)	36000000	0	0
568	Australia/Sydney	Eastern Standard Time (New South Wales)	36000000	1	1
569	Australia/Tasmania	Eastern Standard Time (Tasmania)	36000000	1	1
570	Australia/Victoria	Eastern Standard Time (Victoria)	36000000	1	1
571	Etc/GMT-10	GMT+10:00	36000000	0	0
572	Pacific/Chuuk	Chuuk Time	36000000	0	0
573	Pacific/Guam	Chamorro Standard Time	36000000	0	0
574	Pacific/Port_Moresby	Papua New Guinea Time	36000000	0	0
575	Pacific/Saipan	Chamorro Standard Time	36000000	0	0
576	Pacific/Truk	Chuuk Time	36000000	0	0
577	Pacific/Yap	Chuuk Time	36000000	0	0
578	Australia/LHI	Lord Howe Standard Time	37800000	1	1
579	Australia/Lord_Howe	Lord Howe Standard Time	37800000	1	1
580	Antarctica/Macquarie	Macquarie Island Time	39600000	0	0
581	Asia/Sakhalin	Sakhalin Time	39600000	0	0
582	Asia/Ust-Nera	Ust-Nera Time	39600000	0	0
583	Asia/Vladivostok	Vladivostok Time	39600000	0	0
584	Etc/GMT-11	GMT+11:00	39600000	0	0
585	Pacific/Efate	Vanuatu Time	39600000	0	0
586	Pacific/Guadalcanal	Solomon Is. Time	39600000	0	0
587	Pacific/Kosrae	Kosrae Time	39600000	0	0
588	Pacific/Noumea	New Caledonia Time	39600000	0	0
589	Pacific/Pohnpei	Pohnpei Time	39600000	0	0
590	Pacific/Ponape	Pohnpei Time	39600000	0	0
591	SST	Solomon Is. Time	39600000	0	0
592	Pacific/Norfolk	Norfolk Time	41400000	0	0
593	Antarctica/McMurdo	New Zealand Standard Time	43200000	1	1
594	Antarctica/South_Pole	New Zealand Standard Time	43200000	1	1
595	Asia/Anadyr	Anadyr Time	43200000	0	0
596	Asia/Kamchatka	Petropavlovsk-Kamchatski Time	43200000	0	0
597	Asia/Magadan	Magadan Time	43200000	0	0
598	Etc/GMT-12	GMT+12:00	43200000	0	0
599	Kwajalein	Marshall Islands Time	43200000	0	0
600	NST	New Zealand Standard Time	43200000	1	1
601	NZ	New Zealand Standard Time	43200000	1	1
602	Pacific/Auckland	New Zealand Standard Time	43200000	1	1
603	Pacific/Fiji	Fiji Time	43200000	0	1
604	Pacific/Funafuti	Tuvalu Time	43200000	0	0
605	Pacific/Kwajalein	Marshall Islands Time	43200000	0	0
606	Pacific/Majuro	Marshall Islands Time	43200000	0	0
607	Pacific/Nauru	Nauru Time	43200000	0	0
608	Pacific/Tarawa	Gilbert Is. Time	43200000	0	0
609	Pacific/Wake	Wake Time	43200000	0	0
610	Pacific/Wallis	Wallis & Futuna Time	43200000	0	0
611	NZ-CHAT	Chatham Standard Time	45900000	1	1
612	Pacific/Chatham	Chatham Standard Time	45900000	1	1
613	Etc/GMT-13	GMT+13:00	46800000	0	0
614	MIT	West Samoa Time	46800000	1	1
615	Pacific/Apia	West Samoa Time	46800000	1	1
616	Pacific/Enderbury	Phoenix Is. Time	46800000	0	0
617	Pacific/Fakaofo	Tokelau Time	46800000	0	0
618	Pacific/Tongatapu	Tonga Time	46800000	0	0
619	Etc/GMT-14	GMT+14:00	50400000	0	0
620	Pacific/Kiritimati	Line Is. Time	50400000	0	0
1	Etc/GMT+12	GMT-12:00	-43200000	0	0
2	Etc/GMT+11	GMT-11:00	-39600000	0	0
3	Pacific/Midway	Samoa Standard Time	-39600000	0	0
4	Pacific/Niue	Niue Time	-39600000	0	0
5	Pacific/Pago_Pago	Samoa Standard Time	-39600000	0	0
6	Pacific/Samoa	Samoa Standard Time	-39600000	0	0
7	US/Samoa	Samoa Standard Time	-39600000	0	0
8	America/Adak	Hawaii-Aleutian Standard Time	-36000000	1	1
9	America/Atka	Hawaii-Aleutian Standard Time	-36000000	1	1
10	Etc/GMT+10	GMT-10:00	-36000000	0	0
11	HST	Hawaii Standard Time	-36000000	0	0
12	Pacific/Honolulu	Hawaii Standard Time	-36000000	0	0
13	Pacific/Johnston	Hawaii Standard Time	-36000000	0	0
14	Pacific/Rarotonga	Cook Is. Time	-36000000	0	0
15	Pacific/Tahiti	Tahiti Time	-36000000	0	0
16	SystemV/HST10	Hawaii Standard Time	-36000000	0	0
17	US/Aleutian	Hawaii-Aleutian Standard Time	-36000000	1	1
18	US/Hawaii	Hawaii Standard Time	-36000000	0	0
19	Pacific/Marquesas	Marquesas Time	-34200000	0	0
20	AST	Alaska Standard Time	-32400000	1	1
21	America/Anchorage	Alaska Standard Time	-32400000	1	1
22	America/Juneau	Alaska Standard Time	-32400000	1	1
23	America/Nome	Alaska Standard Time	-32400000	1	1
24	America/Sitka	Alaska Standard Time	-32400000	1	1
25	America/Yakutat	Alaska Standard Time	-32400000	1	1
26	Etc/GMT+9	GMT-09:00	-32400000	0	0
27	Pacific/Gambier	Gambier Time	-32400000	0	0
28	SystemV/YST9	Alaska Standard Time	-32400000	0	0
29	SystemV/YST9YDT	Alaska Standard Time	-32400000	1	1
30	US/Alaska	Alaska Standard Time	-32400000	1	1
31	America/Dawson	Pacific Standard Time	-28800000	1	1
32	America/Ensenada	Pacific Standard Time	-28800000	1	1
33	America/Los_Angeles	Pacific Standard Time	-28800000	1	1
34	America/Metlakatla	Metlakatla Standard Time	-28800000	0	0
35	America/Santa_Isabel	Pacific Standard Time	-28800000	1	1
36	America/Tijuana	Pacific Standard Time	-28800000	1	1
37	America/Vancouver	Pacific Standard Time	-28800000	1	1
38	America/Whitehorse	Pacific Standard Time	-28800000	1	1
39	Canada/Pacific	Pacific Standard Time	-28800000	1	1
40	Canada/Yukon	Pacific Standard Time	-28800000	1	1
41	Etc/GMT+8	GMT-08:00	-28800000	0	0
42	Mexico/BajaNorte	Pacific Standard Time	-28800000	1	1
43	PST	Pacific Standard Time	-28800000	1	1
44	PST8PDT	Pacific Standard Time	-28800000	1	1
45	Pacific/Pitcairn	Pitcairn Standard Time	-28800000	0	0
46	SystemV/PST8	Pacific Standard Time	-28800000	0	0
47	SystemV/PST8PDT	Pacific Standard Time	-28800000	1	1
48	US/Pacific	Pacific Standard Time	-28800000	1	1
49	US/Pacific-New	Pacific Standard Time	-28800000	1	1
50	America/Boise	Mountain Standard Time	-25200000	1	1
51	America/Cambridge_Bay	Mountain Standard Time	-25200000	1	1
52	America/Chihuahua	Mountain Standard Time	-25200000	1	1
53	America/Creston	Mountain Standard Time	-25200000	0	0
54	America/Dawson_Creek	Mountain Standard Time	-25200000	0	0
55	America/Denver	Mountain Standard Time	-25200000	1	1
56	America/Edmonton	Mountain Standard Time	-25200000	1	1
57	America/Hermosillo	Mountain Standard Time	-25200000	0	0
58	America/Inuvik	Mountain Standard Time	-25200000	1	1
59	America/Mazatlan	Mountain Standard Time	-25200000	1	1
60	America/Ojinaga	Mountain Standard Time	-25200000	1	1
61	America/Phoenix	Mountain Standard Time	-25200000	0	0
62	America/Shiprock	Mountain Standard Time	-25200000	1	1
63	America/Yellowknife	Mountain Standard Time	-25200000	1	1
64	Canada/Mountain	Mountain Standard Time	-25200000	1	1
65	Etc/GMT+7	GMT-07:00	-25200000	0	0
66	MST	Mountain Standard Time	-25200000	0	0
67	MST7MDT	Mountain Standard Time	-25200000	1	1
68	Mexico/BajaSur	Mountain Standard Time	-25200000	1	1
69	Navajo	Mountain Standard Time	-25200000	1	1
70	PNT	Mountain Standard Time	-25200000	0	0
71	SystemV/MST7	Mountain Standard Time	-25200000	0	0
72	SystemV/MST7MDT	Mountain Standard Time	-25200000	1	1
73	US/Arizona	Mountain Standard Time	-25200000	0	0
74	US/Mountain	Mountain Standard Time	-25200000	1	1
75	America/Bahia_Banderas	Central Standard Time	-21600000	1	1
76	America/Belize	Central Standard Time	-21600000	0	0
77	America/Cancun	Central Standard Time	-21600000	1	1
78	America/Chicago	Central Standard Time	-21600000	1	1
79	America/Costa_Rica	Central Standard Time	-21600000	0	0
80	America/El_Salvador	Central Standard Time	-21600000	0	0
81	America/Guatemala	Central Standard Time	-21600000	0	0
82	America/Indiana/Knox	Central Standard Time	-21600000	1	1
83	America/Indiana/Tell_City	Central Standard Time	-21600000	1	1
84	America/Knox_IN	Central Standard Time	-21600000	1	1
85	America/Managua	Central Standard Time	-21600000	0	0
86	America/Matamoros	Central Standard Time	-21600000	1	1
87	America/Menominee	Central Standard Time	-21600000	1	1
88	America/Merida	Central Standard Time	-21600000	1	1
89	America/Mexico_City	Central Standard Time	-21600000	1	1
90	America/Monterrey	Central Standard Time	-21600000	1	1
91	America/North_Dakota/Beulah	Central Standard Time	-21600000	1	1
92	America/North_Dakota/Center	Central Standard Time	-21600000	1	1
93	America/North_Dakota/New_Salem	Central Standard Time	-21600000	1	1
94	America/Rainy_River	Central Standard Time	-21600000	1	1
95	America/Rankin_Inlet	Central Standard Time	-21600000	1	1
96	America/Regina	Central Standard Time	-21600000	0	0
97	America/Resolute	Central Standard Time	-21600000	1	1
98	America/Swift_Current	Central Standard Time	-21600000	0	0
99	America/Tegucigalpa	Central Standard Time	-21600000	0	0
100	America/Winnipeg	Central Standard Time	-21600000	1	1
101	CST	Central Standard Time	-21600000	1	1
102	CST6CDT	Central Standard Time	-21600000	1	1
103	Canada/Central	Central Standard Time	-21600000	1	1
104	Canada/East-Saskatchewan	Central Standard Time	-21600000	0	0
105	Canada/Saskatchewan	Central Standard Time	-21600000	0	0
106	Chile/EasterIsland	Easter Is. Time	-21600000	1	1
107	Etc/GMT+6	GMT-06:00	-21600000	0	0
108	Mexico/General	Central Standard Time	-21600000	1	1
109	Pacific/Easter	Easter Is. Time	-21600000	1	1
110	Pacific/Galapagos	Galapagos Time	-21600000	0	0
111	SystemV/CST6	Central Standard Time	-21600000	0	0
112	SystemV/CST6CDT	Central Standard Time	-21600000	1	1
113	US/Central	Central Standard Time	-21600000	1	1
114	US/Indiana-Starke	Central Standard Time	-21600000	1	1
115	America/Atikokan	Eastern Standard Time	-18000000	0	0
116	America/Bogota	Colombia Time	-18000000	0	0
117	America/Cayman	Eastern Standard Time	-18000000	0	0
118	America/Coral_Harbour	Eastern Standard Time	-18000000	0	0
119	America/Detroit	Eastern Standard Time	-18000000	1	1
120	America/Eirunepe	Central Standard Time (Northern Territory)	-18000000	0	0
121	America/Fort_Wayne	Eastern Standard Time	-18000000	1	1
122	America/Grand_Turk	Eastern Standard Time	-18000000	1	1
123	America/Guayaquil	Ecuador Time	-18000000	0	0
124	America/Havana	Cuba Standard Time	-18000000	1	1
125	America/Indiana/Indianapolis	Eastern Standard Time	-18000000	1	1
126	America/Indiana/Marengo	Eastern Standard Time	-18000000	1	1
127	America/Indiana/Petersburg	Eastern Standard Time	-18000000	1	1
128	America/Indiana/Vevay	Eastern Standard Time	-18000000	1	1
129	America/Indiana/Vincennes	Eastern Standard Time	-18000000	1	1
130	America/Indiana/Winamac	Eastern Standard Time	-18000000	1	1
131	America/Indianapolis	Eastern Standard Time	-18000000	1	1
132	America/Iqaluit	Eastern Standard Time	-18000000	1	1
133	America/Jamaica	Eastern Standard Time	-18000000	0	0
134	America/Kentucky/Louisville	Eastern Standard Time	-18000000	1	1
135	America/Kentucky/Monticello	Eastern Standard Time	-18000000	1	1
136	America/Lima	Peru Time	-18000000	0	0
137	America/Louisville	Eastern Standard Time	-18000000	1	1
138	America/Montreal	Eastern Standard Time	-18000000	1	1
139	America/Nassau	Eastern Standard Time	-18000000	1	1
140	America/New_York	Eastern Standard Time	-18000000	1	1
141	America/Nipigon	Eastern Standard Time	-18000000	1	1
142	America/Panama	Eastern Standard Time	-18000000	0	0
143	America/Pangnirtung	Eastern Standard Time	-18000000	1	1
144	America/Port-au-Prince	Eastern Standard Time	-18000000	1	1
145	America/Porto_Acre	Central Standard Time (Northern Territory)	-18000000	0	0
146	America/Rio_Branco	Central Standard Time (Northern Territory)	-18000000	0	0
147	America/Thunder_Bay	Eastern Standard Time	-18000000	1	1
148	America/Toronto	Eastern Standard Time	-18000000	1	1
149	Brazil/Acre	Central Standard Time (Northern Territory)	-18000000	0	0
150	Canada/Eastern	Eastern Standard Time	-18000000	1	1
151	Cuba	Cuba Standard Time	-18000000	1	1
152	EST	Eastern Standard Time	-18000000	0	0
153	EST5EDT	Eastern Standard Time	-18000000	1	1
154	Etc/GMT+5	GMT-05:00	-18000000	0	0
155	IET	Eastern Standard Time	-18000000	1	1
156	Jamaica	Eastern Standard Time	-18000000	0	0
157	SystemV/EST5	Eastern Standard Time	-18000000	0	0
158	SystemV/EST5EDT	Eastern Standard Time	-18000000	1	1
159	US/East-Indiana	Eastern Standard Time	-18000000	1	1
160	US/Eastern	Eastern Standard Time	-18000000	1	1
161	US/Michigan	Eastern Standard Time	-18000000	1	1
162	America/Caracas	Venezuela Time	-16200000	0	0
163	America/Anguilla	Atlantic Standard Time	-14400000	0	0
164	America/Antigua	Atlantic Standard Time	-14400000	0	0
165	America/Aruba	Atlantic Standard Time	-14400000	0	0
166	America/Asuncion	Paraguay Time	-14400000	1	1
167	America/Barbados	Atlantic Standard Time	-14400000	0	0
168	America/Blanc-Sablon	Atlantic Standard Time	-14400000	0	0
169	America/Boa_Vista	Amazon Time	-14400000	0	0
170	America/Campo_Grande	Amazon Time	-14400000	1	1
171	America/Cuiaba	Amazon Time	-14400000	1	1
172	America/Curacao	Atlantic Standard Time	-14400000	0	0
173	America/Dominica	Atlantic Standard Time	-14400000	0	0
174	America/Glace_Bay	Atlantic Standard Time	-14400000	1	1
175	America/Goose_Bay	Atlantic Standard Time	-14400000	1	1
176	America/Grenada	Atlantic Standard Time	-14400000	0	0
177	America/Guadeloupe	Atlantic Standard Time	-14400000	0	0
178	America/Guyana	Guyana Time	-14400000	0	0
179	America/Halifax	Atlantic Standard Time	-14400000	1	1
180	America/Kralendijk	Atlantic Standard Time	-14400000	0	0
181	America/La_Paz	Bolivia Time	-14400000	0	0
182	America/Lower_Princes	Atlantic Standard Time	-14400000	0	0
183	America/Manaus	Amazon Time	-14400000	0	0
184	America/Marigot	Atlantic Standard Time	-14400000	0	0
185	America/Martinique	Atlantic Standard Time	-14400000	0	0
186	America/Moncton	Atlantic Standard Time	-14400000	1	1
187	America/Montserrat	Atlantic Standard Time	-14400000	0	0
188	America/Port_of_Spain	Atlantic Standard Time	-14400000	0	0
189	America/Porto_Velho	Amazon Time	-14400000	0	0
190	America/Puerto_Rico	Atlantic Standard Time	-14400000	0	0
191	America/Santiago	Chile Time	-14400000	1	1
192	America/Santo_Domingo	Atlantic Standard Time	-14400000	0	0
193	America/St_Barthelemy	Atlantic Standard Time	-14400000	0	0
194	America/St_Kitts	Atlantic Standard Time	-14400000	0	0
195	America/St_Lucia	Atlantic Standard Time	-14400000	0	0
196	America/St_Thomas	Atlantic Standard Time	-14400000	0	0
197	America/St_Vincent	Atlantic Standard Time	-14400000	0	0
198	America/Thule	Atlantic Standard Time	-14400000	1	1
199	America/Tortola	Atlantic Standard Time	-14400000	0	0
200	America/Virgin	Atlantic Standard Time	-14400000	0	0
201	Antarctica/Palmer	Chile Time	-14400000	1	1
202	Atlantic/Bermuda	Atlantic Standard Time	-14400000	1	1
203	Brazil/West	Amazon Time	-14400000	0	0
204	Canada/Atlantic	Atlantic Standard Time	-14400000	1	1
205	Chile/Continental	Chile Time	-14400000	1	1
206	Etc/GMT+4	GMT-04:00	-14400000	0	0
207	PRT	Atlantic Standard Time	-14400000	0	0
208	SystemV/AST4	Atlantic Standard Time	-14400000	0	0
209	SystemV/AST4ADT	Atlantic Standard Time	-14400000	1	1
210	America/St_Johns	Newfoundland Standard Time	-12600000	1	1
211	CNT	Newfoundland Standard Time	-12600000	1	1
212	Canada/Newfoundland	Newfoundland Standard Time	-12600000	1	1
213	AGT	Argentine Time	-10800000	0	0
214	America/Araguaina	Brasilia Time	-10800000	0	0
215	America/Argentina/Buenos_Aires	Argentine Time	-10800000	0	0
216	America/Argentina/Catamarca	Argentine Time	-10800000	0	0
217	America/Argentina/ComodRivadavia	Argentine Time	-10800000	0	0
218	America/Argentina/Cordoba	Argentine Time	-10800000	0	0
219	America/Argentina/Jujuy	Argentine Time	-10800000	0	0
220	America/Argentina/La_Rioja	Argentine Time	-10800000	0	0
221	America/Argentina/Mendoza	Argentine Time	-10800000	0	0
222	America/Argentina/Rio_Gallegos	Argentine Time	-10800000	0	0
223	America/Argentina/Salta	Argentine Time	-10800000	0	0
224	America/Argentina/San_Juan	Argentine Time	-10800000	0	0
225	America/Argentina/San_Luis	Argentine Time	-10800000	0	0
226	America/Argentina/Tucuman	Argentine Time	-10800000	0	0
227	America/Argentina/Ushuaia	Argentine Time	-10800000	0	0
228	America/Bahia	Brasilia Time	-10800000	0	0
229	America/Belem	Brasilia Time	-10800000	0	0
230	America/Buenos_Aires	Argentine Time	-10800000	0	0
231	America/Catamarca	Argentine Time	-10800000	0	0
232	America/Cayenne	French Guiana Time	-10800000	0	0
233	America/Cordoba	Argentine Time	-10800000	0	0
234	America/Fortaleza	Brasilia Time	-10800000	0	0
235	America/Godthab	Western Greenland Time	-10800000	1	1
236	America/Jujuy	Argentine Time	-10800000	0	0
237	America/Maceio	Brasilia Time	-10800000	0	0
238	America/Mendoza	Argentine Time	-10800000	0	0
239	America/Miquelon	Pierre & Miquelon Standard Time	-10800000	1	1
240	America/Montevideo	Uruguay Time	-10800000	1	1
241	America/Paramaribo	Suriname Time	-10800000	0	0
242	America/Recife	Brasilia Time	-10800000	0	0
243	America/Rosario	Argentine Time	-10800000	0	0
244	America/Santarem	Brasilia Time	-10800000	0	0
245	America/Sao_Paulo	Brasilia Time	-10800000	1	1
246	Antarctica/Rothera	Rothera Time	-10800000	0	0
247	Atlantic/Stanley	Falkland Is. Time	-10800000	0	0
248	BET	Brasilia Time	-10800000	1	1
249	Brazil/East	Brasilia Time	-10800000	1	1
250	Etc/GMT+3	GMT-03:00	-10800000	0	0
251	America/Noronha	Fernando de Noronha Time	-7200000	0	0
252	Atlantic/South_Georgia	South Georgia Standard Time	-7200000	0	0
253	Brazil/DeNoronha	Fernando de Noronha Time	-7200000	0	0
254	Etc/GMT+2	GMT-02:00	-7200000	0	0
255	America/Scoresbysund	Eastern Greenland Time	-3600000	1	1
256	Atlantic/Azores	Azores Time	-3600000	1	1
257	Atlantic/Cape_Verde	Cape Verde Time	-3600000	0	0
258	Etc/GMT+1	GMT-01:00	-3600000	0	0
259	Africa/Abidjan	Greenwich Mean Time	0	0	0
260	Africa/Accra	Ghana Mean Time	0	0	0
261	Africa/Bamako	Greenwich Mean Time	0	0	0
262	Africa/Banjul	Greenwich Mean Time	0	0	0
263	Africa/Bissau	Greenwich Mean Time	0	0	0
\.



COPY role (id, espace_id, ss_key, name, description, persistent, is_active) FROM stdin;
72	66	f070a127-3ccf-4482-95a7-0a7a05969d82	QueueKPIUser	\N	1	1
73	67	f070a127-3ccf-4482-95a7-0a7a05969d82	EQUK2User	\N	1	1
80	58	89c6b227-f3b7-4597-b568-ec1ef98c9556	EmployeeAppsManager	\N	1	1
87	74	f070a127-3ccf-4482-95a7-0a7a05969d82	NikhilSandboxUser	\N	1	1
88	58	79e01da2-6c93-431b-9b51-632054ffdcc1	ApplicationReviewReadOnly	\N	1	1
89	58	bed66759-16b8-45d7-8c1a-902a7cd9445b	CommercialReviewReadOnly	\N	1	1
92	82	f070a127-3ccf-4482-95a7-0a7a05969d82	tobedeletedUser	\N	1	1
38	55	285ac2fa-6c2b-428c-9824-9151db0d2fe1	GMFApplicationReviewSB	\N	1	1
68	60	f070a127-3ccf-4482-95a7-0a7a05969d82	SandboxModuleUser	\N	1	1
77	69	f070a127-3ccf-4482-95a7-0a7a05969d82	APP_CUser	\N	1	1
40	58	0103229d-19d6-4a26-99be-48c0e5dafb9a	NotepadInternalViewOnly	Notepad - Internal - View Only	1	1
41	58	027cb7c2-e19f-4b08-ac24-471282032480	ApplicationCreateSB	\N	1	1
42	58	0fc60745-89f6-4185-91cb-42a3c225009c	ApplicationReview_PendingConcurrence	\N	1	1
43	58	20d0ccf8-605f-4e22-abbe-3362228c4181	ApplicationDecision	\N	1	1
44	58	27cbc698-b45c-4302-bb9e-730962924b24	NotepadCreate_QualityCheck	NotepadCreate  â€“ Quality Check	1	1
45	58	30a47983-41d4-4099-818f-598a96e0d40b	UnderwritingSupervisor	\N	1	1
46	58	3d9e1af5-5c36-4c03-9ff7-17d9aa0fc405	NotepadCreateInternal	NotepadCreate - Internal	1	1
47	58	41ae7396-3675-4b17-bf86-2bf9a7dc3903	ApplicationVerifySB	\N	1	1
48	58	4517e885-4f06-455b-8661-b0d32e9f2696	NotepadCreateDealer	NotepadCreate - Dealer	1	0
49	58	53b99df8-78a1-4f70-9918-8e2c1936b721	ApplicationReview_QualityCheck	\N	1	1
50	58	53ddef86-02a8-4df2-8a19-969a5973122f	ApplicationOfferSB	\N	1	1
51	58	5f38da7c-b0e0-4902-b568-3390c71ac520	Notepad_QualityCheckViewOnly	Notepad â€“ Quality Check - View Only	1	1
52	58	7398a7bb-c38e-4c17-b69e-b64c0ee49c85	ApplicationReviewSB	\N	1	1
53	58	73b73f6d-992f-4227-8e88-62816222b2cb	ApplicationCreditBureau	\N	1	1
54	58	924bc91b-ac99-4af6-955d-488ba390e3b7	ApplicationRatesFees	\N	1	1
55	58	b8cf92f6-cfc3-4b40-8ef0-81d02b53ad71	ApplicationEditSB	\N	1	1
56	58	c28cbc00-a58f-4d79-b85d-8183cf3a498c	ApplicationWithdrawSB	\N	1	1
57	58	cdb8eefc-1f15-433c-bf9b-52aa13e64492	NotepadCreateExternal	NotepadCreate - External	1	1
58	58	d4424d79-2c6f-4f66-9e44-a4e91f0b14c2	OperationsDirector	\N	1	1
59	58	d47b1d2f-c258-4689-9d29-1b5581b0848b	NotepadAllViewOnly	Notepad  - All - View Only	1	1
60	58	d808bc5e-5b99-45e5-8755-39ef25d66686	RetailManager	\N	1	1
61	58	e3efdce4-4c5a-43f1-8bf3-580c51e349b3	ApplicationWithdrawRestrictedSB	\N	1	1
62	58	ea0c35bb-fdc5-4116-9ef8-8548dafe85d2	ApplicationEditRestrictedSB	\N	1	1
63	58	ec4d117f-e82c-4b49-9bb3-64084ab76379	NotepadDealerViewOnly	Notepad - Dealer - View Only	1	1
64	58	ecd7255c-3aa3-4a1c-9b28-108e896e57d9	Underwriter	\N	1	1
65	58	ed497b1a-dcfc-457e-85a2-ddbe9d356fd0	SeniorUnderwriter	\N	1	1
66	58	f517c3f8-6e8a-431b-8d46-4f957e8498a9	NotepadExternalViewOnly	Notepad - External - View Only	1	1
69	61	f070a127-3ccf-4482-95a7-0a7a05969d82	VasanthUser	\N	1	1
70	63	f070a127-3ccf-4482-95a7-0a7a05969d82	View4EntityUser	\N	1	1
71	64	f070a127-3ccf-4482-95a7-0a7a05969d82	SOAPHeaders_ServerUser	\N	1	1
75	58	381d6338-7051-49b6-93ec-95bd7a493772	EditDealerInformation	\N	1	1
78	58	9632943b-c560-48bd-8735-db1a249b0ac4	ApplicationReview_Escalated	\N	1	1
79	58	ae2b6738-8581-43c5-8c33-07491b8271be	ApplicationReview_QualityCheckUW	\N	1	1
81	58	7ef6fa10-436d-435f-8a1f-5a643e30e444	ViewBureauReport	\N	1	1
86	58	08ea05fe-702e-437d-99a4-9ee041b06762	ApplicationCreateReadOnly	\N	1	1
94	58	95c34fe7-2d2b-4e95-927c-7de40e02fa0d	ApplicationDLAOverrideDecisionOption	\N	1	1
96	93	f070a127-3ccf-4482-95a7-0a7a05969d82	MultipleSelectSampleUser	\N	1	1
11	16	0686eb08-2bea-4cdb-a07e-cd972bcad434	ManageBusinessBureau	Controls access to business bureau configuration pages and menu.	1	1
12	16	fb691004-08be-487a-8b3d-df3ee36a2ed4	ManageCRA	Controls access to CRA configuration pages and menu.	1	1
13	20	f4bd95de-37f4-4594-9fc0-b673c31590d8	ManageDocumentTemplate	Controls access to document template configuration pages.	1	1
30	40	45407232-bdb3-4058-84fc-e94d70ed54a9	ManageDomainValue	Controls access to domain value configuration pages.	1	1
39	57	f0bdca5d-f8d2-4578-8319-04017921983e	ApplicationReportSB	Controls access to reports.	1	1
91	79	f070a127-3ccf-4482-95a7-0a7a05969d82	DeveTestCaseUser	\N	1	1
93	83	f070a127-3ccf-4482-95a7-0a7a05969d82	MetricsUser	\N	1	1
1	5	591c46b1-6e1a-4de4-b1ba-5df48cad0ac1	Administrator	Administrator for App Feedback	1	1
2	5	PermissionAreaEF8D38FB-F8C0-4F00-82CE-6A68A04859FC	FeedbackManager	Manager for App Feedback	1	1
3	6	546f0c04-cbbb-43b6-9c69-01788632f172	Administrator	\N	1	1
4	10	37105987-45ed-428e-a0fa-6ec4403a3864	UserManager	\N	1	1
5	10	d63e8a6e-bd39-40d2-a4c2-6e48878682d4	SuperUser	SuperUsers role allows your users to automatically inherit all other roles that exist in the Environment.	1	1
6	11	11041b23-2bc1-4379-9741-f9a4428bb6e4	ManageReport	Controls access to report configuration pages.	1	1
7	11	7e769b0f-a868-4d81-945c-1215b432bab5	ManageLock	Controls users access to manage locked applications.	1	1
8	11	d2367b26-0a59-4136-87e1-11368f616d5b	ManageSetup	User with this role will be able to see the setup link.	1	1
9	13	61919c43-417b-452f-a290-1812e736c97d	ArchiveRestoreApplications	\N	1	1
10	15	a7e3b763-9c90-4629-9c31-7f17abdcd03d	DataAccess	Controls access to sensitive data on screens.	1	1
14	24	08a994eb-b12b-4b82-a82c-44f533ad769d	ManageLoanSource	\N	1	1
15	25	f070a127-3ccf-4482-95a7-0a7a05969d82	om_apm_mock_serviceUser	\N	1	1
16	27	33829d0b-92bc-4fa7-862b-a043a4c9ed08	ManageOrganization	Controls access to organization configuration pages.	1	1
17	29	ab638fc2-135d-4201-a73e-c86ce329bd51	ManagePopulation	Manage Population	1	1
18	31	14e2f336-dafd-4c97-91d9-948273c33f62	ManageFee	Controls access to Fees configuration pages.	1	1
19	31	949f7e27-606e-4b2c-9930-1d34f30e5a45	ManageRate	Controls access to Rates configuration pages.	1	1
20	31	afa4f905-6f45-4d2e-a478-b2381d82a38c	ManageProduct	Controls access to Products configuration pages.	1	1
21	31	df76ec33-166b-4295-9d06-82c16fc0ae70	ManageCategory	Controls access to Categories configuration pages.	1	1
22	32	cee2b773-0f3c-4ea0-a38a-61221de05096	Translate	This role is used for the translation of the search and queue stings	1	1
23	33	3b395794-b23f-4ffa-a084-cd01526e5620	ManageQueue	Controls access to queues configuration pages.	1	1
24	33	4408f2b5-03e6-47d5-8092-73ae873f8228	ApplicationQueue	Controls access to application queues.	1	1
25	33	9ee2c8cf-52d5-4f1a-9763-e329b507ef8b	ApplicationSearch	Controls access to search queue.	1	1
26	33	d737731d-0495-4481-9b46-f2f22468f4a9	ManageErrorQueue	Controls access to Error queue configuration page.	1	1
27	33	dd5fcb7c-9c14-4030-8e68-b3060e292f96	ManageApplicationSearch	Controls access to Search configuration menu.	1	1
28	33	ec6e49b5-b0cc-4efa-a1f4-330ba63b851b	ResolveErrorQueue	Controls the user access to resolve applications in error.	1	1
29	37	fbd67118-cd0a-4303-9544-05b5aa4e78e0	ApplicationHistory	User with this role will be able to see the workflow history.	1	1
31	44	0ca399bb-b077-42f2-9de3-9b3fd402b7fb	Developer	Protects screens and functionality that should only be available to the development team (mostly for debugging/monitoring tools)	1	1
32	44	1b9a5cac-d2a5-4ac0-8304-78e5d436a8a3	ManageGroup	Controls access to groups configuration	1	1
33	44	37105987-45ed-428e-a0fa-6ec4403a3864	ManageUser	Controls access to User setup pages.	1	1
34	44	9bdab03a-9f4c-471b-b1a0-d760a00309b2	ManageTemplates	Role to manage templates	1	1
35	44	fd558b86-8847-42d7-b626-0f3016995082	Tester	Protects screens and functionality that should only be available to the QA team (mostly the TestCaseHelper flows)	1	1
36	53	1bce4b95-3140-4ce0-9cbf-c73466422673	ApplicationResolveDuplicateSB	Controls the user access to resolve duplicate applications	1	1
37	53	b657a302-3d3b-402a-864c-d9cd852e3191	ManageDuplicateSB	Controls access to duplicate configuration pages.	1	1
67	59	f070a127-3ccf-4482-95a7-0a7a05969d82	datamodelUser	\N	1	1
74	58	5ac1a107-a223-4450-b7ee-bed3c9b7996c	EditVehicleValuation	\N	1	1
76	58	5f3ba494-46c1-4054-b3a0-898599add111	EditDealerLimitedFields	\N	1	1
82	58	1a0857cb-8cd3-46fa-bcee-30271a750d08	ReportCreditBureauView	\N	1	1
83	58	33ab1033-79f2-4640-b73b-97de3d0a7c25	ApplicationHistoryReadOnly	\N	1	1
84	58	6875a094-94e3-4db9-9f81-1ae38cc0ef46	ReprocessApplication	\N	1	1
85	58	6ade86f3-7f8c-4e3f-a1a9-aa0a7e261450	ReportCreditBureauSearch	\N	1	1
90	78	f070a127-3ccf-4482-95a7-0a7a05969d82	BackButtonBrowserToPUser	\N	1	1
95	58	90e4de28-0203-47f9-9dcc-1e7dbda32bab	EditOrgExtn	\N	1	1
\.

COPY "group" (id, name, description, created_by, created, tenant_id, has_custom_management) FROM stdin;
1	SeniorUnderwriter	sadsad	4	2015-09-29 08:15:38	44	0
6	SuperDLA	SuperDLA	4	2016-01-22 13:51:29	44	0
2	Senior Underwriter	Senior Underwriter	4	2015-10-03 03:51:43	44	0
3	Underwriter	Underwriter	4	2015-10-31 21:31:58	44	0
4	Retail Manager	Retail Manager	10	2015-11-01 04:58:15	44	0
5	Operations Director	Operations Director	4	2015-11-01 05:09:39	44	0
7	Test	 	10	2017-03-16 05:44:28	44	0
\.

COPY group_role (id, group_id, role_id, tenant_id) FROM stdin;
1	1	45	44
2	1	64	44
3	1	22	44
4	1	35	44
5	1	65	44
6	1	60	44
7	1	28	44
8	1	58	44
9	1	15	44
10	1	40	44
11	1	66	44
12	1	63	44
13	1	46	44
14	1	57	44
15	1	48	44
16	1	44	44
17	1	59	44
18	1	51	44
19	1	33	44
20	1	34	44
21	1	8	44
22	1	6	44
23	1	19	44
24	1	23	44
25	1	20	44
26	1	17	44
27	1	16	44
28	1	7	44
29	1	14	44
30	1	32	44
31	1	18	44
32	1	26	44
33	1	37	44
34	1	30	44
35	1	13	44
36	1	12	44
37	1	21	44
38	1	11	44
39	1	27	44
40	1	38	44
41	1	74	44
42	1	76	44
43	1	75	44
44	1	31	44
45	1	10	44
46	1	9	44
47	1	56	44
48	1	61	44
49	1	47	44
50	1	25	44
51	1	52	44
52	1	79	44
53	1	49	44
54	1	42	44
55	1	78	44
56	1	36	44
57	1	39	44
58	1	54	44
59	1	24	44
60	1	50	44
61	1	29	44
62	1	55	44
63	1	62	44
64	1	43	44
65	1	53	44
66	1	41	44
338	6	81	44
339	6	45	44
340	6	64	44
341	6	22	44
342	6	35	44
343	6	65	44
344	6	60	44
345	6	28	44
346	6	84	44
347	6	82	44
348	6	85	44
349	6	58	44
350	6	15	44
351	6	40	44
352	6	66	44
353	6	63	44
354	6	46	44
355	6	57	44
356	6	44	44
357	6	59	44
358	6	51	44
359	6	33	44
360	6	34	44
361	6	8	44
362	6	6	44
363	6	19	44
364	6	23	44
365	6	20	44
366	6	17	44
367	6	16	44
368	6	7	44
369	6	14	44
370	6	32	44
371	6	18	44
372	6	26	44
373	6	37	44
374	6	30	44
375	6	13	44
376	6	12	44
377	6	21	44
378	6	11	44
379	6	27	44
380	6	38	44
381	6	80	44
382	6	74	44
383	6	75	44
384	6	31	44
385	6	10	44
386	6	9	44
387	6	56	44
388	6	61	44
389	6	47	44
390	6	25	44
391	6	52	44
392	6	79	44
393	6	49	44
394	6	42	44
395	6	78	44
396	6	36	44
397	6	39	44
398	6	54	44
399	6	24	44
400	6	50	44
401	6	29	44
402	6	55	44
403	6	62	44
404	6	43	44
405	6	53	44
406	6	41	44
67	2	45	44
68	2	64	44
69	2	22	44
70	2	35	44
71	2	65	44
72	2	60	44
73	2	28	44
74	2	58	44
75	2	15	44
76	2	40	44
77	2	66	44
78	2	63	44
79	2	46	44
80	2	57	44
81	2	48	44
82	2	44	44
83	2	59	44
84	2	51	44
85	2	33	44
86	2	34	44
87	2	8	44
88	2	6	44
89	2	19	44
90	2	23	44
91	2	20	44
92	2	17	44
93	2	16	44
94	2	7	44
95	2	14	44
96	2	32	44
97	2	18	44
98	2	26	44
99	2	37	44
100	2	30	44
101	2	13	44
102	2	12	44
103	2	21	44
104	2	11	44
105	2	27	44
106	2	38	44
107	2	74	44
108	2	76	44
109	2	75	44
110	2	31	44
111	2	10	44
112	2	9	44
113	2	56	44
114	2	61	44
115	2	47	44
116	2	25	44
117	2	52	44
118	2	79	44
119	2	49	44
120	2	42	44
121	2	78	44
122	2	36	44
123	2	39	44
124	2	54	44
125	2	24	44
126	2	50	44
127	2	29	44
128	2	55	44
129	2	62	44
130	2	43	44
131	2	53	44
132	2	41	44
133	3	81	44
134	3	45	44
135	3	64	44
136	3	22	44
137	3	35	44
138	3	65	44
139	3	60	44
140	3	28	44
141	3	84	44
142	3	82	44
143	3	85	44
144	3	58	44
145	3	15	44
146	3	46	44
147	3	57	44
148	3	44	44
149	3	33	44
150	3	34	44
151	3	8	44
152	3	6	44
153	3	19	44
154	3	23	44
155	3	20	44
156	3	17	44
157	3	16	44
158	3	7	44
159	3	14	44
160	3	32	44
161	3	18	44
162	3	26	44
163	3	37	44
164	3	30	44
165	3	13	44
166	3	12	44
167	3	21	44
168	3	11	44
169	3	27	44
170	3	38	44
171	3	80	44
172	3	74	44
173	3	76	44
174	3	75	44
175	3	31	44
176	3	10	44
177	3	9	44
178	3	56	44
179	3	61	44
180	3	47	44
181	3	25	44
182	3	52	44
183	3	79	44
184	3	49	44
185	3	42	44
186	3	78	44
187	3	36	44
188	3	39	44
189	3	54	44
190	3	24	44
191	3	50	44
192	3	29	44
193	3	55	44
194	3	62	44
195	3	43	44
196	3	53	44
197	3	41	44
198	4	81	44
199	4	45	44
200	4	64	44
201	4	22	44
202	4	35	44
203	4	65	44
204	4	60	44
205	4	28	44
206	4	84	44
207	4	82	44
208	4	85	44
209	4	58	44
210	4	15	44
211	4	40	44
212	4	66	44
213	4	63	44
214	4	46	44
215	4	57	44
216	4	44	44
217	4	59	44
218	4	51	44
219	4	33	44
220	4	34	44
221	4	8	44
222	4	6	44
223	4	19	44
224	4	23	44
225	4	20	44
226	4	17	44
227	4	16	44
228	4	7	44
229	4	14	44
230	4	32	44
231	4	18	44
232	4	26	44
233	4	37	44
234	4	30	44
235	4	13	44
236	4	12	44
237	4	21	44
238	4	11	44
239	4	27	44
240	4	38	44
241	4	80	44
242	4	74	44
244	4	75	44
245	4	31	44
246	4	10	44
247	4	9	44
248	4	56	44
249	4	61	44
250	4	47	44
251	4	25	44
252	4	52	44
253	4	79	44
254	4	49	44
255	4	42	44
256	4	78	44
257	4	36	44
258	4	39	44
259	4	54	44
260	4	24	44
261	4	50	44
262	4	29	44
263	4	55	44
264	4	62	44
265	4	43	44
266	4	53	44
267	4	41	44
268	5	81	44
269	5	45	44
270	5	64	44
271	5	22	44
272	5	35	44
273	5	65	44
274	5	60	44
275	5	28	44
276	5	84	44
277	5	82	44
278	5	85	44
279	5	58	44
280	5	15	44
281	5	40	44
282	5	66	44
283	5	63	44
284	5	46	44
285	5	57	44
286	5	44	44
287	5	59	44
288	5	51	44
289	5	33	44
290	5	34	44
291	5	8	44
292	5	6	44
293	5	19	44
294	5	23	44
295	5	20	44
296	5	17	44
297	5	16	44
298	5	7	44
299	5	14	44
300	5	32	44
301	5	18	44
302	5	26	44
303	5	37	44
304	5	30	44
305	5	13	44
306	5	12	44
307	5	21	44
308	5	11	44
309	5	27	44
310	5	38	44
311	5	80	44
312	5	74	44
313	5	76	44
314	5	75	44
315	5	31	44
316	5	10	44
317	5	9	44
318	5	56	44
319	5	61	44
320	5	47	44
321	5	25	44
322	5	52	44
323	5	79	44
324	5	49	44
325	5	42	44
326	5	78	44
327	5	36	44
328	5	39	44
329	5	54	44
330	5	24	44
331	5	50	44
332	5	29	44
333	5	55	44
334	5	62	44
335	5	43	44
336	5	53	44
337	5	41	44
407	2	94	44
\.


COPY user_role (id, user_id, role_id, tenant_id) FROM stdin;
1126	47	45	44
45	4	46	44
53	4	53	44
57	4	57	44
695	10	25	44
59	4	61	44
60	4	60	44
63	4	64	44
127	4	15	44
128	4	38	44
192	2	69	10
263	2	77	10
266	4	80	44
269	4	84	44
1127	47	64	44
1128	47	22	44
367	2	87	10
1129	47	35	44
1130	47	65	44
981	42	81	44
1131	47	60	44
982	42	45	44
983	42	64	44
984	42	22	44
985	42	35	44
1132	47	28	44
1133	47	84	44
1134	47	82	44
1135	47	85	44
1136	47	58	44
692	2	92	10
986	42	65	44
987	42	60	44
988	42	28	44
989	42	84	44
990	42	82	44
991	42	85	44
992	42	58	44
993	42	15	44
994	42	40	44
995	42	66	44
996	42	63	44
997	42	46	44
998	42	57	44
999	42	44	44
1000	42	59	44
1001	42	51	44
1002	42	33	44
1003	42	34	44
1004	42	8	44
1005	42	6	44
1006	42	19	44
1007	42	23	44
1008	42	20	44
1009	42	17	44
1010	42	16	44
1011	42	7	44
1012	42	14	44
1013	42	32	44
1014	42	18	44
1015	42	26	44
1016	42	37	44
1017	42	30	44
1018	42	13	44
1019	42	12	44
1020	42	21	44
1021	42	11	44
1022	42	27	44
1023	42	80	44
1024	42	74	44
1025	42	76	44
1026	42	75	44
1027	42	31	44
1028	42	10	44
1029	42	9	44
1030	42	56	44
1031	42	61	44
1032	42	47	44
1033	42	25	44
1034	42	52	44
1035	42	79	44
1036	42	49	44
1037	42	42	44
1038	42	78	44
1039	42	36	44
1040	42	39	44
1041	42	54	44
1042	42	24	44
1043	42	50	44
1044	42	29	44
1045	42	55	44
1046	42	62	44
1047	42	94	44
1048	42	43	44
1049	42	53	44
1050	42	41	44
1125	47	81	44
1137	47	15	44
1138	47	40	44
1139	47	66	44
1140	47	63	44
1141	47	46	44
1142	47	57	44
1143	47	44	44
1144	47	59	44
1145	47	51	44
1146	47	33	44
1147	47	34	44
1148	47	8	44
1149	47	6	44
1150	47	19	44
1151	47	23	44
1152	47	20	44
1153	47	17	44
1154	47	16	44
1155	47	7	44
1156	47	14	44
1157	47	32	44
1158	47	18	44
1159	47	26	44
1160	47	37	44
1161	47	30	44
1162	47	13	44
1163	47	12	44
1164	47	21	44
1165	47	11	44
1166	47	27	44
1167	47	80	44
1168	47	74	44
1169	47	76	44
1170	47	75	44
1171	47	31	44
1172	47	10	44
1173	47	9	44
1174	47	56	44
1175	47	47	44
1176	47	25	44
1177	47	52	44
1178	47	79	44
1179	47	49	44
1180	47	42	44
1181	47	78	44
1182	47	36	44
1183	47	39	44
1184	47	54	44
1185	47	24	44
1186	47	50	44
1187	47	29	44
1188	47	55	44
1189	47	94	44
1190	47	43	44
1191	47	53	44
1192	47	41	44
1200	22	83	44
1202	49	29	44
7	4	6	44
8	4	7	44
9	4	8	44
10	4	9	44
11	4	10	44
12	4	11	44
13	4	12	44
14	4	13	44
15	4	14	44
16	4	16	44
17	4	17	44
18	4	18	44
19	4	19	44
20	4	20	44
21	4	21	44
22	4	22	44
23	4	23	44
24	4	24	44
25	4	25	44
26	4	26	44
27	4	27	44
28	4	28	44
29	4	29	44
30	4	30	44
31	4	31	44
32	4	32	44
33	4	33	44
34	4	34	44
35	4	35	44
37	4	37	44
40	4	41	44
44	4	44	44
46	4	48	44
48	4	47	44
768	38	81	44
50	4	50	44
55	4	56	44
56	4	58	44
64	4	65	44
428	4	82	44
191	2	68	10
693	2	93	10
582	2	91	10
769	38	45	44
770	38	64	44
771	38	22	44
772	38	35	44
773	38	65	44
774	38	60	44
775	38	28	44
776	38	84	44
777	38	82	44
778	38	85	44
779	38	58	44
780	38	15	44
781	38	46	44
782	38	57	44
783	38	44	44
784	38	33	44
785	38	34	44
786	38	8	44
787	38	6	44
788	38	19	44
789	38	23	44
790	38	20	44
791	38	17	44
792	38	16	44
793	38	7	44
794	38	14	44
795	38	32	44
796	38	18	44
797	38	26	44
798	38	37	44
799	38	30	44
800	38	13	44
801	38	12	44
802	38	21	44
803	38	11	44
804	38	27	44
805	38	80	44
806	38	74	44
807	38	76	44
808	38	75	44
809	38	31	44
810	38	10	44
811	38	9	44
812	38	56	44
813	38	61	44
814	38	47	44
815	38	25	44
816	38	52	44
817	38	79	44
818	38	49	44
819	38	42	44
820	38	78	44
821	38	36	44
822	38	39	44
823	38	54	44
824	38	24	44
825	38	50	44
826	38	29	44
827	38	55	44
828	38	94	44
829	38	43	44
830	38	53	44
831	38	41	44
1195	22	81	44
1196	22	61	44
1197	22	62	44
1203	50	43	44
1284	55	81	44
1285	55	45	44
1286	55	64	44
1287	55	22	44
1288	55	35	44
1289	55	65	44
1290	55	60	44
1291	55	28	44
1292	55	84	44
1293	55	82	44
1294	55	85	44
1295	55	58	44
1296	55	15	44
1297	55	40	44
1298	55	66	44
1299	55	63	44
1300	55	46	44
1301	55	57	44
1302	55	44	44
1303	55	59	44
1304	55	51	44
1305	55	33	44
1306	55	34	44
1307	55	8	44
1308	55	6	44
1309	55	19	44
1310	55	23	44
1311	55	20	44
1312	55	17	44
1313	55	16	44
1314	55	7	44
1315	55	14	44
1316	55	32	44
1317	55	18	44
1318	55	26	44
1319	55	37	44
1320	55	30	44
1321	55	13	44
1322	55	12	44
1323	55	21	44
1324	55	11	44
1325	55	27	44
1326	55	80	44
1327	55	74	44
1328	55	76	44
1329	55	75	44
1330	55	31	44
1331	55	10	44
1332	55	89	44
1333	55	9	44
1334	55	56	44
1335	55	61	44
1336	55	47	44
1337	55	25	44
1338	55	52	44
1339	55	88	44
1340	55	79	44
1341	55	49	44
1342	55	42	44
1343	55	78	44
1344	55	36	44
1345	55	39	44
1346	55	54	44
1347	55	24	44
1348	55	50	44
1349	55	83	44
1350	55	29	44
1351	55	55	44
1352	55	62	44
1353	55	94	44
1354	55	43	44
1355	55	53	44
1356	55	41	44
1357	55	86	44
38	4	39	44
43	4	45	44
51	4	52	44
52	4	54	44
416	4	63	44
190	2	67	10
195	2	72	10
608	10	45	44
417	4	59	44
268	4	85	44
609	10	64	44
610	10	22	44
611	10	35	44
612	10	65	44
613	10	60	44
607	10	81	44
614	10	28	44
615	10	84	44
616	10	82	44
502	27	81	44
503	27	45	44
617	10	85	44
618	10	58	44
619	10	15	44
620	10	46	44
621	10	57	44
504	27	64	44
622	10	44	44
623	10	33	44
418	4	51	44
1121	4	83	44
375	4	43	44
624	10	34	44
625	10	8	44
626	10	6	44
505	27	22	44
506	27	35	44
507	27	65	44
508	27	60	44
509	27	28	44
510	27	84	44
511	27	82	44
512	27	85	44
513	27	58	44
514	27	15	44
515	27	40	44
516	27	66	44
517	27	63	44
518	27	46	44
519	27	57	44
520	27	44	44
521	27	59	44
522	27	51	44
523	27	33	44
524	27	34	44
525	27	8	44
526	27	6	44
527	27	19	44
528	27	23	44
529	27	20	44
530	27	17	44
531	27	16	44
532	27	7	44
533	27	14	44
534	27	32	44
535	27	18	44
536	27	26	44
537	27	37	44
538	27	30	44
539	27	13	44
540	27	12	44
541	27	21	44
542	27	11	44
543	27	27	44
544	27	38	44
545	27	80	44
546	27	74	44
547	27	75	44
548	27	31	44
549	27	10	44
550	27	89	44
551	27	9	44
552	27	56	44
553	27	61	44
554	27	47	44
555	27	25	44
556	27	52	44
557	27	88	44
558	27	79	44
559	27	49	44
560	27	42	44
561	27	78	44
562	27	36	44
563	27	39	44
564	27	54	44
565	27	24	44
566	27	50	44
567	27	83	44
568	27	29	44
569	27	55	44
570	27	62	44
571	27	43	44
572	27	53	44
573	27	41	44
574	27	86	44
627	10	19	44
628	10	23	44
629	10	20	44
630	10	17	44
631	10	16	44
632	10	7	44
633	10	14	44
634	10	32	44
635	10	18	44
636	10	26	44
637	10	37	44
638	10	30	44
639	10	13	44
640	10	12	44
641	10	21	44
642	10	11	44
643	10	27	44
644	10	38	44
645	10	80	44
646	10	74	44
1194	47	62	44
648	10	75	44
649	10	31	44
650	10	10	44
651	10	9	44
652	10	56	44
653	10	61	44
654	10	47	44
1122	4	86	44
656	10	52	44
657	10	79	44
658	10	49	44
659	10	42	44
660	10	78	44
661	10	36	44
662	10	39	44
663	10	54	44
664	10	24	44
665	10	50	44
666	10	29	44
667	10	55	44
668	10	62	44
669	10	43	44
670	10	53	44
671	10	41	44
672	10	40	44
673	10	66	44
674	10	63	44
675	10	59	44
676	10	51	44
1123	4	89	44
1124	4	88	44
1193	47	61	44
1279	47	95	44
1280	22	95	44
1281	10	95	44
1282	41	95	44
1	2	4	10
2	2	5	10
3	2	1	10
4	2	2	10
5	2	3	10
6	2	15	10
36	4	36	44
42	4	42	44
193	2	70	10
197	4	74	44
198	17	45	44
199	17	64	44
200	17	22	44
201	17	35	44
202	17	65	44
203	17	60	44
204	17	28	44
205	17	49	44
206	17	58	44
207	17	15	44
208	17	40	44
209	17	66	44
210	17	63	44
211	17	46	44
212	17	57	44
213	17	48	44
214	17	44	44
215	17	59	44
216	17	51	44
217	17	33	44
218	17	34	44
219	17	8	44
220	17	6	44
221	17	19	44
222	17	23	44
223	17	20	44
224	17	17	44
225	17	16	44
226	17	7	44
227	17	14	44
228	17	32	44
229	17	18	44
230	17	26	44
231	17	37	44
232	17	30	44
233	17	13	44
234	17	12	44
235	17	21	44
236	17	11	44
237	17	27	44
238	17	38	44
239	17	74	44
240	17	31	44
241	17	10	44
242	17	42	44
243	17	9	44
244	17	56	44
245	17	61	44
246	17	47	44
247	17	25	44
248	17	52	44
249	17	36	44
250	17	39	44
251	17	54	44
252	17	24	44
253	17	50	44
254	17	29	44
255	17	55	44
256	17	62	44
257	17	43	44
258	17	53	44
259	17	41	44
261	17	75	44
696	10	94	44
694	4	94	44
832	40	81	44
585	4	40	44
833	40	45	44
834	40	64	44
835	40	22	44
405	4	81	44
406	4	66	44
836	40	35	44
837	40	65	44
838	40	60	44
839	40	28	44
840	40	84	44
841	40	82	44
842	40	85	44
843	40	58	44
844	40	15	44
848	40	46	44
849	40	57	44
850	40	44	44
853	40	33	44
854	40	34	44
855	40	8	44
856	40	6	44
857	40	19	44
858	40	23	44
859	40	20	44
860	40	17	44
861	40	16	44
862	40	7	44
863	40	14	44
864	40	32	44
865	40	18	44
866	40	26	44
867	40	37	44
868	40	30	44
869	40	13	44
870	40	12	44
871	40	21	44
872	40	11	44
873	40	27	44
874	40	80	44
875	40	74	44
876	40	76	44
877	40	75	44
878	40	31	44
879	40	10	44
881	40	9	44
882	40	56	44
884	40	47	44
885	40	25	44
886	40	52	44
888	40	79	44
889	40	49	44
890	40	42	44
891	40	78	44
892	40	36	44
893	40	39	44
894	40	54	44
895	40	24	44
896	40	50	44
898	40	29	44
899	40	55	44
901	40	94	44
902	40	43	44
903	40	53	44
904	40	41	44
1204	52	81	44
1205	52	45	44
1206	52	64	44
1207	52	22	44
1208	52	35	44
1209	52	65	44
1210	52	60	44
1211	52	28	44
1212	52	84	44
1213	52	82	44
1214	52	85	44
1215	52	58	44
1216	52	15	44
1220	52	46	44
1221	52	57	44
1222	52	44	44
1223	52	59	44
1224	52	51	44
1225	52	33	44
1226	52	34	44
1227	52	8	44
1228	52	6	44
1229	52	19	44
1230	52	23	44
1231	52	20	44
1232	52	17	44
1233	52	16	44
1234	52	7	44
1235	52	14	44
1236	52	32	44
1237	52	18	44
1238	52	26	44
1239	52	37	44
1240	52	30	44
1241	52	13	44
1242	52	12	44
1243	52	21	44
1244	52	11	44
1245	52	27	44
1246	52	80	44
1247	52	74	44
1248	52	76	44
1249	52	75	44
1250	52	31	44
1251	52	10	44
1253	52	9	44
1254	52	56	44
1255	52	61	44
1256	52	47	44
1257	52	25	44
1258	52	52	44
1260	52	79	44
1261	52	49	44
1262	52	42	44
1263	52	78	44
1264	52	36	44
1265	52	39	44
1266	52	54	44
1267	52	24	44
1268	52	50	44
1270	52	29	44
1271	52	55	44
1272	52	62	44
1273	52	94	44
1274	52	43	44
1275	52	53	44
1276	52	41	44
1278	4	95	44
47	4	49	44
54	4	55	44
62	4	62	44
682	4	76	44
1283	2	96	10
700	22	45	44
701	22	64	44
702	22	22	44
703	22	35	44
704	22	65	44
429	26	81	44
705	22	60	44
430	26	45	44
706	22	28	44
707	22	84	44
81	10	48	44
598	4	75	44
431	26	64	44
708	22	82	44
709	22	85	44
710	22	58	44
711	22	15	44
712	22	40	44
715	22	46	44
716	22	57	44
717	22	44	44
720	22	33	44
721	22	34	44
722	22	8	44
723	22	6	44
724	22	19	44
725	22	23	44
726	22	20	44
727	22	17	44
728	22	16	44
729	22	7	44
730	22	14	44
731	22	32	44
732	22	18	44
907	40	66	44
733	22	26	44
734	22	37	44
735	22	30	44
432	26	22	44
736	22	13	44
737	22	12	44
738	22	21	44
739	22	11	44
740	22	27	44
741	22	38	44
433	26	35	44
742	22	80	44
743	22	74	44
744	22	76	44
434	26	65	44
745	22	75	44
401	2	90	10
129	11	45	44
130	11	64	44
131	11	22	44
132	11	35	44
133	11	65	44
134	11	60	44
135	11	28	44
136	11	49	44
137	11	58	44
138	11	15	44
139	11	40	44
140	11	66	44
141	11	63	44
142	11	46	44
143	11	57	44
144	11	48	44
145	11	44	44
146	11	59	44
147	11	51	44
148	11	33	44
149	11	34	44
150	11	8	44
151	11	6	44
152	11	19	44
153	11	23	44
154	11	20	44
155	11	17	44
156	11	16	44
157	11	7	44
158	11	14	44
159	11	32	44
160	11	18	44
161	11	26	44
162	11	37	44
163	11	30	44
164	11	13	44
165	11	12	44
166	11	21	44
167	11	11	44
168	11	27	44
169	11	38	44
170	11	31	44
171	11	10	44
172	11	42	44
173	11	9	44
174	11	56	44
175	11	61	44
176	11	47	44
177	11	25	44
178	11	52	44
179	11	36	44
180	11	39	44
181	11	54	44
182	11	24	44
183	11	50	44
184	11	29	44
185	11	55	44
186	11	62	44
187	11	43	44
188	11	53	44
189	11	41	44
194	2	71	10
196	4	73	44
264	4	78	44
265	4	79	44
435	26	60	44
436	26	28	44
908	40	63	44
909	40	59	44
910	40	51	44
911	41	81	44
912	41	45	44
913	41	64	44
437	26	84	44
438	26	82	44
439	26	85	44
914	41	22	44
915	41	35	44
746	22	31	44
916	41	65	44
917	41	60	44
918	41	28	44
919	41	84	44
920	41	82	44
921	41	85	44
922	41	58	44
923	41	15	44
924	41	40	44
925	41	66	44
926	41	63	44
927	41	46	44
928	41	57	44
929	41	44	44
930	41	59	44
931	41	51	44
932	41	33	44
933	41	34	44
934	41	8	44
935	41	6	44
936	41	19	44
937	41	23	44
938	41	20	44
939	41	17	44
940	41	16	44
941	41	7	44
942	41	14	44
943	41	32	44
944	41	18	44
945	41	26	44
946	41	37	44
747	22	10	44
947	41	30	44
948	41	13	44
949	41	12	44
950	41	21	44
951	41	11	44
952	41	27	44
953	41	80	44
954	41	74	44
955	41	76	44
440	26	58	44
441	26	15	44
442	26	40	44
443	26	66	44
956	41	75	44
957	41	31	44
958	41	10	44
959	41	9	44
960	41	56	44
444	26	63	44
961	41	61	44
962	41	47	44
963	41	25	44
445	26	46	44
964	41	52	44
965	41	79	44
446	26	57	44
447	26	44	44
448	26	59	44
449	26	51	44
450	26	33	44
451	26	34	44
452	26	8	44
453	26	6	44
454	26	19	44
455	26	23	44
456	26	20	44
457	26	17	44
458	26	16	44
459	26	7	44
460	26	14	44
461	26	32	44
462	26	18	44
463	26	26	44
464	26	37	44
465	26	30	44
466	26	13	44
467	26	12	44
468	26	21	44
469	26	11	44
470	26	27	44
471	26	38	44
472	26	80	44
473	26	74	44
474	26	75	44
475	26	31	44
476	26	10	44
477	26	89	44
478	26	9	44
479	26	56	44
480	26	61	44
481	26	47	44
482	26	25	44
483	26	52	44
484	26	88	44
485	26	79	44
486	26	49	44
487	26	42	44
488	26	78	44
489	26	36	44
490	26	39	44
491	26	54	44
492	26	24	44
493	26	50	44
494	26	83	44
495	26	29	44
496	26	55	44
497	26	62	44
498	26	43	44
499	26	53	44
500	26	41	44
501	26	86	44
748	22	9	44
749	22	56	44
750	22	47	44
751	22	25	44
752	22	52	44
753	22	79	44
754	22	49	44
755	22	42	44
756	22	78	44
757	22	36	44
758	22	39	44
759	22	54	44
760	22	24	44
761	22	50	44
762	22	29	44
763	22	55	44
764	22	94	44
765	22	43	44
766	22	53	44
767	22	41	44
906	40	40	44
966	41	49	44
967	41	42	44
968	41	78	44
969	41	36	44
970	41	39	44
971	41	54	44
972	41	24	44
973	41	50	44
974	41	29	44
975	41	55	44
976	41	62	44
977	41	94	44
978	41	43	44
979	41	53	44
980	41	41	44
1051	43	81	44
1052	43	45	44
1053	43	64	44
1054	43	22	44
1055	43	35	44
1056	43	65	44
1057	43	60	44
1058	43	28	44
1059	43	84	44
1060	43	82	44
1061	43	85	44
1062	43	58	44
1063	43	15	44
1064	43	40	44
1065	43	66	44
1066	43	63	44
1067	43	46	44
1068	43	57	44
1069	43	44	44
1070	43	59	44
1071	43	51	44
1072	43	33	44
1073	43	34	44
1074	43	8	44
1075	43	6	44
1076	43	19	44
1077	43	23	44
1078	43	20	44
1079	43	17	44
1080	43	16	44
1081	43	7	44
1082	43	14	44
1083	43	32	44
1084	43	18	44
1085	43	26	44
1086	43	37	44
1087	43	30	44
1088	43	13	44
1089	43	12	44
1090	43	21	44
1091	43	11	44
1092	43	27	44
1093	43	80	44
1094	43	74	44
1095	43	76	44
1096	43	75	44
1097	43	31	44
1098	43	10	44
1099	43	9	44
1100	43	56	44
1101	43	61	44
1102	43	47	44
1103	43	25	44
1104	43	52	44
1105	43	79	44
1106	43	49	44
1107	43	42	44
1108	43	78	44
1109	43	36	44
1110	43	39	44
1111	43	54	44
1112	43	24	44
1113	43	50	44
1114	43	29	44
1115	43	55	44
1116	43	62	44
1117	43	94	44
1118	43	43	44
1119	43	53	44
1120	43	41	44
\.


COPY user_effective_role (role_id, user_id, tenant_id) FROM stdin;
1	2	10
2	2	10
3	2	10
4	2	10
5	2	10
6	4	44
6	10	44
6	11	44
6	17	44
6	22	44
6	26	44
6	27	44
6	38	44
6	40	44
6	41	44
6	42	44
6	43	44
6	47	44
6	50	44
6	52	44
6	55	44
7	4	44
7	10	44
7	11	44
7	17	44
7	22	44
7	26	44
7	27	44
7	38	44
7	40	44
7	41	44
7	42	44
7	43	44
7	47	44
7	50	44
7	52	44
7	55	44
8	4	44
8	10	44
8	11	44
8	17	44
8	22	44
8	26	44
8	27	44
8	38	44
8	40	44
8	41	44
8	42	44
8	43	44
8	47	44
8	50	44
8	52	44
8	55	44
9	4	44
9	10	44
9	11	44
9	17	44
9	22	44
9	26	44
9	27	44
9	38	44
9	40	44
9	41	44
9	42	44
9	43	44
9	47	44
9	50	44
9	52	44
9	55	44
10	4	44
10	10	44
10	11	44
10	17	44
10	22	44
10	26	44
10	27	44
10	38	44
10	40	44
10	41	44
10	42	44
10	43	44
10	47	44
10	50	44
10	52	44
10	55	44
11	4	44
11	10	44
11	11	44
11	17	44
11	22	44
11	26	44
11	27	44
11	38	44
11	40	44
11	41	44
11	42	44
11	43	44
11	47	44
11	50	44
11	52	44
11	55	44
12	4	44
12	10	44
12	11	44
12	17	44
12	22	44
12	26	44
12	27	44
12	38	44
12	40	44
12	41	44
12	42	44
12	43	44
12	47	44
12	50	44
12	52	44
12	55	44
13	4	44
13	10	44
13	11	44
13	17	44
13	22	44
13	26	44
13	27	44
13	38	44
13	40	44
13	41	44
13	42	44
13	43	44
13	47	44
13	50	44
13	52	44
13	55	44
14	4	44
14	10	44
14	11	44
14	17	44
14	22	44
14	26	44
14	27	44
14	38	44
14	40	44
14	41	44
14	42	44
14	43	44
14	47	44
14	50	44
14	52	44
14	55	44
15	2	10
15	4	44
15	10	44
15	11	44
15	17	44
15	22	44
15	26	44
15	27	44
15	38	44
15	40	44
15	41	44
15	42	44
15	43	44
15	47	44
15	50	44
15	52	44
15	55	44
16	4	44
16	10	44
16	11	44
16	17	44
16	22	44
16	26	44
16	27	44
16	38	44
16	40	44
16	41	44
16	42	44
16	43	44
16	47	44
16	50	44
16	52	44
16	55	44
17	4	44
17	10	44
17	11	44
17	17	44
17	22	44
17	26	44
17	27	44
17	38	44
17	40	44
17	41	44
17	42	44
17	43	44
17	47	44
17	50	44
17	52	44
17	55	44
18	4	44
18	10	44
18	11	44
18	17	44
18	22	44
18	26	44
18	27	44
18	38	44
18	40	44
18	41	44
18	42	44
18	43	44
18	47	44
18	50	44
18	52	44
18	55	44
19	4	44
19	10	44
19	11	44
19	17	44
19	22	44
19	26	44
19	27	44
19	38	44
19	40	44
19	41	44
19	42	44
19	43	44
19	47	44
19	50	44
19	52	44
19	55	44
20	4	44
20	10	44
20	11	44
20	17	44
20	22	44
20	26	44
20	27	44
20	38	44
20	40	44
20	41	44
20	42	44
20	43	44
20	47	44
20	50	44
20	52	44
20	55	44
21	4	44
21	10	44
21	11	44
21	17	44
21	22	44
21	26	44
21	27	44
21	38	44
21	40	44
21	41	44
21	42	44
21	43	44
21	47	44
21	50	44
21	52	44
21	55	44
22	4	44
22	10	44
22	11	44
22	17	44
22	22	44
22	26	44
22	27	44
22	38	44
22	40	44
22	41	44
22	42	44
22	43	44
22	47	44
22	50	44
22	52	44
22	55	44
23	4	44
23	10	44
23	11	44
23	17	44
23	22	44
23	26	44
23	27	44
23	38	44
23	40	44
23	41	44
23	42	44
23	43	44
23	47	44
23	50	44
23	52	44
23	55	44
24	4	44
24	10	44
24	11	44
24	17	44
24	22	44
24	26	44
24	27	44
24	38	44
24	40	44
24	41	44
24	42	44
24	43	44
24	47	44
24	50	44
24	52	44
24	55	44
25	4	44
25	10	44
25	11	44
25	17	44
25	22	44
25	26	44
25	27	44
25	38	44
25	40	44
25	41	44
25	42	44
25	43	44
25	47	44
25	50	44
25	52	44
25	55	44
26	4	44
26	10	44
26	11	44
26	17	44
26	22	44
26	26	44
26	27	44
26	38	44
26	40	44
26	41	44
26	42	44
26	43	44
26	47	44
26	50	44
26	52	44
26	55	44
27	4	44
27	10	44
27	11	44
27	17	44
27	22	44
27	26	44
27	27	44
27	38	44
27	40	44
27	41	44
27	42	44
27	43	44
27	47	44
27	50	44
27	52	44
27	55	44
28	4	44
28	10	44
28	11	44
28	17	44
28	22	44
28	26	44
28	27	44
28	38	44
28	40	44
28	41	44
28	42	44
28	43	44
28	47	44
28	50	44
28	52	44
28	55	44
29	4	44
29	10	44
29	11	44
29	17	44
29	22	44
29	26	44
29	27	44
29	38	44
29	40	44
29	41	44
29	42	44
29	43	44
29	47	44
29	49	44
29	50	44
29	52	44
29	55	44
30	4	44
30	10	44
30	11	44
30	17	44
30	22	44
30	26	44
30	27	44
30	38	44
30	40	44
30	41	44
30	42	44
30	43	44
30	47	44
30	50	44
30	52	44
30	55	44
31	4	44
31	10	44
31	11	44
31	17	44
31	22	44
31	26	44
31	27	44
31	38	44
31	40	44
31	41	44
31	42	44
31	43	44
31	47	44
31	50	44
31	52	44
31	55	44
32	4	44
32	10	44
32	11	44
32	17	44
32	22	44
32	26	44
32	27	44
32	38	44
32	40	44
32	41	44
32	42	44
32	43	44
32	47	44
32	50	44
32	52	44
32	55	44
33	4	44
33	10	44
33	11	44
33	17	44
33	22	44
33	26	44
33	27	44
33	38	44
33	40	44
33	41	44
33	42	44
33	43	44
33	47	44
33	50	44
33	52	44
33	55	44
34	4	44
34	10	44
34	11	44
34	17	44
34	22	44
34	26	44
34	27	44
34	38	44
34	40	44
34	41	44
34	42	44
34	43	44
34	47	44
34	50	44
34	52	44
34	55	44
35	4	44
35	10	44
35	11	44
35	17	44
35	22	44
35	26	44
35	27	44
35	38	44
35	40	44
35	41	44
35	42	44
35	43	44
35	47	44
35	50	44
35	52	44
35	55	44
36	4	44
36	10	44
36	11	44
36	17	44
36	22	44
36	26	44
36	27	44
36	38	44
36	40	44
36	41	44
36	42	44
36	43	44
36	47	44
36	50	44
36	52	44
36	55	44
37	4	44
37	10	44
37	11	44
37	17	44
37	22	44
37	26	44
37	27	44
37	38	44
37	40	44
37	41	44
37	42	44
37	43	44
37	47	44
37	50	44
37	52	44
37	55	44
38	4	44
38	10	44
38	11	44
38	17	44
38	22	44
38	26	44
38	27	44
38	38	44
38	41	44
38	42	44
38	43	44
38	47	44
38	50	44
38	52	44
38	55	44
39	4	44
39	10	44
39	11	44
39	17	44
39	22	44
39	26	44
39	27	44
39	38	44
39	40	44
39	41	44
39	42	44
39	43	44
39	47	44
39	50	44
39	52	44
39	55	44
40	4	44
40	10	44
40	11	44
40	17	44
40	22	44
40	26	44
40	27	44
40	38	44
40	40	44
40	41	44
40	42	44
40	43	44
40	47	44
40	50	44
40	55	44
41	4	44
41	10	44
41	11	44
41	17	44
41	22	44
41	26	44
41	27	44
41	38	44
41	40	44
41	41	44
41	42	44
41	43	44
41	47	44
41	50	44
41	52	44
41	55	44
42	4	44
42	10	44
42	11	44
42	17	44
42	22	44
42	26	44
42	27	44
42	38	44
42	40	44
42	41	44
42	42	44
42	43	44
42	47	44
42	50	44
42	52	44
42	55	44
43	4	44
43	10	44
43	11	44
43	17	44
43	22	44
43	26	44
43	27	44
43	38	44
43	40	44
43	41	44
43	42	44
43	43	44
43	47	44
43	50	44
43	52	44
43	55	44
44	4	44
44	10	44
44	11	44
44	17	44
44	22	44
44	26	44
44	27	44
44	38	44
44	40	44
44	41	44
44	42	44
44	43	44
44	47	44
44	50	44
44	52	44
44	55	44
45	4	44
45	10	44
45	11	44
45	17	44
45	22	44
45	26	44
45	27	44
45	38	44
45	40	44
45	41	44
45	42	44
45	43	44
45	47	44
45	50	44
45	52	44
45	55	44
46	4	44
46	10	44
46	11	44
46	17	44
46	22	44
46	26	44
46	27	44
46	38	44
46	40	44
46	41	44
46	42	44
46	43	44
46	47	44
46	50	44
46	52	44
46	55	44
47	4	44
47	10	44
47	11	44
47	17	44
47	22	44
47	26	44
47	27	44
47	38	44
47	40	44
47	41	44
47	42	44
47	43	44
47	47	44
47	50	44
47	52	44
47	55	44
48	4	44
48	10	44
48	11	44
48	17	44
48	22	44
48	27	44
48	38	44
48	41	44
48	42	44
48	47	44
48	55	44
49	4	44
49	10	44
49	11	44
49	17	44
49	22	44
49	26	44
49	27	44
49	38	44
49	40	44
49	41	44
49	42	44
49	43	44
49	47	44
49	50	44
49	52	44
49	55	44
50	4	44
50	10	44
50	11	44
50	17	44
50	22	44
50	26	44
50	27	44
50	38	44
50	40	44
50	41	44
50	42	44
50	43	44
50	47	44
50	50	44
50	52	44
50	55	44
51	4	44
51	10	44
51	11	44
51	17	44
51	22	44
51	26	44
51	27	44
51	38	44
51	40	44
51	41	44
51	42	44
51	43	44
51	47	44
51	50	44
51	52	44
51	55	44
52	4	44
52	10	44
52	11	44
52	17	44
52	22	44
52	26	44
52	27	44
52	38	44
52	40	44
52	41	44
52	42	44
52	43	44
52	47	44
52	50	44
52	52	44
52	55	44
53	4	44
53	10	44
53	11	44
53	17	44
53	22	44
53	26	44
53	27	44
53	38	44
53	40	44
53	41	44
53	42	44
53	43	44
53	47	44
53	50	44
53	52	44
53	55	44
54	4	44
54	10	44
54	11	44
54	17	44
54	22	44
54	26	44
54	27	44
54	38	44
54	40	44
54	41	44
54	42	44
54	43	44
54	47	44
54	50	44
54	52	44
54	55	44
55	4	44
55	10	44
55	11	44
55	17	44
55	22	44
55	26	44
55	27	44
55	38	44
55	40	44
55	41	44
55	42	44
55	43	44
55	47	44
55	50	44
55	52	44
55	55	44
56	4	44
56	10	44
56	11	44
56	17	44
56	22	44
56	26	44
56	27	44
56	38	44
56	40	44
56	41	44
56	42	44
56	43	44
56	47	44
56	50	44
56	52	44
56	55	44
57	4	44
57	10	44
57	11	44
57	17	44
57	22	44
57	26	44
57	27	44
57	38	44
57	40	44
57	41	44
57	42	44
57	43	44
57	47	44
57	50	44
57	52	44
57	55	44
58	4	44
58	10	44
58	11	44
58	17	44
58	22	44
58	26	44
58	27	44
58	38	44
58	40	44
58	41	44
58	42	44
58	43	44
58	47	44
58	50	44
58	52	44
58	55	44
59	4	44
59	10	44
59	11	44
59	17	44
59	22	44
59	26	44
59	27	44
59	38	44
59	40	44
59	41	44
59	42	44
59	43	44
59	47	44
59	50	44
59	52	44
59	55	44
60	4	44
60	10	44
60	11	44
60	17	44
60	22	44
60	26	44
60	27	44
60	38	44
60	40	44
60	41	44
60	42	44
60	43	44
60	47	44
60	50	44
60	52	44
60	55	44
61	4	44
61	10	44
61	11	44
61	17	44
61	22	44
61	26	44
61	27	44
61	38	44
61	41	44
61	42	44
61	43	44
61	47	44
61	50	44
61	52	44
61	55	44
62	4	44
62	10	44
62	11	44
62	17	44
62	22	44
62	26	44
62	27	44
62	38	44
62	41	44
62	42	44
62	43	44
62	47	44
62	50	44
62	52	44
62	55	44
63	4	44
63	10	44
63	11	44
63	17	44
63	22	44
63	26	44
63	27	44
63	38	44
63	40	44
63	41	44
63	42	44
63	43	44
63	47	44
63	50	44
63	55	44
64	4	44
64	10	44
64	11	44
64	17	44
64	22	44
64	26	44
64	27	44
64	38	44
64	40	44
64	41	44
64	42	44
64	43	44
64	47	44
64	50	44
64	52	44
64	55	44
65	4	44
65	10	44
65	11	44
65	17	44
65	22	44
65	26	44
65	27	44
65	38	44
65	40	44
65	41	44
65	42	44
65	43	44
65	47	44
65	50	44
65	52	44
65	55	44
66	4	44
66	10	44
66	11	44
66	17	44
66	22	44
66	26	44
66	27	44
66	38	44
66	40	44
66	41	44
66	42	44
66	43	44
66	47	44
66	50	44
66	55	44
67	2	10
68	2	10
69	2	10
70	2	10
71	2	10
72	2	10
73	4	44
74	4	44
74	10	44
74	17	44
74	22	44
74	26	44
74	27	44
74	38	44
74	40	44
74	41	44
74	42	44
74	43	44
74	47	44
74	50	44
74	52	44
74	55	44
75	4	44
75	10	44
75	17	44
75	22	44
75	26	44
75	27	44
75	38	44
75	40	44
75	41	44
75	42	44
75	43	44
75	47	44
75	50	44
75	52	44
75	55	44
76	4	44
76	10	44
76	22	44
76	27	44
76	38	44
76	40	44
76	41	44
76	42	44
76	43	44
76	47	44
76	50	44
76	52	44
76	55	44
77	2	10
78	4	44
78	10	44
78	22	44
78	26	44
78	27	44
78	38	44
78	40	44
78	41	44
78	42	44
78	43	44
78	47	44
78	50	44
78	52	44
78	55	44
79	4	44
79	10	44
79	22	44
79	26	44
79	27	44
79	38	44
79	40	44
79	41	44
79	42	44
79	43	44
79	47	44
79	50	44
79	52	44
79	55	44
80	4	44
80	10	44
80	22	44
80	26	44
80	27	44
80	38	44
80	40	44
80	41	44
80	42	44
80	43	44
80	47	44
80	50	44
80	52	44
80	55	44
81	4	44
81	10	44
81	22	44
81	26	44
81	27	44
81	38	44
81	40	44
81	41	44
81	42	44
81	43	44
81	47	44
81	50	44
81	52	44
81	55	44
82	4	44
82	10	44
82	22	44
82	26	44
82	27	44
82	38	44
82	40	44
82	41	44
82	42	44
82	43	44
82	47	44
82	50	44
82	52	44
82	55	44
83	4	44
83	22	44
83	26	44
83	27	44
83	55	44
84	4	44
84	10	44
84	22	44
84	26	44
84	27	44
84	38	44
84	40	44
84	41	44
84	42	44
84	43	44
84	47	44
84	50	44
84	52	44
84	55	44
85	4	44
85	10	44
85	22	44
85	26	44
85	27	44
85	38	44
85	40	44
85	41	44
85	42	44
85	43	44
85	47	44
85	50	44
85	52	44
85	55	44
86	4	44
86	26	44
86	27	44
86	55	44
87	2	10
88	4	44
88	26	44
88	27	44
88	55	44
89	4	44
89	26	44
89	27	44
89	55	44
90	2	10
91	2	10
92	2	10
93	2	10
94	4	44
94	10	44
94	22	44
94	27	44
94	38	44
94	40	44
94	41	44
94	42	44
94	43	44
94	47	44
94	52	44
94	55	44
95	4	44
95	10	44
95	22	44
95	41	44
95	47	44
96	2	10
\.
