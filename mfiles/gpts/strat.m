% strat
% Stratigraphic ages
% places two cell arrays into workspace
%
% geol_age : geological periods with ages
%  Ref: Press and Siever, 1974 (now out of date)
%
% strat_stages : stratigraphic stages with start and end ages
%  Ref: Opdyke and Channell, 1996
% 
% Maurice Tivey  Sept. 2000

% Press and Siever, 1974: now out of date
geol_age={
0,1,'Holocene';   % not correct
1,2,'Pleistocene';% start not correct
2,12,'Pliocene';
12,26,'Miocene';
26,37,'Oligocene';
37,53,'Eocene';
53,65,'Paleocene';
65,136,'Cretaceous';
136,190,'Jurassic';
190,225,'Triassic';
225,280,'Permian';
280,345,'Carboniferous';
345,395,'Devonian';
395,430,'Silurian';
430,500,'Ordovician';
500,570,'Cambrian'}


% Jurassic - early Cretaceous stratigraphic stages based on Gradstein et al., [1994] 
% (also Table 10.2 Opdyke and Channell)
Strat_stages={
0,1.7,'Pleistocene';
1.7,5.3,'Pliocene';
5.3,24.0,'Miocene';
24.0,33.7,'Oligocene';
33.7,55.0,'Eocene';
55.0,65.0,'Paleocene';
65.0,74.5,'Maastrichtian';
74.5,84.0,'Campanian';
84.0,86.3,'Santonian';
86.3,88.7,'Coniacian';
88.7,93.3,'Turonian';
93.3,98.5,'Cenomanian';
98.5,112.0,'Albian';
112.0,121.0,'Aptian';
121.0,127.0,'Barremian';
127.0,132.0,'Hauterivian';
132.0,137.0,'Valanginian';
137.0,144.2,'Berriasian K';
144.2, 150.7,'Tithonian J';
150.7,154.1,'Kimmeridgian';
154.1,159.4,'Oxfordian';
159.4,164.4,'Callovian'
164.4,169.2,'Bathonian'
169.2,176.5,'Bajocian';
176.5,180.1,'Aalenian';
180.1,189.6,'Toarcian';
189.6,195.3,'Pliensbachian';
195.3,201.9,'Sinemurian';
201.9,205.7,'Hettangian J/T';
205.7,225,'Rhaetian'};
% Norian
% Carnian
% Ladinian
% Anisian
% Spa.
% Smi.
% Die.
% Griesbach

