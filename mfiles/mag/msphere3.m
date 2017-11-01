function f=msphere3(incl,decl,M,dz,rs,nx,dx,ix,iy)
% msphere3 - Generate the 3D magnetic field due to a sphere
% at depth
% Usage: f=msphere3(incl,decl,M,dz,rs,nx,dx,ix,iy)
%    dz depth of sphere (km)
%    rs radius of sphere (km)
%    nx number of x grid cells  (==y cells)
%    dx spacing of x grid cells (==y cells)
%     ix x indices location of sphere
%     iy y indices location of sphere
% Output a 'struct' array 'f'
% with the following arrays: f.t,f.hx,f.hy,f.hz
%
% Maurice A. Tivey January 29, 1991
%-------------------------------------------------------
 
degrad=pi/180;
if nargin < 1
   fprintf('DEMO : msphere3\n');
   help msphere3
   incl=60;
   decl=0;
   M=10;dz=0.5;rs=0.1;nx=64;dx=0.05;ix=32;iy=32;
   f=msphere3(incl,decl,M,dz,rs,nx,dx,ix,iy);
   return
 incl=input('Enter inclination (+deg down)->');
 decl=input('Enter declination (+deg cw)  ->');
 M=input('Enter magnetization of sphere (A/M) ->');
 dz=input('Enter depth of sphere (km) ->');
 rs=input('Enter radius of the sphere (km) ->');
 nx=input('Enter number of X grid cells ->');
 dx=input('Enter spacing of X grid cells ->');
end

% now calculate horizontal and vertical unit vectors components

h0=cos(incl*degrad);
z0=sin(incl*degrad);
x0=h0*sin(decl*degrad);
y0=h0*cos(decl*degrad);
%
disp(' Note: Y cells and spacing set equal to X');
disp(' Please wait a moment ...')
% volume of the sphere
v=(4.*pi*rs^3)/3;

% generate x and y arrays
nx2=nx/2;
%ax=-nx2:1:nx2;
ax=0:nx-1;
ay=ax';
X=ones(size(ay))*ax.*dx;
Y=ay*ones(size(ax)).*dx;
X=X-(ix*dx);
Y=Y-(iy*dx);
X=-X;
Y=-Y;

% calculate vertical component
r5=(sqrt(X.^2+Y.^2+dz^2)).^5;
r2=X.^2+Y.^2+dz^2;
XY=X.*Y;
X2=X.^2;
Y2=Y.^2;
Z2=dz*dz;
HY=(x0*(3*dz*X)+y0*((2*Y2)-X2-Z2)+z0*(3*dz*Y))./r5;
HX=(x0*((2*X2)-Y2-Z2)+y0*(3*XY)+z0*(3*dz)*X)./r5;
Z=(x0*(3*dz*X)+y0*(3*dz*Y)+z0*(2*Z2-X2-Y2))./r5;
%
Z=Z.*(100*v*M);
HX=HX.*(100*v*M);
HY=HY.*(100*v*M);
H=HX*sin(decl*degrad)+HY*cos(decl*degrad);
T=H*cos(incl*degrad)+Z*sin(incl*degrad);
% Plotting
clf
axis('square')
subplot(221)
contourf(X,Y,Z), hold on, shading flat
[c,h]=contour(X,Y,Z,'k-'); clabel(c,h), colorbar
title(' Z component');
subplot(222)
contourf(X,Y,H), hold on, shading flat
[c,h]=contour(X,Y,H,'k-'); clabel(c,h), colorbar
title('H component');
subplot(223)
contourf(X,Y,T), hold on, shading flat
[c,h]=contour(X,Y,T,'k-'); clabel(c,h), colorbar
title('Total Field');
% find the distance from peak-trough
[i1,j1]=find(T==max(max(T)))
[i2,j2]=find(T==min(min(T)))
pt_distance=sqrt((i2-i1)^2+(j2-j1)^2)*dx;
tminmax=max(max(T))-min(min(T));
disp('Peak-trough distance (km)'),disp(num2str(pt_distance));
disp('Peak-trough amplitude (nT)'),disp(num2str(tminmax));
%
f.t=T;
f.hx=HX;
f.hy=HY;
f.hz=Z;
% the end
