function out=rmsdif(a,b)
% rmsdif - calculate average and rms difference between two vectors
% or the roughness of a vector
% Usage:  s=rmsdif(a,b);
%         s=rmsdif(a);
% where s is array [avg,rms]
% Maurice A. Tivey
%
   nn=length(a);
   s1=0;
   s2=0;
   if nargin==1,
      dif=diff(a);
   elseif nargin==2,
      dif=abs(a-b);
   else
      help rmsdif
      return
   end
   s1=nansum(dif);
   s2=nansum(dif.*dif);
   avg=s1/nn;
   rms=sqrt(s2/nn - avg^2);
out=[avg,rms];

