function t=mbox3d(x0,y0,z0,x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta)
% mbox3d Compute total magnetic field of a rectangular prism of infinite depth 
% extent for a grid of observations on z0 with x0 and y0 coordinates.
% Sides of prism are parallel to x,y,z axes
% Z-axis is +ve vertical down
% All distances are in kilometers.
%
% Usage:
%   t=mbox3d(x0,y0,z0,x1,y1,z1,x2,y2,inclm,declm,inclf,declf,mag,theta);
% x0,y0,z0 observation coordinates and obs level grid
% x1,y1,z1,x2,y2 lateral extent of prism
% inclm magnetization inclination
% declm magnetization declination
% inclf field inclination
% declf field declination
% mag magnetization
% theta declination of x-axis;
% After Bhattacharyya, 1964; Blakely, 1995
% Maurice A. Tivey  MATLAB July 2002
% calls <mbox>
if nargin < 1
 fprintf('DEMO mbox3d')
 help mbox3d
 x0=-3:.1:3;
 y0=-3:.1:3;
 z0=meshgrid(x0,y0).*0;
 x1=-0.75;x2=0.75;
 y1=-0.75;y2=0.75;
 z1=0.5;
 mi=60;
 md=0;
 fi=60;
 fd=0;
 mag=10;
 theta=0;
 t=mbox3d(x0,y0,z0,x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta);
 subplot(221)
 surf(x0,y0,t); shading interp;camlight right;
 ax=axis;
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Y-Axis Distance in Kilometers')
 title('DEMO: Magnetic field over a vertical prism')
 subplot(223)
 vertex=[
  x1,y1,-1;
  x1,y2,-1;
  x2,y2,-1;
  x2,y1,-1;
  x1,y1,-z1;
  x1,y2,-z1;
  x2,y2,-z1;
  x2,y1,-z1];
faces=[1 2 3 4;
    5 6 7 8;
    1 5 8 4;
    1 2 6 5;
    2 3 7 6;
    4 3 7 8];
 patch('vertices',vertex,'faces',faces,'facecolor',[.5 .5 .5]);
 axis([ax(1) ax(2) ax(3) ax(4) -2 0]);grid on;
 xlabel('X-Axis Distance in Kilometers');ylabel('Y-Axis Distance in Kilometers')
 subplot(222)
 [c,h]=contourf(x0,y0,t);
 clabel(c,h)
 return
end

% call mbox for array of observation points x0,y0,z0
for j=1:length(y0),
    for i=1:length(x0),
        t(i,j)=mbox(x0(i),y0(j),z0(i,j),x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta);
    end
end
