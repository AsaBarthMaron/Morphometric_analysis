load('Z:\Data\light_level_morphology\chou_et_al_reanalysis\ipsilateral_innervation_table.mat');
inrvMat = inrvMat';
%% PCA
[U,S,V] = svd(inrvMat);
figure

subplot(2,2,1)
plot((diag(S)/sum(S(:))) * 100, '*')
title('scree plot')
ylabel('% variance explained')
projPc = inrvMat' * U;

% As expected, the first PC is entirely explained solely by # glom innervated.
subplot(2,2,2)
plot(sum(inrvMat,1), projPc(:,1), '*')
title(['PC1 vs # glom. innervated, corr: ' ...
    num2str(corr(sum(inrvMat,1)', projPc(:,1)))]);
ylabel('Loading onto PC1'); xlabel('# glom innervated');

%% Investigate principle components
% Which PC to investigate?
pcNum = 5;

% Find samples that have loadings more than 2 std above or below the mean
zProjPc = zscore(projPc(:, pcNum));
above2std = find(zProjPc >= 2);
below2std = find(zProjPc <= -2);

normPC = U(:,pcNum) - min(U(:,pcNum));
normPC = normPC / max(normPC);

figure; plot(sort(zProjPc), '*'); 
hold on; 
plot(ones(1542,1) * 2); 
plot(ones(1542,1) * -2)

figure
% Plot innervation map for these entries
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.02], [0.04 0.01], [0.01 0.01]);
h = subplot(1,1,1)
imagesc([inrvMat(:,above2std)'; inrvMat(:,below2std)'])
hold on
numEl = length(above2std) + length(below2std);
plot((normPC * 0.2 * numEl) + (0.4 * numEl), 'linewidth', 4, ...
     'color', [0.85 0.325 0.098])
set(gca, 'xtick', 1:54); 
set(gca, 'xticklabel', glomNames)

%% Clustering
[Y, Z, copDist, meanInconsistency] = cluster_goi(inrvMat);
figure
% subplot(3,1,1)
T = cluster(Z,'cutoff',1);
[~,~, inds] = dendrogram(Z, size(inrvMat,1));
nNs = length(iNs);
ax = gca; ax.XTickLabel = T(iNs);
% ax = gca; ax.XTickLabel = lnNums(iNs);
title('Clustered on input synapses to LNs (PSDs)')
T(iNs);

%% Investigate clusters
%% Logistic regression
