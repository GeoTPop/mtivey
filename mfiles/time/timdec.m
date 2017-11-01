function dtime=timdec(hhmmss);
% timdec - convert hhmmss (Alvin) time format
% to decimal hours
% Usage: 
%    dectime=timdec(hhmmss);
% e.g. 133030 => 13.5083
%
% Maurice A. Tivey
% Oct 1997  Matlab V5
% see also dectim for inverse

hh=floor(hhmmss./10000);
mm=floor((hhmmss-hh.*10000)./100);
ss=hhmmss-hh*10000-mm*100;
dtime=hh+(mm./60)+(ss./3600);
