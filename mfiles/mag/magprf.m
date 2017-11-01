function m2d=magprf(v,start,stop,dx,GTSn)
% MAGPRF Make a magnetization profile using the  
%  Geomagnetic Polarity Timescale.  User is prompted
%  for spreading half rate, start and stop of profile
%  in Ma, and sample interval in km.
%  Routine will load the timescale defined as the 
%  input file called "magrev.m"
%  Examples of timescales included
%   CK92.M : Cande & Kent 1992
%   KG86.M : Kent & Gradstein, 1986
%   LH75.M : Larson & Hilde, 1975
%   KG88.M : Composite scale KG86 + LH75
%   CK92ALL.M : Composite CK92+LH75+Handschumacher88
%   WEI95ALL.M : Wei et al., GRL 1995 Composite+LH75+Handschumacher88
%   CK95ALL.M : Composite CK95+LH75+Handschumacher88 (Default)
%   CHAMPMOD.M : short events within Brunhes adjusted timescale
%                from Champion et al., 1988.
%   WORM97.M : short events within Brunhes 
%
%  Usage: m2d=magprf(hsr,start_time,stop_time,dx);
% to use a different timescale than default:
%    m2d=magprf(hsr,start_time,stop_time,dx,GTSname);
%
% where hsr is the half spreading rate in km/Ma
% and start and stop time are are in millions of years
% dx is desired data spacing in km
% optional GTSname should be in quotes
%
% Maurice A. Tivey Mar 18, 1992
% Mod for MATLAB5  May 1997
%                  Dec 1997 fix for border
%                  Jun 1999 add GTSname input
%

format compact
disp('                MAGPRF');
disp('      MAKE A MAGNETIZATION PROFILE ');
disp('       Magnetic Anomaly Modelling ');

if nargin > 4 
 eval(GTSn) 
 fprintf('Use defined timescale: %s\n',GTS_name);
else
 magrev      % load default timescale
 fprintf('Use magrev default timescale: %s\n',GTS_name);
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

disp('     Maurice A. Tivey - March 18, 1992 ');
disp(' ');
if nargin < 1
 v=input(' Enter spreading halfrate in km/MY -> ');
 start=input(' Enter start time of profile in MY -> ');
 stop= input(' Enter stop time of profile in MY  -> ');
 dx=input(' Enter sample interval in km ');
end
dt=dx/v;
npts= (stop-start)/dt+1   % find number of points
 for ip=1:16,           % make number of points a power of 2
    nn=2^ip;
    if nn >= npts, break;
    end
 end
 nn
 nn2=nn/2;
 n2plus=nn2+1;
% double up timescale for -ve times
 nk=length(GTS);
 bigGTS(1:nk,1)=-GTS(nk:-1:1,2);
 bigGTS(1:nk,2)=-GTS(nk:-1:1,1);
 bigGTS(nk+1:2*nk,:)=GTS;
 GTS=bigGTS;
 clear bigGTS
% create and initialize the magnetization array
% make magnetization amplitude 10 A/m
    m2d=ones(1,nn).*(-10);
    i=1;
%
% first loop to find starting indices
if start == 0
 i=1
 iend=min(find( GTS(:,2) > stop)) 
else 
 i=min(find( GTS(:,2) > start)) 
 iend=min(find( GTS(:,2) > stop)) 
end
disp('going through data')
% now go through the data
j=0;
time=start;
%while GTS(i,1) < stop
while i ~= iend
   while time < GTS(i,2)
     j=j+1;
     m2d(j)=10;
     if time < GTS(i,1)  % small correction
      m2d(j)=-m2d(j);    % for start of epoch
     end		 % less than start time
     time=time+dt;
   end
   i=i+1;
   while time < GTS(i,1)
     time=time+dt;
     j=j+1;
   end
end
clf
m2d=m2d';
% make a timescale
 x=(1:nn).*dx-dx;
 t=(0:(nn-1)).*dt+start;
 size(t)
 if length(m2d)>length(t), 
  disp('error in length of m2d');
  disp('try setting stop age less than 167');
 else
 ix0=find( abs(t) == min(abs(t)) )
 x(ix0)
 x=x-x(ix0);
 % fix border of magnetization to match first value
 m2d(npts+1:nn)=m2d(npts+1:nn).*0+m2d(1);
subplot(211)
plot(t,m2d)
title(' Magnetization Profile')
ylabel(' Magnetization A/m')
xlabel('Time Ma')
axis([start,stop,-40,40]);
subplot(212)
plot(x,m2d)
axis([x(1),x(nn),-40,40]);
xlabel('Distance (km)')
axis;
end
% The End
