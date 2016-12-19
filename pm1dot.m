function [ dot_ab ] = pm1dot( a,b )
    dot_ab=4*dot(a,b) - 2*sum(a) - 2*sum(b) + length(a);
end

