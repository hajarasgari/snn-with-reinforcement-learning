function plotBarStackGroups(stackData, groupLabels) 
%% Plot a set of stacked bars, but group them according to labels provided. 
%% 
%% Params: 
%% stackData is a 3D matrix (i.e., stackData(i, j, k) => (Group, Stack, StackElement)) 
%% groupLabels is a CELL type (i.e., { 'a', 1 , 20, 'because' };) 
%% 
%% Copyright 2011 Evan Bollig (bollig at scs DOT fsu ANOTHERDOT edu 
%% 
%%

NumGroupsPerAxis = size(stackData, 1); 
NumStacksPerGroup = size(stackData, 2);

% Count off the number of bins 
groupBins = 1:NumGroupsPerAxis; 
MaxGroupWidth = 0.65; % Fraction of 1. If 1, then we have all bars in groups touching 
groupOffset = MaxGroupWidth/NumStacksPerGroup; 
figure 
hold on; 
for i=1:NumStacksPerGroup

Y = squeeze(stackData(:,i,:)); 

% Center the bars: 

internalPosCount = i - ((NumStacksPerGroup+1) / 2); 

% Offset the group draw positions: 
groupDrawPos(i,:) = (internalPosCount)* groupOffset + groupBins; 

h = bar(Y, 'stacked'); 
set(h,'BarWidth',groupOffset); 
set(h,'XData',groupDrawPos(i,:)); 
end 
barLabels={'2000','2005','2010','2015'};

% Bar Labeling 
%for j=1:NumGroupsPerAxis 
%text(groupDrawPos(:,j),squeeze(sum(stackData(j,:,:),3)), barLabels,'VerticalAlignment','bottom','HorizontalAlignment','center'); 
%end 
hold off; 
Neuron={'Neuron 1' 'Neuron 2' 'Neuron 3' 'Neuron 4' 'Neuron 5' 'Neuron 6' 'Neuron 7' 'Neuron 8'};
%Neuron={'A1X' 'B1X' 'A2X' 'B2X' 'A1Y' 'B1Y' 'A2Y' 'B2Y'};
%yjob =Neuron;
legend(Neuron,'location','northeast')
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', {'B2Y' 'A1Y' 'B1Y' 'A2Y' 'B2X' 'A2X' 'B1X' 'A1X'})
%hBar = bar(D);
%yd = get(hBar, 'YData');
%barbase = cumsum([zeros(size(D,1),1) D(:,1:end-1)],2);
%joblblpos = D/2 + barbase;
%for k1 = 1:size(D,1)
 %  text(xt(k1)*ones(1,size(D,2)), joblblpos(k1,:), Neuron, 'HorizontalAlignment','center')
%end

ylabel('Number of Spikes','FontSize',14)
set(gca,'FontSize',14)
end