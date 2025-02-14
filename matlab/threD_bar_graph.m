NumStacksPerGroup = 2; % 2
NumGroupsPerAxis = 8; %8
NumStackElements = 8; %8

%groupLabels = { 'Test'; 2; 4; 6; 8; -1; }; 
stackData = zeros(NumGroupsPerAxis,NumStacksPerGroup,NumStackElements);





diagram_event_driven =[ 0           0           0           0           0           0           0           0;
                      350           0         653           0        1169         311        1407           0;
                     1363         357        1045         102         723           0         695           0;
                        0           0           0         557           0         160           0           0;
                        0           0           0           0           0           0           0           0;
                        0           0           0         209           0         685           0         559;
                        0           0           0          90           0         198           0           0;
                        0           0           0           0           0           0           0           0];

diagram_FPGA_computa =[ 0           0           0           0           0         168           9         126;
                        0           0           0           0           0           0           0           0;
                        0           0           0           0           0           0           0           0;
                      126           0         131           0          10           0           0           0;
                        0           0           0           0          70           0          45           0;
                        0           0           0           0           0           0           0           0;
                        0           0           0           0           0           0           0           0;
                        5          45           0          90           0           0           0           0];                    

stackData(:,1,:)= rot90(diagram_FPGA_computa);        
stackData(:,2,:)= rot90(diagram_event_driven);  
groupLabels={'Neuron 1' 'Neuron 2' 'Neuron 3' 'Neuron 4' 'Neuron 5' 'Neuron 6' 'Neuron 7' 'Neuron 8'};
plotBarStackGroups(stackData, Neuron); 