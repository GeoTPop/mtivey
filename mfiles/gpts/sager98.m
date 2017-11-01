% sager98.m
% Geomagnetic Polarity Timescale
%   Mesozoic timescale
% References: 
% Sager, W.W., C. Weiss, M.A.Tivey and H.P. Johnson, Geomagnetic polarity 
% reversal model of deeptow profiles from the Pacific Jurassic quiet zone,
% JGR, 103, 5269-5286, 1998.
% Note that Sager defined reversed polarity periods so
% convert these to normal polarity periods
% Maurice A. Tivey
%
GTS_name='Sager98 surface';
disp('WARNING these are reversed polarity periods')
disp('So multiply mag function by -1 to make normal')
GTS={
 156.199  156.425 'M27r';
 156.766  156.912 'M28n.1r'
 157.062  157.266 'M28n.2r'
 157.531  157.648 'M28n.3r'
 157.700  157.850 'M28r'
 158.116  158.450 'M29r'
 158.679  158.829 'M30r'
 159.162  159.297 'M31r'
 159.623  159.877 'M32r'
 160.095  160.250 'M33n.1r'
 160.308  160.402 'M33n.2r';
 160.472  160.635 'M33n.3r'
 160.858  161.064 'M33r'
 161.158  161.610 'M34n.1r'
 161.704  161.791 'M34r'
 161.918  162.085 'M35r'
 162.383  162.602 'M36n.1r'
 162.645  162.816 'M36r'
 163.110  163.181 'M37n.1r'
 163.339  163.502 'M37r'
 163.893  164.072 'M38n.1r'
 164.098  164.631 'M38r'
 164.825  164.902 'M39n.1r'
 165.422  165.497 'M39n.2r';
 165.960  166.760 'M39r';
 166.692  167.347 'M40r';
 167.516  200.000 'M41r';
 200.000  300.000 'JQZ'};
