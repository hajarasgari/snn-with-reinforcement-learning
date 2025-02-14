clc;
LABEL_SIZE  = 16; 
TITLE_SIZE  = 18;

nTrial = 130;
nRun=3;
nBlock              = 30;
PerCorrectPerTrial  = zeros(nRun,nTrial);
FiringRatePerTrial  = cell(nRun,1);
FIndexPerTrial      = cell(nRun,1);
nIn                 = 6;
nHippo              = 8;
nOut                = 2;
nTimeTrial          = 801;
WeightLayer1To2     = zeros(nRun,nTrial,nIn,nHippo);
WeightLayer2To3     = zeros(nRun,nTrial,nHippo,nOut);

%[PerCorrect FiringRate FIndex W12perTrial W23perTrial RasterPlot] = ...
 %   spikingNetworkContextLearning(nTrial);
%[nTrial nStim nHippo] = size(FiringRate);
load Run_Output.txt

AllPerCorrects=Run_Output(:,1);
%fprintf('Overall percent correct trials: %2.2f.\n',sum(PerCorrect)/nTrial*120);

% *************************************************************************
% Plot the trajectory of percent correct trials.
% *************************************************************************
for iRun = 1:nRun,
        fprintf('Run %d.\n',iRun);
        rng(1+iRun); 
        
        PerCorrectPerTrial(iRun,:)  = AllPerCorrects((iRun-1)*nTrial+1:(iRun-1)*nTrial+nTrial);
        PerCorrect= AllPerCorrects((iRun-1)*nTrial+1:(iRun-1)*nTrial+nTrial);
        
        % *************************************************************************
        % Plot the trajectory of percent correct trials.
        % *************************************************************************
        TrialWindow = repmat(1/30,[30,1]);
        PerCorrect  = imfilter(double(PerCorrect),TrialWindow,'same',0)*100;
        TrialIndex  = 30:(nTrial-30); 
        PerCorrect  = PerCorrect(TrialIndex);
        figure('Name','Figure 3A', 'NumberTitle','off', 'Position',[50 50 800 500]);
        plot(TrialIndex,PerCorrect,'-k','LineWidth',1.5);
        xlabel('Sliding 30 Trial Window','FontSize',LABEL_SIZE);
        ylabel('Performance (Percent Correct)','FontSize',LABEL_SIZE);
        set(gca,'FontSize',LABEL_SIZE); 
        title(sprintf('N=%d',1),'FontSize',TITLE_SIZE);
        ylim([0 110]);
        hold on;
        plot([30 100],[100 100],'--k');
        
         
end

% *************************************************************************
% Figure for correct detection graph.
% *************************************************************************

TrialWindow         = repmat(1/30, [1 30]);
PerCorrectPerTrial  = imfilter(double(PerCorrectPerTrial),...
                               TrialWindow,'same',0)*100;
TrialIndex          = 30:100;
PerCorrectPerTrial  = PerCorrectPerTrial(:,TrialIndex);


figure('Name','Figure 3B', 'NumberTitle','off', 'Position',[50 50 800 500]);
errorarea(TrialIndex,mean(PerCorrectPerTrial),...
                     std(PerCorrectPerTrial),[.85 .85 .85],'k');
hold on
plot([30 100],[100 100],'--k');
%hold off
%axis([30 100 110]);
xlabel('Sliding 30 Trial Window','FontSize',LABEL_SIZE);
ylabel('Performance (Percent Correct)','FontSize',LABEL_SIZE);
set(gca,'FontSize',LABEL_SIZE);
title(sprintf('N=%d',nRun),'FontSize',TITLE_SIZE);



% *************************************************************************
% Figures for selectivity indices.
% *************************************************************************
nBin = 4;
%[nTrial nStim nHippo]   = size(FiringRatePerTrial{1});
nStim=8;
SIPosPerTrial           = zeros(nRun,nBin,nHippo);
SIItemPerTrial          = zeros(nRun,nBin,nHippo);
SIContextPerTrial       = zeros(nRun,nBin,nHippo);
opt.nBin                = nBin;
opt.nTrial              = nTrial;
opt.nCell               = nHippo;
opt.nStim               = nStim;

for iRun = 1:nRun,
    FiringRate                          = FiringRatePerTrial{iRun};
    [SIPos SIItem SIContext]            = firingRateToSI(FiringRate,opt);
    FIndex                              = FIndexPerTrial{iRun};
    SIPosPerTrial(iRun,:,:)             = SIPos;
    SIItemPerTrial(iRun,:,:)            = SIItem;
    SIContextPerTrial(iRun,:,:)         = SIContext;
    SIPosPerTrial(iRun,:,~FIndex)       = NaN;
    SIItemPerTrial(iRun,:,~FIndex)      = NaN;
    SIContextPerTrial(iRun,:,~FIndex)   = NaN;
end

SIPosPerTrial(SIPosPerTrial==0)         = NaN;
SIItemPerTrial(SIItemPerTrial==0)       = NaN;
SIContextPerTrial(SIContextPerTrial==0) = NaN;
MeanSIPos       = squeeze(meanWoutNaN(SIPosPerTrial,1));
SemSIPos        = squeeze(semWoutNaN(SIPosPerTrial,1));
MeanSIItem      = squeeze(meanWoutNaN(SIItemPerTrial,1));
SemSIItem       = squeeze(semWoutNaN(SIItemPerTrial,1));
MeanSIContext   = squeeze(meanWoutNaN(SIContextPerTrial,1));
SemSIContext    = squeeze(semWoutNaN(SIContextPerTrial,1));
XNAME = {'1st','2nd','3rd','4th'};
% *************************************************************************
% Selectivity index for place.
% *************************************************************************
figure('Name','Figur 5A', 'NumberTitle','off', ...
       'Position',[50 50 1200 600],'PaperPosition',[1 1 14 8]);
for iHippo = 1:nHippo,
    subplot(2,nHippo/2,iHippo);
        bar(MeanSIPos(:,iHippo),'EdgeColor',[0 0 0],'FaceColor',[0.7 0.7 0.7]);
        hold on;
        errorbar(1:4,MeanSIPos(:,iHippo),SemSIPos(:,iHippo),'k.','LineWidth',1.5);
        plot([1 4],[1 1],'--k','LineWidth',1.5);
        hold off;
        ylim([0 1.1]);
        set(gca,'XTick',[1 2 3 4],'XTickLabel',XNAME);
        ylabel('SI place','FontSize',LABEL_SIZE);
        set(gca,'FontSize',LABEL_SIZE);
        title(sprintf('Cell %d',iHippo),'FontSize',TITLE_SIZE);
end
print('-depsc',sprintf('%sFigureSIPlace.eps',figurePath));


