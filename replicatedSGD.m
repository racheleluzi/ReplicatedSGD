function [ ok,ep,minerr ] = replicatedSGD( N,M,K,y,eta,lambda,gamma,...
    eta_factor,lambda_factor,gamma_step,batch,formula,seed,max_epochs,...
    init_equal,waitcenter,center,outfile,quiet )

% replicatedSGD(patterns::Patterns; keywords...)
% Runs the replicated Stochastic Gradient Descent algorithm over the given `patterns` (see [`Patterns`](@ref)). It
% automatically detects the size of the input and initializes a system of interacting binary committee machines which
% collectively try to learn the patterns.
% The function returns three values: a `Bool` with the success status, the number of epochs, and the minimum error achieved.
% The available keyword arguments (note that the defaults are mostly *not* sensible, they must be collectively tuned):
% * `K` (default=`1`): number of hidden units for each committee machine (size of the hidden layer)
% * `y` (default=`1`): number of replicas
% * eta` (default=`2`): initial value of the step for the energy (loss) term gradient
% * lambda (default=`0.1`): initial value of the step for the interaction gradient (called `??` in the paper)
% * `gamma` (default=`Inf`): initial value of the interaction strength
% * `etafactor` (default=`1`): factor used to update `?` after each epoch
% * `lambdafactor` (default=`1`): factor used to update `?` after each epoch
% * `gammastep` (default=`0.01`): additive step used to update `?` after each epoch
% * `batch` (default=`5`): minibatch size
% * `formula` (default=`:simple`): used to choose the interaction update scheme when `center=false`; see below for available values
% * `seed` (default=`0`): random seed; if `0`, it is not used
% * `max_epochs` (default=`1000`): maximum number of epochs
% * `init_equal` (default=`true`): whether to initialize all replicated networks equally
% * `waitcenter` (default=`false`): whether to only exit successfully if the center replica has solved the problem
% * `center` (default=`false`): whether to explicity use a central replica (if `false`, it is traced out)
% * `outfile` (default=`""`): name of a file where to output the results; if empty it's ignored
% * `quiet` (default=`false`): whether to output information on screen
% The possible values of the `formula` option are:
% * `:simple` (the default): uses the simplest traced-out center formula (eq. (C7) in the paper)
% * `:corrected`: applies the correction of eq. (C9) to the formula of eq. (C7)
% * `:continuous`: version in which the center is continuous and traced-out
% * `:hard`: same as `:simple` but uses a hard tanh, for improved performance
% Example of a good parameter configuration (for a committee with `K=5` and `N*K=1605` synapses overall, working at `?=M/(NK)=0.5`):

    valid_formulas=['simple','hard','corrected','continuous'];
    patterns=patternsNM(N, M);
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
    if seed~=0
        rng(seed);
    end
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
        end
    end
    
    if center==0
        netc=mean_net(nets);
    else
        dH=zeros(1,N);
    end
    [errc]=compute_err(netc,patterns);
    minerrc=errc;
    for r=1:y
        errs(r)=compute_err(nets(r),patterns);
       % dist(r)=compute_dist(netc,nets(r));
        patt_perm(r)=PatternPermutation(M,batch);
    end
    minerrs=errs;
    minerr=min([minerrc,minerrs]);
    
    sub_epochs=fix((M+batch-1)/batch);
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
        fprintf('ep: %d lambda: %f gamma: %f eta %f\n', ep,params.lambda,params.gamma,params.eta);
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

    
 end

