load('abstract_data_2.mat')

x = 0:100/21:100;
pixel_spacing = 1.1719;
for j = 1:length(data)
    data(j).lengths = data(j).lengths * pixel_spacing;
end

% DNP on same graph
subplot(2,3,1)
plot(x,mean(data(1).angles),x,mean(data(3).angles),x,mean(data(5).angles))
xlabel('% Contraction cycle')
ylabel('Fiber angle from +y axis (deg)')
title('45% MVC')

subplot(2,3,2)
plot(x,mean(data(1).lengths),x,mean(data(3).lengths),x,mean(data(5).lengths))
xlabel('% Contraction cycle')
ylabel('Fiber length (mm)')
title('45% MVC')


subplot(2,3,3)
plot(x,mean(data(1).strains),x,mean(data(3).strains),x,mean(data(5).strains))
xlabel('% Contraction cycle')
ylabel('Strain')
title('45% MVC')

subplot(2,3,4)
plot(x,mean(data(2).angles),x,mean(data(4).angles),x,mean(data(6).angles))
xlabel('% Contraction cycle')
ylabel('Fiber angle from +y axis (deg)')
title('25% MVC')

subplot(2,3,5)
plot(x,mean(data(2).lengths),x,mean(data(4).lengths),x,mean(data(6).lengths))
xlabel('% Contraction cycle')
ylabel('Fiber length (mm)')
title('25% MVC')


subplot(2,3,6)
plot(x,mean(data(2).strains),x,mean(data(4).strains),x,mean(data(6).strains))
xlabel('% Contraction cycle')
ylabel('Strain')
title('25% MVC')


legend('D','N','P')