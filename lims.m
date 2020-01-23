function [XLIM,YLIM,varargout] = lims(X,Y,varargin)
% Defines limits of a plot
% Syntax is:
%       [XLIM,YLIM,varargout] = lims(X,Y,varargin)
%
% One of the inputs can be empty. If so, it is simply ignored.
%       e.g. [XLIM,YLIM] = lims( [] , randn(100,1) )
%
% Returns the limit values for X and Y
% varargout is an axis handle, if requested
%
%  ---options are:
%   'parent'        : parent axis handle (optional)
%                       if an axis handle is given, limits are
%                       automatically applied to it.
%   'margin'        : size of the margin  relative to range of the data
%                       format is [marginX , marginY]
%                       default 5% of data range, i.e. [0.05,0.05]
%   
% O.Codol 4th May 2019
% codol.olivier@gmail.com
%---------------------------------------------------------


m = parsevarargin(varargin,'margin',[0.05,0.05]);
h = parsevarargin(varargin,'parent',0);

if ~isempty(X)
    XLIM = [min(min(X)), max(max(X))];
    XLIM = [XLIM(1)-diff(XLIM)*m(1) XLIM(2)+diff(XLIM)*m(1)];
else
    XLIM = nan(1,2);
end
if ~isempty(Y)
    YLIM = [min(min(Y)), max(max(Y))];
    YLIM = [YLIM(1)-diff(YLIM)*m(2) YLIM(2)+diff(YLIM)*m(2)];
else
    YLIM = nan(1,2);
end

if ~isclass('double',h)
    if ~isempty(X); h.XLim = XLIM; end
    if ~isempty(Y); h.YLim = YLIM; end
end

varargout = {h};

end

