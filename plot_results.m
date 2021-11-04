% plots averaged subject data for ISMRM abstracts

% data = readtable('BC-RH average data.xlsx');


x = data.nominal_pct_MVC;
plot_colors = {'red','black','blue'};
%plot_colors = ['#0072BD';'#D95319';'#EDB120'];
var_names = ["Position","% MVC","MVC (N)","Peak Force (N)",...
    "Peak Torque (Nm)","Initial Angle (deg)","Delta Angle (deg)",...
    "Initial Length (mm)","Delta Length (mm)","Peak Strain",...
    "Strain per Force (N^-1)","Strain per Torque (Nm^-1)"];

series = 'DNP';

for k = [3 6:12]
    
    % create plot
    y = abs(data{:,k});
    pt = plot(x(1:2),y(1:2),x(3:4),y(3:4),x(5:6),y(5:6));
    
    % format plot
    for s = 1:3
        pt(s).Marker = '.';
        pt(s).MarkerSize = 10;
        pt(s).LineStyle = '-';
        pt(s).Color = plot_colors{s};
    end
    xlim([0 .6])
    ylim([0 1.25*max(y)])
    xlabel(var_names(2))
    ylabel(var_names(k))
    
    % add trendline equations
    tlines = '';
    for s = 1:3
        coeffs(s,:) = polyfit(x(2*s-1:2*s),y(2*s-1:2*s),1);
        coeffs(s,:) = round(coeffs(s,:),4);
        tlines = [tlines,'\color{',plot_colors{s},'}',...
            series(s),'    y = ',num2str(coeffs(s,1)),'x + ',num2str(coeffs(s,2)),newline];
    end   
    text(0.05,.1*max(y),tlines)
    
    % save
    exportgraphics(gcf,[char(var_names(k)),' plot.png'])
end