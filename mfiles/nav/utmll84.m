function [dlon1,dlat1]=utmll84(x,y,izone)
% utmll84  Convert UTM to lat long 
% given x y and zone number 
% Use 1984 ellipsoid from 
% Pierson, Map projections - Theory and Applications,1990.
% Snyder, J.P., Map projections - A working manual, USGS
% Prof. paper, 1395, 1987.
% Also see:  http://www.nima.mil
%
% UTM universal transmercator projection has zones 
% which are 6 degrees in longitude and 8 degrees latitude
% measured from the equator and 180 meridian W 
% (zone 1) to 180 meridan E (zone 60)
% 
% constants:
% r  equatorial radius
% e2 eccentricity (e squared)
% k0 scale factor on central meridian of zone
% m  true distance along central meridian from the
%         equator to the specified latitude
% (see also llutm84 for inverse)
%
% Usage: [dlon1,dlat1]=utmll84(x,y,izone)
%
%-------------------------------------------------------
% Maurice A. Tivey October 25, 1991
% MAT Nov. 2000 Fixed flattening
%-------------------------------------------------------

% Clarke 1866 ellipsoid
%      data r/6378206.4/
%      data e2/0.00676866/
%      data k0/0.9996/
% WGS 1972 ellipsoid
%      data r/6378135.0/
%      data e2/0.006694318/
%      data k0/0.9996/
% 1984 ellipsoid
	r=6378137.0;     % equatorial radius
%	e2=0.006705972;  %  
      f	= 0.00335281068; %  1/298.257 flattening
      e2 = 2*f - f*f;
      k0 = 0.9996;
%
% remove 500000. from x for "false eastings" ?
      x=x-500000;
%
% determine zone for calculation of longitude of
% central meridian
      dlon0=(izone-1)*6.-180.+3.;
%fprintf(' UTM zone is %6.0f\n',izone); 
%fprintf(' Central Meridian Latitude is %10.2f\n', dlon0);
%
      e21=e2/(1-e2);
% spheroid calculation
      m=0.+y./k0;
      m0=0.;
      e1=(1.-sqrt(1.-e2))/(1.+sqrt(1.-e2));
      mu=m./(r*(1.-e2/4.-3.*e2*e2/64.-5.*e2*e2*e2/256.));
%
      s2=sin(2.*mu);
      s4=sin(4.*mu);
      s6=sin(6.*mu);
radlat=mu+(3.*e1/2.-27.*e1*e1*e1/32.)*s2+(21.*e1*e1/16.-55.*e1*e1*e1*e1/32.)*s4+(151.*e1*e1*e1/96.)*s6;
%
      dlat=radlat.*57.2957795132;
%
      c=e21.*(cos(radlat)).^2;
      t=(tan(radlat)).^2;
      n=r./sqrt(1-e2.*(sin(radlat)).^2);
      ss=(1-e2.*(sin(radlat)).^2);
      ss=ss.*ss.*ss;
      r1=r*(1-e2)./(sqrt(ss));
      d1=x./(n.*k0);
%
      d2=d1.*d1;
      d3=d2.*d1;
      d4=d3.*d1;
      d5=d4.*d1;
      d6=d5.*d1;
term1=n.*tan(radlat); 
term2=d2./2-(5*3.*t+10.*c-4.*c.*c-9*e21).*d4./24;
term3=(61+90.*t+298.*c+45.*t.*t-252*e21-3.*c.*c).*d6./720;
      rlat1=(term1./r1).*(term2+term3);
      dlat1=dlat-rlat1*57.2957795132;
%
%
terma=(d1-(1.+2.*t+c).*d3./6.);
termb=(5.-(2.*c)+(28.*t)-(3.*c.*c)+(8.*e21)+(24.*t.*t)).*d5./120.;      radln=(terma+termb)./cos(radlat);
      dlon1=dlon0+radln.*57.2957795132;
% output values are in dlat1,dlon1
%      fprintf(' lat: %12.5f\n lon: %12.5f\n',dlat1,dlon1);
