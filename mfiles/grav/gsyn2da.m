function f2d=gsyn2da(den,top,bot,zobs,dx)
% GSYN2DA
%
% Calculate gravity field on level plane given a density and 
% top and bottom of a source layer using Parker's [1973]
% Fourier series summation approach.
%
% Usage:
%      f2d=gsyn2d(den,top,bot,zobs,dx);
%
% Parameters
%       den : density array (kg/m3)
%       top : top of source layer array (km +ve up)
%       bot : bottom of source layer
%      zobs : observation level relative to sea level +ve up
%        dx : data spacing in km
%
% NOTE x distance is positive to right (east) or (north)
%
% Maurice A. Tivey MATLAB Version 7 June 2014

if nargin < 1
 help gsyn2da
 % do a test flat layer model
 den=zeros(128,1);
 den(38:44)=den(38:44)+2670;
 top=ones(size(den)).*(-0.5);
 bot=top-0.5;
 dx=.25; zobs=0;
 x0=(0:127).*dx;
 f2d=gsyn2da(den,top,bot,zobs,dx);
 clf
 subplot(211)
 plot(x0,f2d);
 axis([0 20 0 40])
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO gsyn2da : Profile over a vertical prism')
 subplot(212)
 plot(x0,zeros(size(x0))); hold on;
 plot(x0,top);plot(x0,bot)
 fill([x0(38),x0(44),x0(44),x0(38)],[-0.5,-0.5,-1,-1],'r');
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 axis([0 20 -1 0])
 max(max(f2d))
 return
end

format compact
% parameters defined
 i=sqrt(-1);
 rad=pi/180;         % conversion radians to degrees
 bigG=6.67e-11;      % grav constant
 si2mg=1e5;          % SI units to mgals
 km2m=1000;          % km to meters
% changeable parameters
 nterms=20;
 tol=1e-10;

fprintf('     2D GRAVITY PROFILE FORWARD MODEL\n');
fprintf('          GSYN2DA\n');
fprintf('    Variable thickness source layer\n');
fprintf(' Version June 23 2014\n');
fprintf(' Zobs= %12.5f\n',zobs);,
fprintf(' Nterms,Tol %6.0f %10.5f \n',nterms,tol);
nn=length(den);
fprintf(' Number of points in profile are : %10.0f\n',nn);
fprintf(' Spacing of points dx : %10.4f\n',dx);

const=2*pi*bigG.*(si2mg*km2m);
den=den;
% shift zero level of bathy
 hmax=max(max(top),max(bot));
 hmin=min(min(top),min(bot));
 fprintf(' %10.3f %10.3f = MIN, MAX LAYER TOP AND BOTTOM\n',hmin,hmax);
 shift=max(top);
 hwiggl=abs(hmax-hmin)/2;
 zup=zobs-shift;
 fprintf(' SHIFT ZERO OF BATHY WILL BE %8.3f\n',shift);
 fprintf('THIS IS OPTIMUM FOR INVERSION.\n');
 fprintf('NOTE OBSERVATIONS ARE %8.3f KM ABOVE BATHY\n',zup);
 fprintf('ZOBS=%8.3f ZUP=%8.3f\n',zobs,zup);
 zup=zup+hwiggl;     
 fprintf('%8.3f = HWIGGL, DISTANCE TO MID-LINE OF BATHY\n',hwiggl);
 fprintf('THIS IS OPTIMUM ZERO LEVEL FOR FORWARD PROBLEM\n');
 top=top-shift;
 top=top+hwiggl;
 bot=bot-shift;
 bot=bot+hwiggl;
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
% now do summing over from n=0 to nterms
% sum1=eterm'.*fft(den); % n=0 term
 sum1=zeros(nn,1);
 last=0;
% first=max(abs(sum1));
 for n=1:nterms,
  MH=fft(den.*((top.^n)-(bot.^n)));
  sum=eterm'.*((K.^(n-1))./nfac(n))'.*MH+sum1;
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
b=ifft(const*sum);
f2d=real(b);
% restore bathy
top=top+shift-hwiggl;
bot=bot+shift-hwiggl;
%
clf
subplot(211)
plot(f2d),title('Calculated Gravity Field')
ylabel('Gravity field mGal')
subplot(212)
plot(real(top)),title('Layer')
hold on
plot(real(bot),'r')
% finished

