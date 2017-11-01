function [hh,mm,ss]=hms_from_midnight(secsinday);
% hms_from_midnight
% compute hms given seconds in day from midnight
hh=fix(secsinday/3600);
mm=fix((secsinday-hh*3600)/60);
ss=secsinday-hh*3600-mm*60;