function [xout,yout,zout]=grdcut(x,y,z,ax)
% grdcut
% extract a portion of a grid
% Usage:
%    [xout,yout,zout]=grdcut(x,y,z,ax)
% where is an array ax of the bounds 
% Maurice Tivey 
% Dec 10 2011
i1=min(find(x>ax(1)));
i2=min(find(x>ax(2)));
j1=min(find(y>ax(3)));
j2=min(find(y>ax(4)));
xout=x(i1:i2);
yout=y(j1:j2);
zout=z(j1:j2,i1:i2);