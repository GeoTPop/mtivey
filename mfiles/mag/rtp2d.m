function fout=rtp2d(fin,theta,ampfac,pl) 
% RTP2D - Reduce magnetic anomaly profile to the pole
% given the phase angle (theta) of the observed profile
% see nskew for calculating phase angle
%
% Usage: fout=rtp2d(fin,theta,ampfac,pl)
%
%  fin   : input profile
%  theta : skew angle (degrees) of observed profile
% ampfac : amplitude factor
%  pl    : plot flag 0 to plot , 1 no plotting
%   fout : deskewed output profile
%
% Maurice A. Tivey Feb 8 1993 MATLAB
% MATLAB V5 jan 1999
% Nov 1999 correct for mean value of field thru the fft
%
clf
i=sqrt(-1);  % complex i
rad=pi/180;  % conversion radians to degrees
%
fprintf('          RTP2D\n');
fprintf('Reduce anomaly to the pole\n');
fprintf('Deskew anomaly by %10.1f degrees \n',theta);
 nn=length(fin);
 nn2=nn/2;
 meanfld=mean(fin);
 fprintf('Remove mean value %10.1f from input anomaly\n',meanfld);
 M=fft(fin-meanfld);
%------------------ PHASE filter  --------------
 phase=exp(i*theta*rad.*sign(nn2-(1:nn)));
%------------------ INVERSE fft ----------------
 fout=ifft(M./(ampfac.*phase)');
 fout=real(fout)+meanfld;
 fprintf('Mean value added to result\n');
%------------------ Plotting -------------------
if pl == 0,
 fscl=[0,nn,min(real(fin)),max(real(fin))];
 axis(fscl);
 subplot(211),plot(real(fout))
 title(' Magnetic field - Reduced to the Pole')
 ylabel('Magnetic Field (nT)')
 subplot(212),plot(real(fin))
 title(' Original Magnetic Field')
 text(.7,.35,['Theta= ',num2str(theta)],'sc')
 text(.7,.25,['Ampfac= ',num2str(ampfac)],'sc')
 xlabel(' Distance ')
 ylabel('Magnetic Field (nT)')
 axis;
end
%  The End
