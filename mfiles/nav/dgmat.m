function out=dgmat(in)
% DGMAT
%  CONVERT FROM NAVIGATOR'S TO MATHEMATICIAN'S ANGLES
%  NAV + CW FROM N,  MATH + CCW FROM E% 
%  CALLED BY SUB. <(MISC.)>
%
%  S. MILLER MERVS MACLIB 22-AUG-84
%  M.A.TIVEY 2-APR-85 
%  Maurice A. Tivey June 27, 1991 Unix Version
      out = 90.-in;
      if out < 0.,
       out = 360+out;
      end
