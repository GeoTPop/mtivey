function b=upcon3d(f3d,dx,dy,z,wl,ws)
% UPCON3D - upward continue magnetic field map to specified level
% using linear filtering techniques
%
% Usage:  b=upcon3d(f3d,dx,dy,z)
%         b=upcon3d(f3d,dx,dy,z,wlong,wshort)
%
% f3d : input magnetic field in nT
% dx,dy, grid spacing in km
% z : upcon distance in km (+ve up)
% wlong,wshort : long and short wavelength cutoffs in km 
%
% output 
%       b 	upward continued field (nT)
%
% NOTE: No bordering is performed.
% CAN ALSO USE FOR DOWNWARD CONTINUATION 
%
%  MATLAB UNIX V4.0
%  Maurice A. Tivey July 21 1992
% March 1996
% Aug 2003
% calls <bpass3d>
format compact
if nargin < 1
 fprintf('\n             DEMO OF UPCON3D \n');
 help upcon3d
 fprintf('FIRST GENERATE A PRISM AT DEPTH\n');
 m=zeros(32,32);  m(16:20,16:20)=m(16:20,16:20)+10;
 fprintf('SET PARAMETERS FOR CALCULATING THE FIELD\n');
 fprintf('ASSUME TOPOGRAPHY IS FLAT\\nn');
 h=ones(32,32).*(-2);
 dx=1; dy=1; sdip=0; sdec=0; thick=1;
 rlat=26;rlon=-45;yr=1990;slin=0;zobs=0;
 f3d=syn3d(m,h,rlat,rlon,yr,zobs,thick,slin,dx,dy,sdip,sdec);
 fprintf('NOW CALCULATE AT NEW LEVEL\n')
  f3d1=syn3d(m,h,rlat,rlon,yr,zobs+1,thick,slin,dx,dy,sdip,sdec);
 fprintf('COMPARE TO UPCON VERSION\n')
  f3d2=upcon3d(f3d,dx,dy,1);
  figure(2) 
  surf(f3d2-f3d1);title('f3d2-f3d1')
  max(max(f3d2-f3d1))
return
end

%------------ PARAMETERS ------------------------------
if nargin < 2
 dx=input(' Enter spacing of data points dx in km ->');
 dy=input(' Enter spacing of data points dy in km ->');
 z=input(' Enter distance to upward continue (km +up) ->');
end
%
%------ input profile is in array f3d
%
 fprintf('UPWARD CONTINUATION FOR GRIDS\n');
 fprintf('Distance to upward continue: %12.3f\n',z);
 [ny,nx]=size(f3d);

% calculate wavenumber array
 nx2=nx/2;
 nx2plus=nx2+1;
 ny2=ny/2;
 ny2plus=ny2+1;
 dkx=pi/(nx*dx);
 dky=pi/(ny*dy);
 kx=(-nx2:nx2-1).*dkx;
 ky=(-ny2:ny2-1).*dky;
  X=ones(size(ky))'*kx;
  Y=ky'*ones(size(kx));
  k= 2*sqrt(X.^2+Y.^2);  % wavenumber array
  K=fftshift(k);

B=fft2(f3d);
% do upcon term
up=exp(-K.*z);
if nargin > 4,
   % do bandpass filtering
   wts=bpass3d(nx,ny,dx,dy,wl,ws);
   b=ifft2(B.*up'.*wts);
else     
   b=ifft2(B.*up);
end
b=real(b);
%------------------ Plotting -------------------
clf
subplot(211)
contourf(b);title(' Upward continued Magnetic field')
subplot(212)
contourf(f3d);title( ' Original Field')

