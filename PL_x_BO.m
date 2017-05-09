function x = PL_x_BO(intree)

pathLength = Pvec_tree(intree);
branchOrder = BO_tree(intree);
sect = dissect_tree (intree);

pathLength = pathLength(sect);
branchOrder = branchOrder(sect);
branchLength = diff(pathLength, [], 2);

[B, I] = sort(pathLength(:, 1));
x = cat(2, B, ones(length(B), 1)) \ branchOrder(I, 1);

end