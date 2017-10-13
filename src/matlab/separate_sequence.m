function c = separate_sequence(matr, limits)
%SEPARATE_SEQUENCE(matr, limits)
%  Separate a data matrix containing many gestures
%
%  Inputs
%
%  MATR:   matrix with gesture data of a whole sequence [frames x dms]
%  LIMITS: 2xW matrix containing segment boundaries, for example
%          LIMITS=[1 8; 3 15] means that there are W=2 gestures to
%          separate, one in frames 1-3 and the other in frames 8-15
%
%  Outputs
%
%  C{W}:   cell array whose w'th entry contains w'th gesture data
%
% See also: complement_boundaries (computes the complement segments).
%
% Giovanni Saponaro <gsaponaro@isr.ist.utl.pt>
% Stockholm and Lisbon, 2012

[r_limits, W] = size(limits);
if r_limits ~= 2
    error('separate_sequence: LIMITS should have 2 rows');
end;

c = cell(1,W);

for w = 1:W
    
    c{w} = matr(limits(1,w):limits(2,w), :);
    
end;
