%% main script

files = dir('*.dcm');

% import data
for n = length(files):-1:1
    data(n).name = files(n).name;
    data(n).im = dicomread(data(n).name);
    data(n).info = dicominfo(data(n).name);
end

% get moment arms
% for n = length(files):-1:1
%     [data(n).ma_im, data(n).ma] = get_moment_arm(data(n).im, data(n).info.PixelSpacing(1),data(n).name);
%     data(n).ma = data(n).ma * data(n).info.PixelSpacing(1); % convert to mm
%     ma_ims(:,:,n) = data(n).ma_im;
% end

% get foot angles
for n = length(files):-1:1
    [data(n).fa_im, data(n).fa] = get_foot_angle(data(n).im, data(n).name);
    fa_ims(:,:,n) = data(n).fa_im;
end

save('foot position data.mat','data')

%% functions

function [ma_im, ma] = get_moment_arm(im, pix_spacing, name)
% determines moment arm (ma) from user input points

% Instructions for acquiring points
disp('Identify in order:')
disp('(1) achilles tendon')
disp('(2) achilles tendon insertion point,')
disp('(3) ankle center')

% get user input points
imshow(im,[])
ax = gca;
ax.Toolbar.Visible = 'off';
pts = ginput(3);

% get line coefficients
achilles_coeffs = polyfit(pts(1:2,1),pts(1:2,2), 1);
ma_coeffs(1) = -1/achilles_coeffs(1);
ma_coeffs(2) = pts(3,2) - (pts(3,1) * ma_coeffs(1));

% get line points
x = 0:256;
achilles_y = polyval(achilles_coeffs,x);
ma_y = polyval(ma_coeffs,x);

% get moment arm
[pts(4,1),pts(4,2)] = polyxpoly(x, achilles_y, x, ma_y); % intersection
ma = sqrt( (pts(4,1)-pts(3,1))^2 + (pts(4,2)-pts(3,2))^2);
ma = ma * pix_spacing; % convert to mm
ma = round(ma);

% annotate figure
hold on
plot(pts(1:2,1),pts(1:2,2),'-ow')
plot(pts(3:4,1),pts(3:4,2),'-ow')
text(10,10,name,'Color','white','FontSize',9)
text(pts(4,1)+10,pts(4,2),['ma = ',num2str(ma),'mm'],'Color','white','FontSize',9)

% save figure
fig = getframe(gcf);
ma_im = fig.cdata(:,:,1);

end


function [fa_im, fa] = get_foot_angle(im, name)
% determines foot angle (fa) from user input points

% Instructions for acquiring points
disp('Identify in order:')
disp('(1) heel')
disp('(2) toe,')

% get user input points
imshow(im,[])
ax = gca;
ax.Toolbar.Visible = 'off';
pts = ginput(2);

% get foot angle
dx = pts(2,1) - pts(1,1);
dy = pts(2,2) - pts(1,2);
fa = atand(dy/dx);
fa = round(fa);

% annotate figure
hold on
plot([pts(1,1) pts(2,1)],[pts(1,2) pts(2,2)],'-w')
plot([pts(1,1) pts(2,1)],[pts(1,2) pts(1,2)],'-w')
text(10,10,name,'Color','white','FontSize',9)
text(pts(1,1)+10,pts(1,2),[num2str(fa),char(176)],'Color','white','FontSize',9)

% save figure
fig = getframe(gcf);
fa_im = fig.cdata(:,:,1);

end
