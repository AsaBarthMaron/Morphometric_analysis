function trees = load_lns(lnNums, skeletonDir)
    start_trees
    nSkeles = length(lnNums);
%     scalingFactor = 8e-3;
    scalingFactor = 1;

    for iSkele = 1:nSkeles
        load_tree([skeletonDir, 'LN' num2str(lnNums(iSkele)), ...
            '_inflated_skeleton.swc']);

        trees{iSkele}.X = trees{iSkele}.X * scalingFactor;
        trees{iSkele}.Y = trees{iSkele}.Y * scalingFactor;
        trees{iSkele}.Z = trees{iSkele}.Z * scalingFactor;
    end