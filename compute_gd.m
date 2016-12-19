function [ DeltaH ] = compute_gd( net,patterns,m,h,hout,params )
    K=net.K;N=net.N;DeltaH=net.DeltaH;
    s=patterns.sigma;xi=patterns.xi;
    eta=params.eta;
    tofix=fix((-s(m)*hout+1)/2);
    wrongh=0;indh=0;

    for k=1:K
        if h(k)*s(m)<=0
            wrongh=[wrongh,-h(k)*s(m)];
            indh=[indh,k];
        end
    end
    wrongh=wrongh(2:end);
    indh=indh(2:end);
    sortedindh=zeros(1,tofix);
    %FUNCTION getrank
    l=1;
    while l<=tofix
        j=find(wrongh==min(wrongh));
        sortedindh(l)=j(1);
        wrongh(j)=max(wrongh)+1;
        l=l+1;
    end
    
    for k=sortedindh
        for i=1:N
            DeltaH(i,indh(k))=DeltaH(i,indh(k))+eta*s(m)*(2*(xi(i,m))-1);
        end
    end
end

