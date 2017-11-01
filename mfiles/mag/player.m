function f=player(m2d,dx,top,bot,incl1,decl1,incl2,decl2,slin)
% PLAYER - Calculate the magnetic anomaly of a plane layer
%  using Fast Fourier transforms and linear filtering 
%  techniques after Schouten & McCamy, MGR [1971].
%  See PLAYER3D for map version
%
% Usage: 
%   f=player(m2d,dx,top,bot,incl1,decl1,incl2,decl2,slin)
%
%  m2d : input magnetization profile in A/m
%   dx : data spacing in km
% top/bot : top and bot of layer in km +ve down
% incl1/decl1 : inclination/declination of the field
% incl2/decl2 : inclination/declination of the remanence
% slin : strike of the magnetic lineations +ve cw from north
%      or the stike of the normal to the profile.  It is always
%      assumed that profile is perpendicular to the lineations
% If slin is +ve profile is north to south L to R
% If slin is -ve profile is south to north L to R
% 
%  f : output magnetic field in nT
%  If no input, user is prompted for data spacing, 
%  altitude, and directions of field and magnetization
%
%  Maurice A. Tivey September 10, 1991 PC-MATLAB
%  MAT jan 98 matlab 5

format compact
i=sqrt(-1);  % complex i
rad=pi/180;  % conversion radians to degrees

if nargin < 1
 help player
 % do a test model
 m2d=ones(256,1);
 m2d(64:128)=m2d(64:128)+10;
 dx=.5; top=4; bot=5;
 incl1=46.2173;incl2=44.2884;decl1=-18.061;decl2=0;slin=-20;
 f=player(m2d,dx,top,bot,incl1,decl1,incl2,decl2,slin);
 return
elseif nargin < 9
 dx=input(' Enter spacing of data points dx in km ->');
 top=input(' Enter top of source layer in km +down->');
 bot=input(' Enter bottom of source layer in km +down->');
 lat=input(' Enter latitude of profile -> ');
 incl1=atan(2/tan((90-lat)*rad))/rad;
 fprintf(' For reference the Geocentric Dipole inclination is %10.2f\n',incl1);
 incl1=input(' Enter field inclination ->');
 decl1=input(' Enter field declination ->');
 incl2=input(' Enter magnetization inclination ->');
 decl2=input(' Enter magnetization declination ->');
 disp('Enter angle of normal of profile')
 slin=input(' w.r.t magnetic meridian, +cw from N ->');
end

% check to make sure array is around the correct way
[nx,ny]=size(m2d);
if nx==1, m2d=m2d'; end

%------------ PARAMETERS ------------------------------
mu=100;      % conversion factor to nT
thick = bot-top;
%
%------ calculate geometric and amplitude factors
%
ra1=incl1*rad;
ra2=incl2*rad;
rb1=(decl1-slin)*rad;
rb2=(decl2-slin)*rad;
inclm=atan2(tan(ra2),sin(rb2)); % eff magnetization incl
inclf=atan2(tan(ra1),sin(rb1)); % eff magnetization incl
ampfac=((sin(ra2))*(sin(ra1)))/((sin(inclm))*(sin(inclf)))
theta=(inclm/rad)+(inclf/rad)-180.
const=ampfac*mu;
%
%------ assume magnetization profile is in array m2d
%
nn=length(m2d);
nn2=nn/2;
n2plus=nn2+1;
x=(0:nn-1)*dx;    % distance array
% compute wavenumber array
dk=2*pi/(nn*dx);
K=1:n2plus;
K=(K-1).*dk;
k=K;
k(n2plus+1:nn)=K(nn2:-1:2);
% another way
% k=kvalue(nx,dx);
% k=abs(k);

 M=fft(m2d);
% ----------------- UPCON & EARTH filter ---------------
 earth= 2*pi*(exp(-top*k)-exp(-bot*k));
 earth(nn:-1:n2plus)=earth(1:nn2);
%------------------ PHASE filter  --------------
 phase=exp(i*theta*rad.*sign(nn2-(1:nn)));
%------------------ INVERSE fft ----------------
 f=ifft(const*M.*earth'.*phase');
 f=real(f);
%------------------ Plotting -------------------
fldrng=(max(f)-min(f))/4;
fscl=[0,nn*dx,min(f)-fldrng,max(f)+fldrng];
magrng=(max(m2d)-min(m2d))/4;
magscl=[0,nn*dx,min(m2d)-magrng,max(m2d)+magrng];
clf
subplot(211)
 plot(x,f)
 axis(fscl);
 title(' Magnetic field')
 xlabel(' Distance (km)')
 ylabel(' Amplitude (nT)')
subplot(212)
 plot(x,m2d)
 axis(magscl);
 title(' Magnetization')
 ylabel(' Amplitude (A/m)')
 xlabel(' Distance (km)')

