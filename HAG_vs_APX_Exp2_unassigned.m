clc
clear vars
clear all
close all
%
n = 400;
k = 100;
%experiment 1 (test1) and experiment 2 (test2)
folder = 'outputsEx2_400';
%the number of instances has the same (n,p1,p2)
%==========================================================================
%AS-HRT algorithm: count the perfect and maximal matchings
%
np1 = []; 
for p1 = 0.86:0.01:0.88
    x = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = [folder,'\APX(',num2str(n),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %count for instances
        t = 0; %total of stable matchings
        s = 0; %for average cost of maximal matchings
        for i = 1:k
            if (f_results(i,3) == 1)
                t = t + 1;
                s = s + f_results(i,2);
            end
        end
        if (t ==0)
            x(end+1) = k;
        else
            x(end+1) = s/t;
        end
    end
    np1 = [np1; x];
end

%==========================================================================
%HS-HRT algorithm: count the perfect, maximal and unstable matchings
%
np2 = []; 
for p1 = 0.86:0.01:0.88
    x = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = [folder,'\HAG(',num2str(n),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %count for instances
        t = 0; %total of stable matchings
        s = 0; %for average cost of maximal matchings
        for i = 1:k
            if (f_results(i,3) == 1)
                t = t + 1;
                s = s + f_results(i,2);
            end           
        end
         if (t ==0)
            x(end+1) = k;
        else
            x(end+1) = s/t;
        end
    end
    np2 = [np2; x];
end
%
%==========================================================================
%Percentage of perfect matchings
type = 1;
data_np1 = (np1);
data_np2 = (np2);
%
%create a figure (left,top,width,height) 
figure('position',[100, 100, 1000, 550]); 
set(axes, 'Units', 'pixels', 'Position', [90, 80, 550, 370]);
hold on
%for AS-HRT
APX_line1 = plot(data_np1(1,:),'--bd','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line2 = plot(data_np1(2,:),'--bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
APX_line3 = plot(data_np1(3,:),'--b>','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.7);
%
%for HS-HRT
HAG_line1 = plot(data_np2(1,:),'--rd','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line2 = plot(data_np2(2,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
HAG_line3 = plot(data_np2(3,:),'--r>','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.7);
%=========================================================================
%
 hand = legend([HAG_line1,HAG_line2,HAG_line3,APX_line1,APX_line2,APX_line3],...
       'HAG {\it p_1} = 0.86{     }','HAG {\it p_1} = 0.87','HAG {\it p_1} = 0.88',...
       'APX{\it p_1} = 0.86{     }','APX {\it p_1} = 0.87','APX {\it p_1} = 0.88');   
 %for layout of figure
 set(hand,'FontSize',17,'Position',[0.0 0.83 0.95 0.17],'Orientation','horizontal','NumColumns',3);   
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
hy = ylabel('Average number of unassigned students','color','k');
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