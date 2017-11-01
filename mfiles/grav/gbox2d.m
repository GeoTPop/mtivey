function g=gbox2d(x0,y0,z0,x1,y1,z1,x2,y2,z2,rho);
% gbox2d
% Compute gravity effect of a rectangular prism
% for a profile defined in arrays (x0,y0,z0)
% Sides of prism are parallel to x,y,z axes
% Z-axis is +ve vertical down
% x1,y1,z1 x2,y2,z2 is the lateral extent of the 
% prism.  All distances are in kilometers.
%
% Usage:
%   g=gbox2d(x0,y0,z0,x1,y1,z1,x2,y2,z2,rho);
%
% see also gbox.m
% Maurice A. Tivey  MATLAB July 2002
%
if nargin < 1
 fprintf('DEMO gbox2d')
 help gbox2d
 x0=-10:.25:10;
 z0=zeros(size(x0));
 y0=zeros(size(x0));
 x1=-0.75;x2=0.75;
 y1=-0.75;y2=0.75;
 z1=0.5;z2=1;
 rho=2670;
 g=gbox2d(x0,y0,z0,x1,y1,z1,x2,y2,z2,rho);
 subplot(211)
 plot(x0,g)
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO gbox2d : Gravity over a vertical prism')
 subplot(212)
 plot(x0,z0); hold on;fill([x1,x2,x2,x1],[z1,z1,z2,z2],'r');axis ij
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 max(g)
 return
end

% fixed parameters
 bigG=6.670e-11;
 twopi=pi*2;
 si2mg=1e5;
 km2m=1000;
 isign=[-1,1];
%
for n=1:length(x0),
  x(1)=x0(n)-x1;
  y(1)=y0(n)-y1;
  z(1)=z0(n)-z1;
  x(2)=x0(n)-x2;
  y(2)=y0(n)-y2;
  z(2)=z0(n)-z2;
  sum=0;
  for i=1:2,
    for j=1:2,
        for k=1:2,
            rijk=sqrt(x(i)^2+y(j)^2+z(k)^2);
            ijk=isign(i)*isign(j)*isign(k);
            arg1=atan2((x(i)*y(j)),(z(k)*rijk));
            if arg1 < 0, arg1=arg1+twopi; end
            arg2=rijk+y(j);
            arg3=rijk+x(i);
            if arg2 <= 0, fprintf('Bad Field pt'); end
            if arg3 <= 0, fprintf('Bad field pt'); end
            arg2=log(arg2);
            arg3=log(arg3);
            sum=sum+ijk*(z(k)*arg1-x(i)*arg2-y(j)*arg3);
        end
    end
  end
  g(n)=rho*bigG*sum*si2mg*km2m;
end

                
        