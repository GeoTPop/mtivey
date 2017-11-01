function m2d=inv2d(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% INV2D 
%
% Calculate magnetization from magnetic field and 
% bathymetry for a constant thickness source layer
% Use the Parker & Huestis [1974] Fourier
% inversion approach.
% 
% Usage: m2d=inv2d(f2d,h,wl,ws,rlat,
%                      rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% or for geocentric dipole
%      m2d=inv2d(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
%
% Parameters
%       f2d : magnetic field array (nT)
%         h : bathymetry array (km +ve up)
%        wl : long wavelength cutoff (km)
%        ws : short wavelength cutoff (km)
% rlat rlon : regional lat and long for igrf (decimal degrees)
%             if rlat is 90 then calculate reduced to pole anomaly
%        yr : decimal year of survey for igrf calculation
%             NOTE: make yr negative for no plotting
%      zobs : observation level relative to sea level (km +ve up)
%     thick : thickness in km
%      slin : angle of lineations + cw from north
%        dx : data spacing in km
%      sdec : magnetization declination +ve cw N (optional)
%      sdip : magnetization inclination +ve down (optional)
% Output:
%       m2d : magnetization (A/m)
% NOTES
% 1) Set rlat=90 for zero phase shift
% 2) x distance is positive to right (east) or (north)
%
% Maurice A. Tivey  MATLAB August 27 1992
%                          March  14 1994
%                           May      1996 (new igrf)
% calls nskew magfd ispow2
%-----------------------------------------------------------
format compact
if nargin < 1
 help inv2d
 return
end
%
if nargin > 11, % user defined sdip sdec
 pflag=1;
else            % geocentric dipole hypothesis assumed
 pflag=0;
end  
% parameters defined
	rad=pi/180;  % conversion radians to degrees
	mu=100;      % conversion factor to nT
	nterms=20;
	nitrs=20;
	tol=0.001;
	tolmag=0.001;
	flag=0;
	xmin=0;
fprintf('     2D PROFILE MAGNETIC INVERSE MODEL\n');
fprintf('                  INV2D\n');
fprintf('        Constant thickness layer\n');

fprintf(' Zobs= %12.5f\n Rlat= %12.5f Rlon= %12.5f\n',zobs,rlat,rlon);,
fprintf(' Yr= %12.5f\n',yr);
fprintf(' Thick= %12.5f\n',thick);
fprintf(' Slin = %12.6f\n',slin);
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);

nn=length(f2d);
% print out the input files header
 if length(h) ~= nn, 
  fprintf(' bathy and field arrays must e of the same length\n');
  break; 
 end
 fprintf(' %6.0f points read in for input field and bathy\n',nn);
 fprintf(' DX,XMIN=   %10.3f  %10.3f\n',dx,xmin);
% remove mean from input field
 mnf2d=mean(f2d);
 fprintf('Remove mean of %10.3f from field \n',mnf2d);
 f2d=f2d-mnf2d;
%
% apply a border if needed
 nold=nn;
 flag=ispow2(h);
 if flag~=1 
  fprintf('Apply a border to the input data\n');
  n2=nextpow2(nn+1);
  n2=2^n2;
  fprintf(' From %7d to %8d \n',nold,n2);
  h=border(h,n2);
  f2d=border(f2d,n2);
  nn=n2;
 end
% get unit vectors
 colat=90.-rlat;
 y=magfd(yr,1,zobs,colat,rlon);
% compute skewness parameter
if rlat==90,
 theta=0
 ampfac=1
else
 if pflag==1,  % user defined sdip sdec
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin,sdec,sdip);
 else             % geocentric dipole hypothesis assumed
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin);
 end
end  
%
 const=2*pi*ampfac*mu;
% shift zero level of bathy
 hmax=max(h);
 hmin=min(h);
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BATHY\n',hmin,hmax);
 shift=max(h);
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

nn2=nn/2;
n2plus=nn2+1;
x=(1:nn)*dx-dx;
dk=2*pi/(nn*dx);

% make wave number array
 k=1:n2plus;
 k=(k-1).*dk;
 K=k;
 K(n2plus+1:nn)=k(nn2:-1:2);
% set up bandpass filter
 wts0=bandpass(nn,dx,wl,ws);
 wts=fftshift(wts0);
% do eterm
 dexpz=exp(K*zup);
 dexpw=exp(-K*(hwiggl));
% do thickness term
 alap=(1-exp(-K.*thick));
% phase term 
 phase=exp(i*theta*rad.*sign(nn2-(1:nn)));
% take fft of observed magnetic field and initial m2d
 m2d=zeros(nn,1); % make an initial guess of 0 for m2d
 sum1=fft(m2d);
 F=fft(f2d);
% now do summing over nterms
 intsum=0;
 mlast=zeros(nn,1);
  lastm2d=zeros(1,nn);
  B=(F.*dexpz')./(const.*alap.*phase)';
%  B(1)=0;
fprintf(' CONVERGENCE :\n');
fprintf(' ITER  MAX_PERTURB  #_TERMS  AVG         RMS\n');

for iter=1:nitrs,
% fprintf('ST ITERATION #%6.0f\n',iter);
% summation loop
  sum=zeros(nn,1);
  for nkount=1:nterms,
     n=nkount-1;
%    n=nkount;
    MH=fft(m2d.*(h).^n);
    dsum=dexpw'.*((K.^n)./nfac(n))'.*MH;
    sum=dsum+sum;
    errmax=max( abs(real(sum)+imag(sum)) );
%    if n==0, 
%     first=errmax+1e-10;
%    elseif errmax/first < tol,
%     break,
%    end
  end
% transform to get new solution
%   M=(B-sum);
  M=(B-sum)+mlast;
% filter before transforming to ensure no blow ups
  M(1)=0;
  mlast=M.*wts';
  m2d=ifft(mlast);
%  m2d=real(m2d);
% do convergence test
  errmax=0;
  s1=0;
  s2=0;
  for i=1:nn,
   dif=abs(lastm2d(i)-m2d(i));
   s1=s1+dif;
   s2=s2+dif.*dif;
   if errmax-dif < 0,
    errmax=dif;
   end
   lastm2d(i)=m2d(i);
  end
  avg=s1/nn;
  rms=sqrt(s2/nn - avg^2);
  erpast=errmax;
  if errmax > erpast,
   flag=1;  % set the flag to show diverging solution
   break
  end
 % test for errmax less than tolerance
  if iter==1, first1=errmax+1e-10; end
  if errmax/first1 < tolmag,
   flag=0;
   break
  end
 fprintf('%3.0f, %10.4e, %6.0f',iter,errmax,nkount);
 fprintf(' %10.4e,%10.4e\n',avg,rms);
end  % end of iteration loop

if flag == 1, 
  disp(' I would be quitting now error < tolerance ');
else
  fprintf(' RESTORE ORIGINAL ZERO LEVEL\n');
  fprintf(' SHIFT ZERO LEVEL OF BATHY BY %8.3f\n',shift);
  h=h+shift-hwiggl;
end
%
clf
m2d=real(m2d(1:nold));
h=h(1:nold);
subplot(211)
plot(m2d),title('Calculated Magnetization')
ylabel('Magnetization (A/m)')
subplot(212)
plot(h),title('Bathymetry')
ylabel('Depth (km)')

