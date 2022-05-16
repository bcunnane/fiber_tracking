%% main_apo_analysis

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


tiledlayout(2,3)
for n = [1 3 5 2 4 6] % select 50% MVC's first
    
    % assumes points are bottom to top
    ydel(3) = D(n).sp.ys(12,D(n).ps_idx) - D(n).sp.ys(12,1);
    ydel(2) = D(n).dp.ys(12,D(n).ps_idx) - D(n).dp.ys(12,1);
    ydel(1) = D(n).sl.ys(12,D(n).ps_idx) - D(n).sl.ys(12,1);
    
    nexttile
    plot(D(n).sl.xs(:,1)-80, D(n).sl.ys(:,1),'.-k'...
        ,D(n).dp.xs(:,1)-80, D(n).dp.ys(:,1),'.-k'...
        ,D(n).sp.xs(:,1)-80, D(n).sp.ys(:,1),'.-k'...
        ,D(n).sl.xs(:,D(n).ps_idx)-40, D(n).sl.ys(:,D(n).ps_idx)-ydel(1),'.-b'...
        ,D(n).dp.xs(:,D(n).ps_idx)-40, D(n).dp.ys(:,D(n).ps_idx)-ydel(2),'.-b'...
        ,D(n).sp.xs(:,D(n).ps_idx)-40, D(n).sp.ys(:,D(n).ps_idx)-ydel(3),'.-b')
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

