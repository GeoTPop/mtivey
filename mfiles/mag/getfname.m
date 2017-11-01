function [fid,fname]=getfname
% GETFNAME Open a file with user defined name
%  Prompts user for filename and checks if it 
%  already exists
%  Usage: [fid,filename]=getfname
%
%  Maurice A. Tivey  June 1992
%--------------------------------------------------

fname=input('Enter output filename -> ?','s');
if ~isempty(fname),
 if(exist(fname)),
  disp(['File ',fname,' already exists'])
  buf=input(['Overwrite existing file ',fname,' (return=Y) ?'],'s');
  if (~isempty(buf)),
   break;
  else
   eval(['!del ',fname]);
   disp(['Open file ',fname]);
   fid=fopen(fname,'w');
  end
 else
   disp(['Open new file ',fname]);
   fid=fopen(fname,'w');
 end
end

%
