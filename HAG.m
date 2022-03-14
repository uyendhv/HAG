%==========================================================================
function [f_time,f_cost,f_stable,f_iter,f_reset] = HAG(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list)
m = size(lect_rank_list,1);
n = size(stud_rank_list,1);
q = size(proj_caps_list,2);
stud_rank_copy = stud_rank_list;
M = zeros(2,n);
v = zeros(1,n);
%
f_cost = n;
f_reset = 0;
iter = 0;
tic
si = 0;
while(true)
    %find the unmatched student si and si's rank list is non-empty
    iter = iter + 1;
    cont = false;
    for j = 1:n
        si = mod(si,n) + 1;
        if (M(1,si) == 0) && (~isempty(find(stud_rank_list(si,:) > 0,1)))
            cont = true;
            break;
        end
    end
    if (cont == false)
        f = sum(M(1,:) == 0);
        if f == 0
            break;
        else
            f_reset = f_reset + 1;
            M0 = M;
            [M,v,stud_rank_list] = improve(lect_rank_list,proj_caps_list,stud_rank_list,lect_proj_list,stud_rank_copy,M,v);
            if M == M0
                break;
            end
            continue;
        end
    end
    %h function
    h = stud_rank_list(si,:);
    %h(hj) in [rank(ri,hj), rank(ri,hj) + 1)
    s = histc(M(1,:),1:q);
    z = histc(M(2,:),1:m);
    for pj = 1:q
        if h(pj) > 0
            c = proj_caps_list(pj);
            lk = lect_proj_list(pj);
            d = lect_caps_list(lk);
            h(pj) = h(pj) - min([d - z(lk),1])*0.5 - (c - s(pj))/(2*c + 1);
        end
    end
    %find the project pj with minimum h value
    rank = min(h(find(h > 0)));
    pj = find(h == rank,1,'first');
    %lk offer pj
    lk = lect_proj_list(pj);
    if (s(pj) < proj_caps_list(pj) && z(lk) < lect_caps_list(lk))
        M(1,si) = pj;
        M(2,si) = lk;
    elseif (s(pj) == proj_caps_list(pj))
        %for each student sw in M(pj)
        stud = find(M(1,:) == pj);
        [sw,y] = choose_student(stud_rank_list,lect_rank_list,lect_caps_list,proj_caps_list,lect_proj_list,stud,M,lk,s,z);
        if (y > n + 1) || lect_rank_list(lk,si) < lect_rank_list(lk,sw)
            M(1,sw) = 0;
            M(2,sw) = 0;
            M(1,si) = pj;
            M(2,si) = lk;
            if y < n + 1
                %delete rank
                stud_rank_list(sw,pj) = 0;
            end
        else
            %delete rank
            stud_rank_list(si,pj) = 0;
        end
    elseif z(lk) == lect_caps_list(lk)
        %for each student st in M(lk)
        stud = find(M(2,:) == lk);
        [st,y] = choose_student(stud_rank_list,lect_rank_list,lect_caps_list,proj_caps_list,lect_proj_list,stud,M,lk,s,z);
        if y > n + 1 || lect_rank_list(lk,si) < lect_rank_list(lk,st)
            %M := M\(st,pu)U(si,pj)
            pu = M(1,st);
            M(1,st) = 0;
            M(2,st) = 0;
            M(1,si) = pj;
            M(2,si) = lk;
            if y < n + 1
                %delete rank
                stud_rank_list(st,pu) = 0;
            end
            %replace blocking pair of type 3bi
            if pu ~= pj
                [M,stud_rank_list] = replace(stud_rank_list,stud_rank_copy,M,pu,lk);
            end
        else
            %delete rank
            stud_rank_list(si,pj) = 0;
        end
    end
end
f_time = toc;
f_iter = iter;
f_cost = sum(M(1,:) == 0);
% verify_result_matching(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_copy,lect_proj_list,M);
f_stable = 1;
end
%==========================================================================
function [M,v,stud_rank_list] = improve(lect_rank_list,proj_caps_list,stud_rank_list,lect_proj_list,stud_rank_copy,M,v)
m = size(proj_caps_list,2);
unmatched = find(M(1,:) == 0);
stud_rank_list(unmatched,:) = stud_rank_copy(unmatched,:);
for i = 1:size(unmatched,2)
    su = unmatched(i);
    R = stud_rank_list(su,:);
    while sum(R == 0) < m
        proj = find(R ~= 0);
        [~,idx] = min(R(proj));
        pz = proj(idx);
        lk = lect_proj_list(pz);
        rank_lk_si = lect_rank_list(lk,su);
        %students have same ties with si in lk's list
        stud = find(lect_rank_list(lk,:) == rank_lk_si);
        if (sum(M(1,:) == pz) == proj_caps_list(pz))
            %pj full, consider students assign with pj
            idx1 = find(M(1,stud) == pz);
            for k = 1:size(idx1,2)
                si = stud(idx1(k));
                if v(su) >= v(si)
                    M(1,si) = 0;
                    M(2,si) = 0;
                    M(1,su) = pz;
                    M(2,su) = lk;
                    stud_rank_list(si,pz) = 0;
                    %increase the number of repairs
                    v(su) = v(su) + 1;
                    break;
                end
            end
        else
            %pj under-subscribe
            idx2 = find(M(2,stud) == lk);
            for k = 1:size(idx2,2)
                si = stud(idx2(k));
                if v(su) >= v(si)
                    pj = M(1,si);
                    M(1,si) = 0;
                    M(2,si) = 0;
                    M(1,su) = pz;
                    M(2,su) = lk;
                    stud_rank_list(si,pj) = 0;
                    %increase the number of repairs
                    v(su) = v(su) + 1;
                    %remove block 3bi
                    [M,stud_rank_list] = replace(stud_rank_list,stud_rank_copy,M,pj,lk);
                    break;
                end
            end
        end
        %si is matched in M
        if M(1,su) ~= 0
            break;
        else
            R(pz) = 0;
        end
    end
end
end
%==========================================================================
function [st,y] = choose_student(stud_rank_list,lect_rank_list,lect_caps_list,proj_caps_list,lect_proj_list,stud,M,lk,s,z)
q = size(stud_rank_list,2);
n = size(stud_rank_list,1);
g = lect_rank_list(lk,stud);
for j = 1:size(stud,2)
    st = stud(j);
    pu = M(1,st);
    proj = find(stud_rank_list(st,:) == stud_rank_list(st,pu));
    t = 0;
    %t = sum(min[(d - z),1] * min([c - s,1) * n)
    for k = 1:size(proj,2)
        pz = proj(k);
        c = proj_caps_list(pz);
        lx = lect_proj_list(pz);
        d = lect_caps_list(lx);
        if pz ~= pu
            t = t + min([(d - z(lx)),1]) * min([c - s(pz),1]) * n;
        end
    end
    r = sum(stud_rank_list(st,:) > 0, 2);
    %g = rank + t + r/(q + 1)
    g(j) = g(j) + t + r/(q + 1);
end
[y,idx] = max(g);
st = stud(idx);
end
%==========================================================================
function [M,stud_rank_list] = replace(stud_rank_list,stud_rank_copy,M,pu,lk)
stud = find(M(2,:) == lk);
bool = true;
while bool
    bool = false;
    for j = 1:size(stud,2)
        st = stud(j);
        px = M(1,st);
        if stud_rank_copy(st,pu) > 0 && stud_rank_copy(st,pu) < stud_rank_copy(st,px)
            stud_rank_list(st,pu) = stud_rank_copy(st,pu);
            M(1,st) = pu;
            pu = px;
            bool = true;
            break;
        end
    end
end
end