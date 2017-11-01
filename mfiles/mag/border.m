function out=border(indata,nn2)
% border  make a simple border on data
%
% Usage: out=border(indata,nn2)
%   where 
%  indata : input data profile
%  nn2 : number of points required, if omitted use next power of 2
%  out : bordered output data profile
%
% Maurice A. Tivey
% October 30, 1992

nn=length(indata);
if nargin < 2,
 % determine next power of two automatically
 ip=nextpow2(nn);
 nn2=2^ip;
end

if nn2==nn, 
 fprintf('No border added already power of two\n');
else
 n1=indata(1);
 n2=indata(nn);
 dd=(n2-n1);

% required length of profile was provided
 dn=nn2-nn
 indata(nn+1:nn2)=[1:dn].*(-dd/dn)+indata(nn);
end
out=indata;
