function h = boiteplot(D,varargin)
% Only accepts 1*n or n*1 vector cell arrays as input D.
% Syntax is:
%       h = boiteplot(D,varargin)
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
%   'bwidth'        : width of each bar (default 1)
%   'lwidth'        : width of bar lineframes (default .5)
%   'lwidth'        : width of CI error bars (default 1)
%   'markersize'    : size of individual datapoints (default 3)
%   'mkcolor'       : n*3 matrix of rgb color of individual datapoints 
%                     (default white)
%   'modesize'      : size of mode point (default 5)
%   'zeroline'      : plot a line at y=0 or not. Default '-'. If a double
%                     is passed, plots a zero line with default style. Pass
%                     an empty array "[]" to toggle off, or any accepted 
%                     linestyle input to toggle on.
% O.Codol 26 Nov. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups
Q = flipud(quantile(D,[.05 .25 .5 .75 .95]));


h       = parsevarargin(varargin,'parent','init');
C       = parsevarargin(varargin,'cluster',ones(1,nG));
alpha   = parsevarargin(varargin,'alpha',.3);
bw      = parsevarargin(varargin,'bwidth',1);
lw      = parsevarargin(varargin,'lwidth',.5);
ew      = parsevarargin(varargin,'ewidth',1);
mk      = parsevarargin(varargin,'markersize',3);
mmk     = parsevarargin(varargin,'modesize',5);
cc      = parsevarargin(varargin,'color',zeros(nG,3));
mkcc    = parsevarargin(varargin,'mkcolor',ones(nG,3));
if size(cc,1)==1; cc = repmat(cc,[nG,1]); end


for k = 1:nG
    Ck = k+sum(diff(C(1:k)));
    
    % plot patches
    X = ([.05 .95 .95 .05]+Ck)*bw; % scales X dimension
    Y = [Q(2,k) Q(2,k) Q(4,k) Q(4,k)];
    patch(X,Y,cc(k,:),'facealpha',alpha,'edgecolor',cc(k,:),'linewidth',lw);
    hold on
    
    % plot median
    Y = [Q(3,k); Q(3,k)];
    plot(X([1;2]),Y,'color',cc(k,:),'parent',h,'linewidth',lw);
    
    % plot mean
    X = (.8+Ck)*bw; % scales X dimension
    plot(X,M(k),'o','markersize',mmk,'markerfacecolor',cc(k,:),...
        'markeredgecolor',cc(k,:));
    
    % plot CIs
    CIx = (.8*ones(2,1)+Ck)*bw;
    plot(CIx,err(:,k),'color',cc(k,:),'parent',h,'linewidth',ew);
    
    % plot error bars
    Ex = (.5*ones(2,1)+Ck)*bw;
    plot(Ex,Q(4:5,k),'color',cc(k,:),'parent',h,'linewidth',lw);
    plot(Ex,Q(1:2,k),'color',cc(k,:),'parent',h,'linewidth',lw);
    X = ([.1 -.1; .1 -.1] + Ex./bw)'*bw; % plot error bar ends
    Y = repmat(Q([1,5],k),1,2)';
    plot(X,Y,'color',cc(k,:),'parent',h,'linewidth',lw);
    
    
    % plot individual datapoints
    Y = sort(D(~isnan(D(:,k)),k));
    X = (.2+spread_duplicates(Y)+Ck)*bw;
    plot(X,Y,'o','markersize',mk,'markerfacecolor',mkcc(k,:),...
        'markeredgecolor',cc(k,:));
    hold on
end

h = formatplot(h,D,varargin{:});

end


function X = spread_duplicates(Y)

X = zeros(1,numel(Y));

dup = diff(Y)==0; % find any duplicate
if any(dup) % if any duplicate
    j=1;
    while j<=numel(dup) % go over the full dataset...
        c = 0;
        if dup(j)==1% if a duplicate is located
            c =1;
            while j+c<=numel(dup) && dup(j+c)==1
                c=c+1; % count how many duplicates in a row
            end
            X(j:(j+c)) = linspace(-.1,.1,c+1); % spread that count over x range
        end
        j = j+c+1; % then carry on
    end
end
    
end

