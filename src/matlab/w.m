%% experiments with probability of words being said

addpath(genpath('~/matlab/toolbox/FullBNT-1.0.4'));
addpath('.');
addpath('./robot_data'); % robot self-exploration data, words-affordances BN

LanguageBoostrapping_root = ('~/NOBACKUP/AffordancesAndSpeech/bayesian_net');
if exist(LanguageBoostrapping_root, 'file')==0
    LanguageBoostrapping_root = ('~/Documents/AffordancesAndSpeech/bayesian_net');
end

addpath(genpath([LanguageBoostrapping_root '/matlab']));

%% load Bayesian Network from .mat
load('BN_lab.mat');

%% enter a non-word evidence, get W, enter more evidence, get W
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'green1'});
w1 = BNGetWordProbs(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
w2 = BNGetWordProbs(netobj_lab);

%% enter a word evidence, get W, enter more evidence, get W
%% -> not OK because the marginals of word-nodes-with-evidence have
%%    size 1 instead of 2
netobj_lab = BNEnterWordEvidence(netobj_lab, {'the'}); % equivalent to EnterNodeEvidence {'the','the'}
w3 = BNGetWordProbs(netobj_lab);
netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
w4 = BNGetWordProbs(netobj_lab);
