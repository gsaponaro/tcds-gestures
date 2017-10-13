addpath('./human_data'); % external agent data, gestures, object features(?)

%% load HMM gesture models trained for CR-HRI 2013 article
% hmm1: tap
% [no touch model]
% hmm3: grasp
% hmm4: push
% [hmm0: garbage]
load HMM_M3_Q6_mixsplit;

%% map of HMM gesture names with corresponding indexes
hmm_keys = {'tap', 'grasp', 'push'};
hmm_vals = [1 2 3]; % hmm1 hmm3 hmm4 (hmm2 is touch, unused)
hmm_map = containers.Map(hmm_keys,hmm_vals);

%% load 2017 HMM test data (removing first 2 columns)
tap1_fid = fopen('./human_data/tap1_hand/data.log');
tap1 = textscan(tap1_fid, '%d %f %f %f %f');
tap1{1,1} = [];
tap1{1,2} = [];
tap1 = cell2mat(tap1);
tap1 = tap1 / 1000; % for compatibility with 2013 models
clear tap1_fid;

%% test data segmentation
shrink = 10;
tap1_seglim = [206+shrink 391+shrink 547+shrink;
               361-shrink 521-shrink 674-shrink];
% they were determined by inspecting yarp ppm image numbers:
% [345 530 686;
%  500 660 813]
% and corresponding timestamps:
% [1495933420.892006 1495933426.944280 1495933432.054602;
%  1495933425.965962 1495933431.200979 1495933436.206443]

tap1_cell = separate_sequence(tap1, tap1_seglim);

%% transpose to BNT format
% i.e. from data{example}(frame,coord) to data{example}(coord,frame)
tap1_BNT = transpose_cell_array(tap1_cell);

%% classification
scores_map = containers.Map;
for ex = 1:length(tap1_BNT)
    fprintf('===============================================================\n\n');
    fprintf('test data: tap1, subsequence: %d, ground truth: 1 (tap)\n', ex);
    scores_map('tap') = mhmm_logprob(tap1_BNT{ex}, hmm1_prior, hmm1_trans, hmm1_mu, hmm1_Sigma, hmm1_mixmat);
    scores_map('grasp') = mhmm_logprob(tap1_BNT{ex}, hmm3_prior, hmm3_trans, hmm3_mu, hmm3_Sigma, hmm3_mixmat);
    scores_map('push') = mhmm_logprob(tap1_BNT{ex}, hmm4_prior, hmm4_trans, hmm4_mu, hmm4_Sigma, hmm4_mixmat);
    %scores_map('garbage') = mhmm_logprob(tap1_BNT{ex}, hmm0_prior, hmm0_trans, hmm0_mu, hmm0_Sigma, hmm0_mixmat);
    k = keys(scores_map)
    v = values(scores_map)
    v2 = cell2mat(v);
    v_norm = normalise(1 - v2/sum(v2)) % TODO check
    [m,i] = max(cell2mat(values(scores_map)));
    fprintf('winner: %d (%s)\n', i, k{i});
end;
