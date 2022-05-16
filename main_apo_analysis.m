%% main_apo_analysis
% analysis of medial gastrocnemius (MG) and soleus aponeurosis (apo)
% sl = soleus apo, dp = MG deep apo, sp = MG superficial apo
% uses data structure created from main_apo_processing

% create strain distribution plot
for n = 1%:6:length(data)
    strain_dist_plot(data(n:n+5))
end


% % create gifs
% for n = 1%:6:length(data)
%     apo_gif(data(n:n+5))
% end


%% functions
function strain_dist_plot(D)

apo = {'sl','dp','sp'}; % soleus, deep, and superficial apo data

tiledlayout(2,3,'TileSpacing','tight')
for n = [1 3 5 2 4 6] % select 50% MVC's first, then 25%

    nexttile
    for a = 1:3 % num aponeurosis
        
        % get strains for peak strain index
        s = D(n).(apo{a}).strains(:,D(n).ps_idx);
        
        % get y delta (peak strain vs frame 1) for point at top of image
        ydel = D(n).(apo{a}).ys(12,D(n).ps_idx) - D(n).(apo{a}).ys(12,1);
        
        % select original (first) frame data
        og_x = D(n).(apo{a}).xs(:,1) - 80; % 80 pix x offset to center data
        og_y = D(n).(apo{a}).ys(:,1);
        
        % select peak strain frame data
        ps_x = D(n).(apo{a}).xs(:,D(n).ps_idx) - 40; % 40 pix x offset
        ps_y = D(n).(apo{a}).ys(:,D(n).ps_idx) - ydel; % 
        
        for p = 1:11 % num points
            % set defaults
            style = '.-k';
            width = 0.5;
            
            % determine if longer or shorter
            if s(p) < -0.001
                style = '.:k';
            elseif s(p) > 0.001
                width = 1.5;
            end

            % plot
            plot(og_x(p:p+1), og_y(p:p+1),'.-k','LineWidth',0.5,'MarkerSize',8)
            hold on
            plot(ps_x(p:p+1), ps_y(p:p+1),style,'LineWidth',width,'MarkerSize',8)
            hold on
        end
    end
    
    % plot formating
    axis off
    axis tight
    set(gca,'YDir','reverse')
    title(D(n).ID)
    xlim([0 100])
    
end

end



function apo_gif(D)

dt = .075; %delay time
num_frames = size(D(1).M,3);

filename = [D(1).ID(1:9),' apo animation.gif'];

axis off
axis tight
for fr = 1:num_frames
    k=1;
    for n = [1 3 5 2 4 6] % select 50% MVC's first
        
        % create image with fibers
        imshow(D(n).M(:,:,fr),[]);
        hold on
        plot(D(n).sl.xs(:,fr), D(n).sl.ys(:,fr),'.-w'...
            ,D(n).dp.xs(:,fr), D(n).dp.ys(:,fr),'.-w'...
            ,D(n).sp.xs(:,fr), D(n).sp.ys(:,fr),'.-w')
        text(0, 245, D(n).ID, 'Color', 'w');
        
        % store image
        temp_im = frame2im(getframe(gcf));
        ims(:,:,k) = temp_im(:,:,1);
        k=k+1;
    end
    
    %Write to the GIF File
    if fr == 1
        imwrite(imtile(ims),filename,'gif','Loopcount',inf);
    else
        imwrite(imtile(ims),filename,'gif','WriteMode','append','DelayTime',dt);
    end
    
end
close
end

