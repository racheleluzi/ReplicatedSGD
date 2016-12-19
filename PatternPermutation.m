function [ patt_perm ] = PatternPermutation( M,batch )
MM=randperm(M);
a=1;
patt_perm=struct('M',M,'MM',MM,'a',a,'batch',batch);
end

