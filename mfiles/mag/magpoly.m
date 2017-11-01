function out=magpoly(xs,zs,xv,zv,he,anginc,angstr,suscept)
% MAGPOLY Computes the magnetic anomaly at one or more stations due to an infinite
% polygonal cylinder magnetized by Earth's magnetic field.  The 
% cylinder strikes parallel to the Y-axis, and has a polygonal cross-
% section in the X-Z plane.  The anomalous magnetic field strength depends
% on X and Z, but not on Y.
% Uses FORTRAN compiled program for faster operation
%
%  Won & Bevis, Computing the gravitational and magnetic anomalies due to a
%  polygon: Algorithms and Fortran subroutines, Geophysics, 52, 232-238, 1987.
%
% Usage out=magpoly(xs,zs,xv,zv,he,anginc,angstr,suscept);
%
%   ---->+ve X  (N->S)
%   |
%   |
%   V +ve Z
%
% xs,zs : horizontal and vertical observation station coordinates
% xv,zv : body coordinates : MUST be arranged in a clockwise manner
% he : field intensity
% anginc : inclination of field
% angstr : strike of body from north (+ve cw)
% suscept : susceptibility of body
% write an input file (input00.dat) to input into fortran program magpoly
% outputs a data file (output00.dat) contains Z,X,T arrays
%
 nstn=length(xs);
 nvert=length(xv);
%
if exist('input00.dat')== 2
 disp('Remove existing copy of input00.dat')
 !del input00.dat
end
 fid=fopen('input00.dat','w');
 fprintf(fid,'%6d %6d %8.1f %5.1f %5.1f %12.6f\n',...
   nstn,nvert,he,anginc,angstr,suscept*100);
 for i=1:nstn,
  fprintf(fid,'%12.3f %12.3f\n',xs(i),zs(i));
 end
 for i=1:nvert,
  fprintf(fid,'%12.3f %12.3f\n',xv(i),zv(i));
 end
 fclose(fid);
%
if exist('output00.dat')== 2
 disp('Writing over existing copy of output00.dat')
 !del output00.dat
end
disp('call magpoly.exe')
!c:\matlab\bin\magpoly
load output00.dat
out=output00; 
fprintf('\n');
% Z,X,T
%
