function [f] = verify_result_matching(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list,M)
%find all blocking pair in M
m = size(lect_rank_list,1);
q = size(proj_caps_list,2);
n = size(proj_caps_list,1);
f = 1;
%
%check for finding acceptance each other
for si = 1:size(M,2)
    pj = M(1,si);
    lk = M(2,si);
    if (pj > 0)
        if (stud_rank_list(si,pj) == 0)
            fprintf("\nStudent s%d does not rank project p%d !!!",si,pj);
            break;
        end
        %
        if (lect_rank_list(lk,si) == 0)
            fprintf("\nLecurer l%d does not offer project p%d !!!",lk,pj);
        end
    end
end
%
%check for stable matching
X = [];
for si = 1:size(M,2)
    for pj = 1:q
        if check_blocking_pair(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list,lect_proj_list,si,pj,M) == true
            X(end+1,:) = [si,pj];
            f = 0;
        end
    end
end
if ~isempty(X)
    fprintf("\nThe matching of the following instance is NOT STABLE !!!!");
    X
end
%
%check capacity |M(pj)| > proj_caps_list(pj)
x = unique(M(1,:));
for i = 1:size(x,2)
    %check for project pj
    pj = x(i);
    if (pj == 0)
        continue;
    end
    cj = sum(M(1,:) == pj);
    %check cj in proj_caps_list
    if (cj > proj_caps_list(pj))
        fprintf("\nThe capacities of project p%d is over subscribed!!!!",pj);
        break;
    end
end
%    
%check capacity |M(lk)| > lect_caps_list(lk)
y = unique(M(2,:));
for i = 1:size(y,2)
    %check for lecturer lk
    lk = y(i);
    if (lk == 0)
        continue;
    end
    dk = sum(M(2,:) == lk);
    %check dk in lect_caps_list
    if (dk > lect_caps_list(lk))
        fprintf("\nThe capacities of lecturer l%d is over subscribed!!!!",lk);
        break;
    end
end
end
%====================================================================