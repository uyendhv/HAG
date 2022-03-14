function main
clc
clear vars
clear all
close all
%run algorithms
alg = 2;
%number of instances has the same (n,m,q,p1,p2)
k = 100;
p1 = 0.9;
p2 = 0.5;
    for n = 6000%
        for m = 0.02*n%:0.01*n:0.04*n
           f_results= [];
            i = 1;
            while (i <= k)
                %load the preference matrices and the matching from file
                filename = ['inputsEx4_1\I(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                load(filename,'lect_rank_list','lect_caps_list','proj_caps_list','stud_rank_list','lect_proj_list');
                %run algorithms
                if (alg == 1)
                    [f_time,f_cost,f_stable,f_iter,f_reset] = HAG(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list);
                end
                if (alg == 2)
                    [f_time,f_cost,f_stable,f_iter,f_reset] = APX(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list);                   
                end
                %
                f_results = [f_results; f_time,f_cost,f_stable,f_iter,f_reset];
                %
                fprintf('\nI(%d,%d,%0.1f,%0.1f)-%3d: time = %3.5f, f(M)=%2d, stable=%d, iters=%d, reset=%d',n,m,p1,p2,i,f_time,f_cost,f_stable,f_iter,f_reset);
                %

                i = i + 1;
            end
            if (alg == 1)
               filename2 = ['outputsEx4_1\HAG(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
               save(filename2,'f_results');
            end
            if (alg == 2)
               filename2 = ['outputsEx4_1\APX(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
               save(filename2,'f_results');
            end
         end
          end
    end
%  end
%==========================================================================