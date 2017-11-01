function out=bordref(new)
% bordref  make a border on data by flipping the array
%    and padding at the end of the flipped data with
%    repeated data value    
% Usage: out=bordref(new)
% where
%   new: input data 
%   out: output data
% see also border and bordr3 for maps
% Maurice A. Tivey
% June 30, 1995
% calls <nextpow2>

 nn=length(new);
% determine next power of two automatically
 nn2=2^nextpow2(nn*2);
 out=ones(nn2,1).*new(1);
 out(1:nn)=new(1:nn);
 out(nn+1:nn*2)=new(nn:-1:1);
