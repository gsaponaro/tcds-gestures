%% configure BNT and other paths
configurePaths;

%% user parameters
create_figures = true;
%barwidth = 0.4;
fontsize = 10;

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
%fid = fopen('./human_data/tap_notable_seated_1/data.log'); % best
%fid = fopen('./human_data/tap_notable_seated_2/data.log');
%fid = fopen('./human_data/tap_notable_standing_1/data.log');
%fid = fopen('./human_data/tap_notable_standing_2/data.log');
%fid = fopen('./human_data/norobotview_tap_notable_seated_1/data.log');
fid = fopen('./human_data/norobotview_tap_notable_seated_2/data.log'); %ok
%fid = fopen('./human_data/norobotview_tap_notable_standing_1/data.log');
%fid = fopen('./human_data/norobotview_tap_notable_standing_2/data.log');
%fid = fopen('./human_data/shoulderheight_1/data.log');
%fid = fopen('./human_data/shoulderheight_2/data.log');
%fid = fopen('./human_data/shoulderheight_3/data.log');
%fid = fopen('./human_data/shoulderheight_4/data.log');
%fid = fopen('./human_data/shoulderheight_5/data.log');
%fid = fopen('./human_data/shoulderheight_6/data.log');
%fid = fopen('./human_data/shoulderheight_7/data.log');
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
%human_startframe = 169;
%human_endframe = 214;

% tap_table_sphere_2
%human_startframe = 142;
%human_endframe = 231;

% tap_notable_seated_1
%human_startframe = 124;
%human_endframe = 214;

% tap_notable_seated_2
%human_startframe = 173;
%human_endframe = 258;

% tap_notable_standing_1
%human_startframe = 230;
%human_endframe = 400;

% tap_notable_standing_2
%human_startframe = 162;
%human_endframe = 240;

% norobotview_tap_notable_seated_1
%human_startframe = 265;
%human_endframe = 368;

% norobotview_tap_notable_seated_2
human_startframe = 160;
human_endframe = 375;

% norobotview_tap_notable_standing_1
%human_startframe = 186;
%human_endframe = 297;

% norobotview_tap_notable_standing_2
%human_startframe = 170;
%human_endframe = 278;

% shoulderheight_1
%human_startframe = 235; % artificial difficulty, arm onset
%human_startframe = 260; % real start
%human_endframe = 324;

% shoulderheight_2
%human_startframe = 118;
%human_endframe = 178;

% shoulderheight_3
%human_startframe = 231;
%human_endframe = 298;

% shoulderheight_4
%human_startframe = 190;
%human_endframe = 242;

% shoulderheight_5
%human_startframe = 148;
%human_endframe = 244;

% shoulderheight_6
%human_startframe = 171;
%human_endframe = 266;

% shoulderheight_7
%human_startframe = 152;
%human_endframe = 238;

human_seglim = [human_startframe+shrink;
                human_endframe-shrink];

human_cell = separate_sequence(human, human_seglim);

%% transpose to BNT format
% i.e. from data{example}(frame,coord) to data{example}(coord,frame)
human_BNT = transpose_cell_array(human_cell);
human_data = human_BNT{1}; % get the matrix of coordinates

%% run Forward-Backward on increasingly complete data
interval = 5;
%sequence_length = human_endframe-human_startframe-shrink*2;
sequence_length = size(human_data, 2);
iteration_frames = interval:interval:sequence_length;
num_iterations = length(iteration_frames);
ev = cell(1,num_iterations); % will store HMM evidence in BNActionValue order: grasp,tap,touch
for iter_fb = 1:num_iterations
    frames_so_far = iteration_frames(iter_fb);
    human_so_far = human_data(:, 1:frames_so_far);

    %scores_map = containers.Map;

    %fprintf('===============================================================\n\n');
    %fprintf('test data: human, subsequence: %d, ground truth: 1 (tap)\n', ex);
    tap_score = mhmm_logprob(human_so_far, hmm1_prior, hmm1_trans, hmm1_mu, hmm1_Sigma, hmm1_mixmat);
    grasp_score = mhmm_logprob(human_so_far, hmm3_prior, hmm3_trans, hmm3_mu, hmm3_Sigma, hmm3_mixmat);
    push_score = mhmm_logprob(human_so_far, hmm4_prior, hmm4_trans, hmm4_mu, hmm4_Sigma, hmm4_mixmat);
    %scores_map('garbage') = mhmm_logprob(human_so_far, hmm0_prior, hmm0_trans, hmm0_mu, hmm0_Sigma, hmm0_mixmat);
    %k = keys(scores_map); % alphabetical order: grasp,push,tap
    %v = values(scores_map);
    k = {'grasp', 'tap', 'push'};
    v2 = [grasp_score, tap_score, push_score];
    v_norm = exp(v2-logsumexp(v2));
    v_norm = v_norm/sum(v_norm); % this is just to eliminate numerical problems
    
    % save the evidence pdf for later plots
    ev{iter_fb} = v_norm; % not sure if this is needed

    [m,i] = max(v_norm);
    fprintf('observing %d frames, pdf: [%s] -> winner %d (%s)\n', frames_so_far, num2str(v_norm), i, k{i});

end;

%% load Affordance-Words Bayesian Network data
load('BN_lab.mat');

%% initial evidence
obs_box = {'Shape', 'box', 'Size', 'big'};

p = cell(1,num_iterations); % will store BN posteriors
for iter_bn = 1:num_iterations

    %% reset BN to the initial evidence
    netobj_lab = BNResetEvidence(netobj_lab);
    netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);
    
    %% extract predictions (posteriors) with the current HMM soft evidence
    inferred = {'ObjVel'};
    [netobj_lab,p{iter_bn}] = fusion(netobj_lab, inferred, obs_box, ev{iter_bn});

end;

%%

if create_figures

%     list_of_ev_as_strings = cell(1,num_iterations);
%     list_of_real_frames = cell(1,1+num_iterations);
%     list_of_real_frames{1} = mat2str(1);
%     for iter_ev = 1:num_iterations
%         list_of_ev_as_strings{iter_ev} = mat2str(ev{iter_ev});
%         iter_ev;
%         list_of_real_frames{1+iter_ev} = mat2str(iter_ev*interval*2);
%     end;

%     figure;
%     b = bar(cell2mat(p)');
%     xlabel('Action Evidence [grasp tap touch]', 'FontSize',fontsize);
%     set(gca, 'xticklabels', list_of_ev_as_strings);
%     xtickangle(45);
%     ylabel('$P_{\rm{comb}}(\rm{ObjVel} \mid \rm{Shape=sphere})$', 'Interpreter','latex', 'FontSize',fontsize);
%     l = legend(b, 'slow', 'medium', 'fast');
%     set(l, 'Location','north');

    figure;
    subplot(3,1,1); % to reduce aspect ratio
    ev_all = cell2mat(ev');
    ev_grasp = ev_all(:,1);
    ev_tap = ev_all(:,2);
    ev_touch = ev_all(:,3);
    hp = plot(iteration_frames, ev_grasp, iteration_frames,ev_tap, iteration_frames,ev_touch);
    hp(1).Color = 'g';
    hp(1).LineStyle = '--';
    hp(1).LineWidth = 1;
    %hp(1).Marker = '*';
    hp(2).Color = 'r';
    hp(2).LineStyle = '-';
    hp(2).LineWidth = 1;
    %hp(2).Marker = '+';
    hp(3).Color = 'b';
    hp(3).LineStyle = '-.';
    hp(3).LineWidth = 1;
    %hp(3).Marker = 'x';
    xlabel('$\rm{frame~k}~(\times~30~\rm{ms})$', 'Interpreter','latex', 'FontSize',fontsize);
    %set(gca, 'xticklabels', list_of_real_frames);
    %set(gca, 'xticklabels',{[]});
    set(gca, 'ylim', [-0.05 1.05], 'xlim', [1 sequence_length]);
    %ylabel('$P_{\rm{HMM}}(\rm{Action}=a_k \mid G_1^k)$', 'Interpreter','latex', 'FontSize',fontsize);
    ylabel('$P_{\rm{HMM}}(A \mid G_1^k)$', 'Interpreter','latex', 'FontSize',fontsize);
    l2 = legend(hp, 'grasp', 'tap', 'touch');
    l2.FontSize = fontsize;
    l2.Location = 'east';
    print('-depsc', 'evolution_of_action_posterior_on_box.eps');
end;