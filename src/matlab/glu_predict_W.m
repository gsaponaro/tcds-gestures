%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat'); % new BN with softevidence field
%load('../../../glu-gestures/src/matlab/BN_lab.mat'); % old BN (GLU)

nodevaluepairs = {'Color', 'yellow', 'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'};

%netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
%    'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});
netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs);
probs = BNGetWordProbs(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
probs2 = BNGetWordProbs(netobj_lab);

probdiff = probs2-probs;
figure;
bar(probdiff)
set(gca, 'xtick', 1:length(netobj_lab.WORDNODES))
set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES))
xtickangle(45);
%print -dsvg fullfig
print('-depsc', 'fullfig.eps');

toplot = abs(probdiff)>0.02;
figure;
bar(probdiff(toplot));
set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)))
set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)))
%ylabel('$\Delta p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
ylabel('$\Delta P(w_i)$', 'Interpreter','latex', 'FontSize', 20);
xtickangle(45);
print('-depsc', 'partialfig.eps');