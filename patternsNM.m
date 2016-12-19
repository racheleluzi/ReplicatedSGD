function [patterns] = patternsNM(N,M)
%Generates M random ±1 patterns of length N.
    if (N<1 || mod(N,2)==0)
        error('N must be positive and odd!')
    elseif M<0
        error('M must be positive!')
    end
    xi=randi(0:1,N,M);
 sigma=-1+2.*rand(1,M);
    sigma=2*(sigma>0)-1;
    patterns=struct('xi',xi,'sigma',sigma);
end

