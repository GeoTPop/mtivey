function y=ijuldy(jday,leap)

% IJULDY Calculate day and month from input Julian day
%
% enter 1 for a leap year 0 for a non-leap year
% Usage: y=ijuldy(jday,leap)
%
% Maurice A. Tivey

ldays=[0,31,60,91,121,152,182,213,244,274,305,335,366];
ndays=[0,31,59,90,120,151,181,212,243,273,304,334,365];

mon=1;
if(leap==1)
   i=1;
   while jday > ldays(i),
    mon=mon+1;
    i=i+1;
   end
   iday=jday-ldays(i-1);
   mon=ones(size(jday)).*(i-1);
else
   i=1;
   while jday > ndays(i),
    mon=mon+1;
    i=i+1;
   end
   iday=jday-ndays(i-1);
   mon=ones(size(jday)).*(i-1);
end
y=[iday,mon];
% The end
