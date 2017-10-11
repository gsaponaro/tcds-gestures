function netobj = fusion(bn,posterior,prior,phmm)
% FUSION  Fuse evidence from Bayesian Network with evidence from Hidden
%         Markov Model.
%
% posterior: cell array of node names (strings) to infer.
%
% prior: cell array pairs of node name and value name for the
%        BN observed nodes.

% phmm: array of probabilities obtained by Hidden Markov Model (i.e.,
%       the posterior probability distribution of the gesture classes).
%
% incremental: retains evidence specified so far (default true).
%
% Example:
% netobj = fusion(netobj, {'Action'}, {'Color','yellow','Size','big'}, [0.8 0.1 0.1])

%% checks
if ~isstring(string(posterior))
    error('fusion: posterior argument must be a string array (cell array of strings).');
end;

if ~iscell(prior)
    error('fusion: prior argument must be a cell array.');
end;

if sum(phmm) ~= 1
    error('fusion: phmm argument elements must sum to one.');
end;

%% helper map of HMM gestures names->numbers
gest_keys =   {'tap', 'grasp', 'push'};
gest_vals = [1, 3, 4];
gest_map = containers.Map(gest_keys,gest_vals);

%% determine which type of fusion to apply
if (cellcontains(prior,'Action'))
    % location of the Action value node within the prior string array
    action_value_idx = get_node_index(prior,'Action') + 1;
    % HMM action index of the considered action
    a = gest_map(prior{action_value_idx});
    
    netobj = inference_incl_action(bn,posterior,prior,phmm(a));
else
    netobj = inference_excl_action(bn,posterior,prior,phmm);
end

%% helper functions

% case 1: posterior nodes include action
function ret = inference_incl_action(bn,posterior,prior,phmm_a)
    ret = pbn(bn,posterior,prior) * phmm_a;
end

% case 2: posterior nodes do not include action
function ret = inference_excl_action(bn,posterior,prior,phmm)
    ret = 0;
    for a = 1:size(phmm)
        ret = pbn(bn,posterior,prior) + phmm(a);
    end;
end