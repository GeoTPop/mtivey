function timescl(hi,lo)
% timescl
% plot a geomagnetic timescale on top of
% any plot
%
% Usage: timescl(hi,lo)
%
% where hi lo are yaxis values for mag scale
% and GTS is the geomagnetic timescale

magrev % load time scale
if min(size(GTS)) > 2,
 GTS=abs(GTS(:,1:2)); % convert to numbers
end
% first double up timescale for +ve and -ve time
 nk=length(GTS);
 bigGTS(1:nk,1)=-GTS(nk:-1:1,2);  % to index 2 to remove zero age
 bigGTS(1:nk,2)=-GTS(nk:-1:1,1);
 bigGTS(nk+1:2*nk,:)=GTS(1:nk,:);
 GTS=bigGTS;
 clear bigGTS
nrev=length(GTS);
ymag=[hi,hi,lo,lo];
fill([GTS(1,1),GTS(1,2),GTS(1,2),GTS(1,1)],ymag,'w');
hold on
for i=2:nrev-1,
 fill([GTS(i,1),GTS(i,2),GTS(i,2),GTS(i,1)],ymag,'w')
end
plot([GTS(1,1),GTS(nrev,1)],[lo,lo],'w')
plot([GTS(1,1),GTS(nrev,1)],[hi,hi],'w')
hold off