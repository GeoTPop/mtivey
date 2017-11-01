function den=ginv2d(g2d,h,wl,ws,zobs,thick,dx);
% GINV2D Calculate density from gravity field and 
% bathymetry for a constant thickness source layer
% Use the Parker & Huestis [1974] Fourier
% inversion approach.
% 
% Usage: 
%      density=ginv2d(g2d,b2d,wl,ws,zobs,thick,dx);
%
% Parameters
%       g2d : gravity field array (mg)
%         h : bathymetry array (km +ve up)
%        wl : long wavelength cutoff (km)
%        ws : short wavelength cutoff (km)
%      zobs : observation level relative to sea level (km +ve up)
%     thick : thickness in km
%        dx : data spacing in km
% Output:
%       den : density (kg/m3)
%
% Maurice A. Tivey  MATLAB August 27 1992
% <ispow2><nfac>
format compact
if nargin < 1
 fprintf('DEMO ginv2d\n')
 help ginv2d
 x0=-10:.1:10;
 z0=zeros(size(x0));
 y0=zeros(size(x0));
 x1=-0.75;x2=0.75;
 y1=-0.75;y2=0.75;
 z1=0.5;z2=1;
 rho=2670;
 fprintf('Compute forward model...\n');
 g=gbox2d(x0,y0,z0,x1,y1,z1,x2,y2,z2,rho);
 g=g';
 %plot(g);title('Observed gravity')
 %pause
 fprintf('Now compute inversion...\n');
 h=-abs(ones(size(g)).*z1);wl=0;ws=0.5;
 zobs=0;thick=0.5;dx=0.1;
 den=ginv2d(g+rand(size(g)).*2,h,wl,ws,zobs,thick,dx);
 return
end
%
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
fprintf('     2D PROFILE GRAVITY INVERSE MODEL\n');
fprintf('                  GINV2D\n');
fprintf('        Constant thickness layer\n');
fprintf(' Zobs= %12.5f\n',zobs);,
fprintf(' Thick= %12.5f\n',thick);
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);

nn=length(g2d);
% print out the input files header
 if length(h) ~= nn, 
  fprintf(' bathy and field arrays must be of the same length\n');
  break; 
 end
 fprintf(' %6.0f points read in for input field and bathy\n',nn);
 fprintf(' DX,XMIN=   %10.3f  %10.3f\n',dx,xmin);
% remove mean from input field
 mng2d=mean(g2d);
 fprintf('Remove mean of %10.3f from field \n',mng2d);
 g2d=g2d-mng2d;
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
  g2d=border(g2d,n2);
  nn=n2;
 end
%
 const=2*pi*bigG;
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
 dexpw=exp(-K*(hwiggl));
% do thickness term
 alap=(1-exp(-K.*thick));
% take fft of observed magnetic field and initial m2d
 den=zeros(nn,1); % make an initial guess of 0 for m2d
 sum1=fft(den);
 G=fft(g2d);
% now do summing over nterms
 intsum=0;
 mlast=zeros(nn,1);
  lastden=zeros(nn,1);
  B=(G.*dexpz')./(const.*alap)';
  B(1)=0;
fprintf(' CONVERGENCE :\n');
fprintf(' ITER  MAX_PERTURB  #_TERMS  AVG         RMS\n');
for iter=1:nitrs,
% summation loop
  sum=zeros(nn,1);
  for nkount=1:nterms,
     n=nkount-1;
%    n=nkount;
    MH=fft(den.*(h).^n);
    dsum=dexpw'.*((K.^n)./nfac(n))'.*MH;
    sum=dsum+sum;
    errmax=max( abs(real(sum)+imag(sum)) );
  end
% transform to get new solution
  M=(B-sum)+mlast;
% filter before transforming to ensure no blow ups
  M(1)=0;
  mlast=M.*wts';
  den=ifft(mlast);
% do convergence test
  errmax=0;
  s1=0;
  s2=0;
   dif=abs(lastden-den);
   s1=s1+max(dif);
   s2=s2+max(dif.*dif);
   if errmax-max(dif) < 0,
    errmax=max(dif);
   end
   lastden=den;
   avg=s1/nn;
  rms=sqrt(s2/nn - avg^2);
 % test for errmax less than tolerance
 if iter==1, 
    first1=errmax+1e-10;  
    erpast=errmax;
 end
 if errmax > erpast,
   flag=1;  % set the flag to show diverging solution
   break
 end
 erpast=errmax;
 if errmax < tolmag,
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
den=real(den)./(si2mg*km2m);
den=den(1:nold);
h=h(1:nold);
subplot(211)
plot(den),title('Calculated Density for a Constant Thickness Layer')
ylabel('Density (kg/m3)')
subplot(212)
plot(g2d(1:nold)),title('Observed Gravity')
ylabel('Gravity (mgals)')

