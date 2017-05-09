
[Y, Z, copDist, meanInconsistency] = cluster_goi(zscore(gstats));
figure
% subplot(3,1,1)
T = cluster(Z,'cutoff',1.1);
[~,~, iNs] = dendrogram(Z,40);
nNs = length(iNs);
ax = gca; ax.XTickLabel = T(iNs);
% ax = gca; ax.XTickLabel = lnNums(iNs);
title('Clustered on input synapses to LNs (PSDs)')
T(iNs);
% sortedGrps = X(iNs,:,:);
% subplot(3,1,2)
% bar(sortedGrps(:,:,2), 'stacked')
% % ax = gca; ax.XTick = 1:nNs; ax.XTickLabel = LN_DM6.simpleNames(iNs);
% axis tight
% subplot(3,1,3)
% bar(sortedGrps(:,:,1), 'stacked')
% % ax = gca; ax.XTick = 1:nNs; ax.XTickLabel = LN_DM6.simpleNames(iNs);
% axis tight
%% PCA
[U,S,V] = svd(zscore(gstats)');
projPc = gstats * U;
figure
plot(projPc(:, 1), projPc(:, 2), '*')