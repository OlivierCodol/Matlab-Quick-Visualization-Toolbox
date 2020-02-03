function c = redgreyblue(m,varargin)
%REDBLUE    Shades of red and blue color map

if (nargin<1 || isempty(m))
    m = size(get(gcf,'colormap'),1);
end
if nargin==2
    CENTRE = varargin{1};
else
    CENTRE = .85;
end

if (mod(m,2) == 0) % if pair number of colours
    m1 = m*0.5;
    r = reshape(linspace(0,CENTRE,m1+1),[],1);
    g = r(1:end-1);
    r = [r(1:end-1); CENTRE*ones(m1,1)];
    g = [g; flipud(g)];
    b = flipud(r);
    
else % if odd number of colours
    m1 = floor(m*0.5);
    r = reshape(linspace(0,CENTRE,m1+1),[],1);
    g = r(1:end-1);
    r = [r(1:end-1); CENTRE*ones(m1+1,1)];
    g = [g; CENTRE; flipud(g)];
    b = flipud(r);
    
end

c = [r g b]; 
