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

%% map of BN action names with corresponding indexes
node_idx = BNWhichNode(netobj_lab, 'Action'); % 1
bn_a_keys = netobj_lab.nodeValueNames{node_idx}; % {'grasp', 'tap', 'touch'}
bn_a_vals = [];
for a = 1 : netobj_lab.node_sizes(node_idx)
    bn_a_vals = [bn_a_vals BNWhichNodeValue(netobj_lab, node_idx, bn_a_keys{a})];
end;
clear a;
% bn_a_vals = [1 2 3]
bn_a_map = containers.Map(bn_a_keys,bn_a_vals);

%% map of HMM gesture names with corresponding indexes
hmm_g_keys = {'tap', 'grasp', 'push'};
hmm_g_vals = [1 2 3]; % hmm1 hmm3 hmm4 (hmm2 is touch, unused)
hmm_g_map = containers.Map(hmm_g_keys,hmm_g_vals);

%% case 1 example: inference over nodes including action
% BN priors
nodevaluepairs = {'Shape', 'circle', 'Size', 'small'};
% BN posteriors
posteriornodes = {'Action'};
% HMM evidence in GestureHMM order
phmm = [0.8 0.1 0.1];
% HMM evidence in BNActionValue order
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = phmm(:, reorder);
result1 = fusion(netobj_lab, posteriornodes, nodevaluepairs, hmm_ev_ordered);

%% case 2 example: inference over nodes not including action
% BN priors
nodevaluepairs = {'Shape', 'circle', 'Size', 'small'};
% BN posteriors
posteriornodes = {'ObjVel'};
% HMM evidence in GestureHMM order
phmm = [0.8 0.1 0.1];
% HMM evidence in BNActionValue order
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = phmm(:, reorder);
result2 = fusion(netobj_lab, posteriornodes, nodevaluepairs, hmm_ev_ordered);