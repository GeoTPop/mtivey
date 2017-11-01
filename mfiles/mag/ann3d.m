function a3d=ann3d(f3d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdec,sdip);
% ANN3D Calculate magnetic annihilator using Parker and Huestis
%  inversion approach. If thickness is an array then use 
%  variable thickness routines
% Usage: a3d=ann3d(f3d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdec,sdip);
%     or a3d=ann3d(f3d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,dy);
%
% Magnetic annihilator is the magnetization that produces no 
% external magnetic field.  Note that setting the magnetic field
% to zero only returns the trivial solution ann=0.
% For a more interesting solution put in a known magnetization
% e.g. mag=1 and then compute the field, perform the inversion
% and obtain the annihilator as the difference between the known
% mag (i.e. 1) and inversion result.
% Can test this model by computing the field which should be zero
%
% Input arrays:
%    f3d 	magnetic field (nT)
%    h 		bathymetry (km +ve up)
%    ws,wl	short,long wavelength cutoff (km)
%    rlat,rlon 	latitude,longitude of survey area dec. deg.
%    yr 	year of survey (dec. year)
%    slin 	azimuth of lineations (deg)
%    zobs 	observation level (+km up)
%    thick 	thickness of source layer (km)
%    slin	azimuth of grid (degrees) hard wired to 0
%    dx,dy 	x and y grid spacing  (km)
%    sdec,sdip	optional declination,inclination of magnetization
% Output array:
%    a3d	annihilator (A/m)
%
% Maurice A. Tivey  MATLAB August 3 1998
%-----------------------------------------------------------

format compact
[ny,nx]=size(f3d);
mag1=ones(size(f3d));
if nargin < 13 % geocentric dipole case
  f1=syn3d(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx,dy);
  ann1=inv3d(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,dy);
else % user defined directions sdip sdec
  f1=syn3d(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdec,sdip);
  ann1=inv3d(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdec,sdip);
end
a3d=mag1-ann1;
a3d=real(a3d);
a3d=a3d(1:ny,1:nx);
amax=max(max(a3d));
amin=min(min(a3d));
[i,j]=find(a3d==amax);
fprintf('Max value at %d %d is %f\n',i,j,amax);
[i,j]=find(a3d==amin);
fprintf('Min value at %d %d is %f\n',i,j,amin);
% plot
clf
if version>5
  contourf(a3d);
else
  contour(a3d);
end
title('Annihilator')
