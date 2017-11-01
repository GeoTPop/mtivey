function m2d=inv2da(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% INV2DA Calculate magnetization from magnetic field and bathymetry for
% a variable thickness source layer. Use the Parker & Huestis [1974] Fourier
% inversion approach.
%
% Usage: m2d=inv2da(f2d,h,wl,ws,rlat,
%                      rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% or for geocentric dipole
%      m2d=inv2da(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
%
% Parameters
%       f2d : magnetic field array (nT)
%         h : bathymetry array (km +ve up)
%     wl,ws : long,short wavelength cutoff (km)
% rlat rlon : regional lat and long for igrf (decimal degrees)
%             if rlat is 90 then calculate reduced to pole anomaly
%        yr : decimal year of survey for igrf calculation
%             NOTE: make yr negative for no plotting
%      zobs : observation level relative to sea level (km +ve up)
%     thick : thickness array in km
%      slin : angle of lineations + cw from north
%        dx : data spacing in km
% sdec,sdip : optional magnetization declination,inclination
% Output:
%       m2d : magnetization (A/m)
% NOTES
% 1) Set rlat=90 for zero phase shift ie reduced to pole profiles
% 2) x distance is positive to right (east) or (north)
% 3) profile is west to east or north to south, left to right 
%    for first element to last element of array
%
% Maurice A. Tivey  MATLAB February 12, 1993
%                   Nov 8 1994
%                   Sep 24 1997
% Mar 08 2006 Fixed for Matlab V7 (R14)
% calls <border nskew magfd ispow2 syn2d>
format compact
if nargin < 1
 % demo
 help inv2da
 if exist('synf2d.tst')==2, % do demo if files exist
    f2d=inv2mat('synf2d.tst');
    h=inv2mat('synb2d.tst');
    mag=inv2mat('synm2d.tst');
    thk=ones(size(h)).*0.5;
    rlon=-130;rlat=45;
    yr=1990;zobs=0;wl=0;ws=2.0;slin=20;dx=0.05;
    m2d=inv2da(f2d,h,wl,ws,rlat,rlon,yr,zobs,thk,slin,dx);
 end
 return
elseif nargin > 11, % user defined sdip sdec
 pflag=1;
else            % geocentric dipole hypothesis assumed
 pflag=0;
end
% parameters defined
        rad=pi/180;  % conversion radians to degrees
        mu=100;      % conversion factor to nT
        nterms=20;
        nitrs=10;
        tol=0.01;
        tolmag=0.01;
        flag=0;
        xmin=0;
fprintf('     2D PROFILE MAGNETIC INVERSE MODEL\n');
fprintf('                  INV2DA\n');
fprintf('        Variable thickness layer\n');
fprintf(' Maurice A. Tivey\n');
fprintf('        Sept 22, 1997\n\n');
fprintf(' Zobs= %12.5f\n Rlat= %12.5f Rlon= %12.5f\n',zobs,rlat,rlon);,
fprintf(' Yr= %12.5f\n',yr);
fprintf(' Slin = %12.6f\n',slin);
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);

nn=length(f2d);
% print out the input files header
 if length(h) ~= nn, 
  fprintf(' bathy and field arrays must be of the same length\n');
  return;
 end
 fprintf(' %6.0f points read in for input field and bathy\n',nn);
 fprintf(' DX,XMIN=   %10.3f  %10.3f\n',dx,xmin);
% remove mean from input field
 mnf2d=mean(f2d);
 fprintf('Remove mean of %10.3f from field \n',mnf2d);
 f2d=f2d-mnf2d;
% get unit vectors
 colat=90.-rlat;
 y=magfd(yr,1,zobs,colat,rlon);
% compute skewness parameter
if rlat==90, % if no phase shift desired
 disp('No phase shift requested')
 theta=0
 ampfac=1
else
 if pflag==1,  % user defined sdip sdec
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin,sdec,sdip);
 else             % geocentric dipole hypothesis assumed
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin);
 end
end
 const=2*pi*ampfac*mu;
% calculate base layer
 g=-(abs(h)+thick);
% shift zero level of bathy
 hmax=max(h);
 hmin=min(h);
 gmax=max(g);
 gmin=min(g);
 dmax=max(max(h),max(g));
 dmin=min(min(h),min(g));
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BATHY\n',hmin,hmax);
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BASE\n',gmin,gmax);
 shift=max(h);
 hwiggl= abs(dmax-dmin)/2;
 zup=zobs-shift;
 fprintf(' SHIFT ZERO OF BATHY WILL BE %8.3f\n',shift);
 fprintf('THIS IS OPTIMUM FOR INVERSION.\n');
 fprintf('NOTE OBSERVATIONS ARE %8.3f KM ABOVE BATHY\n',zup);
 fprintf('ZOBS=%8.3f ZUP=%8.3f\n',zobs,zup);
 fprintf('%8.3f = HWIGGL, DISTANCE TO MID-LINE OF BATHY\n',hwiggl);
 fprintf('THIS IS OPTIMUM ZERO LEVEL FOR FORWARD PROBLEM\n')

% bathy zero placed halfway between extremes
% this is optimum for summation but not for iteration
% which needs zero at highest point of bathy
 h=h-shift+hwiggl;
 g=g-shift+hwiggl;

% make wave number array
 nn2=nn/2;
 n2plus=nn2+1;
 x=(1:nn)*dx-dx;
 dk=2*pi/(nn*dx);
 k=1:n2plus;
 k=(k-1).*dk;
 K=k;
 K(n2plus+1:nn)=k(nn2:-1:2);
% set up bandpass filter
 wts0=bandpass(nn,dx,wl,ws);
 wts=fftshift(wts0);
% do eterm
 dexpz=exp(K*zup);
 dexpw=exp(-K*hwiggl);
% phase term 
 phase=exp(i*theta*rad.*sign(nn2-(1:nn)));
% take fft of observed magnetic field and initial m2d
 m2d=zeros(nn,1); % make an initial guess of 0 for m2d
 F=fft(f2d);
 HG=fft(thick);
% now do summing over nterms
  mlast=zeros(nn,1);
  lastm2d=zeros(nn,1);
  B=(F.*dexpz')./(const.*phase.*K)';
  B(1)=0;
fprintf(' CONVERGENCE :\n');
fprintf(' ITER  MAX_PERTURB  #_TERMS  AVG         RMS\n');

for iter=1:nitrs,
% fprintf('ST ITERATION #%6.0f\n',iter);
% summation loop  n=2 to nterms
  sum=zeros(nn,1);
  for n=2:nterms,
    MH=fft( m2d .* (h.^n-g.^n) );
    dsum=(dexpw'.*((K.^(n-1))./nfac(n))'.*MH).*wts';
    sum=dsum+sum;
    errmax=max( abs(real(sum)+imag(sum)) );
%    if n==2, 
%     first=errmax+1e-10;
%    elseif errmax/first < tol,
%     break,
%    end
  end
  plot(real(sum)); drawnow
% transform to get new solution
  M=(B-sum) + mlast;
% filter before transforming to ensure no blow ups
  M(1)=0;
  mlast=M.*wts';
  m2d=ifft(mlast)./thick;
  m2d=ifft(fft(m2d).*wts');
%  m2d=real(m2d);
% do convergence test
  errmax=0;
  s1=0;
  s2=0;
  for j=1:nn,
   dif=abs(lastm2d(j)-m2d(j));
   s1=s1+dif;
   s2=s2+dif.*dif;
   if errmax-dif < 0,
    errmax=dif;
   end
   lastm2d(j)=m2d(j);
  end
  avg=s1/nn;
  rms=sqrt(s2/nn - avg^2);
  erpast=errmax;
  if errmax > erpast,
   flag=1;  % set the flag to show diverging solution
%  return
  end
 % test for errmax less than tolerance
%  if iter==1, first1=errmax+1e-10; end
%  if errmax/first1 < tolmag,
%   flag=0;
%   break
%  end
 fprintf('%3.0f,   %10.4e, %6.0f',iter,errmax,n);
 fprintf('  %10.4e, %10.4e\n',avg,rms);
end  % end of iteration loop

if flag == 1, 
  disp(' I would be quitting now error < tolerance ');
else
  fprintf(' RESTORE ORIGINAL ZERO LEVEL\n');
  fprintf(' SHIFT ZERO LEVEL OF BATHY BY %8.3f\n',shift);
  h=h+shift-hwiggl;
end
g=g+shift-hwiggl;
g=real(g);
%
clf
subplot(211)
 plot(real(m2d)),title('Calculated Magnetization')
 ylabel('Magnetization (A/m)')
subplot(212)
 db=max(g)-min(g);
 dh=max(h)-min(h);
 bscl=[0,max(x),min(g)-db,max(h)+dh];
 axis(bscl)
 plot(x,h),title('Bathymetry')
 hold on
 plot(x,g,'r')
 hold off
 ylabel('Depth (km)')
% END