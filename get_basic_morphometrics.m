maxTreeSize = NaN(nSkeles, 1);
for iSkele = 1:nSkeles
    treeSize(iSkele) = length(trees{iSkele}.X);
end
maxTreeSize = max(treeSize);

pathLengths = NaN(maxTreeSize, nSkeles);
for iSkele = 1:nSkeles
    pathLengths(1:treeSize(iSkele), iSkele) = len_tree(iSkele);
end