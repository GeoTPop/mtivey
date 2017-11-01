function wts=bpass3d(nnx,nny,dx,dy,wlong,wshort);
% BPASS3D set up bandpass filter weights in 2 dimensions
% using a cosine tapered filter
% Usage:  wts3d=bpass3d(nnx,nny,dx,dy,wlong,wshort);
%
% Maurice A. Tivey MATLAB March 1996
% MAT Jun 2006
% Calls <>
%---------------------------------------------------
if nargin <1
 help bpass3d
 fprintf(' Demo ')
 nnx=64;nny=64;dx=0.5;dy=0.5;wlong=12;wshort=1;
  wts=bpass3d(nnx,nny,dx,dy,wlong,wshort);
  clf
  surf(fftshift(wts));view(-30,65);axis tight
  title('Bandpass Filter in Fourier Domain');
 return
end
 twopi=pi*2;
 dk1=2*pi/((nnx-1)*dx);
 dk2=2*pi/((nny-1)*dy);
 % calculate wavenumber array
 nx2=nnx/2;
 nx2plus=nx2+1;
 ny2=nny/2;
 ny2plus=ny2+1;
 dkx=2*pi/(nnx*dx);
 dky=2*pi/(nny*dy);
 kx=(-nx2:nx2-1).*dkx;
 ky=(-ny2:ny2-1).*dky;
  X=ones(size(ky))'*kx;
  Y=ky'*ones(size(kx));
  k= sqrt(X.^2+Y.^2);  % wavenumber array
  k=fftshift(k);

%
if wshort==0, wshort=max(dx*2,dy*2); end
if wlong==0, wlong=min(nnx*dx,nny*dy); end

klo=twopi/wlong;
khi=twopi/wshort;
khif=0.5*khi;
klof=2*klo;
dkl=klof-klo;
dkh=khi-khif;
fprintf(' BPASS3D\n SET UP BANDPASS WEIGHTS ARRAY :\n');
fprintf(' HIPASS COSINE TAPER FROM K= %10.6f TO K= %10.6f\n',klo,klof);
fprintf(' LOPASS COSINE TAPER FROM K= %10.6f TO K= %10.6f\n',khif,khi);
fprintf(' DK1,DK2= %10.4f  %10.4f\n',dk1,dk2)

wl1=1000;
wl2=1000;
if klo>0., wl1=twopi/klo; end
if klof >0., wl2=twopi/klof; end
wl3=twopi/khif;
wl4=twopi/khi;
wnx=twopi/(dk1*(nnx-1)/2);
wny=twopi/(dk2*(nny-1)/2);

fprintf('IE BANDPASS OVER WAVELENGTHS\n');
fprintf('   INF CUT-- %8.3f --TAPER-- %8.3f (PASS) %8.3f --TAPER--%8.3f\n',wl1,wl2,wl3,wl4);
fprintf('   --  CUT TO NYQUIST X,Y= %8.3f  %8.3f\n',wnx,wny);
nnx2=nnx/2+1;
nny2=nny/2+1;
wts=zeros(size(k));  % initialise to zero
for i=1:nny,
 for j=1:nnx,
  if k(i,j)>klo, 
   if k(i,j)<khi, wts(i,j)=1; end
  end
 end
end
for i=1:nny,
 for j=1:nnx,
  if k(i,j)>klo, 
   if k(i,j)<klof, wts(i,j)=wts(i,j)*(1-cos(pi*(k(i,j)-klo)/dkl))/2 ; end
  end
  if k(i,j)>khif, 
   if k(i,j)<khi, wts(i,j)=wts(i,j)*(1-cos(pi*(khi-k(i,j))/dkh))/2 ; end
  end
 end
end
