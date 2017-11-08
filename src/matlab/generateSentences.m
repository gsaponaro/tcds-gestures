% this is an example on how to generate descriptions from word
% probabilities:

%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat');

%% user parameters
word_threshold = 0.2;
create_figures = true;

% 1000 sentences generated randomly accroding to the grammar in
% AffordanceAndSpeech/word2sent/grammar.grm (see Makefile for more
% information)
% if needed we can generate many more
sentenceFilename = 'sentence_data/sentence_1000samples.txt'

%% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
    'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});

%% extract word probabilities
pw = BNGetWordProbs(netobj_lab);

toplot = pw>word_threshold;
if create_figures
    figure;
    bar(pw(toplot));
    set(gca, 'xtick', 1:length(netobj_lab.WORDNODES(toplot)));
    set(gca, 'xticklabel', netobj_lab.nodeNames(netobj_lab.WORDNODES(toplot)));
    set(gca,'XTickLabelRotation',45);
    ylabel('$p(w_i)$', 'Interpreter','latex', 'FontSize', 20);
    print('-depsc', 'example_pw.eps');
end;

%% rescore sentences with word probabilities and pick best sentence
[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);

% find the best sentence
[bestprob, bestsentidx] = max(normlogprobs);
% ...and display it
sentences{bestsentidx}

% sort sentences:
[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');

% display n-best list
nbest = 10;
for h=1:nbest
    disp([sentences{sortedidxs(h)} ' ' num2str(normlogprobs(sortedidxs(h)))]);
end
