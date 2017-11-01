% gm2d.m
% compute simultaneous gravity and magnetic fields
% of  2D body
% distances in meters
% magnetization in gammas, susc in cgs units
% gravity field in mgals
% Singh 2002
X=(xbegin:stn_spcng:xend)';
%
nstn=size(X);
if calgrv
   Gc=6.6732e-3; % universal gravitational constant
   Fx=zeros(size(X));
   Fz=Fx;
end
if calmag
   Hx=zeros(size(X));
   Hz=Hx;
   Hin=Hincl*pi/180;
   Dec=Decl*pi/180;
   pfan=pfang*pi/180;
   cx=cos(Hin)*cos(pfan-Dec);
   cz=sin(Hin);
   Uh=[cx cz];
   H=Hintn.*Uh;
end
%
for body=1:nbody,
   if calgrv, dens=phyc(body,1); end
   if calmag, 
      Susc=phyc(body,2); 
      Ms=phyc(body,3);
      Mincl=phyc(body,4);
      Mdecl=phyc(body,5);
      Ind_magn=Susc.*H; % Induced magnetization
      Min=Mincl*pi/180;
      Mdec=Mdecl*pi/180;
      mcx=cos(Min)*cos(pfan-Mdec);
      mcz=sin(Min);
      Um=[mcx mcz];
      Rem_magn=Ms.*Um;   % Remanent Magnetization
      Net_magn=Rem_magn+Ind_magn;
   end
   % obs stations
   for stn=1:nstn,
      obspt=[X(stn) 0];
      nc=face(body,1);
      Un=zeros(nc,2);
      for f=1:nc,
         % find outward normal vectors for each facet
         p1=Corner(face(body,f+1),:)-obspt;
         if f==nc,
            p2=Corner(face(body,2),:)-obspt;
         else
            p2=Corner(face(body,f+2),:)-obspt;
         end
         v2=p2-p1;
         Un1(f,:)=[v2(2)-v2(1)];
         Un(f,:)=Un1(f,:)/norm(Un1(f,:));
         % Find if face is seen from outside or inside
         dp=sum(Un(f,:).*p1);fsign=sign(dp);
         dp1=abs(dp);r1=norm(p1);r2=norm(p2);
         % Find solid angle
         if dp1==0, 
            Omega=-fsign*2*pi;
         else
            ua=p1./r1;ub=p2./r2;
            rdot=sum(ua.*ub);
            ang=acos(rdot);
            W=2*ang;
            Omega=-fsign*W;
         end
         % Find line integral
         Q=2*(log(r2/r1));
         l=Un(f,1);n=Un(f,2);
         % Now using Omega,1,n and Q get hx,hz due to face f
         if calmag==1 & calgrv==1
            Pd=sum(Un(f,:).*Net_magn); % surafec pole density
            md=-Gc*dens*dp;
            hx=(l*Omega+n*Q);
            hz=(n*Omega-1*Q);
            Hx(stn)=Hx(stn)+Pd*hx;
            Hz(stn)=Hz(stn)+Pd*hz;
            Fz(stn)=Fz(stn)+md*hz;
         end
         if calgrv==1 & calmag==0,
            md=-Gc*dens*dp; % surface mass density
            hz=(n*Omega-l*Q);
            Fz(stn)=Fz(stn)+md*hz;
         end
         if calmag==1 & calgrv==0,
            Pd=sum(Un(f,:).*Net_magn);
            hx=(l*Omega + n*Q);
            hz=(n*Omega - l*Q);
            Hx(stn)=Hx(stn)+Pd*hx;
            Hz(stn)=Hz(stn)+Pd*hz;
         end
      end
   end
end
if calmag==1
   Htot=sqrt((Hx+H(1,1)).^2+(Hz+H(1,2)).^2);
   Dt=Htot-Hintn; % Correct change in total field
   Dta=Hx.*cx+Hz.*cz; % Approx change in total field
end

