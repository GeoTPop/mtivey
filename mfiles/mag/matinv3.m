function matinv3(in,dx,dy,xmin,ymin,filename,title)
% MATINV3 Output grid in ascii INV3D Format
% Usage:  matinv3(in,dx,dy,xmin,ymin,filename)
%       in : input grid
%       dx : xdata spacing in km
%       dy : ydata spacing in km
%     xmin : initial xcoord in km
%     ymin : initial ycoord in km
% filename : use name in single quotes
%
%  Maurice A. Tivey  3 April 1992
% calls <getfname>
if nargin < 6
 [fid,filename]=getfname;
 dx=input(' Enter dx ->');
 dy=input(' Enter dy ->');
 xmin=input(' Enter xmin ->');
 ymin=input(' Enter ymin ->');
 title=input('Enter title text -> ');
else
 fid=fopen(filename,'w');
end
%
[nx,ny]=size(in);
% do header
if nargin > 6
  fprintf(fid,'INV3D   %s\n',title);
else
  fprintf(fid,'INV3D   \n');
end
fprintf(fid,'%6.0f%6.0f',ny,nx);
fprintf(fid,'%10.3f%10.3f',dx,dy);
fprintf(fid,'%10.3f%10.3f\n',xmin,ymin);
fprintf(fid,'(e15.6) \n');
% now do grid
for i=1:nx,
 for j=1:ny,
	fprintf(fid,'%15.6e\n',in(i,j));
 end
end
disp(' Finished writing output INV3D format grid')
fclose(fid)