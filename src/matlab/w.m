%% experiments with probability of words being said

show_figures = false;

% add relevant directories to path
configurePaths

%% load Bayesian Network from .mat
load('BN_lab.mat');

%% result 2 from GLU paper
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
    'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});
w1before = BNGetWordProbs(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
w1after = BNGetWordProbs(netobj_lab);

probdiff1 = w1after - w1before
toplot1 = abs(probdiff1)>0.02;

if show_figures
    figure;
    bar(probdiff1(toplot1));
    set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot1)))
    set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot1)))
    ylabel('$\Delta p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
end;
    
%% new results. when querying over a node with evidence, exclude it
observed_words = {'big','ball'};
netobj_lab = BNEnterWordEvidence(netobj_lab, observed_words, false); % incremental=false resets the BN
word_indices = get_complement_word_indices(netobj_lab, observed_words);
w2before = BNGetWordProbs(netobj_lab, word_indices);
%netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
observed = {'Color', 'blue'};
%observed = [observed sort(repmat(observed_words,1,2))]; % ugly
inferred = {'Action'};
hmm_ev = [0.8 0.1 0.1];
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
result = fusion(netobj_lab, inferred, observed, hmm_ev_ordered);
w2after = BNGetWordProbs(netobj_lab, word_indices);

probdiff2 = w2before - w2after
toplot2 = abs(probdiff2)>0.02;