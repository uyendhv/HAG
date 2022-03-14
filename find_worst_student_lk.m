function [sj] = find_worst_student_lk(lect_rank_list,lk,M)
%find the worst student sj assigned to pj in M
students = find(M(2,:) == lk);
si_rank_list = lect_rank_list(lk,students);
[~,idx] = max(si_rank_list);
sj = students(idx);
end
%==========================================================================