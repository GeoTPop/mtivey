function W=bordr3(data,nnx,nny)
% BORDR3 Apply border region to input grid
%
% Usage: out=bordr3(data,nnx,nny)
%
% Maurice Tivey Oct 1995

[ndatay,ndatax]=size(data);
if nargin < 2
% determine next power of two automatically
 nnx=2^nextpow2(ndatax);
 nny=2^nextpow2(ndatay);
end
fprintf(' APPLY BORDER FROM SIZE %3d  X %3d TO %3d X %3d\n',ndatax,ndatay,nnx,nny)
W=data;
scale=1./(nny-ndatay+2);
A1=W(ndatay,1:ndatax);
A2=W(1,1:ndatax);
for j=ndatay:nny,
   xi=scale*(j-ndatay);
   W(j,1:ndatax)=A1*(1.-xi)+A2*xi;
end
scale=1./(nnx-ndatax+2);
A1=W(1:nny,ndatax);
A2=W(1:nny,1);
for i=ndatax:nnx,
   xi=scale*(i-ndatax);
   W(1:nny,i)=A1*(1.-xi)+A2*xi;
end
%