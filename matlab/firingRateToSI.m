function [SIPlace SIItem SIContext] = firingRateToSI(FiringRate,opt)
% firingRateToSI
%   FiringRate  - Matrix with the firing rate of dimensions: 
%                 nTrial x nStim x nCell.
%   opt         - Structure with fields:
%                 * nCell - Number of cells.
%                 * nStim - Number of stimuli.
%                 * nBin  - Number of bins used for the SI.
%
% RETURN
%   SIPlace     - Selectivity index for place.
%   SIItem      - Selectivity index for item.
%   SIContext   - Selectivity index for context.
%
% DESCRIPTION
%   Converts a firing rate into a selectivity index.

%   Florian Raudies, 07/22/2013, Boston University.

nCell   = opt.nCell;
nStim   = opt.nStim;
nBin    = opt.nBin;
nBlock  = 30;

% We calculate the mean firing rate over 30 trial blocks for each bin.
FiringRatePerBin = zeros(nBin,nStim,nCell);
for iBin = 1:nBin,
    FiringRatePerBin(iBin,:,:) = mean(FiringRate((iBin-1)*nBlock+(1:nBlock),:,:),1);
end

% *************************************************************************
% Selectivity Index for place.
% *************************************************************************
n = 4;
LambdaPlace         = zeros(nBin,n,nCell);
LambdaPlace(:,1,:)  = 0.5*(FiringRatePerBin(:,1,:) + FiringRatePerBin(:,5,:));
LambdaPlace(:,2,:)  = 0.5*(FiringRatePerBin(:,2,:) + FiringRatePerBin(:,6,:));
LambdaPlace(:,3,:)  = 0.5*(FiringRatePerBin(:,3,:) + FiringRatePerBin(:,7,:));
LambdaPlace(:,4,:)  = 0.5*(FiringRatePerBin(:,4,:) + FiringRatePerBin(:,8,:));
LambdaPref          = max(LambdaPlace,[],2);
SIPlace             = (n-sum(LambdaPlace./(eps ...
                                    +repmat(LambdaPref,[1 n 1])),2))/(n-1);
SIPlace(LambdaPref==0)  = 0;
SIPlace                 = squeeze(SIPlace);

% *************************************************************************
% Selectivity Index for item.
% *************************************************************************
n = 2;
LambdaItem          = zeros(nBin,n,nCell);
LambdaItem(:,1,:)   = 0.25*sum(FiringRatePerBin(:,1:4,:),2); % 1, 2, 3, 4
LambdaItem(:,2,:)   = 0.25*sum(FiringRatePerBin(:,5:8,:),2); % 5, 6, 7, 8
LambdaPref          = max(LambdaItem,[],2);
SIItem              = (n-sum(LambdaItem./(eps ...
                                    +repmat(LambdaPref,[1 n 1])),2))/(n-1);
SIItem(LambdaPref==0)   = 0;
SIItem                  = squeeze(SIItem);

% *************************************************************************
% Selectivity Index for context.
% *************************************************************************
n = 2;
LambdaContext       = zeros(nBin,n,nCell);
LambdaContext(:,1,:)= 0.25*sum(FiringRatePerBin(:,1:2:7,:),2); % 1, 3, 5, 7
LambdaContext(:,2,:)= 0.25*sum(FiringRatePerBin(:,2:2:8,:),2); % 2, 4, 6, 8
LambdaPref          = max(LambdaContext,[],2);
SIContext           = (n-sum(LambdaContext./(eps ...
                                    +repmat(LambdaPref,[1 n 1])),2))/(n-1);
SIContext(LambdaPref==0)= 0;
SIContext               = squeeze(SIContext);
