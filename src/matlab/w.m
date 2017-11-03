%% experiments with probability of words being said

%% user parameters
show_figures = true;
word_delta_threshold = 0.02;

%% configure BNT and other paths
configurePaths;

%% load Bayesian Network from .mat
load('BN_lab.mat');

%% Action probability distribution soft evidence from GestureHMM
gesturehmm_pdf = [0.8 0.1 0.1]; % GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev = gesturehmm_pdf(:, reorder); % BNActionValue order: grasp,tap,touch

%% example counter
e = 1;

%% result 2 from GLU paper
fprintf('%d.\n', e);

netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
    'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});
fprintf('after first evidence:\n');
BNShowCurrentEvidence(netobj_lab);
w1before = BNGetWordProbs(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
fprintf('after second evidence:\n');
BNShowCurrentEvidence(netobj_lab);
w1after = BNGetWordProbs(netobj_lab);

probdiff1 = w1after - w1before;
toplot1 = abs(probdiff1)>word_delta_threshold;

if show_figures
    figure;
    bar(probdiff1(toplot1));
    set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot1)))
    set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot1)))
    ylabel('$\Delta p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
end;
    
netobj_lab = BNResetEvidence(netobj_lab);
e = e+1;
fprintf('%d.\n', e);

%% new experiment
observed1 = {'big','ball','rolling'};
netobj_lab = BNEnterWordEvidence(netobj_lab, observed1);
fprintf('after first evidence:\n');
BNShowCurrentEvidence(netobj_lab);
word_indices = get_complement_word_indices(netobj_lab, observed1);
w2before = BNGetWordProbs(netobj_lab, word_indices);
observed2 = {'ObjVel', 'fast'}; % the evidence observed1 was already retained
inferred = {'Action'};
[netobj_lab,~] = fusion(netobj_lab, inferred, observed2, hmm_ev);
fprintf('after second evidence:\n');
BNShowCurrentEvidence(netobj_lab);
w2after = BNGetWordProbs(netobj_lab, word_indices);

probdiff2 = w2after - w2before;
toplot2 = abs(probdiff2)>word_delta_threshold;

if show_figures
    figure;
    bar(probdiff2(toplot2));
    set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot2)))
    set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot2)))
    ylabel('$\Delta p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
end;