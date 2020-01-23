function [M,err] = descriptive(D,varargin)

% find methods requested
method = parsevarargin(varargin,'method','mean');
errtype = parsevarargin(varargin,'err','ci');

if strcmpi(errtype,'ci')
    % CI parameters
    nboot = parsevarargin(varargin,'nboot',10000);
    alpha = parsevarargin(varargin,'alphaci',.05);
    
    % check out CI alpha values
    if alpha>1 && alpha<100; alpha = alpha/100;
    elseif alpha>100 || alpha<0; error('CI alpha must be in percents');
    elseif alpha>.5; alpha = 1-alpha;
    end
end

N = sum(~isnan(D)); % number of datapoints for each group

% get mean/median
if      strcmpi(method,'mean'); M = nanmean(D);
elseif  strcmpi(method,'median'); M = nanmedian(D);
else;   error('method must be ''mean'' or ''median''.');
end



% get error values according to requested method
if strcmpi(errtype,'sem') || strcmpi(errtype,'std')
    err = reshape(nanstd(D),1,[]);
    if strcmpi(errtype,'sem'); err = err./N; end
    err = [M+err;M-err];
    
elseif strcmpi(errtype,'ci')
    if strcmpi(method,'mean')
        err = flip(bootci(nboot,{@nanmean,D},'alpha',alpha));
    elseif strcmpi(method,'median')
        err = flip(bootci(nboot,{@nanmedian,D},'alpha',alpha));
    end
    
else
    error('error type must be ''ci'', ''std'', or ''sem''.');
end


