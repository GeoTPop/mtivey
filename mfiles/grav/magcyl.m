function gz=magcyl(x0,z0,xq,zq,a,sus);
% magcyl
% Compute magnetic effect of a buried horizontal cylinder
% located at xq,zq as measured
% at an observation point (x0,z0)
% Output two components of magnetic field
%  
% a is radius of the sphere
% sus is magnetic intensity in kg/m3
% Z-axis is +ve vertical down
% All distances are in kilometers.
%
% Usage:
%   gz=magcyl(x0,z0,xq,zq,a,rho);
%
% 
% Maurice A. Tivey  MATLAB Mar 2012
%
if nargin < 1
 fprintf('DEMO magcyl')
 help magcyl
 x0=-10:.1:10;
 z0=zeros(size(x0));
 xq=0;
 zq=1;
 a=0.25;
 sus=2670;
for i=1:length(x0);
 z=magcyl(x0(i),z0(i),xq,zq,a,sus);
 gz(i)=z;
end
 clf
 subplot(211)
 plot(x0,gz)
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Magnetic Field (nT)')
 title('DEMO magcyl: Magnetic Field over a buried horizontal cylinder')
 subplot(212)
  plot(x0,z0); hold on
  val=circle;val=val.*a;
  fill(val(1,:),val(2,:)+zq,'r'); axis ij; axis equal
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 return
end

% fixed parameters
 si2mg=1e-5;
 km2m=1000;
% 
rx=x0-xq;
rz=z0-zq;
r2=(rx/rz)^2;
a2=a*a;
if r2==0, fprintf('Error \n'); return; end
gz=(2*pi*a2*sus)/(rz^2);
gz=gz*(1-r2)/((1+r2)^2);
gz=gz*si2mg*km2m;

                
        