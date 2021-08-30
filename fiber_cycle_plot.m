function fiber_cycle_plot(results, force, fse, fibers, plot_title)
%FIBER_RESULT_PLOT plots mean force, strain, length & angle vs motion cycle
%   plots mean force, fiber strain, length, & angle for proximal,
%   middle, and distal fibers.

% variables
data(:,:,3) = results.lengths;
data(:,:,2) = results.angles;
data(:,:,1) = results.strains;

num_frames = length(data(:,:,1));
results_pct = 0:100/(num_frames - 1):100;

force = force(1:round(.8 * length(force))); % use 80% of force data
force_pct = 100 * (1:length(force)) / length(force);

ylabels = ["Strain", "Angle from +y axis (deg)", "Length (pixels)"];
reg_colors = 'ryg';
reg_key = 'pmd';


plotFig = figure;
% cycle plots
for j = 3:-1:1
    
    % create cycle plots
    subplot(2,2,j)
    yyaxis left
    plot(force_pct, force, 'w')
    ylabel('Force (N)')
    yyaxis right
    plot(results_pct, data(1,:,j), ['-',reg_colors(1)],...
         results_pct, data(2,:,j), ['-',reg_colors(2)],...
         results_pct, data(3,:,j), ['-',reg_colors(3)])
    xlabel('Cycle (%)')
    ylabel(char(ylabels(j)))
    ax = gca;
    ax.Color = 'k';
    ax.XColor = 'w';
    ax.YAxis(1).Color = 'w';
    ax.YAxis(2).Color = 'w';
    set(gcf,'Color','k')
end

% fiber image
subplot(2,2,4)
axis off
imshow(fse.image,[]);
hold on
for r = 1:3
    plot(fibers(2*r-1:2*r,1), fibers(2*r-1:2*r,2) ,['-',reg_colors(r)])
end
sgtitle(["\color{white}" + plot_title, "\color{white} Force, \color{red} Proximal, \color{yellow} Middle, \color{green} Distal"])

set(gcf, 'InvertHardCopy', 'off'); % setting 'grid color reset' off
saveas(plotFig, [char(plot_title),' plots.png'])
end

