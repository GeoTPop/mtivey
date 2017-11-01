function out=dinv2d(fld,fdp,bth,wl,ws,rlat,rlon,yr,thick,slin,dx,sdec,sdip)
% DINV2D  
%  Direct inversion from uneven fish track
%  using the approximate equivalence approach of
%  Hussenoeder, Tivey and Schouten, GRL, 1995.
%  This routine only implements the direct inversion
%  part and does not include the correction part.
%  See directinv.m for full implementation
%
% Usage: out=dinv2d(fld,fdp,bth,wl,ws,rlat,rlon,yr,...
%            thick,slin,dx,sdec,sdip);
%
% Parameters
%       fld : magnetic field array (nT)
%       fdp : fish depth (km +ve up)
%       bth : bathymetry array (km +ve up)
%        wl : long wavelength cutoff (km)
%        ws : short wavelength cutoff (km)
% rlat rlon : regional lat and long for igrf (decimal degrees)
%        yr : decimal year of survey for igrf calculation
%      zobs : observation level relative to sea level +ve up
%     thick : thickness in km
%      slin : angle of lineations +ve cw from north
%        dx : data spacing in km
%      sdec : magnetization declination +ve cw N (optional)
%      sdip : magnetization inclination +ve down (optional)
% Output array
%   out=[magnetization,recomputed field,annihilator];
%
% NOTES
% 1) x distance is positive to right (east) or (north)
% 2) Calculate recomputed field and annihilator only if yr is -ve
%
% see also AE GUSPI INV2D PH SYN2D
%
% Maurice A. Tivey	July 1993
%           mods       April 1996
% Matlab V.4.0

if nargin < 1
 help dinv2d
 return
end

% Fixed Parameters
 i=sqrt(-1);
 flag=0;
 xmin=0;
 rad=pi/180;
 mu=100;
% variable parameters, change to suit
 nterms=20;
 nitrs=20;
 tol=0.1;
 tolmag=0.1;
 pflag=0;
%

fprintf('               DINV2D\n');
fprintf(' Direct Inversion using Approximate Equivalence\n');
fprintf('     Maurice A. Tivey   July 1993\n\n');

% check length and size of arrays
f2d=fld;
[nx,ny]=size(f2d);
% if nx > 1, f2d=f2d'; end
[nx,ny]=size(fdp);
% if nx > 1, fdp=fdp'; end
[nx,ny]=size(bth);
% if nx > 1, bth=bth'; end
if size(bth)~=size(fdp),
 fprintf('fdp and bth not the same size\n'); 
 break;
end

% Do approximate equivalence
% convert bathy and fish depth to altitude and pseudo bathy
 fdp=fdp-bth;
% remove mean from field
 mnf2d=mean(f2d);
 fprintf(' Removing a mean of %10.1f from input field\n',mnf2d);
 f2d=f2d-mean(f2d);

% border input arrays if necessary
 if ispow2(f2d)==0,
  fprintf('Bordering arrays ...\n')
  f2d=border(f2d);
  fdp=border(fdp);
 end
 nn=length(f2d);
 out=zeros(nn,3);
% shift zero level of bathy
 h=fdp;
 h=-h;
 zobs=0;
% Now do inversion
 fprintf('Do inversion ...\n');

if nargin < 13,  % do geocentric dipole case

 m2d=inv2d(f2d,h,wl,ws,rlat,rlon,abs(yr),zobs,thick,slin,dx);
 m2d=real(m2d);
 out(:,1)=m2d;
 if yr < 0,  % flag for recomputing field and ann.
  fprintf('Recompute field: \n')
  fr2d=syn2d(m2d,h,rlat,rlon,abs(yr),zobs,thick,slin,dx);
  fr2d=real(fr2d);
  fprintf('Calculate annihilator:\n');
  mag1=ones(size(m2d));
  f1=syn2d(mag1,h,rlat,rlon,abs(yr),zobs,thick,slin,dx);
  ann1=inv2d(f1,h,wl,ws,rlat,rlon,abs(yr),zobs,thick,slin,dx);
  ann=mag1-ann1;
  ann=real(ann);
  out(:,2)=fr2d;
  out(:,3)=ann;
 end

else  % user defined vectors

 m2d=inv2d(f2d,h,wl,ws,rlat,rlon,abs(yr),zobs,thick,slin,dx,sdec,sdip);
 m2d=real(m2d);
 out(:,1)=m2d;
 if yr < 0,  % flag for recomputing field and ann.
  fprintf('Recompute field: \n')
  fr2d=syn2d(m2d,h,rlat,rlon,abs(yr),zobs,thick,slin,dx,sdec,sdip);
  fr2d=real(fr2d);
  fprintf('Calculate annihilator:\n');
  mag1=ones(size(m2d));
  f1=syn2d(mag1,h,rlat,rlon,abs(yr),zobs,thick,slin,dx,sdec,sdip);
  ann1=inv2d(f1,h,wl,ws,rlat,rlon,abs(yr),zobs,thick,slin,dx,sdec,sdip);
  ann=mag1-ann1;
  ann=real(ann);
  out(:,2)=fr2d;
  out(:,3)=ann;
end

end
%
% plotting
clg
if pflag==1,    
 nn=length(fld);
 x=(0:nn-1).*dx;
 subplot(211)
 plot(x,fld-mean(fld));
 hold on
 plot(x,out(1:nn,2),'r--')
 ylabel('Magnetic Field nT')
 title('Observed (yellow) vs recomputed (red)')
 hold off
subplot(212)
 plot(x,out(1:nn,1));
 hold on
 plot(x,out(1:nn,3),'r')
 hold off
 xlabel('Distance km')
 ylabel('Magnetization A/m')
 fprintf('for solution red=annihilator, yellow=magnetization\n')
end
fprintf('Output array [mag,ann,recomp]\n')
%
