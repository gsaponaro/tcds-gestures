function posteriors = posterior_hmm(data, interval)

%% load HMM gesture models trained for CR-HRI 2013 article
% hmm1: tap
% [no touch model]
% hmm3: grasp
% hmm4: push
% [hmm0: garbage]
load('HMM_M3_Q6_mixsplit');