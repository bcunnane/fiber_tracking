%% aponeurosis main
% strain analysis of MG aponeurosis (apo)
% sl = soleus apo, dp = MG deep apo, sp = MG superficial apo

%load('all_data_with_ma.mat')

for n = 1%:length(data)
    apo(n).ID = data(n).ID;
    apo(n).M = data(n).M;
    apo(n).sl = process_apo(data(n),'id soleus apo');
    apo(n).dp = process_apo(data(n),'id mg deep apo');
    apo(n).sp = process_apo(data(n),'id mg superficial apo');
end

%% plotting
p = 14;
x = 1:11;
plot(x,apo.sl.strains(:,p),'-or',x,apo.dp.strains(:,p),'-og',x,apo.sp.strains(:,p),'-ob')
xlim([1 12])
ylim([-.2 .2])

%% Functions
function result = process_apo(D, instructions)
% returns tracked locations of 12 evenly spaced points on outline of 
% user-identifed aponeurosis

pix_spacing = 1.1719; %pixel spacing, to convert to mm

% get aponeurosis outline
figure('Name',instructions,'NumberTitle','off')
imshow(D.M(:,:,1),[])
roi = drawpolyline();

% split into 12 evenly spaced starting points
start_pts = interparc(12, roi.Position(:,1), roi.Position(:,2), 'spline');
close

% track starting points
RES = 1.1719;
START_FRAME = 1;
num_frames = size(D(1).M,3);
dt = ones(num_frames-1,1)  *0.136;
[result.xs, result.ys] = track2dv4(start_pts(:,1), start_pts(:,2), ...
    D.Vx, D.Vz, dt, RES, START_FRAME);

% calculate
dxs = result.xs(2:12,:) - result.xs(1:11,:);
dys = result.ys(2:12,:) - result.ys(1:11,:);
result.lengths = sqrt(dxs.^2 + dys.^2) .* pix_spacing;
result.strains = (result.lengths - result.lengths(:,1)) ./ result.lengths(:,1);

end











