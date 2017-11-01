function f2d=syn2d(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip)
% SYN2D 
%
% Calculate magnetic field on level plane given a magnetization and 
% bathymetry using Parker's [1973] Fourier series summation 
% approach.    
% Usage:
%      f2d=syn2d(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% or for geocentric dipole
%      f2d=syn2d(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx);
%
% Parameters
%       m2d : magnetization array (A/m)
%         h : bathymetry array (km +ve up)
% rlat rlon : regional lat and long for igrf (decimal degrees)
%             if rlat is 90 then calculate reduced to pole anomaly
%        yr : decimal year of survey for igrf calculation
%             NOTE: make yr negative for no plotting
%      zobs : observation level relative to sea level +ve up
%     thick : thickness in km
%      slin : angle of lineations + cw from north
%        dx : data spacing in km
%      sdec : magnetization declination +ve cw N (optional)
%      sdip : magnetization inclination +ve down (optional)
%
% NOTE x distance is positive to right (east) or (north)
%
% Maurice A. Tivey MATLAB Version 5 August 1992
%                                 21 Nov 1994
%                                 17 Dec 1996
%-----------------------------------------------------------
if nargin < 1
 help syn2d
 % do a test flat layer model
 m2d=zeros(256,1);
 m2d(64:128)=m2d(64:128)+10;
 h=ones(size(m2d)).*(-4);
 thk=1; dx=.5;
 rlat=26;rlon=-45;yr=1990;slin=20;zobs=0;
 f2d=syn2d(m2d,h,rlat,rlon,yr,zobs,thk,slin,dx);
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
% changeable parameters
 nterms=20;
 tol=1e-10;

fprintf('     2D PROFILE FORWARD MODEL\n');
fprintf('          SYN2D\n');
fprintf('    Constant thickness layer\n');
fprintf(' Version June 25 1992\n');
fprintf(' Zobs= %12.5f\n Rlat= %12.5f Rlon= %12.5f\n',zobs,rlat,rlon);,
fprintf(' Yr= %12.5f\n',yr);
fprintf(' Thick= %12.5f\n',thick);
nargin
if nargin == 11,
 fprintf(' Slin,Sdec,Sdip = %12.6f %12.6f %12.6f\n',slin,sdec,sdip);
elseif nargin == 9,
 fprintf(' Slin = %12.6f\n',slin');
else
 disp('ERROR on input: Not enough arguments')
end
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);
nn=length(m2d);
fprintf(' Number of points in profile are : %10.0f\n',nn);
fprintf(' Spacing of points dx : %10.4f\n',dx);
% get skewness and phase
if rlat==90,   % then calculate RTP anomaly
 theta=0
 ampfac=1
else
 if nargin == 11,
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin,sdec,sdip);
 else               %  assume a geocentric dipole
  [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin);
 end
end
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
 zup=zup+hwiggl;     
 fprintf('%8.3f = HWIGGL, DISTANCE TO MID-LINE OF BATHY\n',hwiggl);
 fprintf('THIS IS OPTIMUM ZERO LEVEL FOR FORWARD PROBLEM\n');
 h=h-shift;
 h=h+hwiggl;
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
% do constant thickness term
 alap=(1-exp(-K.*thick));
% combine into earth term
% earth=alap.*eterm; 
% modify to multiply by eterm in summation
% to match fortran version
 earth=alap;
% phase term
 phase=exp(i*theta*rad.*sign(nn2-(1:nn)));
% now do summing over from n=0 to nterms
 sum1=eterm'.*fft(m2d); % n=0 term
 last=0;
% first=max(abs(sum1));
 for n=1:nterms,
  MH=fft(m2d.*h.^n);
  sum=eterm'.*((K.^n)./nfac(n))'.*MH+sum1;
  errmax=max(abs(real(sum)+real(sum1)));
  fprintf(' AT TERM  %6.0f ',n);
  fprintf('MAXIMUM PERTURBATION TO SUM %12.5e\n',errmax-last);
%  fprintf('errmax/first = %12.5e\n',(errmax-last)/first);
  if n>1
%   if abs(errmax-last) < tol, break, end
  end
   last=errmax;
   sum1=sum;
 end
b=ifft(const*sum.*earth'.*phase');
f2d=real(b);
% restore bathy
h=h+shift-hwiggl;
%
if pl == 0,
subplot(211)
plot(f2d),title('Calculated Magnetic Field')
subplot(212)
plot(real(h)),title('Bathymetry')
end
