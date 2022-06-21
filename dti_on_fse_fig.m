%% DTI on FSE Figure
% this script creates a figure overlaying the DTI fibers on FSE images

%% get fse images
folder = 'C:\Users\Brandon\Google Drive\research\fiber_tracking\220311-BC\_DICOM';
fse(:,:,1) = dicomread([folder,'\15_D_FSE_w_WS_17\IM-0017-0006.dcm']);
fse(:,:,2) = dicomread([folder,'\09_N_FSE_w_WS_11\IM-0011-0006.dcm']);
fse(:,:,3) = dicomread([folder,'\03_P_FSE_w_WS_4\IM-0004-0006.dcm']);

%% get fiber coordinates
d = [25 27 29]; % subject BC position in 'data' structure
for p = 1:3
    fibers(:,:,p) = data(d(p)).fibers * 2; % doubling converts 256 to 512
end

%% window fse images manually with imtool
% set window to 40-200
% no change to contrast
% export to workspace as D, N, or P
imtool(fse(:,:,3))

%% collect windowed images into single array
fse_win(:,:,1) = D;
fse_win(:,:,2) = N;
fse_win(:,:,3) = P;

%% Plot fibers
for p = 1:3
    
    xs = fibers(:,1,p);
    ys = fibers(:,2,p);
    
    axis off
    imshow(fse_win(:,:,p),[])
    hold on
    
    for j = 1:2:length(xs)-1
        plot(xs(j:j+1),ys(j:j+1),'-w','LineWidth',2)
    end
    
    % store image
    temp_im = frame2im(getframe(gcf));
    ims(:,:,p) = temp_im(:,:,1);
end
close
montage(ims,'Size',[1 3])
