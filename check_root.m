for iSkele = 1:nSkeles
    redirect_tree(iSkele, rootNodeIndex(iSkele))
    plot_tree(iSkele, BO_tree(iSkele))
    axis square
    set(gca, 'Ydir', 'reverse')
    pause
    clf
end