function out=synpoly(fdp,b2d,dx,thick,he,incl,decl,suscept)
% SYNPOLY
% Calculate the magnetic field of a constantly magnetized layer using
% polygon method of Won & Bevis
%  Won & Bevis, Computing the gravitational and magnetic anomalies due to a
%  polygon: Algorithms and Fortran subroutines, Geophysics, 52, 232-238, 1987.
%
% Computes the magnetic anomaly at one or more stations due to an infinite
% polygonal cylinder magnetized by the Earth's magnetic field.  The 
% cylinder strikes parallel to the Y-axis, and has a polygonal cross-
% section in the X-Z plane.  The anomalous magnetic field strength depends
% on X and Z, but not on Y.
% Uses FORTRAN compiled program magpoly for faster operation
% Writes an input file (input00.dat) to input into fortran program magpoly.
% Magpoly outputs a data file (output00.dat) containing X,Z,T arrays
%
% Usage:
%       out=synpoly(fdp,b2d,dx,thick,he,incl,decl,suscept)
%
% Parameters
%       fdp : fish depth array (km +ve up)
%       b2d : bathymetry array (km +ve up)
%        dx : data spacing in km
%     thick : thickness in km
%        he : Earth's total magnetic field strength (e.g 50000)
%      incl : Inclination of Earth's field
%      decl : Strike of the polygon measured ccw from N
%             looking down.
%   suscept : Magnetic susceptibility of the polygon in emu (0.0002)
%      remember that J=kH so that 0.0002*50000=10 e-3 emu => 10 a/m
%       output field is multiplied by 100 to get answer in nT
% Output
%       out : total magnetic field (nT)
%
% Maurice A. Tivey april 1996
%
 format compact
 nstn=length(fdp);
 nvert=length(b2d);
 zs=fdp;
 xs=(0:nstn-1)*dx;
% now add borders to data
 xv(1)=-xs(nstn);
 xv(2:nstn+1)=xs;
 xv(nstn+2)=xs(nstn)*2;
 xv(nstn+3)=xs(nstn)*2;
 xv((nstn+4):(2*nstn+3))=xs(nstn:-1:1);
 xv(nstn*2+4)=xv(1);
% depth
 zv(1)=b2d(1);
 zv(2:nstn+1)=b2d;
 zv(nstn+2)=b2d(nstn);
 zv(nstn+3)=b2d(nstn)-thick;
 zv((nstn+4):(2*nstn+3))=b2d(nstn:-1:1)-thick;
 zv(nstn*2+4)=b2d(1)-thick;
% convert negative down to positive down
zs=-zs;
zv=-zv;
nvert=length(zv)
nstn=length(zs)
%
if exist('input00.dat')== 2
 disp('Remove existing copy of input00.dat')
 !rm input00.dat
end
 fprintf('input00.dat','%6d %6d %8.1f %5.1f %5.1f %12.6f\n',...
   nstn,nvert,he,incl,decl,suscept*100)
 for i=1:nstn,
  fprintf('input00.dat','%12.3f %12.3f\n',xs(i),zs(i));
 end
 for i=1:nvert,
  fprintf('input00.dat','%12.3f %12.3f\n',xv(i),zv(i));
 end
%
% break
if exist('output00.dat')== 2
 disp('Remove existing copy of output00.dat')
 !rm output00.dat
end
!magpoly
load output00.dat
out=output00(:,3);
%
