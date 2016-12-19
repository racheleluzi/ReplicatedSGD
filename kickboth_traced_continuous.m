function [net,netc] = kickboth_traced_continuous(net, netc, params)
    y=params.y;lambda=params.lambda;
    N=net.N;K=net.K;
    H=net.H;J=net.J;oldJ=net.oldJ;
    Hc=netc.H;
    for k = 1:K
        for i = 1:N
            W = 2 * J(i,k) - 1;
            H(i,k)=H(i,k)+lambda*(Hc(i,k) - W);
        end
    end
    J = H > 0;
    Hc= Hc+ 2 * (J - oldJ) / y;
    Jc = Hc > 0;
    net.N=N;net.K=K;
    net.H=H;net.J=J;
    netc.H=Hc;netc.J=Jc;
end


