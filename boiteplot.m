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
%   'alphaci'       : confidence intervals value
%                           - can be from 0 to 1 (default .05)
%                           - or from 0 to 100 (%)%   'parent'        : parent axis handle (default make new figure)
%   'cluster'       : a 1*n or n*1 vector indicating which cluster each
%                     group belongs to (default 1:n, ie. each group is his
%                     its own cluster)
%   'dots'          : 'deport', 'align', 'silo' or 'jitter' (default 'align')
%   'zeroline'      : plot a line at y=0 or not. Default '-'. If a double
%                     is passed, plots a zero line with default style. Pass
%                     an empty array "[]" to toggle off, or any accepted 
%                     linestyle input to toggle on.
%
%-------------
%     these options can be 1*3 or n*3 rgb matrices to specify
%     individual colors to each bar.
%
%   'color'         : 1*3 or n*3 matrix of rgb (default all black)
%   'markercolor'   : n*3 matrix of rgb color of individual datapoints 
%                     (default white)
% 'markeredgecolor' : n*3 matrix of rgb color of individual datapoints
%                     edges (default same as 'color')
%
%-------------
%     these options can be scalars or n*1 or 1*1 vectors to specify
%     individual characteristics to each bar.
%
%   'alpha'         : patch transparency value (default .3). Set to 0 to
%                     remove any patch color.
%   'framewidth'    : width of bar frames (default .5)
%   'errorwidth'    : width of CI error bars (default 1)
%   'modesize'      : size of mode point (default 5)
%   'markersize'    : size of individual datapoints (default 3)

%
% O.Codol 26 Nov. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups
Q = flipud(quantile(D,[.05 .25 .5 .75 .95]));


h       = parsevarargin(varargin,'parent','init'); axes(h);
C       = parsevarargin(varargin,'cluster',ones(1,nG));
a       = parsevarargin(varargin,'alpha',.3);
fw      = parsevarargin(varargin,'framewidth',.5);
ew      = parsevarargin(varargin,'errorwidth',1);
mksz    = parsevarargin(varargin,'markersize',3);
mmk     = parsevarargin(varargin,'modesize',5);
cc      = parsevarargin(varargin,'color',zeros(nG,3));
dots    = parsevarargin(varargin,'dots','align');
mkfc    = parsevarargin(varargin,'markercolor',ones(nG,3));
mkec    = parsevarargin(varargin,'markeredgecolor',repmat(cc,[nG,1]));

if size(cc,2)~=3; error('color option should contain 3 values per row.');end
if size(mkfc,2)~=3; error('markercolor option should contain 3 values per row.');end
if size(mkec,2)~=3; error('markeredgecolor option should contain 3 values per row.');end

if size(cc,1)<nG; cc = repmat(cc,[nG,1]); end
if size(mkfc,1)<nG; mkfc = repmat(mkfc,[nG,1]); end
if size(mkec,1)<nG; mkec = repmat(mkec,[nG,1]); end

if numel(a) <nG;        a  = repmat(a(:),[nG,1]);   end
if numel(fw)<nG;        fw = repmat(fw(:),[nG,1]);  end
if numel(ew)<nG;        ew = repmat(ew(:),[nG,1]);  end
if numel(mksz)<nG;      mksz = repmat(mksz(:),[nG,1]);  end
if numel(mmk)<nG;       mmk = repmat(mmk(:),[nG,1]);  end

% if bar color & dot color is the same and alpha is 1, make dot edge black
ix = sum(mkec(1:nG,:)-cc(1:nG,:),2)==0 & reshape(a==1,[],1);
mkec(ix,:) = zeros(sum(ix),3);

if any(diff(C)<0); error('cluster indexes should be in ascending order'); end




for k = 1:nG
    Ck = k+sum(diff(C(1:k)));
    
    
    % plot patches
    X = ([.05 .95 .95 .05]+Ck); % scales X dimension
    Y = [Q(2,k) Q(2,k) Q(4,k) Q(4,k)];
    patch(X,Y,cc(k,:),'facealpha',a(k),'edgecolor',cc(k,:),'linewidth',fw(k));
    hold on
    
    
    % plot median
    Y = [Q(3,k); Q(3,k)];
    if a(k)~=1; ccmode = cc(k,:); else; ccmode = zeros(1,3); end
    plot(X([1;2]),Y,'color',ccmode,'parent',h,'linewidth',fw(k));
    
    
    % plot mean
    X = (.8+Ck); % scales X dimension
    plot(X,M(k),'o','markersize',mmk(k),'markerfacecolor',ccmode,...
        'markeredgecolor',cc(k,:));
    
    
    % plot CIs
    CIx = (.8*ones(2,1)+Ck);
    plot(CIx,err(:,k),'color',ccmode,'parent',h,'linewidth',ew(k));
    
    
    % plot error bars
    Ex = (.5*ones(2,1)+Ck);
    plot(Ex,Q(4:5,k),'color',cc(k,:),'parent',h,'linewidth',fw(k));
    plot(Ex,Q(1:2,k),'color',cc(k,:),'parent',h,'linewidth',fw(k));
    X = ([.1 -.1; .1 -.1] + Ex)'; % plot error bar ends
    Y = repmat(Q([1,5],k),1,2)';
    plot(X,Y,'color',cc(k,:),'parent',h,'linewidth',fw(k));
    
    
    % plot individual datapoints
    %---------------------------
    [X,Y] = xdot_alignment(D(:,k),Ck,dots,.2,.2);
    plot(X,Y,'o',   'markersize',       mksz(k)     ,...
                    'markerfacecolor',  mkfc(k,:)   ,...
                    'markeredgecolor',  mkec(k,:))  ;
    hold on
end

h = formatplot(h,D,varargin{:});

end



