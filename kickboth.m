function [ net,netc ] = kickboth( net,netc,params )
    N=net.N;K=net.K;
    H=net.H;J=net.J;
    Hc=netc.H;Jc=netc.J;
    dH=netc.dH;
    lambda=params.lambda;
    for k=1:K
        for i=1:N
            dH(i)=Jc(i,k)-J(i,k);
        end
        H(:,k)=lambda*dH+H(:,k);
        Hc(:,k)=-lambda*dH+Hc(:,k);
        for i=1:N
            J(i,k)=H(i,k)>0;
            Jc(i,k)=Hc(i,k)>0;
        end
    end
    net.N=N;net.K=K;
    net.H=H;net.J=J;
    netc.H=Hc;netc.J=Jc;
end

