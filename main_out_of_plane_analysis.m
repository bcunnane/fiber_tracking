%% DTI out-of-plane analysis
% determines the degree to which the DTI fibers are out-of-plane (oop)
% uses the code of get_dti_fibers to get masks
%% processing

% set startup - changes for each subject
ln = 3;%length(oop);
data_idx = 2*ln + 1; %index position of subject's first line in 'data' structure

% determine general subject info
subject = pwd;
subject = subject(end-8:end);
slice = data(data_idx).slice;

posn = 'DNP';
for p = 1:3
    % get ID and first frame of magnitude image
    oop(ln+p).ID = [subject,'-',posn(p)];
    oop(ln+p).M = data(data_idx + (2*p - 2)).M(:,:,1);
    
    % import fiber eigenvector (principle, #3) oop compenent (z) and FA
    load(['DTI_',posn(p)])
    oop(ln+p).z3 = squeeze(DTI_data.DTI_eigenvector(:,:,slice,3,3));
    oop(ln+p).FA = squeeze(DTI_data.FA(:,:,slice));
    
    % get rois
    oop(ln+p).roi = get_roi(oop(ln+p).M);

end

%% get out-of-plane data
% note: masks are in order of: (1)proximal, (2)middle, (3)distal
for n = 1:length(oop)
    
    % get muscle region masks
    oop(n).masks = get_masks(oop(n).roi, 256, 256);
%     for k = 1:3
%         oop(n).masks(:,:,k) = oop(n).masks(:,:,k) .* oop(n).FA; % apply FA filter
%     end
    oop(n).masks = oop(n).masks > 0.0001;
    
    % get z3 regional data within each muscle region
    for k = 1:3
        oop(n).z3_reg{k} = oop(n).z3(oop(n).masks(:,:,k));
    end    
end

%% get statistics
% collect all z3 regional data together
z3_reg = [oop.z3_reg];
for p = 1:3
    reg_data = cell2mat(z3_reg(p:3:54)');
    result(1,p) = mean(reg_data);
    result(2,p) = std(reg_data);
    result(3,p) = mean(abs(reg_data));
    result(4,p) = std(abs(reg_data));
end

%% visualization

% combine images into stacked arrays
z3_ims = abs(cat(3, oop.z3));
mag_ims = cat(3, oop.M);
mask_ims = [oop.masks];
mask_ims = sum(mask_ims,3);
mask_ims = reshape(mask_ims,[256,256,18]);

% convert image stacks into image tiles
z3_ims = imtile(z3_ims,'GridSize', [3 6]);
mag_ims = imtile(mag_ims,'GridSize', [3 6]);
mask_ims = imtile(mask_ims,'GridSize', [3 6]);

% convert magnitude to RGB image
mag_ims = mag_ims(:,:,[1,1,1]) / 3;

% display magnitude image as background
% imshow(mag_ims,[])
% hold on

% overlay FAS colormap
h = imshow(z3_ims,[]);
h.AlphaData = mask_ims;
colormap('jet')
colorbar
set(gca,'visible','off')
caxis([0 .5])

%% functions
function roi = get_roi(image)
% returns ROI coordinates as [x, y]
imshow(image,[])
polygon = drawpolygon();
roi = polygon.Position;
roi = [roi;roi(1,:)]; %close roi by including first point again
close all
end


function masks = get_masks(roi, mpix, npix)
% returns logical array maskS based on region of interest 
%   expects ROI matrix is [x, y]
%   returns region masks as [num_pix, num_pix, n] where n is region number

% get horizontal split lines that divide ROI into 3 approx equal areas
total_mask = poly2mask(roi(:,1), roi(:,2), mpix, npix);
tm_props = regionprops(total_mask);

splits(4) = tm_props.BoundingBox(2) + tm_props.BoundingBox(4);
splits([1 2]) = tm_props.BoundingBox(2); % default (2) to top
splits(3) = splits(1) + tm_props.BoundingBox(4)/2; %default to middle
splits = round(splits);

ideal_area = tm_props.Area / 3;
for j = 1:2
    area = 0;
    while area < ideal_area
        splits(j+1) = splits(j+1) + 1;
        area = sum(total_mask(splits(j):splits(j+1),:),'all');
    end
end

% create masks of 3 individual regions
masks = zeros(mpix, npix, 3);
for n = 1:3
    masks(:,:,n) = total_mask;
    masks(1:splits(n),:,n) = 0; %zeros above split line
    masks(splits(n+1):end,:,n) = 0; % zeros below split line
    masks(:,:,n) = bwmorph(masks(:,:,n),'erode'); %remove pix from edges
end
end
