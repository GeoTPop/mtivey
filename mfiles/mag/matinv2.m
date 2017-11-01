function matinv2(in,dx,xmin,filename,title)
% MATINV2 Output grid in ascii INV2D Format
% 
% Usage:  matinv2(in,dx,xmin,filename,title)
%       in : profile to write out
%       dx : data spacing in km
%     xmin : initial xcoord in km
% filename : use name in single quotes
%    title : enclosed in single quotes
%
%  Maurice A. Tivey  3 April 1992
%  Modified for title Apr 1996
% calls getfname

fprintf('Output array to INV2D format ascii file\n');
if nargin < 5,   % then no title
   title='INV2D   ';
end
if nargin < 4
  [fid,filename]=getfname;
else
  fid=fopen(filename,'w');
end
%
nx=length(in);
% do header
title=['INV2D   ',title,' \n'];
fprintf(fid,title);
fprintf(fid,'%6.0f',nx);
fprintf(fid,'%10.3f',dx);
fprintf(fid,'%10.3f\n',xmin);
fprintf(fid,'(e15.6) \n');
% now do grid
for i=1:nx,
	fprintf(fid,'%15.6e\n',in(i));
end
disp(' Finished writing output INV2D format grid')
fclose(fid);