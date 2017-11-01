function a2d=ann2d(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip)
% ANN2D Calculate magnetic annihilator using Parker and Huestis
% inversion approach. If thickness is an array then use variable 
% thickness routines
%
% Usage: a2d=ann2d(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
%     or a2d=ann2d(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% where 
% a2d : output annihilator magnetization in A/m
% f2d : observed magnetic field (nT)
% h : bathymetry (km +ve up)
% wl,ws : long,short wavelength bandpass cutoff frequency (km)
% rlat,rlon : regional latitude/longitude of profile (decimal degrees)
% yr : year of survey (decimal years)
% zobs : observation level (km)
% thick : thickness of source layer (km)
% slin : strike of lineations perp. to profile (azimuth degrees)
% dx : data spacing (km)
% sdec,sdip : optional declination,inclination of magnetization
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
% Maurice A. Tivey 1996

nn=length(f2d);
mag1=ones(nn,1);
if nargin < 13  % geocentric dipole case
% 
 if length(thick) > 1  
  disp('Use variable thickness layer case') 
  f1=syn2da(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx);
  ann1=inv2da(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
 else
  f1=syn2d(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx);
  ann1=inv2d(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
 end
else  % user defined case
 if length(thick) > 1   
  f1=syn2da(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
  ann1=inv2da(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
 else
  f1=syn2d(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
  ann1=inv2d(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
 end
end
a2d=mag1-ann1;
a2d=real(a2d);
a2d=a2d(1:nn);
%
clf
subplot(211)
plot(a2d),title('Magnetic Annihilator')
ylabel('Magnetization (A/m)')
return
