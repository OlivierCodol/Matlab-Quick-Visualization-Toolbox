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
%                     axis handle is provided, its parent figure is used.
%   'alpha'         : patch transparency value (default .5) for the
%                     distribution. Set to 0 to remove any patch color.
%   'color'         : (1-to-n)*3 matrix of rgb (default all black)
%   'markersize'    : size of individual datapoints (default 5). Can be a
%                     1*n or n*1 vector to specify each group individually.
%   'marker'        : Marker type for the scatterplot. Can be a scalaer up 
%                     to a 1*n or n*1 to specify each group individually.
%                     Default is 'o>ds' for the first 4 groups, and then 
%                     repeats itself.
%   'position'      : 4-element vector indicating the area in the figure in
%                     which to plot. Default is [.1 .1 .9 .9].
%   'hd'            : 'histogram' or 'distribution', to specify if the
%                     distributions either side should be in the form of a
%                     histogram or a distribution. Alternatively, 1 and 2
%                     can be employed for histogram and distribution,
%                     respectively. Default is distribution.
%   'nbins'         : (1 to n)-by-(1 to 2) matrix. Specifies the number of
%                     bins for the histograms (default 5). The first column
%                     is the number of bins for the x axis histogram and
%                     the second for the y-axis histogram. Each row
%                     indicates the values for a group.
%                     If 'hd' is set as 'distribution' or 2, this input is
%                     ignored.
%   'zeroline'      : specify a linestyle and draw a line at y=0 and x=0
%                     with that linestyle (default '-'). 
%                     If the plot does not include 0 then no line is drawn.
%                     Input an empty value [] to toggle off.
% 
%---------------------------------------------------------
% Peter J. Holland (U. of Birmingham, UK) & Olivier Codol
% 11th Sept. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

% Convert input X and Y class to cell if needed
if isa(Xi,'double')
    Xc = mat2cell(Xi,size(Xi,1),ones(1,size(Xi,2)));
else
    Xc = Xi;
    Xi = reshape(cat(1,Xc{:}),[],1);
end
if isa(Yi,'double')
    Yc = mat2cell(Yi,size(Yi,1),ones(1,size(Yi,2)));
else
    Yc = Xi;
    Yi = reshape(cat(1,Yi{:}),[],1);
end


% Parse options
nG      = numel(Xc);
a       = parsevarargin(varargin,'alpha',.5);
mksz    = parsevarargin(varargin,'markersize',5);
nbins   = parsevarargin(varargin,'nbins',5);
cc      = parsevarargin(varargin,'color','k');
mk      = parsevarargin(varargin,'marker','o>ds');
zl      = parsevarargin(varargin,'zeroline','-');


% Scale options if needed so that each group has his value
if size(cc,1)==1; cc = repmat(cc,[nG,1]); end
if size(nbins,2)==1; nbins(:,2)=nbins; end; nbins = ceil(nbins);
if size(nbins,1)<nG; nbins = repmat(nbins,nG,1); end
if numel(mksz)<nG; mksz = repmat(mksz(:),nG,1); end
if numel(a)<nG; a = repmat(a(:),nG,1); end
if numel(mk)<nG; mk = repmat(mk(:),nG,1); end


% histogram or distribution
hd = parsevarargin(varargin,'hd','distribution'); 
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


% Define all subaxes positions in the figure
P = parsevarargin(varargin,'Position',[.1 .1 .9 .9]);
PM = [.2 .2 .7 .7]       .* [P(3) P(4) P(3) P(4)] + [P(1) P(2) 0 0];
PX = [0.05 0.2 0.15 0.7] .* [P(3) P(4) P(3) P(4)] + [P(1) P(2) 0 0];
PY = [0.2 0.05 0.7 0.15] .* [P(3) P(4) P(3) P(4)] + [P(1) P(2) 0 0];
hA(1) = axes('parent',hF,'units','normalized','Position',PM); % main axis
hA(2) = axes('parent',hF,'units','normalized','Position',PX,'NextPlot','add'); % x dist
hA(3) = axes('parent',hF,'units','normalized','Position',PY,'NextPlot','add'); % y dist


% Find proper limits
ymargin = range(Yi(:))*0.1;
xmargin = range(Xi(:))*0.1;
XLIM = [min(Xi(:))-xmargin max(Xi(:))+xmargin];
YLIM = [min(Yi(:))-ymargin max(Yi(:))+ymargin];
YLIM = parsevarargin(varargin,'ylim',YLIM); % if limits specified in input
XLIM = parsevarargin(varargin,'xlim',XLIM);





for k = 1:nG
    X = Xc{:,k};
    Y = Yc{:,k};
    c = cc(k,:);
    
    %---------- Main scatter
    line(X,Y,'linestyle','none','parent',hA(1),'marker',mk(k),...
      'markerfacecolor',c,'color',c,'markeredgecolor','k','markersize',mksz(k));
    
  
    %---------- Y density
    M = repmat(mean(Y),1,2); % mean
    h = line(XLIM,M,'color',c,'parent',hA(1),'LineWidth',1,'XLimInclude','off');
    uistack(h,'bottom')
    if hd==1 % histogram or distribution
        histogram(Y,nbins(k,2),'Parent',hA(2),'FaceColor',cc(k,:),'Orientation','horizontal');
    elseif hd==2
        [hA(2),D] = distline({Y},'parent',hA(2),'color',c,'alpha',a(k),'orientation','horizontal');
        Mh = interp1(D{1}(:,2),D{1}(:,1),M(1)); % mean height
        line([0 Mh],M,'color',c,'parent',hA(2),'LineWidth',2,'YLimInclude','off')
    end
    
    
    %---------- X density
    M = repmat(mean(X),1,2); % mean
    h = line(M,YLIM,'color',c,'parent',hA(1),'LineWidth',1,'XLimInclude','off');
    uistack(h,'bottom')
    if hd==1 % histogram or distribution
        histogram(X,nbins(k,1),'Parent',hA(3),'FaceColor',cc(k,:));
    elseif hd==2
        [hA(3),D] = distline({X},'parent',hA(3),'color',c,'alpha',a(k));
        Mh = interp1(D{1}(:,1),D{1}(:,2),M(1)); % mean height
        line(M,[0 Mh],'color',c,'parent',hA(3),'LineWidth',2,'YLimInclude','off')
    end
    
end


% Some design housekeeping...
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
if diff(YLIM)~=0
    hA(1).YLim = YLIM;
    hA(2).YLim = YLIM;
end
if diff(XLIM)~=0
    hA(1).XLim = XLIM;
    hA(3).XLim = XLIM;
end


% Make zero lines
% Zero line
almostblack = [.3 .3 .3];
if ~isempty(zl) && ~ischar(zl); zl='-'; end
if XLIM(1)<0 && XLIM(2)>0 && ~isempty(zl)
    h = line([0 0],YLIM,        'color',        almostblack ,...
                                'parent',       hA(1)       ,...
                                'LineWidth',    1           ,...
                                'XLimInclude',  'off'       ,...
                                'LineStyle',    zl          );
    uistack(h,'top')
end
if YLIM(1)<0 && YLIM(2)>0 && ~isempty(zl)
    h = line(XLIM,[0 0],        'color',        almostblack ,...
                                'parent',       hA(1)       ,...
                                'LineWidth',    1           ,...
                                'XLimInclude',  'off'       ,...
                                'LineStyle',    zl          );
    uistack(h,'top')
end

% Back to the main axis as current
axes(hA(1));

