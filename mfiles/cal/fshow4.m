% FSHOW4         
%  Matlab routine to show calibration of total field
%  after:
%  1) calculating permanent field offsets with minimization field.m
%  2) calculating induced field effects with curve2.m
%  3) calculating quadrupole effects with curve3.m
%  4) calculate multipole effects with curve4
%
%  M.A.Tivey Jul 8, 2001
% 
format compact
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
subplot(241)
 plot(tf,'r'),title('Minimization of Total Field')
 ylabel('Mag. Fld. (x1000 nT)')
 oscl=axis;
hold on
plot(tf2,'b')
grid on
hold
subplot(245)
 plot(tf2,'b')
 grid on
 ylabel('Mag. Fld. (x1000 nT)')
 title('Corrected Total Field')
 scl=axis;
 nn=scl(2);
 ymax=(scl(4)-scl(3));
 ymin=scl(3);
 pt=text(nn*0.75,ymax*0.35+ymin,'xdc=')
 set(pt,'FontSize',[8])
 pt=text(nn*0.85,ymax*0.35+ymin,num2str(xnew(1)));
 set(pt,'FontSize',[8])
 pt=text(nn*0.75,ymax*0.25+ymin,'ydc=')
 set(pt,'FontSize',[8])
 pt=text(nn*0.85,ymax*0.25+ymin,num2str(xnew(2)));
 set(pt,'FontSize',[8])
 pt=text(nn*0.75,ymax*0.15+ymin,'zdc=')
 set(pt,'FontSize',[8])
 pt=text(nn*0.85,ymax*0.15+ymin,num2str(xnew(3)));
 set(pt,'FontSize',[8])
% Calculate the magnitude of the vector relative to sub
 degrad=pi/180;
 tdc=sqrt(xdc.^2+ydc.^2+zdc.^2);
 incl=asin(xdc/tdc)./degrad
 decl=atan(ydc./zdc)./degrad
%
subplot(242)
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
 pt=text(400,0.95*yrng+yax(3),['decl = ' num2str(lam(2)) '  ' ]);
 set(pt,'FontSize',[8])
 pt=text(100,0.15*yrng+yax(3),['err norm = ' num2str(f)]);
 set(pt,'FontSize',[8])
 grid on
 hold off
 title('Induced field effect fit')
 ylabel('Mag. Fld. (x1000 nT)')
 xlabel('Heading (degrees)')
%
subplot(246)
 plot(tf,'r')
 title('Perm. + Ind. Field Correction')
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
 %
subplot(243)
 c3=lam3(1)*cos((3*hdg-lam3(2)).*pi/180);
 f=sum((tfm-c-c3).^2);
 xt = max(hdg*3)/2;
 yt = max(tfm-c);
 plot(3*hdg,tfm-c,'+')
 hold on
 plot(3*hdg,c3,'og')
 yax=axis;
 yrng=yax(4)-yax(3);
 pt=text(50,0.95*yrng+yax(3),['rng = ' num2str(lam3(1)) '  ' ]);
 set(pt,'FontSize',[8])
 pt=text(800,0.95*yrng+yax(3),['decl = ' num2str(lam3(2)) '  ' ]);
 set(pt,'FontSize',[8])
 pt=text(100,0.15*yrng+yax(3),['err norm = ' num2str(f)]);
 set(pt,'FontSize',[8])
grid on
hold off
title('Quadrupole field effect')
ylabel('Mag. Fld. (x1000 nT)')
xlabel('Heading (degrees)')

subplot(247)
 plot(tf,'r')
 title('Perm. + Ind. + quadrupole Correction')
 hold on
 plot(tf2-c-c3,'g')
 grid on
 hold off
 rmserr_orig=sqrt((max(tf)-min(tf)).^2);
 rmserr_corr=sqrt((max(tf2-c-c3)-min(tf2-c-c3)).^2);
 ymax=oscl(4)-oscl(3);
 ymin=oscl(3);
 pt=text(nn*0.05,ymax*0.85+ymin,['RMSerr orig = ' num2str(rmserr_orig) ' ']);
 set(pt,'FontSize',[8])
 pt=text(nn*0.05,ymax*0.1+ymin,['RMSerr corr = ' num2str(rmserr_corr) ' ']);
 set(pt,'FontSize',[8])
%
subplot(244)
 c4=lam4(1)*cos((4*hdg-lam4(2)).*pi/180);
 f=sum((tfm-c-c3-c4).^2);
 xt = max(hdg*4)/2;
 yt = max(tfm-c-c3);
 plot(4*hdg,tfm-c-c3,'+')
 hold on
 plot(4*hdg,c4,'og')
 yax=axis;
 yrng=yax(4)-yax(3);
 pt=text(50,0.95*yrng+yax(3),['rng = ' num2str(lam3(1)) '  ' ]);
 set(pt,'FontSize',[8])
 pt=text(800,0.95*yrng+yax(3),['decl = ' num2str(lam3(2)) '  ' ]);
 set(pt,'FontSize',[8])
 pt=text(100,0.15*yrng+yax(3),['err norm = ' num2str(f)]);
 set(pt,'FontSize',[8])
 grid on
 hold off
 title('Multipole field effect')
 ylabel('Mag. Fld. (x1000 nT)')
 xlabel('Heading (degrees)')
%
subplot(248)
 plot(tf,'r');hold on;plot(tf2-c-c3-c4,'g')
 title('Multi-pole Correction')
 grid on;hold off;
 rmserr_orig=sqrt((max(tf)-min(tf)).^2);
 rmserr_corr=sqrt((max(tf2-c-c3-c4)-min(tf2-c-c3-c4)).^2);
 ymax=oscl(4)-oscl(3);
 ymin=oscl(3);
 pt=text(nn*0.05,ymax*0.85+ymin,['RMSerr orig = ' num2str(rmserr_orig) ' ']);
 set(pt,'FontSize',[8])
 pt=text(nn*0.05,ymax*0.1+ymin,['RMSerr corr = ' num2str(rmserr_corr) ' ']);
 set(pt,'FontSize',[8])

 % The End
