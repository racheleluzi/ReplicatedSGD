function [ netmean ] = mean_net( nets )
    y=length(nets);
    if y<1
        error('Empty nets vector!')
    end
    K=nets(1).K;
    N=nets(1).N;
    HH=zeros(N,K);
        for i=1:y
            HH=HH+nets(i).J;
        end
    HH=2/y*HH-1;
    netmean=NetH(HH);
end

