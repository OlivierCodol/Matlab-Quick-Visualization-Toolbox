function h = rainplot(D,varargin)
% Only accepts 1*n or n*1 vector cell arrays as input D.
% Syntax is:
%       h = barplot2(D,varargin)
% Returns an axis handle
%
%  ---options are:
%   'method'        : 'mean' (default) or 'median'
%   'err'           : 'ci' (default) 'sem' or 'std'
%   'nboot'         : any integer (default 10000)
%   'alphaci'       : from 0 to 1 (default .05)
%   'parent'        : parent axis handle (default make new figure)
%   'cluster'       : a 1*n or n*1 vector indicating which cluster each
%                     group belongs to (default 1:n, ie. each group is his
%                     its own cluster)
%   'alpha'         : patch transparency value (default .3). Set to 0 to
%                     remove any patch color.
%   'color'         : n*3 matrix of rgb (default all black)
%   'lwidth'        : width of bar lineframes (default 2)
%   'ewidth'        : width of error bars (default 3)
%   'markersize'    : size of individual datapoints (default 15)
%   
% O.Codol 17st Mar. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups

h       = parsevarargin(varargin,'parent','init');
C       = parsevarargin(varargin,'cluster',1:nG);
A       = parsevarargin(varargin,'alpha',.5);
lw      = parsevarargin(varargin,'lwidth',.5);
ew      = parsevarargin(varargin,'ewidth',lw*4);
mk      = parsevarargin(varargin,'markersize',3);
cc      = parsevarargin(varargin,'color',zeros(nG,3));
r       = parsevarargin(varargin,'dots','o');
if size(cc,1)==1; cc = repmat(cc,[nG,1]); end

if A==1
    mkcc = repmat([.6 .6 .6],nG,1);
    cc = zeros(size(cc));
else
    mkcc = cc;
end

for k = 1:nG
    Ck = k+sum(diff(C(1:k))); % defines group position based on cluster
    CC = cc(k,:);
    
    % plot distribution
    [Y,X] = ksdensity(D(:,k));
    Y = (Y/max(Y))/2 + 0.5 + Ck; % scale data, then shift it
    line([X X(1)],[Y Y(1)],'color',CC,'parent',h,'LineWidth',lw)
    hold on
    X = [X zeros(1,numel(X))];  %#ok<AGROW>
    Y = [Y fliplr(Y)];          %#ok<AGROW>
    patch(X,Y,1,'facecolor',mkcc(k,:),'facealpha',A,'parent',h,'EdgeColor','none')
    hold on
    
    % plot error bars
    Y = [.5 .5] + Ck;
    plot(err(:,k),Y,'color',CC,'parent',h,'linewidth',ew);
    hold on
    
    % plot mode
    Y = [.5 .5] + Ck;
    plot(M(k),Y,'o','markersize',mk*2,'markerfacecolor',CC,'markeredgecolor',CC);
    hold on
    
    % plot individual datapoints
    X = sort(D(~isnan(D(:,k)),k));
    if strcmpi(r,'o')
        % Y = (linspace(.1,.5,sum(~isnan(D(:,k))))+Ck);
        Y = repmat(.3,sum(~isnan(D(:,k))),1)+Ck;
        plot(X,Y,'o','markersize',mk,'markerfacecolor',CC,'markeredgecolor',CC);
    elseif strcmpi(r,'-')
        Y = repmat([.25 .35],sum(~isnan(D(:,k))),1)+Ck;
        X = repmat(X(:),1,2);
        line(X',Y','linewidth',mk,'color',CC);
    end
        
    hold on
    
end

% Axis format
h.YLim   = [1 (nG+1.2+sum(diff(C(1:nG))))];
h.YTickLabel = '';
h.YTick  = ((1:nG) + reshape(C,1,[])) - 0.5;

end


