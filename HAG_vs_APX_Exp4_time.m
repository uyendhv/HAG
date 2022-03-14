clc
clear vars
clear all
close all
% n = 200;
p1 = 0.9;
p2 = 0.5;
%experiment 1 (test1) and experiment 2 (test2)
folder = 'outputsEx4_2';
%==========================================================================
%AS algorithm
time1 = [];
for n = 1000:1000:10000
    f_avg_time = [];
    for m = 0.02*n:0.01*n:0.04*n
        %load to file for averaging results
        filename = [folder,'\APX(',num2str(n),',',num2str(m),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    time1 = [time1;f_avg_time];
end
%==========================================================================
%for HS-HRT
time2 = [];
for n = 1000:1000:10000
    f_avg_time = [];
    for m = 0.02*n:0.01*n:0.04*n
        %load to file for averaging results
        filename = [folder,'\HAG(',num2str(n),',',num2str(m),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    time2 = [time2;f_avg_time];
end
%==========================================================================
%execution time
data_np1 = log10(time1)';
data_np2 = log10(time2)';
%
%create a figure (left,top,width,height) 
figure('position',[100, 100, 1000, 550]); 
set(axes, 'Units', 'pixels', 'Position', [90, 80, 550, 370]);
hold on
%for AS-HRT
APX_line1 = plot(data_np1(1,:),'--bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line2 = plot(data_np1(2,:),'--b>','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line3 = plot(data_np1(3,:),'--b^','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line4 = plot(data_np1(4,:),'-bo','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);

%
%for HS-HRT
HAG_line1 = plot(data_np2(1,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line2 = plot(data_np2(2,:),'--r>','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line3 = plot(data_np2(3,:),'--r^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line4 = plot(data_np2(4,:),'--ro','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);

%=========================================================================
%
%   hand = legend([HAG_line1,APX_line1],...
%          'HAG {     }','APX {     }');      
hand = legend([HAG_line1,HAG_line2,HAG_line3,APX_line1,APX_line2,APX_line3],...
       'HAG {\it m} = 0.02n{     }','HAG {\it m} = 0.03n','HAG {\it m} = 0.04n',...
       'APX{\it m} = 0.02n{     }','APX {\it m} = 0.03n','APX {\it m} = 0.04n'); 
   %for layout of figure
set(hand,'FontSize',17,'Position',[0.0 0.83 0.95 0.17],'Orientation','horizontal','NumColumns',3);   
legend('boxoff')
set(gcf,'color','w');
xlim([1 10]);
xticks(1:10);
xticklabels({'1000','2000','3000','4000','5000','6000','7000','8000','9000','10000'})
%
%
hx = xlabel('{\it n}','color','k');
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