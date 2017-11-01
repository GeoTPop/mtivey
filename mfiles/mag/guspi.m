function [gold,up]=guspi(f2d,fdp,dx,wl,ws,zlev,OPT)
% GUSPI Frequency domain reduction of potential fields
% to a horizontal plane.  Upward continuation using an 
% iterative fast fourier transform to reduce magnetic 
% measurements made on an uneven surface to a level plane.
% Guspi, Geoexploration, 24, 87-98, 1987.
%
% Usage: 
%   [gold,up]=guspi(f2d,fdp,dx,wl,ws,zlev,OPT);
%
% Parameters
%     f2d : input magnetic field (nT)
%     fdp : input observation depth (km +ve up)
%      dx : input data spacing (km)
%   wl,ws : long,short wavelength cutoff (km) 0 for default
%    zlev : required upward continuation level  (km)
%     OPT : optional convergence parameters [nitrs,nterms,gtol,tol] [40,40,001,.001]
% Output:
%    gold : magnetic field at Guspi reduction level zref (nT)
%      up : upward continued magnetic field at required zlev (nT)
%
% Maurice A. Tivey 9 Mar 1993
% calls <border2,ispow2,rmsdif>

if nargin < 1
 disp('DEMO ')
 help guspi
 return
end
%
 if nargin > 6,
  % options are specified by OPT array
  tol=OPT(4);
  gtol=OPT(3);
  nterms=OPT(2);
  nitrs=OPT(1);
 else
  tol=.0100;
  gtol=.0100;
  nterms=40;
  nitrs=40;
 end
% border arrays to next power of two
 olen=length(f2d); % original length
 if ispow2(f2d)==0,
  disp('Bordering data to power of two by mirroring')
  f2d=border2(f2d);
  fdp=border2(fdp);
 end
%
[nx,ny]=size(f2d);
if nx>ny, disp('transpose f2d array'); f2d=f2d'; end 
[nx,ny]=size(fdp);
if nx>ny, disp('transpose fdp array'); fdp=fdp'; end
 nn=length(f2d);
 nn2=nn/2;
 n2plus=nn2+1;
 dk=2*pi/(nn*dx)
% calculate wavenumbers
 k=1:n2plus;
 k=(k-1).*dk;
 K=k;
 K(n2plus+1:nn)=-k(nn2:-1:2);
% Determine reference plane
% Version-1 place ref plane as halfway between max and min
% Note: Guspi defines z +ve down
% determine max min of observation level
 zmax=max( fdp );
 zmin=min( fdp );
 fprintf('zmin,zmax : %10.3f %10.3f\n',zmin,zmax);
%
 hwiggl=(zmax-zmin)/2;
 fprintf('Choice of reference levels:\n');
 fprintf(' %8.3f halfway level\n',zmin+hwiggl);
 fprintf(' %8.3f maximum level\n',zmax);
 fprintf(' %8.3f minimum level\n',zmin);
 fprintf(' %8.3f mean level\n',mean(fdp(1:nx)));
 fprintf(' %8.3f median level\n',median(fdp(1:nx)));
 fprintf(' Note that convergence is always achieved at min level\n');
% zref=input('Enter reference level ->');
%
  disp('hard wired to min level')
  zref=zmin;
% zref=zmin+hwiggl/2;
 fprintf('Reference level %10.3f set to zero\n',zref);
% set z to height above the reference level
 h=fdp-zref;
% plot(h,'w'),title('shifted z')
% remove mean from field 
 mnf2d=mean(f2d);
 f2d=f2d-mnf2d;
 fprintf(' Remove mean of %12.3f from input field\n',mnf2d);
% bandpass filter
 fprintf('bandpass filter for stability:\n');
 if ws==0, ws=max(abs(h)); end;
 fprintf(' wlong,wshort = %8.3f %8.3f\n',wl,ws);
 wts=bandpass(nn,dx,wl,ws);
 wts0=fftshift(wts);
% setup initial guess
 gold=f2d;
% iteration loop
 for iter=1:nitrs,
  Gab=fft(gold);
% summation loop
  gsum=0;
  for n=1:nterms,
   g=(((-h).^n)./nfac(n)).*(ifft( ((abs(K)).^n).*(Gab.*wts0) ));
%   g=(((-h).^n)./nfac(n)).*(ifft( ((abs(K)).^n).*(Gab) ));
%   plot(real(g),'w'),pause(1)
   gsum=g+gsum;  % sum the terms
%   fprintf('nterms, max(g): %5.0f %10.3f\n',n,max(real(g)));
   if max(real(g)) < gtol, break, end
  end
%
  gnew=f2d-real(gsum);  % calculate new field
% now evaluate convergence of iteration
   gdiff=abs(gnew-gold);
   conv(iter)=max(gdiff)-min(gdiff);
  err=rmsdif(gnew,gold);
  conv(iter)=err(1); %avg
  fprintf('iter %2.0f, nterms %2.0f, avg= %8.3f, rms= %8.3f\n',iter,n,err(1),err(2));
  if iter == 1,
   gold=gnew; % do nothing and loop around
  elseif conv(iter) < tol, 
   fprintf(' convergence less than tolerance ...\n');
   break;
  elseif conv(iter)/conv(1) >1
   fprintf(' iteration diverging ...\n')
   break
  else
   gold=gnew;
  end
 end   % end of iteration loop
fprintf(' Guspi reduction plane level %10.3f\n',zref);
disp(' Note: output guspi level array is gold')
fprintf(' Finished Guspi ... now do upward continuation\n');
fprintf(' Upward continue to %f level\n',zlev);

figure(1)
clf
subplot(312),plot(gold,'b'),title('guspi field vs observed')
hold on
plot(f2d)
hold off
subplot(313),plot(fdp,'b'),title('fdep')
hold on
plot([0,nn],[zref,zref],'r--')
hold off
up=upcon(gold',dx,zlev-zref);
disp('Finished upcon');

subplot(311)
plot(up(1:olen))
title(['GUSPI Upcon field at',num2str(zlev),' km level'])
subplot(312),plot(gold(1:olen),'r')
title('Guspi downward cont. field vs observed')
hold on
plot(f2d(1:olen));
legend('Guspi','Obs');
hold off
subplot(313),plot(fdp(1:olen),'b'),title('Fish Depth')
hold on
plot([0,olen],[zref,zref],'r-.')
plot([0,olen],[zlev,zlev],'r--')
legend('fdep','zref','zlev');
hold off
orient tall
