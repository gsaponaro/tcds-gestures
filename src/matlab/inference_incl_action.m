function [netobj, result] = inference_incl_action(netobj,inferred,observed,hmm_ev)
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
% netobj: updated Bayesian Network struct
%
% result: element-wise multiplication between Bayesian Network inference
%         and gesture Hidden Markov Model inference, i.e.,
%         p(Action,X1|X2,V) = p_BN(Action,X1|X2) .* p_HMM(Action|V)
%
% Giovanni Saponaro, Giampiero Salvi

fprintf('\n');
fprintf('computing P_comb( ');
fprintf('%s ', inferred{:});
fprintf('| ')
fprintf('%s ', observed{:});
fprintf(') ...\n');

%% BN copy for baseline calculations at the end
netobj2 = netobj;

%% BN part
% enter node evidence for all prior observed nodes
netobj = BNEnterNodeEvidence(netobj, observed);

% extract predictions (posteriors)
pred = marginal_prob(netobj, inferred);

fprintf('... P_BN =\n');
disp(pred.T);
    
%% HMM part
% given by hmm_ev, already re-ordered to follow BN action values order

fprintf(strrep(['... P_HMM = (' num2str(hmm_ev, ' %f ') ')'], ',)', ''));
fprintf('\n');

%% merge the evidence of the two models

% first, construct aux vector to be like size(inferred), except for the
% Action dimension entry, where it will be 1. Example:
% inferred = {'Action', 'Color'} -> size=[3 4] -> sizes_for_repmat=[1 4]
sizes_for_repmat = [];
num_inferred_nodes = length(inferred);
actnode_idx = get_node_index(inferred, 'Action'); % position of 'Action'
for d = 1:num_inferred_nodes
    if d==actnode_idx
        sizes_for_repmat = [sizes_for_repmat 1];
    else
        sizes_for_repmat = [sizes_for_repmat length(make_bn_node_map(netobj,inferred{d}))]; % TODO optimize
    end;
end;

% stack repetitions of hmm_ev appropriately for the multiplication below
hmm_ev_rep = repmat(hmm_ev', sizes_for_repmat);

%% element-wise multiplication
result = bsxfun(@times, pred.T, hmm_ev_rep);

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
%this warning is printed also when the matrices seem equal - maybe some
%slight decimal values differ?
% if result ~= pred2.T
%     warning('inference_incl_action: our result differs from BNT''s result!');
% end;