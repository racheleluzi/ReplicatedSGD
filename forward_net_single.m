function [ h,tau,hout,tout ] = forward_net_single( netr,ximu )
    K=netr.K;J=netr.J;
    h=zeros(1,K);tau=h;
       for k=1:K
           h(k)=pm1dot(ximu,J(:,k));
           tau(k)=2*(h(k)>0)-1;
       end
       hout=sum(tau);
       tout=2*(hout>0)-1;
end

