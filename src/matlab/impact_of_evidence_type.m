%% configure BNT and other paths
configurePaths;

%% user parameters
create_figures = true;
barwidth = 0.4;
%mycolormap = autumn;
fontsize = 14;
%word_threshold = 0.2;
%word_delta_threshold = 0.02;

%% load data
load('BN_lab.mat');

%% give some initial evidence to the Bayesian Network

% GLU
%observed = {'Color', 'yellow', 'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'};

observed = {'Size', 'big', 'Shape', 'circle'};
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% extract predictions (posteriors) so far
inferred = {'Action'};
actions = keys(make_bn_node_map(netobj_lab,'Action'));

%% P_BN(inferred | observed), also computed/printed internally by fusion
marg = marginal_prob(netobj_lab, inferred);
pbn0 = marg.T;

% if create_figures
%     figure;
%     bar(pbn0, barwidth);
%     %colormap(mycolormap);
%     xlabel('Action', 'FontSize',fontsize);
%     set(gca, 'xticklabel',actions);
%     %yl = ylabel('$P(\rm{Action} | \rm{Size=big, Shape=sphere})$');
%     yl = ylabel('$P_{\rm{comb}}$');
%     set(yl, 'Interpreter','latex');
%     set(yl, 'FontSize',fontsize);
%     ylim('manual');
%     ylim([0, 1.0]);
%     %print('-depsc', 'impact_evidence0.eps');
% end;

%% extract word probabilities
%pw0 = BNGetWordProbs(netobj_lab);

%% GestureHMM Action soft evidence: uniform
%% (OK, verified to be identical to no evidence)
gesturehmm_pdf = [1/3 1/3 1/3]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

[netobj_lab,pbn1] = fusion(netobj_lab, inferred, observed, hmm_ev);

% if create_figures
%     figure;
%     bar(pbn1, barwidth);
%     %colormap(mycolormap);
%     xlabel('Action', 'FontSize',fontsize);
%     set(gca, 'xticklabel',actions);
%     %yl = ylabel('$P(\rm{Action} | \rm{Size=big, Shape=sphere})$');
%     yl = ylabel('$P_{\rm{comb}}$');
%     set(yl, 'Interpreter','latex');
%     set(yl, 'FontSize',fontsize);
%     ylim('manual');
%     ylim([0, 1.0]);
%     %print('-depsc', 'impact_evidence033tap.eps');
% end;

%% extract word probabilities
%pw1 = BNGetWordProbs(netobj_lab);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.4 0.3 0.3]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%% extract prediction
[netobj_lab,pbn2] = fusion(netobj_lab, inferred, observed, hmm_ev);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.5 0.25 0.25]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%% extract prediction
[netobj_lab,pbn3] = fusion(netobj_lab, inferred, observed, hmm_ev);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.6 0.2 0.2]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%% extract prediction
[netobj_lab,pbn4] = fusion(netobj_lab, inferred, observed, hmm_ev);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.7 0.15 0.15]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%% extract prediction
[netobj_lab,pbn5] = fusion(netobj_lab, inferred, observed, hmm_ev);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.8 0.1 0.1]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%% extract prediction
[netobj_lab,pbn6] = fusion(netobj_lab, inferred, observed, hmm_ev);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% GestureHMM Action soft evidence, more informative than before
gesturehmm_pdf = [0.9 0.05 0.05]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%% extract prediction
[netobj_lab,pbn7] = fusion(netobj_lab, inferred, observed, hmm_ev);

%% reset BN to the initial evidence
netobj_lab = BNResetEvidence(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% GestureHMM Action soft evidence, more informative than before = hard evidence
%gesturehmm_pdf = [1.0 0 0]; % GestureHMM order: tap,grasp,touch
%reorder = [2 1 3]; % TODO use get_remapping
%hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action','tap'});

%% extract prediction
%[netobj_lab,pbn8] = fusion(netobj_lab, inferred, observed, hmm_ev);

% marg = marginal_prob(netobj_lab, {'Action'});
% pbn8 = marg.T;

pbn8 = [0; 1; 0];

% I want to have the figure (currently subplot 1) as well as the legend
% (currently subplot 2) visible, outside of the figure! Giovanni
if create_figures
    figure;

    h1 = subplot(1,2,1);
    b = bar([pbn1 pbn2 pbn3 pbn4 pbn5 pbn6 pbn7 pbn8]);
    xlabel('Action', 'FontSize',fontsize);
    set(gca, 'XTickLabel', actions, 'FontSize',fontsize);
    ylabel('$P_{\rm{comb}}$', 'Interpreter','latex', 'FontSize',fontsize);

    h2 = subplot(1,2,2);
    set(h2, 'Visible','off');
    b2 = bar([repmat([0 0 0],8,1)']);
    %set(b2, 'Visible','off');
    l = legend(b2, 'uniform (no evidence)', '[0.3 0.4 0.3]', '[0.25 0.5 0.25]', ...
        '[0.2 0.6 0.2]', '[0.2 0.7 0.2]', '[0.1 0.8 0.1]', '[0.05 0.9 0.05]', ...
        '[0 1 0] (hard evidence)');
    set(l, 'Location','northeast');
    set(l, 'FontSize',fontsize);

    print('-depsc', 'impact_of_soft_evidence.eps');
end;