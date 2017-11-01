function s = field(vec)
% FIELD
%  Minimize the total field variation
%  of the ALVIN magnetometer by varying
%  offsets and calibration factors.
%  Loads local file junk.mat which contains tf,xf,
% yf,zf and ref (the reference field to minimize to)
%  Usage:
%          xnew=fmins('field',[vec(1),vec(2)... ])
%
% M.A.Tivey Feb 24, 1992
% July 1994
% Oct 1997 Matlab V5
% See FSHOW for plotting results
%
beta=1.0;
format compact
% load .MAT data file saved previously
%   with array variables xf,yf,zf,tf
% 
load junk
%xf=detrend(xf);
%yf=detrend(yf);
%zf=detrend(zf);
%tf=detrend(tf);

% initialise the mean field
 % known=mean(tf);
 known=ref;

% Set starting values for offsets
% note can only solve for a max of 5 variables in 'vec'
% these variables represent the "permanent magnetic field"
% of the sensor environment
     xdc=vec(1)*ones(size(xf));
     ydc=vec(2)*ones(size(yf));
     zdc=vec(3)*ones(size(zf));
%    xcf=vec(4)*ones(size(xf));
%    ycf=vec(5)*ones(size(yf));
     zcf=1.0;
     xcf=1.0;
     ycf=1.0;
%
tf1=sqrt(((xf-xdc).*xcf).^2+((yf-ydc).*ycf).^2+((zf-zdc).*zcf).^2);
%    
% minimum roughness norm
     tfdif=diff(tf1);
     tfmn=abs(known-mean(tf1));
     s=sqrt(sum(tfdif.^2))+beta*(tfmn.^2);
% without mean
%       s=sqrt(sum(tfdif.^2));
% minimum variation norm note this will not
% necessarily give a good 2alpha signal
%    s=max(tf1)-min(tf1)+ beta*(tfmn);
%    s=max(tf1)-min(tf1)

%    s=sqrt((max(tf1)-min(tf1)).^2)+beta*(tfmn.^2);
% JQZ version
%    s=max(abs(tf1-known))+beta*(sqrt(sum(tfdif.^2)));

