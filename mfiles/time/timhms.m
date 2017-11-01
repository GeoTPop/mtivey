function [h,m,s]=timhms(time)
% timhms 
% Convert time in decimal hours to hrs mins secs
%
% Usage [h,m,s]=timhms(time);
% Maurice A. Tivey

h=fix(time);
m=fix((time-h).*60);
s=floor(time.*3600-(h.*3600)-(m.*60));
%
% check for hours greater than 24
for i=1:length(h), 
   if h(i) >= 24,h(i)=h(i)-24;end
   if s(i)>= 60, m(i)=m(i)+1;s(i)=s(i)-60; end
end
% the end

