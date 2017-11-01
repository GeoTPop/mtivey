function [l1,t1]=vscale(sclx,scly,ftext,x0,y0)
% plot a vertical scale bar on a map or figure
% interactively if desired
%
% Usage [l1,t1]=vscale(sclx,scly,ftext,x0,y0)
%
% sclx,scly are length and height of scalebar
% ftext is scale label
% x0,y0 are optional lefthand bottom coordinates of scalebar
% if not specfied then you are prompted by a cursor
% on the current figure
%
% output are handles to line and text respectively
% see also pscale.m
% Maurice A. Tivey Feb 1998

format compact
if nargin < 5
 disp('Click on map where you want scale bar')
 [x0,y0]=ginput(1)
end
l1=line([x0+sclx x0 x0 x0+sclx],[y0 y0 y0+scly y0+scly]);
t1=text(x0+sclx,y0+scly/2,ftext,'HorizontalAlignment','left');
return