%% main_apo_analysis
% analysis of medial gastrocnemius (MG) and soleus aponeurosis (apo)
% sl = soleus apo, dp = MG deep apo, sp = MG superficial apo
% uses data structure created from main_apo_processing

%% Individual subject Analysis
% for n = 1:6:length(data)
%     
% %     strain_dist_plot(data(n:n+5))
% %     exportgraphics(gcf,[data(n).ID, ' strain dist plots.png'])
% %     close
%     
%     strain_dist_model(data(n:n+5))
% %     exportgraphics(gcf,[data(n).ID, ' strain dist model.png'])
% %     saveas(gcf,'Figure 4a.png')
% %     saveas(gcf,'Figure 4a','epsc')
%     
%     
% %     apo_gif(data(n:n+5))
% end

%% Averaged subject analysis
for n = 1:6
    % create temporary data sructures
    temp = data(n:6:end);
    sl = [temp.sl];
    dp = [temp.dp];
    sp = [temp.sp];
    
    % average segments together
    aves(n).ID = ['DataMeans-', temp(1).ID(11:end)];
    aves(n).ps_idx = round(mean([temp.ps_idx]));
    aves(n).sl.strains = mean(cat(3,sl.strains), 3);
    aves(n).dp.strains = mean(cat(3,dp.strains), 3);
    aves(n).sp.strains = mean(cat(3,sp.strains), 3);
    
end
% plot average results
strain_dist_bar(aves)
saveas(gcf,'Figure 4b.png')
saveas(gcf,'Figure 4b','epsc')


%% Statistics

% data setup
apo = ['sl';'dp';'sp'];
anova = table;
anova.vars = {'%mvc';'posn';'seg'};
str.sl = [];
str.dp = [];
str.sp = [];
pct_mvc = repmat([repmat(50,11,1);repmat(25,11,1)],18,1);
posn = repmat([repmat('D',22,1); repmat('N',22,1); repmat('P',22,1)],6,1);
seg = repmat((1:11)',36,1);
for n = 1:length(data)
    str.sl = [str.sl; data(n).sl.strains(:,data(n).ps_idx)];
    str.dp = [str.dp; data(n).dp.strains(:,data(n).ps_idx)];
    str.sp = [str.sp; data(n).sp.strains(:,data(n).ps_idx)];
end

% ANOVA
for a = 1:3
    anova.(apo(a,:)) = anovan(str.(apo(a,:)),{pct_mvc,posn,seg}...
        ,'varnames',{'%mvc','posn','seg'},'display','off');
end

% paired t-tests
ttable = table;
ttable.seg = (1:11)';
for a = 1:3
    for s = 1:11
        [~, ttable.([apo(a,:),'_DN'])(s)] = ttest(str.(apo(a,:))(seg==s & posn=='D'), str.(apo(a,:))(seg==s & posn=='N'));
        [~, ttable.([apo(a,:),'_NP'])(s)] = ttest(str.(apo(a,:))(seg==s & posn=='N'), str.(apo(a,:))(seg==s & posn=='P'));
        [~, ttable.([apo(a,:),'_DP'])(s)] = ttest(str.(apo(a,:))(seg==s & posn=='D'), str.(apo(a,:))(seg==s & posn=='P'));
    end
end
%% functions

function strain_dist_bar(D)
% displays the strain in each aponeurosis (apo) segment at the frame of 
% peak strain as a vertical bar graph

figure('Position',[300 100 880 660]);
tiledlayout(2,3,'TileSpacing','compact', 'Padding', 'compact')
for n = [1 3 5 2 4 6] % select 50% MVC's first, then 25%
    
    % arrange strain data at peak contraction for bar chart
    y = [D(n).sl.strains(:,D(n).ps_idx)...
        ,D(n).dp.strains(:,D(n).ps_idx)...
        ,D(n).sp.strains(:,D(n).ps_idx)];
    y = flip(y,1); % distal at top of matrix, proximal at bottom
    
    % create chart
    nexttile
    b = barh(y,'hist');
    b(1).FaceColor = 'r';
    b(2).FaceColor = 'g';
    b(3).FaceColor = 'b';
    title(D(n).ID(11:end))
    
    % format plot
    xlabel('Strain')
    ylabel('(Distal)          Segment        (Proximal)')
    yticklabels({'11','10','9','8','7','6','5','4','3','2','1'})
    xlim([-.4 .1])
    if n==1
        legend('Soleus','Deep','Superficial','Location','best')
    end
    
end
end


function strain_dist_model(D)
% side-by-side plot of aponeurosis (apo) at rest and peak strain
% sl = soleus apo, dp = MG deep apo, sp = MG superficial apo

color = 'rgb'; % red = sl, green = dp, blue = sp

figure('Position',[300 100 880 660]);
tiledlayout(2,3,'TileSpacing','compact', 'Padding', 'compact')
for n = [1 3 5 2 4 6] % select 50% MVC's first, then 25%
    
    % select data
    ps_idx = D(n).ps_idx;
    rs_x = [D(n).sl.xs(:,1), D(n).dp.xs(:,1), D(n).sp.xs(:,1)];
    rs_y = [D(n).sl.ys(:,1), D(n).dp.ys(:,1), D(n).sp.ys(:,1)];
    ps_x = [D(n).sl.xs(:,ps_idx), D(n).dp.xs(:,ps_idx), D(n).sp.xs(:,ps_idx)];
    ps_y = [D(n).sl.ys(:,ps_idx), D(n).dp.ys(:,ps_idx), D(n).sp.ys(:,ps_idx)];
    
    % get strains for peak strain index
    peak_strains = [D(n).sl.strains(:,ps_idx), D(n).dp.strains(:,ps_idx), D(n).sp.strains(:,ps_idx)];
        
    % arrange data in plot frame
    x_offset = 7; % pixels between each aponeurosis representation
    rs_x = rs_x - min(rs_x(:));
    ps_x = ps_x - min(ps_x(:)) + max(rs_x(:)) + x_offset;
    rs_y = rs_y - min(rs_y(:));
    ps_y = ps_y - min(ps_y(:));    
    
    nexttile
    for a = 1:3 % aponeurosis (1)sl (2)dp (3)sp
        for p = 1:11 % point number in aponeurosis
            % set default line formatting
            style = ['.-',color(a)];
            width = 0.5;
            
            % plot data at rest
            plot(rs_x(p:p+1,a), rs_y(p:p+1,a),style,'LineWidth',width,'MarkerSize',8)
            hold on
            
            % determine if segment at peak strain is longer or shorter
            if peak_strains(p,a) < -0.001
                width = 1.5;
            elseif peak_strains(p,a) > 0.001
                style = ['.:',color(a)];
            end
            
            % plot data at peak strain
            plot(ps_x(p:p+1,a), ps_y(p:p+1,a),style,'LineWidth',width,'MarkerSize',8)
            hold on
        end
    end
    
    % plot formating
    axis off
    axis tight
    set(gca,'YDir','reverse')
    title(D(n).ID(11:end))
    text(mean(rs_x(:)), max([rs_x(:);rs_y(:)])+10, 'Rest')
    text(mean(ps_x(:)), max([rs_x(:);rs_y(:)])+10, 'Peak')
    
end
%sgtitle(D(n).ID(1:9))
end


function strain_dist_plot(D)
% displays the strain in each aponeurosis (apo) segment at the frame of 
% peak strain

x = 1:11;

figure('Position',[300 100 880 660]);
tiledlayout(2,3,'TileSpacing','compact', 'Padding', 'compact')
for n = [1 3 5 2 4 6] % select 50% MVC's first, then 25%
    
    % create plot
    nexttile
    plot(x, D(n).sl.strains(:,D(n).ps_idx),'.-r'...
        ,x, D(n).dp.strains(:,D(n).ps_idx),'.-g'...
        ,x, D(n).sp.strains(:,D(n).ps_idx),'.-b')
    title(D(n).ID(11:end))
    
    % annotate plot
    xlim([0 12])
    ylim([-.4 .2])
    xlabel('Segment')
    ylabel('Strain')
    if n==1
        legend('Soleus','Deep','Superficial','Location','southeast')
    end
    
end
%sgtitle([D(n).ID(1:9), ' at peak strain'])
end


function apo_gif(D)
% creates cine gif of aponeurosis (apo) point motion through contraction

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
        text(0, 245, D(n).ID(11:end), 'Color', 'w');
        
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

