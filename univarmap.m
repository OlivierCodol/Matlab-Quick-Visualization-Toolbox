
function h = univarmap(D,h,varargin)
% h = univarmap(D,h,varargin)
% D is the data matrix
% h is the target axis handle
% varargin are
%       'CLIM',[min max]        Defines Z-axis limit (range of colours)
%       'BarLabel',string       Labels the colorbar
% Mask
% MaskColor
% MaskWidth
% cmap
% O.Codol - 9th Nov 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=find(strcmpi(varargin,'clim'));
if any(k)
    CLIM = varargin{k(1)+1};
    varargin( [ k(1) k(1)+1 ] ) = [];
    imagesc(h,'XData',1:size(D,1),'YData',1:size(D,2),'CData',D,CLIM)
else
    imagesc(h,'XData',1:size(D,1),'YData',1:size(D,2),'CData',D)
end
h.YAxis.Direction = 'normal';
h.XLim = [1, size(D,1)];
h.YLim = [1, size(D,2)];



MaskC = parsevarargin(varargin,'MaskColor',[0 0 0]);
W = parsevarargin(varargin,'MaskWidth',1);


k=find(strcmpi(varargin,'Mask'));
if any(k)
  M = varargin{k(1)+1};
  B = mask(M');
  for j = 1:numel(B)
      hold on
      plot(B{j}(:,1),B{j}(:,2),'Color',MaskC,'LineWidth',W)
  end
end


if numel(unique(D))<=2
    colormap(gray(2));
else
    cmap = parsevarargin(varargin,'CMap','parula');
    colormap(h,eval([cmap '(100)']))
end

CB = parsevarargin(varargin,'colorbar','on');
if strcmpi(CB,'on')
    c = colorbar('peer',h);
    c.Label.String = parsevarargin(varargin,'BarLabel','');
end

end



function B = mask(D)

C = bwlabeln(D);  % Recode each cluster with a specific number
Cv = C(:);          % reshape into a column vector
nC = unique(Cv(D(:)==1)); % Count how many individual clusters

B = cell(numel(nC),1);

for k = 1:numel(nC)
    Cn = C==nC(k);
    [row,col]=find(diff(Cn)==1);
    if ~isempty(row)
        B{k} = bwtraceboundary(D,[row(1)+1, col(1)],'N');
    else
        B{k} = [];
    end
end

I = cellfun(@isempty,B); % Find empty cells
B = B(~I);  % Erase empty cells

end

function Value = parsevarargin(IN,theoption,thedefault)
k = find(strcmpi(IN,theoption));
if any(k); Value = IN{k(1)+1}; else; Value = thedefault; end
end

