% fshow - plot results of mag calibration        
%  Matlab routine to compare total field
%  after calculating field offsets
%  with minimization technique in field.m 
%  M.A.Tivey June 8, 1990
% 
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
subplot(211),plot(tf,'r'),title('Calibration: Minimization of Total Field')
ylabel('Magnetic Field x1000 nT')
hold on
plot(tf2,'b')
so=rmsdif(tf);
s=rmsdif(tf2);
text(0.68,0.40,['orig. maxmin:',num2str((max(tf)-min(tf))/2)],'sc')
text(0.68,0.30,['corr. maxmin:',num2str((max(tf2)-min(tf2))/2)],'sc')
text(0.7,0.10,['corr. rms: ',num2str(s(2))],'sc')
text(0.7,0.20,['orig. rms: ',num2str(so(2))],'sc')
hold off
subplot(212)
plot(tf2,'b'),title('Corrected Total Field')
ylabel('Magnetic Field x1000 nT')
text(0.05,0.30,['xdc= ',num2str(xnew(1))],'sc')
text(0.05,0.20,['ydc= ',num2str(xnew(2))],'sc')
text(0.05,0.10,['zdc= ',num2str(xnew(3))],'sc')
% The End
