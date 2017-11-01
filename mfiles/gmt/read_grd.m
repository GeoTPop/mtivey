function [x,y,z]=read_grd(grdfile)
% READ_GRD 
% reads GMT grid file into Matlab array z
% Accommodates new format of GMT 4.2 grid files
%
%   Usage: [x,y,z]=read_grd(grdfile);
%    where 
%          x = east coordinate vector (eg. longitude)
%          y = north coordinate vector (eg. latitude)
%          z = matrix of gridded values (eg. bathy grid)
%
%   Example:
%           [x,y,z]=read_grd('foo.grd');
%           contour(x,y,z)
% Uses mexnc toolbox, see also write_grd
% supercedes read_gmt
% Maurice Tivey 
% May 2007
% May 2012  Modified for MATLAB 2011 using mexnc library
% Apr 2013  uses built-in matlab NetCDF functions
%  
cdfid=netcdf.open(grdfile,'NC_NOWRITE');
[ndims,nvars,ngatts,unlimdim]=netcdf.inq(cdfid);

% test to see if grid is old GMT format or new COARDS format
if nvars==3, % new V4 GMT COARDS compliant grd
 disp('reading v4+ grid')
 x=netcdf.getVar(cdfid,0);
 y=netcdf.getVar(cdfid,1);
 z=netcdf.getVar(cdfid,2);
 z=double(z)'; % convert single precision to double
elseif nvars==6, % i.e. old V3 GMT format grd
 disp('reading v3 format grid')
 x_range=netcdf.getVar(cdfid,0);
 y_range=netcdf.getVar(cdfid,1);
 dims=netcdf.getVar(cdfid,4);
 pixel=netcdf.getAtt(cdfid,5,'node_offset');
 if pixel,   % pixel node registered but convert to gridline registered
  dx=diff(x_range)/double(dims(1));  
  dy=diff(y_range)/double(dims(2));
  x=x_range(1)+dx/2:dx:x_range(2)-dx/2;  
  y=y_range(1)+dy/2:dy:y_range(2)-dy/2;
 else        % gridline registered
  dx=diff(x_range)/double(dims(1)-1);
  dy=diff(y_range)/double(dims(2)-1);
  x=x_range(1):dx:x_range(2);
  y=y_range(1):dy:y_range(2);
 end
 z=netcdf.getVar(cdfid,5);
 z=flipud(reshape(z,dims(1),dims(2))');
else
 error('read_grd: problem reading grid'); 
end
%
y=y';
netcdf.close(cdfid);


