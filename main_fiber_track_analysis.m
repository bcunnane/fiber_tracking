%% Fiber Track Analysis
% Main analysis script for foot position fiber tracking experiment
% assumes there are 2 points per fiber

%load(all_data.mat)
fields = {'peak_strain','str_per_force','str_per_torque',...
    'init_ang','final_ang','init_len','final_len'}';
%% Calculations
pix_spacing = 1.1719; %pixel spacing, to convert to mm

for k = length(data):-1:1
    
    % fiber tracking raw calcs
    dxs = data(k).xs(2:2:end,:) - data(k).xs(1:2:end,:);
    dys = data(k).ys(2:2:end,:) - data(k).ys(1:2:end,:);
    data(k).lengths = sqrt(dxs.^2 + dys.^2) * pix_spacing;
    data(k).angles = acosd(abs(dys ./ data(k).lengths)); %to +Y axis
    data(k).del_lengths = data(k).lengths - data(k).lengths(:,1);
    data(k).del_angles = data(k).angles - data(k).angles(:,1);
    data(k).strains = data(k).del_lengths ./ data(k).lengths(:,1);
    
    % extract desired result values
    data(k).mvc_torque = data(k).MVC * data(k).ma * 0.001; %Nm
    data(k).peak_force = max(data(k).mean);
    data(k).peak_torque = data(k).peak_force * data(k).ma * 0.001; %Nm
    [data(k).peak_strain, data(k).ps_idx] = min(data(k).strains,[],2);
    data(k).str_per_force = data(k).peak_strain / data(k).peak_force;
    data(k).str_per_torque = data(k).peak_strain / data(k).peak_torque;
    
    data(k).init_ang = data(k).angles(:,1);
    data(k).init_len = data(k).lengths(:,1);
    for fbr = 1:3 %cycle through the 3 fibers
        data(k).final_ang(fbr,1) = data(k).angles(fbr, data(k).ps_idx(fbr,1));
        data(k).final_len(fbr,1) = data(k).lengths(fbr, data(k).ps_idx(fbr,1));
    end
    
end
%% Tables accross all subjects
% Mean (mu) & Std (sigma); Median (med) and Interquartile Range (iq_rge)

% build table framework
norm_fields = cat(1,{'MVC';'mvc_torque';'peak_force';'peak_torque'},fields(1:3));
non_norm_fields = fields(4:7);
tbl_1a = table;
tbl_1a.posn = ['D';'D';'N';'N';'P';'P'];
tbl_1a.pctMVC = ['50%';'25%';'50%';'25%';'50%';'25%'];
tbl_2 = tbl_1a;
tbl_1b.posn = ['D';'D';'D';'D';'D';'D';'N';'N';'N';'N';'N';'N';'P';'P';'P';'P';'P';'P'];
tbl_1b.pctMVC = [];


% fill in normal table
for k = 1:6
    for f = 1:length(norm_fields)
        % collect data for all subjects at foot posn and %MVC
        field_data = cat(1,data(k:6:end).(norm_fields{f}));
        
        % calculate stats
        mu = mean(field_data);
        sigma = std(field_data);
        
        % set decimal precision
        if ismember(f,1:4)
            p = '1';
        elseif ismember(f,5:7)
            p = '4';
        end
        
        % fill table
        cell_data = sprintf(['%.',p,'f[%.',p,'f]'],mu,sigma);
        tbl_1a.(norm_fields{f})(k) = string(cell_data);
    end
end

% fill in non-normal data table
for k = 1:6
    for f = 1:length(non_norm_fields)
        % collect data for all subjects at foot posn and %MVC
        field_data = cat(1,data(k:6:end).(non_norm_fields{f}));
        
        % calculate stats
        med = median(field_data);
        iq_rge = iqr(field_data);

        % fill table
        cell_data = sprintf('%.1f[%.1f]',med,iq_rge);
        tbl_2.(non_norm_fields{f})(k) = string(cell_data);
    end
end
% writetable(tbl_1a,'table 1a.xlsx')
% writetable(tbl_1b,'table 1b.xlsx')

%% Contraction Plots
% generate gifs
% for k = 25%1:6:length(data)
%     fiber_gif(data(k:k+5))
%     close
% end

% generate mean fiber cycle plots
% for k = 31%1:6:length(data)
%     fiber_cycle_plot(data(k:k+5));
%     %saveas(gcf, [data(1).ID(1:9),' plots.png'])
%     saveas(gcf,'Figure 3.png')
%     saveas(gcf,'Figure 3','epsc')
%     
% end
%% Stats setup
pct_mvc = repmat({'50';'50';'50';'25';'25';'25'},18,1);
posn = repmat('DDDDDDNNNNNNPPPPPP',1,6)';
fiber = repmat({'Pr';'Mi';'Di'},36,1);

%% Stats normality check

% shapiro-wilks test setup
sw = table;
sw.n = {'D50';'N50';'P50';'D25';'N25';'P25'};
for k=1:length(fields)
    
    % select all data
    field_data = cat(1,data.(fields{k}));
    
    % analyze by %MVC and ankle angles
    f = figure;
    f.Position = [300 100 980 660];
    tiledlayout(2,3)
    for j = 1:6
        % select %MVC and ankle angle data
        case_idx = (posn == sw.n{j}(1)) & ismember(pct_mvc,sw.n{j}(2:3));
        
        % shapiro-wilks test
        [~,sw.(fields{k})(j),~] = swtest(field_data(case_idx),.05);
        
        % qq-plots
        nexttile
        qqplot(field_data(case_idx))
        title(sw.n{j})
    end
    plot_title = [strrep(fields{k},'_',' '), ' qq-plots'];
    sgtitle(plot_title)
%     exportgraphics(gcf, [plot_title,'.png'])
%     close
    
end

%% Stats for normal data
% applies to peak_strain, str_per_force, & str_per_torque

% 3-way anova
p_anova3 = table;
p_anova3.fields = fields(1:3);
for k = 1:length(p_anova3.fields)    
    field_data = cat(1,data.(p_anova3.fields{k}));
    p_vals = anovan(field_data,{pct_mvc,posn,fiber}...
        ,'model','interaction','varnames',{'%mvc','posn','fiber'},'display','off');
    p_anova3.mvc(k) = p_vals(1);
    p_anova3.posn(k) = p_vals(2);
    p_anova3.fiber(k) = p_vals(3);
    p_anova3.mvcXposn(k) = p_vals(4);
    p_anova3.mvcXfiber(k) = p_vals(5);
    p_anova3.posnXfiber(k) = p_vals(6);
end

% P table 2-way anova, paired t-test for posn
p_normal = table;
p_normal.fields = fields(1:3);
for k = 1:length(p_normal.fields)
    
    % 2-way anova
    field_data = cat(1,data.(p_normal.fields{k}));
    p_vals = anovan(field_data,{pct_mvc,posn}...
        ,'model','interaction','varnames',{'%mvc','posn'},'display','off');
    p_normal.mvc(k) = p_vals(1);
    p_normal.posn(k) = p_vals(2);
    p_normal.mvcXposn(k) = p_vals(3);
    
    % paired t-tests for positions 
    [~, p_normal.dn(k)] = ttest(field_data(posn == 'D'), field_data(posn == 'N'));
    [~, p_normal.np(k)] = ttest(field_data(posn == 'N'), field_data(posn == 'P'));
    [~, p_normal.dp(k)] = ttest(field_data(posn == 'D'), field_data(posn == 'P'));

end

%% Stats for non-normal data
% applies to init_ang, final_ang, init_len, & final_len

p_not_norm = table;
p_not_norm.fields = fields(4:7);

case_data = table;
n = {'D50';'N50';'P50';'D25';'N25';'P25'};

for k = 1:length(p_not_norm.fields)
    
    % get data specific to field
    field_data = cat(1,data.(p_not_norm.fields{k}));
    
    % select %MVC and ankle angle data
    for j = 1:6
        case_idx = (posn == n{j}(1)) & ismember(pct_mvc,n{j}(2:3));
        case_data.(n{j}) = field_data(case_idx);
    end
    
    % 25% vs 50% MVC using Mann-Whitney (aka Wilcoxon Rank Sum)
    p_not_norm.MVC_mw(k) = ranksum([case_data.D50; case_data.N50; case_data.P50]...
        ,[case_data.D25; case_data.N25; case_data.P25]);
    
    % combine all ankle angle data (so 50% and 25% together)
    ankle_angs = [case_data{:,1:3}; case_data{:,4:6}]; % (:,1)D (:,2)N (:,3)P
    
    % Ankle angles using Mann-Whitney
    p_not_norm.DN_mw(k) = ranksum(ankle_angs(:,1),ankle_angs(:,2));
    p_not_norm.NP_mw(k) = ranksum(ankle_angs(:,2),ankle_angs(:,3));
    p_not_norm.DP_mw(k) = ranksum(ankle_angs(:,1),ankle_angs(:,3));
    
    % Ankle Angles using Kruskal-Wallis
    p_not_norm.DN_kw(k) = kruskalwallis([ankle_angs(:,1), ankle_angs(:,2)],[],'off');
    p_not_norm.NP_kw(k) = kruskalwallis([ankle_angs(:,2), ankle_angs(:,3)],[],'off');
    p_not_norm.DP_kw(k) = kruskalwallis([ankle_angs(:,1), ankle_angs(:,3)],[],'off');
end


%% Stats for MVC
mvc = [data.MVC];

% sort MVC into (1)D, (2)N, & (3)P
col = 1;
for n = [1,3,5]
    posn_mvc(:, col) = mvc(n:6:end);
    col = col+1;
end

% get means & stds
mvc_stats(1,:) = mean(posn_mvc);
mvc_stats(2,:) = std(posn_mvc);

% paired t tests
[~, p_dn] = ttest(posn_mvc(:,1), posn_mvc(:,2));
[~, p_np] = ttest(posn_mvc(:,2), posn_mvc(:,3));
[~, p_dp] = ttest(posn_mvc(:,1), posn_mvc(:,3));

%% Package data for SPSS
mvc = {'50','25'};
fbr_posn = {'Pr','Mi','Di'};
for f = 1:length(fields)
    
    spss = table;
    
    % select all data for field
    field_data = cat(1,data.(fields{f}));
    
    % separate data by case posiiton, mvc, and fiber location
    for p = 'DNP'
        for m = 1:2
            for k=1:3
                fiber_loc = fbr_posn{k};
                case_idx = (posn == p) & strcmp(pct_mvc, mvc{m}) & strcmp(fiber, fbr_posn{k});
                spss.([p,mvc{m},fbr_posn{k}]) = field_data(case_idx);
            end
        end
    end
    
    % write table for SPSS data analysis
%     writetable(spss,[fields{f},'.xlsx'])
    
end




