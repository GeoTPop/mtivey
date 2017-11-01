function [x,y]=llutm84(dlat,dlon,isyes,izone)
% llutm84 Convert lat long to UTM coordinates 
%   
% Use 1984 Ellipsoid from 
% Pierson, Map projections - Theory and Applications, 1990.
% Snyder, J.P., Map projections - A working manual, USGS
% Prof. paper, 1395, 1987.
% Also see:  http://www.nima.mil

% UTM universal transmercator projection has zones 
% which are 6 degrees in longitude and 8 degrees latitude
% measured from the equator and 180 meridian W 
% (zone 1) to 180 meridan E (zone 60)
% 
% constants:
% r  equatorial radius
% e2 eccentricity
% k0 scale factor on central meridian of zone
% m  true distance along central meridian from the
%         equator to the specified latitude
% 1984 ellipsoid version 
%
% Usage: [x,y]=llutm84(dlat,dlon,isyes,izone)
% if isyes ==1 then print out zone id
% if you provide the zone then it will use that
%-------------------------------------------------
% Maurice A. Tivey April 17, 1992
%-------------------------------------------------

% Clarke 1866 ellipsoid
%      r=6378206.4;
%      e2=0.00676866;
% WGS 1972 ellipsoid (built into GPS receivers)  
%      r=6378135.0;
%      e2=.006694318;
% 1984 ellipsoid
      r=6378137.0;       % equatorial radius
%      e2=0.006705972;   %
      f	= 0.00335281068; %  1/298.257 flattening
      e2 = 2*f - f*f;
      k0=0.9996;
%
% determine zone for calculation of longitude of
% central meridian
[nx,ny]=size(dlat);
if ny>1, dlat=dlat'; dlon=dlon'; end
if nargin < 4,
 izone=fix((dlon(1)+180.)/6.)+1;
end
      dlon0=(izone-1)*6.-180.+3.;
      radln0=dlon0/57.2957795132;
if isyes==1,
 fprintf(' UTM zone is %6.0f\n',izone);
 fprintf(' Central Meridian Longitude is %10.4f\n', dlon0);
end
%
      radlat=dlat/57.2957795132;
      radln=dlon/57.2957795132;
      e21=e2/(1-e2);
      n=r./sqrt(1-e2.*(sin(radlat)).^2);
      t=(tan(radlat)).^2;
      c=e21*(cos(radlat)).^2;
      a=(cos(radlat)).*((dlon-dlon0)./57.2957795132);
%
      s2=sin(2.*radlat);
      s4=sin(4.*radlat);
      s6=sin(6.*radlat);
      e4=e2*e2;
      e6=e2*e4;
% simplified calculation for Clarke ellipsoid
%     m=(111132.0894*dlat)-(16216.94*s2)+(17.21*s4)-(.02*s6)
% full expression for other ellipsoids
terma=(1-e2/4.-3.*e4/64.-5*e6/256.);     
termb=(3*e2/8.+3*e4/32.+45*e6/1024.);
termc=(15*e4/256.+45*e6/1024.);
termd=(35*e6/3072.);
m=r.*(terma.*radlat-termb.*s2+termc.*s4-termd.*s6);
      m0=0.;
%
      a2=a.*a;
      a3=a.*a.*a;
      a4=a2.*a2;
      a5=a3.*a2;
      a6=a3.*a3;
      x=k0.*n.*(a+(1.-t+c).*a3./6.+(5.-18.*t+t.*t+72.*c-58.*e21).*a5./120.);
term1=n.*tan(radlat); 
term2=(5-t+9.*c+4.*c.*c).*a4./24;
term3=(61-58.*t+t.*t+600.*c-330*e21).*a6./720;

     y=k0.*((m-m0)+term1.*(a2./2+term2+term3));
%
% add 500000. to x to complete "false eastings"
      x=x+500000.;
%      fprintf(' x= %12.1f\n y= %12.1f\n',x,y);
% finished
