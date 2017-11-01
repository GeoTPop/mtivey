function fout=rtp3d(fin,ra1,rb1,ra2,rb2) 
% RTP3D  Reduce a magnetic field anomaly map to the pole 
% using Fourier transform and specifying inclination and 
% declination of the field and magnetization
%  fin is input array
%  fout is output array
%
% usage: fout=rtp3d(fin,incl_fld,decl_fld,incl_mag,decl_mag)
%
%  PC-MATLAB
%  Maurice A. Tivey March 16 1992/ June 1994

i=sqrt(-1);  % complex i
rad=pi/180;  % conversion radians to degrees
mu=100;      % units to nT
format compact
if nargin < 1
 fprintf('DEMO MODE\n');
 help rtp3d
 f3d=syn3d;
 fout=rtp3d(f3d,46.3,-17.7,44.28,0);
 return
elseif nargin < 5
 fprintf('Reduce magnetic anomaly map to the pole\n');
 ra1=input('Enter field inclination ->');
 rb1=input('Enter field declination ->');
 ra2=input('Enter magn inclination ->');
 rb2=input('Enter magn declination ->');
end
%
ra1=ra1*rad;
rb1=rb1*rad;
ra2=ra2*rad;
rb2=rb2*rad;
 
 [ny,nx]=size(fin);
 ni=1/nx;
 nx2=nx/2;
 nx2plus=nx2+1;
 x=-.5:ni:.5-ni;
 ni=1/ny;
 ny2=ny/2;
 ny2plus=ny2+1;
 y=-.5:ni:.5-ni;

 X=ones(size(y))'*x;
 Y=y'*ones(size(x));
 k=2*pi*sqrt(X.^2+Y.^2);  % wavenumber array
%
%------ calculate geometric and amplitude factors
 Ob=(sin(ra1)+i*cos(ra1)*sin(atan2(Y,X)+rb1));
 Om=(sin(ra2)+i*cos(ra2)*sin(atan2(Y,X)+rb2));
 O=(Ob.*Om);
% alternate calculation
% O=phase3d(ra1,rb1,ra2,rb2,nx,ny);
%  O=O./abs(k.^2);
 
% calculate northpole phase
 ra1=90*rad;
 rb1=0;
 ONP=(sin(ra1)+i*cos(ra1)*sin(atan2(Y,X)+rb1));
 ONP=(ONP.*ONP);
% alternate calculation
% ONP=phase3d(90,0,90,0,nx,ny);
% ONP=ONP./abs(k.^2);

 amp=abs(O);       % amplitude factor
 phase=angle(O);   % phase angle 
 F=fft2(fin);
 F=fftshift(F)./O;
%------------------ INVERSE fft ----------------
 fout=ifft2(fftshift(F.*ONP));
%------------------ Plotting -------------------
% fscl=[0,nn,min(real(fin)),max(real(fin))];
% axis(fscl);
 subplot(221),contour(real(fout))
 title(' Deskewed Magnetic field')
% text(.9,.75,num2str(theta),'sc')
% text(.8,.75,'Theta=','sc')
subplot(222); im(phase); axis xy; title('Phase')
subplot(224); im(amp); axis xy; title('Amplitude')
  subplot(223)
 xlabel(' Distance ')
 ylabel(' Amplitude (nT)')
 contour(real(fin))
 title(' Original Magnetic Field')
% axis;
%  The End
