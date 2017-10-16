function m = make_bn_node_map(netobj,nodename)
% MAKE_BN_NODE_MAP  Given a Bayesian Network node name, build a map
%                   container which has the node's possible names (strings)
%                   as keys, and the corresponding indexes as values.
%
% Inputs
%
% netobj: Bayesian Network struct, see also
%         https://github.com/giampierosalvi/AffordancesAndSpeech
%
% nodename: char array (string) of the Bayesian Network node
%
% Outputs
%
% m: a containers.Map object with the possible <name,index> pairs
%
% Example:
% make_bn_node_map(netobj_lab,'Action') -> {'grasp':1, 'tap':2, 'touch':3}
%
% Giovanni Saponaro

node_idx = BNWhichNode(netobj, nodename);
if isempty(node_idx)
    perror('make_bn_node_map: nodename argument must be a string (cell array) corresponding to a Bayesian Network node.');
end;

keys = netobj.nodeValueNames{node_idx};
node_size = netobj.node_sizes(node_idx);
vals = zeros(1,node_size);

for a = 1 : node_size
    vals(a) = BNWhichNodeValue(netobj, node_idx, keys{a});
end;
m = containers.Map(keys,vals);