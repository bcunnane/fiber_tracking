function fiber_cycle_plot(data)
%FIBER_CYCLE_PLOT gerenates plots over contraction cycle for
% foot positions: D = dorsiflextion, N = neutral, P = plantar flexion
% data for proximal, middle, and distal fibers is averaged

% average results for proximal, middle, and distal fibers
for j = length(data):-1:1
    del_lens(j,:) = mean(data(j).del_lengths);
    del_angs(j,:) = mean(data(j).del_angles);
    strains(j,:) = mean(data(j).strains);
end

% generate plots
n = 1;
f = figure;
f.Position = [400 100 700 600];
x = 0:(100/21):100; % converting frames to % of cycle
posn = 'D N P';
for j = [1 3 5]
    
    % plot delta angle
    subplot(3,3,n)
    plot(x, del_angs(j,:), x, del_angs(j+1,:))
    title(posn(j))
    xlabel('% Contraction cycle')
    ylabel('\Delta Fiber angle (deg)')
    ylim([-5 10])
    
    % plot delta length
    subplot(3,3,n+1)
    plot(x, del_lens(j,:), x, del_lens(j+1,:))
    title(posn(j))
    xlabel('% Contraction cycle')
    ylabel('\Delta Fiber length (mm)')
    ylim([-15 5])
    
    % plot strain
    subplot(3,3,n+2)
    plot(x, strains(j,:), x, strains(j+1,:))
    title(posn(j))
    xlabel('% Contraction cycle')
    ylabel('Fiber strain')
    ylim([-.5 .1])
    
    n = n+3;
    
end

subplot(3,3,1)
legend('50% MVC','25% MVC','Location','best')

end