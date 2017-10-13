function marg = BNSoftPredictionAccuracy3(netobj, posteriornodes)
% BNSOFTPREDICTIONACCURACY3  Compute the marginal probability of
%                            specified posterior node(s).
%
% Example:
% posteriornodes = {'ObjVel'};
% nodevaluepairs = {'Action', 'tap', 'Shape', 'box', 'Size', 'big'};
% netobj_lab = BNEnterNodeEvidence(netobj_lab, nodevaluepairs, 0);
% predictions = BNSoftPredictionAccuracy3(netobj_lab, posteriornodes);
% -> predictions.T now contains the distribution of posteriornodes
%
% Note:
% The name of this function is not intuitive. It was chosen to be
% similar to BNSoftPredictionAccuracy, because it replicates the first
% part of that function (the one that computes the predictions).
%
% Giampiero Salvi, Giovanni Saponaro

% from strings to integers
predictionNodes = cellfun(@(x) BNWhichNode(netobj,x), posteriornodes);

marg = marginal_nodes(netobj.engine, predictionNodes);
