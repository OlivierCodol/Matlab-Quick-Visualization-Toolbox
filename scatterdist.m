function [hF,hA] = scatterdist(Xi,Yi,varargin)
% Creates a scatter plot with histograms either side
% Syntax is
%       hF = scatterdist(Xi,Yi,varargin)
% Xi and Yi must be a cell array with each cell containing one group's
% data, or a n*nG matrix where nG is the number of groups and n the number
% of observations.
% Returns a figure handle
%
%  ---options are:
%   'parent'        : parent figure handle (default make new figure). If an
%                     axis is provided, its parent figure is used.
%   'alpha'         : patch transparency value (default .5) for the
%                     distribution. Set to 0 to remove any patch color.
%   'color'         : n*3 matrix of rgb (default all black)
%   'markersize'    : size of individual datapoints (default 5)
%   'xlim'          : specify the limits in the x-axis manually. By default
%                     this includes all datapoints and adds 10% of the data
%                     range on each side of the data.
%   'ylim'          : same as xlim but on the y-axis.
%   'position'      : 4-element vector indicating the area in the figure in
%                     which to plot. Default is [.1 .1 .9 .9].
%   'hd'            : 'histogram' or 'distribution', to specify if the
%                     distributions either side should be in the form of a
%                     histogram or a distribution. Alternatively, 1 and 2
%                     can be employed for histogram and distribution,
%                     respectively. Default is distribution.
%   'nbins'         : number of bins for the histograms (default 5). Can
%                     provide a 2-elements vector to specify different
%                     number of bins for X (1st element) and Y (2nd). If
%                     'hd' is set as 'distribution' or 2, this input is
%                     ignored.
% 
%---------------------------------------------------------
% Peter J. Holland (U. of Birmingham, UK) & Olivier Codol
% 11th Sept. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

% Convert input X and Y class to cell if needed
if isa(Xi,'double'); Xc = mat2cell(Xi,size(Xi,1),ones(1,size(Xi,2))); end
if isa(Yi,'double'); Yc = mat2cell(Yi,size(Yi,1),ones(1,size(Yi,2))); end


nG      = numel(Xi);
a       = parsevarargin(varargin,'alpha',.5);
mk      = parsevarargin(varargin,'markersize',5);
nbins   = parsevarargin(varargin,'nbins',5);
cc      = parsevarargin(varargin,'color','k');
if size(cc,1)==1; cc = repmat(cc,[nG,1]); end
if numel(nbins)==1; nbins(2)=nbins; end; nbins = ceil(nbins);


hd = parsevarargin(varargin,'hd','distribution'); % hist. or distribution
if isa(hd,'char') && strcmpi(hd,'histogram')
    hd=1;
elseif isa(hd,'char') && strcmpi(hd,'distribution')
    hd=2;
elseif isa(hd,'double') && ~(hd==1 || hd==2)
    error('hd must be 1 (distribution) or 2 (histogram)')
elseif isa(hd,'char')
    error('hd must be ''distribution'' or ''histogram''')
end

% Complicated parsing of 'parent' to ensure hF is a figure handle
hF = parsevarargin(varargin,'parent','init'); % original axis
while ~strcmpi(class(hF),'matlab.ui.Figure'); hF = hF.Parent; end
k = find(strcmpi(varargin,'parent')); if ~any(k); clf(hF); end
P = parsevarargin(varargin,'Position',[.1 .1 .9 .9]);


% Define all subaxes positions in the figure %TODO CREATE VARARGIN FOR PM
% PX PY POSITIONS xDistPosition yDistPosition scatterPosition
PM = [.2 .2 .7 .7]       .* [P(3) P(4) P(3) P(4)] + [P(1) P(2) 0 0];
PX = [0.05 0.2 0.15 0.7] .* [P(3) P(4) P(3) P(4)] + [P(1) P(2) 0 0];
PY = [0.2 0.05 0.7 0.15] .* [P(3) P(4) P(3) P(4)] + [P(1) P(2) 0 0];
hA(1) = axes('parent',hF,'units','normalized','Position',PM); % main axis
hA(2) = axes('parent',hF,'units','normalized','Position',PX,'NextPlot','add'); % x dist
hA(3) = axes('parent',hF,'units','normalized','Position',PY,'NextPlot','add'); % y dist


% Find proper limits
ymargin = range(Yi(:))*0.1;
xmargin = range(Xi(:))*0.1;
XL = [min(Xi(:))-xmargin max(Xi(:))+xmargin];
YL = [min(Yi(:))-ymargin max(Yi(:))+ymargin];
YL = parsevarargin(varargin,'ylim',YL); % if limits specified in input
XL = parsevarargin(varargin,'xlim',XL);


MKS = {'o';'>';'d';'s'};
% MKS = repmat({'o';'>'},nG,1);


for k = 1:size(Xi,2)
    X = Xc{:,k};
    Y = Yc{:,k};
    c = cc(k,:);
    
    %---------- Main scatter
    line(X,Y,'linestyle','none','parent',hA(1),'marker',MKS{k},...
      'markerfacecolor',c,'color',c,'markeredgecolor','k','markersize',mk);
    
  
    %---------- Y density
    M = repmat(mean(Y),1,2); % mean
    h = line(XL,M,'color',c,'parent',hA(1),'LineWidth',1,'XLimInclude','off');
    uistack(h,'bottom')
    if hd==1 % histogram or distribution
        histogram(Y,nbins(2),'Parent',hA(2),'FaceColor',cc(k,:),'Orientation','horizontal');
    elseif hd==2
        [hA(2),D] = distline({Y},'parent',hA(2),'color',c,'alpha',a,'orientation','horizontal');
        Mh = interp1(D{1}(:,2),D{1}(:,1),M(1)); % mean height
        line([0 Mh],M,'color',c,'parent',hA(2),'LineWidth',2,'YLimInclude','off')
    end
    
    
    %---------- X density
    M = repmat(mean(X),1,2); % mean
    h = line(M,YL,'color',c,'parent',hA(1),'LineWidth',1,'XLimInclude','off');
    uistack(h,'bottom')
    if hd==1 % histogram or distribution
        histogram(X,nbins(1),'Parent',hA(3),'FaceColor',cc(k,:));
    elseif hd==2
        [hA(3),D] = distline({X},'parent',hA(3),'color',c,'alpha',a);
        Mh = interp1(D{1}(:,1),D{1}(:,2),M(1)); % mean height
        line(M,[0 Mh],'color',c,'parent',hA(3),'LineWidth',2,'YLimInclude','off')
    end
    
end

hA(1).Box = 'on';
hA(1).YAxisLocation = 'right';
hA(1).XAxisLocation = 'top';
hA(2).Color = 'none';
hA(2).XAxis.Visible = 'off';
hA(2).YAxis.Visible = 'off';
hA(3).Color = 'none';
hA(3).XAxis.Visible = 'off';
hA(3).YAxis.Visible = 'off';
hA(2).XDir = 'reverse';
hA(3).YDir = 'reverse';

% Apply proper limits
if diff(YL)~=0
    hA(1).YLim = YL;
    hA(2).YLim = YL;
end
if diff(XL)~=0
    hA(1).XLim = XL;
    hA(3).XLim = XL;
end

% Make zero lines
h = line([0 0],[-10000000 10000000],'color',[.7 .7 .7],'parent',hA(1),...
    'LineWidth',1,'XLimInclude','off','LineStyle','-');
uistack(h,'top')
h = line([-10000000 10000000],[0 0],'color',[.7 .7 .7],'parent',hA(1),...
    'LineWidth',1,'XLimInclude','off','LineStyle','-');
uistack(h,'top')

