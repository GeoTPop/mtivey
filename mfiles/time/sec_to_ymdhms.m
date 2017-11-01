function [year,month,day,hour,minute,second] = sec_to_ymdhms(secs_from_1970) 
% sec_to_ymdhms
% Calculates the date given the number of seconds from 
% Jan-01-1970 
% Matlab datenum and datevec use year 0 as ref, but we will 
% use Jan 1 1970 as ref to be compatible w/ unix convention.
% 
% Note: returns year as 1997, not 97, and 2002, not 02 
% Usage: [y,m,d,h,m,s]=sec_to_ymdhms(secsfrom1970)
%
%  August 1997 G. Lerner, created and written
% MATLAB5 <datevec>
% Maurice A. Tivey Jul 19 2001
% see also ymdhms_to_sec

% t1 = datenum(1970,1,1);
t1=719529;   % this is the date number for Jan 1 1970

[year,month,day,hour,minute,second]  = datevec(t1 + (secs_from_1970/(24*3600)));

