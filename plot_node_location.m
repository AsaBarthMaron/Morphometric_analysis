% plot_node_location.m plots the xy location of a specified node, overlaid
% on top of the z projected tree (plotted using the
% plot_treee function). This script assumes that trees have already been
% loaded in, and that lnNums and nSkeles have been set. 
%
function plot_node_location(trees, nodeCoords, lnNums)
nSkeles = length(trees)
h = figure
for iSkele = 1:nSkeles
    clf
    plot_tree(iSkele)
    hold on
    plot(nodeCoords(iSkele, 1), nodeCoords(iSkele, 2), 'or', 'linewidth', 5, 'markerSize', 15)
    set(gca,'Ydir','reverse')
    title(['LN ' num2str(lnNums(iSkele))])
    pause
end