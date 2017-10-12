function result = inference_incl_action(netobj,posterior,prior,hmm_ev)

%% BN part
% enter node evidence for all prior nodes
netobj = BNEnterNodeEvidence(netobj, prior, 0);
% TODO enter word evidence if available

% extract predictions (posteriors)
pred = BNSoftPredictionAccuracy3(netobj, posterior);

%% HMM part
% given by hmm_ev, already re-ordered to follow BN action values order

%% merge the evidence of the two models
result = pred.T .* hmm_ev';

%% normalize to unitary sum
result = normalise(result);