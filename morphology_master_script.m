% Master script to do morphology analysis
%% Load in LNs .SWC files to be used
clear
load('Z:\Data\EM_analyses\2017-02-13_rerooted_intrees_+stats.mat')
% % skeletonDir = '/home/asa/2017-02-03_inflated_skeletons/';
% skeletonDir = 'C:\Users\asa\Documents\2017-02-03_inflated_skeletons\';
% 
lnNums = [1, 2, 3, 6, 7, 8, 9, 10, 16, 18, 21, 23, 24, 25, 26, 27, 28, 29,...
    30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42];
% lnNums = [1, 2, 3, 6, 7, 8, 9, 10, 16, 18, 21, 23, 24, 25, 26, 27, 28, 29,...
%     30, 31, 32, 34, 35, 36, 38, 39, 40, 41, 42];
% lnNums = [1, 2, 3, 6, 7, 8, 9, 10, 16, 18, 21, 23, 24, 25, 26, 27, 28, 29,...
%     31, 32, 34, 35, 36, 38, 39, 40, 41, 42];
rmInd = [19, 22, 26];
lnNums(rmInd) = [];
trees(rmInd) =  [];
treesByType(rmInd) = [];
coordinates(rmInd) = [];
% lnNums = [25, 26, 27, 28, 29];
nSkeles = length(lnNums);
% trees = load_lns(lnNums, skeletonDir);
% 
% %% Group trees by cell type
% % Default is that each neuron is the sole member of its type.
% for iSkele = 1:nSkeles
%     treesByType{iSkele} = trees(iSkele);
% end

%% Get stats from built in TREES 'stats_tree' fn
getStats = 0;
getVol = 1;
getTort = 1;
getPLxBO = 1;
rmStats = 1;
percentiles = 1;
getPriDiam = 1;
getSomaAng = 1;
getCoreShell = 1;

if getStats
    stats = stats_tree(treesByType, [], [], '-w');
end
if getVol
    for iSkele = 1:nSkeles
        vol = vol_tree(trees{iSkele});
        stats.dstats(iSkele).vol = {vol};
        stats.gstats(iSkele).vol = sum(vol);
    end
end
if getTort
    for iSkele = 1:nSkeles
        tort = tortuosity_tree(trees{iSkele});
        stats.dstats(iSkele).tort = {tort};
%         stats.gstats(iSkele).mtort = mean(tort);
        if ~percentiles
            stats.gstats(iSkele).maxtort = max(tort);
        end
    end
end 
if getPLxBO
    for iSkele = 1:nSkeles
        param = PL_x_BO(trees{iSkele});
        stats.gstats(iSkele).PLxBO = param(1);
    end
end
if rmStats
    stats.dstats = rmfield(stats.dstats, 'peucl');
    stats.dstats = rmfield(stats.dstats, 'Plen');
    stats.dstats = rmfield(stats.dstats, 'parea');
end
if percentiles
    for iSkele = 1:nSkeles
        stats.gstats(iSkele).ptort = prctile(stats.dstats(iSkele).tort{1}, 90);
        stats.gstats(iSkele).pbo = prctile(stats.dstats(iSkele).BO{1}, 90);
    end
end 
if getPriDiam
    medPriDiam = primary_neurite_diameter;
    medPriDiam(rmInd) = [];
    for iSkele = 1:nSkeles
        stats.gstats(iSkele).medPriDiam = medPriDiam(iSkele);
    end
end
if getSomaAng
    somaAngle = soma_angle;
    somaAngle(rmInd) = [];
    for iSkele = 1:nSkeles
        stats.gstats(iSkele).somaAngle = somaAngle(iSkele);
    end
end
if getSomaAng
      Shell = core_shell;
    coreShell(rmInd) = [];
    for iSkele = 1:nSkeles
        stats.gstats(iSkele).coreShell = coreShell(iSkele);
    end
end
% Set some variables
dstatNames = fieldnames(stats.dstats);
nDstats =  length(dstatNames);
nBins = 20;
dstatHist = zeros(nBins, nSkeles, nDstats);
dstatRange = zeros(2, nSkeles, nDstats);
dstatBinLocs = zeros(nBins, nDstats);

gstatNames = fieldnames(stats.gstats);
nGstats = length(gstatNames);
gstats = zeros(nSkeles, nGstats);

% Find range for each distribution
for iSkele = 1:nSkeles
    for iStat = 1:nDstats
        dstatRange(1, iSkele, iStat) = ...
            min(stats.dstats(iSkele).(dstatNames{iStat}){1});
        dstatRange(2, iSkele, iStat) = ...
            max(stats.dstats(iSkele).(dstatNames{iStat}){1});
    end
end
tmpMin = squeeze(min(dstatRange(1, :, :)));
tmpMax = squeeze(max(dstatRange(2, :, :)));
dstatRange = [floor(tmpMin), ceil(tmpMax)];
% dstatRange(6,1) = 0;
% dstatRange(7,1) = 0.7;
% dstatRange(6,2) = 2e5;
% dstatRange(7,2) = 1.5;

% Get histograms for dstats
for iStat = 1:nDstats
    dstatBinLocs(:, iStat) = dstatRange(iStat, 1):...
                             (dstatRange(iStat, 2) - dstatRange(iStat, 1)) / ...
                             (nBins - 1):dstatRange(iStat, 2);
end
for iSkele = 1:nSkeles
    for iStat = 1:nDstats
        [dstatHist(:,  iSkele, iStat)] = ...
            hist(stats.dstats(iSkele).(dstatNames{iStat}){1}, dstatBinLocs(:, iStat));
    end
end

% Now get gstats into a matrix
for iSkele = 1:nSkeles
    gstats(iSkele, :) = structfun(@(x) (x), stats.gstats(iSkele));
end

% Remove unwanted stats. Some of the stats that are given are not
% necessarily relevant.
unwantedGstats = [2, 4, 5, 6, 8, 10:14, 16, 17, 18, 19];
% unwantedGstats = [2, 4, 8];
gstats(:, unwantedGstats) = [];
gstatNames(unwantedGstats) = [];
nGstats = length(gstatNames);

%% Plot raw values (of all trees) for each global stat
nSubPlots = ceil(sqrt(nGstats));

figure
colormap(parula)
for iStat = 1:nGstats
    subplot(nSubPlots, nSubPlots, iStat)
    bar(gstats(:, iStat));
    title(gstatNames{iStat})
end

%% Plot stat distributions
nSubPlots = ceil(sqrt(nDstats));
figure
set(gcf, 'DefaultAxesColorOrder',co) 
for iSkele = 1:nSkeles
    for iStat = 1:nDstats
        subplot(nSubPlots, nSubPlots, iStat)
        title(dstatNames{iStat})
        plot(dstatBinLocs(:,iStat), dstatHist(:,:,iStat), 'linewidth', 2, 'color', [0.8 0.8 0.8])
        hold on
        plot(dstatBinLocs(:,iStat), dstatHist(:,iSkele,iStat), 'linewidth', 2)
    end
    pause
end

%% Load LN images (z-projections)
% imgPath = '/home/asa/2017-02-08_LN_skeleton_pics/';
imgPath = 'C:\Users\asa\Documents\2017-02-08_LN_skeleton_pics/';
% lnPics = zeros(1464,2492, 4, nSkeles);

for iSkele = 1:nSkeles
    if any(lnNums(iSkele) == [21, 25, 35])
        lnPics(:,:,:,iSkele) = imread([imgPath '2017-02-08_08bad_LN' ...
                                       num2str(lnNums(iSkele)) '.tif']);
    else
        lnPics(:,:,:,iSkele) = imread([imgPath '2017-02-08_364eb_LN' ...
                                       num2str(lnNums(iSkele)) '.tif']);
    end
end

% Crop images
lnPics(:, [1:399, 2050:end], : , :) = [];
% lnPics(:,:,4,:) = [];
%% Plot combination figure
% Set figure settings
close all
figure
% set(gcf, 'DefaultAxesColorOrder',co)
set(gcf,'color','w');
nXSubPlots = 6;
nYSubPlots = 6 + 1;
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.02], [0.01 0.04], [0.03 0.03]);
h = subplot(nXSubPlots, nYSubPlots, 1)
doSave = 1;

% Write some subplot labels
dstatsFullNames = {'Branch order', 'Branch angle (rad)', 'Branch length', 'Sholl intersections', 'Branch asymmetry', 'volume', 'tortuosity'};
gstatsFullNames = {'Total path length', '# branch points',  'mean branch length', 'mean. branch order', 'Hull area', 'volume', 'PLxBO', '90th p. tortuosity', '90th p. BO', 'Pri. Neurite Diam.', 'Soma loc. (rad)', 'core/shell ratio'}
picRegion = 1:(nXSubPlots * (nYSubPlots - 1));
picRegion(nXSubPlots:nXSubPlots:end) = NaN;
% picRegion(nXSubPlots-1:nXSubPlots:end) = NaN;
% picRegion(nXSubPlots-2:nXSubPlots:end) = NaN;
picRegion(isnan(picRegion)) = [];

pause
for iSkele = 1:nSkeles
    subplot(nYSubPlots,nXSubPlots,picRegion)
    imshow(lnPics(:,:,1:3,iSkele))
    title(['LN ' num2str(lnNums(iSkele))])
    set(gca, 'fontsize', 20)
    for iStat = 1:6
        subplot(nYSubPlots,nXSubPlots,[nXSubPlots * iStat])
        bar(gstats(:, iStat + 6), 'barwidth', 1);
        hold on
        myGstats = zeros(nSkeles, nGstats);
        myGstats(iSkele,:) = gstats(iSkele,:);
        bar(myGstats(:, iStat + 6), 'r', 'barwidth', 1);
%         title(gstatNames{iStat})
        title(gstatsFullNames{iStat + 6})
        set(gca, 'xticklabel', [])
        set(gca, 'box', 'off')
        set(gca, 'fontsize', 12)
        xlim([0 nSkeles + 1])
    end
    for iStat = 1:6
        subplot(nYSubPlots,nXSubPlots,((nYSubPlots-1) * nXSubPlots) + iStat)
        bar(gstats(:, iStat), 'barwidth', 1);
        hold on
        myGstats = zeros(nSkeles, nGstats);
        myGstats(iSkele,:) = gstats(iSkele,:);
        bar(myGstats(:, iStat), 'r', 'barwidth', 1);
%         title(gstatNames{iStat})
        title(gstatsFullNames{iStat})
        set(gca, 'xticklabel', [])
        set(gca, 'box', 'off')
        set(gca, 'fontsize', 12)
        xlim([0 nSkeles + 1])
    end
    if doSave
        fileName = ['2017_03_22_LN' num2str(lnNums(iSkele)) '_morphology_analysis'];
        img = getframe(gcf);
        imwrite(img.cdata, [fileName, '.png']);
    end
%     pause
end
    
%% Plot combination figure
% % Set figure settings
% close all
% figure
% % set(gcf, 'DefaultAxesColorOrder',co)
% set(gcf,'color','w');
% nXSubPlots = nGstats ;
% nYSubPlots = nDstats + 1;
% subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.02], [0.01 0.04], [0.03 0.03]);
% h = subplot(nXSubPlots, nYSubPlots, 1)
% doSave = 0;
% 
% % Write some subplot labels
% dstatsFullNames = {'Branch order', 'Branch angle (rad)', 'Branch length', 'Sholl intersections', 'Branch asymmetry', 'volume', 'tortuosity'};
% gstatsFullNames = {'Total path length', '# branch points',  'mean branch length', 'mean. branch order', 'Hull area', 'volume', 'PLxBO', '90th p. tortuosity', '90th p. BO', 'Pri. Neurite Diam.', 'Soma loc. (rad)', 'core/shell ratio'}
% picRegion = 1:(nXSubPlots * (nYSubPlots - 1));
% picRegion(nXSubPlots:nXSubPlots:end) = NaN;
% picRegion(nXSubPlots-1:nXSubPlots:end) = NaN;
% % picRegion(nXSubPlots-2:nXSubPlots:end) = NaN;
% picRegion(isnan(picRegion)) = [];
% 
% % pause
% for iSkele = 1:nSkeles
%     subplot(nYSubPlots,nXSubPlots,picRegion)
%     imshow(lnPics(:,:,1:3,iSkele))
%     title(['LN ' num2str(lnNums(iSkele))])
%     set(gca, 'fontsize', 20)
%     for iStat = 1:nDstats
%         subplot(nYSubPlots,nXSubPlots,[(nXSubPlots * iStat) - 1, nXSubPlots * iStat])
%         plot(dstatBinLocs(:,iStat), dstatHist(:,:,iStat), 'linewidth', 2, 'color', [0.8 0.8 0.8])
%         hold on
%         plot(dstatBinLocs(:,iStat), dstatHist(:,iSkele,iStat), 'linewidth', 2)
% %         title(dstatNames{iStat})
%         title(dstatsFullNames{iStat})
%         set(gca, 'box', 'off')
%         set(gca, 'fontsize', 14)
%         hold off
%     end
%     for iStat = 1:nGstats
%         subplot(nYSubPlots,nXSubPlots,((nYSubPlots-1) * nXSubPlots) + iStat)
%         bar(gstats(:, iStat));
%         hold on
%         myGstats = zeros(nSkeles, nGstats);
%         myGstats(iSkele,:) = gstats(iSkele,:);
%         bar(myGstats(:, iStat), 'r');
% %         title(gstatNames{iStat})
%         title(gstatsFullNames{iStat})
%         set(gca, 'xticklabel', [])
%         set(gca, 'box', 'off')
%         set(gca, 'fontsize', 12)
%     end
%     if doSave
%         fileName = ['2017_03_22_LN' num2str(lnNums(iSkele)) '_morphology_analysis'];
%         img = getframe(gcf);
%         imwrite(img.cdata, [fileName, '.png']);
%     end
%     pause
% end
