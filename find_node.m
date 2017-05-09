% Find the nearest node to the x,y,z coordinates given.
function nodeIndex = find_node(trees, coordinates)

nSkeles = length(trees);
nodeIndex = zeros(nSkeles, 1);

for iSkele = 1:nSkeles
    nodeCoords = [trees{iSkele}.X, trees{iSkele}.Y, trees{iSkele}.Z];
    node_distance = bsxfun(@minus, nodeCoords, coordinates(iSkele,:));
    node_distance = sqrt(sum(node_distance .^ 2, 2));
    nodeIndex(iSkele) = find(node_distance == min(node_distance));
end

end
