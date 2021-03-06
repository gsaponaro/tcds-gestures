function [netobj, result] = inference_excl_action(netobj,inferred,observed,hmm_ev)
% INFERENCE_EXCL_ACTION  Compute an inference from the combined affordances
%                        Bayesian + gesture Hidden Markov Model, in the case
%                        where the inferred nodes (i.e., posteriors)
%                        *do not* include the action node which is common
%                        between the two sub-models.
%                        This corresponds to entering the hard evidence
%                        for each action value into the BN, and then
%                        performing a sum.
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
% netobj: updated Bayesian Network struct
%
% result: matrix multiplication between Bayesian Network inference
%         (with the Action variable) and gesture Hidden Markov Model
%         inference, i.e.,
%         p(X1|X2,V) = sum_{a=1}^{num_actions} p_BN(Action=a,X1|X2) * p_HMM(Action=a|V)
%
% Giovanni Saponaro, Giampiero Salvi

if cellcontains(observed,'Action')
    error('inference_excl_action: Action is already observed by BN');
    error('not implemented');
end;

fprintf('\n');
fprintf('computing P_comb( ');
fprintf('%s ', inferred{:});
fprintf('| ')
fprintf('%s ', observed{:});
fprintf(') ...\n');

%% BN copy for baseline calculations at the end
netobj2 = netobj;

%% BN part

% copy of inferred augmented with 'Action' var, to be marginalized out
temp_inferred = inferred;
if ~cellcontains(temp_inferred,'Action')
    temp_inferred{end+1} = 'Action';
else
    warning('inference_excl_action: inferred already contains Action');
end;

% enter node evidence for all prior observed nodes
netobj = BNEnterNodeEvidence(netobj, observed);

% extract predictions (posteriors)
pred = marginal_prob(netobj, temp_inferred);

fprintf('... auxiliary P_BN( ');
fprintf('%s ', temp_inferred{:});
fprintf('| ')
fprintf('%s ', observed{:});
fprintf(') =\n');
disp(pred.T);

%% HMM part
% given by hmm_ev, already re-ordered to follow BN action values order

fprintf(strrep(['... P_HMM = (' num2str(hmm_ev, ' %f ') ')'], ',)', ''));
fprintf('\n');

%% merge the evidence of the two models

% reshape hmm_ev to a format suitable for matrix multiplication below
sizes_for_repmat = [1 1]; % TODO support queries with >1 inferred nodes
hmm_ev_rep = repmat(hmm_ev', sizes_for_repmat);

%% matrix multiplication
%fprintf('\nDEBUG going to multiply %s by %s...\n', mat2str(size(pred.T)), mat2str(size(hmm_ev_rep)));
result = pred.T * hmm_ev_rep;

% fprintf('\n... result (not normalized) =\n');
% disp(result);

%% normalize the whole matrix (joint probability) to unitary sum
result = normalize(result);

fprintf('\n... result (normalized) =\n');
disp(result);

%% BNT soft evidence
netobj2 = BNResetEvidence(netobj2);
netobj2 = BNEnterNodeEvidence(netobj2, observed, true, {'Action', hmm_ev});
pred2 = marginal_prob(netobj2, inferred);
fprintf('using purely BNT, P_comb =\n');
disp(pred2.T);

%% compute original BN query without marginalizing out Action, for comparison
fprintf('for comparison, the result purely with BN (ignoring HMM) would be:\n');
fprintf('P_BN( ');
fprintf('%s ', inferred{:});
fprintf('| ')
fprintf('%s ', observed{:});
fprintf(') =\n');
netobj2 = BNResetEvidence(netobj2);
netobj2 = BNEnterNodeEvidence(netobj2, observed);
pred_only_bn = marginal_prob(netobj2, inferred);
disp(pred_only_bn.T);