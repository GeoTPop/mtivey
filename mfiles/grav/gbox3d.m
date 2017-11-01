function g=gbox3d(x0,y0,z0,x1,y1,z1,x2,y2,z2,rho);
% gbox3d
% Compute gravity effect of a rectangular prism
% for a map defined in grid arrays (x0,y0,z0)
% Sides of prism are parallel to x,y,z axes
% Z-axis is +ve vertical down
% x1,y1,z1 x2,y2,z2 is the lateral extent of the 
% prism.  All distances are in kilometers.
%
% Usage:
%   g=gbox3d(x0,y0,z0,x1,y1,z1,x2,y2,z2,rho);
%
% see also gbox.m gbox2d.m
% Maurice A. Tivey  MATLAB July 2002
%
if nargin < 1
 fprintf('DEMO gbox3d')
 help gbox3d
 x0=-10:.25:10;
 y0=-10:.25:10;
 [X,Y]=meshgrid(x0,y0);
 Z=zeros(size(X));
 x1=-0.75;x2=0.75;
 y1=-0.75;y2=0.75;
 z1=0.5;z2=1;
 rho=2670;
 g=gbox3d(X,Y,Z,x1,y1,z1,x2,y2,z2,rho);
 clf
 subplot(211)
 surf(x0,y0,g); shading interp;camlight right;
 xlabel('X-Axis Distance(km)');ylabel('Y-Axis Distance(km)')
 zlabel('Gravity (mgals)')
 title('DEMO gbox3d : Gravity over a vertical prism')
 subplot(212)
 fill([x1,x1,x2,x2],[y1,y2,y2,y1],'r');view(3);axis([-10 10 -10 10 -1 1]);
 xlabel('X-Axis Distance (km)');ylabel('Y-Axis Distance (km)');zlabel('Depth (km)');
 figure
 subplot(211)
 plot(x0,g(:,41))
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO gbox3d : Extracted profile over a vertical prism')
 subplot(212)
 plot(x0,zeros(size(x0))); hold on;fill([x1,x2,x2,x1],[-z1,-z1,-z2,-z2],'r');
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 axis([-10 10 -1 0])
 max(max(g))
 return
end

% fixed parameters
 bigG=6.670e-11;
 twopi=pi*2;
 si2mg=1e5;
 km2m=1000;
 isign=[-1,1];
%
for n=1:length(y0),
for m=1:length(x0),
  x(1)=x0(n,m)-x1;
  y(1)=y0(n,m)-y1;
  z(1)=z0(n,m)-z1;
  x(2)=x0(n,m)-x2;
  y(2)=y0(n,m)-y2;
  z(2)=z0(n,m)-z2;
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
  g(n,m)=rho*bigG*sum*si2mg*km2m;
end
end
                
        