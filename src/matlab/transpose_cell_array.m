function transposed = transpose_cell_array(cell_array)
%TRANSPOSE_CELL_ARRAY Transpose all matrices of a cell array
%
% Inputs:
%
% Outputs:
%
% Giovanni Saponaro <gsaponaro@isr.ist.utl.pt>
% Stockholm and Lisbon, 2012

if ~iscell(cell_array)
    error('transpose_cell_array: input must be a cell array.');
end;

transposed = cellfun(@(a) a', cell_array, 'UniformOutput',false);