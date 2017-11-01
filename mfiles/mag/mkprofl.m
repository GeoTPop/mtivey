function out=mkprofl(mkp,smon,emon,sday,eday,stime,etime,strike,dx,tdir)
% MKPROFL project trackline data onto a profile with equally spaced data points.
% Uses linear interpolation but could substitute a spline if needed.
%
% Usage: 
%     out=mkprofl(mkp)
%  or 
%     out=mkprofl(mkp,smon,emon,sday,eday,stime,etime,strike,dx,tdir)
%
%   input array mkp must be in the form: 
%    (yr,mon,day,time,x,y,fdep,bathy,fld)
%  smon emon : start and end month
%  sday eday : start and end day
%  stime etime : start and end time
%  strike : strike of profile +ve cw from north
%  dx : spacing of profile points in km
%  tdir : direction of profile, -1 for reverse otherwise 1
%	
%   out array contains [bth,fdp,fld]

format compact
% parameters defined
 degrd=180/pi;
 
fprintf('                     MKPROFL\n')
fprintf('      Project profiles onto a specified azimuth\n')
fprintf(' Based on MKPROFL fortran routine but uses linear interpolation\n')
%
fprintf('\n\n NOTE: Position, depth etc should be in kilometers..\n');
% start time and stop time
 nn=length(mkp);
 yr=mkp(1,1);
 if mkp(nn,1)>yr, 
    disp('program not set up to deal with year rollover');
 end
 time=mkp(:,4);
 jd=juldy(mkp(:,3),mkp(:,2),mkp(:,1));
 jdtime=jd+time./24;
if nargin < 2
 smon=input('Enter start mon (if 0 then use all the data) ');
 if smon == 0
   start=1;
   stop=nn;
   sday=mkp(1,3);
   eday=mkp(nn,3);
   smon=mkp(1,2);
   emon=mkp(nn,2);
   stime=mkp(1,4);
   etime=mkp(nn,4);
 else
  emon=input('Enter end mon 	');
  sday=input('Enter start day 	');
  eday=input('Enter end day 	');
  stime=input('Enter start time ');
  etime=input('Enter end time 	');
 end
 strike=input('Enter azimuth of projected profile in degrees ');
 dx=input('Enter interpolation spacing of new profile in km ');
 tdir=input('Enter sense of direction of new profile (-1 to reverse) ');
end
 jds=juldy(sday,smon,yr)
 jde=juldy(eday,emon,yr)
 stime=jds+stime/24;
 etime=jde+etime/24;
 % find indices
 start=min(find(jdtime>=stime))
 stop=min(find(jdtime>=etime)) 
%
 degmat=dgmat(strike);
 rad=degmat/degrd;
 
mkp=mkp(start:stop,:);
 x=mkp(:,5);
 y=mkp(:,6);
 fdp=mkp(:,7);
 bth=mkp(:,8);
 fld=mkp(:,9);

      npts=length(x);
      c = cos(rad);
      s = sin(rad);
      xp1 = (x(1)*c + y(1)*s);
      xl = 0.;
      yl = 0.;
      ypmin = 1.e10;
      ypmax =-1.e10;
fprintf('Set up for projection: strike,degmat,tdir= %6.1f %6.1f %6.1f\n',strike,degmat,tdir);
      fprintf(' c,s,xp1=%8.3f %8.3f %8.3f\n',c,s,xp1);
%
%----------loop through input points, projecting along strike:
    fprintf(' projection of input data:\n');
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
    fprintf(' %10.3f %10.3f = min,max off-strike excursions\n',ypmin,ypmax);
    fprintf(' %10.3f %10.3f = first,last proj. distances\n',dist(1),dist(npts));
 
%----------interpolate depths, forming zout:
      sdiff = dist(npts)-dist(1);
      nout = abs(sdiff)/dx + 1;
 %     if nout > npdim ,
 %       disp('Error NPDIM exceeds no. of interpolated points');
 %     end
 %     if nout < 0,
 %       disp('Error NPDIM less than no. of interpolated points');
 %     end
      ds = dx;
      if tdir >= 0.,  
%  set up for time-forward interpolation:
%  (if proj. dist. decreases with time, change sign)
       s1 = dist(1);
       if sdiff < 0., ds = -dx; end
      else
%  set up for time-reversed interpolation
%  (if proj. dist. increased with time, change sign)
       s1 = dist(npts);
       if sdiff > 0., ds = -dx; end
      end
%
      s=s1-ds;
      for i=1:nout,
       s=s+ds;
       ss(i)=s;
      end

      fprintf('\n Perform linear interpolation\n')
%----------perform spline interpolation on values:
% could substitute a spline interpolation here
% first check that dist is monotonic
 [sort_dist,sort_i]=sort(dist);
 if min(diff(sort_i)) < 0
  fprintf('Needed to re-sort arrays to make monotonic\n')
  sort_bth=bth(sort_i);
  sort_fdp=fdp(sort_i);
  sort_fld=fld(sort_i);
  newbth=linterp(sort_dist,sort_bth,ss);
  newfdp=linterp(sort_dist,sort_fdp,ss);
  newfld=linterp(sort_dist,sort_fld,ss);
 else
  newbth=linterp(dist,bth,ss);
  newfdp=linterp(dist,fdp,ss);
  newfld=linterp(dist,fld,ss);
 end
nn=length(newbth);
fprintf('Output %6d points for each profile depth,fdepth,field\n',nn);
 out=[newbth newfdp newfld];
 fprintf('finished   \n\n');
%
 fprintf('Profiles can be saved using MATINV2 ...\n');
