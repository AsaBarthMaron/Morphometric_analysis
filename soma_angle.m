function [theta] = soma_angle
load('Z:\Data\EM_analyses\2017-03-20_soma_data\soma_locations.mat');
plotResults = 1;
lnNames = [lnNames(23:end); flipud(lnNames(1:22))];
somaXYZ = [somaXYZ(23:end, :); flipud(somaXYZ(1:22, :))];
lnNames(12) = [];
somaXYZ(12, :) = [];
%% Get angle of somas

CENTER = [7000, 7000, 4870]; % AL x,y,z center

somaXYZ = bsxfun(@minus, somaXYZ, CENTER);
% theta = atan2(somaXYZ(:,2), somaXYZ(:,1));
[theta, rho] = cart2pol(somaXYZ(:,1), somaXYZ(:,2));
theta(theta < 0) = 2 * pi - abs(theta(theta < 0));
%%
if plotResults
    [x, y] = pol2cart(theta, rho);
    figure
    plot(somaXYZ(:,1), somaXYZ(:,2), '*')
    hold on
    plot(0,0, '*')
    hold on
    plot([zeros(31,1) x]', [zeros(31,1) y]')
end