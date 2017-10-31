function indices = get_complement_word_indices(netobj, exclude_words)
% GET_COMPLEMENT_WORD_INDICES  Compute the list of all word indices minus
%                              the indices corresponding to a desired
%                              exclusion list.
%
% Inputs
%
% netobj: Bayesian Network struct, see also
%         https://github.com/giampierosalvi/AffordancesAndSpeech
%
% exclude_words: char array (string) of words that we want to exclude
%
% Outputs
%
% indices: an array with the indices corresponding to all words minus
%          the provided exclusion list
%
% Example:
%
% get_complement_word_indices(netobj_lab, {'blue','rolls'})
% = all the word indices minus 30 and 42
%
% Giovanni Saponaro

if ~isstring(string(exclude_words))
    error('get_complement_word_indices: exclude_words argument must be a string array (cell array of strings).');
end;

num_excl = length(exclude_words);
exclude_idx = zeros(1,num_excl);
for w = 1:num_excl
    exclude_idx(w) = get_node_index(netobj.nodeNames,exclude_words{w});
end;

indices = setdiff(netobj.WORDNODES, exclude_idx);