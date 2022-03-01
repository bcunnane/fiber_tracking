function fibers = get_dti_fibers(image, eigen_vec, fa_filter)
% Determines muscle fibers from MR diffusion data via average direction
% within a region of interest (ROI)

%analyze
[mpix, npix] = size(image);
roi = get_roi(image);
masks = get_masks(roi, mpix, npix);
for n = size(masks,3):-1:1
    props = regionprops(masks(:,:,n),'Centroid','Extrema');
    centroids(n,:) = [props.Centroid];
    bounds(:,:,n) = props.Extrema;
end
bounds = [bounds; bounds(1,:,:)]; %close boundaries

for n = size(masks,3):-1:1
    masks(:,:,n) = masks(:,:,n) .* fa_filter; % apply FA filter
end

fiber_dirs = get_fiber_dirs(eigen_vec, masks);
fibers = get_fiber_coords(fiber_dirs, centroids, bounds, npix);

%display
figure('Name','DTI Fibers','NumberTitle','off')
set(gcf, 'Position',  [100, 100, 1200, 400])
subplot(1,3,1)
show_rois(image, roi)
subplot(1,3,2)
show_masks(image, masks)
subplot(1,3,3)
show_fibers(image, fibers)
saveas(gcf,'DTI results.png')
end


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


function fibers = get_fiber_coords(fiber_dirs, centroids, bounds, npix)
% calculates muscle fiber endpoint coordinates
%   Normalizes the fiber direction based on largest value
%   Generates a long fiber line for each region
%   Intersection of long fiber line and region boundary is determined
%   Note: input and output coords have top-left origins (pixel default)

for n = size(fiber_dirs,1):-1:1
    % create long line segment in direction of fiber
    fiber_dirs(n,:) = fiber_dirs(n,:) ./ max(abs(fiber_dirs(n,:))); %normalize
    line(2,:) = centroids(n,:) + fiber_dirs(n,:) .* npix;
    line(1,:) = centroids(n,:) - fiber_dirs(n,:) .* npix;
    
    % intercept of line segment and region boundary = fiber end points
    [x,y] = polyxpoly(bounds(:,1,n), bounds(:,2,n), line(:,1), line(:,2));
    fibers((2*n-1):(2*n),1:2) = [x,y];
end
end


function show_rois(image,roi)
% displays regions of interest on image
%   expects ROI matrix is [x y]
imshow(image,[])
hold on
plot(roi(:,1),roi(:,2),'-oc')
title('ROI')
end


function show_masks(image, masks)
% displays masks on image
%   expects mask matrix is [x y n] where n is the region number
all_masks = logical(sum(masks,3));
image(all_masks) = max(image(:));
imshow(image,[])
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






