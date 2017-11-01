% SINT200
% Paleointensity curve from Guyodo and Valet, 
% EPSL, 143, 23-36, 1996.
% Downloaded from EPSL web site:
%   http://www.elsevier.com/locate/epsl
% sint200.tbl
% Array GV has the following columns:
%  Time kyr BP,# of records, Relative Intensity, Stddev
%
% Note relative intensity is set to 1 at ~45 kyrs
% Multiplying by a factor of 5 approximates the
% magnitude of the dipole moment.
% see also archeomg.m for archeomagnetic data


%Time B.P.	Number of	Relative Paleo-		Std. Dev.
%(ka)		records		intensity Sint-200		(1 sigma)

GV=[
2.0000		2.0000		2.0145			0.0041903;
3.0000		3.0000		2.0189			0.13203;
4.0000		3.0000		1.9972			0.14171;
5.0000		3.0000		2.0157			0.036360;
6.0000		5.0000		1.6240			0.57091;
7.0000		6.0000		1.7691			0.33528;
8.0000		6.0000		1.7057			0.25933;
9.0000		8.0000		1.6635			0.29210;
10.000		9.0000		1.5615			0.41489;
11.000		10.000		1.5995			0.47498;
12.000		11.000		1.5267			0.36448;
13.000		11.000		1.5187			0.47335;
14.000		13.000		1.4070			0.47401;
15.000		13.000		1.3182			0.54566;
16.000		13.000		1.2695			0.51230;
17.000		14.000		1.2218			0.37711;
18.000		15.000		1.3055			0.45941;
19.000		15.000		1.2852			0.53699;
20.000		15.000		1.2214			0.52801;
21.000		15.000		1.1638			0.44412;
22.000		15.000		1.1025			0.36515;
23.000		16.000		1.0611			0.29263;
24.000		17.000		1.0407			0.25242;
25.000		17.000		1.1007			0.27705;
26.000		17.000		0.98083			0.19136;
27.000		17.000		0.95845			0.23477;
28.000		17.000		0.92672			0.28726;
29.000		17.000		0.95164			0.25966;
30.000		17.000		0.93692			0.31538;
31.000		17.000		0.94129			0.26459;
32.000		17.000		0.92391			0.28578;
33.000		17.000		0.91798			0.31337;
34.000		17.000		0.90387			0.37934;
35.000		17.000		0.81936			0.32229;
36.000		17.000		0.69785			0.22517;
37.000		17.000		0.58777			0.21062;
38.000		17.000		0.59625			0.20198;
39.000		17.000		0.70595			0.33952;
40.000		17.000		0.61252			0.21168;
41.000		17.000		0.60641			0.26143;
42.000		17.000		0.67573			0.25202;
43.000		17.000		0.76366			0.27697;
44.000		17.000		0.85615			0.28815;
45.000		17.000		0.90851			0.36038;
46.000		17.000		1.0364			0.37293;
47.000		17.000		1.1071			0.49588;
48.000		17.000		1.1938			0.55851;
49.000		17.000		1.2612			0.50910;
50.000		17.000		1.3114			0.34455;
51.000		17.000		1.4044			0.27000;
52.000		17.000		1.4486			0.30461;
53.000		17.000		1.4049			0.34829;
54.000		17.000		1.4453			0.26986;
55.000		17.000		1.4905			0.41452;
56.000		17.000		1.4834			0.61680;
57.000		16.000		1.4123			0.56732;
58.000		16.000		1.3273			0.60881;
59.000		16.000		1.2598			0.52025;
60.000		16.000		1.1820			0.38833;
61.000		16.000		1.1202			0.33331;
62.000		16.000		1.0453			0.29317;
63.000		15.000		1.0165			0.25333;
64.000		15.000		0.92144			0.27131;
65.000		15.000		0.91056			0.29077;
66.000		15.000		0.93249			0.39022;
67.000		15.000		0.96087			0.35752;
68.000		15.000		0.99251			0.35026;
69.000		15.000		1.0212			0.31203;
70.000		15.000		1.1123			0.23573;
71.000		15.000		1.1865			0.21805;
72.000		15.000		1.1797			0.34310;
73.000		15.000		1.1342			0.27996;
74.000		15.000		1.0519			0.27313;
75.000		15.000		1.1005			0.45206;
76.000		15.000		1.1198			0.38915;
77.000		15.000		1.1555			0.39491;
78.000		15.000		1.1337			0.37041;
79.000		15.000		1.2147			0.41365;
80.000		15.000		1.2062			0.42575;
81.000		15.000		1.1775			0.35620;
82.000		15.000		1.2005			0.32466;
83.000		15.000		1.1537			0.27623;
84.000		15.000		1.1535			0.23762;
85.000		15.000		1.2054			0.27787;
86.000		15.000		1.2356			0.32747;
87.000		15.000		1.1942			0.26747;
88.000		15.000		1.1042			0.31851;
89.000		15.000		1.0755			0.35671;
90.000		15.000		1.0652			0.34954;
91.000		15.000		1.0677			0.39402;
92.000		15.000		1.0178			0.35472;
93.000		15.000		0.94499			0.33374;
94.000		15.000		0.88399			0.35859;
95.000		15.000		0.85279			0.38567;
96.000		15.000		0.80914			0.41485;
97.000		15.000		0.75786			0.35086;
98.000		15.000		0.69589			0.35208;
99.000		15.000		0.69103			0.31124;
100.00		15.000		0.69724			0.21222;
101.00		15.000		0.73478			0.21064;
102.00		14.000		0.79998			0.21967;
103.00		14.000		0.77452			0.25779;
104.00		14.000		0.71125			0.20184;
105.00		14.000		0.67746			0.15852	;
106.00		14.000		0.72217			0.16156;
107.00		13.000		0.73057			0.17603;
108.00		13.000		0.71267			0.21691;
109.00		13.000		0.73854			0.20673;
110.00		13.000		0.76947			0.20659;
111.00		13.000		0.78360			0.24259;
112.00		13.000		0.74900			0.25627;
113.00		13.000		0.74676			0.25523;
114.00		13.000		0.74302			0.27460;
115.00		13.000		0.76648			0.25105;
116.00		13.000		0.78844			0.25843;
117.00		13.000		0.78189			0.27243;
118.00		13.000		0.84467			0.27050;
119.00		13.000		0.84553			0.32674;
120.00		13.000		0.85968			0.33231;
121.00		13.000		0.88449			0.35309;
122.00		13.000		0.89024			0.38533;
123.00		12.000		0.91224			0.32995;
124.00		12.000		0.91583			0.36454;
125.00		12.000		1.0030			0.33860;
126.00		12.000		1.0415			0.31656;
127.00		12.000		1.0893			0.36465;
128.00		12.000		1.0134			0.29611;
129.00		12.000		1.0259			0.33329;
130.00		12.000		0.97726			0.32076;
131.00		12.000		0.89261			0.29695;
132.00		12.000		0.91658			0.32102;
133.00		12.000		0.94707			0.36468;
134.00		12.000		0.92717			0.30262;
135.00		12.000		0.88556			0.31316;
136.00		10.000		1.0414			0.36550;
137.00		10.000		1.0584			0.28875;
138.00		9.0000		1.1650			0.29119;
139.00		8.0000		1.2332			0.36582;
140.00		8.0000		1.2221			0.31087;
141.00		8.0000		1.2251			0.24972;
142.00		8.0000		1.2376			0.27628;
143.00		8.0000		1.2639			0.31628;
144.00		8.0000		1.2815			0.37382;
145.00		8.0000		1.2998			0.41913;
146.00		8.0000		1.2998			0.44232;
147.00		8.0000		1.2596			0.45263;
148.00		8.0000		1.2021			0.48170;
149.00		8.0000		1.1741			0.51974;
150.00		8.0000		1.1381			0.56293;
151.00		8.0000		1.0370			0.41016;
152.00		8.0000		0.99007			0.38357;
153.00		8.0000		0.97581			0.35691;
154.00		8.0000		0.91538			0.27343;
155.00		8.0000		0.92936			0.29914;
156.00		8.0000		1.0109			0.37927;
157.00		8.0000		1.1808			0.44255;
158.00		8.0000		1.3362			0.62470;
159.00		8.0000		1.3387			0.67213;
160.00		7.0000		1.1395			0.45772;
161.00		7.0000		1.0492			0.31186;
162.00		7.0000		0.96037			0.24114;
163.00		7.0000		0.96153			0.19122;
164.00		7.0000		1.0519			0.20012;
165.00		7.0000		1.1962			0.22186;
166.00		7.0000		1.3121			0.26619;
167.00		7.0000		1.2308			0.22169;
168.00		7.0000		1.1931			0.21646;
169.00		7.0000		1.1259			0.27252;
170.00		7.0000		1.0885			0.25861;
171.00		7.0000		1.1332			0.30109;
172.00		7.0000		1.0663			0.26453;
173.00		7.0000		0.97212			0.17479;
174.00		7.0000		1.0357			0.30014;
175.00		7.0000		1.1442			0.52436;
176.00		7.0000		1.1316			0.56030;
177.00		7.0000		1.1040			0.33186;
178.00		7.0000		1.1529			0.24050;
179.00		7.0000		1.0738			0.19230;
180.00		7.0000		0.97995			0.19596;
181.00		7.0000		0.90127			0.27896;
182.00		7.0000		0.79822			0.27251;
183.00		7.0000		0.65407			0.21078;
184.00		7.0000		0.55870			0.18329;
185.00		7.0000		0.52436			0.16486;
186.00		7.0000		0.47559			0.18625;
187.00		7.0000		0.43082			0.22320;
188.00		7.0000		0.39300			0.26863;
189.00		6.0000		0.43818			0.31093;
190.00		5.0000		0.34900			0.28168;
191.00		5.0000		0.35912			0.30136;
192.00		5.0000		0.43121			0.27864;
193.00		5.0000		0.58557			0.23767;
194.00		5.0000		0.68501			0.26923;
195.00		4.0000		0.83074			0.33048;
196.00		4.0000		0.86111			0.35018;
197.00		4.0000		0.91070			0.38637;
198.00		4.0000		0.99072			0.45901;
199.00		3.0000		0.90641			0.42952;
200.00		3.0000		1.0837			0.59245];


