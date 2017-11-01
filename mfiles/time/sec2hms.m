function [h,m,s] = sec2hms(t)
% sec2hms
% convert seconds in day to h,m,s
% Usage:
%   [h,m,s] = sec2hms(t)
%
% Maurice A. Tivey Jul 2001
% MATLAB5
h = floor(t/3600);
m = floor((t-h*3600)/60);
s = t-h*3600-m*60;
