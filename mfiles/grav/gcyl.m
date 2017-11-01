function [gx,gz]=gcyl(x0,z0,xq,zq,a,rho);
% gcyl
% Compute gravity effect of a buried horizontal cylinder
% located at xq,zq as measured
% at an observation point (x0,z0)
% Output two components of gravitational
% attraction
% a is radius of the sphere
% rho is density in kg/m3
% Z-axis is +ve vertical down
% All distances are in kilometers.
%
% Usage:
%   [gx,gz]=gcyl(x0,z0,xq,zq,a,rho);
%
% After Blakely, 1995
% Maurice A. Tivey  MATLAB July 2002
%
if nargin < 1
 fprintf('DEMO gcyl')
 help gcyl
 x0=-10:.1:10;
 z0=zeros(size(x0));
 xq=0;
 zq=1;
 a=0.25;
 rho=2670;
for i=1:length(x0);
 [gx(i),gz(i)]=gcyl(x0(i),z0(i),xq,zq,a,rho);
end
 clf
 subplot(211)
 plot(x0,gx)
 hold on
 plot(x0,gz,'g')
 legend('gx','gz');
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO gcyl: Gravity over a buried horizontal cylinder')
 subplot(212)
  plot(x0,z0); hold on
  val=circle;val=val.*a;
  fill(val(1,:),val(2,:)+zq,'r'); axis ij; axis equal
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 return
end

% fixed parameters
 bigG=6.670e-11;
 si2mg=1e5;
 km2m=1000;
% 
rx=x0-xq;
rz=z0-zq;
r2=(rx*rx+rz*rz);
if r2==0, fprintf('Error \n'); return; end
tmass=pi*rho*(a^2);
gx=-2*bigG*tmass*rx/r2;
gz=-2*bigG*tmass*rz/r2;
gx=gx*si2mg*km2m;
gz=gz*si2mg*km2m;

                
        