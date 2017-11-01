function [gx,gy,gz]=gsphere(x0,y0,z0,xq,yq,zq,a,rho);
% gsphere
% Compute gravity effect of a buried sphere
% located at xq,yq,zq as measured
% at an observation point (x0,y0,z0)
% Output three components of gravitational
% attraction
% a is radius of the sphere
% rho is density in kg/m3
% Z-axis is +ve vertical down
% All distances are in kilometers.
%
% Usage:
%   [gx,gy,gz]=gsphere(x0,y0,z0,xq,yq,zq,a,rho);
%
% After Blakely, 1995
% Maurice A. Tivey  MATLAB July 2002
%
if nargin < 1
 fprintf('DEMO gsphere')
 help gsphere
 x0=-10:.1:10;
 y0=zeros(size(x0));
 z0=zeros(size(x0));
 xq=0;
 yq=0;
 zq=1;
 a=0.25;
 rho=2670;
for i=1:length(x0);
 [gx(i),gy(i),gz(i)]=gsphere(x0(i),y0(i),z0(i),xq,yq,zq,a,rho);
end
 clf
 subplot(211)
 plot(x0,gx)
 hold on
 plot(x0,gy,'r');plot(x0,gz,'g')
 legend('gx','gy','gz');
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO gsphere: Gravity over a buried sphere')
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
ry=y0-yq;
rz=z0-zq;
r=sqrt(rx*rx+ry*ry+rz*rz);
if r==0, fprintf('Error \n'); return; end
r3=r^3;
tmass=4*pi*rho*(a^3)/3;
gx=-bigG*tmass*rx/r3;
gy=-bigG*tmass*ry/r3;
gz=-bigG*tmass*rz/r3;
gx=gx*si2mg*km2m;
gy=gy*si2mg*km2m;
gz=gz*si2mg*km2m;

                
        