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
ims = [];
for p = 1:3
    
    xs = fibers(:,1,p);
    ys = fibers(:,2,p);
    
    axis off
    imshow(fse_win(:,:,p),[])
    hold on
    
    % plot DTI fibers
    for j = 1:2:length(xs)-1
        plot(xs(j:j+1),ys(j:j+1),'--g','LineWidth',2)
    end
    
    % add arrows
    clr = 'green';
    fs = 24;
    if p == 1
        text(275, 170, '→', 'Color',clr,'FontSize',fs,'FontWeight','bold')
        text(295, 255, '→', 'Color',clr,'FontSize',fs,'FontWeight','bold')
    elseif p == 2
        text(270, 155, '→', 'Color',clr,'FontSize',fs,'FontWeight','bold')
        text(290, 250, '→', 'Color',clr,'FontSize',fs,'FontWeight','bold')
    else
        text(290, 270, '→', 'Color',clr,'FontSize',fs,'FontWeight','bold')
    end
    
    % store image
    ims = cat(2, ims, frame2im(getframe(gcf)));
end
close
imshow(ims)
saveas(gcf, 'Figure 2.png')
saveas(gcf,'Figure 2','epsc')