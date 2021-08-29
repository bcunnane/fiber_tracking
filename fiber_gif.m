function fiber_gif(dynamic_mag, xs, ys, gif_title)
%FIBER_GIF saves .gif animation of fiber motion from dynamic MRI images

dt = .05; %delay time
num_frames = size(dynamic_mag,3);

gif_title = char(gif_title);
filename = [gif_title,' animation.gif'];

fig = figure;
axis tight
for f = 1:num_frames
    
    % get image frame with fibers
    fiber_show(dynamic_mag(:,:,f), xs(:,f), ys(:,f));
    text(0, 245, gif_title, 'Color', 'w');
    im = frame2im(getframe(fig));
    [im,map] = rgb2ind(im,256);
    
    % Write to the GIF File
    if f == 1
        imwrite(im,map,filename,'gif','Loopcount',inf);
    else
        imwrite(im,map,filename,'gif','WriteMode','append','DelayTime',dt);
    end
end

end

