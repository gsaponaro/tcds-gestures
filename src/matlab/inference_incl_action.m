function result = inference_incl_action(netobj,inferred,observed,hmm_ev)
% INFERENCE_INCL_ACTION  Compute an inference from the combined affordances
%                        Bayesian + gesture Hidden Markov Model, in the case
%                        where the inferred nodes (i.e., posteriors)
%                        *include* the action node which is common between
%                        the two sub-models.
%                        This corresponds to just multiplying (element-wise
%                        multiplication) the probabilities coming from the
%                        two sub-models.
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
% Example:
% observed = {'Shape', 'circle', 'Size', 'small'};
% inferred = {'Action'};
% hmm_ev = [0.8 0.1 0.1];
% reorder = [2 1 3];
% hmm_ev_ordered = hmm_ev(:, reorder);
% result = inference_incl_action(netobj,inferred,observed,hmm_ev_ordered);
% ->
% computing p( Action | Shape circle Size small ) ...
% ... p_BN = (0.413323  0.421183  0.165493)
% ... p_HMM = (0.100000  0.800000  0.100000)
% ... => (0.104684  0.853400  0.041915)
%
% Giovanni Saponaro, Giampiero Salvi

fprintf('\n');
fprintf('computing p( ');
fprintf('%s ', inferred{:});
fprintf('| ')
fprintf('%s ', observed{:});
fprintf(') ...\n');

%% BN part
% enter node evidence for all prior nodes
netobj = BNEnterNodeEvidence(netobj, observed, 0);
% TODO enter word evidence if available

% extract predictions (posteriors)
pred = BNSoftPredictionAccuracy3(netobj, inferred);

fprintf(strrep(['... p_BN = (' num2str(pred.T', ' %f ') ')'], ',)', ''));

%% HMM part
% given by hmm_ev, already re-ordered to follow BN action values order

fprintf(strrep(['\n... p_HMM = (' num2str(hmm_ev, ' %f ') ')'], ',)', ''));

%% merge the evidence of the two models
result = pred.T .* hmm_ev';

%% normalize to unitary sum
result = normalise(result);

fprintf(strrep(['\n... => (' num2str(result', ' %f ') ')'], ',)', ''));
fprintf('\n');