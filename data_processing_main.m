%% Data Processing Main
% main script for importing and processing ankle angle MG VEPC study data
% set working directory to subject data folder ie /930312-BC
%% Import Data
posn = 'DNP';
pct = ['50%MVC';'25%MVC'];
home_dir = pwd;
dicom_dirs = dir([home_dir,'\','_DICOM']);
dicom_dirs = {dicom_dirs(4:end).name}';
for k = 3
    % get force data
    force_path = [home_dir,'\',posn(k)];
    temp = force_data_read(force_path);
    cd(home_dir)
    
    % load DTI data
    load([home_dir,'/DTI_',posn(k)])
    
    for s = 1:2
        % get name
        temp(s).ID = char(regexp(force_path,'\d{6}-\w{2}\\\w','match'));
        temp(s).ID = [strrep(temp(s).ID,'\','-'),' ',pct(s,:)];
        
        % get dynamic data
        series = str2num(temp(s).series_num);
        dynamic = recon_fs([home_dir,'/_DICOM/',dicom_dirs{series}]);
        
        % get location information
        temp(s).loc = dynamic.location;
        [~,temp(s).slice] = min(abs(DTI_data.location-temp(s).loc));
        
        % apply anisotropic smoothing to velocities
        num_iter = 10;
        kappa = 2;
        option = 1;
        delta_t = 1/7;
        num_frames = size(dynamic.M,3);
        for i=1:num_frames
            dynamic.Vx (:,:,i) = anisodiff2D(dynamic.Vx(:,:,i),...
                dynamic.M(:,:,i),num_iter,delta_t, kappa,option);
            dynamic.Vy (:,:,i) = anisodiff2D(dynamic.Vy(:,:,i),...
                dynamic.M(:,:,i),num_iter,delta_t, kappa,option);
            dynamic.Vz (:,:,i) = anisodiff2D(dynamic.Vz(:,:,i),...
                dynamic.M(:,:,i),num_iter,delta_t, kappa,option);
        end
        
        % assign dynamic images to data structure
        % convert velocities from cm/s to mm/s (x10) and negate Vx
        temp(s).M = dynamic.M;
        temp(s).Vx = -10 * dynamic.Vx;
        temp(s).Vy = 10 * dynamic.Vy;
        temp(s).Vz = 10 * dynamic.Vz;
    end
    
    % get DTI fibers
    fa_filter = logical(DTI_data.FA(:,:,temp(s).slice) > 0.15);
    eigen_vec = squeeze(DTI_data.DTI_eigenvector(:,:,temp(s).slice,:,:));
    temp(s).fibers = get_dti_fibers(dynamic(1).M(:,:,1), eigen_vec, fa_filter);
    temp(1).fibers = temp(2).fibers;
    saveas(gcf,[temp(1).ID(1:11),' DTI results.png'])
    close
end
%% Track Fibers
RES = 1.1719;
START_FRAME = 1;
for k = 1:length(temp)
    num_frames = size(temp(1).M,3);
    dt = ones(num_frames-1,1)*0.136;
    [temp(k).xs, temp(k).ys] = track2dv4(temp(k).fibers(:,1),...
        temp(k).fibers(:,2), temp(k).Vx, temp(k).Vz, dt, RES, START_FRAME);
    single_fiber_gif(temp(k).M, temp(k).xs, temp(k).ys, temp(k).ID)
end
%% Save together
data = [data,temp];