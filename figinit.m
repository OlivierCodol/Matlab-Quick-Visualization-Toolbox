function hf = figinit(n,varargin)

hf = figure(n); clf;
if nargin==2
    pos = varargin{1};
    set(hf,'units','pixels','position',pos)
end

end
