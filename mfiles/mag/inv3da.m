function m3d=inv3da(f3d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdec,sdip)
% INV3D Calculate magnetization from magnetic field and bathymetry for a map.  
% Assumes a VARIABLE thickness source layer whose upper bound is
% bathymetry. Use the Parker & Huestis [1974] Fourier inversion approach.  
%
% Usage: m3d=inv3da(f3d,h,wl,ws,rlat,
%                      rlon,yr,zobs,thick,azim,dx,dy,sdec,sdip);
%   or for geocentric dipole
%     m3d=inv3da(f3d,h,wl,ws,rlat,rlon,yr,zobs,thick,azim,dx,dy);
%
% Input arrays:
%    f3d 	magnetic field (nT)
%    h 		bathymetry (km +ve up)
%    wl		filter long wavelength cutoff (km)
%    ws		filter short wavelength cutoff (km)
%    rlat 	latitude of survey area dec. deg.
%    rlon 	longitude of survey area dec. deg.
%    yr 	year of survey (dec. year)
%    slin 	azimuth of lineations (deg)
%    zobs 	observation level (+km up)
%    thick 	thickness array of source layer (km)
%    azim	azimuth of grid (degrees) hard wired to 0
%    dx 	x grid spacing  (km)
%    dy 	y grid spacing  (km)
%    sdec	declination of magnetization (optional)
%    sdip	inclination of magnetization (optional)
% Output array:
%    m3d	magnetization (A/m)
%
% 27 Aug 1992 Maurice A. Tivey MATLAB
%  5 May 1995 MAT 
%    Mar 1996 MAT
%    Jan 2000 MAT fixed problems
% Jan 2007 MAT fixed compatibility with MATLAB R14
% calls <syn3d,magfd,nskew,bpass3d>


format compact
if nargin < 1
 fprintf('\nDEMO OF INV3DA mfile\n');
 help inv3da
 fprintf('FIRST GENERATE A PRISM AT DEPTH\n');
 m=ones(32,32).*10;  m(16:20,16:20)=m(16:20,16:20)+20;
 fprintf('SET PARAMETERS FOR CALCULATING THE FIELD\n');
 fprintf('ASSUME TOPOGRAPHY IS FLAT\n');
 h=ones(32,32).*(-2);
 thk=peaks(32);thk=thk-min(min(thk));
 thk=thk./max(max(thk))+0.1;
 dx=1; dy=1;
 rlat=26;rlon=-45;yr=1990;slin=0;zobs=0;
 f3d=syn3da(m,h,rlat,rlon,yr,zobs,thk,slin,dx,dy);
 fprintf('NOW DO INVERSION.....\n')
 wl=0;
 ws=0;
 m3d=inv3da(f3d,h,wl,ws,rlat,rlon,yr,zobs,thk,slin,dx,dy);
 subplot(224)
 contourf(m),title('Input Magnetization')
 return
end

if nargin > 12, % user defined sdip sdec
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
	nterms=40;
	nitrs=40;
	tol=0.01;
	tolmag=0.01;
	flag=0;
	xmin=0;
%
fprintf('       3D MAGNETIC INVERSE MODEL\n');
fprintf('                  INV3DA\n');
fprintf('        Variable thickness layer\n');

fprintf(' Zobs= %12.5f\n Rlat= %12.5f Rlon= %12.5f\n',zobs,rlat,rlon);,
fprintf(' Yr= %12.5f\n',yr);
fprintf(' Variable thickness\n');
fprintf(' Slin = %12.6f\n',slin);
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);

[ny,nx]=size(f3d);
% print out the input files header
 if size(h) ~= size(f3d), 
  fprintf(' bathy and field arrays must be of the same length\n');
  return; 
 end
 fprintf(' READ %6.0f X %6.0f matrix by columns \n',nx,ny);
 fprintf(' DX,DY= %10.3f %10.3f XMIN,YMIN= %10.3f  %10.3f\n',dx,dy,xmin,xmin);
% remove mean from input field
 mnf3d=mean(mean(f3d));
 fprintf('Remove mean of %10.3f from field \n',mnf3d);
 f3d=f3d-mnf3d;
%
 colat=90.-rlat;
 y=magfd(yr,1,zobs,colat,rlon);

% compute phase and amplitude factors from 2D method
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
 sdip=atan2( 2.*sin(rlat*rad),cos(rlat*rad) )/rad;
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

% make wave number array
% ni=1/nx;
 nx2=nx/2;
 nx2plus=nx2+1;
% x=-.5:ni:.5-ni;
% ni=1/ny;
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
%
%------ calculate geometric and amplitude factors
 Ob=(sin(ra1)+i*cos(ra1)*sin(atan2(Y,X)+rb1));
 Om=(sin(ra2)+i*cos(ra2)*sin(atan2(Y,X)+rb2));
 O=Ob.*Om;
 O=fftshift(O);
 amp=abs(O);   % amplitude factor
 phase=fftshift( exp(i*(angle(Ob)+angle(Om))));   % phase angle 
 const=2*pi*mu;

% calculate base layer
 g=-(abs(h)+thick);
 
% shift zero level of bathy
 hmax=max(max(h));
 hmin=min(min(h));
 gmax=max(max(g));
 gmin=min(min(g)); 
 conv=1;
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BATHY\n',hmin,hmax);
 fprintf('CONVERT BATHY (M OR KM), +DOWN or +UP)\n');
 fprintf('TO BATHY (KM, +UP)\n');
 shift=hmax;
 hwiggl=abs(hmax-gmin)/2;
 zup=zobs-shift;
 fprintf(' SHIFT ZERO OF BATHY WILL BE %8.3f\n',shift);
 fprintf('THIS IS OPTIMUM FOR INVERSION.\n');
 fprintf('NOTE OBSERVATIONS ARE %8.3f KM ABOVE BATHY\n',zup);
 fprintf('ZOBS=%8.3f ZUP=%8.3f\n',zobs,zup);
% zup=zup+hwiggl;     
 fprintf('%8.3f = HWIGGL, DISTANCE TO MID-LINE OF BATHY\n',hwiggl);
 fprintf('THIS IS OPTIMUM ZERO LEVEL FOR FORWARD PROBLEM\n')

% bathy zero placed halfway between extremes
% this is optimum for summation but not for iteration
% which needs zero at highest point of bathy
 h=h-shift+hwiggl;
 g=g-shift+hwiggl;

% set up bandpass filter
 wts=bpass3d(nx,ny,dx,dy,wl,ws);
% do eterm
 dexpz=exp(k.*zup);
 dexpw=exp(-k.*hwiggl);
% take fft of observed magnetic field and initial m3d
 m3d=zeros(ny,nx); % make an initial guess of 0 for m3d
 sum1=fft2(m3d);
 F= (fft2(f3d));
 HG= (h-g);
% now do summing over nterms
 intsum=0;
 mlast=zeros(ny,nx);
 lastm3d=zeros(ny,nx);
 B=(F.*dexpz)./(const.*amp.*phase);
 B(1,1)=0;
%
fprintf(' CONVERGENCE :\n');
fprintf(' ITER  MAX_PERTURB  #_TERMS  AVG ERR  \n');
for iter=1:nitrs,
% summation loop start with n=2
  sum=zeros(ny,nx);
  for nkount=2:nterms,
%    n=nkount-1;
    n=nkount;
    MH=fft2(m3d.*(h.^n-g.^n));
    dsum=dexpw.*((k.^(n-1))./nfac(n)).*MH;
    sum=dsum+sum;
    errmax=max(max( abs(real(sum)+imag(sum)) ));
  end
% transform to get new solution
  M= (B-(sum));
% filter before transforming to ensure no blow ups
  M(1,1)=0;
  mlast=(M./thick).*wts;
  m3d=ifft2(mlast);
% do convergence test
  errmax=0;
  s1=zeros(ny,nx);
  s2=zeros(ny,nx);
   dif=abs(lastm3d-m3d);
   s2=s2+dif.*dif;
   if errmax-max(max(dif)) < 0,
    errmax=max(max(dif));
   end
   lastm3d=m3d;
  
  avg=mean(mean(dif));
%  rms=sqrt(s2/(nx*ny) - avg^2);
  if iter==1, 
    first1=errmax+1e-10; 
    erpast=errmax;
  end
  if errmax > erpast,
   flag=1;  % set the flag to show diverging solution
   break
  end
  erpast=errmax;
 % test for errmax less than tolerance
  if errmax < tolmag,
   flag=0;
   break
  end
 fprintf('%3.0f, %10.4e, %6.0f ',iter,errmax,nkount);
 fprintf(' %10.4e\n',avg);
end  % end of iteration loop

if flag == 1, 
  disp(' I would be quitting now error < tolerance ');
else
  fprintf(' RESTORE ORIGINAL ZERO LEVEL\n');
  fprintf(' SHIFT ZERO LEVEL OF BATHY BY %8.3f\n',shift);
  h=h+shift-hwiggl;
  g=g+shift-hwiggl;
  g=real(g);
end
%
m3d=real(m3d);
clf
subplot(221)
contourf(m3d),title('Calculated Magnetization')
subplot(222)
contourf(f3d),title('Magnetic Field');
subplot(223)
contourf(real(thick)),title('Layer thickness')
 
