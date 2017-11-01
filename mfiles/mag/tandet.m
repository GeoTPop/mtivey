function [sume,zze]=tandet(f,zze);      
% tandet arctan function
% based on subroutine tandet(f,zze,sume)
% Usage: 
%    [sume,zze]=tandet(f,zze);
%
% used in prism3d.m
%  Maurice Tivey Feb. 1999
%
% Problem of summing sume solved by calling
% tandet and then summing result
% e.g. [t1,w1]=tandet(ft1,w1);tt1=tt1+t1;
% 
      sume=0;
      q1=zze+f;
      q2=1-zze*f;
      if q2 == 0.0,
       if q1 < 0,
        sume=sume-(pi/2);
       else
        sume=sume+(pi/2);
       end
       zze=0.0;
      else
       zze=q1/q2;
       if q2 > 0.0, return; end
       if q1 < 0,
          sume=sume-pi;
       elseif q1==0,
          return;
       else
          sume=sume+pi;
       end
      end

