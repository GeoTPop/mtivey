function time=hmstim(h,m,s)
% hmstim - convert time in hms to decimal hours
%
% Usage time=hmstime(h,m,s);
% Maurice A. Tivey
 time=h+(m./60)+(s./3600);
 
