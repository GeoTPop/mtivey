function kx=kvalue(nn,dx)
% KVALUE compute wavenumber coordinate
% Usage:
%    kx=kvalue(nn,dx);
%
nn2=nn/2;
n2plus=nn2+1;
dkx=2*pi/(nn*dx);
% make wave number array
kx=(-nn2:nn2-1).*dkx;
kx=fftshift(kx);

% a slower way
%for j=1:nn,
% if j <= n2plus
%   kx(j)=(j-1)*dkx;
% else
%   kx(j)=(j-nn-1)*dkx;
% end
%end
