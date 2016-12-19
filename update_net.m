function [ net ] = update_net( net )
    H=net.H;DeltaH=net.DeltaH;
    H=H+DeltaH;
    J=H>0;
    net.H=H;net.J=J;
end

