function varargout = legendbox(HF,LABELS,CC,varargin)
% Create a box legend, returns an axis handle
% Syntax is 
%           legendbox(HF,LABELS,CC,varargin)
% HF is the figure handle
% LABELS is a cell array wih N labels
% CC is a N*3 rgb color matrix
%
% Options are:
%   'alpha'         Alpha value of box colors. Scalar or N-element vector.
%                   Default is 0.5.
%   'linewidth'     Scalar or N-element vector indicating width of lines
%                   (default 1).
%   'fontsize'      Size of text, scalar or N-elements vector.
%   'position'      4-elements position in figure (default [0 0.05 1 .95])
%   'outerposition' Outer position in figure
%   'fliplr'        set the lines on the left of the text (0, default) or
%                   on the right of the text (1).
%
%
% O.Codol 02 Feb. 2020
% codol.olivier@gmail.com
%---------------------------------------------------------


if ~iscell(LABELS); error('labels should be a 1*n cell array'); end
LABELS = LABELS(:);

A       = parsevarargin(varargin,'alpha',.5);
L       = parsevarargin(varargin,'linewidth',1);
N       = size(LABELS,1);
P       = parsevarargin(varargin,'Position',[0 0.05 1 .95]);
FS      = parsevarargin(varargin,'fontsize',floor(500*P(4)/N));
OP      = parsevarargin(varargin,'OuterPosition',[]);
FLR     = parsevarargin(varargin,'fliplr',0);

if numel(L) <N;     L  = repmat(L(:), N,1);     end
if numel(A) <N;     A  = repmat(A(:), N,1);     end
if numel(FS)<N;     FS = repmat(FS(:),N,1);     end

h=axes('Parent',HF,'Position',P); axes(h);
if ~isempty(OP); h.OuterPosition = OP; end
h.Color='none';
h.XAxis.Visible='off';
h.YAxis.Visible='off';

% Flip sides or not
if FLR==1           % labels on the left
    xt=.81;
    X=[.85 .99 .99 .85];
    POS = 'right';
elseif FLR==0       % boxes on the left
    xt=.19;
    X=[.01 .15 .15 .01];
    POS = 'left';
end

M = .1/N;
B = .8/N;

% For each box/label
for k=1:N
   C = CC(k,:);
   Y = [M+B M+B M M]+(k-1)/N;
   patch(X,Y,C,'parent',h,'facealpha',A(k),'edgecolor',C,'linewidth',L(k));
   
   yt=(k-.45)/N;
   text(xt,yt,LABELS{k},'FontSize',FS(k),'HorizontalAlignment',POS)
end

xlim([0 1])

varargout = {h};
