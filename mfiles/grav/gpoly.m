function g=gpoly(x0,z0,xcorn,zcorn,ncorn,rho)
% gpoly
% Compute vertical attraction of a two dimensional body
% with polygonal cross-section at observation pt (x0,z0)
% All distances in km
% rho is density in kg/m3
% xcorn,zcorn are coordinates of polygon arranged
% in a clockwise fashion looking at y axis with x-axis
% to the right. z is +ve down
% Usage:
%  g=gpoly(x0,z0,xcorn,zcorn,ncorn,rho)
%
% After Blakely, 1995
% Maurice A. Tivey MATLAB July 2002
%
if nargin < 1
 fprintf('DEMO gpoly')
 help gpoly
 x0=-10:.25:10;
 z0=zeros(size(x0));
 xcorn=[-0.75 -0.75 0.75 0.75];
 zcorn=[1 0.5 0.5 1];
 ncorn=4;
 rho=2670;
 for i=1:length(x0);
  g(i)=gpoly(x0(i),z0(i),xcorn,zcorn,ncorn,rho);
 end
 clf
 subplot(211)
 plot(x0,g)
 xlabel('X-Axis Distance in Kilometers')
 ylabel('Gravity (mgals)')
 title('DEMO gpoly: Gravity over a polygon extending to \infty along y-axis')
 subplot(212)
 plot(x0,z0); hold on;fill(xcorn,zcorn,'r');axis ij
 xlabel('X-Axis Distance in Kilometers');ylabel('Depth (km)')
 max(g)
 return
end

bigG=6.670e-11;
si2mg=1e5;
km2m=1000;
sum=0;
%
for n=1:ncorn,
    if n == ncorn,
        n2=1;
    else
        n2=n+1;
    end
    x1=xcorn(n)-x0;
    z1=zcorn(n)-z0;
    x2=xcorn(n2)-x0;
    z2=zcorn(n2)-z0;
    r1sq=x1*x1+z1*z1;
    r2sq=x2*x2+z2*z2;
    if r1sq==0, fprintf('Field pt is on a corner (insert a NaN)\n'); r1sq=NaN;end
    if r2sq==0, fprintf('Field pt is on a corner (insert a NaN)\n'); r2sq=NaN;end
    denom=z2-z1;
    if denom==0, denom=1e-6; end
    alpha=(x2-x1)/denom;
    beta=(x1*z2-x2*z1)/denom;
    factor=beta/(1+alpha^2);
    term1=0.5*(log(r2sq)-log(r1sq));
    term2=atan2(z2,x2)-atan2(z1,x1);
    sum=sum+factor*(term1-alpha*term2);
end
g=2*rho*bigG*sum*si2mg*km2m;

        