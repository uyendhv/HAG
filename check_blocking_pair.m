function [f] = check_blocking_pair(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list,si,pj,M)
% A (student,project) pair (si, pj) in (SxP)\M is a blocking pair of M, if 
%1. pj is in Ai (i.e. si finds pj acceptable).
%2. Either si is unassigned in M or si prefers pj to M(si).
%3. Either
%  (3a) pj is under-subscribed and lk is under-subscribe;
%  (3b) pj is under-subscribed and lk is full, and either si is in M(lk) or lk
%  prefers si to his worst in M(lk);
%  (3c) pj is full and lk prefer si to the worst student in M(pj) 
%  where lk is the lecture who offers pj.
%==========================================================================
%1. pj is in Ai (i.e. si finds pj acceptable).
rank_si_pj = stud_rank_list(si,pj);
f1 = (rank_si_pj > 0);
%
%2. Either si is unassigned in M or si prefers pj to M(si).
pi = M(1,si);
if (pi >0)
    rank_si_pi = stud_rank_list(si,pi);
else
    rank_si_pi = 0;
end
f2 = (pi == 0)||(rank_si_pj < rank_si_pi);
%
%3. pj is under-subscribed
cj = proj_caps_list(pj);
f3 = (sum(M(1,:) == pj) < cj);
%
%find lecturer lk who offers pj
lk = lect_proj_list(pj);
%take si's rank in lk's rank list
if (si >0)
    rank_lk_si = lect_rank_list(lk,si);
else
    rank_lk_si = 0;
end
%
%  (3a) pj is under-subscribed and lk is under-subscribe;
dk = lect_caps_list(lk);
f3a = f3 && (sum(M(2,:) == lk) < dk);
%  (3b) pj is under-subscribed and lk is full, and either si is in M(lk) or lk
%  prefers si to his worst in M(lk);
sw = find_worst_student_lk(lect_rank_list,lk,M);
rank_lk_sw = lect_rank_list(lk,sw);
f3b = f3 && (sum(M(2,:) == lk) == dk) && (M(2,si) == lk || rank_lk_si < rank_lk_sw);
%  (3c) pj is full and lk prefer si to the worst student in M(pj) 
%  where lk is the lecture who offers pj.
sw2 = find_worst_student_pj(lect_rank_list,lk,pj,M);
rank_lk_sw2 = lect_rank_list(lk,sw2);
f3c = (sum(M(1,:) == pj) == cj) && (rank_lk_si < rank_lk_sw2);
f = f1 && f2 && (f3a || f3b || f3c);
%==========================================================================