%% Script to reproduce the results of the paper
%% Beyond the Self: Using Grounded Affordances to Interpret and Describe Others' Actions
%
% See https://github.com/gsaponaro/tcds-gestures for instructions.
%
% Giovanni Saponaro, Giampiero Salvi

%% configure BNT and other paths
configurePaths;

%% load Bayesian Network
load('BN_lab.mat');

%% user parameters
create_figures = true;
fontsize = 14;

%% Figure 3
% Inference over action given the evidence
% X_obs = {Size=small, Shape=sphere, ObjVel=slow}, combined with different
% probabilistic soft evidence about the action.

observed = {'Size', 'small', 'Shape', 'circle', 'ObjVel', 'slow'};
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% extract predictions (posteriors) so far
inferred = {'Action'};
actions = keys(make_bn_node_map(netobj_lab,'Action'));

% P_BN(inferred | observed), also computed/printed internally by fusion
marg = marginal_prob(netobj_lab, inferred);
pbn0 = marg.T;

% GestureHMM Action soft evidence: uniform
gesturehmm_pdf = [1/3 1/3 1/3]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch
[netobj_lab,pbn1] = fusion(netobj_lab, inferred, observed, hmm_ev);

% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.4 0.3 0.3]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

% extract prediction
[netobj_lab,pbn2] = fusion(netobj_lab, inferred, observed, hmm_ev);

% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.5 0.25 0.25]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

% extract prediction
[netobj_lab,pbn3] = fusion(netobj_lab, inferred, observed, hmm_ev);

% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.6 0.2 0.2]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

% extract prediction
[netobj_lab,pbn4] = fusion(netobj_lab, inferred, observed, hmm_ev);

% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.7 0.15 0.15]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

% extract prediction
[netobj_lab,pbn5] = fusion(netobj_lab, inferred, observed, hmm_ev);

% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.8 0.1 0.1]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

% extract prediction
[netobj_lab,pbn6] = fusion(netobj_lab, inferred, observed, hmm_ev);

% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.9 0.05 0.05]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

% extract prediction
[netobj_lab,pbn7] = fusion(netobj_lab, inferred, observed, hmm_ev);

% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

% extract prediction
%[netobj_lab,pbn8] = fusion(netobj_lab, inferred, observed, hmm_ev);
% marg = marginal_prob(netobj_lab, {'Action'});
% pbn8 = marg.T;
pbn8 = [0; 1; 0];

if create_figures
    figure(3);
    b3 = bar([pbn1 pbn2 pbn3 pbn4 pbn5 pbn6 pbn7 pbn8]');

    hold on;
    
    color1 = [0.21 0.17 0.53]; % dark blue
    color2 = [0.2  0.72 0.63]; % greenish blue
    color3 = [0.98 0.98 0.05]; % yellowish
    b3(1).FaceColor = color1;
    b3(2).FaceColor = color2;
    b3(3).FaceColor = color3;
    xlabel('Evidence', 'FontSize',fontsize);
    set(gca, 'xticklabels', {'uniform', '[0.3 0.4 0.3]', '[0.25 0.5 0.25]', ...
        '[0.2 0.6 0.2]', '[0.15 0.7 0.15]', '[0.1 0.8 0.1]', '[0.05 0.9 0.05]', ...
        '[0 1 0]'});
    xlabel('$P_{\rm{HMM}}(A \mid G_1^T)$ [grasp tap touch]', 'Interpreter','latex', 'FontSize',fontsize);
    xtickangle(45);
    ylabel('$P_{\rm{comb}}(A \mid X_{\rm{obs}}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    ylim([0, 1.0]);
    l = legend(b3, 'grasp', 'tap', 'touch');
    set(l, 'Location','northwest');

    print('-depsc', 'impact_of_evidence_on_Action.eps');
end

%% Figure 4
% Inference over the object velocity effect of different
% objects, when given probabilistic soft evidence about the action.

% sphere

% soft evidence over Action, for various experiments to visualize together
% BNActionValue order: grasp,tap,touch
ev = [0 0 1
    0 0.25 0.75
    0 0.5 0.5
    0 0.75 0.25
    0 1 0];

% load Bayesian Network
load('BN_lab.mat');

% give some initial evidence to the Bayesian Network
obs_sphere = {'Shape', 'circle'};
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_sphere);

% extract predictions (posteriors)
inferred = {'ObjVel'};
nexamples = size(ev, 1);
% this only works for single inference node
node_size = netobj_lab.node_sizes(BNWhichNode(netobj_lab, inferred{1}));
p = zeros(node_size, nexamples+1);
% posterior without evidence on action
p(:, 1) = BNMarginalProb(netobj_lab, inferred);

for ex = 1:nexamples
    netobj_lab = BNResetEvidence(netobj_lab);
    netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_sphere, true, {'Action', ev(ex,:)});
    p(:, ex+1) = BNMarginalProb(netobj_lab, inferred);
end

% TODO put in Figure 4, subfig left
if create_figures
    figure;
    b = bar(p');
    xlabel('$P_{\rm{HMM}}(A \mid G_1^T)$ [grasp tap touch]', 'Interpreter','latex', 'FontSize',fontsize);
    set(gca, 'xticklabels', {'none', mat2str(ev(1,:)), mat2str(ev(2,:)), mat2str(ev(3,:)), ...
        mat2str(ev(4,:)), mat2str(ev(5,:))});
    xtickangle(45);
    ylabel('$P_{\rm{comb}}(\rm{ObjVel} \mid \rm{Shape=sphere}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    ylim([0, 1.0]);
    l = legend(b, 'slow', 'medium', 'fast');
    set(l, 'Location','best');
    print('-depsc', 'impact_of_evidence_on_ObjVel_sphere.eps');
end

% box

% load data
load('BN_lab.mat');

% give some initial evidence to the Bayesian Network
obs_box = {'Shape', 'box'};
netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box);

% extract predictions (posteriors)
inferred = {'ObjVel'};
nexamples = size(ev, 1);
% this only works for single inference node
node_size = netobj_lab.node_sizes(BNWhichNode(netobj_lab, inferred{1}));
p = zeros(node_size, nexamples+1);
% posterior without evidence on action
p(:, 1) = BNMarginalProb(netobj_lab, inferred);

for ex = 1:nexamples
    netobj_lab = BNResetEvidence(netobj_lab);
    netobj_lab = BNEnterNodeEvidence(netobj_lab, obs_box, true, {'Action', ev(ex,:)});
    p(:, ex+1) = BNMarginalProb(netobj_lab, inferred);
end

% TODO put in Figure 4, subfig right
if create_figures
    figure;
    b = bar(p');
    %xlabel('Action Evidence [grasp tap touch]', 'FontSize',fontsize);
    xlabel('$P_{\rm{HMM}}(A \mid G_1^T)$ [grasp tap touch]', 'Interpreter','latex', 'FontSize',fontsize);
    set(gca, 'xticklabels', {'none', mat2str(ev(1,:)), mat2str(ev(2,:)), mat2str(ev(3,:)), mat2str(ev(4,:)), ...
        mat2str(ev(5,:))});
    xtickangle(45);
    ylabel('$P_{\rm{comb}}(\rm{ObjVel} \mid \rm{Shape=box}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    ylim([0, 1.0]);
    l = legend(b, 'slow', 'medium', 'fast');
    set(l, 'Location','best');
    print('-depsc', 'impact_of_evidence_on_ObjVel_box.eps');
end

%% Figure 5
% Object velocity effect anticipation before impact. The evidence from the
% gesture recognizer (left) is fed into the Affordance-Words model before
% the end of the execution. The combined model predicts the effect (right)
% and describes it in words.

%% Figure 6
% Variation of word occurrence probabilities:
% DeltaP(w_i) = P_comb(w_i | X_obs, Action=tap) − P_BN (w_i | X_obs),
% where X_obs = {Size=big, Shape=sphere, ObjVel=fast}. This
% variation corresponds to the difference of word probability
% when we add the tap action evidence (obtained from gesture
% recognition) to the initial evidence about object features and
% effects. We have omitted words for which no significant
% variation was observed.

%% Table II
% 10-best list of sentences generated from the evidence
% X_obs = {Color=yellow, Size=big, Shape=sphere, ObjVel=fast}.

%% Figure 7
% 10-best list of sentences generated given two different sets of evidence.
% In (a) the model interprets the object movement as indicating a succesful
% grasp and uses the conjunction "and". In (b) the slow movement is
% interpreted as no movement at all and, therefore, as an unsuccessful
% grasp: for that reason, the conjunction "but" is used.
