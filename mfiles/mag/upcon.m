function b=upcon(f2d,dx,z)
% UPCON - Upward continue a magnetic field profile to a specified level 
% using linear filtering techniques
%
%  Usage: b=upcon(f2d,dx,z)
%   input f2d : magnetic field
%         dx  : spacing in km
%         z   : upward continuation distance in km
%   output b  : upward continued field
%  Be warned that this approach is sensitive to edge
%  effects so make sure data is bordered properly!
%
%  Maurice A. Tivey July 1997
% calls <>

if nargin < 1
  help upcon  
  return
end
%
plotflag=0;
if dx < 0, plotflag=1; end
dx=abs(dx);

 [nx,ny]=size(f2d);
 if ny > 1, f2d=f2d'; end

 nn=length(f2d);
 nn2=nn/2;
 n2plus=nn2+1;
 x=(1:nn)*dx-dx;
 dk=2*pi/(nn*dx);
% make wave number array
 k=1:n2plus;
 k=(k-1).*dk;
 K=k;
 K(n2plus+1:nn)=k(nn2:-1:2);
 B=fft(f2d);
% - upcon term --------------------------------
 up=exp(-K.*z);
 b=ifft(B.*up');
 b=real(b);
%------------------ Plotting -------------------
if plotflag==1,
clf
subplot(211)
plot(x,b)
title(' Upward continued Magnetic field')
xlabel(' Distance km')
ylabel(' Amplitude (nT)')
subplot(212)
plot(x,f2d)
title(' Original Magnetic field')
xlabel(' Distance km')
ylabel(' Amplitude (nT)')
end
%  The End
