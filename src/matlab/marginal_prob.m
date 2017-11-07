function marg = marginal_prob(netobj, posteriornodes)
% MARGINAL_PROB  Compute the marginal probability of posterior node(s).
%
% Example:
% posteriornodes = {'ObjVel'};
% nodevaluepairs = {'Action', 'tap', 'Shape', 'box', 'Size', 'big'};
% netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs, 0);
% predictions = marginal_prob(netobj_lab, posteriornodes);
% -> predictions.T now contains the distribution of posteriornodes
%
% Note:
% This function is equivalent to the first part of BNSoftPredictionAccuracy
%
% Giampiero Salvi, Giovanni Saponaro

% from strings to integers
predictionNodes = cellfun(@(x) BNWhichNode(netobj,x), posteriornodes);

marg = marginal_nodes(netobj.engine, predictionNodes);
