function [ net ] = NetH( H )
    K=size(H,2);
    if K<1
        error('Empty initial vector H!')
    end
    N=size(H,1);
    J=H>0;
    DeltaH=zeros(N,K);
    oldJ=J;
    dH=zeros(N,1);
    net=struct('N',N,'K',K,'J',J,'H',H,'DeltaH',DeltaH,'oldJ',oldJ,'dH',dH);
end

