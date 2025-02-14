clc; clear; close all;
nRun=1;
nBlock              = 30;
LABEL_SIZE  = 16;
TITLE_SIZE  = 18;
PlotIndex   = [1 3 5 7 2 4 6 8];
PlotName    = {'A','B','C','D','E','F', 'G','H'};
%PlotName    = {'A','B','C','D'};
CellIndex   = [1 2 3 4 5 6 7 8];
%CellIndex   = [2 3 5 7];
nTrial=130;           opt.nTrial=nTrial;
dt          = 0.1;    opt.dt=dt; % Tclk=100ns for simulations

nStim=8;              
nHippo=8;
nIn=6;
nOut=2;
nMaxTime    = 5000;   
nMaxSample  = 100;
opt.nMaxTime    = nMaxTime;
opt.nHippo      = nHippo;
opt.nTrial      = nTrial;
opt.nStim       = nStim;
opt.nCell       = nHippo;
opt.nMaxSample  = nMaxSample;
RasterPlot  = ManySlotBuffer(nStim*nHippo,nMaxSample,nMaxTime);
%%

load RP_0_s0.txt
load RP_0_s1.txt
load RP_0_s2.txt
load RP_0_s3.txt
load RP_0_s4.txt
load RP_0_s5.txt
load RP_0_s6.txt
load RP_0_s7.txt

load RP_1_s0.txt
load RP_1_s1.txt
load RP_1_s2.txt
load RP_1_s3.txt
load RP_1_s4.txt
load RP_1_s5.txt
load RP_1_s6.txt
load RP_1_s7.txt

load RP_2_s0.txt
load RP_2_s1.txt
load RP_2_s2.txt
load RP_2_s3.txt
load RP_2_s4.txt
load RP_2_s5.txt
load RP_2_s6.txt
load RP_2_s7.txt

load RP_3_s0.txt
load RP_3_s1.txt
load RP_3_s2.txt
load RP_3_s3.txt
load RP_3_s4.txt
load RP_3_s5.txt
load RP_3_s6.txt
load RP_3_s7.txt

load RP_4_s0.txt
load RP_4_s1.txt
load RP_4_s2.txt
load RP_4_s3.txt
load RP_4_s4.txt
load RP_4_s5.txt
load RP_4_s6.txt
load RP_4_s7.txt

load RP_5_s0.txt
load RP_5_s1.txt
load RP_5_s2.txt
load RP_5_s3.txt
load RP_5_s4.txt
load RP_5_s5.txt
load RP_5_s6.txt
load RP_5_s7.txt

load RP_6_s0.txt
load RP_6_s1.txt
load RP_6_s2.txt
load RP_6_s3.txt
load RP_6_s4.txt
load RP_6_s5.txt
load RP_6_s6.txt
load RP_6_s7.txt

load RP_7_s0.txt
load RP_7_s1.txt
load RP_7_s2.txt
load RP_7_s3.txt
load RP_7_s4.txt
load RP_7_s5.txt
load RP_7_s6.txt
load RP_7_s7.txt
%%


a=zeros(1,nHippo*nStim);

n0s0=RP_0_s0(:,1);  a(1)=length (n0s0);
n0s1=RP_0_s1(:,1);  a(2)=length (n0s1);
n0s2=RP_0_s2(:,1);  a(3)=length (n0s2);
n0s3=RP_0_s3(:,1);  a(4)=length (n0s3);
n0s4=RP_0_s4(:,1);  a(5)=length (n0s4);
n0s5=RP_0_s5(:,1);  a(6)=length (n0s5); 
n0s6=RP_0_s6(:,1);  a(7)=length (n0s6);
n0s7=RP_0_s7(:,1);  a(8)=length (n0s7);

n1s0=RP_1_s0(:,1);  a(9)= length (n1s0);
n1s1=RP_1_s1(:,1);  a(10)=length (n1s1);
n1s2=RP_1_s2(:,1);  a(11)=length (n1s2);
n1s3=RP_1_s3(:,1);  a(12)=length (n1s3);
n1s4=RP_1_s4(:,1);  a(13)=length (n1s4);
n1s5=RP_1_s5(:,1);  a(14)=length (n1s5);
n1s6=RP_1_s6(:,1);  a(15)=length (n1s6);
n1s7=RP_1_s7(:,1);  a(16)=length (n1s7);

n2s0=RP_2_s0(:,1);  a(17)=length (n2s0);
n2s1=RP_2_s1(:,1);  a(18)=length (n2s1);
n2s2=RP_2_s2(:,1);  a(19)=length (n2s2);
n2s3=RP_2_s3(:,1);  a(20)=length (n2s3);
n2s4=RP_2_s4(:,1);  a(21)=length (n2s4);
n2s5=RP_2_s5(:,1);  a(22)=length (n2s5);
n2s6=RP_2_s6(:,1);  a(23)=length (n2s6);
n2s7=RP_2_s7(:,1);  a(24)=length (n2s7);

n3s0=RP_3_s0(:,1);  a(25)=length (n3s0);
n3s1=RP_3_s1(:,1);  a(26)=length (n3s1);
n3s2=RP_3_s2(:,1);  a(27)=length (n3s2);
n3s3=RP_3_s3(:,1);  a(28)=length (n3s3);
n3s4=RP_3_s4(:,1);  a(29)=length (n3s4);
n3s5=RP_3_s5(:,1);  a(30)=length (n3s5);
n3s6=RP_3_s6(:,1);  a(31)=length (n3s6);
n3s7=RP_3_s7(:,1);  a(32)=length (n3s7);

n4s0=RP_4_s0(:,1);  a(33)=length (n4s0);
n4s1=RP_4_s1(:,1);  a(34)=length (n4s1);
n4s2=RP_4_s2(:,1);  a(35)=length (n4s2);
n4s3=RP_4_s3(:,1);  a(36)=length (n4s3);
n4s4=RP_4_s4(:,1);  a(37)=length (n4s4);
n4s5=RP_4_s5(:,1);  a(38)=length (n4s5);
n4s6=RP_4_s6(:,1);  a(39)=length (n4s6);
n4s7=RP_4_s7(:,1);  a(40)=length (n4s7);

n5s0=RP_5_s0(:,1);  a(41)=length (n5s0);
n5s1=RP_5_s1(:,1);  a(42)=length (n5s1);
n5s2=RP_5_s2(:,1);  a(43)=length (n5s2);
n5s3=RP_5_s3(:,1);  a(44)=length (n5s3);
n5s4=RP_5_s4(:,1);  a(45)=length (n5s4);
n5s5=RP_5_s5(:,1);  a(46)=length (n5s5); 
n5s6=RP_5_s6(:,1);  a(47)=length (n5s6); 
n5s7=RP_5_s7(:,1);  a(48)=length (n5s7); 

n6s0=RP_6_s0(:,1);  a(49)=length (n6s0);
n6s1=RP_6_s1(:,1);  a(50)=length (n6s1);
n6s2=RP_6_s2(:,1);  a(51)=length (n6s2);
n6s3=RP_6_s3(:,1);  a(52)=length (n6s3);
n6s4=RP_6_s4(:,1);  a(53)=length (n6s4);
n6s5=RP_6_s5(:,1);  a(54)=length (n6s5);
n6s6=RP_6_s6(:,1);  a(55)=length (n6s6);
n6s7=RP_6_s7(:,1);  a(56)=length (n6s7);

n7s0=RP_7_s0(:,1);  a(57)=length (n7s0);
n7s1=RP_7_s1(:,1);  a(58)=length (n7s1);
n7s2=RP_7_s2(:,1);  a(59)=length (n7s2);
n7s3=RP_7_s3(:,1);  a(60)=length (n7s3);
n7s4=RP_7_s4(:,1);  a(61)=length (n7s4);
n7s5=RP_7_s5(:,1);  a(62)=length (n7s5);
n7s6=RP_7_s6(:,1);  a(63)=length (n7s6);
n7s7=RP_7_s7(:,1);  a(64)=length (n7s7);

nTimeTrial=max(a);

DataTrialRow=zeros(nHippo,nStim,nTimeTrial);

b00=zeros(nTimeTrial-length(n0s0),1);  DataTrialRow(1,1,:)= vertcat(n0s0,b00);
b01=zeros(nTimeTrial-length(n0s1),1);  DataTrialRow(1,2,:)= vertcat(n0s1,b01);
b02=zeros(nTimeTrial-length(n0s2),1);  DataTrialRow(1,3,:)= vertcat(n0s2,b02);
b03=zeros(nTimeTrial-length(n0s3),1);  DataTrialRow(1,4,:)= vertcat(n0s3,b03);
b04=zeros(nTimeTrial-length(n0s4),1);  DataTrialRow(1,5,:)= vertcat(n0s4,b04);
b05=zeros(nTimeTrial-length(n0s5),1);  DataTrialRow(1,6,:)= vertcat(n0s5,b05);
b06=zeros(nTimeTrial-length(n0s6),1);  DataTrialRow(1,7,:)= vertcat(n0s6,b06);
b07=zeros(nTimeTrial-length(n0s7),1);  DataTrialRow(1,8,:)= vertcat(n0s7,b07);


b10=zeros(nTimeTrial-length(n1s0),1);  DataTrialRow(2,1,:)= vertcat(n1s0,b10);
b11=zeros(nTimeTrial-length(n1s1),1);  DataTrialRow(2,2,:)= vertcat(n1s1,b11);
b12=zeros(nTimeTrial-length(n1s2),1);  DataTrialRow(2,3,:)= vertcat(n1s2,b12);
b13=zeros(nTimeTrial-length(n1s3),1);  DataTrialRow(2,4,:)= vertcat(n1s3,b13);
b14=zeros(nTimeTrial-length(n1s4),1);  DataTrialRow(2,5,:)= vertcat(n1s4,b14);
b15=zeros(nTimeTrial-length(n1s5),1);  DataTrialRow(2,6,:)= vertcat(n1s5,b15);
b16=zeros(nTimeTrial-length(n1s6),1);  DataTrialRow(2,7,:)= vertcat(n1s6,b16);
b17=zeros(nTimeTrial-length(n1s7),1);  DataTrialRow(2,8,:)= vertcat(n1s7,b17);

b20=zeros(nTimeTrial-length(n2s0),1);  DataTrialRow(3,1,:)= vertcat(n2s0,b20);
b21=zeros(nTimeTrial-length(n2s1),1);  DataTrialRow(3,2,:)= vertcat(n2s1,b21);
b22=zeros(nTimeTrial-length(n2s2),1);  DataTrialRow(3,3,:)= vertcat(n2s2,b22);
b23=zeros(nTimeTrial-length(n2s3),1);  DataTrialRow(3,4,:)= vertcat(n2s3,b23);
b24=zeros(nTimeTrial-length(n2s4),1);  DataTrialRow(3,5,:)= vertcat(n2s4,b24);
b25=zeros(nTimeTrial-length(n2s5),1);  DataTrialRow(3,6,:)= vertcat(n2s5,b25);
b26=zeros(nTimeTrial-length(n2s6),1);  DataTrialRow(3,7,:)= vertcat(n2s6,b26);
b27=zeros(nTimeTrial-length(n2s7),1);  DataTrialRow(3,8,:)= vertcat(n2s7,b27);

b30=zeros(nTimeTrial-length(n3s0),1);  DataTrialRow(4,1,:)= vertcat(n3s0,b30);
b31=zeros(nTimeTrial-length(n3s1),1);  DataTrialRow(4,2,:)= vertcat(n3s1,b31);
b32=zeros(nTimeTrial-length(n3s2),1);  DataTrialRow(4,3,:)= vertcat(n3s2,b32);
b33=zeros(nTimeTrial-length(n3s3),1);  DataTrialRow(4,4,:)= vertcat(n3s3,b33);
b34=zeros(nTimeTrial-length(n3s4),1);  DataTrialRow(4,5,:)= vertcat(n3s4,b34);
b35=zeros(nTimeTrial-length(n3s5),1);  DataTrialRow(4,6,:)= vertcat(n3s5,b35);
b36=zeros(nTimeTrial-length(n3s6),1);  DataTrialRow(4,7,:)= vertcat(n3s6,b36);
b37=zeros(nTimeTrial-length(n3s7),1);  DataTrialRow(4,8,:)= vertcat(n3s7,b37);

b40=zeros(nTimeTrial-length(n4s0),1);  DataTrialRow(5,1,:)= vertcat(n4s0,b40);
b41=zeros(nTimeTrial-length(n4s1),1);  DataTrialRow(5,2,:)= vertcat(n4s1,b41);
b42=zeros(nTimeTrial-length(n4s2),1);  DataTrialRow(5,3,:)= vertcat(n4s2,b42);
b43=zeros(nTimeTrial-length(n4s3),1);  DataTrialRow(5,4,:)= vertcat(n4s3,b43);
b44=zeros(nTimeTrial-length(n4s4),1);  DataTrialRow(5,5,:)= vertcat(n4s4,b44);
b45=zeros(nTimeTrial-length(n4s5),1);  DataTrialRow(5,6,:)= vertcat(n4s5,b45);
b46=zeros(nTimeTrial-length(n4s6),1);  DataTrialRow(5,7,:)= vertcat(n4s6,b46);
b47=zeros(nTimeTrial-length(n4s7),1);  DataTrialRow(5,8,:)= vertcat(n4s7,b47);

b50=zeros(nTimeTrial-length(n5s0),1);  DataTrialRow(6,1,:)= vertcat(n5s0,b50);
b51=zeros(nTimeTrial-length(n5s1),1);  DataTrialRow(6,2,:)= vertcat(n5s1,b51);
b52=zeros(nTimeTrial-length(n5s2),1);  DataTrialRow(6,3,:)= vertcat(n5s2,b52);
b53=zeros(nTimeTrial-length(n5s3),1);  DataTrialRow(6,4,:)= vertcat(n5s3,b53);
b54=zeros(nTimeTrial-length(n5s4),1);  DataTrialRow(6,5,:)= vertcat(n5s4,b54);
b55=zeros(nTimeTrial-length(n5s5),1);  DataTrialRow(6,6,:)= vertcat(n5s5,b55);
b56=zeros(nTimeTrial-length(n5s6),1);  DataTrialRow(6,7,:)= vertcat(n5s6,b56);
b57=zeros(nTimeTrial-length(n5s7),1);  DataTrialRow(6,8,:)= vertcat(n5s7,b57);

b60=zeros(nTimeTrial-length(n6s0),1);  DataTrialRow(7,1,:)= vertcat(n6s0,b60);
b61=zeros(nTimeTrial-length(n6s1),1);  DataTrialRow(7,2,:)= vertcat(n6s1,b61);
b62=zeros(nTimeTrial-length(n6s2),1);  DataTrialRow(7,3,:)= vertcat(n6s2,b62);
b63=zeros(nTimeTrial-length(n6s3),1);  DataTrialRow(7,4,:)= vertcat(n6s3,b63);
b64=zeros(nTimeTrial-length(n6s4),1);  DataTrialRow(7,5,:)= vertcat(n6s4,b64);
b65=zeros(nTimeTrial-length(n6s5),1);  DataTrialRow(7,6,:)= vertcat(n6s5,b65);
b66=zeros(nTimeTrial-length(n6s6),1);  DataTrialRow(7,7,:)= vertcat(n6s6,b66);
b67=zeros(nTimeTrial-length(n6s7),1);  DataTrialRow(7,8,:)= vertcat(n6s7,b67);

b70=zeros(nTimeTrial-length(n7s0),1);  DataTrialRow(8,1,:)= vertcat(n7s0,b70);
b71=zeros(nTimeTrial-length(n7s1),1);  DataTrialRow(8,2,:)= vertcat(n7s1,b71);
b72=zeros(nTimeTrial-length(n7s2),1);  DataTrialRow(8,3,:)= vertcat(n7s2,b72);
b73=zeros(nTimeTrial-length(n7s3),1);  DataTrialRow(8,4,:)= vertcat(n7s3,b73);
b74=zeros(nTimeTrial-length(n7s4),1);  DataTrialRow(8,5,:)= vertcat(n7s4,b74);
b75=zeros(nTimeTrial-length(n7s5),1);  DataTrialRow(8,6,:)= vertcat(n7s5,b75);
b76=zeros(nTimeTrial-length(n7s6),1);  DataTrialRow(8,7,:)= vertcat(n7s6,b76);
b77=zeros(nTimeTrial-length(n7s7),1);  DataTrialRow(8,8,:)= vertcat(n7s7,b77);

nTimePerRun= 550000;
stimulusIndex = @(X) 1*X(1)+2*X(2)+3*X(3)+4*X(4)+4*X(6);
DataRun=zeros(nHippo,nStim,nRun,nTimePerRun);
Data_iRun=zeros(1,nTimePerRun);
InVec=zeros(1,6);
for iCell= 1: nHippo,
    for iStim=1:nStim,
        count=0;
        t=1;
        n=0;
        EndRun=1;
        nt=0;
        ir_old=1;     
        while(EndRun ~= 0) 
            ir=DataTrialRow(iCell,iStim,n+t);
            if ir_old==ir, 
              t=t;
              n=n;
              nt=nt+1;
            else
              n=n+t-1;  
              t=1;
              nt=1;
            end             
          it=DataTrialRow(iCell,iStim,n+t+1);
          c =DataTrialRow(iCell,iStim,n+t+2);
          for i=1:c+2,
               DataRun(iCell,iStim,ir,t+i-nt)=DataTrialRow(iCell,iStim,n+t+i);
          end
          t=t+c+3;
          ir_old=ir;
          if (n+t-1)>=nTimeTrial,
             EndRun=0;
          else
              EndRun=DataTrialRow(iCell,iStim,n+t);
          end
        end
    
    end
end
     
%%  Depict Raster plot   
nBin = 4;
%load W12_MAX.txt;
%load W12_MAX_Binary.txt;
%W12_MAXIMUM =  W12_MAX(:,1);
%W12_MAXIMUM_Binary = W12_MAX_Binary;
%FiringRatePerTrial      = cell(nRun,1);
%FIndexPerTrial          = cell(nRun,1);
%W12_iRun                = zeros(1,nHippo);
for iRun=1:1:nRun,
RasterPlot  = ManySlotBuffer(nStim*nHippo,nMaxSample,nMaxTime);    
    for iCell= 1: nHippo,
         for iStim=1:nStim,
             switch iStim
             case 1 
                 InVec=[1 0 0 0 1 0]; %S0
             case 2
                 InVec=[0 1 0 0 1 0]; %S1
             case 3 
                 InVec=[0 0 1 0 1 0]; %S2
             case 4 
                 InVec=[0 0 0 1 1 0]; %S3
             case 5 
                 InVec=[1 0 0 0 0 1]; %S4
             case 6 
                 InVec=[0 1 0 0 0 1]; %S5
             case 7
                 InVec=[0 0 1 0 0 1]; %S6
             case 8
                 InVec=[0 0 0 1 0 1]; %S7 
             end
             
             iSlot   = sub2ind([nStim nHippo],stimulusIndex(InVec),iCell);        
                   t=1;
                   EndDataRow=1;
                   Data_iRun=DataRun(iCell,iStim,iRun,:);
                   
                while(EndDataRow ~= 0)  
                      a=Data_iRun(t) ;   
                      b=Data_iRun(t+1);
                      DataRow=zeros(b+2,1);                      
                      for i=1:b+2,
                         DataRow(i)=Data_iRun(t+i-1);
                      end
                      t=t+b+2;
                      RasterPlot.addEntryToSlot(iSlot,DataRow);
      
                      if t>=length(Data_iRun),
                          EndDataRow=0;
                      else
                          EndDataRow=Data_iRun(t+1);
                      end
                end        
                
         
         end
    end
    
end  

iRun=1;
PlotIndex   = [1 3 5 7 2 4 6 8];
PlotName    = {'A','B','C','D','E','F', 'G','H'};
%PlotName    = {'A','B','C','D'};
CellIndex   = [1 2 3 4 5 6 7 8];
%CellIndex   = [1 4 5 8];
diagram=zeros(nStim,nStim,1);
    for iIndex = 1:length(CellIndex),
                 iCell = CellIndex(iIndex);
                 figure('Position',[50 50 1200 400],'PaperPosition',[1 1 9 3],...
                 'Name',['Figure 4',PlotName{iIndex}],'numbertitle','off'); 
                 for iStim = 1:nStim,
                      iSlot           = sub2ind([nStim nHippo],iStim,iCell);
                      DataTrialSpike  = RasterPlot.getAllEntryForSlot(iSlot);
                      DataSpike       = DataTrialSpike(:,3:end);
                      [X,Y]           = find(DataSpike)
                      nSample         = size(DataSpike,1);
                      diagram(iIndex,iStim)=sum(sum(DataSpike));
                      subplot(2,4,PlotIndex(iStim)); 
                      plot(Y*dt,X,'.k');
                      xlabel('Time to action (us)');
                      ylabel('Sample');
                      axis([0 200 0 35]);
                      box on;
                      %text(200,35,sprintf('spikes:%d,samples:%d',...
                      %sum(sum(DataSpike)),nSample));
                     % title(sprintf('iRun=%d',iRun));
                 end
     end








