function [order] = get_remapping(map,dominant_map)
% GET_REMAPPING  Compute the ordering required to make a map consistent
%                with another dominant map.
%
% Example:
% map_keys = {'tap', 'grasp', 'push'};
% map_vals = [1 2 3];
% map = containers.Map(map_keys,map_vals);
% dominant_map_keys = {'grasp', 'tap', 'touch'}
% dominant_map_vals = [1 2 3];
% dominant_map = containers.Map(dominant_map_keys,dominant_map_vals);
% get_remapping(map,dominant_map) = [2 1 3]

ml = map.length;

if ml ~= dominant_map.length
    perror('get_remapping: the two maps must have equal length');
end;

% array of logical values
tf = isKey(map, dominant_map.keys);
if ~all(tf)
    warning('get_remapping: some of the keys of the first map differ from those of the second map.');
end;

% TODO hack mapping HMM touch to BN grasp

map_keys = keys(map);
dominant_map_keys = keys(dominant_map);

order = [];
for m = 1:ml
    order = [order get_node_index(dominant_map_keys,map_keys{m})];
end;