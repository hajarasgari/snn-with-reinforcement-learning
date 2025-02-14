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
%title(sprintf('N=%d',nRun),'FontSize',TITLE_SIZE);
ylim([0 110]);
hold on;
plot([30 100],[100 100],'--k');
%set(gca,LABEL_SIZE);
%axis([30 nTrial-30 0 110]);
%print('-deps',sprintf('%sFigurePercentCorrect%d.eps',figurePath,1));
