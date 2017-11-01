function gz=gvcyl(x0,z0,xq,zq,a,rho);
% gcyl
% Compute gravity effect of a buried vertical cylinder
% located at xq,zq as measured
% at an observation point (x0,z0)
% Output two components of gravitational
% attraction
% a is radius of the cylinder
% rho is density in kg/m3
% Z-axis is +ve vertical down
% All distances are in kilometers.
%
% Usage:
%   gz=gvcyl(x0,z0,xq,zq,a,rho);
%
% After Telford et al., 1976
% eq. 2.45a 2.45b
%
% Maurice A. Tivey  MATLAB Oct 2007
%
if nargin < 1
 fprintf('DEMO gvcyl')
 help gvcyl
 x0=-1:0.005:1;
 z0=zeros(size(x0));
 xq=0;
 zq=0.02;
 a=0.05;  % 50 m radius cylinder
 rho=2787-2670; % 5% FeS mineralization 
for i=1:length(x0);
 gz(i)=gvcyl(x0(i),z0(i),xq,zq,a,rho);
end
 clf
 plot(x0,gz)
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO gvcyl: Gravity over a buried vertical cylinder')
 return
end

% fixed parameters
 bigG=6.670e-11;
 si2mg=1e5;
 km2m=1000;
% 
rx=x0-xq;
rz=z0-zq;
r2=sqrt(rx.*rx+rz.*rz);
if r2==0, fprintf('Error \n'); return; end
tmass=2*pi*bigG*rho;
%gz=tmass*sqrt(a^2+zq^2);
%
theta=atan(rx./rz);
mu=cos(theta);
P1=legendre(1,mu);
P2=legendre(2,mu);
P3=legendre(3,mu);
P4=legendre(4,mu);
% see Telford, 1976
% z depth of cylinder; R radius of cylinder; r distance from axis
% for z<r<R
gz1=tmass*a*(1-(r2/a).*P1(1,:) + 0.5*(r2/a).^2.*P2(1,:) + 0.125*(r2/a).^4.*P3(1,:) );
% for r>R>z
gz2=tmass*a*(0.5*(a/r2) - 0.125*(a/r2).^3.*P2(1,:) + (1/16)*(a/r2).^5.*P4(1,:) );

ii=(find((r2-a)<=0));% inside
jj=(find((r2-a)>0)); % outside 
gz2(ii)=0;gz1(jj)=0;
gz=gz1+gz2;
% convert to milligals
gz=gz*si2mg*km2m;

                
        