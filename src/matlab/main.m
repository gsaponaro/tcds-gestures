% MAIN  Run experiments related to merging of evidence from affordances
%       Bayesian Network with evidence from gesture Hidden Markov Model.
%
% Pre-requisites: install FullBNT and the words-affordances Bayesian
%                 Network code (see below).
%
% Giovanni Saponaro, Giampiero Salvi

%% configure paths

% BNT
addpath(genpath('~/matlab/toolbox/FullBNT-1.0.4'));

addpath('.');
addpath('./robot_data'); % Bayesian Network

% gesture Hidden Markov Models
%test_path = [getenv('HOME') '/Dropbox/phd/work-2017/work-2017-05/glu2017_oni_videos'];

% words-affordances Bayesian Network
% 1. clone the repository https://github.com/giampierosalvi/AffordancesAndSpeech
% 2. then, set below the full path to AffordancesAndSpeech/bayesian_net
LanguageBoostrapping_root = ('~/NOBACKUP/AffordancesAndSpeech/bayesian_net');

addpath(genpath([LanguageBoostrapping_root '/matlab']))

%% load Bayesian Network from .mat
load('BN_lab.mat');

%% map of BN action names with corresponding indexes
node_idx = BNWhichNode(netobj_lab, 'Action'); % 1
bn_keys = netobj_lab.nodeValueNames{node_idx}; % {'grasp', 'tap', 'touch'}
bn_vals = zeros(1,3); % it will be [1 2 3]
for a = 1 : netobj_lab.node_sizes(node_idx)
    bn_vals(a) = BNWhichNodeValue(netobj_lab, node_idx, bn_keys{a});
end;
clear a;
bn_map = containers.Map(bn_keys,bn_vals);

%% map of HMM gesture names with corresponding indexes
hmm_keys = {'tap', 'grasp', 'push'};
hmm_vals = [1 2 3]; % hmm1 hmm3 hmm4 (hmm2 is touch, unused)
hmm_map = containers.Map(hmm_keys,hmm_vals);

%% case 1 example: inference over nodes including action
% BN observed nodes
observed = {'Shape', 'circle', 'Size', 'small'};
% BN nodes to infer
inferred = {'Action'};
% HMM evidence in GestureHMM order
hmm_ev = [0.8 0.1 0.1];
% HMM evidence in BNActionValue order
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
% do the HMM+BN merged inference
result1 = fusion(netobj_lab, inferred, observed, hmm_ev_ordered);

%% case 2 example: inference over nodes not including action
% BN priors
observed = {'Shape', 'circle', 'Size', 'small'};
% BN posteriors
inferred = {'ObjVel'};
% HMM evidence in GestureHMM order
hmm_ev = [0.8 0.1 0.1];
% HMM evidence in BNActionValue order
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
result2 = fusion(netobj_lab, inferred, observed, hmm_ev_ordered);
