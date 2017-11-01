function out=border(new,nn2)
% border.m  make a simple border on data
%
% Usage: out=border(new,nn2)
%   where input data is new
%   number of points required is nn2 if omitted use next power of 2
%   output data is out
%
% Maurice A. Tivey
% October 30, 1992
%
 nn=length(new);
if nargin < 2,
 % determine next power of two automatically
 nn2=2^nextpow2(nn);
end
 n1=new(1);
 n2=new(nn);
 dnew=(n2-n1);

% length of profile was provided
 dn=nn2-nn;
 new(nn+1:nn2)=[1:dn].*(-dnew/dn)+new(nn);
% plot(new)
 out=new;
