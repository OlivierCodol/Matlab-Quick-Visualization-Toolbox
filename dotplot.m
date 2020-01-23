function h = dotplot(D,varargin)
% Only accepts 1*n or n*1 vector cell arrays as input D.
% Syntax is:
%       h = dotplot(D,varargin)
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
%   'color'         : n*3 matrix of rgb (default all black)
%   'bwidth'        : width of each bar (default 1)
%   'ewidth'        : width of error bars (default 3)
%   'markersize'    : size of mean/median dot (default 25)
%   'marker'        : marker type for mean/median dot (default '.')
% 	'zeroline'      : draw a black line at y=0 (1) or not (0) (default 1)
%   
% O.Codol 1st Mar. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups

h       = parsevarargin(varargin,'parent','init');
C       = parsevarargin(varargin,'cluster',1:nG);
bw      = parsevarargin(varargin,'bwidth',1);
ew      = parsevarargin(varargin,'ewidth',3);
mks     = parsevarargin(varargin,'markersize',25);
mk      = parsevarargin(varargin,'marker','.');
cc      = parsevarargin(varargin,'color',zeros(nG,3));
% if size(cc,1)==1; 
    cc = repmat(cc,[nG,1]);
% end


for k = 1:nG
    Ck = k+sum(diff(C(1:k)));
    X = (.6+Ck)*bw;
    
    % plot error bars
    line([X X],err(:,k),'color','k','parent',h,'linewidth',ew);
    hold on
    
    % plot mean/median
    Y = M(k);
    if ~strcmpi(mk,'-')
        plot(X,Y,mk,'markersize',mks,'color',cc(k,:));
    else
        X = ([.45 .75]+Ck)*bw;
        line(X,[Y Y],'color','k','parent',h,'linewidth',ew);
    end
    hold on
    
    % plot individual datapoints
    X = (.3*ones(1,sum(~isnan(D(:,k))))+Ck)*bw;
    Y = sort(D(~isnan(D(:,k)),k));
    plot(X,Y,'o','markersize',2,'markerfacecolor',[.5 .5 .5],...
        'markeredgecolor',[.5 .5 .5]);
    hold on
end

h = formatplot(h,D,varargin{:});

end