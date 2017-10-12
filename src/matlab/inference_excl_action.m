function result = inference_excl_action(netobj,posterior,prior,hmm_ev,action_map)

fprintf('\n');
fprintf('computing p( ');
fprintf('%s ', posterior{:});
fprintf('| ')
fprintf('%s ', prior{:});
fprintf(') ...\n');

action_keys = keys(action_map);

result = 0;
for a = 1:length(hmm_ev)
    fprintf('action %d (%s):\n', a, action_keys{a});
    
    %% BN part

    % to marginalize out the action, we will enter its hard evidence
    % for each possible value of it as a prior.

    % copy of prior to be modified only in this iteration
    temp_prior = prior;

    if ~cellcontains(temp_prior,'Action')
        temp_prior{end+1} = 'Action';
        temp_prior{end+1} = char(action_keys(a));
    end;

    % enter node evidence for all prior nodes
    netobj = BNEnterNodeEvidence(netobj, temp_prior, 0);
    % TODO enter word evidence if available

    % extract predictions (posteriors)
    pred = BNSoftPredictionAccuracy3(netobj, posterior);

    fprintf('\t p_BN=%f p_HMM=%f product=%f ', pred.T(a), hmm_ev(a), pred.T(a)*hmm_ev(a));
    
    %% HMM part
    % given by hmm_ev, already re-ordered to follow BN action values order
    
    %% merge the evidence of the two models
    result = result + pred.T(a)*hmm_ev(a);
    fprintf('result_so_far=%f\n', result);
end;

% normalize to unitary sum
%result = normalise(result);

% OLD
%     % location of the Action value node within the posterior string array
%     action_value_idx = get_node_index(posterior,'Action') + 1;
%     % HMM action number
%     hmm_a = gest_map(prior{action_value_idx});
%     % index within gest_vals array
%     a = find(gest_vals == hmm_a);