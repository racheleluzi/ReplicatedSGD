clc;
clear;
close all;
%settaggio parametri
K = 5;
y = 7;
eta = 2.0;
lambda = 0.75;
gamma = 0.05;
eta_factor = 1.0;
lambda_factor = 1.0;
gamma_step = 0.01;
batch = 2;
formula = 'simple';
seed = 0;
max_epochs = 10;
init_equal = 1;
waitcenter = 0;
center = 0;
outfile = ' ';
quiet=0;
N = 5;
M = 3;
seed = 202;
runseed = 101;
%srand(seed)
patterns=patternsNM(N, M);
xi=patterns.xi;
s=patterns.sigma;
valid_formulas=['simple','hard','corrected','continuous'];
    if (K<1 || mod(K,2)==0)
        error('K must be positive and odd!')
    end
    if y<1
        error('y must be positive!')
    end
    if batch<1
        error('batch must be positive!')
    end
%     if isempty(find(valid_formulas==formula))
%         error('Unknown formula %s, you must choose one between:\n simple,hard,corrected,continuous.', formula)
%     end
    if max_epochs<0
        error('max_epochs cannot be negative!')
    end
    if (lambda==0 && waitcenter)
        warning('lambda=%d, waitcenter=true', lambda)
    end
    if (init_equal && batch>=M)
        warning('batch=%d, M=%d, init_equal=true: you should choose batch<M!', batch, M)
    end
%     if seed~=0
%         srand(seed);
%     end
    params=struct('y',y,'eta',eta,'lambda',lambda,'gamma',gamma);
    %creo il network di riferimento
    if center||init_equal
        netc=NetNK(N,K);
    end
    %creo le repliche inizializzandole uguali al primo network o diverse a seconda dei parametri assegnati a init_equal
    for r=1:y
        if init_equal
            nets(r)=netc;
        else
            nets(r)=NetNK(N,K);
            nets(r).H
        end
    end
    
    if center==0
        netc=mean_net(nets);
        netc.H
    else
        dH=zeros(1,N);
    end
    
    for r=1:y
        d(r)=cdist(nets(r).J,netc.J)
    end
    d
    
    
    return
    [errc]=compute_err(netc,patterns);
    minerrc=errc;
    for r=1:y
        errs(r)=compute_err(nets(r),patterns);
       % dist(r)=compute_dist(netc,nets(r));
        patt_perm(r)=PatternPermutation(M,batch);
    end
    minerrs=errs;
    minerrc=min([minerrc,minerrs]);
    
    sub_epochs=fix((M-batch+1)/batch);
    ok=0;ep=0;
    while (ok==0 && ep<max_epochs)
        ep=ep+1;
        for subep=1:sub_epochs
            for r=randperm(y)
                net=nets(r);
                [net,patt_perm(r)]=subepoch(net, patterns, patt_perm(r), params);
%                 if center==0
%                     %if formula==char('continuous')
                        [ net,netc ]= kickboth_traced_continuous(net, netc, params);
% %                     else
%                          kickboth_traced(net, netc, params)%, func)
% %                     end
%                 elseif params.lambda > 0
                       [ net,netc ]= kickboth(net, netc, params);
%                end
            end
        end
        errc = compute_err(netc, patterns);
        minerrc = min(minerrc, errc);
        if errc == 0
            ok = 1;
        end
        for r = 1:y
            net = nets(r);
            errs(r) = compute_err(net, patterns);
            minerrs(r) = min(minerrs(r), errs(r));
            if errs(r) == 0 && waitcenter==0
                ok = 1;
            end
%            dist(r) = compute_dist(netc, net);
        end
        minerr = min(minerrc, min(minerrs));
        fprintf('ep: %d lambda: %f gamma: %f eta %f\n', ep,lambda,gamma,eta);
        fprintf('errc %f [%f]\n', errc,minerrc);
        fprintf('errs %f %f mean=(%f)\n', min(minerrs),errs,mean(errs));
        %println("  dist = $dist (mean=$(mean(dist)))")

%         [eta, lambda, gamma]=update(eta, lambda, gamma, eta_factor, lambda_factor, gamma_step);
%         params.eta=eta;
%         params.lambda=lambda;
%         params.gamma=gamma;
        params.eta=eta_factor*params.eta;
        params.lambda=lambda_factor*params.lambda;
        params.gamma=gamma_step+params.gamma;
        
    end

    if quiet==0
        if ok==1
            disp('SOLVED')
        else
            disp('FAILED')
        end
    end
