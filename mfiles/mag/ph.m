function out=ph(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip)
%
% PH  Do full Parker and Huestis inversion and recalculation of
%     magnetic field including annihilator
%
% Usage: out=ph(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
%     or out=ph(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
%
%  where out = [m2d,fr2d,ann];
%
% Maurice A. Tivey

if nargin < 13  % geocentric dipole case
% inversion
 m2d=inv2d(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
% recomputed field
 fr2d=syn2d(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx);
% annihilator (see below for explanation)
 nn=length(f2d);
 mag1=ones(nn,1);
 f1=syn2d(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx);
 ann1=inv2d(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx);
 ann=mag1-ann1;

else  % user defined case
% inversion
 m2d=inv2d(f2d,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% recomputed field
 fr2d=syn2d(m2d,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
% annhilator (see below for explanation)
 nn=length(f2d);
 mag1=ones(nn,1);
 f1=syn2d(mag1,h,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
 ann1=inv2d(f1,h,wl,ws,rlat,rlon,yr,zobs,thick,slin,dx,sdec,sdip);
 ann=mag1-ann1;
end
% Now do annihilator i.e. the magnetization that produces no 
% external magnetic field.  Note that setting the magnetic field
% to zero only returns the trivial solution ann=0.
% For a more interesting solution put in a known magnetization
% e.g. mag=1 and then compute the field, perform the inversion
% and obtain the annihilator as the difference between the known
% mag (i.e. 1) and inversion result.
% Can test this model by computing the field which hould be zero
% now output arrays
m2d=real(m2d);
ann=real(ann);
out(:,1)=m2d;
out(:,2)=real(fr2d);
out(:,3)=ann;
clg
subplot(311)
plot(f2d);hold on; plot(fr2d,':'); title('Magnetic field')
hold off
subplot(312)
plot(m2d); hold on; plot(ann,':'); title('Magnetization')
hold off
subplot(313)
plot(h), title('Bathymetry')
