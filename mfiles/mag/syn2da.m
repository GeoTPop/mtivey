function f2d=syn2da(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip)
% SYN2DA - Calculate mag field given a magnetization and bathymetry for
% a variable thickness layer using Parker's [1973] Fourier series 
% summation approach
% Usage:
%      f2d=syn2da(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% or for geocentric dipole
%      f2d=syn2da(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx);
%
% Parameters
%       m2d : magnetization array (A/m)
%         h : bathymetry array (km +ve up)
% rlat rlon : regional lat and long for igrf (decimal degrees)
%             if rlat is 90 then calculate reduced to pole anomaly
%        yr : decimal year of survey for igrf calculation
%             NOTE: make yr negative for no plotting
%      zobs : observation level relative to sea level +ve up
%     thick : thickness array in km
%      slin : angle of lineations + cw from north
%        dx : data spacing in km
%      sdec : magnetization declination +ve cw N (optional)
%      sdip : magnetization inclination +ve down (optional)
%
% NOTE x distance is positive to right (east) or (north)
%
% Maurice A. Tivey MATLAB Version 10 August 1992
%                   Nov 8 1994
% MAT mods	    Dec 17 1996

if nargin < 1
 help syn2da
 % test a simple variable layer model
 m2d=zeros(256,1);
 m2d(64:128)=m2d(64:128)+10;
 h=ones(size(m2d)).*(-4);
 thk=ones(size(h)); thk(80:100)=thk(80:100).*0.5;
 dx=0.5;rlat=26;rlon=-45;yr=1990;slin=20;zobs=0;
 f2d=syn2da(m2d,h,rlat,rlon,yr,zobs,thk,slin,dx);
 return
end

pl=0;
if yr < 0,  % check if yr negative which is a flag to not plot
 yr=abs(yr);
 pl=1;
end
format compact
% parameters defined
	i=sqrt(-1);
	rad=pi/180;  % conversion radians to degrees
	mu=100;      % conversion factor to nT
	nterms=20;
	tol=1e-10;
fprintf('     2D PROFILE FORWARD MODEL\n');
fprintf('          SYN2DA\n');
fprintf('    Variable thickness layer\n\n');
fprintf(' Maurice A. Tivey\n');
fprintf(' Version: Dec 17 1996\n\n');
fprintf(' Zobs= %12.5f\n Rlat= %12.5f Rlon= %12.5f\n',zobs,rlat,rlon);,
fprintf(' Yr= %12.5f\n',yr);
if nargin == 11
fprintf(' Slin,Sdec,Sdip = %12.6f %12.6f %12.6f\n',slin,sdec,sdip);
elseif nargin == 9,
 fprintf(' Slin = %12.6f\n',slin);
else
 disp('ERROR on input: Not enough arguments');
end
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);
nn=length(m2d);
fprintf(' Number of points in profile are : %10.0f\n',nn);
fprintf(' Spacing of points dx : %10.4f\n',dx);

% get phase and skewness directions
if rlat==90,   % then this is a reduced to pole anomaly
 theta=0
 ampfac=1
else      % calculate actual phase parameters
 if nargin == 11,
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin,sdec,sdip);
 else
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin);
 end
end
 const=2*pi*ampfac*mu;
% calculate base layer
 base=h-thick;
% shift zero level of bathy
 hmax=max(max(h),max(base));
 hmin=min(min(h),min(base));
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BATHY AND BASE\n',hmin,hmax);
 shift=max(h);
 hwiggl=abs(hmax-hmin)/2;
 zup=zobs-shift;
 fprintf(' SHIFT ZERO OF BATHY WILL BE %8.3f\n',shift);
 fprintf('THIS IS OPTIMUM FOR INVERSION.\n');
 fprintf('NOTE OBSERVATIONS ARE %8.3f KM ABOVE BATHY\n',zup);
 fprintf('ZOBS=%8.3f ZUP=%8.3f\n',zobs,zup);
 zup=zup+hwiggl;     
 fprintf('%8.3f = HWIGGL, DISTANCE TO MID-LINE OF BATHY\n',hwiggl);
 fprintf('THIS IS OPTIMUM ZERO LEVEL FOR FORWARD PROBLEM\n');
 h=h-shift;
 h=h+hwiggl;
 base=base-shift;
 base=base+hwiggl;
%
 nn2=nn/2;
 n2plus=nn2+1;
 x=(1:nn)*dx-dx;
 dk=2*pi/(nn*dx);
% make wave number array
 k=1:n2plus;
 k=(k-1).*dk;
 K=k;
 K(n2plus+1:nn)=k(nn2:-1:2);
% do upcon term
 eterm=exp(-K.*zup);
% phase term
 phase=exp(i*theta*rad.*sign(nn2-(1:nn)));
% now do summing over nterms
 sum1=zeros(nn,1);
 last=0;
 for n=1:nterms,
  MH=fft(m2d.*(h.^n-base.^n));
  sum=eterm'.*((K.^n)./nfac(n))'.*MH+sum1;
  errmax=max(abs( real(sum)+real(sum1)));
  fprintf(' AT TERM  %6.0f ',n);
  fprintf('MAXIMUM PERTURBATION TO SUM %12.5e\n',errmax-last);
  if n>1,
   if abs(errmax-last) < tol, 
%    return
   end
  end
%  fprintf('errmax/first = %12.5e\n',(errmax-last)/first);
   last=errmax;
   sum1=sum;
 end
b=(const*sum.*phase');
%b(1)=0;
b=ifft(b);
f2d=real(b);
% restore bathy
h=h+shift-hwiggl;
h=real(h);
base=base+shift-hwiggl;
base=real(base);
% plotting
if pl == 0,
 fscl=[0,max(x),min(f2d)-0.1*min(f2d),max(f2d)+0.1*max(f2d)];
 axis(fscl)
 clf
 subplot(211)
 plot(x,f2d),title('Calculated Magnetic Field')
 subplot(212)
 db=max(base)-min(base);
 dh=max(h)-min(h);
 bscl=[0,max(x),min(base)-db,max(h)+dh];
 axis(bscl)
 plot(x,h),title('Bathymetry ')
 hold on
 plot(x,base,'r')
 hold off
end


