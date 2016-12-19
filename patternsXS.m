function [ patterns,N,M ] = patternsXS( xi,sigma )
%Encapsulates the input patterns `?` and their associated desired outputs `?` for use in
%[`replicatedSGD`](@ref). The inputs `?` must be given as a vector of vectors, while the outputs `?`
%must be given as a vector. In both cases, they are converted to ±1 values using their sign (more precisely,
%using `x > 0 ? 1 : -1`).
    M=size(xi,2);
    if length(sigma)~=M
        error('Inconsistent vector lengths!')
    elseif M<1
        error('Empty patterns!')
    end
    N=size(xi,1);
    for mu=1:M
        for i=1:N
            xi(i,mu)=(xi(i,mu)*mu>0);
        end
        sigma(mu)=2*(sigma(mu)*mu>0)-1;
    end
    patterns=struct('xi',xi,'sigma',sigma);
end

