%% configure BNT and other paths
configurePaths;

%% load data
load('BN_lab.mat');

% 1000 sentences generated randomly accroding to the grammar in
% AffordanceAndSpeech/word2sent/grammar.grm (see Makefile for more
% information)
% if needed we can generate many more
sentenceFilename = 'sentence_data/sentence_1000samples.txt';

%% example counter
e = 1;

%% Example in which the generated conjunction is ``and'' (because of
%% consistency between Action, Object Features and Effect evidence)

fprintf('%d.\n', e);

%% enter some evidence
netobj_lab = BNEnterNodeEvidence(netobj_lab, ...
    {'Size', 'small', 'Shape', 'box', 'Action', 'touch', 'Contact', 'long', 'ObjHandVel', 'slow'});

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

netobj_lab = BNResetEvidence(netobj_lab);
e = e+1;
fprintf('\n');

%% Example in which the generated conjunction is ``but'' (because of
%% no consistency between Action, Object Features and Effect evidence):

fprintf('%d.\n', e);

netobj_lab = BNEnterNodeEvidence(netobj_lab, ...
    {'Size', 'small', 'Shape', 'box', 'Action', 'touch', 'Contact', 'short', 'ObjHandVel', 'medium'});

[sentences, normlogprobs] = BNScoreSentences(netobj_lab, sentenceFilename);

[bestprob, bestsentidx] = max(normlogprobs);
sentences{bestsentidx}

[sortedprobs, sortedidxs] = sort(normlogprobs, 'descend');

nbest = 10;
for h=1:nbest
    disp([sentences{sortedidxs(h)} ' ' num2str(normlogprobs(sortedidxs(h)))]);
end
