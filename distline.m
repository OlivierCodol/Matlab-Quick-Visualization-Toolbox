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
%   'color'         : 1*3 to n*3 matrix of rgb (default parula)
%   'linewidth'     : scalar to n*1 voctor specifying width of distribution
%                     lines.
%   'alpha'         : alpha of distribution colors (default 0, ie.
%                     transparent).
%                     Can be up to n*1 vector for different alpha for each
%                     distribution.
%   'orientation'   : 'horizontal' or 'vertical' (default) distribution plots
%   'normalise'     : normalise distributions (1) or not (0, default)
% 'bandwidthfactor' : how much smoothing occurs in the distribution, with
%                     values between 0 and 1 indicating less smoothing and
%                     above 1 indicating more smooothing (default 1).
%                     Can be a scalar or n-element vector.
%                     Also see built-in function ksdensity.


%   
% O.Codol 17th Mar. 2019
% codol.olivier@gmail.com
%--------------------------------------------------------------------------


%----------------------------------------------------
% PARSE INPUTS
%----------------------------------------------------
D       = checkinplot(D);                    % check data input format
nG      = size(D,2);                         % get number of groups






%----------------------------------------------------
% PARSE OPTIONS
%----------------------------------------------------
if nG==1
    default_cc = parula(nG+1); % avoid yellow
else
    default_cc = parula(nG);
end

h       = parsevarargin(varargin,'parent','init'); axes(h);
cc      = parsevarargin(varargin,'color',default_cc);
lw      = parsevarargin(varargin,'linewidth',1);
a       = parsevarargin(varargin,'alpha',0);
hv      = parsevarargin(varargin,'orientation','vertical');
norm_f  = parsevarargin(varargin,'normalise',false); % normalise flag
bwf     = parsevarargin(varargin,'bandwidthfactor',1); % normalise flag

if size(cc,1)==1;       cc = repmat(cc,[nG,1]);     end
if numel(a) <nG;        a  = repmat(a(:),[nG,1]);   end
if numel(lw)<nG;        lw = repmat(lw(:),[nG,1]);  end
if numel(bwf)<nG;       bwf = repmat(bwf(:),[nG,1]);end


% Vertical or horizontal plotting
if isa(hv,'char') && strcmpi(hv,'vertical')
    hv = false;
elseif isa(hv,'char') && strcmpi(hv,'horizontal')
    hv = true;
else
    error('orientation should be vertical (default) or horizontal')
end








%----------------------------------------------------
% MAIN CODE (plot each distribution)
%----------------------------------------------------

AllData = cell(nG,1);  % Allocate memory

for k = 1:nG
    % Get density
    [~,~,bandwidth] = ksdensity(D(:,k)); % optimal bandwith for data density
    [Y,X] = ksdensity(D(:,k),'width',bwf(k)*bandwidth);
    
    % Apply some options if required
    if norm_f; Y = Y/sum(Y); end                % normalise distribution
    if hv; [X,Y] = deal(Y,X); end               % flip axis to vertical
    
    % Plot distribution
    line(X,Y,'color',cc(k,:),'parent',h,'LineWidth',lw(k))
    
    % Fill distribution if option is required
    if a~=0
        Xp = [X fliplr((X))];
        Yp = [(Y) zeros(1,numel(Y))];
        patch(Xp,Yp,1,'facecolor',cc(k,:),'facealpha',a(k),'parent',h,'EdgeColor','none');
    end
    
    % Pack output
    AllData{k} = reshape([X,Y],[],2);
end








%----------------------------------------------------
% PACK OUTPUT DISTRIBUTIONS
%----------------------------------------------------

varargout = {AllData};





end



