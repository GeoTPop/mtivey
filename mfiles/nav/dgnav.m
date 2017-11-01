function out=dgnav(in)
%------------------------------------------------------
%  CONVERT FROM MATHEMATICIAN'S TO NAVIGATOR'S ANGLES
%  NAV + CW FROM N,  MATH + CCW FROM E
%  USED IN PROG. <MKPROFL>, CALLED BY SUB. <(MISC.)>
%
%  CALLS SUB.<(NONE)>
%------------------------------------------------------
%  S. MILLER MERVS MACLIB 22-AUG-84
%  M.A.TIVEY 2-APR-85 
%  Maurice A. Tivey June 27, 1991 Unix Version
%  <MERVS.LIB>
%------------------------------------------------------
      out = 90.-in;
      if out < 0.,
       out = 360+out;
      end
