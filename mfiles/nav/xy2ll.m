function xy2ll(dlat0,dlon0)
% XY2LL
%   determine scales for lat,lon
%   based on Clarke 1866 spheroid see Bowditch
%   emulates ALVIN TRANSLAT utility
%   see also TRANSLAT.M
%   input:    lat. lon. origin (decimal degrees)
%          xy2ll(dlat0,dlon0)
%   or     xy2ll
%  then asks for x,y to convert
%   output:   prints out lat lon only
% Maurice A. Tivey
%
disp('XY2LL');
disp('Convert Alvin x y to lat lon');
disp('Interactive test version')
if nargin < 1
 disp('Enter origin of Net');
 dlat0=input('Enter latitude in degrees -> ')
 dlon0=input('Enter longitude in degrees -> ')
end

%--------work out scaling (metres per minute of lat, lon):
      radlat = dlat0/(180/pi);
      c1 = cos(radlat);
      c2 = cos(2.*radlat);
      c3 = cos(3.*radlat);
      c4 = cos(4.*radlat);
      c5 = cos(5.*radlat);
      c6 = cos(6.*radlat);
      sclat = (111132.92-559.82*c2+1.175*c4-.0023*c6)
      sclon = (111412.84*c1-93.5*c3+.0118*c5)

x=input('Enter x of net in meters to translate to lat lon -> ')
y=input('Enter y of net in meters to translate to lat lon -> ')
lat=dlat0+(y/sclat);
lon=dlon0+(x/sclon);
fprintf('Lat: %15.5f  Long: %15.5f\n',lat,lon);
latm=(lat-fix(lat)).*60;
lonm=(lon-fix(lon)).*60;
fprintf('Lat %4d %8.4f  Long: %4d %8.4f\n',fix(lat),latm,fix(lon),lonm)
  
