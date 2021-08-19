%% start up
load('022621 P processed data.mat')

% constants
PPF = 2; %points per fiber
RES = 1.1719;
START_FRAME = 1;

% variables
num_frames = size(dynamic(1).M,3);
dt = ones(num_frames-1,1)*0.136;

%% analysis
for j = length(dynamic):-1:1
    
    % register FSE (#moving) to 1st frame of magnitude dynamic (#fixed)
    tform = affine_register(fse.image, dynamic(j).M(:,:,1));
    
    % convert points
    [reg_x, reg_y]= transformPointsForward(tform, fibers.x, fibers.y);
        
    % calcs
    [results(j).xs,results(j).ys]= track2dv4(reg_x,reg_y,dynamic(j).Vx_SM, dynamic(j).Vz_SM,dt,RES,START_FRAME);
    results(j).dxs = results(j).xs(PPF:PPF:end,:)-results(j).xs(1:PPF:end,:);
    results(j).dys = results(j).ys(PPF:PPF:end,:)-results(j).ys(1:PPF:end,:);
    results(j).lengths = sqrt(results(j).dxs.^2 + results(j).dys.^2);
    results(j).slopes = results(j).dys ./ results(j).dxs;
    results(j).angles = (180/pi())*acos(results(j).dys ./ results(j).lengths); %to +Y axis
    results(j).strains = (results(j).lengths - results(j).lengths(:,1)) ./ results(j).lengths(:,1);
    
    % save results
    series(j)= string([name,' ',num2str(round(force(j).pcent,1)),'% MVC']);
    fiber_cycle_plot(results(j), force(j).mean, fse, fibers, series(j))
    fiber_gif(dynamic(j).M, results(j).xs, results(j).ys, series(j))
end

