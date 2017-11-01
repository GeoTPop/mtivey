function [gold,up]=guspi3d(f3d,fdp,dx,dy,wl,ws,zlev)
% GUSPI3D Frequency domain reduction of potential fields
% to a horizontal plane.  Upward continuation using an 
% iterative fast fourier transform to reduce magnetic 
% measurements made on an uneven surface to a level plane
% Guspi, F., Geoexploration, 24, 87-98, 1987.
%
% Usage:
%   [gold,up]=guspi3d(f3d,fdp,dx,dy,wl,ws,zlev);
% where
% f3d : input field grid (nT)
% fdp : input observation plane grid (km +up)
% dx,dy  : input data spacing (km)
% wl,ws : long,short wavelength cutoff set to 0 for default (km)
% zlev : desired upward continuation level (km)
% gold : output field at guspi reduction level zref (nT(
% up : output upward continued field at desired zlev (nT)
%
% Maurice A. Tivey Oct. 1995 MATLAB V4
% MAT March 1996

disp(' GUSPI3D')
disp(' frequency domain reduction of potential fields');
disp(' to a horizontal plane.   ');
disp(' ');
% define parameters
 i=sqrt(-1);
 tol=1.00;
 gtol=1.00;
 nterms=20;
 nitrs=30;
[ny,nx]=size(f3d);
% border grids - assume input grids are bordered

% calculate wavenumber array
 nx2=nx/2;
 nx2plus=nx2+1;
 ny2=ny/2;
 ny2plus=ny2+1;
 dkx=pi/(nx*dx);
 dky=pi/(ny*dy);
 kx=(-nx2:nx2-1).*dkx;
 ky=(-ny2:ny2-1).*dky;
  X=ones(size(ky))'*kx;
  Y=ky'*ones(size(kx));
  k= 2*sqrt(X.^2+Y.^2);  % wavenumber array
  k=fftshift(k);

% Determine reference plane
% Version-1 place ref plane as halfway between max and min
% Note: Guspi defines z +ve down
% determine max min of observation level
 zmax=max(max( fdp ));
 zmin=min(min( fdp ));
 fprintf('zmin,zmax : %10.3f %10.3f\n',zmin,zmax);
%
 hwiggl=(zmax-zmin)/2;
 fprintf('Choice of reference levels:\n');
 fprintf(' %8.3f halfway level\n',zmin+hwiggl);
 fprintf(' %8.3f minimum level\n',zmin);
 fprintf(' %8.3f mean level\n',mean(fdp(1:nx)));
 fprintf(' %8.3f median level\n',median(fdp(1:nx)));
 fprintf(' Note that convergence is ALWAYS achieved at min level\n');
 fprintf(' so that min level is HARD WIRED in this version\n');
% zref=input('Enter reference level ->');
 zref=zmin;
%
% zref=zmin+hwiggl/2;
 fprintf('Reference level %10.3f set to zero\n',zref);
% set z to height above the reference level
 h=fdp-zref;
% remove mean from field 
 mnf3d=mean(mean(f3d));
 f3d=f3d-mnf3d;
 fprintf(' Remove mean of %12.3f from input field\n',mnf3d);
% bandpass filter
 fprintf('bandpass filter for stability:\n');
 if ws==0, ws=max(max(abs(h))); end;
 fprintf(' INPUT BANDPASS parameters wlong,wshort = %8.3f %8.3f\n',wl,ws);
% set up bandpass filter
 wts0=bpass3d(nx,ny,dx,dy,wl,ws);
% setup initial guess
 gold=f3d;
%
% iteration loop
 for iter=1:nitrs,
  Gab=fft2(gold);
% summation loop
  gsum=zeros(size(f3d));
  for n=1:nterms,
   g=(((-h).^n)./nfac(n)).*(ifft2( ((abs(k)).^n).*(Gab.*wts0) ));
   gsum=g+gsum;  % sum the terms
   fprintf('nterms, max(g): %5.0f %10.3f\n',n,max(max(real(g))));
   if max(max(real(g))) < gtol, break, end
  end
%
  gnew=f3d-real(gsum);  % calculate new field
% now evaluate convergence of iteration
  err=rmsdif3d(gnew,gold);
  conv(iter)=err(1); %avg
  fprintf('iter %2.0f, nterms %2.0f, avg= %8.3f, rms= %8.3f\n',iter,n,err(1),err(2));
  if iter == 1,
   gold=gnew; % do nothing and loop around
  elseif conv(iter) < tol, 
   fprintf(' convergence less than tolerance ...\n');
   break;
  elseif conv(iter)/conv(1) >1
   fprintf(' iteration diverging ...')
   break
  else
   gold=gnew;
  end
 end   % end of iteration loop
fprintf(' Guspi reduction plane level %10.3f\n',zref);
fprintf(' Finished Guspi ... now do upward continuation\n');
disp(' Note: output guspi level array is gold')
clf
subplot(211),contour(gold,'w'),title('Guspi field vs Observed')
hold on
contour(f3d,'r')
hold off
subplot(212),contour(fdp),title('fdep')
fprintf('Upward continue to %12.3f km level\n',zlev);
up=upcon3d(gold,dx,dy,zlev-zref);
disp('Finished upcon');
