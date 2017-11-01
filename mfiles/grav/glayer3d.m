function g=glayer3d(rho,dx,dy,z1,z2);
% glayer3d
% Compute vertical gravitational attraction
% of a two-dimensional grid of varying density
% confined to a plane layer.
% rho is density kg/m3
% dx,dy data spacing in north/east direction
% z1,z2 top and bottom of layer
% z +ve down, x is north, y is east
% observation level is assumed to be zero
%
% Loosely based on Blakely, 1995
% Maurice A. Tivey June 2014
% <kval3d>
if nargin < 1
 fprintf('DEMO glayer3d')
 help glayer3d
 x0=-10:.25:10;
 y0=-10:.25:10;
 [X,Y]=meshgrid(x0,y0);
 %rho=rand(size(X)).*800; % a more interesting model
 rho=zeros(size(X));
 rho(38:44,38:44)=rho(38:44,38:44)+2670;
 z1=0.5;z2=1;
 dx=0.25;dy=0.25;
 z1=0.5;z2=1;
 g=glayer3d(rho,dx,dy,z1,z2);
 clf
 subplot(211)
 surf(x0,y0,g);shading interp; camlight; lighting phong
 xlabel('X-Axis Distance(km)');ylabel('Y-Axis Distance(km)')
 zlabel('Gravity (mgals)')
 title('DEMO glayer3d : Gravity over a plane layer')
 subplot(212)
 x1=-0.75;x2=0.75;y1=-0.75;y2=0.75;
 fill([x1,x1,x2,x2],[y1,y2,y2,y1],'r');axis([-10 10 -10 10 -1 1]);
 xlabel('X-Axis Distance (km)');ylabel('Y-Axis Distance (km)');zlabel('Depth (km)');
 figure
 subplot(211)
 plot(x0,g(:,41))
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO glayer3d : Extracted profile over a vertical prism')
 subplot(212)
 plot(x0,zeros(size(x0))); hold on;fill([x0(38),x0(44),x0(44),x0(38)],[-z1,-z1,-z2,-z2],'r');
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 axis([-10 10 -1 0])
 max(max(g))
 return
end

bigG=6.67e-11;
si2mg=1e5;
km2m=1000;

[nx,ny]=size(rho);
% Note Blakely has nx as NS, ny as EW

% Fourier transform density
F=fft2(rho);
% calculate earth filter
k=kval3d(ny,nx,dy,dx);
gearth=2*pi*bigG*(exp(-k.*z1)-exp(-k.*z2))./k;
%i0=find(k==0);
%gearth(i0)=2*pi*bigG*(z2-z1);

% inverse transform the product of density
% and earth filter
g=ifft2(gearth.*F)*si2mg*km2m;
g=real(g);