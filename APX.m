%Ref: Manlove, 2018, The Student-Project Allocation Problem.
%==========================================================================
function [f_time,f_cost,f_stable,f_iter,f_reset] = APX(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list)
l = size(lect_rank_list,1);
n = size(stud_rank_list,1);
p = size(proj_caps_list,2);
stud_rank_list_copy = stud_rank_list;
M = zeros(2,n);
act_s = ones(1,n);
phase = ones(1,n);
%
f_stable = 0;
f_cost = n;
f_reset = 0;
iter = 0;
tic
si = 0;
while(sum(act_s==0) ~= n)
    iter = iter + 1;
    cont = false;
    for j = 1:n
        si = mod(si,n) + 1;
        if act_s(si) == 1
            if (~isempty(find(stud_rank_list(si,:) > 0,1)))
                cont = true;
                break;
            else
                if phase(si) == 1
                    f_reset = f_reset + 1;
                    stud_rank_list(si,:) = stud_rank_list_copy(si,:);
                    phase(si) = phase(si) + 1;
                    cont = true;
                    break;
                else
                    act_s(si) = 0;
                    continue;
                end
            end
        end
    end
    if (cont == false)
        break;
    end
    %find proj's min rank in student rank list
    rank = min(stud_rank_list(si,find(stud_rank_list(si,:))));
    %find proj have min rank
    proj = find(stud_rank_list(si,:) == rank);
    pj = proj(1);
    %find fully project
    for h = 1:size(proj,2)
        ph = proj(h);
        lh = lect_proj_list(ph);
        if (sum(M(1,:) == ph) < proj_caps_list(ph) && sum(M(2,:) == lh) < lect_caps_list(lh))
            pj = ph;
            break;
        end
    end
    %lk offer pj
    lk = lect_proj_list(pj);
    assg = 0;
    %
    if (sum(M(1,:) == pj) < proj_caps_list(pj) && sum(M(2,:) == lk) < lect_caps_list(lk))
        M(1,si) = pj;
        M(2,si) = lk;
        act_s(si) = 0;
        assg = 1;
    elseif (sum(M(1,:) == pj) < proj_caps_list(pj) && sum(M(2,:) == lk) == lect_caps_list(lk))
        [unc_stud] = precarious_lk(stud_rank_list,lect_proj_list,proj_caps_list,lect_caps_list,lk,M);
        if unc_stud ~= 0
            sr = unc_stud;
            assg = 1;
        else
            sr = find_worst_student_lk(lect_rank_list,lk,M);
            rank_lk_si = lect_rank_list(lk,si);
            rank_lk_sr = lect_rank_list(lk,sr);
            if((rank_lk_si < rank_lk_sr) || (rank_lk_si == rank_lk_sr && phase(si) > phase(sr)))
                assg = 1;
                stud_rank_list(sr,M(1,sr)) = 0;
            end
        end
        if assg == 1
            M(1,sr) = 0;
            M(2,sr) = 0;
            M(1,si) = pj;
            M(2,si) = lk;
            act_s(si) = 0;
            act_s(sr) = 1;
        end
    elseif (sum(M(1,:) == pj) == proj_caps_list(pj))
        [unc_stud] = precarious(stud_rank_list,lect_proj_list,proj_caps_list,lect_caps_list,pj,M);
        if unc_stud ~= 0
            sr = unc_stud;
            assg = 1;
        else
            sr = find_worst_student_pj(lect_rank_list,lk,pj,M);
            rank_lk_si = lect_rank_list(lk,si);
            rank_lk_sr = lect_rank_list(lk,sr);
            if((rank_lk_si < rank_lk_sr) || (rank_lk_si == rank_lk_sr && phase(si) > phase(sr)))
                assg = 1;
                stud_rank_list(sr,pj) = 0;
            end
        end
        if assg == 1
            M(1,sr) = 0;
            M(2,sr) = 0;
            M(1,si) = pj;
            M(2,si) = lk;
            act_s(si) = 0;
            act_s(sr) = 1;
        end
    end
    if assg == 0
        stud_rank_list(si,pj) = 0;
    end
    %     end
end
[M] = promote_student(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list_copy,lect_proj_list,M);
M;
f_time = toc;
f_iter = iter;
f_cost = find_cost_of_matching(M);
% verify_result_matching(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list_copy,lect_proj_list,M);
f_stable = 1;
%f_stable = check_stable(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list,M);
end
%==========================================================================
function [M] = promote_student(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list,M)
s = size(stud_rank_list,1);
p = size(proj_caps_list,2);
for i = 1:s
    si = i;
    for j = 1:p
        pj = j;
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
        %
        %  (3a) pj is under-subscribed and lk is under-subscribe;
        dk = lect_caps_list(lk);
        f3b = f3 && (sum(M(2,:) == lk) == dk) && (M(2,si) == lk);
        %  (3c) pj is full and lk prefer si to the worst student in M(pj)
        %  where lk is the lecture who offers pj.
        f = f1 && f2 && f3b;
        if f == 1
            M(1,si) = pj;
            %             fprintf('%d, %d',si,pj);
        end
    end
end
end
%==========================================================================
function [unc_stud] = precarious(stud_rank_list,lect_proj_list,proj_caps_list,lect_caps_list,pj,M)
unc_stud = 0;
stud_as_proj = find(M(1,:) == pj);
for j = 1:proj_caps_list(pj)
    s = stud_as_proj(j);
    pj_rank = stud_rank_list(s,pj);
    p_ties = find(stud_rank_list(s,:) == pj_rank);
    %find hos under subscribed has same rank with hj
    for k = 1:size(p_ties,2)
        lr = lect_proj_list(p_ties(k));
        if (sum(M(1,:) == p_ties(k)) < proj_caps_list(p_ties(k)) && sum(M(2,:) == lr) < lect_caps_list(lr))
            unc_stud = s;
            break;
        end
    end
    if unc_stud ~= 0
        break;
    end
end
end
%==========================================================================
function [unc_stud] = precarious_lk(stud_rank_list,lect_proj_list,proj_caps_list,lect_caps_list,lk,M)
unc_stud = 0;
stud_as_lect = find(M(2,:) == lk);
for j = 1:size(stud_as_lect,2)
    s = stud_as_lect(j);
    pj = M(1,s);
    pj_rank = stud_rank_list(s,pj);
    p_ties = find(stud_rank_list(s,:) == pj_rank);
    %find hos under subscribed has same rank with hj
    for k = 1:size(p_ties,2)
        lr = lect_proj_list(p_ties(k));
        if (sum(M(1,:) == p_ties(k)) < proj_caps_list(p_ties(k)) && sum(M(2,:) == lr) < lect_caps_list(lr))
            unc_stud = s;
            break;
        end
    end
    if unc_stud ~= 0
        break;
    end
end
end
%==========================================================================
function [f] = find_cost_of_matching(M)
%f: the number of singles in M
f = size(find(M(1,:) == 0),2);
end
%==========================================================================
function [stb] = check_stable(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list,M)
stb = 1;
q = size(proj_caps_list,2);
for st = 1:size(M,2)
    for pt = 1:q
        if check_blocking_pair(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list,st,pt,M) == true
            stb = 0;
        end
    end
end
end