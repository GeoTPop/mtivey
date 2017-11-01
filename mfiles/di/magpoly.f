c magpoly.for
c driver program for the m_poly routine
c Won & Bevis Geophysics 1987
c
      real*8 xv(2048),zv(2048),xs(2048),zs(2048),he,suscept,anginc
      real*8 angstr,anom_z(2048),anom_x(2048),anom_t(2048)
      character*8 fmt/'(3e15.5)'/
c
      kunit=20
      lunit=30
c
      write(*,'(a)')' MAGPOLY - Won & Bevis, 1987'
      open(kunit,file='input00.dat')
c open input file and read parameters stns locations
c  and body coordinates
      read(kunit,*) nstn,nvert,he,anginc,angstr,suscept
c read stn locations
c
      do 10 i=1,nstn
       read(kunit,*) xs(i),zs(i)
 10   continue
c now read body
      do 20 j=1,nvert
       read(kunit,*) xv(j),zv(j)
 20   continue
c
      call m_poly(xs,zs,nstn,xv,zv,nvert,he,anginc,angstr,
     *         suscept,anom_z,anom_x,anom_t)
      open(lunit,file='output00.dat')
      do 50 i=1,nstn
       write(lunit,fmt) anom_z(i),anom_x(i),anom_t(i)
 50   continue
      close(lunit)
      end

      subroutine m_poly(xs,zs,nstn,xv,zv,nvert,he,anginc,angstr,
     *                  suscept,anom_z,anom_x,anom_t)
c Won & Bevis 1987 Geophysics
c  *---> X
c  |
c  |
c  \/
c  Z +ve down
c
c Input:
c  xs,zs  Vectors containing station coordinates
c  xv,zv  Vectors containing polygon vertices ordered in a 
c         clockwise manner as viewed looking towards the negative y axis
c  he     Earth's total magnetic field strength
c  anginc Inclination of Earth's field
c  angstr Strike of the polygon measured counterclockwise from
c         magnetic north looking down.
c suscept Magnetic susceptibility of the polygon in emu
c
c Output:
c  anom_z vertical magnetic anomaly at each station
c  anom_x horizontal magnetic anomaly at each station
c  anom_t total magnetic anomaly at each station
c Usage: [anom_x,anom_z,anom_t]=m_poly(xs,zs,xv,zv,he,anginc,angstr,suscept);
c
c     implicit real*8(a-h,o-z)
      real*8 xv(nvert),zv(nvert),xs(nstn),zs(nstn),x1,z1,x2,z2,x21,z21
      real*8 anom_z(nstn),anom_x(nstn),anom_t(nstn),th1,th2,xst,zst
      real*8 pi,two_pi,dtr,c1,c2,c3,suscept,he,hz,hx,test,x21s,z21s
      real*8 xz12,r1s,r2s,r21s,r1n,p,q,dzz,dzx,dxz,dxx,z21dx21,x21z21
      real*8 fz,fx,anginc,angstr
c
      pi=3.141592654d0
      two_pi=2.0d0*pi
      dtr=pi/180.0d0
c
      c1=dsin(anginc*dtr)
      c2=dsin(angstr*dtr)*dcos(anginc*dtr)
      c3=2.0d0*suscept*he
      
      do 100 is=1,nstn
       xst=xs(is)
       zst=zs(is)
       hz=0.0d0
       hx=0.0d0
       do 50 ic=1,nvert
        x1=xv(ic)-xst
        z1=zv(ic)-zst
        if(ic.eq.nvert)then
          x2=xv(1)-xst
         z2=zv(1)-zst
        else
           x2=xv(ic+1)-xst
         z2=zv(ic+1)-zst
        endif
      
        if (x1.eq.0.0d0 .and. z1.eq.0.0d0) then
         goto 50
        else
         th1=datan2(z1,x1)
        endif
      
        if (x2.eq.0.0d0 .and. z2.eq.0.0d0) then
         goto 50
        else
         th2=datan2(z2,x2)
        endif
      
        if( dsign(1.0d0,z1) .ne. dsign(1.0d0,z2) ) then
         test=x1*z2-x2*z1
         if (test .gt. 0.0d0) then
          if (z1 .ge. 0.0d0) th2=th2+two_pi
         elseif (test .lt. 0.0d0) then
          if (z2 .ge. 0.0d0) th1=th1+two_pi
         else                           
          goto 50
         endif
        endif
      
        t12=th1-th2
        z21=z2-z1
        x21=x2-x1
        x21s=x21*x21
         z21s=z21*z21
        xz12=x1*z2-x2*z1
        r1s=x1*x1+z1*z1
        r2s=x2*x2+z2*z2
        r21s=x21*x21+z21*z21
        r1n=0.5d0*dlog(r2s/r1s)
        p=(xz12/r21s)*((x1*x21-z1*z21)/r1s - (x2*x21-z2*z21)/r2s)
        q=(xz12/r21s)*((x1*z21+z1*x21)/r1s - (x2*z21+z2*x21)/r2s)
      
        if (x21 .eq. 0.0d0) then
         dzz=-p
         dzx=q-z21s*r1n/r21s
         dxz=q
         dxx=p+z21s*t12/r21s
        else
         z21dx21=z21/x21
         x21z21=x21*z21
         fz=(t12+z21dx21*r1n)/r21s
         fx=(t12*z21dx21-r1n)/r21s
         dzz=-p+x21s*fz
         dzx=q-x21z21*fz
         dxz=q-x21s*fx
         dxx=p+x21z21*fx
        endif
      
         hz=c3*(c1*dzz+c2*dzx) + hz
         hx=c3*(c1*dxz+c2*dxx) + hx
 50    continue
c end of vertex for loop
       anom_z(is)=hz
       anom_x(is)=hx
       anom_t(is)=c1*hz+c2*hx
 100  continue
c end of station for loop
      return
      end
