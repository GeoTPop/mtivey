function out=ispow2(array)
% ISPOW2  check to see if an array is a power of
%        two or not, for eventual bordering
% Usage: flag=ispow2(array);
%  flag=0 if not power of two
%  flag=1 if a power of two
%
% see also BORDER BORDER3 NEXTPOW2
% Maurice A.Tivey

nn=length(array);
out=0;  % set flag to zero
for i=1:16,
 if nn==2^i,
  out=1;
 end
end
%