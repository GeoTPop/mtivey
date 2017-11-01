function J=smvect(YR,RLAT,RLON,ALTKM,SLIN,SDEC,SDIP)
% SMVECT - Get magnetization and field vectors using IGRF
% 
% Usage: y=smvect(yr,rlat,rlon,altkm,slin,sdec,sdip)
%  yr : input year of survey (decimal year)
% rlat,rlon : regional latitude, longitude of survey (dec. degrees)
% altkm : observation level relative to sealevel (km +ve up)
% slin : strike of lineations (+CW from North) normal to profile
% sdec,sdip : declination, inclination of magnetization. If set to zero
%           use Geocentric dipole assumption (sdec=0).
%  NOTE :  IN PARKER'S DEFINITION THE PROFILE LINE IS INITIALLY:
%               Y IS +VE NORTH
%               X IS +VE EAST
%               Z IS +VE UP
% Usage: out=smvect(YR,RLAT,RLON,ALTKM,SLIN,SDEC,SDIP)
%
%  S MILLER INV2D MACLIB 10-JULY-84
%  M.A.TIVEY 17-FEB-88 MS-FORTRAN V. 4.0
%  M.A.TIVEY March 5, 1991 MATLAB
%  M.A.TIVEY March 1998 MATLAB 5 add magfd for any year
% calls <magfd>

DEGRD = 180./pi;
fprintf(' COMPUTE IGRF FOR %10.4f = YEAR \n %10.4f = LAT (DEC DEG)\n',YR,RLAT);
fprintf(' %10.4f = LON \n %10.4f = ALT ABOVE SEA LEVEL (KM) \n',RLON,ALTKM);
fprintf(' %9.3f = STRIKE OF Y-AXIS, NORMAL TO PROFILE (CW FROM NORTH)\n',SLIN);
COLAT = 90.-RLAT;
%
q=magfd(YR,1,ALTKM,COLAT,RLON);
%
X=q(1);
Y=q(2);
Z=q(3);
T=q(4);
fprintf(' COMPUTED FIELD COMPONENTS ARE \n X = %10.2f (NORTH)\n',X);
fprintf(' Y = %10.2f (EAST)\n',Y);
fprintf(' Z = %10.2f (POS DOWN)\n',Z);
fprintf(' T = %10.2f TOTAL FIELD\n',T);
	DEC   = atan2(Y,X)*DEGRD;
	HORIZ = sqrt(X^2+Y^2);
	DIP = atan2(Z,HORIZ)*DEGRD;
%  NOTE FOR GEOCENTRIC DIPOLE TAN(INC)=2*TAN(LAT)
	GDIP = atan2( 2.*sin(RLAT/DEGRD),cos(RLAT/DEGRD) )*DEGRD;
	fprintf(' %10.3f = MAGNETIC DECLINATION ( STRIKE, CW FROM N )\n',DEC);
	fprintf(' %10.4f = MAGNETIC INCLINATION ( DIP, POS DOWN )\n',DIP);
	fprintf(' %10.4f = GEOCENTRIC DIPOLE INCLINATION \n',GDIP);
	RMDIP = GDIP/DEGRD;
	RMDEC = 0.;
if abs(SDEC) > 0. & abs(SDIP) > 0.
	fprintf(' NON-GEOCENTRIC MAGNETIZATION VECTOR SPECIFIED:\n');
	fprintf(' %10.4f = DESIRED MAGNETIZATION DECLINATION (+CW FROM N)\n',SDEC);
	fprintf(' %10.4f = DESIRED MAGNETIZATION INCLINATION (+DN)\n', SDIP);
	RMDIP = SDIP/DEGRD;
	RMDEC = SDEC/DEGRD;
%  COMPUTE MAGNETIZATION AND AMBIENT FIELD UNIT VECTORS, A LA PARKER
%
%  NOTE THAT PARKER'S DEFINITION OF X,Y,Z IS
%  X IS EAST, Y IS NORTH, Z IS UP
%  TO GET A PROFILE IN THE NORTH DIRECTION (I.E. ALONG X) SLIN =-90.
%
%  X = ALONG PROFILE
%  Y = NORMAL TO PROFILE, IE PARALELL TO LINEATIONS
%  Z = POSITIVE UP ( IN CONTRAST TO ALMOST EVERYONE ELSE)
end
%
	RS = SLIN/DEGRD;
	RDEC = DEC/DEGRD;
	RDIP = DIP/DEGRD;
	HATM(1) =  cos(RMDIP)*sin(RMDEC-RS);
	HATM(2) = cos(RMDIP)*cos(RMDEC-RS);
	HATM(3) = -sin(RMDIP);
	HATB(1) =  cos(RDIP)*sin(RDEC-RS);
	HATB(2) =  cos(RDIP)*cos(RDEC-RS);
	HATB(3) = -sin(RDIP);
fprintf('  %10.6f %10.6f %10.6f = MAGNETIZATION UNIT VECTOR\n',HATM(1),HATM(2),HATM(3));
fprintf('  %10.6f %10.6f %10.6f = AMBIENT FIELD UNIT VECTOR\n',HATB(1),HATB(2),HATB(3));
fprintf('  COMPONENTS ARE (X,Y,Z=ALONG, ACROSS PROFILE, AND UP)\n');
J(1:3)=HATB;
J(4:6)=HATM;
%
