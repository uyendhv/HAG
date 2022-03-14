clc
clear vars
clear all
close all
%
p1 = 0.9;
p2 = 0.5;
k = 100;
%experiment 1 (test1) and experiment 2 (test2)
folder = 'outputsEx4_1';
%the number of instances has the same (n,m,q,p1,p2)
%==========================================================================
%AS-HRT algorithm: count the perfect and maximal matchings
%
np1 = []; 
for n = 1000:1000:10000
    x = [];
    for m = 0.02*n:0.01*n:0.04*n
        %load to file for averaging results
        filename = [folder,'\APX(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        %count for instances
        p = 0; %for the perfect matchings
        for i = 1:k
            if (f_results(i,2) == 0)&&(f_results(i,3) == 1)
                p = p + 1;
            end
        end
        x(end+1) = p;
    end
    np1 = [np1; x];
end

%==========================================================================
%HS-HRT algorithm: count the perfect, maximal and unstable matchings
%
np2 = [];  
for n = 1000:1000:10000
    x = [];
    for m = 0.02*n:0.01*n:0.04*n
        %load to file for averaging results
        filename = [folder,'\HAG(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];        
        load(filename,'f_results');
        %count for instances
        p = 0; %for the perfect matchings
        for i = 1:k
            if (f_results(i,2) == 0)&&(f_results(i,3) == 1)
                p = p + 1;
            end
        end
        x(end+1) = p;
    end
    np2 = [np2; x];
end
%
%==========================================================================
%Percentage of perfect matchings
data_np1 = np1';
data_np2 = np2';
%  data_np1 = mean(np1,2);
%  data_np2 = mean(np2,2);
%
%create a figure (left,top,width,height) 
figure('position',[100, 100, 1000, 550]); 
set(axes, 'Units', 'pixels', 'Position', [90, 80, 550, 370]);
hold on
%for AS-HRT
APX_line1 = plot(data_np1(1,:),'-bd','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line2 = plot(data_np1(2,:),'-bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line3 = plot(data_np1(3,:),'-b>','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
% APX_line4 = plot(data_np1(4,:),'--bp','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);

%
%for HS-HRT
HAG_line1 = plot(data_np2(1,:),'-rd','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line2 = plot(data_np2(2,:),'-rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line3 = plot(data_np2(3,:),'-r>','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
% HAG_line4 = plot(data_np2(4,:),'--rp','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);

%=========================================================================
%
hand = legend([HAG_line1,HAG_line2,HAG_line3,APX_line1,APX_line2,APX_line3],...
       'HAG {\it p_1} = 0.02n{     }','HAG {\it p_1} = 0.03n','HAG {\it p_1} = 0.04n',...
       'APX{\it p_1} = 0.02n{     }','APX {\it p_1} = 0.03n','APX {\it p_1} = 0.04n');     
%for layout of figure
set(hand,'FontSize',17,'Position',[0.0 0.83 0.95 0.17],'Orientation','horizontal','NumColumns',3);   
legend('boxoff')
set(gcf,'color','w');
xlim([1 10]);
xticks(1:10);
xticklabels({'1000','2000','3000','4000','5000','6000','7000','8000','9000','10000'})
%
hx = xlabel('{\it p_2}','color','k');
set(hx, 'FontSize', 17)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',17)
%
ylim([0,105]);
yticks(0:10:105);
hy = ylabel('Percentage of perfect matchings','color','k');
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
