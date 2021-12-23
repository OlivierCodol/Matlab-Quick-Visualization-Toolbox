function h = dotplot(D,varargin)
% Only accepts 1*n or n*1 vector cell arrays as input D.
% Syntax is:
%       h = dotplot(D,varargin)
% Returns an axis handle
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
%   'marker'        : type of individual datapoint (default '.')
%
%-------------
%     these options can be scalars or n*1 or 1*1 vectors to specify
%     individual characteristics to each bar.
%
%   'errorwidth'    : width of error bars (default 3)
%   'markersize'    : size of individual datapoints (default 2)
%
%-------------
%     these options can be 1*3 or n*3 rgb matrices to specify
%     individual colors to each bar.
%
%   'color'         : 1*3 or n*3 matrix of rgb (default all black)
%   'markerfacecolor' : n*3 matrix of rgb color of individual datapoints 
%                       (default same as 'color')
%   'markeredgecolor' : n*3 matrix of rgb color of individual datapoints
%                       edges (default same as 'color')
%   
% O.Codol 1st Mar. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------

%----------------------------------------------------
% SORT OUT INPUTS
%----------------------------------------------------
D = checkinplot(D);                     % check data input format
[M,err] = descriptive(D,varargin{:});   % get descriptive statistics
nG = numel(M);                          % get number of groups


h      = parsevarargin(varargin,'parent',         'init'              ); axes(h);
C      = parsevarargin(varargin,'cluster',        1:nG                );
ew     = parsevarargin(varargin,'errorwidth',     3                   );
mksz   = parsevarargin(varargin,'markersize',     2                   );
mk     = parsevarargin(varargin,'marker',         '.'                 );
dots   = parsevarargin(varargin,'dots',           'jitter'            );
cc     = parsevarargin(varargin,'color',          zeros(nG,3)         );
mfc    = parsevarargin(varargin,'markerfacecolor',repmat(cc,[nG,1])   );
mec    = parsevarargin(varargin,'markeredgecolor',repmat(cc,[nG,1])   );
msz    = parsevarargin(varargin,'modesize',       20                  );

if size(cc,2)~=3;  error(          'color option should contain 3 values per row.');end
if size(mfc,2)~=3; error(    'markercolor option should contain 3 values per row.');end
if size(mec,2)~=3; error('markeredgecolor option should contain 3 values per row.');end

if size(cc,1) == 1;    cc = repmat(cc,[nG,1]);          end
if size(mfc,1)<nG;     mfc = repmat(mfc,[nG,1]);        end
if size(mec,1)<nG;     mec = repmat(mec,[nG,1]);        end
if numel(ew)<nG;       ew = repmat(ew(:),[nG,1]);       end
if numel(msz)<nG;      msz = repmat(msz(:),[nG,1]);     end
if numel(mk)<nG;       mk = repmat(mk(:),[nG,1]);       end
if numel(mksz)<nG;     mksz = repmat(mksz(:),[nG,1]);   end


if any(diff(C)<0); error('cluster indexes should be in ascending order'); end





%----------------------------------------------------
% MAIN LOOP
% each iteration is a single bar
%----------------------------------------------------
for k = 1:nG
    
    
    Ck = k+sum(diff(C(1:k)));
    X = (.6+Ck);
    
    
    
    % plot error bars
    line([X X],err(:,k),'color','k','parent',h,'linewidth',ew(k));
    hold on
    
    
    
    % plot mean/median
    Y = M(k);
    if ~strcmpi(mk(k),'-')
        plot(X,Y,mk(k),'markersize',msz(k),'color',cc(k,:));
    else
        X = ([.45 .75]+Ck);
        line(X,[Y Y],'color','k','parent',h,'linewidth',ew(k));
    end
    hold on
    
    
    % plot individual datapoints
    %---------------------------
    [X,Y] = xdot_alignment(D(:,k),Ck,dots,.3,.2);
    plot(X,Y,'o',   'markersize',       mksz(k)       ,...
                    'markerfacecolor',  mfc(k,:)   ,...
                    'markeredgecolor',  mec(k,:))  ;
    hold on
end


%----------------------------------------------------
% Format the plot
%----------------------------------------------------
h = formatplot(h,D,varargin{:});


end