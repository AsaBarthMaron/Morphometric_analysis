% TODO:
for iSkele = 1:nSkeles
intree = trees{iSkele};
pathLength = Pvec_tree(intree);
branchOrder = BO_tree(intree);

sect = dissect_tree (intree);

pathLength = pathLength(sect);
branchOrder = branchOrder(sect);
branchLength = diff(pathLength, [], 2);

% [B, I] = sort(pathLength(:, 1));
% scatter(B, branchLength(I));
% xlabel('Path length'); ylabel('Branch Length')
% title(['Tree ' num2str(iSkele) ', Corr: ' ...
%     num2str(corr(B, branchLength(I)))], 'fontsize', 20);
% set(gca, 'fontsize', 16)

% [B, I] = sort(branchOrder(:, 1));
% scatter(B, branchLength(I));
% xlabel('Branch order'); ylabel('Branch Length')
% title(['Tree ' num2str(iSkele) ', Corr: ' ...
%     num2str(corr(B, branchLength(I)))], 'fontsize', 20);
% set(gca, 'fontsize', 16)

[B, I] = sort(pathLength(:, 1));
x = cat(2, B, ones(length(B), 1)) \ branchOrder(I, 1);
scatter(B, branchOrder(I, 1));
hold on

plot(B, cat(2, B, ones(length(B), 1))  * x)
xlabel('Path length'); ylabel('Branch order')
title(['Tree ' num2str(iSkele) ', Corr: ' ...
    num2str(corr(B, branchOrder(I, 1)))], 'fontsize', 20);
set(gca, 'fontsize', 16)
hold off
% [B, I] = sort(branchLength);
% scatter(B, branchOrder(I));
% xlabel('Branch length'); ylabel('Branch Order')
% title(['Tree ' num2str(iSkele) ', Corr: ' ...
%     num2str(corr(B, branchOrder(I)))], 'fontsize', 20);
% set(gca, 'fontsize', 16)

pause
end