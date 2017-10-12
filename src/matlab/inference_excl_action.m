function result = inference_excl_action(netobj,posterior,prior,hmm_ev,action_map)

action_keys = keys(action_map);

result = 0;
for a = 1:length(hmm_ev)
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
    
    %% HMM part
    % given by hmm_ev, already re-ordered to follow BN action values order
    
    %% merge the evidence of the two models
    result = result + pred.T(a)*hmm_ev(a);
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