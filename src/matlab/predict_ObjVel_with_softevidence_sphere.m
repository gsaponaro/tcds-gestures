%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat');

%% load HMM gesture models trained for CR-HRI 2013 article
% hmm1: tap
% [no touch model]
% hmm3: grasp
% hmm4: push
% [hmm0: garbage]
load('HMM_M3_Q6_mixsplit');

%% load November 2017 human gesture data, removing first 2 columns
%fid = fopen('./human_data/tap_table_sphere_1/data.log');
%fid = fopen('./human_data/tap_table_sphere_2/data.log');
fid = fopen('./human_data/tap_notable_seated_1/data.log');
human = textscan(fid, '%d %f %f %f %f');
human{1,1} = [];
human{1,2} = [];
human = cell2mat(human);
human = human / 1000; % for compatibility with 2013 models
clear fid;

%% temporal segmentation
%shrink = 15;
shrink = 0;

% tap_table_sphere_1
% human_seglim = [169+shrink;
%                 214-shrink];

% tap_table_sphere_2
% human_seglim = [142+shrink;
%                 231-shrink];

% tap_notable_seated_1
human_startframe = 120;
human_endframe = 213;

human_seglim = [human_startframe+shrink;
                human_endframe-shrink];

human_cell = separate_sequence(human, human_seglim);

%% transpose to BNT format
% i.e. from data{example}(frame,coord) to data{example}(coord,frame)
human_BNT = transpose_cell_array(human_cell);

interval = 5;
for frames_so_far = 5:interval:human_endframe

    if frames_so_far > human_endframe-human_startframe
        break;
    end;

    human_so_far = human_BNT{1}(:, 1:frames_so_far);

    %% classification with Forward-Backward algorithm
    scores_map = containers.Map;

    %fprintf('===============================================================\n\n');
    %fprintf('test data: human, subsequence: %d, ground truth: 1 (tap)\n', ex);
    scores_map('tap') = mhmm_logprob(human_so_far, hmm1_prior, hmm1_trans, hmm1_mu, hmm1_Sigma, hmm1_mixmat);
    scores_map('grasp') = mhmm_logprob(human_so_far, hmm3_prior, hmm3_trans, hmm3_mu, hmm3_Sigma, hmm3_mixmat);
    scores_map('push') = mhmm_logprob(human_so_far, hmm4_prior, hmm4_trans, hmm4_mu, hmm4_Sigma, hmm4_mixmat);
    %scores_map('garbage') = mhmm_logprob(human_so_far, hmm0_prior, hmm0_trans, hmm0_mu, hmm0_Sigma, hmm0_mixmat);
    k = keys(scores_map);
    v = values(scores_map);
    v2 = cell2mat(v);
    logsum = logsumexp(v2);
    v_norm = exp(v2-logsum);
    [m,i] = max(cell2mat(values(scores_map)));
    fprintf('observing %d frames, pdf: [%s] -> winner %d (%s)\n', frames_so_far, num2str(v_norm), i, k{i});


end;