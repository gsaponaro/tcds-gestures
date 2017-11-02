% MAIN  Run experiments related to merging of evidence from affordances
%       Bayesian Network with evidence from gesture Hidden Markov Model.
%
% Pre-requisites: install FullBNT and the words-affordances Bayesian
%                 Network code (see below).
%
% Giovanni Saponaro, Giampiero Salvi

%% configure BNT and other paths
configurePaths;

%% load Bayesian Network
load('BN_lab.mat');

%% map with possible values of a node
bn_map = make_bn_node_map(netobj_lab,'Action');

%% examples
e = 1; % example counter

%% retain evidence?
incremental = false;

fprintf('case 1 examples (inference over nodes including Action)\n\n');
% =====================================================================

fprintf('%d.\n', e);

observed = {'Shape', 'circle', 'Size', 'small'}; % BN observed nodes
inferred = {'Action'}; % BN nodes to infer
hmm_ev = [0.8 0.1 0.1]; % HMM evidence in GestureHMM order
% GestureHMM order: tap, grasp, touch
% BNActionValue order: grasp, tap, touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder); % HMM evidence in BNActionValue order
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred hmm_ev reorder hmm_ev_ordered result;
e = e+1;

fprintf('%d.\n', e);

% Word nodes: repeat it to indicate presence, set to '-' to indicate absense
observed = {'Shape', 'circle', 'Size', 'small', 'moves', 'moves'};
inferred = {'Action'};
hmm_ev = [0.8 0.1 0.1];
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred hmm_ev reorder hmm_ev_ordered result;
e = e+1;

fprintf('%d.\n', e);

observed = {'Shape', 'circle', 'Size', 'small', 'moves', 'moves', 'rolling', '-'};
inferred = {'Action'};
hmm_ev = [0.8 0.1 0.1];
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred hmm_ev reorder hmm_ev_ordered result;
e = e+1;

fprintf('%d.\n', e);

observed = {'Color', 'yellow', 'Shape', 'circle'};
inferred = {'Action', 'ObjVel'};
hmm_ev = [0.8 0.1 0.1];
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred hmm_ev reorder hmm_ev_ordered result;
e = e+1;

fprintf('%d.\n', e);

observed = {'ObjVel', 'fast', 'Shape', 'circle'};
inferred = {'Action', 'Color'};
hmm_ev = [0.8 0.1 0.1];
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred hmm_ev reorder hmm_ev_ordered result;
e = e+1;

fprintf('case 2 examples (inference over nodes not including Action)\n\n');
% =====================================================================

fprintf('%d.\n', e);

observed = {'Shape', 'circle'};
inferred = {'Color'};
hmm_ev = [0.8 0.1 0.1];
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred hmm_ev reorder hmm_ev_ordered result;
e = e+1;

fprintf('%d.\n', e);

observed = {'Shape', 'circle', 'Size', 'small'};
inferred = {'Color'};
hmm_ev = [0.8 0.1 0.1];
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder);
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred hmm_ev reorder hmm_ev_ordered result;
e = e+1;

% TODO: support case-2 queries with more than one inferred nodes,
%       such as inferred = {'ObjVel', 'Color'};
