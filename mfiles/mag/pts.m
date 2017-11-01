function [xf,yf,zf]= pts(npt,ifcont,fid);
% based on subroutine pts (plouff)
% read in field points
% Usage:
%    [xf,yf,zf]= pts(npt,ifcont,fid);
% <used in prism3d>
% <>
% Maurice Tivey Feb 1999 
 nk=0;
 kode=fscanf(fid,'%d',1);
 kend=fscanf(fid,'%d',1);
 vals=fgetl(fid);
 if kode == 5 | kode == 55,
    if kend-1 < 0
       % random point format z-x-y-anomaly
       fprintf('\n\nRead random points: \n')
       nval=sscanf(vals,'%f');
       zf(1)=nval(1); % altitude of observation
       xf(1)=nval(2); % northing of observation
       yf(1)=nval(3); % easting of observation
       fprintf('%d x= %f y= %f z= %f\n',i,xf(1),yf(1),zf(1));
       % ok loop to get rest of the points ending with a 55 card
       for i=2:npt
         kode=fscanf(fid,'%d',1);
         if kode == 55,
          nk=i;
          break; 
         end
         kend=fscanf(fid,'%d',1);
         vals=fgetl(fid);
         nval=sscanf(vals,'%f');
         zf(i)=nval(1);
         xf(i)=nval(2);
         yf(i)=nval(3);
         fprintf('%d x= %f y= %f z= %f\n',i,xf(i),yf(i),zf(i));
       end
    elseif kend-1 == 0,
       % 1d profile sequence z-x1-y1-x2-y2-ds
       fprintf('Read id profile of points \n')
       nval=sscanf(vals,'%f');
       dx=nval(4)-nval(2);
       dy=nval(5)-nval(3);
       dist=sqrt(dx*dx+dy*dy);
       dx=nval(6)*dx/dist;
       dy=nval(6)*dy/dist;
       ns=nk+1;
       xs=nval(2)-dx;
       ys=nval(3)-dy;
       n1=1.5*dist/nval(6);
       nb=0;
       %
       while nb <= n1,
          xs=xs+dx;
          nb=nb+1;
          ys=ys+dy;
          nk=nk+1;
          zf(nk)=nval(1);
          xf(nk)=xs;
          yf(nk)=ys;
       end      
       xs=xs-dx;
       fprintf('points %d to %d spaced at %f %s\n',ns,nk,nval(6),unit);
       fprintf(' apart along a profile from %f x %f y to %f x %f  y\n',nval(2),nval(3),xs,ys);
       fprintf(' depth= %f %s\n',nval(1),unit)
         if kode == 55,
          nk=i;
          break; 
         end
    end
else
   fprintf(' Error in fieldpoint card for contour usage or wrong\n');
   fprintf('  digits in columns1-4\n',kode,kend)
end
return
