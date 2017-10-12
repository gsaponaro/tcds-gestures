function netobj = fusion(netobj,posterior,prior,hmm_ev)
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
% incremental: retains evidence specified so far (default true)
%
% Example where inference includes action node:
% netobj = fusion(netobj, {'Action'}, {'Color','yellow','Size','big'}, [0.8 0.1 0.1])
%
% Example where inference does not include action node:
% netobj = fusion(netobj, {'Size'}, {'Color','yellow'}, [0.8 0.1 0.1])

%% checks
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
    case1 = inference_incl_action(netobj,posterior,prior,hmm_ev)
else
    % case 2: posterior nodes do not include action
    case2 = inference_excl_action(netobj,posterior,prior,hmm_ev)
en