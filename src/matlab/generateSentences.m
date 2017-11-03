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
[description, normprob] = BNScoreSentences(netobj_lab, sentenceFilename)

% note that this just shows the best sentence, for debugging it
% could be better to output the whole list with probabilities. I
% might add at least the possiblity to get an n-best list.
