% sag98dp.m
% Geomagnetic Polarity Timescale
%   Mesozoic timescale
% Deeptow version
% References: 
% Sager, W.W., C. Weiss, M.A.Tivey and H.P. Johnson, Geomagnetic polarity 
% reversal model of deeptow profiles from the Pacific Jurassic quiet zone,
% JGR, 103, 5269-5286, 1998.
% Note that Sager defined reversed polarity periods so
% convert these to normal polarity periods
% Maurice A. Tivey
%
GTS_name='Sager98 deep';
disp('WARNING these are reversed polarity periods')
disp('So multiply mag function by -1 to make normal')
GTS={
 154.149  154.249 'M25.1r'; % H88
 154.389  154.489 'M25.2r';
 154.679  154.819 'M25.3r';
 154.959  155.059 'M25.4r';
 155.159  155.259 'M25.5r';
 155.359  155.429 'M25.6r';
 155.679  155.979 'M26r';% 156.229-155.32 => 0.909 offset to h88 M27
 156.229  156.410 'M27r'; % beginning of sager 1998 timescale
 156.741  156.906 'M28r';
 157.016  157.273 'M28Ar';
 157.329  157.425 'M28Br';
 157.543  157.643 'M28Cr';
 157.731  157.852 'M28Dr';
 158.023  158.056 'M29n.1r';
 158.129  158.389 'M29r';
 158.443  158.516 'M29Ar';
 158.652  158.829 'M30r';
 158.939  158.973 'M30Ar';
 159.145  159.235 'M31n.1r'
 159.266  159.312 'M31n.2r';
 159.360  159.420 'M31r';
 159.445  159.477 'M32n.1r';
 159.585  159.643 'M32n.2r';
 159.675  159.768 'M32r'; 
 160.095  160.241 'M33r';
 160.327  160.404 'M33Ar';
 160.479  160.604 'M33Br';
 160.647  160.704 'M33Cn.1r';
 160.839  161.064 'M33Cr';
 161.158  161.237 'M34n.1r';
 161.289  161.331 'M34n.2r';
 161.366  161.422 'M34n.3r';
 161.447  161.600 'M34Ar';
 161.706  161.747 'M34Bn.1r';
 161.773  161.882 'M34Br';
 161.918  162.122 'M35r';
 162.241  162.320 'M36n.1r';
 162.368  162.391 'M36Ar';
 162.423  162.579 'M36Br';
 162.656  162.793 'M36Cr';
 163.060  163.187 'M37n.1r';
 163.322  163.472 'M37r';
 163.593  163.654 'M38n.1r';
 163.760  163.800 'M38n.2r';
 163.889  164.006 'M38n.3r';
 164.270  164.343 'M38n.4r';
 164.504  164.600 'M38r';
 164.775  164.914 'M39n.1r';
 165.047  165.150 'M39n.2r';
 165.297  165.398 'M39n.3r';
 165.648  165.804 'M39n.4r';
 165.908  166.037 'M39n.5r';
 166.129  166.260 'M39n.6r';
 166.337  166.427 'M39n.7r';
 166.541  166.639 'M39r';
 166.710  166.791 'M40n.1r';
 166.931  166.987 'M40n.2r';
 167.039  167.168 'M40n.3r';
 167.222  167.333 'M40r';
 167.406  200.000 'M41r';
 200.000  300.000 'JQZ'};
