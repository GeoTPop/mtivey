function f = curve2(lam)
% CURVE2 is used to fit a two-alpha cosine curve to 
% heading data vs total field fluxgate data. Simulates a
% dipolar or induced contribution.  Assumes a function of the form:
%
%    c=lam(1)*cos((2*hdg-lam(2)).*pi/180);
%     corrected_f=observed_f - c;
%
% Set the following options to limit iterations:
%  OPTIONS(1)-Display parameter (Default:0). 1 displays some results
%  OPTIONS(2)-Termination tolerance for X.(Default: 1e-4).
%  OPTIONS(3)-Termination tolerance on F.(Default: 1e-4).
%  OPTIONS(14)-Maximum number of iterations. (Default 100*no. of variables)
%
%  where lam(2) is the declination angle
%  and   lam(1) is the multiplication factor
%
% Usage: lam=fmins('curve2',lam)
% loads junk2.mat which has tf2 and hdg arrays
 tf=0;
load junk2
% tf=tf2;
if exist('tfoff') == 0
% need to normalize somehow. There are various ways
% so pick your favorite
% method 1 : balance on midway between max and min
 tfmax=max(tf2);
 tfmin=min(tf2);
 tfrng=(tfmax-tfmin)/2;
 tfoff=tfmin+tfrng;
 tf=tf2-tfoff;

% method 2 : trend
% tf=detrend(tf2);

% method 3 : remove mean
%tf=tf-mean(tf);
else
 tf=tf2-tfoff;
end

hdg=2.*hdg;
 
 % compute cosine function
  c=lam(1)*cos((hdg-lam(2)).*pi/180);
% norm is sqrt of squares of residuals
 f = norm(tf-c);  
% alternatively sum of squares of residuals
% f=sum((tf-c).^2);  

% Statements to plot progress of fitting:
xt = max(hdg)*.8;
mtf = max(tf2-tfoff); ltf=min(tf2-tfoff);
rng= mtf-ltf;
ax=[0 800 ltf-0.1*rng mtf+0.1*rng];
yt=ax(4)-ax(3);
plot(hdg,tf2-tfoff,'bo',hdg, [c],'r+','EraseMode','xor')
axis(ax)
text(600,ax(3)+0.85*yt,['decl = ' num2str(lam(2)) ' '])
text(600,ax(3)+0.96*yt,['rng = ' num2str(lam(1)) ' '])
text(600,ax(3)+0.77*yt,['err norm = ' num2str(f)])
text(600,ax(3)+0.68*yt,['offset = ' num2str(tfoff)])
xlabel('Heading');
ylabel('Magnetic field');
title('CALIBRATION : 2*COSINE HEADING FUNCTION');
drawnow
 