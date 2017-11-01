function ll2xy(dlat0,dlon0)
% translat
%   determine scales for lat,lon
%   based on clarke spheroid, 1866 as in bowditch
%   emulates ALVIN TRANSLAT utility
%   
%   input:    lat. lon. origin (decimal degrees)
%          ll2xy(dlat0,dlon0)
%  asks for lat lon to convert
%   output:   x,y in meters
% Maurice A. Tivey
%
format compact
if nargin < 1
 disp('Enter origin of Net');
 dlat0=input('Enter latitude in degrees -> ')
 dlon0=input('Enter longitude in degrees -> ')
end
%--------work out scaling (metres per minute of lat, lon):
      radlat = dlat0/57.2957795;
      c1 = cos(radlat);
      c2 = cos(2.*radlat);
      c3 = cos(3.*radlat);
      c4 = cos(4.*radlat);
      c5 = cos(5.*radlat);
      c6 = cos(6.*radlat);
      sclat = (111132.09-566.05*c2+1.20*c4-.002*c6);
      sclon = (111415.13*c1-94.55*c3+.012*c5);
lon=input('Enter lon in degrees to translate to x -> ');
lat=input('Enter lat in degrees to translate to y -> ');
y=(lat-dlat0)*sclat;
x=(lon-dlon0)*sclon;
fprintf('X: %15.2f  Y: %15.2f\n',x,y);
