%% Fiber Track Analysis
% Main analysis script for foot position fiber tracking experiment
% assumes there are 2 points per fiber

%load(all_data.mat)
pix_spacing = 1.1719; %pixel spacing, conver to mm
%% Calculations
for k = length(data):-1:1
    % fiber tracking calcs
    dxs = data(k).xs(2:2:end,:) - data(k).xs(1:2:end,2);
    dys = data(k).ys(2:2:end,:) - data(k).ys(1:2:end,2);
    data(k).lengths = sqrt(dxs.^2 + dys.^2) * pix_spacing; 
    data(k).slopes = dys ./ dxs;
    data(k).angles = acosd(abs(dys ./ data(k).lengths)); %to +Y axis
    data(k).strains = (data(k).lengths - data(k).lengths(:,1)) ./ data(k).lengths(:,1);
    
    % average muscle regions proximal, middle, & distal together
    data(k).lengths = mean(data(k).lengths);
    data(k).slopes = mean(data(k).slopes);
    data(k).angles = mean(data(k).angles); %to +Y axis
    data(k).strains = mean(data(k).strains);
    
    % general calcs
    data(k).peak_force = max(data(k).mean);
    [data(k).peak_strain, data(k).ps_idx] = min(data(k).strains);
    data(k).str_per_force = data(k).peak_strain / data(k).peak_force;
    
    data(k).init_ang = data(k).angles(1);
    data(k).del_ang = data(k).angles(data(k).ps_idx) - data(k).init_ang;
    
    data(k).init_len = data(k).lengths(1);
    data(k).del_len = data(k).lengths(data(k).ps_idx) - data(k).init_len;
end
%% Results Table
results = table;
results.position = ['D';'D';'N';'N';'P';'P'];
results.pctMVC = ['50%';'25%';'50%';'25%';'50%';'25%'];
for k = 1:6
    results.MVC(k) = mean([data(k:6:end).MVC]);
    results.peakForce(k) = mean([data(k:6:end).peak_force]);
    results.PeakStrain(k) = mean([data(k:6:end).peak_strain]);
    results.StrainPerForce(k) = mean([data(k:6:end).str_per_force]);
    results.intAng(k) = mean([data(k:6:end).init_ang]);
    results.delAng(k) = mean([data(k:6:end).del_ang]);
    results.intLen(k) = mean([data(k:6:end).init_len]);
    results.delLen(k) = mean([data(k:6:end).del_len]);
end
%% Plots
% generate gifs
for k = 1%:6:length(data)
    fiber_gif(data(k:k+5))
    close
end

% generate cycle plots
for k = 1%:6:length(data)
    fiber_cycle_plot(data(k:k+5));
    close
end

