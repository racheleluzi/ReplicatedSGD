function [ patt_perm,Mbatch ] = getbatch( patt_perm )
    M=patt_perm.M; a=patt_perm.a; batch=patt_perm.batch; MM=patt_perm.MM;
    b=min(a+batch-1,M);
    if b==M
        MM=randperm(M);
        patt_perm.a=1;
    else
        patt_perm.a=b+1;
    end
    Mbatch=MM(a:b);
end

