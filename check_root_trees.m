figure
pause
for iSkele = 1:nSkeles
    redirect_tree(iSkele, rootNodeIndex(iSkele))
    plot_tree(iSkele, BO_tree(iSkele))
    axis square
    set(gca, 'Ydir', 'reverse')
%     pause
    fileName = ['2017_02_12_LN_' num2str(lnNums(iSkele)) '_rerooted_branch_order'];
    img = getframe(gcf);
    imwrite(img.cdata(63:726, 468:1133, :), [fileName, '.png']);
    clf
end