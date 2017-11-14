% this is an example on how to generate descriptions from word
% probabilities:

%% configure BNT and other paths
close;
configurePaths;

%% load data
load('BN_lab.mat');

%% user parameters
% 10000 sentences generated randomly accroding to the grammar in
% AffordanceAndSpeech/word2sent/grammar.grm (see Makefile for more
% information)
% if needed we can generate many more
sentenceFilename = 'sentence_data/sentence_10000samples_uniq.txt';
nbest = 10;

%% first example \graspBoxGreenOne
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

%% second example \touchBoxGreenOne
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

%% third example \graspSphereGreenTwo
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

%% fourth example \touchSphereGreenTwo
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

%%
function displayNBest(sentences, sortedidxs, normlogprobs, nbest, pattern)
    n=1;
    for h=1:length(sortedidxs)
        if isempty(regexp(sentences{sortedidxs(h)}, pattern, 'once'))
            continue
        end
        disp([num2str(h) ': ' sentences{sortedidxs(h)} ' ' num2str(normlogprobs(sortedidxs(h)))]);
        n=n+1;
        if n>nbest
            break
        end
    end
end