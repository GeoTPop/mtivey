function GTS=gts2gmt(hsr,hi,lo,GTSname)
% gts2gmt
% create a geomagnetic timescale in distance
% Can be used to output to an
% ascii file for gmt plotting
%
% Usage: gts=gts2gmt(hsr,hi,lo)
% you can also define the timescale name to load
%  gts=gts2gmt(hsr,hi,lo,GTSname)
%
% where hsr is the half spreading rate in km/Ma
% and hi lo are yaxis values for mag scale
% GTSname should be in quotes
%
% Maurice A. Tivey  
% MATLAB5  Nov 1998
%          Jun 1999 Mod for GTS

if nargin > 3 
 eval(GTSname) 
 fprintf('Use defined timescale %s\n',GTS_name);
else
 magrev      % load default timescale
 fprintf('Use magrev default timescale %s\n',GTS_name);
end
 
% check for cell structure MATLAB5
if iscell(GTS) == 1,
 gts=cat(2,[GTS{:,1};GTS{:,2}]); 
 clear GTS
 GTS=gts';
else
 if min(size(GTS)) > 2,
  GTS=abs(GTS(:,1:2)); % convert to numbers
 end
end
format compact
% first double up timescale for +ve and -ve time
 nk=length(GTS);
 bigGTS(1:nk,1)=-GTS(nk:-1:1,2);  % to index 2 to remove zero age
 bigGTS(1:nk,2)=-GTS(nk:-1:1,1);
 bigGTS(nk+1:2*nk,:)=GTS(1:nk,:);
 GTS=bigGTS;
 clear bigGTS
nrev=length(GTS);
ymag=[hi,hi,lo,lo];
% now convert to distance
GTS=GTS.*hsr;

%fname='testpol.ll';
%  
%fprintf(fname,'%15.7f %15.7f\n',GTS(1,1),ymag(1));
%fprintf(fname,'%15.7f %15.7f\n',GTS(1,2),ymag(2));
%fprintf(fname,'%15.7f %15.7f\n',GTS(1,2),ymag(3));
%%fprintf(fname,'%15.7f %15.7f\n',GTS(1,1),ymag(1));
%fprintf(fname,'>\n');
%for i=2:nrev-1,
% fprintf(fname,'%15.7f %15.7f\n',GTS(i,1),ymag(1));
% fprintf(fname,'%15.7f %15.7f\n',GTS(i,2),ymag(2));
% fprintf(fname,'%15.7f %15.7f\n',GTS(i,2),ymag(3));
% fprintf(fname,'>\n');
%end

 
