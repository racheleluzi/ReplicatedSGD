function [ net ] = NetNK( N,K )
	H=-1+2.*rand(N,K);
    H=2*(H>0)-1;
    J=H>0;
    DeltaH=zeros(N,K);
    oldJ=J;
    dH=zeros(N,1);
    net=struct('N',N,'K',K,'J',J,'H',H,'DeltaH',DeltaH,'oldJ',oldJ,'dH',dH);
end

