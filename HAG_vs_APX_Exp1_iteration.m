clc
clear vars
clear all
close all
n = 100;
%experiment 1 (test1) and experiment 2 (test2)
folder = 'outputsEx1_100';
%==========================================================================
%AS-HRT
iter1 = [];
for p2 = 0.0:0.1:1.0
     f_iter = [];
    for p1 = 0.1:0.1:0.8
        %load to file for averaging results
        filename = [folder,'\APX(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];               
        load(filename,'f_results');
        f_iter(end+1) = mean(f_results(:,4));
    end
    iter1 = [iter1;f_iter];
end
%==========================================================================
%for HS-HRT
iter2 = [];
for p2 = 0.0:0.1:1.0
     f_iter = [];
    for p1 = 0.1:0.1:0.8
        %load to file for averaging results
        filename = [folder,'\HAG(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];  
        load(filename,'f_results');
        f_iter(end+1) = mean(f_results(:,4));
    end
    iter2 = [iter2;f_iter];
end
%==========================================================================
%for plot figures
APX_plot_data = iter1';
HAG_plot_data = iter2';
%
%create a figure (left,top,width,height) 
figure('position',[100, 100, 1000, 550]); 
set(axes, 'Units', 'pixels', 'Position', [90, 80, 550, 370]);
hold on
%for AS-HRT
APX_line1 = plot(APX_plot_data(1,:),'--bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line2 = plot(APX_plot_data(2,:),'--r>','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line3 = plot(APX_plot_data(3,:),'--r^','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line4 = plot(APX_plot_data(4,:),'--ro','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);

%
%for HS-HRT - lines
HAG_line1 = plot(HAG_plot_data(1,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line2 = plot(HAG_plot_data(2,:),'--b>','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line3 = plot(HAG_plot_data(3,:),'--b^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line4 = plot(HAG_plot_data(4,:),'--bo','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);

%=========================================================================
hand = legend([HAG_line1,APX_line1],...
         'HAG {     }','APX {     }'); 
   % hand = legend([HAG_line1,HAG_line2,HAG_line3,HAG_line4,APX_line1,APX_line2,APX_line3,APX_line4],...
%        'HAG {\it p_1} = 0.5{     }','HAG {\it p_1} = 0.6{     }','HAG {\it p_1} = 0.7','HAG {\it p_1} = 0.8',...
%        'APX {\it p_1} = 0.5{     }','APX{\it p_1} = 0.6{     }','APX {\it p_1} = 0.7','APX {\it p_1} = 0.8');
%for layout of figure
set(hand,'FontSize',17,'Position',[0.0 0.83 0.95 0.17],'Orientation','horizontal','NumColumns',2);   
legend('boxoff')
set(gcf,'color','w');
xlim([1 11]);
xticks(1:11);
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'})
%
hx = xlabel('{\it p_2}','color','k');
set(hx, 'FontSize', 17)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',17)
%
% ylim([200,275]);
% yticks(200:15:275);
hy = ylabel('Average number of iterations','color','k');
set(hy,'FontSize',17)
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
