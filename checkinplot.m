function Y = checkinplot(D)

if ~isclass('cell',D); error('Only cell format data input accepted.'); end
if ~any(size(D)==1)
    error('D should be a 1*n cell array with one group per cell.');
else
    D = reshape(D,1,[]);
end

Dnan = nanpad(D);
Y = nan(numel(Dnan{1}),length(Dnan));
for k = 1:size(Y,2); Y(:,k) = reshape(Dnan{k},[],1); end