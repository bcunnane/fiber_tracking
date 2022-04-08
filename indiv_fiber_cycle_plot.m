function indiv_fiber_cycle_plot(data)
%FIBER_CYCLE_PLOT gerenates plots over contraction cycle for
% foot positions: D = dorsiflextion, N = neutral, P = plantar flexion
% fibers: pr = proximal (red), mi = middle (green), di = distal (blue)

posn = 'DDNNPP';
x = 0:(100/21):100; % converting frames to % of cycle

for mvc = 1:2
    n = 1;
    f = figure;
    f.Position = [400 100 700 600];
    name = [data(mvc).ID(1:9),' ',data(mvc).ID(end-5:end)];
    sgtitle(name)
    for j = mvc:2:6
        
        % plot delta angle
        subplot(3,3,n)
        plot(x, data(j).del_angles(1,:),'-r'...
            ,x, data(j).del_angles(2,:),'-g'...
            ,x, data(j).del_angles(3,:),'-b')
        title(posn(j))
        xlabel('% Contraction cycle')
        ylabel('\Delta Fiber angle (deg)')
        ylim([-5 10])
        
        % plot delta length
        subplot(3,3,n+1)
        plot(x, data(j).del_lengths(1,:),'-r'...
            ,x, data(j).del_lengths(2,:),'-g'...
            ,x, data(j).del_lengths(3,:),'-b')
        title(posn(j))
        xlabel('% Contraction cycle')
        ylabel('\Delta Fiber length (mm)')
        ylim([-15 5])
        
        % plot strain
        subplot(3,3,n+2)
        plot(x, data(j).strains(1,:),'-r'...
            ,x, data(j).strains(2,:),'-g'...
            ,x, data(j).strains(3,:),'-b')
        title(posn(j))
        xlabel('% Contraction cycle')
        ylabel('Fiber strain')
        ylim([-.5 .1])
        
        n = n+3;
        
    end
    
    subplot(3,3,1)
    legend('Pr','Mi','Di','Location','best')
    saveas(gcf, [name,' indiv fiber plots.png'])
end

end