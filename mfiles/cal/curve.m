function f = curve(lam)
% CURVE is used to fit cosine curve to heading data
% vs total field fluxgate data.  Simulates a
% permanent field contribution.  Assumes a function of 
% the form: 
%
%    c=lam(1)*cos((hdg-lam(2)).*pi/180);
%     corrected_f=observed_f - c;
%
% Set the following options to limit iterations:
%  OPTIONS(1)-Display parameter (Default:0). 1 displays some results
%  OPTIONS(2)-Termination tolerance for X.(Default: 1e-4).
%  OPTIONS(3)-Termination tolerance on F.(Default: 1e-4).
%  OPTIONS(14)-Maximum number of iterations. (Default 100*no. of variables)
%
%  where lam(2)=declination angle
%        lam(1)= scale factor
% use:
%     lam=fmins('curve',lam)
% loads junk.mat which has tf and hdg arrays

 tf=0; % pre-initialize tf to make sure it is 
       % a variable not tf.m

load junk
 tf2=tf;
if exist('tfoff') == 0
% need to normalize somehow. There are various ways
% so pick your favorite
% method 1 : balance on midway between max and min
 xrng=(max(tf2)-min(tf2))/2;
 xoff=min(tf2)+xrng;
% method 2 : trend
% tf2=detrend(tf);

% method 3 : remove mean
%tf2=tf-mean(tf);
else
 xoff=tfoff;
end

% cosine function fit
% version 1
%  
 c=lam(1)*cos((hdg-lam(2)).*pi/180)+xoff;

% version 2
%c=lam(1)*cos((hdg-lam(2)).*pi/180);

% estimate goodness of fit
   dif=abs(tf2-c);
   s1=sum(dif);
   s2=sum(dif.*dif);
   avg=s1/length(tf2);
   rms=sqrt(s2/length(tf2) - avg^2);
% rms difference
  f=rms ;   
% mean difference
 % f=avg;  
% maximum singular value difference
 % f = norm(tf2-c);   

% Statements to plot progress of fitting:
xt = 270;
mtf = max(tf2); ltf=min(tf2);
rng= mtf-ltf;
ax=[0 360 ltf-0.1*rng mtf+0.1*rng];
yt=ax(4)-ax(3);
 
plot(hdg,[tf2],'bo',hdg, [c],'r+','EraseMode','xor')
axis(ax)
text(xt,ax(3)+0.90*yt,['decl = ' num2str(lam(2)) '  ' ])
text(xt,ax(3)+0.96*yt,['rng = ' num2str(lam(1)) '  ' ])
text(xt,ax(3)+0.85*yt,['err norm = ' num2str(f)])
text(xt,ax(3)+0.80*yt,['offset = ' num2str(xoff)])
xlabel('Heading');ylabel('Magnetic field');
title('CALIBRATION : COSINE HEADING FUNCTION')
drawnow

   

