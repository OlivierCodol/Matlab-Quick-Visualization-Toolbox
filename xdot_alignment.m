%--------------------------------------------------------------------
% small function to sort out the x-axis jitter of individual dots
%--------------------------------------------------------------------
function [X,Y] = xdot_alignment(D,Ck,dots,CENTER,WIDTH)

Y = D(~isnan(D));
n = numel(Y);

switch dots
    case 'none'
        X=[];
        Y=[];
    case 'align'
        X = (CENTER+spread_duplicates(Y,WIDTH)+Ck);
    case 'silo'
        X = (linspace(CENTER-WIDTH/2,CENTER+WIDTH/2,n)+Ck);
    case 'deport'
        Y = sort(Y);
        X = (linspace(CENTER-WIDTH/2,CENTER+WIDTH/2,n)+Ck);
    case 'jitter'
        %[~,~,bandwidth] = ksdensity(Y); % optimal bandwith for data density
        [f,xi] = ksdensity(Y);%,'width',bandwidth); % jitter according to density
        fJit = interp1(xi,f,Y);
        jitX = fJit.*rand(n,1);
        X = (-WIDTH*jitX/max(jitX)+CENTER+WIDTH/2+Ck);
end
X = X(:);
Y = Y(:);
end






%--------------------------------------------------------------------
% If 'align' option, spread Y duplicates so they don't overlap
%--------------------------------------------------------------------
function X = spread_duplicates(Y,width)

X = zeros(1,numel(Y));
w = [-1 1] * width/2; 
dup = diff(Y)==0; % find any duplicate


if any(dup) % if any duplicate
    j=1;
    while j<=numel(dup) % go over the full dataset...
        c = 0;
        if dup(j)==1% if a duplicate is located
            c =1;
            while j+c<=numel(dup) && dup(j+c)==1
                c=c+1; % count how many duplicates in a row
            end
            
            X(j:(j+c)) = linspace(w(1),w(2),c+1); % spread that count over x range
        end
        j = j+c+1; % then carry on
    end
end


end