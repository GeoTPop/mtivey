function out = rbmmed(in,wl)
% rbmmed - median filtering of input signal
%
% Usage out=rbmmed(in,wl)
%  in : Input array
%  wl : window length (an even number)
%  out : Output array
%
%
% Maurice A. Tivey 12 Jan 1992

disp(' Median Filtering')
wl2=wl/2;
start=wl2+1;
finish=length(in)-start;
% initialise array 'out'
out=in;
for i=start:finish,
  out(i)=median(in(i-wl2:i+wl2));
end
