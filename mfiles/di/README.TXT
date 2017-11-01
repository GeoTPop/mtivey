README FOR DIRECT INVERSION FROM UNEVEN TRACK
Hussenoeder, Tivey, & Schouten, GRL, 22, 3131-3138, 1995.
 
The following mfiles are a simplified
set of scripts to run the direct inversion.
directinv.m has a brief outline of the steps
required to run the direct inversion. This is
reproduced below.
The list of ascii mfiles required are:
  border.m
  dinv2d.m
  directinv.m
  inv2d.m
  inv2mat.m
  ispow2.m
  magfd.m
  matinv2.m
  nskew.m
  syn2d.m
  synpoly.m
Also you will need the spherical harmonic coefficients
for the global field (sh.mat etc) in directory igrf.
These binary matlab files must be downloaded in binary.

% DIRECT INVERSION FROM UNEVEN TRACK
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

