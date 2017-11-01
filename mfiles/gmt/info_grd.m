function info_grd(grdfile)
% info_grd
% get info on GMT grid file  
%   Usage: info_grd(grdfile);
%
% Maurice Tivey MATLAB5 using mexcdf53  May 1997
% MAT June 2007 mod for mexnc
% MAT Apr 2013 modified to use MATLAB netcdf library

fprintf('\ninfo_grd %s\n\n',grdfile);
cdfid=netcdf.open(grdfile,'nowrite');
ginfo=ncinfo(grdfile);  % use shortcut?

% test to see if grid is old GMT format or new COARDS format
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(cdfid);

if nvars==3, % new type GMT4+ file
 fprintf('GMT 4.2 format NetCDF grid\n');
 gtype=ncreadatt(grdfile,'/','Conventions');
 gtitle=ncreadatt(grdfile,'/','title');
 fprintf('Title: %s\n',gtitle);
 ghistory=ncreadatt(grdfile,'/','history');
 fprintf('History: %s\n',ghistory);
 if ginfo.Attributes(4).Name=='description',
  gdesc=ncreadatt(grdfile,'/','description');
  fprintf('Description: %s\n',gdesc);
 end 
 gscale=1;goffset=0;
 fprintf('Normal node registration used\n');
 fprintf('grdfile format: nf (# 18)\n');
 
 [fnx,dims(1)]=netcdf.inqDim(cdfid,0);
 [fny,dims(2)]=netcdf.inqDim(cdfid,1);
 x=netcdf.getVar(cdfid,0);
 y=netcdf.getVar(cdfid,1);
 nx=dims(1);
 ny=dims(2);
 x1=min(x);x2=max(x);
 y1=min(y);y2=max(y);
 dx= (x2-x1)/(nx-1);
 dy= (y2-y1)/(ny-1);
 x_range=[x1 x2];
 y_range=[y1 y2];
 xysize=nx*ny;
% read z data, actually stored as single precision
% but convert to double precision for MATLAB
 z=netcdf.getVar(cdfid,2);
 z=flipud(flipud(z.'));
else
% old GMT V3 format grid
 gformat=netcdf.inqFormat(cdfid);
 gtitle=ncreadatt(grdfile,'/','title');
 gdesc=ncreadatt(grdfile,'/','source');
 gnode=netcdf.getAtt(cdfid,5,'node_offset');
 gscale=netcdf.getAtt(cdfid,5,'scale_factor');
 goffset=netcdf.getAtt(cdfid,5,'add_offset');
 fprintf('Old format GMT V3 NetCDF grid\n');
 fprintf('%s\n',gformat)
 fprintf('Title: %s\n',gtitle);
 fprintf('Command: %s\n',gdesc);
 if gnode==0,
  fprintf('Normal node registration used\n')
 else
  fprintf('Pixel node registration used\n');
 end
 fprintf('grdfile format: cf (# 10)\n');
 x_range=netcdf.getVar(cdfid,0);
 y_range=netcdf.getVar(cdfid,1);
 %spacing=netcdf.getAtt(cdfid,5,'spacing');
 dims=netcdf.getVar(cdfid,4)';
 gnode=netcdf.getAtt(cdfid,5,'node_offset');
 if gnode==1,                         % pixel node registered
    dx=diff(x_range)/double(dims(1)); % convert int to double for division
    dy=diff(y_range)/double(dims(2));
    x=x_range(1)+dx/2:dx:x_range(2)-dx/2; % convert to gridline registered
    y=y_range(1)+dy/2:dy:y_range(2)-dy/2;
else                              % gridline registered
    dx=diff(x_range)/double(dims(1)-1); % convert int to double for division
    dy=diff(y_range)/double(dims(2)-1);
    x=x_range(1):dx:x_range(2);
    y=y_range(1):dy:y_range(2);
end
 nx=dims(1);
 ny=dims(2);
 xysize=nx*ny;
 z=netcdf.getVar(cdfid,5);
 z=flipud(reshape(z,nx,ny)');
end
% close file
netcdf.close(cdfid);

zmax=max(max(z));
zmin=min(min(z));
fprintf(' %d X grid points by %d Y grid points\n',nx,ny);
fprintf('x_min: %13.7f x_max: %13.7f x_inc: %13.7f\n',x_range(1),x_range(2),dx);
fprintf('y_min: %13.7f y_max: %13.7f y_inc: %13.7f\n',y_range(1),y_range(2),dy);
fprintf('z_min: %13.7g z_max: %13.7g\n',zmin,zmax);
fprintf('scale_factor: %d add_offset: %d\n',gscale,goffset);

