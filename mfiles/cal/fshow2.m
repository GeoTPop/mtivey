% FSHOW2         
%  Matlab routine to compare calcibration of
%  total field after calculating field offsets
%  with minimization technique in field.m and
%  an induced field effect with curve2.m
%  see fshow and fshowall
%  M.A.Tivey June 8, 1990
% 
format compact
if exist('xnew') == 0
   fprintf('Error xnew array of cal factors does not exist')
   return
end
nsize=length(xnew) 
% xnew is array with offsets computed by field and fmins
	xdc=xnew(1);
	ydc=xnew(2);
	zdc=xnew(3);
if nsize > 3
	xcf=xnew(4);
	ycf=xnew(5);
	zcf=xnew(6);
else
	xcf=1;
	ycf=1;
	zcf=1;
end
clf
% apply the computed offsets to the data
tf2=sqrt(((xf-xdc).*xcf).^2+((yf-ydc).*ycf).^2+((zf-zdc).*zcf).^2);
subplot(221)
 plot(tf,'r'),title('Minimization of Total Field')
 ylabel('Mag. Fld. (x1000 nT)')
 oscl=axis;
hold on
plot(tf2,'b')
grid on
hold
subplot(223)
plot(tf2,'b')
grid on
ylabel('Mag. Fld. (x1000 nT)')
title('Corrected Total Field')
scl=axis;
nn=scl(2);
ymax=(scl(4)-scl(3));
ymin=scl(3);
pt=text(nn*0.05,ymax*0.35+ymin,'xdc=')
set(pt,'FontSize',[8])
pt=text(nn*0.15,ymax*0.35+ymin,num2str(xnew(1)));
set(pt,'FontSize',[8])
pt=text(nn*0.05,ymax*0.25+ymin,'ydc=')
set(pt,'FontSize',[8])
pt=text(nn*0.15,ymax*0.25+ymin,num2str(xnew(2)));
set(pt,'FontSize',[8])
pt=text(nn*0.05,ymax*0.15+ymin,'zdc=')
set(pt,'FontSize',[8])
pt=text(nn*0.15,ymax*0.15+ymin,num2str(xnew(3)));
set(pt,'FontSize',[8])
% Calculate the magnitude of the vector relative to sub
degrad=pi/180;
tdc=sqrt(xdc.^2+ydc.^2+zdc.^2);
incl=asin(xdc/tdc)./degrad
decl=atan(ydc./zdc)./degrad
subplot(222)
%
tfm=detrend(tf2);
c=lam(1)*cos((2*hdg-lam(2)).*pi/180);
f=sum((tfm-c).^2);
xt = max(hdg*2)/2;
yt = max(tfm);
plot(2*hdg,tfm,'+')
hold on
plot(2*hdg,c,'og')
yax=axis;
yrng=yax(4)-yax(3);
pt=text(50,0.95*yrng+yax(3),['rng = ' num2str(lam(1)) '  ' ]);
set(pt,'FontSize',[8])
pt=text(50,0.85*yrng+yax(3),['decl = ' num2str(lam(2)) '  ' ]);
set(pt,'FontSize',[8])
pt=text(50,0.15*yrng+yax(3),['err norm = ' num2str(f)]);
set(pt,'FontSize',[8])
grid on
hold off
title('Induced field effect fit')
ylabel('Mag. Fld. (x1000 nT)')
xlabel('Heading (degrees)')
subplot(224)
 plot(tf,'r')
 title('Perm. + Ind. Field Correction of Total field')
 hold on
 plot(tf2-c,'g')
 grid on
 hold off
 rmserr_orig=sqrt((max(tf)-min(tf)).^2);
 rmserr_corr=sqrt((max(tf2-c)-min(tf2-c)).^2);
 ymax=oscl(4)-oscl(3);
 ymin=oscl(3);
 pt=text(nn*0.05,ymax*0.85+ymin,['RMSerr orig = ' num2str(rmserr_orig) ' ']);
 set(pt,'FontSize',[8])
 pt=text(nn*0.05,ymax*0.1+ymin,['RMSerr corr = ' num2str(rmserr_corr) ' ']);
 set(pt,'FontSize',[8])
% The End
