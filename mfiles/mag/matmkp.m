function matmkp(a)
% MATMKP Output deeptow magnetic data in MKPROFL ascii Format
%
%  Usage: matmkp(mkp)
%  input array mkp must be in the form: 
%      [yr,mon,day,time,x,y,fdep,bathy,fld]
%
%  Maurice A. Tivey  3 April 1992

[fname, pathname] = uiputfile('*.mkp', 'Output an MKP ascii file');
fid=fopen([pathname, fname],'w');
%[fid,fname]=getfname;

npts=length(a);
% now do data
for i=1:npts,
	fprintf(fid,'%3.0f%3.0f%3.0f',a(i,1),a(i,2),a(i,3));
	fprintf(fid,'%8.4f %12.1f %12.1f',a(i,4),a(i,5),a(i,6));
	fprintf(fid,'%8.1f %8.1f %8.1f\n',a(i,7),a(i,8),a(i,9));
end
disp(' Finished writing output MKPROFL format file')
fclose(fid)