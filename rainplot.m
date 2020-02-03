function h = rainplot(D,varargin)
% Only accepts 1*n or n*1 vector cell arrays as input D.
% Syntax is:
%       h = rainplot(D,varargin)
% Returns an axis handle
%
%  ---options are:
%   'method'        : 'mean' (default) or 'median'
%   'err'           : 'ci' (default) 'sem' or 'std'
%   'nboot'         : any integer (default 10000)
%   'alphaci'       : confidence intervals value
%                           - can be from 0 to 1 (default .05)
%                           - or from 0 to 100 (%)%   'parent'        : parent axis handle (default make new figure)
%   'cluster'       : a 1*n or n*1 vector indicating which cluster each
%                     group belongs to (default 1:n, ie. each group is his
%                     its own cluster)
%   'alpha'         : patch transparency value (default .5). Set to 0 to
%                     remove any patch color.
%   'dots'          : 'deport', 'align', 'silo' or 'jitter' (default 'align')
%   'ycut'          : re-center the y axis on the datapoints (1) or not (0,
%                     default)
%   'zeroline'      : specify a linestyle and draw a line at y=0 with that
%                     linestyle (default '-'). 
%                     If the plot does not include 0 (eg. using the 'ycut'
%                     option), then no line is drawn.
%                     Input an empty value [] to toggle off.
%
%-------------
%     these options can be 1*3 or n*3 rgb matrices to specify
%     individual colors to each bar.
%
%   'color'         : 1*3 or n*3 matrix of rgb (default all black)
%   'modecolor'     : 1*3 to n*3 matrix of rgb for mode color
%                     (default same as 'color')
%   'modeedgecolor' : 1*3 to n*3 matrix of rgb for mode edge color
%                     (default same as 'color')
%
%-------------
%     these options can be scalars or n*1 or 1*1 vectors to specify
%     individual characteristics to each bar.
%
%   'framewidth'    : width of cloud frames (default .5)
%   'errorwidth'    : width of CI error bars (default 1)
%   'modesize'      : size of mode point (default 5)
%   'markersize'    : size of individual "rain" datapoints (default 3 & .5 
%                     for 'o' and '-', respectively; see 'marker')
%
% O.Codol 17st Mar. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------


%----------------------------------------------------
% SORT OUT DATA
%----------------------------------------------------
D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups




%----------------------------------------------------
% SORT OUT OPTIONS
%----------------------------------------------------
h       = parsevarargin(varargin,'parent','init'); axes(h);
C       = parsevarargin(varargin,'cluster',1:nG);
a       = parsevarargin(varargin,'alpha',.5);
fw      = parsevarargin(varargin,'framewidth',.5);
ew      = parsevarargin(varargin,'errorwidth',fw*4);
mmk     = parsevarargin(varargin,'modesize',5);
cc      = parsevarargin(varargin,'color',zeros(nG,3));
mkfc    = parsevarargin(varargin,'modecolor',repmat(cc,[nG,1]));
mkec    = parsevarargin(varargin,'modeedgecolor',repmat(cc,[nG,1]));
mk      = parsevarargin(varargin,'marker','-');
dots    = parsevarargin(varargin,'dots','align');
yc      = parsevarargin(varargin,'ycut',0);
zl      = parsevarargin(varargin,'zeroline','-');
switch mk
    case 'o'; mksz = parsevarargin(varargin,'markersize',3);
    case '-'; mksz = parsevarargin(varargin,'markersize',.5);
end

if size(cc,2)~=3; error('color option should contain 3 values per row.');end

if size(cc,1)<nG; cc = repmat(cc,[nG,1]); end
if size(mkfc,1)<nG; mkfc = repmat(mkfc,[nG,1]); end
if size(mkec,1)<nG; mkec = repmat(mkec,[nG,1]); end

if numel(a) <nG;        a  = repmat(a(:),[nG,1]);   end
if numel(fw)<nG;        fw = repmat(fw(:),[nG,1]);  end
if numel(ew)<nG;        ew = repmat(ew(:),[nG,1]);  end
if numel(mksz)<nG;        mksz = repmat(mksz(:),[nG,1]);  end
if numel(mmk)<nG;       mmk = repmat(mmk(:),[nG,1]);  end

% if bar color & dot color is the same and alpha is 1, make dot edge black
ix = sum(mkec(1:nG,:)-cc(1:nG,:),2)==0 & reshape(a==1,[],1);
mkec(ix,:) = zeros(sum(ix),3);




%----------------------------------------------------
% MAIN LOOP
% each iteration is a single rainplot
%----------------------------------------------------

MINX = Inf;  % will be useful to draw figure limits later on
MAXX = -Inf;


for k = 1:nG
    Ck = k+sum(diff(C(1:k))); % defines group position based on cluster
    CC = cc(k,:);
    
    
    
    % plot distribution
    %---------------------------
    [Y,X] = ksdensity(D(:,k));
    Y = (Y/max(Y))/2 + 0.5 + Ck; % scale data, then shift it
    line([X X(1)],[Y Y(1)],'color',CC,'parent',h,'LineWidth',fw(k))
    hold on
    MINX = min(min(X(:)),MINX); % save info to draw figure limits later on
    MAXX = max(max(X(:)),MAXX);
    X = [X zeros(1,numel(X))];  %#ok<AGROW>
    Y = [Y fliplr(Y)];          %#ok<AGROW>
    patch(X,Y,1,'facecolor',CC,'facealpha',a(k),'parent',h,'EdgeColor','none')
    hold on
    
    
    
    
    % plot error bars
    %---------------------------
    Y = [.5 .5] + Ck;
    plot(err(:,k),Y,'color',mkec(k,:),'parent',h,'linewidth',ew(k));
    hold on
    
    
    
    % plot mode
    %---------------------------
    Y = [.5 .5] + Ck;
    plot(M(k),Y,'o',        'markersize',       mmk(k)      ,...
                            'markerfacecolor',  mkfc(k,:)   ,...
                            'markeredgecolor',  mkec(k,:))  ;
    hold on
    
    
    
    % plot individual datapoints
    %---------------------------
    switch mk
        case 'o'
            [Y,X] = xdot_alignment(D(:,k),Ck,dots,.3,.2);
            plot(X,Y,'o',   'markersize',       mksz(k)     ,...
                            'markerfacecolor',  CC          ,...
                            'markeredgecolor',  CC          );
        case '-'
            Y = repmat([.25 .35],sum(~isnan(D(:,k))),1)+Ck;
            X = repmat(X(:),1,2);
            line(X',Y','linewidth',mksz(k),'color',CC);
    end
    hold on
end




%----------------------------------------------------
% FORMAT PLOT
%----------------------------------------------------
h.YLim   = [1 (nG+1.2+sum(diff(C(1:nG))))];
h.YTickLabel = '';
h.YTick  = ((1:nG) + reshape(C,1,[])) - 0.5;

% X limit
XLIM = lims([MINX MAXX],[],[.1 .1]);
if ~yc && all(~(D(~isnan(D(:)))>0)); XLIM(2)=0; end
if ~yc && all(~(D(~isnan(D(:)))<0)); XLIM(1)=0; end
h.XLim   = XLIM;

% Zero line
if ~isempty(zl) && ~ischar(zl); zl='-'; end
if XLIM(1)<0 && XLIM(2)>0 && ~isempty(zl)
    hl = line([0 0],h.YLim,'color',[.4 .4 .4],'parent',h,'linewidth',.5,'linestyle',zl);
    hold on
    uistack(hl,'bottom');
end


end


