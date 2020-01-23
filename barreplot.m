function h = barreplot(D,varargin)
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
%   'bwidth'        : width of each bar (default 1)
%   'lwidth'        : width of bar lineframes (default 2)
%   'ewidth'        : width of error bars (default 3)
%   'markersize'    : size of individual datapoints (default 2)
%   'dots'          : 'deport', 'align', or 'jitter' (default 'jitter')
% O.Codol 1st Mar. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups

h       = parsevarargin(varargin,'parent','init');
C       = parsevarargin(varargin,'cluster',ones(1,nG));
alpha   = parsevarargin(varargin,'alpha',.5);
bw      = parsevarargin(varargin,'bwidth',1);
lw      = parsevarargin(varargin,'lwidth',.5);
ew      = parsevarargin(varargin,'ewidth',1.5);
mk      = parsevarargin(varargin,'markersize',2);
dots    = parsevarargin(varargin,'dots','jitter');
cc      = parsevarargin(varargin,'color',zeros(nG,3));
if size(cc,1)==1; cc = repmat(cc,[nG,1]); end

if alpha==1; mkcc = repmat([.6 .6 .6],nG,1); cc = zeros(size(cc));
else;        mkcc = cc;
end

for k = 1:nG
    Ck = k+sum(diff(C(1:k)));
    
    % plot patches
    X = ([0 1 1 0]+Ck)*bw; % scales X dimension
    Y = [M(k) M(k) 0 0];
    patch(X,Y,cc(k,:),'facealpha',alpha,'edgecolor',cc(k,:),'linewidth',lw);
    hold on
    
    % plot error bars
    Ex = (.8*ones(2,1)+Ck)*bw;
    plot(Ex,err(:,k),'color',cc(k,:),'parent',h,'linewidth',ew);
    hold on
%     X = ([.1 -.1; .1 -.1] + Ex./bw)'*bw; % plot error bar ends
%     Y = repmat(err(:,k),1,2)';
%     plot(X,Y,'color',cc(k,:),'parent',h,'linewidth',ew);
%     hold on
    
    % plot individual datapoints
    Y = sort(D(~isnan(D(:,k)),k));
    if strcmpi(dots,'align')
        X = (.4*ones(1,sum(~isnan(D(:,k))))+Ck)*bw;
    elseif strcmpi(dots,'deport')
        X = (linspace(.1,.65,sum(~isnan(D(:,k))))+Ck)*bw;
    elseif strcmpi(dots,'jitter')
        % When estimating density use the optimal bandwith
        [~,~,bandwidth] = ksdensity(D(~isnan(D(:,k)),k));
        % jitter is a function of the density at that point
        [f,xi] = ksdensity(D(~isnan(D(:,k)),k),'width',bandwidth);
        fJit = interp1(xi,f,D(~isnan(D(:,k)),k));
        jitX = fJit.*(-rand(sum(~isnan(D(:,k))),1)+1);
        X = (.45*jitX/max(jitX)+.1+Ck)*bw;
    end
    plot(X,Y,'o','markersize',mk,'markerfacecolor',mkcc(k,:),...
        'markeredgecolor',cc(k,:));
    hold on
end

h = formatplot(h,D,varargin{:});

end



