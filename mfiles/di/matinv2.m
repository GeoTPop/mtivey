function matinv2(in,dx,xmin,filename,title)
% MATINV2
%   Output grid in ascii INV2D Format
%   Input array: in
%   Output file: out.x2d
%
% Usage:  matinv2(in,dx,xmin,filename,title)
%  Maurice A. Tivey  3 April 1992
%
fprintf('Output array to INV2D format ascii file\n');
if nargin < 5
 title='INV2D      ';
end
 if nargin < 4
  [fid,filename]=getfname;
 else
  fid=fopen(filename,'w');
 end

nx=length(in);
% do header
fprintf(fid,[title,'\n']);
fprintf(fid,'%6.0f',nx);
fprintf(fid,'%10.3f',dx);
fprintf(fid,'%10.3f\n',xmin);
fprintf(fid,'(e15.6) \n');
% now do grid
for i=1:nx,
	fprintf(fid,'%15.6e\n',in(i));
end
disp(' Finished writing output INV2D format grid')
