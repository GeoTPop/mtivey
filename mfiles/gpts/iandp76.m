% I&P76.M
% 
% digitized polarity bias data from
% Irving, E. & G. Pullaiah, Reversals of the
% geomagnetic field, magnetostratigraphy, and
% relative magnitude of paleosecular variation
% in the Phanerozoic, Earth Science Reviews,
% 12, 35-64, 1976.
% see their figure 13

% 100 Ma average
p100=[53,65,79,59,34,15,27,37,48,28,30];
t100=50:50:550;
% 50 Ma average
p50=[46,53,70,81,80,75,78,72,49,21,5,11,...
     24,24,28,52,60,55,30,31,29,19,28];
t50=25:25:575;
% 25 Ma average   12.5 MA intervals
p25=[48,41,55,50,42,75,85,94,85,70,78,74,...
     70,76,81,86,81,43,30,0,7,4,5,12,9,14,...
     21,14,12,27,43,46,53,62,67,76,15,2,19,...
     25,29,2,11,19,18,35,0];
t25=12.5:12.5:587.5;
% note that I&P sampled frequencies at .0001 c/Ma
y=(p25-50)/100;
nn=256;
nn2=nn/2;
sle_rate=1/12.5;
% do spectral analysis
order=23;
s=moburgc(y,order,256);
% plot it out
   subplot(211)
   plot((1:47)*12.5, y)
   title('Irving & Pullaiah, 1976 Data Compilation')
   ylabel('Bias')
   xlabel('Age Ma')
   ff = (sle_rate/nn)* (0:nn2-1);
   subplot(212)
   plot(ff*10000, s(1:nn2))
   title('Burg Maximum Entropy Spectrum')
   xlabel('Frequency cycles/Ma x10-4')
