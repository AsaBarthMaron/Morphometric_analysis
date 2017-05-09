function [medPriDiam] = primary_neurite_diameter
load('Z:\Data\EM_analyses\2017-03-16_morphology_analysis\primaryBranchNodeXYZ.mat')
load('Z:\Data\EM_analyses\2017-02-13_rerooted_intrees.mat')
checkNodes = 0;
plotDiameterHist = 0;
% Find node indices from coordinates
priNodeInd = find_node(trees, primaryBranchNodeXYZ);

% Check these nodes to make sure they are correct
for iSkele = 1:nSkeles
    nodeCoords(iSkele, :) = [trees{iSkele}.X(priNodeInd(iSkele))...
                             trees{iSkele}.Y(priNodeInd(iSkele))];
end
if checkNodes
    plot_node_location(trees, nodeCoords, lnNums)
end

% Get path from primary branch point back to root node
for iSkele = 1:nSkeles
    tempPath = ipar_tree(trees{iSkele});
    pathToRoot = tempPath(priNodeInd(iSkele), :);
    pathToRoot(pathToRoot == 0) = [];
    priDiameter{iSkele} = trees{iSkele}.D(pathToRoot);
end

%% check primary neurite diameter histogram
if plotDiameterHist
    figure
    for iSkele = 1:nSkeles
        histogram(priDiameter{iSkele}, 20)
        xlim([0 300]) 
        hold on
        plot(mean(priDiameter{iSkele}) * ones(2,1), yLims)
        plot(median(priDiameter{iSkele}) * ones(2,1), yLims)
        pause
        hold off
    end
end

%% Calculate mean/median/modal diameter
for iSkele = 1:nSkeles
    medPriDiam(iSkele) = median(priDiameter{iSkele});
    meanPriDiam(iSkele) = mean(priDiameter{iSkele});
end