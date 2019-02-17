%% Script to reproduce the results of the paper
%% Beyond the Self: Using Grounded Affordances to Interpret and Describe Others' Actions
%
% See https://github.com/gsaponaro/tcds-gestures for instructions.
%
% Giovanni Saponaro, Giampiero Salvi

%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat');

%% user parameters
create_figures = true;
save_figures = false;

fontsize = 14;
color1 = [0.21 0.17 0.53]; % dark blue
color2 = [0.2  0.72 0.63]; % greenish blue
color3 = [0.98 0.98 0.05]; % yellowish

%% Figure 3 of the paper
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

    if save_figures
        print('-depsc', 'impact_of_evidence_on_Action.eps');
    end
end

%% Figure 4 of the paper
% Inference over the object velocity effect of different
% objects, when given probabilistic soft evidence about the action.

% Figure 4(a) of the paper: sphere

% soft evidence over Action, for various experiments to visualize together
% BNActionValue order: grasp,tap,touch
ev = [0 0 1
    0 0.25 0.75
    0 0.5 0.5
    0 0.75 0.25
    0 1 0];

% load data
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

if create_figures
    figure(4);
    subplot(1,2,1);
    b = bar(p');
    b(1).FaceColor = color1;
    b(2).FaceColor = color2;
    b(3).FaceColor = color3;
    xlabel('$P_{\rm{HMM}}(A \mid G_1^T)$ [grasp tap touch]', 'Interpreter','latex', 'FontSize',fontsize);
    set(gca, 'xticklabels', {'none', mat2str(ev(1,:)), mat2str(ev(2,:)), mat2str(ev(3,:)), ...
        mat2str(ev(4,:)), mat2str(ev(5,:))});
    xtickangle(45);
    ylabel('$P_{\rm{comb}}(\rm{ObjVel} \mid \rm{Shape=sphere}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    ylim([0, 1.0]);
    l = legend(b, 'slow', 'medium', 'fast');
    set(l, 'Location','best');

    if save_figures
        print('-depsc', 'impact_of_evidence_on_ObjVel_sphere.eps');
    end
end

% Figure 4(b) of the paper: box

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

if create_figures
    subplot(1,2,2);
    b = bar(p');
    b(1).FaceColor = color1;
    b(2).FaceColor = color2;
    b(3).FaceColor = color3;
    %xlabel('Action Evidence [grasp tap touch]', 'FontSize',fontsize);
    xlabel('$P_{\rm{HMM}}(A \mid G_1^T)$ [grasp tap touch]', 'Interpreter','latex', 'FontSize',fontsize);
    set(gca, 'xticklabels', {'none', mat2str(ev(1,:)), mat2str(ev(2,:)), mat2str(ev(3,:)), mat2str(ev(4,:)), ...
        mat2str(ev(5,:))});
    xtickangle(45);
    ylabel('$P_{\rm{comb}}(\rm{ObjVel} \mid \rm{Shape=box}, G_1^T)$', 'Interpreter','latex', 'FontSize',fontsize);
    ylim([0, 1.0]);
    l = legend(b, 'slow', 'medium', 'fast');
    set(l, 'Location','best');

    if save_figures
        print('-depsc', 'impact_of_evidence_on_ObjVel_box.eps');
    end
end

%% Figure 5 of the paper
% Object velocity effect anticipation before impact. The evidence from the
% gesture recognizer (left) is fed into the Affordance-Words model before
% the end of the execution. The combined model predicts the effect (right)
% and describes it in words.

% top left
% evolution_of_action_posterior_sphere_log

% top right
% evolution_of_action_posterior_sphere_effect_pred

% bottom left
% evolution_of_action_posterior_box_log

% bottom right
% evolution_of_action_posterior_box_effect_pred

%% Figure 6 of the paper
% Variation of word occurrence probabilities:
% DeltaP(w_i) = P_comb(w_i | X_obs, Action=tap) − P_BN (w_i | X_obs),
% where X_obs = {Size=big, Shape=sphere, ObjVel=fast}. This
% variation corresponds to the difference of word probability
% when we add the tap action evidence (obtained from gesture
% recognition) to the initial evidence about object features and
% effects. We have omitted words for which no significant
% variation was observed.

% load data
load('BN_lab.mat');

nodevaluepairs = {'Color', 'yellow', 'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'};

%netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
%    'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});
netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs);
probs = BNGetWordProbs(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
probs2 = BNGetWordProbs(netobj_lab);

probdiff = probs2-probs;

% plot with all the words, including those where the variation was zero
% if create_figures
%     figure;
%     bar(probdiff)
%     set(gca, 'xtick', 1:length(netobj_lab.WORDNODES))
%     wordnameswithquotes = strcat('"', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)), '"');
%     set(gca, 'xticklabel', wordnameswithquotes);
%     xtickangle(45);
%     if save_figures
%         print('-depsc', 'fullfig.eps');
%     end
% end

if create_figures
    toplot = abs(probdiff)>0.02;
    figure(6);
    bar(probdiff(toplot));
    set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)))
    wordnameswithquotes = strcat('"', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)), '"');
    set(gca, 'xticklabel', wordnameswithquotes);
    ylabel('$\Delta P(w_i)$', 'Interpreter','latex', 'FontSize', 20);
    xtickangle(45);

    if save_figures
        print('-depsc', 'partialfig.eps');
    end
end

%% Table II of the paper
% 10-best list of sentences generated from the evidence
% X_obs = {Color=yellow, Size=big, Shape=sphere, ObjVel=fast}.

% load data
load('BN_lab.mat');

% 10000 sentences generated randomly accroding to the grammar in
% AffordanceAndSpeech/word2sent/grammar.grm (see Makefile for more
% information)
% if needed, we can generate many more
sentenceFilename = 'sentence_data/sentence_10000samples_uniq.txt';

% enter the evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
    'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});

% % extract word probabilities
% pw = BNGetWordProbs(netobj_lab);

% % plot probabilities of the words
% word_threshold = 0.2; % user parameter
% toplot = pw>word_threshold;
% if create_figures
%     figure;
%     bar(pw(toplot));
%     set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)));
%     wordnameswithquotes = strcat('"', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)), '"');
%     set(gca, 'xticklabel', wordnameswithquotes);
%     set(gca,'XTickLabelRotation',45);
%     ylabel('$P(w_i)$', 'Interpreter','latex', 'FontSize', 20);
%     if save_figures
%         print('-depsc', 'example_pw.eps');
%     end
% end

% rescore sentences with word probabilities and pick best sentence
% TODO: fix the following error. Index exceeds array bounds.
% Error in BNScoreSentences (line 45)
%        sentenceLogProbs(sentenceidx) = sentenceLogProbs(sentenceidx) + wordLogProbs(idx);
%                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);

% add quotation marks around all sentences
sentences = strcat('"', sentences, '"');

% % find the best sentence
% [bestprob, bestsentidx] = max(normlogprobs);
% % ...and display it
% sentences{bestsentidx};

% sort sentences
[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');

% display n-best list
nbest = 10;
for h = 1:nbest
    disp([sentences{sortedidxs(h)} ' ' num2str(normlogprobs(sortedidxs(h)))]);
end

%% Figure 7 of the paper
% 10-best list of sentences generated given two different sets of evidence.
% In (a) the model interprets the object movement as indicating a succesful
% grasp and uses the conjunction "and". In (b) the slow movement is
% interpreted as no movement at all and, therefore, as an unsuccessful
% grasp: for that reason, the conjunction "but" is used.

% top left
% p_conjunctions_and_evidence

% top right
% p_conjunctions_but_evidence

% bottom left
% list of sentences starting with
% ``the robot is picking the sphere \textbf{and} the sphere is moving''  & $-0.59328$

% bottom right
% list of sentenes starting with
% ``the robot is picking the cube \textbf{but} the square is still''  & $-0.52575$

%% Figure 8 of the paper
% Example of descriptions generated by the model.
% (a) "The robot is grasping the box and the green box is moving."
% (b) "The robot is poking the green square and the cube is inert."
% (c) "The robot picked the ball and the green ball is moving."
% (d) "Baltazar is poking the green sphere and the sphere is still."

% load data
load('BN_lab.mat');

% user parameters
% 10000 sentences generated randomly accroding to the grammar in
% AffordanceAndSpeech/word2sent/grammar.grm (see Makefile for more
% information)
% if needed, we can generate many more
sentenceFilename = 'sentence_data/sentence_10000samples_uniq.txt';
nbest = 1;

% (a) first example \graspBoxGreenOne
evidence = {'Action', 'grasp', 'Color', 'green1', 'Size', 'big', 'Shape', 'box', 'ObjVel', 'medium'};
% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, evidence, false);
% extract word probabilities
pw = BNGetWordProbs(netobj_lab);
% rescore sentences with word probabilities and pick best sentence
[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);
% sort sentences:
[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');
% display n-best list (containing color)
disp('\graspBoxGreenOne')
displayNBest(sentences, sortedidxs, normlogprobs, nbest, 'green|yellow|blue')

% (b) second example \touchBoxGreenOne
evidence = {'Action', 'touch', 'Color', 'green1', 'Size', 'big', 'Shape', 'box', 'ObjVel', 'slow'};
% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, evidence, false);
% extract word probabilities
pw = BNGetWordProbs(netobj_lab);
% rescore sentences with word probabilities and pick best sentence
[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);
% sort sentences:
[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');
% display n-best list
disp('\touchBoxGreenOne')
displayNBest(sentences, sortedidxs, normlogprobs, nbest, 'green|yellow|blue')

% (c) third example \graspSphereGreenTwo
evidence = {'Action', 'grasp', 'Color', 'green2', 'Size', 'small', 'Shape', 'circle', 'ObjVel', 'medium'};
% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, evidence, false);
% extract word probabilities
pw = BNGetWordProbs(netobj_lab);
% rescore sentences with word probabilities and pick best sentence
[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);
% sort sentences:
[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');
% display n-best list
disp('\graspBoxGreenTwo')
displayNBest(sentences, sortedidxs, normlogprobs, nbest, 'green|yellow|blue')

% (d) fourth example \touchSphereGreenTwo
evidence = {'Action', 'touch', 'Color', 'green2', 'Size', 'big', 'Shape', 'circle', 'ObjVel', 'slow'};
% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, evidence, false);
% extract word probabilities
pw = BNGetWordProbs(netobj_lab);
% rescore sentences with word probabilities and pick best sentence
[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);
% sort sentences:
[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');
% display n-best list
disp('\touchBoxGreenTwo')
displayNBest(sentences, sortedidxs, normlogprobs, nbest, 'green|yellow|blue')