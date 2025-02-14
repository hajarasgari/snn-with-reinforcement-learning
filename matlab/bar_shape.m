
%% Diagram time_trial_event_driven
clc; close all;
load time_trial_event_driven.txt
trial_time=zeros(100,1); 
trial_time1=time_trial_event_driven(:,1);
trial_time = trial_time1(30:130);
mean_time=mean(trial_time);
stairs(trial_time,'-','LineWidth',1.4);
xlim([1 100])
xlabel('# Trial','FontSize',1);
ylabel('Processing Time (ms)','FontSize',15);
set(gca,'FontSize',15);
%%
reward=[0 0 0 0 0 0   1  1  0 1  0 1  1  1   0 0 0 0 0 0  0 0  0 1   0 0 0 0 0 1   ];
move  =[1 1 1 1 1 0   0  0  1 0  1 0  0  0   1 1 1 1 1 0  1 0  1 0   1 1 1 1 1 0   ];
dig   =[0 0 0 0 0 1   1  1  0 1  0 1  0  0   0 0 0 0 0 1  0 1  0 1   0 0 0 0 0 1   ];
x=(1:1:length(move))
figure (5);
plot (x,3*reward,'.',x, 2*dig,'.',x, move, '.');
ylim([0 4])




%%


diagram_event_driven =[ 0           0           0           0           0           0           0           0;
                      350           0         653           0        1169         311        1407           0;
                     1363         357        1045         102         723           0         695           0;
                        0           0           0         557           0         160           0           0;
                        0           0           0           0           0           0           0           0;
                        0           0           0         209           0         685           0         559;
                        0           0           0          90           0         198           0           0;
                        0           0           0           0           0           0           0           0];

sum_diagram_event_driven=sum(diagram_event_driven);
sum__total_diagram_event_driven=sum(sum_diagram_event_driven);
%bar(diagram)
%title('Total forest')
%xlabel('Neurons')
%ylabel('Number of Spikes')

diagram_computational =[ 0           0           0           0           0           0           0           0;
                         0           0           0           0          68         20           88           0;
                         0           0           0           0           0           0           0           0;
                         0           0           0           0           0           0           0           0;
                       137          18         233          25           3           0           0           0;
                         0           0           0           0           0         162          43         126;
                         0           0           0           0           0           0           0           0;
                        24         145           0         102          29          25           0           3];

sum_diagram_computational=sum(diagram_computational); 
sum_total_diagram_computational= sum(sum_diagram_computational);

diagram_FPGA_computa1 =[ 0           0           0           0           0         168           9         126;
                        0           0           0           0           0           0           0           0;
                        0           0           0           0           0           0           0           0;
                      126           0         131           0          10           0           0           0;
                        0           0           0           0          70           0          45           0;
                        0           0           0           0           0           0           0           0;
                        0           0           0           0           0           0           0           0;
                        5          45           0          90           0           0           0           0];  
diagram_FPGA_computa2 =[ 15    25     0     0    37   154     5   102; %%% more important--reported in the paper
                         0     0     0     0    55     0    90     0;
                         0    14     0     0    13    13     4     0;
                         0     0     5     0     0     0    20     0;
                        182     5   106    65     5     0     0     0;
                        0    15    10    35     0     0     0     0;
                         0     0     5     0     0     0    10     0;
                         0     0     0     0     0     0     0     0];
sum_diagram_FPGA_computa=sum(diagram_FPGA_computa2);     
total_sum_diagram_FPGA_computa = sum (sum_diagram_FPGA_computa);
                    
%% Diagram sum spikes                    

diagram_sum=[sum_diagram_FPGA_computa;
             sum_diagram_computational;
             sum_diagram_event_driven];
D_sum=rot90(diagram_sum);         
%D = rot90(diagram_FPGA_computa);
D=rot90(diagram_sum); 
bar_handle=bar(D)
Neuron={'Computational [14]' 'This work' 'Event-driven [18]'};
legend(Neuron,'location','northeast');
legend(Neuron,'location','northeast');
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', {'B2Y' 'A1Y' 'B1Y' 'A2Y' 'B2X' 'A2X' 'B1X' 'A1X'})
ylabel('Number of Spikes','FontSize',15)
set(gca,'FontSize',15)
%figure(1) 

%xt = get(gca, 'XTick');
%set(gca, 'XTick', xt, 'XTickLabel', {'Neuron 1' 'Neuron 2' 'Neuron 3' 'Neuron 4' 'Neuron 5' 'Neuron 6' 'Neuron 7' 'Neuron 8'})
%yd = get(hBar, 'YData');
%yjob = {' A1X' ' A2Y' 'A1Y' 'A2X' 'B1Y' 'B2X' 'B1X' 'B2Y'};
%barbase = cumsum([zeros(size(D,1),1) D(:,1:end-1)],2);
%joblblpos = D/2 + barbase;
%for k1 = 1:size(D,1)
%   text(xt(k1)*ones(1,size(D,2)), joblblpos(k1,:), yjob, 'HorizontalAlignment','center')
%end
%ylabel('Number of Spikes')
%%
D=rot90(diagram_FPGA_computa2);
D1=rot90(diagram_computational);
D2=rot90(diagram_event_driven);
y=D;
y1=D1;
y2=D2;
bar_handle=bar(y,'stacked')
hold on
%bar_handle=bar(y1,'stacked')
%bar_handle=bar(y2,'stacked')
Neuron={'Neuron 1' 'Neuron 2' 'Neuron 3' 'Neuron 4' 'Neuron 5' 'Neuron 6' 'Neuron 7' 'Neuron 8'};
%Neuron={'A1X' 'B1X' 'A2X' 'B2X' 'A1Y' 'B1Y' 'A2Y' 'B2Y'};
%yjob =Neuron;
legend(Neuron,'location','northeast')
%legend(Neuron,'location','southoutside');
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', {'B2Y' 'A1Y' 'B1Y' 'A2Y' 'B2X' 'A2X' 'B1X' 'A1X'})
%hBar = bar(D);
%yd = get(hBar, 'YData');
barbase = cumsum([zeros(size(D,1),1) D(:,1:end-1)],2);
joblblpos = D/2 + barbase;
%for k1 = 1:size(D,1)
 %  text(xt(k1)*ones(1,size(D,2)), joblblpos(k1,:), Neuron, 'HorizontalAlignment','center')
%end
 
ylabel('Number of Spikes','FontSize',15)
set(gca,'FontSize',15)
set(bar_handle(1),'FaceColor','c') ;
%set(bar_handle(2),'FaceColor','b') ;
%set(bar_handle(3),'FaceColor','y') ;
%set(bar_handle(4),'FaceColor','g') ;
%set(bar_handle(5),'FaceColor','m') ;
%set(bar_handle(6),'FaceColor','r') ;
%set(bar_handle(7),'FaceColor','k') ;
