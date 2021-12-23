function nanC = nanpad(C)

% Input must be a cell
if ~isclass('cell',C)
    error('Input must be a cell array')
end

% Get the size of all cells
Sz = (cellfun(@size,C,'UniformOutput',0));

if numel(unique(cell2mat(cellfun(@numel,Sz,'UniformOutput',0))))>1
    error('At least one cell has a different number of dimensions')
end

% Make the size array a matrix
Sz = cell2mat(Sz(:));

% Get the difference of each cell size from the largest array, and reshape
% it back to the input array format
padSz = reshape(mat2cell(max(Sz)-Sz,ones(size(Sz,1),1),size(Sz,2)),size(C));

% Pad each cell with nans
nanC = cellfun(@(C,padSz) padarray(C,padSz,NaN,'post'),C,padSz,'UniformOutput',0);

end
