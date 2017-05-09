% function [coreShell] = core_shell
load('Z:\Data\EM_analyses\2017-03-21_core_shell\all_LN_synapses.mat');
load('Z:\Data\EM_analyses\2017-03-21_resampled_rerooted_intrees.mat');

%% Get convex hull of VA1v from VA1v LN synapses
K = convhulln(synXYZ); % Get hull
C = centroid(synXYZ); % Get hull centroid

% plot3(synXYZ(:,1), synXYZ(:,1), synXYZ(:,1), 'b*')
% plot3(synXYZ(K,1), synXYZ(K,1), synXYZ(K,1), 'r*')

%% Resample trees
doResamp = 0;
if doResamp;
    resampInterval = 20;
    for iSkele = 1:nSkeles
        resampTimer = tic;
        resampTrees{iSkele} = resample_tree(trees{iSkele}, resampInterval)
        disp(['Skele #' num2str(iSkele) ' (LN #' num2str(lnNums(iSkele)) ') - ' ...
              num2str(toc(resampTimer))])
    end
end
%% Inspect VA1v whether VA1v annotation of each tree's nodes looks right
inspectNodes = 1;
inspectHists = 1;
for iSkele = 1:nSkeles
    nodeXYZ = [resampTrees{iSkele}.X, resampTrees{iSkele}.Y, resampTrees{iSkele}.Z];
    tol = 1e-2*mean(abs(synXYZ(:)));
%     in = inhull(nodeXYZ, synXYZ(K, :), [], tol);
    in = inhull(nodeXYZ, synXYZ(K, :));
    
    if inspectNodes
        clf
        plot3(nodeXYZ(in, 1),nodeXYZ(in, 2),nodeXYZ(in, 3),'r*')
        hold on
        plot3(nodeXYZ(~in, 1),nodeXYZ(~in, 2),nodeXYZ(~in, 3),'b*')
        plot3(synXYZ(K, 1),synXYZ(K, 2),synXYZ(K, 3),'y*')
        pause
    end
    
    nodeXYZ(~in, :) = [];
    nodeDists{iSkele} = bsxfun(@minus, nodeXYZ, C);
    nodeDists{iSkele} = sqrt(sum(nodeDists{iSkele} .^ 2, 2));
    if ~isempty(nodeDists{iSkele})
        maxDist(iSkele) = max(nodeDists{iSkele});
    end
    medDist(iSkele) = median(nodeDists{iSkele});
    meanDist(iSkele) = mean(nodeDists{iSkele});
end
% bar(medDist)
maxDist = max(maxDist(iSkele));
histCenters = 1:50:maxDist;
for iSkele = 1:nSkeles
    distHists(:, iSkele) = hist(nodeDists{iSkele}, histCenters);
    if inspectHists
        subplot(6,6,iSkele)
        bar(histCenters, distHists(:, iSkele), 'barwidth', 1)
        xlim([0 maxDist])
    end
end
distHists(15,:) = bsxfun(@plus, distHists(15,:), eps);
coreShell = sum(distHists(1:15,:)) ./ (sum(distHists(16:end,:)));
% coreShell = sum(distHists(1:15,:)) ./ (sum(distHists(1:15,:)) + sum(distHists(16:end,:)));
%% Inspect VA1v whether VA1v annotation of each tree's nodes looks right
inspectNodes = 0;
if inspectNodes
    for iSkele = 1:nSkeles
        nodeXYZ = [trees{iSkele}.X, trees{iSkele}.Y, trees{iSkele}.Z];
        tol = 1e-2*mean(abs(nodeXYZ(:)))
        in = inhull(nodeXYZ, synXYZ(K, :), [], tol);
        clf
        plot3(nodeXYZ(in, 1),nodeXYZ(in, 2),nodeXYZ(in, 3),'r*')
        hold on
        plot3(nodeXYZ(~in, 1),nodeXYZ(~in, 2),nodeXYZ(~in, 3),'b*')
        plot3(x(K),y(K),z(K),'y*')
        pause
    end
end
%% Find indices of nodes within VA1v LN synapse convex hull

%%
%%
% close all
% nodeXYZ = [trees{1}.X, trees{1}.Y, trees{1}.Z];
% figure
% plot(nodeXYZ(:, 1),nodeXYZ(:, 2),'b*')
% 
% a = resample_tree(trees{1}, 20);
% figure
% resampledXYZ = [a.X, a.Y, a.Z];
% plot(resampledXYZ(:, 1),resampledXYZ(:, 2),'b*') 