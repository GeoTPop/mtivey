function y=juldy(iday,mon,yr)

% JULDY Calculate Julian day from input day and month
% and year. Year determines if it is a leap year or not.
% Usage: y=juldy(iday,mon,yr)
%
% Maurice A. Tivey 1991
%

% tst for leap year
leap=0;
if floor(yr/4)==0,
 leap=1;
end

[nx,ny]=size(mon);
if nx > ny, mon=mon'; end
[nx,ny]=size(iday);
if nx > ny, iday=iday'; end

ldays=[0,31,60,91,121,152,182,213,244,274,305,335];
ndays=[0,31,59,90,120,151,181,212,243,273,304,334];
if(leap==1)
   y=iday+ldays(mon);
else
   y=iday+ndays(mon);
end
% The end
