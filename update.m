function [ eta, lambda, gamma ] = update(eta, lambda, gamma, eta_factor, lambda_factor, gamma_step)
    eta=eta_factor*eta;
    lambda=lambda_factor*lambda;
    gamma=gamma_step+gamma;
    
end

