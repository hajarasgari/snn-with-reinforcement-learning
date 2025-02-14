function D = meanWoutNaN(D, dim)
% meanWoutNaN
%   D   - N-dimensional data matrix.
%   dim - Dimension to calculate mean over.
%
% RETURN
%   D   - (N-1)-dimensional data matrix. In Matlab dimension dim is
%         retained and set to the value of 1.
%
% DESCRIPTION
%   Calculate the mean of D along dimension dim excluding NaN entries.

%   Florian Raudies, 09/07/2014, Boston University.

Index   = isnan(D);
D(Index)= 0;
D       = sum(D,dim)./(eps+size(D,dim)-sum(Index,dim));