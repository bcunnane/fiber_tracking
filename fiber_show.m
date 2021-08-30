function fiber_show(image, xs, ys)
%FIBER_SHOW plots muscle fiber x & y coords on MRI image

PPF = 2; %points per fiber

axis off
imshow(image,[]);
hold on
for j = 1:PPF:length(xs)-1
    plot(xs(j:j+1),ys(j:j+1),'-y')
end

end

