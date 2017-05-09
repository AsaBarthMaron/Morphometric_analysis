function trees = reduce_tree(trees)
% Reduce tree removes all continuation (C) nodes from a tree.
% This allows each node to be treated as a representation of the entire
% neuronal segment/branch preceeding it (from the previous branch/root, to 
% the current branch/termination).

nTrees = length(trees);
for iTree = 1:nTrees
    dA = trees{iTree}.dA;
    isContinuation = sum(dA) == 1;
    isContinuation(1) = 0;
    yContinuation = [false isContinuation(1:end-1)];
    
    trees{iTree}.dA(:, isContinuation) = [];
    trees{iTree}.dA(yContinuation, :) = [];
    
    trees{iTree}.X(isContinuation) = [];
    trees{iTree}.Y(isContinuation) = [];
    trees{iTree}.Z(isContinuation) = [];
    trees{iTree}.D(isContinuation) = [];
    trees{iTree}.R(isContinuation) = [];
end
