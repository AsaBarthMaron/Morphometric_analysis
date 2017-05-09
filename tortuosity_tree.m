function tortuosity = tortuosity_tree(intree)
% Calculate tortuosity of a tree using the path length / euclidean distance
% metric (arc-chord ratio) as defined:
% 
%       T = L / C;
%           T: Tortuosity.
%           L: Path length.
%           C: Euclidean distance between endpoints.
% 
% Tortusoity can be calculated for either whole trees or individual
% branches. As of 02/14/17 only branches have been implemented.

% Calculate path length of branches (branchLength).
pathLength = Pvec_tree(intree);
sect = dissect_tree (intree);
branchLength = diff(pathLength(sect), [], 2);

% Calculate euclidean distance between endpoints of branches.
allCoords = [intree.X, intree.Y, intree.Z];
branchCoords = cat(3, allCoords(sect(:,1), :), allCoords(sect(:,2), :));
nodeDistances = diff(branchCoords, [], 3);
nodeDistances = sqrt(sum(nodeDistances .^ 2, 2));

% Calculate the arc-chord ratio
tortuosity = branchLength ./ nodeDistances;