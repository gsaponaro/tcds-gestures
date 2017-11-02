% Training of Words-Affordances Bayesian Network
% see https://github.com/giampierosalvi/AffordancesAndSpeech by Giampiero Salvi
% script by Giovanni Saponaro, 2017

%% configure BNT and other paths
configurePaths

%% 1) create initial word-affordance network
% Giampiero 2017-11-02: you need to be in AffordancesAndSpeech/bayesian_net
% to run the following command
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
% Giampiero 2017-11-02: you need to be in tcds-gestures/src/matlab/robot_data
% to run the following command
%save('BN_lab.mat', 'netobj_lab');