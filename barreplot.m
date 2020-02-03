function h = barreplot(D,varargin)
% Only accepts 1*n or n*1 vector cell arrays as input D.
% Syntax is:
%       h = barreplot(D,varargin)
% Returns an axis handle
%
%
%  ---options are:
%   'method'        : 'mean' (default) or 'median'
%   'err'           : 'ci' (default) 'sem' or 'std'
%   'nboot'         : any integer for CIs bootstrap procedure (default 10000)
%   'alphaci'       : confidence intervals value
%                           - can be from 0 to 1 (default .05)
%                           - or from 0 to 100 (%)
%   'parent'        : parent axis handle (default make new figure)
%   'cluster'       : a 1*n or n*1 vector indicating which cluster each
%                     group belongs to (default 1:n, ie. each group is his
%                     its own cluster)
%   'dots'          : 'deport', 'align', 'silo' or 'jitter' (default 'jitter')
%   'ycut'          : re-center the y axis on the datapoints (1) or not
%                     (default 0)
%   'zeroline'      : specify a linestyle and draw a line at y=0 with that
%                     linestyle (default '-'). 
%                     If the plot does not include 0 (eg. using the 'ycut'
%                     option), then no line is drawn.
%                     Input an empty value [] to toggle off.
%
%-------------
%     these options can be scalars or n*1 or 1*1 vectors to specify
%     individual characteristics to each bar.
%
%   'alpha'         : patch transparency value (default .5). Set to 0 to
%                     remove any patch color.
%   'framewidth'    : width of bar lineframes (default .5)
%   'errorwidth'    : width of error bars (default 1.5)
%   'markersize'    : size of individual datapoints (default 2)
%
%-------------
%     these options can be 1*3 or n*3 rgb matrices to specify
%     individual colors to each bar.
%
%   'color'         : 1*3 or n*3 matrix of rgb (default all black)
%   'markercolor'   : n*3 matrix of rgb color of individual datapoints 
%                     (default white)
% 'markeredgecolor' : n*3 matrix of rgb color of individual datapoints
%                     edges (default white)
%
% O.Codol 1st Mar. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------





%----------------------------------------------------
% PARSE INPUTS
%----------------------------------------------------
D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups


h       = parsevarargin(varargin,'parent','init'); axes(h);
C       = parsevarargin(varargin,'cluster',1:nG);
a       = parsevarargin(varargin,'alpha',.5);
fw      = parsevarargin(varargin,'framewidth',.5);
ew      = parsevarargin(varargin,'errorwidth',1.5);
mk      = parsevarargin(varargin,'markersize',2);
dots    = parsevarargin(varargin,'dots','jitter');
cc      = parsevarargin(varargin,'color',zeros(nG,3));
mkfc    = parsevarargin(varargin,'markercolor',repmat(cc,[nG,1]));
mkec    = parsevarargin(varargin,'markeredgecolor',repmat(cc,[nG,1]));

if size(cc,2)~=3;   error(          'color option should contain 3 values per row.');end
if size(mkfc,2)~=3; error(    'markercolor option should contain 3 values per row.');end
if size(mkec,2)~=3; error('markeredgecolor option should contain 3 values per row.');end

if size(cc,1) == 1;     cc = repmat(cc,[nG,1]);     end
if size(mkfc,1)<nG;     mkfc = repmat(mkfc,[nG,1]); end
if size(mkec,1)<nG;     mkec = repmat(mkec,[nG,1]); end
if numel(a) <nG;        a  = repmat(a(:),[nG,1]);   end
if numel(fw)<nG;        fw = repmat(fw(:),[nG,1]);  end
if numel(ew)<nG;        ew = repmat(ew(:),[nG,1]);  end
if numel(mk)<nG;        mk = repmat(mk(:),[nG,1]);  end

% if bar color & dot color is the same and alpha is 1, make dot edge black
ix = sum(mkec(1:nG,:)-cc(1:nG,:),2)==0 & reshape(a==1,[],1);
mkec(ix,:) = zeros(sum(ix),3);

if any(diff(C)<0); error('cluster indexes should be in ascending order'); end





%----------------------------------------------------
% MAIN LOOP
% each iteration is a single bar
%----------------------------------------------------
for k = 1:nG
    Ck = k+sum(diff(C(1:k)));
    
    
    % plot patches
    %-------------
    X = ([0 1 1 0]+Ck); % scales X dimension
    Y = [M(k) M(k) 0 0];
    patch(X,Y,cc(k,:),'facealpha',a(k),'edgecolor',cc(k,:),'linewidth',fw(k));
    hold on
    
    
    
    % plot error bars
    %----------------
    Ex = (.8*ones(2,1)+Ck);
    if a(k)~=1; ccerror = cc(k,:); else; ccerror = zeros(1,3); end
    plot(Ex,err(:,k),'color',ccerror,'parent',h,'linewidth',ew(k));
    hold on
    % X = ([.1 -.1; .1 -.1] + Ex./bw)'*bw; % plot error bar ends
    % Y = repmat(err(:,k),1,2)';
    % plot(X,Y,'color',cc(k,:),'parent',h,'linewidth',ew);
    % hold on
    
    
    
    % plot individual datapoints
    %---------------------------
    [X,Y] = xdot_alignment(D(:,k),Ck,dots,.4,.5);
    plot(X,Y,'o',   'markersize',       mk(k)       ,...
                    'markerfacecolor',  mkfc(k,:)   ,...
                    'markeredgecolor',  mkec(k,:))  ;
    hold on
end




%----------------------------------------------------
% FORMAT PLOT
%----------------------------------------------------
h = formatplot(h,D,varargin{:});





end



