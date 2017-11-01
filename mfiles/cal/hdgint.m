function new=hdgint(x,hdg,xi)
% HDGINT  Interpolate heading data
% fix heading data for proper interpolation
% to retain the 360 to 0 discontinuity
% input x: original abscissa
%       hdg: heading data
%       xi: new abscissa
% Output new: interpolated heading data
% new=hdgint(x,hdg,xi);
% Maurice A. Tivey 


%II=find(diff(hdg)>150) % find rollover in hdg
%nlen=length(hdg);
%mark=zeros(length(hdg));
%mark(II+1)=mark(II)+1;
%val=0;
%for i=1:nlen,
% if mark(i)==1,
%  val=val+360;
% end
% newhdg(i)=hdg(i)-val;
%end

% first transform hdg data to a smooth 
% continuous function like a sine curve
 degrad=pi/180;
 qs=sin((hdg-180)*degrad);
 qc=cos((hdg-180)*degrad);
% Note need the cosine to maintain sign info
 
% Now do the interpolation
 newqs=interp1(x,qs,xi);
 newqc=interp1(x,qc,xi); 
% now transform back to heading data
 new=atan2(newqs,newqc)/degrad;
 new=new+180;
%
