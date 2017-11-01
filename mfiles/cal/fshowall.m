% FSHOWALL         
%  Matlab routine to show calibration of total field
%  depending on what cal parameters exist in the
%  workspace (i.e. xnew lam lam3 lam4)
%  M.A.Tivey Jul 2001
% 
format compact
if exist('lam4')
   fshow4
elseif exist('lam3')
   fshow3
elseif exist('lam')
   fshow2
elseif exist('xnew')
   fshow
else
   fprintf('xnew cal array does not exist')
   return
end
 