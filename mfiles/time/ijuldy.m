function [month,iday]=ijuldy(jday,yr)
% ijuldy - day and month from julian day and year 
% Calculate day and month from input Julian day
% and year
% Usage: [month,day]=ijuldy(jday,yr)
%
% Maurice A. Tivey
% mod Jul 17 2003 MAT
% ref: J. Meeus, Astronomical Algorithms, 1998
% MATLAB5

% test for leap year
leap=2;
% century years not divisible by 400 are
% not leap years
if yr ~= 1900 & yr ~= 2100
 if mod(yr,4)==0,
  leap=1;
 end
end
% see J. Meeus, pg 66
month=fix(9*(leap+jday)/275 + 0.98);
if jday < 32, month=1; end
iday=jday-fix(275*month/9)+leap*fix((month+9)/12)+30;
