function D = semWoutNaN(D, dim)
% semWoutNaN
%   D   - N-dimensional data matrix.
%   dim - Dimension to calculate mean over.
%
% RETURN
%   D   - (N-1)-dimensional data matrix. In Matlab dimension dim is
%         retained and set to the value of 1.
%
% DESCRIPTION
%   Calculate the standard error of the mean (SEM) of D along dimension dim 
%   excluding NaN entries.

%   Florian Raudies, 09/07/2014, Boston University.


Dim         = ones(1,length(size(D)));
Dim(dim)    = size(D,dim);
Index       = isnan(D);
D(Index)    = 0;

% Number of elements in that dimension.
N  = size(D,dim) - sum(Index,dim);
% Mean over that dimension.
M = sum(D,dim)./(eps+N);
% Standard error of the mean.
D = sqrt(sum((~Index).*(D - repmat(M,Dim)).^2,dim))./(eps+N);