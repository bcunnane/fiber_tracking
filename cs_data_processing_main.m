%% Processing raw support data
force = force_data_read();
fse = dicom_data_read;
fibers = fiber_data_read();

% convert to pixels if mm
fibers.x = fibers.x / fse.header.PixelSpacing(1);
fibers.y = fibers.y / fse.header.PixelSpacing(2);

% resize FSE and fiber points to match dyanimic im size
num_pix = size(dynamic(1).M,1);
% fse.image = imresize(fse.image,[num_pix num_pix]);
fibers.x = round(fibers.x / 2);
fibers.y = round(fibers.y / 2);
%% Processing raw CS data
% import raw p files
% raw = pfile2struct;
% 
% % reconstruct compressed sensing data
% for i=1:size(raw,2)
%     dynamic(i) = reconCS(raw(i), 'cs4vps2', i); 
% end

% convert from cm/s to mm/s (x10) and negate Vx
for j = 1:length(dynamic)
    dynamic(j).Vx = -10 * dynamic(j).Vx;
    dynamic(j).Vy = 10 * dynamic(j).Vy;
    dynamic(j).Vz = 10 * dynamic(j).Vz;
end

% ensure dynamic & FSE image alignment
for j = 1:length(dynamic)
    while true
        imshowpair(dynamic(j).M(:,:,1),imresize(fse.image,[256 256]))
        ui_response = questdlg('Images Are Aligned?',...
            'UI Menu',...
            'Looks good','Flip Vertical','Flip Horizontal','Looks good');
        switch ui_response
            case 'Looks good'
                close all
                break
            case 'Flip Vertical'
                flip_dir=1;
            case 'Flip Horizontal'
                flip_dir=2;
        end
        dynamic(j).M  = flip(dynamic(j).M,flip_dir);
        dynamic(j).Vx = flip(dynamic(j).Vx,flip_dir);
        dynamic(j).Vy = flip(dynamic(j).Vy,flip_dir);
        dynamic(j).Vz = flip(dynamic(j).Vz,flip_dir);
    end
end

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
%% Save final data
name = pwd;
name = strrep(name(end-7:end),'\',' ');
filename = name + " processed data.mat";
save(filename, 'name', 'dynamic', 'force', 'fse', 'fibers')


