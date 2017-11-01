function wts=azwts3(az1,az2,nnx,nny,dx,dy,wlong,wshort);
% AZWTS3 set azimuthal notch filter weights in X-direction
%  with bandpass as usual (AS IN SUB. WTS)
%    WT = 0.  WHEN KY/KX < AZ1
%    WT = COS TAPER WHEN BETWEEN AZ1 AND AZ2
%    WT = NORMAL BANDPASS WHEN KY/KX > AZ2
%   AZIMUTHAL NOTCH DISABLED WHEN AZ1=AZ2
%
% Usage:  wts3d=azwts3(az1,az2,nnx,nny,dx,dy,wlong,wshort);
%
%  S MILLER INV3D MACLIB 1-AUG-83
%  M.A.TIVEY 3-MAY-88 P.C. Version M.S. FORTRAN 4.01
%  LIB <LINV3D>
%
%  Maurice A. Tivey
%  MATLAB V5 Dec 1999
%  MAT Jun 2006
% calls <>
%-------------------------------------------------------

if nargin <1
 help azwts3
 fprintf(' Demo ')
 nnx=64;nny=64;dx=0.5;dy=0.5;wlong=12;wshort=1;
 az1=0.1;az2=.25;
 wts=azwts3(az1,az2,nnx,nny,dx,dy,wlong,wshort);
 figure(1); clf
  surf(fftshift(wts));axis tight; view(2);
  title('Azimuthal Bandpass filter in Fourier domain az1=0.1 az2=0.25');
  az1=0.25;az2=2;
 wts2=azwts3(az1,az2,nnx,nny,dx,dy,wlong,wshort);
 figure(2); clf
  surf(fftshift(wts2));axis tight; view(2);
  title('Azimuthal Bandpass filter in Fourier domain az1=0.25 az2=2');
  return
end
 twopi=pi*2;
 dk1=twopi/((nnx-1)*dx);
 dk2=twopi/((nny-1)*dy); 
% calculate wavenumber array
 nx2=nnx/2;
 nx2plus=nx2+1;
 ny2=nny/2;
 ny2plus=ny2+1;
 dkx=twopi/(nnx*dx);
 dky=twopi/(nny*dy);
 %kx=(-nx2:nx2-1).*dk1;
 %ky=(-ny2:ny2-1).*dk2;
 kx=(-nx2:nx2-1).*dkx;
 ky=(-ny2:ny2-1).*dky;
  X=ones(size(ky))'*kx;
  Y=ky'*ones(size(kx));
  k= sqrt(X.^2+Y.^2);  % wavenumber array
%  k=fftshift(k);

if wshort==0, wshort=max(dx*2,dy*2); end
if wlong==0, wlong=min(nnx*dx,nny*dy); end

klo=twopi/wlong;
khi=twopi/wshort;
%tollow=1-exp(-klo*thick);
%tolhi=exp(-khi*(zup*hwiggl));
%khi=log(1/tolhi)/(zup*thick);
%klo=log(1/(1-tollow))/thick;
%
khif=0.5*khi;
klof=2*klo;
dkl=klof-klo;
dkh=khi-khif;
dkaz=az2-az1;
iazm=1; % initialize flag variable 1=true,0=false
if dkaz==0, iazm=0; end % ie false
if dkaz<0, dkaz =-abs(dkaz); end
%
fprintf(' AZWTS3\n SET UP BANDPASS WEIGHTS ARRAY :\n');
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

if iazm~=0,  
 fprintf(' AZIMUTHAL FILTER NOTCH NEAR X-DIR, ZERO TO KY/KX=%8.3f\n COS TAPER TO KY/KX=%8.3f NORMAL BANDPASS OTHERWISE\n',az1,az2)
end

nnx2=nnx/2+1;
nny2=nny/2+1;
wts=zeros(size(k));  % initialise to zero

% initial set up with standard weights
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
 
% Now modify with notch filter
for i=1:nny,
 for j=1:nnx,
  if k(i,j)<=klo | k(i,j)>=khi
    % do nothing
  else
  if kx(j)==0,
   % do nothing
  else
   acyx=abs(ky(i)/kx(j));
   if acyx<=az1, 
    wts(i,j)=0;
   else
    if acyx<az2, 
     %----------COMPUTE NOTCH FILTER WTS IN TAPER REGION:
     wts(i,j) = ( 1.-cos(pi*(acyx-az1)/dkaz))/2.;
    else
     wts(i,j) = 1.;
    end
    if k(i,j)>klo, 
     if k(i,j)<klof, wts(i,j)=wts(i,j)*(1-cos(pi*(k(i,j)-klo)/dkl))/2 ; end
    end
    if k(i,j)>khif, 
     if k(i,j)<khi, wts(i,j)=wts(i,j)*(1-cos(pi*(khi-k(i,j))/dkh))/2 ; end
    end
   end 
  end
  end
 end
end
%
%wts=rot90(wts); % a fix for a mix up on kx and ky
wts=fftshift(wts);
