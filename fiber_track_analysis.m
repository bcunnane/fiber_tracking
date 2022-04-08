%% Fiber Track Analysis
% Main analysis script for foot position fiber tracking experiment
% assumes there are 2 points per fiber

%load(all_data.mat)
%% Calculations
pix_spacing = 1.1719; %pixel spacing, to convert to mm

for k = length(data):-1:1
    
    % fiber tracking raw calcs
    dxs = data(k).xs(2:2:end,:) - data(k).xs(1:2:end,:);
    dys = data(k).ys(2:2:end,:) - data(k).ys(1:2:end,:);
    data(k).lengths = sqrt(dxs.^2 + dys.^2) * pix_spacing;
    data(k).angles = acosd(abs(dys ./ data(k).lengths)); %to +Y axis
    data(k).del_lengths = data(k).lengths - data(k).lengths(:,1);
    data(k).del_angles = data(k).angles - data(k).angles(:,1);
    data(k).strains = data(k).del_lengths ./ data(k).lengths(:,1);
    
    % extract desired result values
    data(k).peak_force = max(data(k).mean);
    data(k).peak_torque = data(k).peak_force * data(k).ma * 0.001; %Nm
    [data(k).peak_strain, ps_idx] = min(mean(data(k).strains));
    data(k).str_per_force = data(k).peak_strain / data(k).peak_force;
    data(k).str_per_torque = data(k).peak_strain / data(k).peak_torque;
    
    data(k).init_ang = mean(data(k).angles(:,1));
    data(k).del_ang = mean(data(k).angles(:,ps_idx)) - data(k).init_ang;
    
    data(k).init_len = mean(data(k).lengths(:,1));
    data(k).del_len = mean(data(k).lengths(:,ps_idx)) - data(k).init_len;
end
%% Result Mean Table
rslt_means = table;
rslt_means.position = ['D';'D';'N';'N';'P';'P'];
rslt_means.pctMVC = ['50%';'25%';'50%';'25%';'50%';'25%'];
for k = 1:6
    rslt_means.MVC(k) = mean([data(k:6:end).MVC]);
    rslt_means.peakForce(k) = mean([data(k:6:end).peak_force]);
    rslt_means.peakTorque(k) = mean([data(k:6:end).peak_torque]);
    rslt_means.PeakStrain(k) = mean([data(k:6:end).peak_strain]);
    rslt_means.StrainPerForce(k) = mean([data(k:6:end).str_per_force]);
    rslt_means.StrainPerTorque(k) = mean([data(k:6:end).str_per_torque]);
    rslt_means.StrainPerForce(k) = mean([data(k:6:end).str_per_force]);
    rslt_means.intAng(k) = mean([data(k:6:end).init_ang]);
    rslt_means.delAng(k) = mean([data(k:6:end).del_ang]);
    rslt_means.intLen(k) = mean([data(k:6:end).init_len]);
    rslt_means.delLen(k) = mean([data(k:6:end).del_len]);
end
%% Result Std Table
rslt_stds = table;
rslt_stds.position = ['D';'D';'N';'N';'P';'P'];
rslt_stds.pctMVC = ['50%';'25%';'50%';'25%';'50%';'25%'];
for k = 1:6
    rslt_stds.MVC(k) = std([data(k:6:end).MVC]);
    rslt_stds.peakForce(k) = std([data(k:6:end).peak_force]);
    rslt_stds.peakTorque(k) = std([data(k:6:end).peak_torque]);
    rslt_stds.PeakStrain(k) = std([data(k:6:end).peak_strain]);
    rslt_stds.StrainPerForce(k) = std([data(k:6:end).str_per_force]);
    rslt_stds.StrainPerTorque(k) = std([data(k:6:end).str_per_torque]);
    rslt_stds.StrainPerForce(k) = std([data(k:6:end).str_per_force]);
    rslt_stds.intAng(k) = std([data(k:6:end).init_ang]);
    rslt_stds.delAng(k) = std([data(k:6:end).del_ang]);
    rslt_stds.intLen(k) = std([data(k:6:end).init_len]);
    rslt_stds.delLen(k) = std([data(k:6:end).del_len]);
end

%% Plots
% generate gifs
% for k = 1:6:length(data)
%     fiber_gif(data(k:k+5))
%     close
% end

% generate mean fiber cycle plots
% for k = 1:6:length(data)
%     fiber_cycle_plot(data(k:k+5));
%     close
% end

% generate individual fiber cycle plots
for k = 1:6:length(data)
    indiv_fiber_cycle_plot(data(k:k+5));
    close all
end
