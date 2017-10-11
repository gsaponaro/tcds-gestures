%% configure paths

% BNT
addpath(genpath('~/matlab/toolbox/FullBNT-1.0.4'));

% current directory
addpath('.');

% gesture Hidden Markov Models
test_path = [getenv('HOME') '/Dropbox/phd/work-2017/work-2017-05/glu2017_oni_videos'];

% words-affordances Bayesian Network
% 1. clone the repository https://github.com/giampierosalvi/AffordancesAndSpeech
% 2. then, set below the full path to AffordancesAndSpeech/bayesian_net
LanguageBoostrapping_root = ('~/NOBACKUP/AffordancesAndSpeech/bayesian_net');

addpath(genpath([LanguageBoostrapping_root '/matlab']))

%% load Bayesian Network from .mat
load('BN_lab.mat');

% netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Color', 'yellow', ...
%     'Size', 'big', 'Shape', 'circle', 'ObjVel', 'fast'});
% probs = BNGetWordProbs(netobj_lab);
% netobj_lab = BNEnterNodeEvidence(netobj_lab, {'Action', 'tap'});
% probs2 = BNGetWordProbs(netobj_lab);
