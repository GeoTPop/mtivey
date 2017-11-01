function Jtrue=directinv(fld,fdp,bth,wl,ws,rlat,rlon,yr,thick,slin,dx)
%
% Direct inversion from an uneven track
% Full blown version with corrections applied
% NOT checked thoroughly
%
% DIRECT INVERSION FROM UNEVEN TRACK
% Hussenoeder, Tivey, & Schouten, GRL, 22, 3131-3138, 1995.
%
% There are five basic steps to carry out direct inversion
% from an uneven track using the approximate equivalence (AE)
% assumption.
%
% Step 1. - Direct Inversion of data by making AE assumption Jdi
%   
% Step 2. - Calculate forward magnetic field Bt of a known magnetization
%           (1 A/m) along observation track (use Won & Bevis)
%
% Step 3. - Invert magnetic field Bt using AE assumption to give Jt
%           i.e. do a direct inversion
%
% Step 4. - Calculate forward magnetic field Be of a known magnetization
%           (1 A/m) in the AE reference frame
%
% Step 5. - Invert magnetic field Be in AE reference frame to give Je
%
% The correction factor (Jt-Je) is a per A/m of the true magnetization, Jtrue
%
% to make correction to the direct inversion result Jdi we
% have that :
%             Jtrue = Jdi - [Jt-Je]*Jtrue
% where Jtrue is the true (and unknown) magnetization.  We can 
% solve the above equation using algebra for Jtrue to obtain
%
%            Jtrue = Jdi/(1+(Jt-Je))
%
% NOTE also that the corrections are applied to magnetization so
% that there is no need for phase shifts in the correction models.
%  
% Usage:
%   Jtrue=directinv(fld,fdp,bth,wl,ws,rlat,rlon,yr,thick,slin,dx);
%
% M.A.Tivey Ver. Nov 1996

% test data
 if nargin < 1
   rlat=24.333;
   rlon=-46.5;
   wl=0;ws=1.1;
   yr=1991;thick=0.5;slin=20;dx=0.06;
   fld=inv2mat('/big/home/deeptow/moe/matlab/test/tb91_l13.fld');
   fdp=inv2mat('/big/home/deeptow/moe/matlab/test/tb91_l13.fdp');
   bth=inv2mat('/big/home/deeptow/moe/matlab/test/tb91_l13.bth');
  dmag=directinv(fld,fdp,bth,wl,ws,rlat,rlon,yr,thick,slin,dx);
 end
%
% make borders to data   
if ispow2(fdp) == 0,
 f2d=border(fld);
 b2d=border(bth);
 fdp=b2d+border(fdp-bth);
end

% step 1
 out=dinv2d(f2d,fdp,b2d,wl,ws,rlat,rlon,abs(yr),thick,slin,dx);
 Jdi=out(:,1);

% step 2
 he=50000;suscept=.00002; % makes 1a/m
 Bt=synpoly(fdp,b2d,dx,thick,he,90,0,suscept);

% step 3
 out=dinv2d(Bt,fdp,b2d,wl,ws,90,0,abs(yr),thick,0,dx);
 Jt=out(:,1);

% step 4
 h=fdp-b2d;
 h=-h;
 zlev=zeros(size(h));
 Be=synpoly(zlev,h,dx,thick,he,90,0,suscept);

% step 5
 out=dinv2d(Be,zlev,h,wl,ws,90,0,abs(yr),thick,0,dx);
 Je=out(:,1);
% Construct the final corrected solution
 Jtrue=Jdi./(1+Jt-Je);
% plot
plot(Jdi)
hold on
plot(Jtrue,'r')
legend('Jdi','Jt ')
hold off
title('Direct inversion and correction')
