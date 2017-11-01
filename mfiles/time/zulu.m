function z=zulu(time,shift)
% zulu
% convert time to GMT by entering shift
%
% Usage: z=zulu(time,shift)
% Maurice A. Tivey   September 15, 1992

z=time+shift;
npts=length(time);
for i=1:npts,
 if z(i) >=24.,
  z(i)=z(i)-24;
 end
end
%
