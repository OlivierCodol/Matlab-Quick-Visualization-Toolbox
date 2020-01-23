function [h,varargout] = distline(D,varargin)
% Only accepts 1*n or n*1 vector cell arrays as input D.
% Syntax is:
%       [h,varargout] = distline(D,varargin)
% Returns an axis handle
%   Varargout  returns a n*1 cell array with [X,Y] positions of the
%   distribution of each n.
%
%  ---options are:
%   'parent'        : parent axis handle (default make new figure)
%   'color'         : n*3 matrix of rgb (default parula)
%   'linewidth'     : width of distribution lines
%   
% O.Codol 17th Mar. 2019
% codol.olivier@gmail.com
%--------------------------------------------------------------------------
%%

% Check input
%--------------------------------------------------------------------------
D       = checkinplot(D);                    % check data input format
nG      = size(D,2);                         % get number of groups






% Parse options
%--------------------------------------------------------------------------
if nG ==1
    default_cc = parula(nG+1); % avoid yellow
else
    default_cc = parula(nG);
end

h       = parsevarargin(varargin,'parent','init');
cc      = parsevarargin(varargin,'color',default_cc);
lw      = parsevarargin(varargin,'linewidth',1);
alpha   = parsevarargin(varargin,'alpha',0);
hv      = parsevarargin(varargin,'orientation','vertical');
norm_f  = parsevarargin(varargin,'normalise',false); % normalise flag
if size(cc,1)==1; cc = repmat(cc,[nG,1]); end



% Vertical or horizontal plotting
if isa(hv,'char') && strcmpi(hv,'vertical')
    hv = false;
elseif isa(hv,'char') && strcmpi(hv,'horizontal')
    hv = true;
else
    error('orientation should be vertical (default) or horizontal')
end







% Main code (plots each distribution)
%--------------------------------------------------------------------------

AllData = cell(nG,1);  % Allocate memory

for k = 1:nG
    % Get density
    [Y,X] = ksdensity(D(:,k));
    
    % Apply some options if required
    if norm_f; Y = Y/sum(Y); end                % normalise distribution
    if hv; [X,Y] = deal(Y,X); end               % flip axis to vertical
    
    % Plot distribution
    line(X,Y,'color',cc(k,:),'parent',h,'LineWidth',lw)
    
    % Fill distribution if option is required
    if alpha~=0
        Xp = [X fliplr((X))];%zeros(1,numel(X))];
        Yp = [(Y) zeros(1,numel(Y))];%fliplr((Y))];
        patch(Xp,Yp,1,'facecolor',cc(k,:),...
            'facealpha',alpha,'parent',h,'EdgeColor','none');
    end
    
    % Pack output
    AllData{k} = reshape([X,Y],[],2);
end







% Pack output
%--------------------------------------------------------------------------

varargout = {AllData};





end



