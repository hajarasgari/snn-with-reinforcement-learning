LABEL_SIZE  = 16;
TITLE_SIZE  = 18;
nTrial = 130;
nRun=1;
%[PerCorrect FiringRate FIndex W12perTrial W23perTrial RasterPlot] = ...
 %   spikingNetworkContextLearning(nTrial);
%[nTrial nStim nHippo] = size(FiringRate);
load output.txt
PerCorrect=output(:,1);
fprintf('Overall percent correct trials: %2.2f.\n',sum(PerCorrect)/nTrial*120);

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
title(sprintf('N=%d',nRun),'FontSize',TITLE_SIZE);
ylim([0 110]);
hold on;
plot([30 100],[100 100],'--k');
%set(gca,LABEL_SIZE);
%axis([30 nTrial-30 0 110]);
%print('-deps',sprintf('%sFigurePercentCorrect%d.eps',figurePath,1));






nTrial = 130;
nRun=100;
PerCorrectPerTrial=zeros(nRun,nTrial)
%[PerCorrect FiringRate FIndex W12perTrial W23perTrial RasterPlot] = ...
 %   spikingNetworkContextLearning(nTrial);
%[nTrial nStim nHippo] = size(FiringRate);
load Run_Output_test1.txt

AllPerCorrects=Run_Output_test1(:,1);
%fprintf('Overall percent correct trials: %2.2f.\n',sum(PerCorrect)/nTrial*120);

% *************************************************************************
% Plot the trajectory of percent correct trials.
% *************************************************************************
for iRun = 1:nRun,
        fprintf('Run %d.\n',iRun);
        rng(1+iRun);
        
        PerCorrectPerTrial(iRun,:)  = AllPerCorrects((iRun-1)*nTrial+1:(iRun-1)*nTrial+nTrial);
end

TrialWindow         = repmat(1/30, [1 30]);
PerCorrectPerTrial  = imfilter(double(PerCorrectPerTrial),...
                               TrialWindow,'same',0)*100;
TrialIndex          = 30:100;
PerCorrectPerTrial  = PerCorrectPerTrial(:,TrialIndex);

%subplot(1,2,2)
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
%xlabel('Sliding 30 Trial Window','FontSize',LABEL_SIZE);
%ylabel('Performance (Percent Correct)','FontSize',LABEL_SIZE);


print('-deps',sprintf('%sFigurePercentCorrect%dRuns.eps',figurePath,nRun));
