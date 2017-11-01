function pol_id(yval,GTSname,vflag)
% plot identification of polarity timescale
% on a plot
% Usage:    pol_id(yval,GTSname,vflag)
%  yval : level at which text will be plotted eg -10 A/m
%  GTSname : timescale name see gpts for timescale names
%  vflag : 1 to plot vertical axis 0 or blank for horizontal
%
% Maurice A. Tivey Jan 1995
% Modified for MATLAB5 July 1999
% Mod for mseries anoms May 2000
% see pol_idx for plotting vs distance
 
if nargin > 1 
 eval(GTSname) 
 fprintf('Use defined timescale :');
else
 magrev      % load default timescale
 fprintf('Use magrev default timescale :');
 vflag=0;
end
disp(GTS_name);

hold on   % set hold on for current figure
% yval=-10;
 txtang=90;
 txtsiz=8;
% check for cell structure MATLAB5
if iscell(GTS) == 1,
 gts=cat(2,[GTS{:,1};GTS{:,2}]); 
 gts=gts';
else
 if min(size(GTS)) > 2,
  gts=abs(GTS(:,1:2)); % convert to numbers
 end
end

% double up timescale for -ve times
 nk=length(gts);
 bigGTS(1:nk,1)=-gts(nk:-1:1,2);
 bigGTS(1:nk,2)=-gts(nk:-1:1,1);
 bigGTS(nk+1:2*nk,:)=gts;
 gts=bigGTS;
 clear bigGTS
%
 big=GTS(nk:-1:1,3);
 big(nk+1:2*nk)=GTS(1:nk,3);
nlen=length(gts);
axscl=axis;      % get current axis values

if vflag==1, % plot vertically
 nstart=max(find(gts(:,1)<axscl(3)))+1;
 nend=min(find(gts(:,2)>axscl(4)));
 if isempty(nend);nend=length(gts);end;
 for i=nstart:nend-1
    if abs(gts(i,1)) > 120, % test for M series
       h=text(yval,(gts(i+1,1)-gts(i,2))/2+gts(i,2),big{i});
    else
       h=text(yval,(gts(i,2)-gts(i,1))/2+gts(i,1),big{i});
    end
  set(h,'Rotation',0,'Fontsize',txtsiz);
 end
else % horizontal  
 nstart=max(find(gts(:,1)<axscl(1)))+1;
 nend=min(find(gts(:,2)>axscl(2)));
 if isempty(nend);nend=length(gts);end;
 for i=nstart:nend-1
    if abs(gts(i,1)) > 120, % test for M series
      h=text((gts(i+1,1)-gts(i,2))/2+gts(i,2),yval,big{i});
    else
      h=text((gts(i,2)-gts(i,1))/2+gts(i,1),yval,big{i});
    end    
    set(h,'Rotation',txtang,'Fontsize',txtsiz);
 end
end
hold off
