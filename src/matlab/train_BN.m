% Training of Words-Affordances Bayesian Network
% see https://github.com/giampierosalvi/AffordancesAndSpeech by Giampiero Salvi
% script by Giovanni Saponaro, 2017

%% configure BNT and other paths
addpath(genpath('~/matlab/toolbox/FullBNT-1.0.4'))
addpath('.');

% words-affordances Bayesian Network
% 1. clone the repository https://github.com/giampierosalvi/AffordancesAndSpeech
% 2. then, set below the full path to AffordancesAndSpeech/bayesian_net
LanguageBoostrapping_root = ('~/NOBACKUP/AffordancesAndSpeech/bayesian_net');

addpath(genpath([LanguageBoostrapping_root '/matlab']))

%% 1) create initial word-affordance network
netobj_lab = createBN('config/networkDefinition.txt');

%% 2) set default properties (node types, initial connections...)
netobj_lab = BNSetDefaults(netobj_lab);

%% 3) load data from text file (coming from ../asr_htk/workdir)
netobj_lab = BNLoadData(netobj_lab, 'data/sent-1-5_lab_aff_bag.txt');

%% 3) learn the structure of the net
netobj_lab = BNLearnStructure(netobj_lab);

%% 4) learn the parameters of the net
netobj_lab = BNLearnParameters(netobj_lab);

%% save Bayesian Network to .mat
%save('BN_lab.mat', 'netobj_lab');