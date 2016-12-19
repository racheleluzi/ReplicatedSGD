clc;
clear;
close all;
%settaggio parametri
K = 5;
y = 7;
eta = 2.0;
lambda = 0.5;
gamma = 0.8;
eta_factor = 1.0;
lambda_factor = 1.0;
gamma_step = 0.01;
batch = 80;
formula = 'simple';
seed = 202;
max_epochs = 1000;
init_equal = 1;
waitcenter = 0;
center = 0;
outfile = ' ';
quiet=0;
N = 321;
M = 201;
runseed = 101;
patterns=patternsNM(N, M);
%const opts = Dict(:K=>5, :y=>7, :batch=>80, :?=>0.75, :?=>0.05, :?step=>0.001, :max_epochs=>10_000, :seed=>runseed)

%for formula in [:simple, :hard, :corrected, :continuous]
    [ok, epochs, minerr] = replicatedSGD(N,M,K,y,eta,lambda,gamma,...
    eta_factor,lambda_factor,gamma_step,batch,formula,seed,max_epochs,...
    init_equal,waitcenter,center,outfile,quiet);
    %@test ok
%end
% 
% opts[:formula] = :hard
% 
% ok, epochs, minerr = replicatedSGD(patterns; opts..., init_equal=false)
% @test ok
% 
% ok, epochs, minerr = replicatedSGD(patterns; opts..., init_equal=false, center=true)
% @test ok
% 
% outfile = tempname()
% isfile(outfile) && rm(outfile)
% try
%     ok, epochs, minerr = replicatedSGD(patterns; opts..., quiet=true, outfile=outfile)
%     @test ok
% finally
%     isfile(outfile) && rm(outfile)
% end
% 
% srand(seed)
% patterns = Patterns([randn(N) for ? = 1:M], randn(M))
% ok, epochs, minerr = replicatedSGD(patterns; opts...)
% @test ok
% 
% end # module