function n=juldy(iday,mon,yr)
% juldy - compute julian day from day,month,yr 
% Calculate modified Julian day from input day and month
% and year. Year determines if it is a leap year or not.
% Modified julian day starts at Greenwich mean midnight.
% see jday for julian day emphemeris as used in astronomy
%
% Usage: n=juldy(iday,mon,yr)
%
% Maurice A. Tivey 1991
% Jul 2000
% mod Jul 17 2003 MAT
% ref: J. Meeus, Astronomical Algorithms, 1998
% MATLAB5

% test for leap year
leap=2; % common year
% century years not divisible by 400 are
% not leap years in Gregorian calendar
if yr ~= 1900 & yr ~= 2100
 if mod(yr,4)==0,
  leap=1;  % a leap (bissextile) year
 end
end
% see J. Meeus eqn pg. 65
 n=fix(275*mon/9)-leap*fix((mon+9)/12)+iday-30;
% The end
