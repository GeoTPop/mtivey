function out=rbmsmh(in,w_length)
% rbmsmh - smoothing window using a running average
% Usage: out=rbmsmh(in,wl);
%  in : Input array
% wl : window length
%  out : output array
%
% Maurice Tivey 2006

wl2=w_length/2;
start=wl2+1;
finish=length(in)-start;
% initialise
out=in;
for i=start:finish,
  out(i)=mean(in(i-wl2:i+wl2));
end
