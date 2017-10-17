function result = inference_excl_action(netobj,inferred,observed,hmm_ev,action_map)
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
% action_map: (optional) map container with action names and indexes
%
% Outputs
%
% result: element-wise multiplication between Bayesian Network inference
%         (with the Action variable marginalized out) and gesture Hidden
%         Markov Model inference, i.e.,
%         p(X1|X2,V) = sum_{a=1}^{num_actions} p_BN(Action=a,X1|X2) .* p_HMM(Action=a|V)
%
% Giovanni Saponaro, Giampiero Salvi

if cellcontains(observed,'Action')
    perror('inference_excl_action: Action is already observed by BN, case not implemented');
    perror('NOTE: if Action is already observed by BN, why even merge it with HMM?');
end;

fprintf('\n');
fprintf('computing p( ');
fprintf('%s ', inferred{:});
fprintf('| ')
fprintf('%s ', observed{:});
fprintf(') ...\n');

action_names = keys(action_map);
num_actions = length(action_map);
%action_size = size(action_map)

%% BN part

% copy of inferred augmented with 'Action' var, to be marginalized out
temp_inferred = inferred;
if ~cellcontains(temp_inferred,'Action')
    temp_inferred{end+1} = 'Action';
else
    warning('inference_excl_action: inferred already contains Action');
end;
fprintf('DEBUG temp_inferred = ');
fprintf('%s ', temp_inferred{:});
fprintf('\n');

% enter node evidence for all prior nodes
netobj = BNEnterNodeEvidence(netobj, observed, 0);
% TODO enter word evidence if available

% extract predictions (posteriors)
pred = BNSoftPredictionAccuracy3(netobj, temp_inferred);

fprintf('... whole p_BN =\n');
disp(pred.T);

actnode_idx = get_node_index(temp_inferred, 'Action'); % position of 'Action'

%% HMM part
% given by hmm_ev, already re-ordered to follow BN action values order

fprintf(strrep(['\n... p_HMM = (' num2str(hmm_ev, ' %f ') ')'], ',)', ''));
fprintf('\n');

hmm_ev_rep = hmm_ev';

% for a = 1:num_actions
%     fprintf('\nDEBUG action %d (%s):\n', a, action_names{a});
%     
%     fprintf('DEBUG we take entry %d -> \n', a);
%     % ugly hack, TODO generalize
%     if actnode_idx==1
%         disp(pred.T(a,:,:,:));
%     elseif actnode_idx==2
%         disp(pred.T(:,a,:,:));
%     elseif actnode_idx==3
%         disp(pred.T(:,:,a,:));
%     elseif actnode_idx==4
%         disp(pred.T(:,:,:,a));
%     else
%         perror('reference_excl_action: queries of this complexity not implemented');
%     end;
%     
%     %% merge the evidence of the two models
% end;

%% matrix multiplication
fprintf('\nDEBUG going to multiply %s by %s...\n', mat2str(size(pred.T)), mat2str(size(hmm_ev_rep)));
result = pred.T * hmm_ev_rep;
fprintf('\n... result (not normalized) =\n');
disp(result);

% fprintf('\nDEBUG ground truth:\n');
% other_map = make_bn_node_map(netobj,inferred{1}); % Color
% num_other = length(other_map);
% gt = zeros(num_other,1);
% for c = 1:num_other
%     curr = 0;
%     for a = 1:num_actions
%         curr = curr + pred.T(c,a)*hmm_ev_rep(a);
%     end;
%     gt(c) = curr;
% end;
% gt

%% normalize to unitary sum (along which dimension? always the Action one?)
%result = normalise(result);

%% compute original BN query without marginalizing out Action, for comparison
fprintf('\nfor comparison, the result purely with BN (ignoring HMM) would be:\n');
netobj = BNEnterNodeEvidence(netobj, observed, 0);
pred_only_bn = BNSoftPredictionAccuracy3(netobj, inferred);
disp(pred_only_bn.T);