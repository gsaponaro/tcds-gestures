function index = get_node_index(cellarray,node)
% GET_NODE_INDEX  Compute the node location index (integer) of a string
%                 within a string array.
%
% Example:
% get_node_index({'a','b','c'},'c') = 3

unfiltered_index = find(ismember(cellarray, node));

if ~isempty(unfiltered_index)
    index = unfiltered_index;
else
    index = -1; % error value
end;