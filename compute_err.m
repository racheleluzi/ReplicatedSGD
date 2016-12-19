function [ errs,tout ] = compute_err( net,patterns )
    xi=patterns.xi;
    s=patterns.sigma;
    errs=0;
    for m=1:size(xi,2)
        [~,tout(m)]=forward_net(net,xi(:,m));
        errs=errs+(tout(m)~=s(m));
    end
    
end

