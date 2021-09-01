%% Processing raw force data
home_dir = pwd;
force_path = uigetdir(home_dir,'Select force data folder');
name = char(regexp(force_path,'\d{6}-\w{2}\\\w','match'));
name = strrep(name,'\','-');
force = force_data_read(force_path);
%% Processing FSE data
% get FSE at same location as dynamic scan
fse = dicom_data_read();
fse.image = imresize(fse.image,[256 256]); % resize FSE to match dynamic
%% Processing dyanmic data
% process dynamic images

for i=1:2
    dynamic_dir = uigetdir(home_dir,'Select dyanmic data folder');
    dynamic(i) = recon_fs(dynamic_dir);
end

% convert from cm/s to mm/s (x10) and negate Vx
for j = 1:length(dynamic)
    dynamic(j).Vx = -10 * dynamic(j).Vx;
    dynamic(j).Vy = 10 * dynamic(j).Vy;
    dynamic(j).Vz = 10 * dynamic(j).Vz;
end

% % ensure dynamic & FSE image alignment
% for j = 1:length(dynamic)
%     while true
%         imshow(dynamic(j).M(:,:,1))
%         ui_response = questdlg('Images Are Aligned?',...
%             'UI Menu',...
%             'Looks good','Flip Vertical','Flip Horizontal','Looks good');
%         switch ui_response
%             case 'Looks good'
%                 close all
%                 break
%             case 'Flip Vertical'
%                 flip_dir=1;
%             case 'Flip Horizontal'
%                 flip_dir=2;
%         end
%         dynamic(j).M  = flip(dynamic(j).M,flip_dir);
%         dynamic(j).Vx = flip(dynamic(j).Vx,flip_dir);
%         dynamic(j).Vy = flip(dynamic(j).Vy,flip_dir);
%         dynamic(j).Vz = flip(dynamic(j).Vz,flip_dir);
%     end
% end

% perform anisotropic smoothing
num_iter = 10;
kappa = 2;
option = 1; 
delta_t = 1/7;
num_frames = size(dynamic(j).M,3);

for j=1:length(dynamic)
    for i=1:num_frames
        dynamic(j).Vx_SM (:,:,i) = anisodiff2D(dynamic(j).Vx(:,:,i),...
            dynamic(j).M(:,:,i),num_iter,delta_t, kappa,option);
        dynamic(j).Vy_SM (:,:,i) = anisodiff2D(dynamic(j).Vy(:,:,i),...
            dynamic(j).M(:,:,i),num_iter,delta_t, kappa,option);
        dynamic(j).Vz_SM (:,:,i) = anisodiff2D(dynamic(j).Vz(:,:,i),...
            dynamic(j).M(:,:,i),num_iter,delta_t, kappa,option);
    end
end
%% get DTI fibers

% load dti data
% set slice so location corresponds to dynamic
slice = 6;
image = dynamic(1).M(:,:,1);
eigen_val = squeeze(DTI_data.DTI_eigenvalue(:,:,slice,:));
eigen_vec = squeeze(DTI_data.DTI_eigenvector(:,:,slice,:,:));
fibers = get_dti_fibers(image, eigen_val, eigen_vec);
%% Save final data
filename = name + " processed data.mat";
save(filename, 'name', 'dynamic', 'force', 'fse', 'fibers')


