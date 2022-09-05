
% show base image
% im = imread(['C:\Users\Brandon\Google Drive\research\fiber_tracking',...
%     '\paper\archive\figure 5 edited.png']);
f = figure;
imshow(im)
hold on

% at rest markers
plot(259,204,'ok','MarkerSize',7,'MarkerFaceColor','k') %D
plot(180,321,'sk','MarkerSize',8,'MarkerFaceColor','k') %N
plot(165,365,'Dk','MarkerSize',7,'MarkerFaceColor','k') %P

% peak contraction markers
plot(198,268,'or','MarkerSize',7,'MarkerFaceColor','r') %D
plot(116,510,'sr','MarkerSize',8,'MarkerFaceColor','r') %N
plot(100,558,'Dr','MarkerSize',7,'MarkerFaceColor','r') %P

% format and save
legend('D - Rest','N - Rest','P - Rest','D - Peak','N - Peak','P - Peak')
saveas(gcf,'Figure 5.png')
saveas(gcf,'Figure 5','epsc')