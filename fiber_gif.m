function fiber_gif(data)
%FIBER_GIF saves .gif animation of fiber motion from dynamic MRI images

dt = .075; %delay time
num_frames = size(data(1).M,3);

filename = [data(1).ID(1:9),' animation.gif'];

axis off
axis tight
for f = 1:num_frames
    k=1;
    for n = [1 3 5 2 4 6] % select 50% MVC's first
        
        % create image with fibers
        imshow(data(n).M(:,:,f),[]);
        hold on
        for j = [1 3 5]
            plot(data(n).xs(j:j+1,f),data(n).ys(j:j+1,f),'-w','LineWidth',1)
        end
        text(0, 245, data(n).ID(11:end), 'Color', 'w');
        
        % store image
        temp_im = frame2im(getframe(gcf));
        ims(:,:,k) = temp_im(:,:,1);
        k=k+1;
    end
    
    %Write to the GIF File
    if f == 1
        imwrite(imtile(ims),filename,'gif','Loopcount',inf);
    else
        imwrite(imtile(ims),filename,'gif','WriteMode','append','DelayTime',dt);
    end
    
end

