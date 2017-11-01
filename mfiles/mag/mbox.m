function t=mbox(x0,y0,z0,x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta)
% mbox Compute total magnetic field of a rectangular prism of infinite depth extent
% at an observation point (x0,y0,z0)
% Sides of prism are parallel to x,y,z axes
% Z-axis is +ve vertical down
%
% Usage:
%   t=mbox(x0,y0,z0,x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta);
% x0,y0,z0 observation coordinates and obs level grid
% x1,y1,z1,x2,y2 lateral extent of prism in km
% mi,md : magnetization inclination, declination
% fi,fd : field inclination, declination
% mag : magnetization
% theta : azimuth of x-axis;
%
% After Bhattacharyya, 1964; Blakely, 1995
% Maurice A. Tivey  MATLAB July 2002
%
if nargin < 1
 fprintf('DEMO mbox')
 help mbox
 x0=-10:.1:10;
 z0=zeros(size(x0));
 y0=zeros(size(x0));
 x1=-0.75;x2=0.75;
 y1=-0.75;y2=0.75;
 z1=0.5;
 mi=60;
 md=0;
 fi=60;
 fd=0;
 mag=10;
 theta=0;
for i=1:length(x0);
 t(i)=mbox(x0(i),y0(i),z0(i),x1,y1,z1,x2,y2,mi,md,fi,fd,mag,theta);
end
 subplot(211)
 plot(x0,t)
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Magnetic Field (nT)')
 title('DEMO: MBOX Magnetic field over a vertical prism')
 subplot(212)
 plot(x0,z0); hold on;fill([x1,x2,x2,x1],[z1,z1,1,1],'r');axis ij
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 return
end

% fixed parameters
 twopi=pi*2;
 cm=1e-7;
 t2nt=1e9;
%
ma=cos(mi*pi/180)*cos((md-theta)*pi/180);
mb=cos(mi*pi/180)*sin((md-theta)*pi/180);
mc=sin(mi*pi/180);
fa=cos(fi*pi/180)*cos((fd-theta)*pi/180);
fb=cos(fi*pi/180)*sin((fd-theta)*pi/180);
fc=sin(fi*pi/180);
% hatm=dircos(mi,md,theta);
% ma=hatm(2);mb=hatm(1);mc=-hatm(3);
% hatb=dircos(fi,fd,theta);
% fa=hatb(2);fb=hatb(1);mc=-hatb(3);
fm1=ma*fb+mb*fa;
fm2=ma*fc+mc*fa;
fm3=mb*fc*mc*fb;
fm4=ma*fa;
fm5=mb*fb;
fm6=mc*fc;
alpha(1)=x1-x0;
alpha(2)=x2-x0;
beta(1)=y1-y0;
beta(2)=y2-y0;
h=z1-z0;
t=0;
hsq=h^2;
for i=1:2,
   alphasq=alpha(i).^2;
   for j=1:2,
      sign=1;
      if i ~= j, sign=-1; end
      r0sq=alphasq+beta(j).^2+hsq;
      r0=sqrt(r0sq);
      r0h=r0*h;
      alphabeta=alpha(i)*beta(j);
      arg1=(r0-alpha(i))/(r0+alpha(i));
      arg2=(r0-beta(j))/(r0+beta(j));
      arg3=alphasq+r0h+hsq;
      arg4=r0sq+r0h-alphasq;
      tlog=fm3*log(arg1)/2 + fm2*log(arg2)/2 - fm1*log(r0+h);
      tatan=-fm4*atan2(alphabeta,arg3)-fm5*atan2(alphabeta,arg4)+fm6*atan2(alphabeta,r0h);
      t=t+sign*(tlog+tatan);
   end
end
t=t*mag*cm*t2nt;
                
        