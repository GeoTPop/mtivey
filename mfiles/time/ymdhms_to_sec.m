function secs_from_1970 = ymdhms_to_sec(year,month,day,hours,minutes,seconds)
% ymdhms_to_sec
% This function calculates the number of seconds from Jan-01-1970 to the 
% time specified by the args
%
% will accept year as 97 for 1997,  02 for 2002
%
% Matlab datenum and datevec use year 0 as ref, but we will use Jan 1 1970 
% as ref to be compatible w/ unix convention.
%
% Usage:
%  secs_from_1970 = ymdhms_to_sec
%     (year,month,day,hours,minutes,seconds);
%
% August 1997 G. Lerner, cteated and written
% MATLAB5 <datenum>
% Maurice A. Tivey Jul 19 2001
% see also sec_to_ymdhms

% check for exactly 6 input arguments
error(nargchk(6,6,nargin))

% map 97 to 1997,  02 to 2002, etc
if (year <50)
    year = year +2000;
elseif (year <100)
    year = year + 1900;
end

% t1 = datenum(1970,1,1);
t1 = 719529;   % this is the date number for Jan 1 1970

t2 = datenum(year,month,day,hours,minutes,seconds);

secs_from_1970=(t2-t1)*24*3600;
