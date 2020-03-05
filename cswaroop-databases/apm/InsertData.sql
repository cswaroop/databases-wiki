
set search_path=junk,public;
set client_encoding='UTF8';

copy tenant(id,name) from stdin encoding 'windows-1251';
GMF	GMF
GMF_UK	United Kingdom
GMF_IT	Italy
GMF_BENELUX	Belgium, the Netherlands, and Luxembourg 
GMF_MCC	Mexico, Columbia and Chile
\.


copy title(id) from stdin encoding 'windows-1251';
Miss
Mr
Mrs
Ms
\.


copy residential_status(id) from stdin encoding 'windows-1251';
Tutte le altre   
Leasing                           
Propieta        
Vive coni genitori o parenti   
Affitto
\.

copy it_street_type(id) from stdin encoding 'windows-1251';
Corso
Frazione
Largo
Piazza
Piazzale
SP
SS
Via
Viale
\.

copy application_status(id) from stdin encoding 'windows-1251';
Draft
Submitted
Reviewed
Referral
Completed
Action
Reject
ConditionalApprove
PurchaseRescore
Escalation
PendingDuplicationResolution
PendingWithdrawalArchive
PendingReviewResolution
PendingErrorResolution
PendingApprovalArchive
PendingDeclineArchive
PendingVerification
PendingMissingData
PendingConcurrenceReview
PendingQualityCheck
\.

copy marital_status(id) from stdin encoding 'windows-1251';
Single
Married / Civil Partnership
Separated
Divorced / Dissolved
Widowed
Unmarried
Co-habiting
\.

copy business_type(id) from stdin encoding 'windows-1251';
Agriculture 
Retail
Wholesale
Construction
Chemicals
Engineering
Manufacturing
Financial service
Other services
Service industry
Professions
Communication
Energy
Technology
Transport
Taxi or vehicle hire
\.

copy profession(id) from stdin encoding 'windows-1251';
Casalinga
Dipendente settore privato
Disoccupato
Ditta Individuale
Libero professionista
Pensionato
Pubbico Impiego
Studente
\.

copy employment_type(id) from stdin encoding 'windows-1251';
Employed
Homemaker
Retired
Student
Unemployed
\.

copy payment_method(id) from stdin encoding 'windows-1251';
Direct Debit
Postal Coupon
\.

copy company_type(id) from stdin encoding 'windows-1251';
Societa
Associazione in Partecipazione
\.

copy occupation(employment_type,id) from stdin encoding 'windows-1251';
Employed	Accountant
Employed	Administrator
Employed	Air Traffic Controller
Employed	Analyst
Employed	Architect
Employed	Assistant Manager
Employed	Auditor
Employed	Baggage Handler
Employed	Baker
Employed	Bank Staff
Employed	Bar Worker
Employed	Barber/Hairdresser
Employed	Book Keeper
Employed	Bricklayer
Employed	Building Engineer
Employed	Butcher
Employed	Buyer
Employed	Carpenter
Employed	Cashier
Employed	Chemist
Employed	Cleaning Person
Employed	Clergy
Employed	Clerical Worker
Employed	Commissioned/Warrant Officer
Employed	Computer Operator
Employed	Cook Service
Employed	Creative
Employed	Croupier
Employed	Dental Assistant
Employed	Dentist
Employed	Designer
Employed	Director
Employed	Doctor
Employed	Driver
Employed	Driving Instructor
Employed	Electrician
Employed	Engineer
Employed	Executive
Employed	Factory/Outside Manager
Employed	Factory; Worker Production
Employed	Farmer
Employed	Firefighter
Employed	General Assistant
Employed	Glazier
Employed	Golf Instructor
Employed	Hospital Attendant
Employed	Insurance Adjuster
Employed	Insurance Agent
Employed	Interior Decorator
Employed	Jeweller
Employed	Labourer
Employed	Lawyer
Employed	Lecturer
Employed	Librarian
Employed	Machine Operator
Employed	Maintenance Mechanic
Employed	Manager
Employed	Mechanic
Employed	Mechanical Engineer
Employed	Military
Employed	Miscellaneous
Employed	Nurse
Employed	Nursery School Teacher
Employed	Office Manager
Employed	Office Staff
Employed	Optician
Employed	Osteopath
Employed	Outside Worker
Employed	Packer
Employed	Painter & Decorator
Employed	Partnership 4 Plus
Employed	Partnership Up To 3
Employed	Personnel Consultant
Employed	Photographer
Employed	Pilot
Employed	Plumber
Employed	Police
Employed	Production Controller
Employed	Production; Other
Employed	Professional; Licensed
Employed	Professional; Other
Employed	Receptionist
Employed	Repairer/Installer Production
Employed	Research Assistant
Employed	Restaurant Host/Hostess
Employed	Roofer
Employed	Sales
Employed	Sales Representative
Employed	School Head Teacher
Employed	Secretary
Employed	Security Guard
Employed	Self Employed
Employed	Semi-Professional
Employed	Service Manager
Employed	Service; Food-Handler
Employed	Service; Other
Employed	Ship Crew
Employed	Social Worker
Employed	Steel Worker
Employed	Steward/Stewardess
Employed	Stock Broker
Employed	Supervisor
Employed	Surveyor
Employed	Systems Analyst
Employed	Teacher
Employed	Technician
Employed	Telephone Operator
Employed	Trades
Employed	TV Repair
Employed	Underwriter
Employed	Uniformed Civil Service
Employed	Uniformed Postal Service
Employed	Veterinarian
Employed	Waiter/Waitress
Employed	Warehouse Worker
Homemaker	Homemaker/Housewife
Retired	Retired
Student	Student
Unemployed	Unemployed With Income
Unemployed	Unemployed With No Income
\.


copy it_province(id) from stdin encoding 'windows-1251' ;
Agrigento
Alessandria
Ancona
Aosta
Arezzo
Ascoli Piceno
Asti
Avellino
Bari
Barletta-Andria-Trani
Belluno
Benevento
Bergamo
Biella
Bologna
South Tyrol
Brescia
Brindisi
Cagliari
Caltanissetta
Campobasso
Carbonia-Iglesias
Caserta
Catania
Catanzaro
Chieti
Como
Cosenza
Cremona
Crotone
Cuneo
Enna
Fermo
Ferrara
Florence
Foggia
Forlì-Cesena
Frosinone
Genoa
Gorizia
Grosseto
Imperia
Isernia
La Spezia
L''Aquila
Latina
Lecce
Lecco
Livorno
Lodi
Lucca
Macerata
Mantua
Massa and Carrara
Matera
Medio Campidano
Messina
Milan
Modena
Monza and Brianza
Naples
Novara
Nuoro
Ogliastra
Olbia-Tempio
Oristano
Padua
Palermo
Parma
Pavia
Perugia
Pesaro and Urbino
Pescara
Piacenza
Pisa
Pistoia
Pordenone
Potenza
Prato
Ragusa
Ravenna
Reggio Calabria
Reggio Emilia
Rieti
Rimini
Rome
Rovigo
Salerno
Sassari
Savona
Siena
Sondrio
Syracuse
Taranto
Teramo
Terni
Trapani
Trentino
Treviso
Trieste
Turin
Udine
Varese
Venice
Verbano-Cusio-Ossola
Vercelli
Verona
Vibo Valentia
Vicenza
Viterbo
\.

 INSERT INTO currency(id,label) VALUES
    ('GBP', 'Pound Sterling'),
    ('EUR', 'Euro'),
    ('CHF', 'Swiss Franc'),
    ('BRL', 'Brazilian Real'),
    ('CLP', 'Chilean Peso'),
    ('COP', 'Colombian Peso'),
    ('MXN', 'Mexican New Peso'),
    ('MXP', 'Mexican Peso'),      
    ('USD', 'United States Dollar');

INSERT INTO country(id, name, name2, iso3, numcode) VALUES 
    ('GB', 'UNITED KINGDOM', 'United Kingdom', 'GBR', 826),
    ('IT', 'ITALY', 'Italy', 'ITA', 380),
    ('AT', 'AUSTRIA', 'Austria', 'AUT', 40),
    ('FR', 'FRANCE', 'France', 'FRA', 250),
    ('DE', 'GERMANY', 'Germany', 'DEU', 276),
    ('MX', 'MEXICO', 'Mexico', 'MEX', 484),
    ('CL', 'CHILE', 'Chile', 'CHL', 152),
    ('CO', 'COLOMBIA', 'Colombia', 'COL', 170),
    ('BE', 'BELGIUM', 'Belgium', 'BEL', 56),
    ('NL', 'NETHERLANDS', 'Netherlands', 'NLD', 528),
    ('LU', 'LUXEMBOURG', 'Luxembourg', 'LUX', 442),
    ('CH', 'SWITZERLAND', 'Switzerland', 'CHE', 756),
    ('BR', 'BRAZIL', 'Brazil', 'BRA', 76);

  INSERT INTO language(id,label, country) VALUES
    ('en_GB', 'English', 'GB'),
    ('it_IT', 'Italian', 'IT'),
    ('de_AT', 'German',  'AT'),
    ('fr_FR', 'French',  'FR'),
    ('de_DE', 'German',  'DE'),
    ('es_MX', 'Spanish', 'MX'),
    ('es_CL', 'Chile',   'CL'),      
    ('es_CO', 'Spanish', 'CO'),
    ('nl_BE', 'Dutch',   'BE'),
    ('fr_BE', 'French',  'BE'),
    ('nl_NL', 'Dutch',   'NL'),
    ('fr_LU', 'French',  'LU'),
    ('de_LU', 'German',  'LU'),
    ('fr_CH', 'French',  'CH'),
    ('de_CH', 'German',  'CH'),
    ('it_CH', 'Italian', 'CH'),
    ('pt_BR', 'Portuguese', 'BR')   
    ;



copy cra(id, country) from stdin encoding 'windows-1251';
GB_EQUIFAX_CONSUMER	GB
GB_EQUIFAX_COMMERCIAL	GB
GB_EXPERIAN_CONSUMER	GB
IT_CRIF_CONSUMER	IT
IT_CRIF_COMMERCIAL	IT
IT_EXPERIAN_CONSUMER	IT
\.

copy app_type(country, label) from stdin encoding 'windows-1251';
IT	PrivateIndividual
IT	SoleTrader
IT	Company
IT	Partnership
GB	PrivateIndividual
GB	SoleTrader
GB	Company
GB	Partnership
GB	PartershipGT3
\.

copy product_category_type(id,label) from stdin encoding 'windows-1251';
CONSUMER	CONSUMER
BUSINESS	BUSINESS
\.

copy product_category(id,categorytype) from stdin encoding 'windows-1251';
IND	CONSUMER
SME	BUSINESS
\.
copy product(country,category,label) from stdin encoding 'windows-1251';
GB	IND	PCP
GB	IND	CSHP
GB	IND	LEASING
GB	SME	PCP
GB	SME	CSHP
GB	SME	LEASING
IT	IND	AUTOLOAN
IT	IND	SMARTBUY
IT	IND	SMALLTICKET
IT	SME	AUTOLOAN
IT	SME	SMARTYBUY
IT	SME	LEASING
\.
copy org_type(id) from stdin encoding 'windows-1251';
Financial Institution
Organization
Continent
Country
Region
Branch
\.
copy org(id,parent_id,org_type, org_name) from stdin encoding 'windows-1251';
1	\N	Organization	GMF
2	1	Continent	EUROPE
3	1	Continent	LATAM
4	2	Country	United Kingdom
5	2	Country	Italy
6	4	Region	GBRegion
7	6	Branch	GB
8	5	Region	ITRegion
9	8	Branch	IT
\.


INSERT INTO nationality (id, code) VALUES
    (1, 'Afghan'),
    (2, 'Albanian'),
    (3, 'Algerian'),
    (4, 'American'),
    (5, 'Andorran'),
    (6, 'Angolan'),
    (7, 'Antiguans'),
    (8, 'Argentinean'),
    (9, 'Armenian'),
    (10, 'Australian'),
    (11, 'Austrian'),
    (12, 'Azerbaijani'),
    (13, 'Bahamian'),
    (14, 'Bahraini'),
    (15, 'Bangladeshi'),
    (16, 'Barbadian'),
    (17, 'Barbudans'),
    (18, 'Batswana'),
    (19, 'Belarusian'),
    (20, 'Belgian'),
    (21, 'Belizean'),
    (22, 'Beninese'),
    (23, 'Bhutanese'),
    (24, 'Bolivian'),
    (25, 'Bosnian'),
    (26, 'Brazilian'),
    (27, 'British'),
    (28, 'Bruneian'),
    (29, 'Bulgarian'),
    (30, 'Burkinabe'),
    (31, 'Burmese'),
    (32, 'Burundian'),
    (33, 'Cambodian'),
    (34, 'Cameroonian'),
    (35, 'Canadian'),
    (36, 'Cape Verdean'),
    (37, 'Central African'),
    (38, 'Chadian'),
    (39, 'Chilean'),
    (40, 'Chinese'),
    (41, 'Colombian'),
    (42, 'Comoran'),
    (43, 'Congolese'),
    (44, 'Costa Rican'),
    (45, 'Croatian'),
    (46, 'Cuban'),
    (47, 'Cypriot'),
    (48, 'Czech'),
    (49, 'Danish'),
    (50, 'Djibouti'),
    (51, 'Dominican'),
    (52, 'Dutch'),
    (53, 'East Timorese'),
    (54, 'Ecuadorean'),
    (55, 'Egyptian'),
    (56, 'Emirian'),
    (57, 'Equatorial Guinean'),
    (58, 'Eritrean'),
    (59, 'Estonian'),
    (60, 'Ethiopian'),
    (61, 'Fijian'),
    (62, 'Filipino'),
    (63, 'Finnish'),
    (64, 'French'),
    (65, 'Gabonese'),
    (66, 'Gambian'),
    (67, 'Georgian'),
    (68, 'German'),
    (69, 'Ghanaian'),
    (70, 'Greek'),
    (71, 'Grenadian'),
    (72, 'Guatemalan'),
    (73, 'Guinea-Bissauan'),
    (74, 'Guinean'),
    (75, 'Guyanese'),
    (76, 'Haitian'),
    (77, 'Herzegovinian'),
    (78, 'Honduran'),
    (79, 'Hungarian'),
    (80, 'I-Kiribati'),
    (81, 'Icelander'),
    (82, 'Indian'),
    (83, 'Indonesian'),
    (84, 'Iranian'),
    (85, 'Iraqi'),
    (86, 'Irish'),
    (87, 'Israeli'),
    (88, 'Italian'),
    (89, 'Ivorian'),
    (90, 'Jamaican'),
    (91, 'Japanese'),
    (92, 'Jordanian'),
    (93, 'Kazakhstani'),
    (94, 'Kenyan'),
    (95, 'Kittian and Nevisian'),
    (96, 'Kuwaiti'),
    (97, 'Kyrgyz'),
    (98, 'Laotian'),
    (99, 'Latvian'),
    (100, 'Lebanese'),
    (101, 'Liberian'),
    (102, 'Libyan'),
    (103, 'Liechtensteiner'),
    (104, 'Lithuanian'),
    (105, 'Luxembourger'),
    (106, 'Macedonian'),
    (107, 'Malagasy'),
    (108, 'Malawian'),
    (109, 'Malaysian'),
    (110, 'Maldivan'),
    (111, 'Malian'),
    (112, 'Maltese'),
    (113, 'Marshallese'),
    (114, 'Mauritanian'),
    (115, 'Mauritian'),
    (116, 'Mexican'),
    (117, 'Micronesian'),
    (118, 'Moldovan'),
    (119, 'Monacan'),
    (120, 'Mongolian'),
    (121, 'Moroccan'),
    (122, 'Mosotho'),
    (123, 'Motswana'),
    (124, 'Mozambican'),
    (125, 'Namibian'),
    (126, 'Nauruan'),
    (127, 'Nepalese'),
    (128, 'New Zealander'),
    (129, 'Nicaraguan'),
    (130, 'Nigerian'),
    (131, 'Nigerien'),
    (132, 'North Korean'),
    (133, 'Northern Irish'),
    (134, 'Norwegian'),
    (135, 'Omani'),
    (136, 'Pakistani'),
    (137, 'Palauan'),
    (138, 'Panamanian'),
    (139, 'Papua New Guinean'),
    (140, 'Paraguayan'),
    (141, 'Peruvian'),
    (142, 'Polish'),
    (143, 'Portuguese'),
    (144, 'Qatari'),
    (145, 'Romanian'),
    (146, 'Russian'),
    (147, 'Rwandan'),
    (148, 'Saint Lucian'),
    (149, 'Salvadoran'),
    (150, 'Samoan'),
    (151, 'San Marinese'),
    (152, 'Sao Tomean'),
    (153, 'Saudi'),
    (154, 'Scottish'),
    (155, 'Senegalese'),
    (156, 'Serbian'),
    (157, 'Seychellois'),
    (158, 'Sierra Leonean'),
    (159, 'Singaporean'),
    (160, 'Slovakian'),
    (161, 'Slovenian'),
    (162, 'Solomon Islander'),
    (163, 'Somali'),
    (164, 'South African'),
    (165, 'South Korean'),
    (166, 'Spanish'),
    (167, 'Sri Lankan'),
    (168, 'Sudanese'),
    (169, 'Surinamer'),
    (170, 'Swazi'),
    (171, 'Swedish'),
    (172, 'Swiss'),
    (173, 'Syrian'),
    (174, 'Taiwanese'),
    (175, 'Tajik'),
    (176, 'Tanzanian'),
    (177, 'Thai'),
    (178, 'Togolese'),
    (179, 'Tongan'),
    (180, 'Trinidadian or Tobagonian'),
    (181, 'Tunisian'),
    (182, 'Turkish'),
    (183, 'Tuvaluan'),
    (184, 'Ugandan'),
    (185, 'Ukrainian'),
    (186, 'Uruguayan'),
    (187, 'Uzbekistani'),
    (188, 'Venezuelan'),
    (189, 'Vietnamese'),
    (190, 'Welsh'),
    (191, 'Yemenite'),
    (192, 'Zambian'),
    (193, 'Zimbabwean');

