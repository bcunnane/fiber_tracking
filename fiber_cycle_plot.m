function fiber_cycle_plot(data)
%FIBER_CYCLE_PLOT gerenates plots over contraction cycle for
% foot positions: D = dorsiflextion, N = neutral, P = plantar flexion

% calculate changes from initial values
for j = length(data):-1:1
    lengths(j,:) = data(j).lengths - data(j).lengths(1);
    angles(j,:) = data(j).angles - data(j).angles(1);
end

% generate plots
n = 1;
f = figure;
f.Position = [400 200 700 600];
x = 0:(100/21):100; % converting frames to % of cycle
posn = 'D N P';
for j = [1 3 5]
    
    % delta angle
    subplot(3,3,n)
    plot(x,angles(j,:), x,angles(j+1,:))
    title(posn(j))
    xlabel('% Contraction cycle')
    ylabel('\Delta Fiber angle (deg)')
    ylim([-5 10])
    
    % delta length
    subplot(3,3,n+1)
    plot(x,lengths(j,:), x,lengths(j+1,:))
    title(posn(j))
    xlabel('% Contraction cycle')
    ylabel('\Delta Fiber length (mm)')
    ylim([-15 5])
    
    % strain
    subplot(3,3,n+2)
    plot(x,data(j).strains, x,data(j+1).strains)
    title(posn(j))
    xlabel('% Contraction cycle')
    ylabel('Fiber strain')
    ylim([-.5 .1])
    
    n = n+3;
    
end

subplot(3,3,1)
legend('50% MVC','25% MVC','Location','southeast')

saveas(gcf, [data(1).ID(1:9),' plots.png'])
end