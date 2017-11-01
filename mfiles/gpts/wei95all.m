% WEI95ALL.M
% Geomagnetic Polarity Timescale
% Combined Cenozoic and Mesozoic scales
% References: 
% WEI95	Wei, W., Revised age calibration points for the geomagnetic 
%   polarity time scale, Geophys. Res. Lett., 22, 957-960, 1995.
% KG86	Kent, D.V., and F.M. Gradstein, A Jurassic to recent chronology, 
%   in The geology of North America, vol. M, The Western North Atlantic 
%   Region, edited by P.R. Vogt and B.E. Tucholke, pp 45-50, Geological 
%   Soc. of America, Boulder, Colo., 1986.
% CK95  Cande, S.C., and D.V. Kent, Revised calibration of the geomagnetic polarity 
%   timescale for the late Cretaceous and Cenozoic, J. Geophys. Res., 100, 
%   6,093-6,095, 1995.
% H88	Handschumacher, D.W., W.S. Sager, T. W.C. Hilde, and D.R. Bracey, 
%   Pre-Cretaceous tectonic evolution of the Pacific plate and extension 
%   of the geomagnetic polarity reversal timescale with implications for 
%   the origin of the Jurassic "Quiet Zone", Tectonophys., 155, 365-380, 1988.
%
% H88 has been merged onto the end of KG86 at M26 by adding
% 3.14 Ma to H88 ages
% Note also there is a problem with C12 in Wei timescale
% Maurice A. Tivey
%
GTS_name='Composite Wei95+CK95+KG86+H88';
% substitute { for [
GTS = { 
   0.000    0.780 '1n     ';       %Brunhes/Matuyama
	0.990    1.070 '1r.1n  ';       %Jaramillo
	1.770    1.950 '2n     ';       %Olduvai
	2.140    2.150 '2r.1n  ';
	2.581    3.040 '2An.1n ';       %Matuyama/Gauss
	3.110    3.220 '2An.2n ';       %
	3.330    3.580 '2An.3n ';       %Gauss/Gilbert
	4.180    4.290 '3n.1n  ';       %Cochiti
	4.480    4.620 '3n.2n  ';       %Nunivak
	4.800    4.890 '3n.3n  ';       %Sidufjall
	4.980    5.230 '3n.4n  ';       %Thvera
	5.829    6.051 '3An.1n '; % Wei 1995 changes from here on
	6.173    6.450 '3An.2n ';
	6.795    6.943 '3Bn    ';
	6.986    7.019 '3Br.1n ';
	7.183    7.216 '3Br.2n ';
	7.271    7.398 '4n.1n  ';
	7.483    7.902 '4n.2n  ';
	8.055    8.088 '4r.1n  ';
	8.543    8.887 '4An    ';
	9.106    9.191 '4Ar.1n ';
	9.490    9.560 '4Ar.2n ';
	9.670    9.827 '5n.1n  ';
	9.874   11.089 '5n.2n  ';
       11.214   11.273 '5r.1n  ';
       11.738   11.806 '5r.2n  ';
       12.314   12.495 '5An.1n ';
       12.628   12.904 '5An.2n ';
       13.256   13.294 '5Ar.1n ';
       13.379   13.436 '5Ar.2n ';
       13.654   13.843 '5AAn   ';
       14.050   14.312 '5ABn   ';
       14.555   15.021 '5ACn   ';
       15.147   15.677 '5ADn   ';
       15.901   16.007 '5Bn.1n ';
       16.178   16.320 '5Bn.2n ';
       17.289   17.592 '5Cn.1n ';
       17.628   17.800 '5Cn.2n ';
       17.872   18.051 '5Cn.3n ';
       18.617   18.955 '5Dn    ';
       19.603   20.074 '5En    ';
       20.321   21.295 '6n     ';
       21.633   21.814 '6An.1n ';
       22.047   22.324 '6An.2n ';
       22.703   22.780 '6AAn   ';
       23.025   23.107 '6AAr.1n';
       23.284   23.312 '6AAr.2n';
       23.392   23.527 '6Bn.1n ';
       23.572   23.794 '6Bn.2n ';
       24.031   24.183 '6Cn.1n ';
       24.302   24.405 '6Cn.2n ';
       24.573   24.673 '6Cn.3n ';
       25.191   25.235 '7n.1n  ';
       25.281   25.579 '7n.2n  ';
       25.850   25.982 '7An    ';
       26.136   26.247 '8n.1n  ';
       26.284   26.784 '8n.2n  ';
       27.214   28.100 '9n     ';
       28.400   28.625 '10n.1n ';
       28.690   28.854 '10n.2n ';
       29.514   29.779 '11n.1n ';
       29.886   30.228 '11n.2n ';
       30.576   31.103 '12n    '; % mistake in Wei paper 29.576 changed to 30.576
       33.313   33.812 '13n    ';
       34.922   35.200 '15n    ';
       35.586   35.760 '16n.1n ';
       35.909   36.518 '16n.2n ';
       36.771   37.543 '17n.1n ';
       37.660   37.877 '17n.2n ';
       37.941   38.112 '17n.3n ';
       38.389   39.382 '18n.1n ';
       39.451   39.892 '18n.2n ';
       40.898   41.135 '19n    ';
       42.064   43.245 '20n    ';
       45.731   47.511 '21n    ';
       48.778   49.540 '22n    ';
       50.734   50.921 '23n.1n ';
       51.034   51.802 '23n.2n ';
       52.478   52.800 '24n.1n ';
       52.897   52.947 '24n.2n ';
       53.057   53.527 '24n.3n ';
       56.113   56.584 '25n    ';
       57.691   58.027 '26n    ';
       60.850   61.188 '27n    ';
       62.359   63.479 '28n    ';
       63.821   64.613 '29n    ';
       65.578   67.610 '30n    '; % from here on Cande and Kent 1995
       67.735   68.737 '31n    ';
       71.071   71.338 '32n.1n ';
       71.587   73.004 '32n.2n ';
       73.291   73.374 '32r.1n ';
       73.619   79.075 '33n    ';
       83.000  118.000 '34n    '; % KQZ
	118.70  121.81 'M0     '; % Kent & Gradstein, 1986
	122.25  123.03 'M1     '; % note M anoms refer to negative anomalies
	125.36  126.46 'M3     '; % immediately before id
	127.05  127.21 'M5     ';
	127.34  127.52 'M6     ';
	127.97  128.33 'M7     ';
	128.60  128.91 'M8     ';
	129.43  129.82 'M9     ';
	130.19  130.57 'M10    ';
	130.63  131.00 '       ';
	131.02  131.36 '       ';
	131.65  132.53 'M10N   ';
	133.03  133.08 'M11    ';
	133.50  134.31 'M11    ';
	134.42  134.75 '       ';
	135.56  135.66 'M12    ';
	135.88  136.24 '       ';
	136.37  136.64 '       ';
	137.10  137.39 'M13    ';
	138.30  139.01 'M14    ';
	139.58  141.20 'M15    ';
	141.85  142.27 'M16    ';
	143.76  144.33 'M17    ';
	144.75  144.88 'M18    ';
	144.96  145.98 '       ';
	146.44  146.75 'M19    ';
	146.81  147.47 '       ';
	148.33  149.42 'M20    ';
	149.89  151.46 'M21    ';
	151.51  151.56 '       ';
	151.61  151.69 '       ';
	152.23  152.66 'M22    ';
	152.84  153.21 '       ';
	153.49  153.52 '       ';
	154.15  154.48 'M23    ';
	154.85  154.88 '       ';
	155.08  155.21 'M24    ';
	155.48  155.84 '       ';
	156.00  156.29 '       ';
	156.55  156.70 'M25    ';
	156.78  156.88 '       ';
	156.96  157.10 '       ';
	157.20  157.30 '       ';
	157.38  157.46 '       ';
	157.53  157.61 '       ';
	157.66  157.91 'M26    '; % Handschumacher M26+3.14Ma
	158.21  158.46 'M27    '; % for match with KG86
	158.74  158.99 'M28    '; %
	159.24  159.48 'M28a   ';
	159.56  159.84 'M28b   ';
	159.88  160.06 'M29    ';
	160.19  160.75 'M30    ';
	161.09  161.14 'M30a   ';
	161.23  161.41 'M31    ';
	161.59  162.04 'M32    ';
	162.25  162.31 'M32a   ';
	162.38  162.66 'M33    ';
	162.89  163.22 'M34    ';
	163.40  163.49 'M34a   ';
	163.61  163.67 'M34b   ';
	163.82  164.19 'M34c   ';
	164.32  164.53 'M35    ';
	164.72  164.79 'M35a   ';
	164.88  165.18 'M35b   ';
	165.24  165.42 'M36    ';
	165.65  165.99 'M37    ';
	166.11  166.17 'M37a   ';
	166.30  166.38 'M37b   ';
	166.49  166.74 'M37c   ';
	166.76  166.99 'M38    ';
	167.70  200.00 'JQZ    ';
	200.00  300.00 '       '};
 
