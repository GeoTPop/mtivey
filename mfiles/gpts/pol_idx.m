function pol_idx(hsr,yval,vflag)
% plot identification of polarity timescale
% on a plot vs distance from axis.
%
% Usage:    pol_id(hsr,yval)
%   hsr : is the half spreading rate in km/Ma
%  yval : is level at which text will be
%         plotted eg -10 A/m
%  vflag : 1 to plot vertical axis, 0 or blank for horizontal
% loads a timescale if it already exists otherwise use default
% in magrev
% Maurice A. Tivey Sep 1998
%  MATLAB5
% see pol_id for time axis plot.

 hold on   % set hold on for current figure
 
% yval=-10;
 txtang=90;
 txtsiz=8;
% load time scale if it doesn't already exist
if exist('GTS','var')==0
   fprintf('Use magrev default timescale :');
   magrev 
end
if iscell(GTS) == 1,
 gts=cat(2,[GTS{:,1};GTS{:,2}]); 
 gts=gts';
end
% double up timescale for -ve times
 nk=length(gts);
 bigGTS(1:nk,1)=-gts(nk:-1:1,2);
 bigGTS(1:nk,2)=-gts(nk:-1:1,1);
 bigGTS(nk+1:2*nk,:)=gts;
 gts=bigGTS;
% now convert to distance
 gts=gts.*hsr;

%
 big=GTS(nk:-1:1,3);
 big(nk+1:330)=GTS(1:nk,3);
% gts=abs(GTS(:,1:2)); % convert first two columns to numbers
% recover the negative sign
% ii=find(gts(:,2)==0);
% gts(1:ii,:)=-gts(1:ii,:);
%
nlen=length(gts);
axscl=axis;      % get current axis values
if vflag==1, % plot vertically
 nstart=max(find(gts(:,1)<axscl(3)))+1;
 nend=min(find(gts(:,2)>axscl(4)));
 if isempty(nend);nend=length(gts);end;
 for i=nstart:nend
  h=text(yval,(gts(i,2)-gts(i,1))/2+gts(i,1),big{i});
  set(h,'Rotation',0,'Fontsize',txtsiz);
 end
else % horizontal  
 nstart=max(find(gts(:,1)<axscl(1)))+1;
 nend=min(find(gts(:,2)>axscl(2)));
 if isempty(nend);nend=length(gts);end;
 for i=nstart:nend
  h=text((gts(i,2)-gts(i,1))/2+gts(i,1),yval,big{i});
  set(h,'Rotation',txtang,'Fontsize',txtsiz);
 end
end
hold off
