function result = fusion(netobj,posterior,prior,hmm_ev,action_map)
% FUSION  Fuse evidence from Bayesian Network with evidence from Hidden
%         Markov Model.
%
% netobj: Bayesian Network struct
%
% posterior: cell array of node names (strings) to infer
%
% prior: cell array pairs of node name and value name for the
%        BN observed nodes
%
% hmm_ev: array of probabilities obtained by Hidden Markov Model (i.e.,
%         the posterior probability distribution of the gesture classes)
%
% action_map: (optional) map container with action names and indexes
%
% Example where inference includes action node:
% netobj = fusion(netobj, {'Action'}, {'Color','yellow','Size','big'}, [0.8 0.1 0.1])
%
% Example where inference does not include action node:
% netobj = fusion(netobj, {'Size'}, {'Color','yellow'}, [0.8 0.1 0.1])

%% checks
if nargin < 5
    % use default action_map
    action_keys = {'grasp', 'tap', 'touch'};
    action_vals = [1 2 3];
    action_map = containers.Map(action_keys,action_vals);
end;

if ~isstring(string(posterior))
    error('fusion: posterior argument must be a string array (cell array of strings).');
end;

if ~iscell(prior)
    error('fusion: prior argument must be a cell array.');
end;

if sum(hmm_ev) ~= 1
    error('fusion: phmm argument elements must sum to one.');
end;

%% determine the type of fusion and apply it
if cellcontains(posterior,'Action')
    % case 1: posterior nodes include action
    result = inference_incl_action(netobj,posterior,prior,hmm_ev);
else
    % case 2: posterior nodes do not include action
    result = inference_excl_action(netobj,posterior,prior,hmm_ev,action_map);
end