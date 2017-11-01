function [X,T]=mpole(m,dz,nx,dx,incl)
% MPOLE  Total magnetic field due to a monopole at depth
% analogous to an infinitely long rod.
% Magnetic profile is along the magnetic meridian
% 2D (profile) version like Telford example
%
%  Usage: [X,T]=mpole(m,dz,nx,dx,incl)
%   Input
%       m  : magnetization in A/m
%       dz : depth to top of monopole in km
%       nx : number of points
%       dx : spacing of points in km
%      incl: inclination (degrees)
%  Output
%      X   : distance array
%      T   : magnetic field profile
%
% Maurice A. Tivey May 26, 1992
% July 2002
if nargin < 1
   fprintf('Demo mpole\n')
   help mpole
   [X,T]=mpole(10,0.1,64,0.01,60);
   return
end
degrad=pi/180;
nx2=nx/2;
% generate x distance array
X=(0:(nx-1)).*dx;
X=X-X(nx2);
%X=-nx2:1:nx2;
%X=X.*dx;
xz=X/dz;
r5=(sqrt(X.^2+dz^2)).^5;
X2=X.^2;
T=-m*(cos(incl*degrad).*X-sin(incl*degrad)*dz);
% 
T=T./((X2+dz^2).^1.5);
yt = max(T);
xt = min(X);
plot(X,T)
title('Total Magnetic Field over a Monopole')
text(xt,0.95*yt,[' Depth  (km) = ' num2str(dz) ])
text(xt,0.85*yt,[' Incl = ' num2str(incl) ])
