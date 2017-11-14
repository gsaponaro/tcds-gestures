%% configure BNT and other paths
clear all;
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
fid = fopen('./human_data/tap_notable_seated_1/data.log'); % best
%fid = fopen('./human_data/tap_notable_seated_2/data.log');
%fid = fopen('./human_data/tap_notable_standing_1/data.log');
%fid = fopen('./human_data/tap_notable_standing_2/data.log');
%fid = fopen('./human_data/norobotview_tap_notable_seated_1/data.log');
%fid = fopen('./human_data/norobotview_tap_notable_seated_2/data.log'); %ok
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
human_startframe = 121;
human_endframe = 214;

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
%human_startframe = 160;
%human_endframe = 375;

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

%% Compute forward-backward returning details (alpha)
% In order to get the details we run for each model in two steps: first get
% GMM posteriors, and then run forward backward
% NOTE: we run with scaled=0 to get the real probabilities. However, this
% may cause numerical problems. Should check.
tap_obslik = mixgauss_prob(human_data, hmm1_mu, hmm1_Sigma, hmm1_mixmat);
[tap_alpha, ~, tap_gamma, tap_ll] = fwdback(hmm1_prior, hmm1_trans, tap_obslik, 'fwd_only', 1, 'scaled', 0);
grasp_obslik = mixgauss_prob(human_data, hmm3_mu, hmm3_Sigma, hmm3_mixmat);
[grasp_alpha, ~, grasp_gamma, grasp_ll] = fwdback(hmm3_prior, hmm3_trans, grasp_obslik, 'fwd_only', 1, 'scaled', 0);
push_obslik = mixgauss_prob(human_data, hmm4_mu, hmm4_Sigma, hmm4_mixmat);
[push_alpha, ~, push_gamma, push_ll] = fwdback(hmm4_prior, hmm4_trans, push_obslik, 'fwd_only', 1, 'scaled', 0);

%% plot alphas
if create_figures
    figure;
    subplot(3,1,1);
    title('HMM tap states probability');
    imagesc(tap_alpha ./ (ones(6,1) * sum(tap_alpha)));
    set(gca, 'ydir', 'normal');
    subplot(3,1,2);
    title('HMM grasp states probability');
    imagesc(grasp_alpha ./ (ones(6,1) * sum(grasp_alpha)));
    set(gca, 'ydir', 'normal');
    subplot(3,1,3);
    title('HMM push/touch states probability');
    imagesc(push_alpha ./ (ones(6,1) * sum(push_alpha)));
    set(gca, 'ydir', 'normal');
end;


%% Turn alpha probabilities into likelihoods of each model.
% This is a 3xN matrix where the row index corresponds to the models.
% NOTE: the order is based on the Bayesian network!!!
liks = [sum(grasp_alpha); sum(tap_alpha); sum(push_alpha)];

% Normalize the likelihoods to get posteriors
normliks = liks ./ (ones(3,1)*sum(liks));

%% plot the log likelihoods normalized by the length of the sequence
% the advantage is to show the time evolution
N = size(liks, 2);
framenormlogliks = log(liks)./(ones(3,1)*1:size(liks,2));
figure
subplot(2,1,1)
plot(framenormlogliks')
set(gca, 'ylim', [-3, 1.1], 'xlim', [1, N])
%legend('tap', 'grasp', 'touch', 'location', 'southwest')
text(N-15, framenormlogliks(1,N-15)+0.4, 'grasp')
text(N-15, framenormlogliks(2,N-15)+0.4, 'tap')
text(N-15, framenormlogliks(3,N-15)-0.7, 'touch')
xlabel('frame $t$ ($\times$ 30 ms)', 'Interpreter','latex', 'FontSize',fontsize);
ylabel('$\log\mathcal{L}_{\rm{HMM}}(A \mid G_1^t)$', 'Interpreter','latex', 'FontSize',fontsize);
print('-depsc', 'evolution_of_action_posterior_sphere_log.eps');

%% load Affordance-Words Bayesian Network data
load('BN_lab.mat');

%% initial evidence
obs_sphere = {'Shape', 'circle', 'Size', 'small'};

%% variables used for repeated BN inference below
interval = 5;
sequence_length = length(normliks);
iteration_frames = interval:interval:sequence_length;
num_iterations = length(iteration_frames);

p = cell(1,num_iterations); % will store BN posteriors
for iter_bn = 1:num_iterations
    % reset BN to the initial evidence
    netobj_lab = BNResetEvidence(netobj_lab);
    % define action evidence from HMM
    ev = normliks(:,iteration_frames(iter_bn))';
    % enter both hard and soft evidence
    netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_sphere, true, {'Action', ev});
    
    % extract predictions (posteriors) with the current HMM evidence
    p{iter_bn} = BNMarginalProb(netobj_lab, {'ObjVel'});
end

%% plot the probability distribution for the last prediction
if create_figures
    figure
    subplot(2,2,1)
    barh(p{num_iterations})
    title('$P_{\rm{comb}}(\rm{ObjVel} \mid X_{\rm{obs}}, G_1^t)$', 'Interpreter','latex', 'FontSize',fontsize);
    set(gca, 'yticklabels', netobj_lab.nodeValueNames{BNWhichNode(netobj_lab, 'ObjVel')}, 'FontSize',fontsize);
    set(gca, 'xlim', [0 1.05])
    print('-depsc', 'evolution_of_action_posterior_sphere_effect_pred.eps');
end

%% NOT USED: evolution of probabilities in linear domain

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
    hp = plot(normliks');
    hp(1).Color = 'g';
    hp(1).LineStyle = '--';
    hp(1).LineWidth = 1;
    hp(2).Color = 'r';
    hp(2).LineStyle = '-';
    hp(2).LineWidth = 1;
    hp(3).Color = 'b';
    hp(3).LineStyle = '-.';
    hp(3).LineWidth = 1;
    xlabel('$\rm{frame~t}~(\times~30~\rm{ms})$', 'Interpreter','latex', 'FontSize',fontsize);
    set(gca, 'ylim', [-0.05 1.05], 'xlim', [1 size(normliks, 2)]);
    ylabel('$P_{\rm{HMM}}(A \mid G_1^t)$', 'Interpreter','latex', 'FontSize',fontsize);
    l2 = legend(hp, 'grasp', 'tap', 'touch');
    l2.FontSize = fontsize;
    l2.Location = 'east';
    %print('-depsc', 'evolution_of_action_posterior_on_sphere.eps');
end;