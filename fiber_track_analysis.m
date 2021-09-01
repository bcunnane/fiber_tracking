%% start up
%load('210818-BC-P processed data.mat')

% constants
PPF = 2; %points per fiber
RES = 1.1719;
START_FRAME = 1;

% variables
num_frames = size(dynamic(1).M,3);
dt = ones(num_frames-1,1)*0.136;

%% analysis
for j = length(dynamic):-1:1

    [results(j).xs, results(j).ys]= track2dv4(fibers(:,1),fibers(:,2),dynamic(j).Vx_SM, dynamic(j).Vz_SM,dt,RES,START_FRAME);
    results(j).dxs = results(j).xs(PPF:PPF:end,:) - results(j).xs(1:PPF:end,:);
    results(j).dys = results(j).ys(PPF:PPF:end,:) - results(j).ys(1:PPF:end,:);
    results(j).lengths = sqrt(results(j).dxs.^2 + results(j).dys.^2);
    results(j).slopes = results(j).dys ./ results(j).dxs;
    results(j).angles = acosd(abs(results(j).dys ./ results(j).lengths)); %to +Y axis
    results(j).strains = (results(j).lengths - results(j).lengths(:,1)) ./ results(j).lengths(:,1);
    
    % save results
    series(j)= string([name,' ',num2str(round(force(j).pcent)),'% MVC']);
    fiber_cycle_plot(results(j), force(j).mean, dynamic(j).M(:,:,1), fibers, series(j))
    fiber_gif(dynamic(j).M, results(j).xs, results(j).ys, series(j))
end

