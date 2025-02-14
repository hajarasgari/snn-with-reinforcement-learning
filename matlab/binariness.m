function X = binariness(X)
% binariness
%   X   - Input values (N-dimensional matrix)
%
% RETURN 
%   X   - Output values (N-dimensional matrix)
%
% DESCRIPTION
%   The measure of binariness maps values between 0...1 to 0...1 with 0.5
%   being the minimum 0 and 0 or 1 being the maximum 1. Here, we use the
%   parabola:
%   y = 4 (x - 0.5)^2

%   Florian Raudies, 09/07/2014, Boston University.

X = 4*(X-0.5).^2;