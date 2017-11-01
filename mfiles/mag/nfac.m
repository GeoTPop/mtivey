function nsum=nfac(N)
% NFAC - calculate N-factorial
%
%  Maurice A. Tivey 30-Oct-90

nsum=1;
for i=1:N,
    nsum=nsum*i;
end
