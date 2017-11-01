function hhmmss=dectim(time)
% dectim - convert decimal hours to hhmmss
% format used in ALVIN data, etc
% Usage:
%   hhmmss=dectim(decimalhours)
% e.g. 13.5083 => 133030
%
% Maurice A. Tivey Oct 1997 
% MATLABV5
% see also timdec for inverse

hh=floor(time);
mm=floor((time-hh)*60);
ss=((time-hh)*60-mm)*60;
hhmmss=hh*10000+mm*100+ss;
