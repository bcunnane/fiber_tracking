%% Foot Position Analysis
% determines the foot angle and moment arm of large FOV DICOM images

%% Import data
files = dir('*.dcm');
num_files = length(files);
% for n = 16:18%num_files:-1:1
%     ft(n).name = files(n).name(1:11);
%     ft(n).im = dicomread(files(n).name);
%     ft(n).info = dicominfo(files(n).name);
% end

%% Get foot angle (fa) & moment arm (ma) 
for n = 18%num_files:-1:1
    %[ft(n).fa_pts, ft(n).fa] = get_foot_angle(ft(n).im);
    %[ft(n).ma_pts, ft(n).ma] = get_moment_arm(ft(n).im, ft(n).info.PixelSpacing(1));
end

%% Display images
k=1;
for n = 13:15%[1:3:num_files,2:3:num_files,3:3:num_files]
    show_foot_posn(ft(n));
    fig = getframe(gcf);
    result_ims(:,:,k) = fig.cdata(:,:,1);
    k = k+1;
end
close
montage(result_ims,'Size',[1 3])%[3 num_files/3]);
saveas(gcf,'foot position results.png')
saveas(gcf,'foot position results','epsc')

%% functions

function [pts, ma] = get_moment_arm(im, pix_spacing)
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
close

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

end


function [pts, fa] = get_foot_angle(im)
% determines foot angle (fa) in degrees from user input points

% Instructions for acquiring points
disp('Identify in order:')
disp('(1) heel')
disp('(2) toe,')

% get user input points
imshow(im,[])
roi = drawline;
pts(2:3,:) = roi.Position;
pts(1,1) = pts(3,1);
pts(1,2) = pts(2,2);
close

% get foot angle
dx = pts(3,1) - pts(2,1);
dy = pts(3,2) - pts(2,2);
fa = atand(dy/dx);
fa = round(fa);

end


function show_foot_posn(data)
% show image
imshow(data.im,[])
ax = gca;
ax.Toolbar.Visible = 'off';
hold on
%text(10,10,data.name,'Color','white','FontSize',9)

% show moment arm
plot(data.ma_pts(1:2,1),data.ma_pts(1:2,2),'-ow')
plot(data.ma_pts(3:4,1),data.ma_pts(3:4,2),'-ow')
%text(data.ma_pts(4,1)+10,data.ma_pts(4,2),['ma = ',num2str(data.ma),'mm'],'Color','white','FontSize',9)
text(data.ma_pts(1,1) + 6, data.ma_pts(1,2) - 7, '1', 'Color','white','FontSize',10)
text(data.ma_pts(2,1) + 8, data.ma_pts(2,2) - 5, '2', 'Color','white','FontSize',10)
text(data.ma_pts(3,1) - 17, data.ma_pts(3,2) - 5, '3', 'Color','white','FontSize',10)

% show foot angle
plot(data.fa_pts(:,1), data.fa_pts(:,2),'-w')
text(data.fa_pts(2,1)+8,data.fa_pts(2,2),[num2str(data.fa),char(176)],'Color','white','FontSize',10)

end
