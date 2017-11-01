function [newx,newy]=mkprftrk(mkp,smon,emon,sday,eday,stime,etime,strike,dx,tdir)
% mkprftrk - Make projected track coordinates along original trackline
% Usage: [newx,newy]=mkprftrk(mkp,smon,emon,sday,eday,stime,etime,strike,dx,tdir)
% Use mkprofl and project the x,y instead of bathy and fdep
% Maurice Tivey
%
mkp(:,7)=mkp(:,5);
mkp(:,8)=mkp(:,6);
out=mkprofl(mkp,smon,emon,sday,eday,stime,etime,strike,dx,tdir);
newx=out(:,2);
newy=out(:,1);
return
 
% Version 2 more complicated??
% Reproject profile back onto trackline
% Bend projected profile back onto original trackline
degrad=pi/180;
% done in terms of distance along track
% first calculate distance along track from starting position
nx=length(prf);
prf_dist=cum((0:nx-1).*dx);
 degmat=dgmat(strike);
 rad=degmat/degrd;
% find starting point of original track and calculate 
% along track distance
      npts=length(x);
      c = cos(rad);
      s = sin(rad);
      xp1 = (x(1)*c + y(1)*s);
      xl = 0.;
      yl = 0.;
      ypmin = 1.e10;
      ypmax =-1.e10;
    for i=1:npts
       xp = (x(i)*c + y(i)*s);
       yp = y(i)*c - x(i)*s;
       dist(i) = xp - xp1;
       delx = x(i)-xl;
       dely = y(i)-yl;
       cse = 0.;
         if delx==0. & dely==0., 
           xl = x(i);
           yl = y(i);
         else
           deg = atan2(dely,delx)*degrd;
           cse = dgnav(deg);
           xl = x(i);
           yl = y(i);
          end
         ypmin = min([ypmin,yp]);
         ypmax = max([ypmax,yp]);
     end

  prf_x=linterp(prf_dist,x,dist);
  prf_y=linterp(prf_dist,y,dist);
