clc
clear vars
clear all
close all
n = 100;
%experiment 1 (test1) and experiment 2 (test2)
folder = 'outputsEx1_100';
%==========================================================================
%AS algorithm
time1 = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = [folder,'\APX(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    time1 = [time1;f_avg_time];
end
%==========================================================================
%for HS-HRT
time2 = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = [folder,'\HAG(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    time2 = [time2;f_avg_time];
end
%==========================================================================
%execution time
data_np1 = log10(mean(time1));
data_np2 = log10(mean(time2));
%
%create a figure (left,top,width,height) 
figure('position',[100, 100, 1000, 550]); 
set(axes, 'Units', 'pixels', 'Position', [100, 80, 550, 370]);
hold on
%for AS-HRT
APX_line1 = plot(data_np1(1,:),'--bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line2 = plot(data_np1(2,:),'-b>','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line3 = plot(data_np1(3,:),'-b^','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line4 = plot(data_np1(4,:),'-bo','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);

%
%for HS-HRT
HAG_line1 = plot(data_np2(1,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line2 = plot(data_np2(2,:),'-r>','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line3 = plot(data_np2(3,:),'-r^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line4 = plot(data_np2(4,:),'--ro','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);

%=========================================================================
%

  hand = legend([HAG_line1,APX_line1],...
         'HAG {     }','APX {     }');      
% hand = legend([HAG_line1,HAG_line2,HAG_line3,APX_line1,APX_line2,APX_line3],...
%        'HAG {\it p_1} = 0.6{     }','HAG {\it p_1} = 0.7','HAG {\it p_1} = 0.8',...
%        'APX{\it p_1} = 0.6{     }','APX {\it p_1} = 0.7','APX {\it p_1} = 0.8');     

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
% ylim([-3 -2.6]);
% yticks(-3:0.1:-2.6);
hy = ylabel('Average execution time (log_{10}sec.)','color','k');
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