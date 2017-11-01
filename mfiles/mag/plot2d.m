function plot2d(f2d,m2d,b2d,dx);
% PLOT2D - Plot magnetization field and bathymetry
%
% Usage: plot2d(f2d,m2d,b2d,dx);
%
npts=length(f2d);
% make x array
x=0:npts-1;
x=x.*dx;
clf
subplot(311)
plot(x,f2d);
grid on
ylabel('Magnetic Field (nT)')
subplot(312)
plot(x,m2d);
grid on
ylabel('Magnetization (A/m)')
subplot(313);
plot(x,b2d);
ylabel('Bathymetry (km)')
xlabel('Distance (km)')
grid on
