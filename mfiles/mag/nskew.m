function [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin,sdec,sdip)
% NSKEW - Compute skewness parameter and amplitude factor
%  following Schouten (1971)
%  Computes GEOCENTRIC DIPOLE unless given
%  declination and dip of magnetization      
% Usage: 
%    [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin)
% or
%    [theta,ampfac]=nskew(yr,rlat,rlon,zobs,slin,sdec,sdip)
%
%  Input variables:
%   yr : decimal year of survey
%   rlat,rlon : regional latitude, longitude in decimal degrees
%   zobs : level of observation in km above sealevel
%   slin : strike of lineations normal to profile (+cw degrees from north)
%   sdec,sdip : magnetization declination,inclination 
% Output variables
%   theta : phase angle
%   ampfac : amplitude factor
% Calls <magfd>
%
% Maurice A. Tivey February 3, 1993
%    checked April 1996
% MATLAB 5 Nov 1998
% See skew.m for more general calculation
%---------------------------------------------------------
rad=pi/180;
% get unit vectors
 colat=90.-rlat;
 y=magfd(abs(yr),1,zobs,colat,rlon);
% compute skewness parameter
 bx=y(1);
 by=y(2);
 bz=y(3);
 bh=sqrt(bx^2+by^2);
 decl1= atan2(by,bx)/rad;
 incl1= atan2(bz,bh)/rad;
 if yr > 0
  fprintf(' EARTH''S MAGNETIC FIELD DIRECTION:\n');
  fprintf(' %10.3f = MAGNETIC DECLINATION ( STRIKE, CW FROM N )\n',decl1);
  fprintf(' %10.4f = MAGNETIC INCLINATION ( DIP, POS DOWN )\n',incl1);
 end
if nargin > 5,
%  NOTE FOR GEOCENTRIC DIPOLE TAN(INC)=2*TAN(LAT)
%if abs(sdec) > 0. | abs(sdip) > 0.
  if yr > 0
   fprintf(' NON-GEOCENTRIC MAGNETIZATION VECTOR SPECIFIED:\n');
   fprintf(' %10.4f = DESIRED MAGNETIZATION DECLINATION (+CW FROM N)\n',sdec);
   fprintf(' %10.4f = DESIRED MAGNETIZATION INCLINATION (+DN)\n', sdip);
  end
else %
 sdip= atan2( 2.*sin(rlat*rad),cos(rlat*rad) )/rad;
 sdec=0;
 if yr > 0
  fprintf(' GEOCENTRIC MAGNETIZATION VECTOR SPECIFIED:\n');
  fprintf(' %10.4f = GEOCENTRIC DIPOLE INCLINATION \n',sdip);
  fprintf(' %10.3f = GEOCENTRIC DECLINATION ASSUMED\n',sdec);
 end
end
% compute phase and amplitude factors
  ra1=incl1*rad;
  rb1=(decl1-slin)*rad;
  ra2=sdip*rad;
  rb2=(sdec-slin)*rad;
% compute phase and amplitude factors
 inclm=atan2(tan(ra2),sin(rb2));
 inclf=atan2(tan(ra1),sin(rb1));
 ampfac=((sin(ra2))*(sin(ra1)))/((sin(inclm))*(sin(inclf)));
 theta=(inclm/rad)+(inclf/rad)-180.;
  if theta <= -360,
    theta = theta+360;
  elseif theta >= 360,
     theta = theta-360;
  end
% compute unit vectors for a check
 hatm(1)=cos(sdip*rad)*sin((sdec-slin)*rad);
 hatm(2)=cos(sdip*rad)*cos((sdec-slin)*rad);
 hatm(3)=-sin(sdip*rad);
 hatb(1)=cos(incl1*rad)*sin((decl1-slin)*rad);
 hatb(2)=cos(incl1*rad)*cos((decl1-slin)*rad);
 hatb(3)=-sin(incl1*rad);
 %
if yr > 0
 fprintf('  %10.6f %10.6f %10.6f = MAGNETIZATION UNIT VECTOR\n',hatm(1),hatm(2),hatm(3));
 fprintf('  %10.6f %10.6f %10.6f = AMBIENT FIELD UNIT VECTOR\n',hatb(1),hatb(2),hatb(3));
 fprintf('  COMPONENTS ARE (X,Y,Z=ALONG, ACROSS PROFILE, AND UP\n\n');
end
 %
