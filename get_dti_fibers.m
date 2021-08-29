%GET DTI FIBERS 
% Determines muscle fibers from MR diffusion data via average direction
% within a region of interest (ROI)

%load('DTI.mat')
NUM_ROIS = 3;
slice = 8; %set so location is same as dynamic
%image = dynamic(1).M(:,:,1);
eigen_val = squeeze(DTI_data.DTI_eigenvalue(:,:,slice,:));
eigen_vec = squeeze(DTI_data.DTI_eigenvector(:,:,slice,:,:));


%analyze
rois = get_rois(image, NUM_ROIS);  %select 4 points surrounding MG muscle
masks = get_masks(rois);
for n = size(masks,3):-1:1
    c = regionprops(masks(:,:,n),'centroid');
    centroids(n,:) = [c.Centroid];
end
masks = apply_FA_filter(masks,eigen_val);
fiber_dirs = get_fiber_dirs(eigen_vec, masks);
fibers = get_fiber_coords(fiber_dirs, centroids, rois);
save('fibers.mat','fibers')


%display
figure('Name','DTI Fibers','NumberTitle','off')
subplot(1,3,1)
show_rois(image, rois)
subplot(1,3,2)
show_masks(image, masks)
subplot(1,3,3)
show_fibers(image, fibers)
saveas(gcf,'DTI results.png')

    
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


function masks = get_masks(rois)
% returns logical array mask based on each regions of interest and 
%   expects ROIs matrix is [x, y, n] where n is the region number

% get region masks
for n = size(rois,3):-1:1
    masks(:,:,n) = poly2mask(rois(:,1,n), rois(:,2,n),256,256);
    masks(:,:,n) = bwmorph(masks(:,:,n),'erode'); %remove pix from edges
end
end


function masks = apply_FA_filter(masks, eigen_vals)
% Applies fractional anisotropy (FA) threshold filter to region mask
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

% combine region masks & FA filter
for n = size(masks,3):-1:1
    masks(:,:,n) = masks(:,:,n) .* fa_filter;
end
end


function fiber_dirs = get_fiber_dirs(eigen_vec, masks)
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
    
    sign_idx = ys > 0;
    ys(sign_idx) = ys(sign_idx) .* -1;
    xs(sign_idx) = xs(sign_idx) .* -1;
    
    fiber_dirs(n,:) = [mean(xs), mean(ys)];
end
end


function fibers = get_fiber_coords(fiber_dirs, centroids, rois)
% calculates muscle fiber endpoint coordinates
%   Normalizes the fiber direction based on largest value
%   Generates a long fiber line for each ROI
%   Intersection of long fiber line and ROI boundary is determined
%   Note: input and output coords have top-left origins (pixel default)

NUM_PIX = 256;

for n = size(fiber_dirs,1):-1:1
    % create long fiber line
    fiber_dirs(n,:) = fiber_dirs(n,:) ./ max(abs(fiber_dirs(n,:))); %normalize
    fiber_line(2,:) = centroids(n,:) + fiber_dirs(n,:) .* NUM_PIX;
    fiber_line(1,:) = centroids(n,:) - fiber_dirs(n,:) .* NUM_PIX;
    
    % get intercept and save as fiber coordinates
    [x,y] = polyxpoly(rois(:,1,n),rois(:,2,n),fiber_line(:,1),fiber_line(:,2));
    fibers(2*n-1:2*n,1:2) = [x,y];
end
end


function show_rois(image,rois)
% displays regions of interest on image
%   expects ROI matrix is [x y n] where n is the region number

imshow(image,[])
hold on
for n = 1:size(rois,3)
    plot(rois(:,1,n),rois(:,2,n))
end
title('ROIs')
end


function show_masks(image, masks)
% displays masks on image
%   expects mask matrix is [x y n] where n is the region number
all_masks = logical(sum(masks,3));
image(all_masks) = max(image(:));
imshow(image,[])
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






