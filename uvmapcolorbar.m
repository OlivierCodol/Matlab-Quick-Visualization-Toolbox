function h=uvmapcolorbar(hf,ha,varargin)

OP = parsevarargin(varargin,'OuterPosition',[]);
P = parsevarargin(varargin,'Position',[]);
obj = findobj(allchild(ha),'type','image');
D = obj.CData(:);
CLIM = parsevarargin(varargin,'clim',[min(D) max(D)]);

CC=flip(ha.Colormap);
Y=linspace(CLIM(1),CLIM(2),size(CC,1)+1);
X=repmat([0 1 1 0],numel(Y),1);
Y=fliplr(reshape(sort(repmat(Y(:),2,1)),2,[]));
Y = [Y(:,1:end-1);Y(:,2:end)]';

if ~isempty(OP);    h=axes('parent',hf,'OuterPosition',OP);
elseif ~isempty(P); h=axes('parent',hf,'Position',P);
else;               h=axes('parent',hf);
end
h.Box='on';
h.XTick=[];
h.YAxisLocation='right';
for k=1:size(Y,1); patch(X(k,:),Y(k,:),CC(k,:),'parent',h,'edgecolor','none'); end
lims([0 1],CLIM,'parent',h,'margin',[0 0]);

