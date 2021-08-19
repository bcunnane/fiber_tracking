%GET DTI FIBERS 
% Determines muscle fibers from MR diffusion data via average direction
% within a region of interest (ROI)

%load('Results.mat')


%initialize
NUM_ROIS = 3;

series = 1;
slice = 1;
frame = 1;
image = data(series).m(:,:,slice,frame);
eigen_val = squeeze(data(series).dti_val(:,:,slice,:));
eigen_vec = squeeze(data(series).dti_vec(:,:,slice,:,:));

% %analyze
% rois = get_rois(image, NUM_ROIS);  %select 4 points surrounding MG muscle
% masks = get_masks(rois, eigen_val);
fibers = get_fibers(eigen_vec, masks);

% test
% examine_voxels(eigen_vec, masks);

%display
figure('Name','DTI Fibers','NumberTitle','off')
subplot(1,3,1)
show_rois(image, rois)
subplot(1,3,2)
show_masks(image, masks)
subplot(1,3,3)
show_fibers(image, fibers)

function examine_voxels(eigen_vec, masks)
% use only the lead eiven vector (3rd column)
eigen_vec = squeeze(eigen_vec(:,:,:,3));

for n = 1:size(masks,3)
    % get centoid of large ROI
    c = regionprops(masks(:,:,n),'centroid');
    centroid = [c.Centroid];
    centroid = round(centroid);
    
    % get eigen vector of small 5x5 ROIs at centroids
    xpix = [centroid(1)-2 : centroid(1)+2];
    ypix = [centroid(2)-2 : centroid(2)+2];
    ev_x = eigen_vec(xpix, ypix, 1);
    ev_y = eigen_vec(xpix, ypix, 2);
    ev_z = eigen_vec(xpix, ypix, 3);
    
%     ev_x = round(ev_x,2);
%     ev_y = round(ev_y,2);
%     ev_z = round(ev_z,2);
%     disp(table(ev_x,ev_y,ev_z))
    
    mean_ev_x(n,:) = round(mean(abs(ev_x(:))), 2);
    mean_ev_y(n,:) = round(mean(abs(ev_y(:))), 2);
    mean_ev_z(n,:) = round(mean(abs(ev_z(:))), 2);
    

end
disp(table(mean_ev_x, mean_ev_y, mean_ev_z))
end

    
function rois = get_rois(image,num_rois)
% determines 4-point regions of interest (ROIs)
%   returns ROIs based on 4 point user-determined trapezoidal vertices
%   points must be selected counter-clockwise starting from top right
%   returned matrix is [x, y, n] where n is the region number from top
%   region points are counter-clockwise starting from top right

% get vertices
figure('Name','Select 4 MG Muscle Points','NumberTitle','off')
imshow(image,[])
[vtx(:,1), vtx(:,2)] = ginput(4);
close('Select 4 MG Muscle Points') 

% split into small areas. matrix is [x y n] where n is base number
bases(:,2,2) = round(vtx(2,2):abs(vtx(3,2)-vtx(2,2)) / num_rois:vtx(3,2));
bases(:,1,2) = round(vtx(2,1):abs(vtx(3,1)-vtx(2,1)) / num_rois:vtx(3,1));
bases(:,2,1) = round(vtx(1,2):abs(vtx(4,2)-vtx(1,2)) / num_rois:vtx(4,2));
bases(:,1,1) = round(vtx(1,1):abs(vtx(4,1)-vtx(1,1)) / num_rois:vtx(4,1));

% output the regions
for n = num_rois:-1:1
    rois(5,:,n) = bases(n,:,1);
    rois(4,:,n) = bases(n+1,:,1);
    rois(3,:,n) = bases(n+1,:,2);
    rois(2,:,n) = bases(n,:,2);
    rois(1,:,n) = bases(n,:,1);
end
end


function masks = get_masks(rois,eigen_vals)
% returns logical array mask based on each regions of interest and 
% fractional anisotropy (FA) threshold
%   expects ROIs matrix is [x, y, n] where n is the region number
%   expects eigen_value (ev) matrix is [num_pix, num_pix, 3 evs]

% get FA filter
FA_THRESHOLD = 0.15;

ev1s = eigen_vals(:,:,1);
ev2s = eigen_vals(:,:,2);
ev3s = eigen_vals(:,:,3);

numerator = (ev1s - ev2s).^2 + (ev2s - ev3s).^2 + (ev1s - ev3s).^2;
denominator = 2*(ev1s.^2 + ev2s.^2 + ev3s.^2);
fa_vals = sqrt(numerator ./ denominator);

fa_filter = fa_vals > FA_THRESHOLD;

% get region masks
for n = size(rois,3):-1:1
    masks(:,:,n) = poly2mask(rois(:,1,n), rois(:,2,n),256,256);
    masks(:,:,n) = bwmorph(masks(:,:,n),'erode'); %remove pix from edges
end

% combine region masks & FA filter
for n = size(rois,3):-1:1
    masks(:,:,n) = masks(:,:,n) .* fa_filter;
end
end


function fibers = get_fibers(eigen_vec, masks)
% determines fiber direction as average direction in mask region
%   assumes eigen vector matrix is:
%   x1   x2   x3
%   y1   y2   y3
%   z1   z2   z3

for n = size(masks,3):-1:1
    % get fiber direction
    data_in_roi = masks(:, :, n) .* eigen_vec;
    xs = data_in_roi(:,:,1,3);   % see column assumption, 3rd col only
    ys = data_in_roi(:,:,2,3);   % see column assumption, 3rd col only
    xs = xs(xs~=0);
    ys = ys(ys~=0);
    
    opp_sign = ys > 0;
    ys(opp_sign) = ys(opp_sign) .* -1;
    xs(opp_sign) = xs(opp_sign) .* -1;
    
    fiber_dirs(n,:) = [mean(xs), mean(ys)];
    fiber_dirs(n,:) = fiber_dirs(n,:) ./ max(abs(fiber_dirs(n,:))); %normalize
    
    % extrapolate fiber
    c = regionprops(masks(:,:,n),'centroid', 'EquivDiameter');
    centroid = [c.Centroid];
    radius = 0.8 * (c.EquivDiameter / 2); % 0.8r prevents fiber leaving ROI
    fibers(n*2,:) = centroid + fiber_dirs(n,:) .* radius;
    fibers(n*2-1,:) = centroid - fiber_dirs(n,:) .* radius;
end
end


function show_rois(image,rois)
%SHOW_REGIONS displays regions of interest on image
%   expects ROI matrix is [x y n] where n is the region number

imshow(image,[])
hold on
for n = 1:size(rois,3)
    plot(rois(:,1,n),rois(:,2,n))
end
title('ROIs')
end


function show_masks(image, masks)
% display masks on image
%   expects mask matrix is [x y n] where n is the region number
num_masks = size(masks,3);
imshow(image,[])
hold on
for n = 1:size(masks,3)
    m = imshow(masks(:, :, n), []);
    set(m, 'AlphaData', masks(:,:,n)) %alpha is transparency
end
hold off
title('Masks')
end


function show_fibers(image, fibers)
% displays fibers on image
%   expects fiber matrix is [x y] where each fiber is two points

xs = fibers(:, 1);
ys = fibers(:, 2);

imshow(image, []);
hold on
for j = 1:2:length(xs)-1
    plot(xs(j:j+1), ys(j:j+1), '-y')
end
hold off
title('Fibers')
end






