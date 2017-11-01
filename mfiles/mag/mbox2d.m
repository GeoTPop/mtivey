function t=mbox2d(x0,y0,z0,x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta)
% mbox2d Compute magnetic effect of a rectangular prism of infinite depth extent
% for a profile (x0,y0,z0). Sides of prism are parallel to x,y,z axes,
% Z-axis is +ve vertical down
% All distances are in kilometers.
%
% Usage:
%   t=mbox2d(x0,y0,z0,x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta);
% x0,y0,z0 arrays of observation points
% x1,y1,z1 x2,y2 are the lateral extents of the prism.  
% mi,md : magnetization inclination, declination
% fi,fd : field inclination, declination
% mag : magnetization of prism
% theta : strike of body
%
% After Bhattacharyya, 1964; Blakely, 1995
% Maurice A. Tivey  MATLAB July 2002
% calls <mbox>

if nargin < 1
 fprintf('DEMO mbox2d')
 help mbox2d
 x0=-10:.1:10;
 z0=zeros(size(x0));
 y0=zeros(size(x0));
 x1=-0.75;x2=0.75;
 y1=-0.75;y2=0.75;
 z1=0.5;
 mi=60;
 md=0;
 fi=60;
 fd=0;
 mag=10;
 theta=0;
 t=mbox2d(x0,y0,z0,x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta);
 subplot(211)
 plot(x0,t)
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Magnetic Field (nT)')
 title('DEMO: MBOX2D Magnetic field over a vertical prism')
 subplot(212)
 plot(x0,z0); hold on;fill([x1,x2,x2,x1],[z1,z1,1,1],'r');axis ij
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 return
end

% call mbox for array of observation points x0,y0,z0
for i=1:length(x0);
 t(i)=mbox(x0(i),y0(i),z0(i),x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta);
end
