clc
clear vars
close all
%==========================================================================
%examle SPA-ST, Manlove 2003
% s = 7;
% l = 3;
lect_rank_list = [2 4 3 1 4 5 1;
                  0 2 1 0 2 0 2;
                  1 0 0 0 0 2 1];
lect_proj_list = [1 1 1 2 2 2 3 3];
lect_caps_list = [3;2;2];
proj_caps_list = [2 1 1 1 1 1 1 1];

stud_rank_list = [1 0 0 0 0 0 1 0;
                  1 0 2 0 3 0 0 0;
                  1 1 0 2 0 0 0 0;
                  0 1 0 0 0 0 0 0;
                  1 0 0 2 0 0 0 0;
                  0 1 0 0 0 0 0 2;
                  0 0 1 0 1 0 0 2];
% %-------------------
%I(10,0.1,0.30)- 29
% n = 10;
% p1 = 0.1;
% p2 = 0.3;
% i = 29;
% filename = ['test2\I(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
% load(filename,'lect_rank_list','lect_caps_list','proj_caps_list','stud_rank_list','lect_proj_list');
% [M] = EGS2(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list)
% [f_time,f_cost,f_stable,f_iter,f_reset] = SPA_ST_HA(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list);
[f_time,f_cost,f_stable,f_iter,f_reset] = SPA_ST_GS2(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list);
% [f_time,f_cost,f_stable,f_iter,f_reset] = HA(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list)

