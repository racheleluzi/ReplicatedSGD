function [ hout,tout ] = forward_net( netr,xi )
    m=size(xi,2);
    hout=zeros(1,m);tout=hout;
    for i=1:m
        [~,~,hout(i),tout(i)]=forward_net_single(netr,xi(:,i));
    end
end

