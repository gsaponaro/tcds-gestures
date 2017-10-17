function result = fusion(netobj,inferred,observed,hmm_ev)
% FUSION  Fuse evidence from affordances Bayesian Network with evidence
%         from gesture Hidden Markov Model. This function automatically
%         chooses the correct merging strategy, depending on the presence
%         or absence of the action node among the list of inferred nodes
%         (i.e., posteriors).
%
% Inputs
%
% netobj: Bayesian Network struct, see also
%         https://github.com/giampierosalvi/AffordancesAndSpeech
%
% inferred: string array of the node names to do the inference on
%
% observed: cell array with pairs of node name and value name corresponding
%           to the Bayesian Network evidence
%
% hmm_ev: array of probabilities obtained from gesture Hidden Markov Model
%         (i.e., posterior probability distribution of the gesture classes)
%
% Outputs
%
% result: TODO describe
%
% Example where inference includes action node:
% netobj = fusion(netobj, {'Action'}, {'Color','yellow','Size','big'}, [0.8 0.1 0.1])
%
% Example where inference does not include action node:
% netobj = fusion(netobj, {'Size'}, {'Color','yellow'}, [0.8 0.1 0.1])

%% checks
if ~isstring(string(inferred))
    error('fusion: inferred argument must be a string array (cell array of strings).');
end;

if ~iscell(observed)
    error('fusion: observed argument must be a cell array.');
end;

if sum(hmm_ev) ~= 1
    error('fusion: hmm_ev argument elements must sum to one.');
end;

if cellcontains(observed,'Action')
    error('fusion: the case when Action is in the observed nodes is not yet implemented.');
end;

%% determine the type of fusion and apply it
if cellcontains(inferred,'Action')
    % case 1: inferred nodes include action
    result = inference_incl_action(netobj,inferred,observed,hmm_ev);
else
    % case 2: inferred nodes do not include action
    result = inference_excl_action(netobj,inferred,observed,hmm_ev);
end