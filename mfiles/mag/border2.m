function out=border2(data)
% border2 make border on data by flipping the array
%    and padding inbetween the flipped data with
%    repeated data value  
%
% Usage: out=border2(data)
%   data: input data 
%   out: output data
%
% see also border for simple border and bordr3 for maps
% Maurice A. Tivey
% June 30, 1995
% calls <nextpow2>
 nn=length(data);
% determine next power of two automatically
 nn2=2^nextpow2(nn*2);
 out=ones(nn2,1).*data(nn);
 out(1:nn)=data(1:nn);
 n0=nn2-nn+1;
 out(n0:1:nn2)=data(nn:-1:1);
