function [ net,patt_perm ] = subepoch( net,patterns,patt_perm,params )
    [patt_perm,Mbatch]=getbatch(patt_perm);
    s=patterns.sigma;
    xi=patterns.xi;
    for i=1:length(Mbatch)
        [h,~,hout,tout]=forward_net_single(net,xi(:,Mbatch(i)));
        if tout~=s(Mbatch(i))
           DeltaH = compute_gd( net,patterns,Mbatch(i),h,hout,params );
           net.DeltaH=DeltaH;
        end
    end
    net = update_net( net );
end

