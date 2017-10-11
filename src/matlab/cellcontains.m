function found = cellcontains(cellarray,element)
% CELLCONTAINS  Verify if a cell array of strings contains one particular
%               string.
%
% Example:
% cellcontains({'a','b','c'},'a') = logical 1 (true)

if ~isstring(string(cellarray))
    error('cellcontains: cellarray argument must be a string array (cell array of strings).');
end;

if ~ischar(element)
    error('cellcontains: element argument must be a character array (i.e., a string).');
end;

% case insensitive
%found = any(strcmpi(cellarray,element));

% case sensitive
found = any(strcmp(cellarray,element));
