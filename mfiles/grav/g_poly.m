function out=g_poly(xs,zs,xv,zv,den)
%
% Computes the vertical component of gravitational acceleration
% due to a polygon in a two-dimensional space (x,z), or
% equivalently due to an infinitely long polygonal cylinder 
% striking in the Y-direction in a three-dimensional space.
%  Won & Bevis, Computing the gravitational and magnetic anomalies due to a
%  polygon: Algorithms and Fortran subroutines, Geophysics, 52, 232-238, 1987.
%
%  *---> X
%  |
%  |
%  \/
%  Z +ve down
%
% Input:
%  xs,zs  Vectors containing station coordinates
%  xv,zv  Vectors containing polygon vertices ordered in a 
%         clockwise manner as viewed looking towards the negative y axis
%  den    polygon density
% Output:
%  grav_z vertical component of gravitational acceleration
%         due to a polygon at each of the stations
% Usage: grav_z=g_poly(xs,zs,xv,zv,den);
% Maurice A. Tivey 2 June 1994.
%
% Units
% Density	Gravity		Length	Constant
% gm/cm3	mgals		  km	13.3464e+0
% gm/cm3	mgals		   m	13.3464e-3
% gm/cm3	mgals		 kft	 4.0680e+0
% km/m3		mm/s2	 	 m	13.3464e-8
%
dtr=pi/180;
twopi=2*pi;
con=13.3464;  % edit for appropriate units
if nargin < 1,
 help g_poly
 % this is a test model to compare with 
 % x0=-10:.1:10;z0=zeros(size(x0));y0=zeros(size(x0));
 % x1=-0.5;x2=0.5;y1=-10;y2=10;z1=1;z2=2;rho=2670;
 % f=gbox2d(x0,y0,z0,x1,y1,z1,x2,y2,z2,rho);
%
 xs=0:.1:12.7;
 zs=zeros(size(xs));
 %xv=[5 6 6 5];
 %zv=[1 1 2 2];
 xv=[5 6.5 6.5 5];
 zv=[0.5 0.5 1 1];
 den=2.67;
 out=g_poly(xs,zs,xv,zv,den);
 subplot(211)
 plot(xs,out');title('DEMO g poly : Forward Gravity Field Model polygon extends to infinity');
 ylabel('Gravity Field')
 axis([-4 14 0 30])
 subplot(212)
 plot(xs,-zs); hold on; 
 %plot([xv xv(1)],[-zv -zv(1)]);
 fill([xv(1),xv(2),xv(3),xv(4)],[-zv(1),-zv(2),-zv(3),-zv(4)],'r');
 hold off
 axis([-4 16 -1 0])
 xlabel('Distance');ylabel('Depth')
 max(out)
end

nstn=length(xs);   % number of stations
nvert=length(xv);  % number of vertices
for is=1:nstn,	% loop over stations
 grav=0;
 xst=xs(is);
 zst=zs(is);
 for ic=1:nvert,	% vertex loop
  gz=0;
  x1=xv(ic)-xst;
  z1=zv(ic)-zst;
  if ic == nvert, 
   x2=xv(1)-xst;
   z2=zv(1)-zst;
  else  
   x2=xv(ic+1)-xst;
   z2=zv(ic+1)-zst;
  end
%
  if (x1==0 & z1==0),
   break
  else
   th1=atan2(z1,x1);
  end
  
  if (x2==0 & z2==0),
   break
  else
   th2=atan2(z2,x2);
  end

  if sign(z1) ~= sign(z2)
   test=x1*z2-x2*z1;
   if test > 0.0,
    if z1 >= 0.0, th2=th2+twopi; end
   elseif test < 0.0,
    if z2 >= 0.0, th1=th1+twopi; end
   else
    break
   end
  end
%
  t12=th1-th2;
  z21=z2-z1;
  x21=x2-x1;
  xz1=x1*x1+z1*z1; 
  xz2=x2*x2+z2*z2;
%
  if x21 == 0.0,
   gz=0.5*x1*log(xz2/xz1);
  else
   gz=x21*(x1*z2-x2*z1)*(t12+0.5*(z21/x21)*log(xz2/xz1))/(x21*x21+z21*z21);
  end
%
  grav=grav+gz;
 end  % end of vertex for loop
 grav_z(is)=con*den*grav;
end	% end of station for loop
out=grav_z;
% done
    
