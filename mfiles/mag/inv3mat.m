function out=inv3mat(fname)
% INV3MAT Open and read an INV3D format grid
%   Usage: out=inv3mat('input_filename');
%
%  Maurice A. Tivey 22 Apr. 1993
format compact
if(exist(fname)),
 fid=fopen(fname,'r');
 title=fgetl(fid);
 nx=fscanf(fid,'%d',1);
 ny=fscanf(fid,'%d',1);
 dx=fscanf(fid,'%f',1);
 dy=fscanf(fid,'%f',1);
 xmin=fscanf(fid,'%f',1);
 ymin=fscanf(fid,'%f',1);
 fmt=fscanf(fid,'%s',1);
 fprintf(' NX by NY grid %6d %6d \n',nx,ny);
 fprintf(' DX DY spacing in km = %10.3f %10.3f \n',dx,dy);
 fprintf(' XMIN YMIN = %10.3f %10.3f \n',xmin,ymin);
% now read array
 out=fscanf(fid,'%f',[nx,ny]);
 out=rot90(out);
 out=flipud(out);
 fprintf(' %6d by %6d POINTS READ FROM FILE %s\n',nx,ny,fname);
else
 disp(['File ',fname,' cannot be found']);
end
%

