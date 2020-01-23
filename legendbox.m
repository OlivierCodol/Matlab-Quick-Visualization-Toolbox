function h=legendbox(HF,LABELS,CC,varargin)

if ~iscell(LABELS); error('labels should be a 1*n cell array'); end
LABELS = LABELS(:);

A       = parsevarargin(varargin,'alpha',.5);
L       = parsevarargin(varargin,'lwidth',1);
N       = size(LABELS,1);
FS      = parsevarargin(varargin,'fontsize',250/N);
P       = parsevarargin(varargin,'Position',[0 0.05 1 .95]);
OP      = parsevarargin(varargin,'OuterPosition',[]);
FLR     = parsevarargin(varargin,'fliplr',0);

h=axes('Parent',HF,'Position',P);
if ~isempty(OP); h.OuterPosition = OP; end
h.Color='none';
h.XAxis.Visible='off';
h.YAxis.Visible='off';

if FLR==1
    xt=.81;
    X=[.85 .99 .99 .85];
    POS = 'right';
elseif FLR==0
    xt=.19;
    X=[.01 .15 .15 .01];
    POS = 'left';
end

M = .1/N;
B = .8/N;


for k=1:N
   C = CC(k,:);
   Y = [M+B M+B M M]+(k-1)/N;
   patch(X,Y,C,'parent',h,'facealpha',A,'edgecolor',C,'linewidth',L);
   
   yt=(k-.45)/N;
   text(xt,yt,LABELS{k},'FontSize',FS,'HorizontalAlignment',POS)
end

xlim([0 1])


