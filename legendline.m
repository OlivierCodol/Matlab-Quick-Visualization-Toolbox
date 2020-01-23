function h=legendline(HF,LABELS,CC,varargin)

if ~iscell(LABELS); error('labels should be a 1*n cell array'); end
LABELS = LABELS(:);

L       = parsevarargin(varargin,'lwidth',1);
N       = size(LABELS,1);
FS      = parsevarargin(varargin,'fontsize',250/N);
P       = parsevarargin(varargin,'Position',[0 0.05 1 .95]);
OP      = parsevarargin(varargin,'OuterPosition',[]);
FLR     = parsevarargin(varargin,'fliplr',0);

h = axes('Parent',HF,'Position',P);
if ~isempty(OP); h.OuterPosition = OP; end
h.Color='none';
h.XAxis.Visible='off';
h.YAxis.Visible='off';

if FLR==1
    xt=.04;
    X=[.85 .99];
elseif FLR==0
    xt=.19;
    X=[.01 .15];
end



for k=1:N
   C = CC(k,:);
   Y = ([.5 .5]+k-1)/N;
   line(X,Y,'parent',h,'color',C,'linewidth',L);
   
   yt=(k-.45)/N;
   text(xt,yt,LABELS{k},'FontSize',FS)
end

xlim([0 1])


