function [X,T,Z,HX]=msph(m,dz,rs,nx,dx,incl)
% MSPH - Total magnetic field due to a sphere at depth
% Magnetic profile is along the magnetic meridian
% 2D (profile) version like Telford example
%
% usage: [X,T,Z,HX]=msph(m,dz,rs,nx,dx,incl)
% m	: magnetization (A/m)
% dz	: depth of sphere (km)
% rs	: radius of sphere (km)
% nx	: number of data points
% dx	: data spacing of output profile (km)
% incl	: inclination in degrees
%
% Output:
% X	: data x array
% T,Z,HX : total field, vertical field, horizontal field
%
% Maurice A. Tivey January 29, 1991

if nargin < 1
   fprintf('DEMO : msph\n');
   help msph
   [x,t,z,hx]=msph(10,.5,.1,64,.1,60);
   return
end
degrad=pi/180;
decl=0;
% now calculate horizontal and vertical unit vectors
h0=cos(incl*degrad);
z0=sin(incl*degrad);

nx2=nx/2;
% generate x distance array
X=-nx2:1:nx2;
X=X.*dx;
xz=X/dz;
r5=(sqrt(X.^2+dz^2)).^5;
X2=X.^2;
% calculate components
Z=(((3*h0*dz).*X)+(z0*(2*dz*dz)-X2))./r5;
HX=(h0*(2.*X2-dz^2)+((3*z0*dz).*X))./r5;
T=(cos(incl*degrad).*HX+sin(incl*degrad).*Z);
% 
% volume of the sphere
vol=(4*pi.*rs.^3)./3;
T=T.*(100*m*vol);
Z=Z*(100*m*vol);
HX=HX.*(100*m*vol);
yt = max(T);
xt = min(X);
% Plotting
clf
plot(X,T)
hold on
plot(X,Z,'r')
plot(X,HX,'g')
legend('T','V','HX')
title('Magnetic Field Over a Buried Sphere')
xlabel('Distance (km)')
ylabel('Magnetic Field (nT)')
text(xt,0.95*yt,['Depth  (km) = ' num2str(dz) ])
text(xt,0.85*yt,['Radius (km) = ' num2str(rs) ])
text(xt,0.75*yt,['Inclination = ' num2str(incl)]);