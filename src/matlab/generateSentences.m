% this is an example on how to generate descriptions from word
% probabilities:

%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat');

% 1000 sentences generated randomly accroding to the grammar in
% AffordanceAndSpeech/word2sent/grammar.grm (see Makefile for more
% information)
% if needed we can generate many more
sentenceFilename = 'sentence_data/sentence_1000samples.txt'

%% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
    'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});

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
