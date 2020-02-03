clearvars
close all

% Fake data
ng=6;
nsample = 50;
X = mat2cell(.2*randn(nsample,ng)+3,nsample,ones(1,ng));


CL = [1,1,1,2,3,3]; % cluster values
cc = [0.2422    0.1504    0.6603]; % color is purple
a = linspace(.1,1,ng); % let's have fun with the alpha parameter here

% Initialise figure
figure(1); clf;
[nrow,ncol] = deal(4,5);
for k = 1:(nrow*ncol)
    ha(k)=subplot(nrow,ncol,k);
end

%% BARREPLOTS

% Create options - this is practical because one can input the same options
% as many times as wished. If one wants to input each name-value pair
% directly to the function that is fine too, naturally.
OPTIONS = {'color',cc,'cluster',CL,'alpha',a,'ycut',1};

% Create barplots. This illustrate different types of dot jittering
barreplot(X,'parent',ha(1),OPTIONS{:},'dots','align');
barreplot(X,'parent',ha(2),OPTIONS{:},'dots','deport');
barreplot(X,'parent',ha(3),OPTIONS{:},'dots','jitter'); title('barreplot');
barreplot(X,'parent',ha(4),OPTIONS{:},'dots','silo');
barreplot(X,'parent',ha(5),OPTIONS{:},'dots','none');



%% DOTPLOTS

OPTIONS{2} = parula(ng); % change colormap because this is prettier here

% All options from eg. barreplot are compatible across functions. This is
% very practical to swap between functions. 
dotplot(X,'parent',ha(6),OPTIONS{:},'dots','align');
dotplot(X,'parent',ha(7),OPTIONS{:},'dots','deport');
dotplot(X,'parent',ha(8),OPTIONS{:},'dots','jitter'); title('dotplot');
dotplot(X,'parent',ha(9),OPTIONS{:},'dots','silo');
dotplot(X,'parent',ha(10),OPTIONS{:},'dots','none');



%% BOITEPLOTS

OPTIONS{2} = [0.2422    0.1504    0.6603]; % color is back to purple

boiteplot(X,'parent',ha(11),OPTIONS{:},'dots','align');
boiteplot(X,'parent',ha(12),OPTIONS{:},'dots','deport');
boiteplot(X,'parent',ha(13),OPTIONS{:},'dots','jitter'); title('boiteplot');
boiteplot(X,'parent',ha(14),OPTIONS{:},'dots','silo');
boiteplot(X,'parent',ha(15),OPTIONS{:},'dots','none');


%% RAINPLOTS

% This option is better to illustrate the dot jitters in rainplots
% The default is ['marker','-'] though.
OPTIONS = [OPTIONS,'marker','o'];

rainplot(X,'parent',ha(16),OPTIONS{:},'dots','align');
rainplot(X,'parent',ha(17),OPTIONS{:},'dots','deport');
rainplot(X,'parent',ha(18),OPTIONS{:},'dots','jitter'); title('rainplot');
rainplot(X,'parent',ha(19),OPTIONS{:},'dots','silo');
rainplot(X,'parent',ha(20),OPTIONS{:},'dots','none');


%% GAUGEPLOT

% Initialise figure
hf = figure(2); clf

% Fake data
[ncat,ng] = deal(10,8);
X = mat2cell(rand(ncat,ng),ncat,ones(1,ng));

ha = axes('Position',[.07 .07 .3 .3]);
OPTIONS = {'color',cool(ncat),'cluster',[1,1,1,2,3,3,4,4],'alpha',1};

gaugeplot(X,'parent',ha,OPTIONS{:});%,'cluster',CL,'alpha',a,'dots','align','ycut',1,'marker','o');
title('gaugeplot')



%% SCATTERDIST

% Fake data
[ng,nsample] = deal(5,500);
X = randn(nsample,ng) + (1:ng)*2;
Y = randn(nsample,ng) - (1:ng)*0.5;

OPTIONS = {'color',jet(ng),'parent',hf,'nbins',10,'zeroline','--'};

scatterdist(X,Y,'hd','distribution','position',[.5   0 .5 .5],OPTIONS{:});
scatterdist(X,Y,'hd','histogram'   ,'position',[.5  .46 .5 .5],OPTIONS{:});
title('scatterdist')


%% DISTLINE

% Fake data
ng = 15;
X = mat2cell(randn(nsample,ng) + 7*randn(1,ng),nsample,ones(1,ng));


% Distributions with empty patches
ha = axes('Position',[.07 .5 .4 .15]);
distline(X,'parent',ha,'alpha',0,'color',summer(ng));

% Distributions with filled patches
ha = axes('Position',[.07 .75 .4 .15]);
distline(X,'parent',ha,'alpha',.7,'color',summer(ng));
title('distline')

%% LEGENDS

LABELS = {'one','two','three'};
legendline(hf,LABELS, summer(3),'position',[.36 .55 .18 .07],'fliplr',1);
legendbox (hf,LABELS, cool(3)  ,'position',[.38 .1 .18 .07]);


