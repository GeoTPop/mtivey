function f3d=syn3da(m3d,h,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdip,sdec)
% SYN3DA - Calculate magnetic field given a magnetization and bathymetry 
% map using Parker's [1973] Fourier series summation approach
% Variable thickness model
%
% Input arrays:
%    m3d 	magnetization (A/m)
%    h 		bathymetry (km +ve up)
%    rlat 	latitude of survey area (dec. deg.)
%    rlon 	longitude of survey area (dec. deg.)
%    yr 	year of survey (dec. year)
%    slin 	azimuth of lineations (deg) set to 0
%    zobs 	observation level (+km up)
%    thick 	array of thickness of source layer (km)
%    dx 	x grid spacing  (km) 
%    dy		y grid spacing  (km)
%    sdec	declination of magnetization (optional)
%    sdip	inclination of magnetization (optional)
% Output array:
%    f3d	magnetic field (nT)
%
% Usage: f3d=syn3d(m3d,h,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdip,sdec)
%   or geocentric dipole: 
%        f3d=syn3d(m3d,h,rlat,rlon,yr,zobs,thick,slin,dx,dy);
%
% 5 Aug 1992 Maurice A. Tivey MATLAB Version 5 A 
% Mar 1996 MAT   
% May 1996 MAT new IGRF                                  
% Jan 2000 MAT fixed problems 
% calls <magfd, nskew, nfac>
clf
format compact
if nargin < 1
 fprintf('\n\n  DEMO OF SYN3DA\n\n');
 help syn3da
 fprintf('GENERATE A PRISM AT DEPTH\n');
 m=ones(32,32).*10;  m(16:20,16:20)=m(16:20,16:20)+20;
 fprintf('SET PARAMETERS FOR CALCULATING THE FIELD\n');
 fprintf('ASSUME TOPOGRAPHY IS FLAT\n');
 fprintf('ASSUME THICKNESS IS A CONSTANT 1 km \n');
 h=ones(32,32).*(-2);
 %thk=ones(size(h)).*1;
 thk=peaks(32);thk=thk-min(min(thk));
 thk=thk./max(max(thk));
 dx=1; dy=1;
 rlat=26;rlon=-45;yr=1990;slin=0;zobs=0;
 f3d=syn3da(m,h,rlat,rlon,yr,zobs,thk,slin,dx,dy);
 subplot(222);contourf(f3d);title('Magnetic Field')
 subplot(223);contourf(thk);title('Thickness')
 subplot(221);contourf(m);title('Magnetization')
 return
end

if nargin > 10, % user defined sdip sdec
 pflag=1;
else            % geocentric dipole hypothesis assumed
 sdip=0;
 sdec=0;
 pflag=0;
end  
% parameters defined
 i=sqrt(-1);
 rad=pi/180;  % conversion radians to degrees
 mu=100;      % conversion factor to nT
% changeable parameters 
 nterms=10;
 tol=0.1;
%
fprintf('     3D MAGNETIC FIELD FORWARD MODEL\n');
fprintf('                 SYN3DA\n');
fprintf('       Variable thickness layer\n');
fprintf(' M.A.Tivey      Version: Jan 21, 2000\n');
fprintf(' Zobs= %12.5f\n Rlat= %12.5f Rlon= %12.5f\n',zobs,rlat,rlon);,
fprintf(' Yr= %12.5f\n',yr);
fprintf(' Slin,Sdec,Sdip = %12.6f %12.6f %12.6f\n',slin,sdec,sdip);
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);
[ny,nx]=size(m3d);
fprintf(' Number of points in map are : %6.0f x%6.0f\n',nx,ny);
fprintf(' Spacing of points : %10.4f X %10.4f \n',dx,dy);

 colat=90.-rlat;
 y=magfd(yr,1,zobs,colat,rlon);
% compute skewness parameter
 bx=y(1);
 by=y(2);
 bz=y(3);
 bh=sqrt(bx^2+by^2);
 decl1= atan2(by,bx)/rad;
 incl1= atan2(bz,bh)/rad;
if abs(sdec) > 0. | abs(sdip) > 0.
 [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin,sdec,sdip);
else
 [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin);
 sdip= atan2( 2.*sin(rlat*rad),cos(rlat*rad) )/rad;
 sdec=0;
end
%
 slin=0 % slin is forced to zero
 ra1=incl1*rad;
 rb1=(decl1-slin)*rad;
% rb1=(slin-decl1)*rad;
 ra2=sdip*rad;
 rb2=(sdec-slin)*rad;
% rb2=(slin-sdec)*rad;

% calculate wavenumber array
% ni=1/(nx);
 nx2=nx/2;
 nx2plus=nx2+1;
% x=-.5:ni:.5-ni;
% ni=1/(ny);
 ny2=ny/2;
 ny2plus=ny2+1;
% y=-.5:ni:.5-ni;
%  X=ones(size(y))'*x;
%  Y=y'*ones(size(x));
%  k= 2*pi*sqrt(X.^2+Y.^2);  % wavenumber array
%  k=fftshift(k);
% compute another way
 dkx=pi/(nx*dx);
 dky=pi/(ny*dy);
 kx=(-nx2:nx2-1).*dkx;
 ky=(-ny2:ny2-1).*dky;
  X=ones(size(ky))'*kx;
  Y=ky'*ones(size(kx));
  k= 2*sqrt(X.^2+Y.^2);  % wavenumber array
  k=fftshift(k);
%
i=sqrt(-1);
Ob=(sin(ra1)+i*cos(ra1)*sin(atan2(Y,X)+rb1));
Om=(sin(ra2)+i*cos(ra2)*sin(atan2(Y,X)+rb2));
O=Ob.*Om;
O=fftshift(O);
amp=abs(O);   % amplitude factor
phase=fftshift( exp(i*(angle(Ob)+angle(Om))));   % phase angle 
const=2*pi*mu;

% calculate base layer
 base=h-thick;
% shift zero level of bathy
 hmax=max( max(max(h)),max(max(base)) );
 hmin=min( min(min(h)),min(min(base)) );
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BATHY\n',hmin,hmax);
 shift=max(max(h));
 hwiggl=abs(hmax-hmin)/2;
 zup=zobs-shift;
 fprintf(' SHIFT ZERO OF BATHY WILL BE %8.3f\n',shift);
 fprintf(' THIS IS OPTIMUM FOR INVERSION.\n');
 fprintf(' NOTE OBSERVATIONS ARE %8.3f KM ABOVE BATHY\n',zup);
 fprintf('ZOBS=%8.3f ZUP=%8.3f\n',zobs,zup);
 zup=zup+hwiggl;     
 fprintf('%8.3f = HWIGGL, DISTANCE TO MID-LINE OF BATHY\n',hwiggl);
 fprintf(' THIS IS OPTIMUM ZERO LEVEL FOR FORWARD PROBLEM\n');
 h=h-shift;
 h=h+hwiggl;
 base=base-shift;
 base=base+hwiggl;

% do upcon term
 eterm=exp(-k.*zup); 
% now do summing over nterms
 MH=fft2(m3d);
 msum1=0;%msum1=eterm.*MH;
 last=0;
 first=max(abs(msum1));
 for n=1:nterms,
  MH=fft2(m3d.*(h.^n-base.^n) );
  msum=eterm.*((k.^n)./nfac(n)).*MH+msum1;
  errmax=max(max(abs(real(msum))));
%  errmax=max(max(abs(real(msum)+real(msum1))));
  fprintf(' AT TERM  %6.0f ',n);
  fprintf('MAXIMUM PERTURBATION TO SUM %12.5e\n',errmax-last);
%  fprintf('errmax/first = %12.5e\n',(errmax-last)/first);
%  if (errmax-last)/first < tol, break, end
   last=errmax;
   msum1=msum;
 end
b=const.*msum.*O;
b(1,1)=0;
f3d=real(ifft2(b));
% restore bathy
h=h+shift-hwiggl;
 h=real(h);
base=base+shift-hwiggl;
 base=real(base);
%
% statistics
 max(max(f3d))
 min(min(f3d))

% Plotting
 contour(f3d),title('Calculated Magnetic Field')
hold on
 contour(m3d,1,'k')
hold off

