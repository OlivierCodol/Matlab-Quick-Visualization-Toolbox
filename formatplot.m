function h = formatplot(h,D,varargin)

% Handle options
nG       = size(D,2);
C        = parsevarargin(varargin,'cluster',1:nG);
bw       = parsevarargin(varargin,'bwidth',1);
yc       = parsevarargin(varargin,'ycut',0);
zl       = parsevarargin(varargin,'zeroline','-');

% X limit
XLIM     = nan(1,2);
XLIM(2)  = (nG+1.2+sum(diff(C(1:nG))))*bw;
XLIM(1)  = 0.8*bw;
h.XLim   = XLIM;

% Y limit
[~,YLIM] = lims([],D(:),[0.1,0.1]);
if ~yc && all(~(D(~isnan(D(:)))>0)); YLIM(2)=0; end
if ~yc && all(~(D(~isnan(D(:)))<0)); YLIM(1)=0; end
h.YLim   = YLIM;

% Zero line
if ~isempty(zl) && ~ischar(zl); zl='-'; end
if YLIM(1)<0 && YLIM(2)>0 && ~isempty(zl)
    hl = line(h.XLim,[0 0],'color',[.4 .4 .4],'parent',h,'linewidth',.5,'linestyle',zl);
    hold on
    uistack(hl,'bottom');
end

% Axis format
% h.Box    = 'on';
h.XTickLabel = '';
h.XTick  = ((1:nG) + reshape(C,1,[]))*bw - bw/2;

end