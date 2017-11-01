% HA97.M
% Geomagnetic Polarity Timescale
% GTS array shows beginning and end of normal polarity chrons
% in millions of years
%
% Reference: 
% Huestis, S.P and G.D. Acton, On the construction of geomagnetic 
% timescales from non-prejudicial treatment of magnetic 
% anomaly data from multiple ridges, Geophys. J. Int.,
% 129, 176-182, 1997.
%
% Mar 2000 Maurice A. Tivey
% MATLAB V5

GTS_name='Huestis & Acton 97';
fprintf(' This gpts only goes to C13n \n%s\n',GTS_name);
GTS = { 0.000    0.780 '1n     ';	%Brunhes/Matuyama
        0.979    1.042 '1r.1n  ';	%Jaramillo
        1.789    2.010 '2n     ';	%Olduvai
        2.219    2.250 '2r.1n  ';
        2.613    3.083 '2An.1n ';	%Matuyama/Gauss
        3.158    3.256 '2An.2n ';	%
        3.363    3.599 '2An.3n ';	%Gauss/Gilbert
        4.096    4.208 '3n.1n  ';	%Cochiti
        4.354    4.542 '3n.2n  ';	%Nunivak
        4.743    4.835 '3n.3n  ';	%Sidufjall
        4.968    5.230 '3n.4n  ';	%Thvera
        5.912    6.157 '3An.1n ';	%
        6.291    6.595 '3An.2n ';
        6.971    7.131 '3Bn    ';
        7.177    7.212 '3Br.1n ';
        7.388    7.423 '3Br.2n ';
        7.482    7.615 '4n.1n  ';
        7.705    8.144 '4n.2n  ';
        8.302    8.335 '4r.1n  ';
        8.796    9.140 '4An    ';
        9.359    9.444 '4Ar.1n ';
        9.739    9.806 '4Ar.2n ';
        9.913   10.064 '5n.1n  ';
       10.107   11.168 '5n.2n  ';
       11.274   11.323 '5r.1n  ';
       11.714   11.770 '5r.2n  ';
       12.189   12.337 '5An.1n ';
       12.443   12.666 '5An.2n ';
       12.918   12.945 '5Ar.1n ';
       13.006   13.047 '5Ar.2n ';
       13.203   13.338 '5AAn   ';
       13.488   13.676 '5ABn   ';
       13.851   14.175 '5ACn   ';
       14.264   14.638 '5ADn   ';
       14.800   14.891 '5Bn.1n ';
       15.039   15.164 '5Bn.2n ';
       16.039   16.361 '5Cn.1n ';
       16.378   16.551 '5Cn.2n ';
       16.624   16.807 '5Cn.3n ';
       17.399   17.748 '5Dn    ';
       18.433   18.906 '5En    ';
       19.157   20.211 '6n     ';
       20.586   20.771 '6An.1n ';
       21.013   21.302 '6An.2n ';
       21.701   21.782 '6AAn   ';
       22.041   22.128 '6AAr.1n';
       22.315   22.347 '6AAr.2n';
       22.436   22.588 '6Bn.1n ';
       22.639   22.886 '6Bn.2n ';
       23.151   23.415 '6Cn.1n ';
       23.621   23.800 '6Cn.2n ';
       24.015   24.144 '6Cn.3n ';
       24.808   24.863 '7n.1n  ';
       24.922   25.282 '7n.2n  ';
       25.606   25.764 '7An    ';
       25.946   26.061 '8n.1n  ';
       26.098   26.618 '8n.2n  ';
       27.056   28.066 '9n     ';
       27.365   27.642 '10n.1n ';
       28.718   28.909 '10n.2n ';
       29.663   29.930 '11n.1n ';
       30.037   30.380 '11n.2n ';
       30.771   31.179 '12n    ';  % end of HA97 
       33.058   33.545 '13n    '}; % can add on CK95 to here
 
