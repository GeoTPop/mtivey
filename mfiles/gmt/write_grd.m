function write_grd(x,y,z,grdname,gtitle)
% WRITE_GRD
% writes Matlab array z into GMT .grd file
% using new GMT 4.2 format grid spec
%
% Usage:  write_grd(x,y,z,grdfile)
% Example:  contour(x,y,z);
%           write_grd(x,y,z,grdfile);
%           [x,y,z]=read_grd(grdfile);
%           contour(x,y,z);
%
% Uses mexnc toolbox, see also read_grd
% Maurice Tivey June 2007
% Apr 2013 use built netcdf library

[ny nx]=size(z);
dims=size(z);
x1=min(x);x2=max(x);
y1=min(y);y2=max(y);
spacing=[(x2-x1)/(nx-1) (y2-y1)/(ny-1)];
x_range=[x1 x2];
y_range=[y1 y2];
z_range=[min(z(:)) max(z(:))];

q=NaN;
%
disp('Write GMT V4+ format NetCDF grid');

% Create netCDF file  (synchronous writes)
cdfid = netcdf.create(grdname,'SHARE');

% Create Global attributes
gconv='COARDS/CF-1.0';
if nargin == 5,
 % use input title
else
 gtitle=grdname;
end
ghistory='File written by MATLAB function write_grd';
gmtdes=['Created ', datestr(now)];
gmtver='4.X';
 
% Global
 netcdf.putAtt(cdfid,netcdf.getConstant('NC_GLOBAL'),'Conventions',gconv);
 netcdf.putAtt(cdfid,netcdf.getConstant('NC_GLOBAL'),'title',gtitle);
 netcdf.putAtt(cdfid,netcdf.getConstant('NC_GLOBAL'),'history',ghistory);
 netcdf.putAtt(cdfid,netcdf.getConstant('NC_GLOBAL'),'description',gmtdes);
 netcdf.putAtt(cdfid,netcdf.getConstant('NC_GLOBAL'),'GMT_Version',gmtver);

% X coords
  dimid=netcdf.defDim(cdfid,'x',length(x));
  x_id = netcdf.defVar(cdfid,'x','double',dimid);
  netcdf.putAtt(cdfid,x_id,'long_name','x');
  netcdf.putAtt(cdfid,x_id,'actual_range',double(x_range));
  netcdf.endDef(cdfid);  % End define mode
  netcdf.putVar(cdfid,x_id,x);
% Y coords
  netcdf.reDef(cdfid);
  dimid=netcdf.defDim(cdfid,'y',length(y));
  y_id = netcdf.defVar(cdfid,'y','double',dimid);
  netcdf.putAtt(cdfid,y_id,'long_name','y');
  netcdf.putAtt(cdfid,y_id,'actual_range',double(y_range));
  netcdf.endDef(cdfid);  % End define mode
  netcdf.putVar(cdfid,y_id,y);
% Z values
  netcdf.reDef(cdfid);
  z_id = netcdf.defVar(cdfid,'z','NC_FLOAT',[0 1]);
  netcdf.putAtt(cdfid,z_id,'long_name','z');
  netcdf.putAtt(cdfid,z_id,'_FillValue',single(q));
  netcdf.putAtt(cdfid,z_id,'actual_range',single(z_range));
  netcdf.endDef(cdfid);  % End define mode
  netcdf.putVar(cdfid,z_id,single(z'));

%
  netcdf.close(cdfid);
%
disp([grdname ' created'])

