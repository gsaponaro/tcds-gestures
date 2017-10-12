function result = inference_incl_action(netobj,posterior,prior,hmm_ev)

fprintf('\n');
fprintf('computing p( ');
fprintf('%s ', posterior{:});
fprintf('| ')
fprintf('%s ', prior{:});
fprintf(') ...\n');

%% BN part
% enter node evidence for all prior nodes
netobj = BNEnterNodeEvidence(netobj, prior, 0);
% TODO enter word evidence if available

% extract predictions (posteriors)
pred = BNSoftPredictionAccuracy3(netobj, posterior);

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