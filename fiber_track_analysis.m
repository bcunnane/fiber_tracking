%Fiber Track Analysis
% main analysis file for vepc fiber tracking in MG muscle
% expects .mat files containing processed vepc data
% note: create an empty table named T_all before running

PPF = 2; %points per fiber
RES = 1.1719;
START_FRAME = 1;

files = dir('*.mat');
for n = 1:length(files)
    load(files(n).name)
    num_frames = size(dynamic(1).M,3);
    dt = ones(num_frames-1,1)*0.136;
    for j = length(dynamic):-1:1
        % data is proximal middle distal from top to bottom
        
        % analysis for all frames
        [results(j).xs, results(j).ys]= track2dv4(fibers(:,1),fibers(:,2),dynamic(j).Vx_SM, dynamic(j).Vz_SM,dt,RES,START_FRAME);
        results(j).dxs = results(j).xs(PPF:PPF:end,:) - results(j).xs(1:PPF:end,:);
        results(j).dys = results(j).ys(PPF:PPF:end,:) - results(j).ys(1:PPF:end,:);
        results(j).lengths = sqrt(results(j).dxs.^2 + results(j).dys.^2);
        results(j).slopes = results(j).dys ./ results(j).dxs;
        results(j).angles = acosd(abs(results(j).dys ./ results(j).lengths)); %to +Y axis
        results(j).strains = (results(j).lengths - results(j).lengths(:,1)) ./ results(j).lengths(:,1);
        
        series_name(j)= string([name,' ',num2str(round(force(j).pcent)),'% MVC']);
        %fiber_cycle_plot(results(j), force(j).mean, dynamic(j).M(:,:,1), fibers, series_name(j))
        %fiber_gif(dynamic(j).M, results(j).xs, results(j).ys, series_name(j))
        
        % analysis for peak strain
        series = repmat(series_name(j),3,1);
        regions = ["proximal";"middle";"distal"];
        
        abs_strains = abs(results(j).strains);
        peak_strains = max(abs_strains,[],2);
        peak_strain_frames = find(abs_strains == peak_strains);
        
        peak_strain_angles = results(j).angles(peak_strain_frames);
        delta_angles = results(j).angles(:,1) - peak_strain_angles; %degrees
        
        peak_strain_lengths = results(j).lengths(peak_strain_frames);
        delta_lengths = results(j).lengths(:,1) - peak_strain_lengths;
        pixel_spacing = 1.1719; % from dicom header
        delta_lengths = delta_lengths * pixel_spacing; % convert to mm
        
        T = table(series,regions,peak_strains,delta_angles,delta_lengths);
        T_all = [T_all; T];
    end
end

