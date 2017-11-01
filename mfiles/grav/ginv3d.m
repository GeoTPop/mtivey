function d3d=ginv3d(g3d,h,wl,ws,zobs,thick,dx,dy);
% ginv3d
% Invert for density from gravity field   
% and bathymetry assuming a constant thickness
% source layer. Use the Parker & Huestis [1974] Fourier
% inversion approach.  
%
% Usage: d3d=ginv3d(g3d,h,wl,ws,zobs,thick,dx,dy);
% Input arrays:
%    g3d 	gravity field (mgals)
%    h 		bathymetry (km +ve up)
%    wl		filter long wavelength cutoff (km)
%    ws		filter short wavelength cutoff (km)
%    zobs 	observation level (+km up)
%    thick 	thickness of source layer (km)
%    dx 	x grid spacing  (km)
%    dy 	y grid spacing  (km)
% Output array:
%    d3d	density (kg/m3)
%
% Maurice A. Tivey  MATLAB July 2002

if nargin < 1
    g3d=glayer;
    d3d=ginv3d(g3d,ones(size(g3d)).*(-0.5),0,0,0,0.5,0.25,0.25);
    clf;
    surf(d3d);shading interp;camlight right;lighting phong;
    title('DEMO ginv3d : Inverse gravity field for density')
    zlabel('Density (kg/m3)');
  figure(2)
  subplot(211)
   rho=zeros(size(g3d));
   rho(38:44,38:44)=rho(38:44,38:44)+2670;
   contourf(rho(20:60,10:60),10);colorbar;axis equal;title('Input Density')
  subplot(212)
   contourf(d3d(20:60,10:60),10);colorbar;axis equal;title('Calculated Density')
  suptitle('Comparison of two calculation methods')
  return
 end
format compact
% fixed parameters
 i=sqrt(-1);
 rad=pi/180;         % conversion radians to degrees
 bigG=6.67e-11;      % grav constant
 si2mg=1e5;          % SI units to mgals
 km2m=1000;          % km to meters
% changeable parameters
	nterms=20;
	nitrs=20;
	tol=0.0001;
	tolmag=0.0001;
	flag=0;
	xmin=0;
%
fprintf('       3D GRAVITY INVERSE MODEL\n');
fprintf('                  GINV3D\n');
fprintf('        Constant thickness layer\n');
fprintf(' Zobs= %12.5f\n',zobs);,
fprintf(' Thick= %12.5f\n',thick);
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);

[ny,nx]=size(g3d);
% print out the input files header
 if size(h) ~= size(g3d), 
  fprintf('ERROR: bathy and field arrays must be of the same length\n');
  return; 
 end
 fprintf(' READ %6.0f X %6.0f matrix by columns \n',nx,ny);
 fprintf(' DX,DY= %10.3f %10.3f XMIN,YMIN= %10.3f  %10.3f\n',dx,dy,xmin,xmin);
% remove mean from input field
 mng3d=mean(mean(g3d));
 fprintf('Remove mean of %10.3f mgals from field \n',mng3d);
 g3d=g3d-mng3d;
%
% make wave number array
 nx2=nx/2;
 nx2plus=nx2+1;
 ny2=ny/2;
 ny2plus=ny2+1;
%  
 dkx=pi/(nx*dx);
 dky=pi/(ny*dy);
 kx=(-nx2:nx2-1).*dkx;
 ky=(-ny2:ny2-1).*dky;
  X=ones(size(ky))'*kx;
  Y=ky'*ones(size(kx));
  k= 2*sqrt(X.^2+Y.^2);  % wavenumber array
  k=fftshift(k);
%
  const=2*pi*bigG;
% shift zero level of bathy
 hmax=max(max(h));
 hmin=min(min(h));
 conv=1;
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BATHY\n',hmin,hmax);
 fprintf('CONVERT BATHY (M OR KM), +DOWN or +UP)\n');
 fprintf('TO BATHY (KM, +UP)\n');
 hmax=max(max(h));
 hmin=min(min(h));
 shift=hmax;
 hwiggl=abs(hmax-hmin)/2;
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

% set up bandpass filter
wts=bpass3d(nx,ny,dx,dy,wl,ws);
% do eterm
 dexpz=exp(k.*zup);
 dexpw=exp(-k.*hwiggl);
% do thickness term
 alap=(1-exp(-k.*thick));
% take fft of observed gravity field and guess initial d3d
 d3d=zeros(ny,nx); % make an initial guess of 0 for d3d
 sum1=fft2(d3d);
 G= fft2(g3d);
% now do summing over nterms
 intsum=0;
 mlast=zeros(ny,nx);
 lastd3d=zeros(ny,nx);
 B=(G.*dexpz)./(const.*alap);
 B(1,1)=0;
%
fprintf(' CONVERGENCE :\n');
fprintf(' ITER  MAX_PERTURB  #_TERMS  AVG ERR  \n');
for iter=1:nitrs,
% summation loop
  sum=zeros(ny,nx);
  for nkount=1:nterms,
    n=nkount-1;
%    n=nkount;
    MH=(fft2(d3d.*(h).^n));
    dsum=dexpw.*((k.^n)./nfac(n)).*MH;
    sum=dsum+sum;
    errmax=max(max( abs(real(sum)+imag(sum)) ));
  end
% transform to get new solution
  M= (B-(sum))+mlast;
% filter before transforming to ensure no blow ups
  M(1,1)=0;
  mlast=M.*wts;
  d3d=ifft2(mlast);
% do convergence test
  errmax=0;
  s1=zeros(ny,nx);
  s2=zeros(ny,nx);
   dif=abs(lastd3d-d3d);
   s2=s2+dif.*dif;
   if errmax-max(max(dif)) < 0,
    errmax=max(max(dif));
   end
   lastd3d=d3d;
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
end
%
d3d=real(d3d)./(si2mg*km2m);
return
clf
  subplot(211)
   contourf(d3d),title('Calculated Density')
   colorbar
  subplot(212)
   contourf(g3d),title('Gravity Field');
   colorbar
 
