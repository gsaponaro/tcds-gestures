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

%% retain evidence?
incremental = false;

%% Action evidence from GestureHMM
hmm_ev = [0.8 0.1 0.1]; % HMM evidence in GestureHMM order: tap,grasp,touch
reorder = [2 1 3]; % TODO use get_remapping
hmm_ev_ordered = hmm_ev(:, reorder); % BNActionValue order: grasp,tap,touch

%% example counter
e = 1;

fprintf('case 1 examples (inference over nodes including Action)\n\n');
% =====================================================================

fprintf('%d.\n', e);

observed = {'Shape', 'circle', 'Size', 'small'}; % BN observed nodes
inferred = {'Action'}; % BN nodes to infer
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred;
e = e+1;

fprintf('%d.\n', e);

% Word nodes: repeat it to indicate presence, set to '-' to indicate absense
observed = {'Shape', 'circle', 'Size', 'small', 'moves', 'moves'};
inferred = {'Action'};
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred;
e = e+1;

fprintf('%d.\n', e);

observed = {'Shape', 'circle', 'Size', 'small', 'moves', 'moves', 'rolling', '-'};
inferred = {'Action'};
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred;
e = e+1;

fprintf('%d.\n', e);

observed = {'Color', 'yellow', 'Shape', 'circle'};
inferred = {'Action', 'ObjVel'};
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred;
e = e+1;

fprintf('%d.\n', e);

observed = {'ObjVel', 'fast', 'Shape', 'circle'};
inferred = {'Action', 'Color'};
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred;
e = e+1;

fprintf('case 2 examples (inference over nodes not including Action)\n\n');
% =====================================================================

fprintf('%d.\n', e);

observed = {'Shape', 'circle'};
inferred = {'Color'};
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred;
e = e+1;

fprintf('%d.\n', e);

observed = {'Shape', 'circle', 'Size', 'small'};
inferred = {'Color'};
fusion(netobj_lab, inferred, observed, hmm_ev_ordered, incremental);

clear observed inferred;
e = e+1;

% TODO: support case-2 queries with more than one inferred nodes,
%       such as inferred = {'ObjVel', 'Color'};
