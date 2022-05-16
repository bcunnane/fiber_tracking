%% main_apo_processing
% processing of medial gastrocnemius (MG) and soleus aponeurosis (apo)
% sl = soleus apo, dp = MG deep apo, sp = MG superficial apo
% use data from fiber_track_analysis (including peak strain index)

%load('all_data_with_ma.mat')

for n = 1%:2:length(data)
    
    % soleus apo
    start_pts = id_apo(data(n),'id soleus apo');
    data(n).sl = track_apo(data(n), start_pts);
    data(n+1).sl = track_apo(data(n+1), start_pts);
    
    % deep apo
    start_pts = id_apo(data(n),'id mg deep apo');
    data(n).dp = track_apo(data(n), start_pts);
    data(n+1).dp = track_apo(data(n+1), start_pts);
    
    %superficial apo
    start_pts = id_apo(data(n),'id mg superficial apo');
    data(n).sp = track_apo(data(n), start_pts);
    data(n+1).sp = track_apo(data(n+1), start_pts);

end

%% Functions
function start_pts = id_apo(D, instructions)
% returns 12 evenly spaced points on outline of user-identifed aponeurosis

% get aponeurosis outline
f = figure('Name',instructions,'NumberTitle','off');
imshow(D.M(:,:,1),[])
f.Position = [300 100 880 660];
roi = drawpolyline();

% split into 12 evenly spaced starting points
start_pts = interparc(12, roi.Position(:,1), roi.Position(:,2), 'spline');
close
end

function apo = track_apo(D, start_pts)
% returns tracked locations of aponeurosis outline points

% track starting points
RES = 1.1719;
START_FRAME = 1;
PIX_SPACING = 1.1719; %pixel spacing, to convert to mm

num_frames = size(D(1).M,3);
dt = ones(num_frames-1,1)  *0.136;
[apo.xs, apo.ys] = track2dv4(start_pts(:,1), start_pts(:,2), ...
    D.Vx, D.Vz, dt, RES, START_FRAME);


% calculate
dxs = apo.xs(2:12,:) - apo.xs(1:11,:);
dys = apo.ys(2:12,:) - apo.ys(1:11,:);
apo.lengths = sqrt(dxs.^2 + dys.^2) .* PIX_SPACING;
apo.strains = (apo.lengths - apo.lengths(:,1)) ./ apo.lengths(:,1);

end











