function g=grvsph(R,z,nx,dx,rho)
%  grvsph
%  Calculate the gravity effect of a sphere
%  2D profile version
%  Based on Telford pg 57
%  Maurice A. Tivey  June 18, 1991
%  1 gal= 10-2 m/s2
G=6.670e-11;
if nargin < 1
disp('  Calculate the gravity effect of a sphere')
disp('  2D profile version')
R=input(' Enter radius of sphere (m) ')
rho=input(' Enter density contrast of sphere (kg/m3) ')
z=input(' Enter depth of sphere (km) ')
nx=input(' Enter number of profile points ')
dx=input(' Enter spacing of points (km) ')
end
%
nx2=nx/2;
x=-nx2:1:nx2-1;
x=x*dx;
R3=R^3;
x2=x.^2;
const=(4*pi*G*rho*R3)/3;
z2=z^2;
f=z*((x2+z2).^(-1.5))*1e-6;
g=const*f;
g=g*100000;   % convert to mgals
subplot(211)
plot(x,g,'w'),title(' Gravity effect of sphere ')
xlabel(' Distance (km)')
ylabel( 'Gravity (mgals)')
subplot(212)
plot((x/z),g),title(' Gravity effect of sphere ')
xlabel(' Depth units x/z')
ylabel( 'Gravity (mgals)')
