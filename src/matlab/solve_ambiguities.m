%% configure BNT and other paths
configurePaths;

%% user parameters
create_figures = true;
barwidth = 0.4;
mycolormap = autumn;
fontsize = 20;
word_threshold = 0.2;
word_delta_threshold = 0.02;

%% load data
load('BN_lab.mat');

%% give some initial evidence to the Bayesian Network
observed = {'Shape', 'box', 'ObjVel', 'fast'};
netobj_lab = BNEnterNodeEvidence(netobj_lab, observed);

%% extract predictions (posteriors) so far
inferred = {'Action', 'HandVel'};

actions = keys(make_bn_node_map(netobj_lab,'Action'));
handvels = keys(make_bn_node_map(netobj_lab,'HandVel'));

%% P_BN(inferred | observed), also computed/printed internally by fusion
marg = marginal_prob(netobj_lab, inferred);
pbn = marg.T;

if create_figures
    figure;
    bar3(pbn, barwidth);
    colormap(mycolormap);
    xlabel('HandVel', 'FontSize',fontsize);
    set(gca, 'xticklabel',handvels);
    ylabel('Action', 'FontSize',fontsize);
    set(gca, 'yticklabel',actions);
    % char(strjoin(string(inferred), ' '))
    %hz = zlabel('$P_{\rm{BN}}(\rm{Action,HandVel} \mid \rm{Shape=box, ObjVel=fast})$');
    hz = zlabel('$P_{\rm{BN}}$');
    set(hz, 'Interpreter','latex');
    set(hz, 'FontSize',fontsize);
    zlim('manual');
    zlim([0, 1.0]);
    print('-depsc', 'before_softevidence_prediction.eps');
end;

%% extract word probabilities
pw_before = BNGetWordProbs(netobj_lab);

%% now let's add the soft evidence about Action from GestureHMM
gesturehmm_pdf = [0.1 0.8 0.1]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

[netobj_lab,pfusion] = fusion(netobj_lab, inferred, observed, hmm_ev);

if create_figures
    figure;
    bar3(pfusion, barwidth);
    colormap(mycolormap);
    xlabel('HandVel', 'FontSize',fontsize);
    set(gca, 'xticklabel',handvels);
    ylabel('Action', 'FontSize',fontsize);
    set(gca, 'yticklabel',actions);
    %hz = zlabel('$P_{\rm{comb}}(\rm{Action,HandVel} \mid \rm{Shape=box, ObjVel=fast, Action=}P_{\rm{HMM}}(Action))$');
    hz = zlabel('$P_{\rm{comb}}$');
    set(hz, 'Interpreter','latex');
    set(hz, 'FontSize',fontsize);
    zlim('manual');
    zlim([0, 1.0]);
    print('-depsc', 'after_softevidence_prediction.eps');
end;

%% extract word probabilities
pw_after = BNGetWordProbs(netobj_lab);

toplot = pw_after>word_threshold;
if create_figures
    figure;
    bar(pw_after(toplot));
    set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)));
    set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)));
    set(gca,'XTickLabelRotation',45);
    ylabel('$p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
    print('-depsc', 'after_softevidence_pw.eps');
end;

%no variation
% probdiff = pw_after - pw_before;
% toplot = abs(probdiff)>word_delta_threshold;
% 
% if create_figures
%     figure;
%     bar(probdiff(toplot));
%     set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)))
%     set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)))
%     ylabel('$\Delta p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
% end;