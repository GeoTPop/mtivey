% gm2d test model
%
%
calgrv=1; % 1 compute gravity 0 do not compute gravity
calmag=1; % 1 compute mag 0 do not compute mag
Hintn=50000;   % ambient field intensity
Decl=10;       % declination
Hincl=10;		% inclination
pfang=-20;		% azimuth +xaxis, +cw from N
fht=-5.0;		% obs plane
nbody=1;			% number of bodies
ncor=3;			% number of polygon corners
% corner array (x,z) pairs
Corner=[8 8; 8 6; 11 6];
Corner(:,2)=Corner(:,2)+fht;
% For each body phyc is a row vector containing
% density
% susceptibility cgs units
% strength of remanent magnetization in gammas?
% Inclination of magnetization
% declination of magnetization
phyc(1,1:5)=[0.5 0.001 0 0 0];
face=zeros(50,20);  % initialize body faces
% for each body,face array contains # of vertex in the polygon cross 
% section, their indices in cw order
face(1,1:4)=[3 1 2 3];
xbegin=0;		% start of profile
stn_spcng=1;	% station interval
xend=20;			% end of profile
%
gm2d
% plot
subplot(211);plot(Fz);subplot(212);plot(Dt)