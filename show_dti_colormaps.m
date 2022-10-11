%% SHOW DTI COLORMAPS
% generates colormaps of DTI principle eigenvector for slice used in VEPC
%% collect data of interest from main "data" struct
idx = 1;
for j=1:2:length(data)
    dti(idx).id = data(j).ID(1:end-9);
    dti(idx).posn = data(j).ID(end-7);
    dti(idx).slice = data(j).slice;
    idx = idx + 1;
end
%% load DTI data
root = 'C:\Users\Brandon\Google Drive\research\fiber_tracking\';
for j=1:length(dti)
    load([root,dti(j).id,'\DTI_',dti(j).posn,'.mat'])
    dti(j).eigvec = squeeze(DTI_data.DTI_eigenvector(:,:,dti(j).slice,:,3));
    dti(j).eigvec = dti(j).eigvec(:,:,[3 1 2]); %set rgb to zxy
end
%% show eigenvector colormaps
for j=1%:3:length(dti)
    im = abs([dti(j:j+2).eigvec]);
    imshow(im)
    %saveas(gcf, [dti(j).id,' DNP principal DTI eigenvector.png'])
end