function y = sec_from_midnight(hours,minutes,seconds)
% sec_from_midnight
% Usage:
%   y = sec_from_midnight(hours,minutes,seconds);
%

y = 3600*hours + 60*minutes + seconds;
