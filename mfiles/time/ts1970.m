function y=ts1970(yr,jd)
% ts1970  
% Calculate time since 1970 in seconds
% Usage: 
%     secs=ts1970(yr,jd)
% yr is year of survey
% jd is julian decimal day of survey
%
% Maurice A. Tivey Jul 2001
% MATLAB5 <ijuldy,timhms,datenum>
% see also ymdhms_to-seconds

t1 = 719529;   % this is the date number for Jan 1 1970

jdi=jd-rem(jd,1);
[hours,minutes,seconds]=timhms(rem(jd,1)*24);
[month,day]=ijuldy(jdi,yr)
t2 = datenum(yr,month,day,hours,minutes,seconds);

y=(t2-t1)*86400;
