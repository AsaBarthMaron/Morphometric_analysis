% function BLxPL = branch_length
% TODO:
intree = trees{3};
pathLength = Pvec_tree(intree);
branchOrder = BO_tree(intree);

sect = dissect_tree (intree);

pathLength = pathLength(sect);
branchOrder = branchOrder(sect);
branchLength = diff(pathLength, [], 2);
%% Branch length as fn of path length
[B, I] = sort(pathLength(:, 1));
scatter(B, branchLength(I));

%% Branch length as fn of branch order
[B, I] = sort(branchOrder(:, 1));
scatter(B, branchLength(I));

%% Branch order as fn of path length
[B, I] = sort(pathLength(:, 1));
scatter(B, branchOrder(I));

%% Branch order as fn of branch length
[B, I] = sort(branchLength);
scatter(B, branchOrder(I));
