clc
clear vars
clear all
close all
n = 10000;
%experiment 1 (test1) and experiment 2 (test2)
folder = 'outputsEx5_1';
%==========================================================================
%AS algorithm
time1 = [];
for p1 = 0.95:0.01:0.99
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = [folder,'\APX(',num2str(n),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    time1 = [time1;f_avg_time];
end
%==========================================================================
%for HS-HRT
time2 = [];
for p1 = 0.95:0.01:0.99
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = [folder,'\HAG(',num2str(n),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    time2 = [time2;f_avg_time];
end
%==========================================================================
%Percentage of perfect matchings
data_np1 = log10(time1);
data_np2 = log10(time2);
% data_np1 = mean((time1),2);
% data_np2 = mean((time2),2);
%
%create a figure (left,top,width,height) 5
figure('position',[100, 100, 1000, 550]); 
set(axes, 'Units', 'pixels', 'Position', [100 85 736 465]);
hold on

%---------------------------------------------------------------
[P2,P1] = meshgrid([0.0:0.1:1.0],[0.95:0.01:0.99]);
h1= surf(P2,P1,data_np1,'facealpha',0.5);
h2 = surf(P2,P1,data_np2,'facealpha',0.9);
legend([h1,h2], {'APX', 'HAG'});
%
set(gcf,'color','w');
xticks(0.0:0.1:1.0);
yticks(0.95:0.01:0.99);
%
hx = xlabel('{\it p_2}','color','k');
set(hx, 'FontSize', 17)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',17)
%
hy = ylabel('{\it p_1}','color','k');
set(hy, 'FontSize', 17)
hxb = get(gca,'YTickLabel');
set(gca,'YTickLabel',hxb,'fontsize',17)
%
 hz = zlabel('Average execution time (log_{10}sec.)','color','k');
 set(hz,'FontSize',17)
%
grid on
ax = gca;
set(ax,'GridLineStyle','--') 
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.4;
box on
%}