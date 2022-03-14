clc
clear vars
clear all
close all
p1 = 0.9;
p2 = 0.5;
%
folder = 'outputsEx4_2';
%==========================================================================
%AS-HRT
iter1 = [];
for n = 1000:1000:10000
    f_iter = [];
    for m = 0.02*n:0.01*n:0.04*n
        %load to file for averaging results
        filename = [folder,'\APX(',num2str(n),',',num2str(m),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        f_iter(end+1) = mean(f_results(:,4));
    end
    iter1 = [iter1;f_iter];
end
%==========================================================================
%for HS-HRT
iter2 = [];
for n = 1000:1000:10000
    f_iter = [];
    for m = 0.02*n:0.01*n:0.04*n
        %load to file for averaging results
        filename = [folder,'\HAG(',num2str(n),',',num2str(m),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];                     load(filename,'f_results');
        load(filename,'f_results');
        f_iter(end+1) = mean(f_results(:,4));
    end
    iter2 = [iter2;f_iter];
end
%==========================================================================
%for plot figures
APX_plot_data = iter1';
HAG_plot_data = iter2';
% data_np1 = mean((iter1),2);
% data_np2 = mean((iter2),2);
%
%create a figure (left,top,width,height) 
figure('position',[100, 100, 1000, 550]); 
set(axes, 'Units', 'pixels', 'Position', [110, 80, 550, 370]);
hold on
%for AS-HRT
APX_line1 = plot(APX_plot_data(1,:),'--bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line2 = plot(APX_plot_data(2,:),'--b>','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line3 = plot(APX_plot_data(3,:),'--b^','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line4 = plot(data_np1(4,:),'-bo','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);

%
%for HS-HRT
HAG_line1 = plot(HAG_plot_data(1,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line2 = plot(HAG_plot_data(2,:),'--r>','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line3 = plot(HAG_plot_data(3,:),'--r^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line4 = plot(HAG_plot_data(4,:),'--bo','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);

%=========================================================================
hand = legend([HAG_line1,HAG_line2,HAG_line3,APX_line1,APX_line2,APX_line3],...
       'HAG {\it p_1} = 0.02n{     }','HAG {\it p_1} = 0.03n','HAG {\it p_1} = 0.04n',...
       'APX{\it p_1} = 0.02n{     }','APX {\it p_1} = 0.03n','APX {\it p_1} = 0.04n'); 
% hand = legend([HAG_line1,HAG_line2,HAG_line3,HAG_line4,APX_line1,APX_line2,APX_line3,APX_line4],...
%         'HAG {\it p_1} = 0.81{     }','HAG {\it p_1} = 0.82{     }','HAG {\it p_1} = 0.83','HAG {\it p_1} = 0.84',...
%         'APX {\it p_1} = 0.81{     }','APX{\it p_1} = 0.82{     }','APX {\it p_1} = 0.83','APX {\it p_1} = 0.84'); 
%  hand = legend([HAG_line1,HAG_line2,HAG_line3,HAG_line4,APX_line1,APX_line2,APX_line3,APX_line4],...
%        'HAG {\it p_1} = 0.85{     }','HAG {\it p_1} = 0.86{     }','HAG {\it p_1} = 0.87','HAG {\it p_1} = 0.88',...
%        'APX{\it p_1} = 0.85{     }','APX{\it p_1} = 0.86{     }','APX {\it p_1} = 0.87','APX {\it p_1} = 0.88');  
%for layout of figure
 set(hand,'FontSize',17,'Position',[0.0 0.83 0.95 0.17],'Orientation','horizontal','NumColumns',3);   
legend('boxoff')
set(gcf,'color','w');
xlim([1 10]);
xticks(1:10);
xticklabels({'1000','2000','3000','4000','5000','6000','7000','8000','9000','10000'})
%
hx = xlabel('{\it n}','color','k');
set(hx, 'FontSize', 17)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',17)
%
% ylim([200,300]);
% yticks(200:10:300);
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
