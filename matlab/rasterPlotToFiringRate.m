function FiringRate = rasterPlotToFiringRate(RasterPlot, opt)
% rasterPlotToFiringRate
%   RasterPlot  - Assumes that this is an object instance of ManySlotBuffer
%                 with dimensions: nSlots x nEntry x nData.
%   opt         - Structure with fields:
%                 * nTrial      - Number of trials.
%                 * nStim       - Number of stimuli.
%                 * nCell       - Number of cells.
%                 * nMaxSample  - Maximum number of samples per cell.
%                 * dt          - Time step in msec.
%
% RETURN
%   FiringRate - Matrix with firing rates per trial, stimulus, and cell.
%                The dimension of the matrix is:
%                nTrial x nStim x nCell.
%

%   Florian Raudies, 09/07/2014, Boston University.

nTrial      = opt.nTrial;
nStim       = opt.nStim;
nCell       = opt.nCell;
nMaxSample  = opt.nMaxSample;
dt          = opt.dt;
% Use a stack container to gather all the samples.
FiringRate          = zeros(nTrial,nStim,nCell);
FiringRateSamples   = StackContainer(nTrial*nStim*nCell,nMaxSample);
% For all slots (which are all stimuli and hippocampal cells combined).
for iSlot = 1:nStim*nCell,
    % Piece out the index for the stimulus and the hippocampal cell.
    [iStim iHippo]  = ind2sub([nStim nCell],iSlot);
    DataTrialSpike  = RasterPlot.getAllEntryForSlot(iSlot);
    % Get the spike counts from index 3 to the end.
    SpikeCount      = sum(DataTrialSpike(:,3:end),2);
    % Get the number of steps from the index 2.
    Steps           = DataTrialSpike(:,2);
    % Get the trial numbers from index 1.
    DataTrial       = DataTrialSpike(:,1);
    % Caclulcate the spike rate.
    nSample         = size(DataTrialSpike,1);
    SpikeRate       = SpikeCount./(Steps*dt);
    % For each sample add the spike rate for this data point composed of
    % trial, stimulus, and hippocampal cell index.
    for iSample = 1:nSample,
        iTrial = DataTrial(iSample);
        iData = sub2ind([nTrial nStim nCell],iTrial,iStim,iHippo);
        FiringRateSamples.push(iData, SpikeRate(iSample)); 
    end
end

% Convert all the computed firing rates from one trial, which could include
% different stimuli, into a mean firing rate. This happens if the same 
% stimulus occurs multiple times in a trial.
for iData = 1:nTrial*nStim*nCell,
    sumFiringRate = 0;
    nEntry = FiringRateSamples.numel(iData);
    if nEntry,
        while ~FiringRateSamples.empty(iData),
            sumFiringRate = sumFiringRate + FiringRateSamples.pop(iData);   
        end
        [iTrial,iStim,iHippo] = ind2sub([nTrial nStim nCell],iData);
        FiringRate(iTrial,iStim,iHippo) = sumFiringRate/nEntry;
    end
end

