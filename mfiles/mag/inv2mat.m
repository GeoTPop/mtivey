function out=inv2mat(fname)
% INV2MAT open file and read in inv2d format profile
% Usage: out=inv2mat;  % to query filename
%  or    out=inv2mat('fname');
% Maurice A. Tivey

if nargin < 1
 fname=input('Enter filename -> ?','s');
else
if(exist(fname)),
 fid=fopen(fname,'r');
  title=fgetl(fid);
 nx=fscanf(fid,'%d',1);
 dx=fscanf(fid,'%f',1);
 xmin=fscanf(fid,'%f',1);
 fmt=fscanf(fid,'%s',1);
 [out]=fscanf(fid,'%f',nx);
 fprintf(' %5.0f POINTS READ FROM FILE %s\n',nx,fname);
 fprintf(' DX= %10.3f\n',dx);
 status=fclose(fid);
else
 disp(['File ',fname,' cannot be found']);
end
end
