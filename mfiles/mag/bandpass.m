function wts=bandpass(nn,dx,wlong,wshort)
% BANDPASS  Construct a bandpass filter in the F-domain   
% Usage: wts=bandpass(nn,dx,wlong,wshort)               
% nn = number of points in array                        
% dx = data spacing (km)                                
% wlong = short wavelength cutoff (km)                  
% wshort = long wavelength cutoff (km)                 
% wts = output bandpass filter in Fourier-domain         
% STEFAN A. HUSSENOEDER 5/10/96

 nn2=nn/2;
 nk=2*pi*(nn2-1)/(nn*dx);
 dk=2*pi/(nn);
 k=(nn2:-1:-(nn2-1)).*dk;
 k=abs(k);
%
%  nyquist wavelength 2*dx
%  nyquist wavenumber = (2*pi)/(2*dx)
%  long wavelength cutoff = (nn-1)*dx
%  wavenumber cutoff (2*pi)/((nn-1)*dx)

% cutoff low frequencies
if wlong == 0,
	wlong=nn*dx*4;
end
% cutoff high frequencies
if wshort == 0
	wshort=2*dx;
end
disp(' Calculate record harmonics')
n4=ceil(2*pi/(dk*wshort/dx));
n1=round(2*pi/(dk*wlong/dx)); 
%n1=round(2*pi/(dk*wlong/dx))+1;  % **** ADDED 1
n2=2*n1;
n3=floor(0.5*n4);
if n3 <= n2, n3=n2+1; end
if n4 <= n3, n4=n3+1; end
if n1 == 0, n1=1; end
if n2 == 0, n2=2; end
fprintf(' WTS N1 N2 N3 N4 : %6.0f %6.0f',n1,n2);
fprintf(' %6.0f %6.0f\n',n3,n4);
% set B filter = 0.
B=zeros(nn2,1);
B(n2:n3)=B(n2:n3)+1;
B(n1:n2)=(1-cos( pi/(n2-n1)*((n1:n2)-n1) ) )/2;
B(n3:n4)=(1-cos( pi/(n4-n3)*((n3:n4)-n4) ) )/2;
wts(1:nn2)=B(nn2:-1:1);     
wts(nn2+1:nn)=B;

% subplot(211)
% plot(B(1:nn2/2)),title('Bandpass Filter')
% subplot(212)
% plot(wts)
% pause(5)
%   SHOW SPECTRUM OF FIELD  
      CAY1=(n1-1)*dk/dx;
      CAY2=(n2-1)*dk/dx;
      CAY3=(n3-1)*dk/dx;
      CAY4=(n4-1)*dk/dx;
fprintf('WAVENUMBERS (1/KM) . . . \n');
fprintf(' HIPASS TAPER FROM %12.4f TO %12.4f\n',CAY1,CAY2);
fprintf(' LOPASS TAPER FROM %12.4f TO %12.4f\n',CAY3,CAY4);
      if CAY1 <= 0., CAY1=0.000001; end
      CAY1=2*pi/CAY1;
      CAY2=2*pi/CAY2;
      CAY3=2*pi/CAY3;
      CAY4=2*pi/CAY4;
%
fprintf('WAVELENGTHS (KM) . . . \n');
fprintf(' HIPASS TAPER FROM %12.4f TO %12.4f\n',CAY1,CAY2); 
fprintf(' LOPASS TAPER FROM %12.4f TO %12.4f\n',CAY3,CAY4);
fprintf('RECORD HARMONIC NUMBERS . . . \n');
fprintf(' HIPASS TAPER FROM  %6.0f TO %6.0f\n',n1,n2);
fprintf(' LOPASS TAPER FROM  %6.0f TO %6.0f\n',n3,n4);
