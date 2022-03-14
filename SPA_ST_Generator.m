%======================================================================================
function SPA_ST_Generator()
clc
clear vars
clear all
close all
%number of instances has the same (n,m,q,p1,p2)
k = 1;
n = 10000;
    for p1 = 0.95:0.01:0.99
        for p2 = 0.5
            m = 0.02*n;
            i = 1;
            q = 0.05*n;
            while (i <= k)
              %
                S = rand(n,q);
                L = rand(m,n);
                %generate preference lists
                [~,stud_pref_list] = sort(S,2);
                [~,lect_pref_list] = sort(L,2);
                %generate an SPA-ST instance
                [lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list] = make_rank_lists(stud_pref_list,lect_pref_list,p1,p2,q);
                %
                if (~isempty(stud_rank_list))
                %
                    %filename = ['inputs1000_10000\I(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                    filename = ['inputsEx5_2\I(',num2str(n),',',num2str(p1,'%.2f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                    save(filename,'lect_rank_list','lect_caps_list','proj_caps_list','stud_rank_list','lect_proj_list');
                 %    
                    i = i + 1;
                end
            end
        end
    end
end
%============================================================================================
function [lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_offer] = make_rank_lists(stud_pref_list,lect_pref_list,p1,p2,q)
%size of SPA-ST instance
n = size(stud_pref_list,1);
m = size(lect_pref_list,1);
%
%1.generate lecturers' projects whose sum of elements is equal to q
x = 1 + rand(m,1);
lect_proj_list = round(x/sum(x)*q);
%exactly round to q projects
s = sum(lect_proj_list) - q;
for i = 1:abs(s)
    if s > 0
        [~,idx] = max(lect_proj_list); 
        lect_proj_list(idx) = lect_proj_list(idx) - 1;
    else
       if s <0
           [~,idx] = min(lect_proj_list);
           lect_proj_list(idx) = lect_proj_list(idx) + 1;
       end
    end
end
%
%generate lecturers offer project
q = sum(lect_proj_list);
lect_proj_offer = zeros(1,q);
idx = 1;
for i = 1:m
    for j = 1:lect_proj_list(i)
        lect_proj_offer(idx) = i;
        idx = idx + 1;
    end
end

%2. the total capacities of the projects
total_cj = round(1.2*n);
%total_cj is randomly distributed amongst the projects
x = 1 + rand(1,q);
proj_caps_list = round(x/sum(x)*total_cj);
%exactly round to q projects
s = sum(proj_caps_list) - total_cj;
for i = 1:abs(s)
    if s > 0
        [~,idx] = max(proj_caps_list); 
        proj_caps_list(idx) = proj_caps_list(idx) - 1;
    else
       if s <0
           [~,idx] = min(proj_caps_list);
           proj_caps_list(idx) = proj_caps_list(idx) + 1;
       end
    end
end
%
%1. generate an instance of HRP with incomplete lists
%
%generate randomly using a probability

for i = 1:n
    %r - rank
    lect_stud_list = lect_proj_offer;
    for r1 = 1:q
        if (rand() <= p1)
            %delete proj j from stud i's list
            j = stud_pref_list(i,r1);
            stud_pref_list(i,r1) = 0;
            %delete stud i from lect j's list
            lect_stud_list(j) = 0;
        end
    end
    for r2 = 1:m
        if isempty(find(lect_stud_list == r2))
            idx = find(lect_pref_list(r2,:) == i);
            lect_pref_list(r2,idx) =0;
        end
    end
end
%
%2. generate an instance of HRP with Ties, i.e. HRT
%
stud_rank_list = zeros(n,q);
lect_rank_list = zeros(m,n);
lect_caps_list = zeros(m,1);
%check if any resident has an empty preference list, discard the instance
for i = 1:n
    if ~any(stud_pref_list(i,:))
        stud_rank_list = [];
        return;
    end
end
for i = 1:q
    if ~any(stud_pref_list(:,i))
        stud_rank_list = [];
        return;
    end
end
%check if any hospital has an empty preference list, discard the instance
for i = 1:m
    if ~any(lect_pref_list(i,:))
        stud_rank_list = [];
        return;
    end
end
%
%create ties in residents' rank list
for i = 1:n
    %
    idx = find(stud_pref_list(i,:) ~=0,1,'first');
    stud_rank_list(i,stud_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:q
        if (stud_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            stud_rank_list(i,stud_pref_list(i,j)) = cj;
        end
    end
end

%create ties in hospitals' rank list
for i = 1:m
    %
    idx = find(lect_pref_list(i,:) ~=0,1,'first');
    lect_rank_list(i,lect_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:n
        if (lect_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            lect_rank_list(i,lect_pref_list(i,j)) = cj;
        end
    end
end
%
%3. the capacity for each lecturer lk is chosen randomly to lie between 
%the highest capacity of the projects offered by lk and the sum of the
%capacities of the projects that lk offers.
%
% lect_caps_list = zeros(m,1);
% for i = 1:m
%     pj = find(lect_proj_offer == i);
%     if isempty(pj)
%         stud_rank_list = [];
%         return;
%     end
%     d1 = max(proj_caps_list(pj));
%     d2 = sum(proj_caps_list(pj));
%     lect_caps_list(i) = randi([round(0.7*d2),round(0.9*d2)],1,1); %d2;
% end
%
%fprintf('\n sum of lecturers capacities = %d\n',sum(lect_caps_list));
%
%3. generate capacity for hospitals
for i = 1:m
%     stud_idxs = find(lect_rank_list(i,:) > 0);
%     lect_caps_list(i) = randi(size(stud_idxs,2),1,1);
     lect_caps_list(i) = ceil(1.1*n/m);
end
end
%==========================================================================