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
% result: TODO describe

%
% Example:
% observed = {'Shape', 'circle', 'Size', 'small'};
% inferred = {'ObjVel'};
% hmm_ev = [0.8 0.1 0.1];
% reorder = [2 1 3];
% hmm_ev_ordered = hmm_ev(:, reorder);
% result = inference_excl_action(netobj,inferred,observed,hmm_ev_ordered);
% ->
% TODO print output
%
% Giovanni Saponaro, Giampiero Salvi

fprintf('\n');
fprintf('computing p( ');
fprintf('%s ', inferred{:});
fprintf('| ')
fprintf('%s ', observed{:});
fprintf(') ...\n');

action_keys = keys(action_map);
action_length = length(action_map);
action_size = size(action_map);

result = zeros(action_size);

for a = 1:action_length
    fprintf('action %d (%s):\n', a, action_keys{a});
    
    %% BN part

    % copy of inferred nodes to be modified only in this iteration
    temp_inferred = inferred;

    if ~cellcontains(temp_inferred,'Action')
        temp_inferred{end+1} = 'Action';
        %temp_inferred{end+1} = char(action_keys(a));
        %fprintf('DEBUG Action=%s...\n', char(action_keys(a)));
    end;

    % enter node evidence for all prior nodes
    netobj = BNEnterNodeEvidence(netobj, observed, 0);
    % TODO enter word evidence if available

    % extract predictions (posteriors)
    pred = BNSoftPredictionAccuracy3(netobj, temp_inferred);

    %fprintf(strrep(['... p_BN = (' num2str(pred.T', ' %f ') ')'], ',)', ''));
    
    %% HMM part
    % given by hmm_ev, already re-ordered to follow BN action values order

    fprintf(strrep(['\n... p_HMM = (' num2str(hmm_ev, ' %f ') ')'], ',)', ''));
    
    %% merge the evidence of the two models
end;

% normalize to unitary sum
%result = normalise(result);

% OLD
%     % location of the Action value node within the inferred string array
%     action_value_idx = get_node_index(inferred,'Action') + 1;
%     % HMM action number
%     hmm_a = gest_map(prior{action_value_idx});
%     % index within gest_vals array
%     a = find(gest_vals == hmm_a);