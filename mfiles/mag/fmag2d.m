function f2d=fmag2d(m2d,h,zobs,thick,dx)
% FMAG2D Calculate mag field given a magnetization and
%  a constant thickness layer using Parker's [1973] Fourier 
%  series summation approach. No phase shift applied.
% Usage:
%      f2d=fmag2d(m2d,h,zobs,thick,dx);
% where 
%    m2d : magnetization (A/m)
%    h : bathymetry (km +up)
%    zobs : observation level (km)
%    thick : layer thickness value (km)
%    dx : spacing of points (km)
% See syn2d and syn2da for more general versions
%---------------------------------------------------------
% Maurice A. Tivey MATLAB Version Sept 22 1994
% MAT Checked/fixed               Dec 17 1996
%

if nargin < 1
 help fmag2d
 % do a test flat layer model
 m2d=zeros(256,1);
 m2d(64:128)=m2d(64:128)+10;
 h=ones(size(m2d)).*(-4);
 thk=1; dx=.5; zobs=0;
 f2d=fmag2d(m2d,h,zobs,thk,dx);
 return
end

pl=0; % plot
if dx < 0,  % check if dx negative which is a flag to not plot
 dx=abs(dx);
 pl=1; % dont plot
end
 
format compact
% parameters defined
i=sqrt(-1);
rad=pi/180;  % conversion radians to degrees
mu=100;      % conversion factor to nT
nterms=20;
tol=1e-10;
%
fprintf('     2D PROFILE FORWARD MODEL\n');
fprintf('          FMAG2D\n');
fprintf('    Constant thickness layer\n\n');
fprintf('        RTP Version\n');
fprintf(' Maurice A. Tivey - Version: Dec 17 1996\n\n');
 nn=length(m2d);
 const=2*pi*mu;
% calculate base layer
 g=-(abs(h)+thick);
% shift zero level of bathy
 hmax=max(h);
 hmin=min(h);
 fprintf(' %10.3f %10.3f = MIN, MAX OBSERVED BATHY AND BASE\n',hmin,hmax);
 shift=max(h);
 hwiggl=abs(hmax-hmin)/2;
 zup=zobs-shift;
 fprintf(' SHIFT ZERO OF BATHY WILL BE %8.3f\n',shift);
 fprintf('THIS IS OPTIMUM FOR INVERSION.\n');
 fprintf('NOTE OBSERVATIONS ARE %8.3f KM ABOVE BATHY\n',zup);
 fprintf('ZOBS=%8.3f ZUP=%8.3f\n',zobs,zup);
 zup=zup+hwiggl;     
 fprintf('%8.3f = HWIGGL, DISTANCE TO MID-LINE OF BATHY\n',hwiggl);
 fprintf('THIS IS OPTIMUM ZERO LEVEL FOR FORWARD PROBLEM\n');
 h=h-shift;
 h=h+hwiggl;
%
 nn2=nn/2;
 n2plus=nn2+1;
 x=(1:nn)*dx-dx;
 dk=2*pi/(nn*dx);
% make wave number array
 k=1:n2plus;
 k=(k-1).*dk;
 K=k;
 K(n2plus+1:nn)=k(nn2:-1:2);
% do upcon term
 eterm=exp(-K.*zup);
% do constant thickness term
 alap=(1-exp(-K.*thick));
% phase term set to zero
 phase=exp(i*0*rad.*sign(nn2-(1:nn)));
% now do summing over nterms
 sum1=eterm'.*fft(m2d); % n=0 term
 last=0;
 for n=1:nterms,
  MH=fft(m2d.*(h.^n));
  sum=eterm'.*((K.^n)./nfac(n))'.*MH+sum1;
  errmax=max(abs( real(sum)+real(sum1)));
  fprintf(' AT TERM  %6.0f ',n);
  fprintf('MAXIMUM PERTURBATION TO SUM %12.5e\n',errmax-last);
  if n>1
%  if abs(errmax-last) < tol; break, end
  end
   last=errmax;
   sum1=sum;
 end
b=ifft(const*sum.*alap'.*phase');
f2d=real(b);
% restore bathy
 h=h+shift-hwiggl;
% plotting
if pl == 0,
 clf
% fscl=[0,max(x),min(f2d)-0.1*min(f2d),max(f2d)+0.1*max(f2d)];
% axis(fscl)
 subplot(211)
  plot(x,f2d),title('Calculated Magnetic Field')
 subplot(212)
  plot(x,h),title('Bathymetry')
  hold on
  plot(x,g)
  hold off
%  db=max(g)-min(g);
%  dh=max(h)-min(h);
%  bscl=[0,max(x),min(g)-db,max(h)+dh];
%  axis(bscl)
end
