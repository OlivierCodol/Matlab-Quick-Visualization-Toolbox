function h = gaugeplot(D,varargin)
% Accepts 1*n or n*1 cell arrays or x*n matrix as input D, where n is the
% number of groups and x is the number of categories.
% Any x-value represents the amount of a category.
% Syntax is:
%       h = gaugeplot(D,varargin)
% Returns an axis handle
%
%  ---options are:
%   'parent'        : parent axis handle (default make new figure)
%   'cluster'       : a 1*n or n*1 vector indicating which cluster each
%                     group belongs to (default 1:n, ie. each group is his
%                     its own cluster)
%   'alpha'         : patch transparency vector (default .5). Set to 0 to
%                     remove any patch color. A x*1 vector can be input to
%                     setup an alpha for each ategory independently.
%   'color'         : x*3 matrix of rgb (default all black)
%   'framewidth'    : 1*1 to n*1 vector specifying the width of bar frames
%                     (default .5)
%
% O.Codol 27th Jul. 2019
% codol.olivier@gmail.com
%---------------------------------------------------------




%----------------------------------------------------
% PARSE DATA INPUT
%----------------------------------------------------
if iscell(D); nG=numel(D); D=cell2mat(D); else; nG=size(D,2); end
D = reshape(D,[],nG);

if any(D(:)>1) || any(D(:)<0)
    error('data entries should all be in the [0 1] interval');
end

D = cumsum(D,1);
D = [zeros(1,size(D,2)); D]; % add a layer of 0s
nC = size(D,1);                   % get number of categories per group





%----------------------------------------------------
% PARSE OPTIONS
%----------------------------------------------------
h       = parsevarargin(varargin,'parent','init'); axes(h);
C       = parsevarargin(varargin,'cluster',ones(1,nG));
a       = parsevarargin(varargin,'alpha',.5);
fw      = parsevarargin(varargin,'framewidth',.5);
cc      = parsevarargin(varargin,'color',cool(nC-1));

if size(cc,1)==1; cc = repmat(cc,[nC-1,1]);     end
if numel(fw)<nG;  fw = repmat(fw(:),nG,1);         end
if numel(a) <nC;  a  = repmat(a(:),nC,1);          end





%----------------------------------------------------
% MAIN PLOTTING LOOP
%----------------------------------------------------
for k = 1:nG
    Ck = k+sum(diff(C(1:k)));
    
    X = ([0 1 1 0]+Ck); % scales X dimension
    for j = 2:nC
        Y = [D(j,k) D(j,k) D(j-1,k) D(j-1,k)];
        CLR = cc(j-1,:);
        fa = a(j-1);
        patch(X,Y,CLR,'facealpha',fa,'edgecolor','k','linewidth',fw(k));
        hold on
    end
end




end
