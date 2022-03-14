function [sj] = find_worst_student_pj(lect_rank_list,lk,pj,M)
%find the worst student sj assigned to pj in M
students = find(M(1,:) == pj);
si_rank_list = lect_rank_list(lk,students);
[~,idx] = max(si_rank_list);
sj = students(idx);
end
%==========================================================================