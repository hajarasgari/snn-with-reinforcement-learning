

//==============================================================================
// router configuration options
//==============================================================================


//////////////////////////////////////////////
//// total buffer size per port in flits
parameter buffer_size = 32;

parameter one     = 32'b00000000000000000000000000000001;

parameter buffer_Time=16;

/////////////////////////////////////////////
// select network topology

parameter nRun=3; 

parameter nTrial=130;

parameter Num_Layers=3;

parameter Neurons_Layer1=6;

parameter Neurons_Layer2=8;

parameter Neurons_Layer3=2;

parameter Num_Neurons=Neurons_Layer1+Neurons_Layer2+Neurons_Layer3;

parameter nHist=2;

parameter nTimeTrial = 300001;

parameter nTimeReplay=16'b0000000001111111;// 

/////////////////////////////////////////////////////////////////
//////////Neuron parameters

   parameter V_RESET      = 32'b11110111000010100000000000000000; 
   
   parameter ETA          = 32'b00000000000010100000000000000000;
   //parameter ETA          = 32'b00000001101000000000000000000000;
    
   parameter V_th         = 32'b11111001101000000000000000000000;   
    
   parameter V_leakage    = 32'b00000000000000000000000100000000;
// parameter V_leakage    = 32'b00000000000000001000100000000000;
    
   parameter I_sensory    = 32'b00000001100000000000000000000000;
	    
   parameter W_MAX        = 32'b00000010000000000000000000000000;  
	//parameter W         = 32'b0000000xxxxxxxxxxxxxxxxx00000000; 
	
   ////#2700;
 //parameter STDP_pos     = 32'b00000000000000111000000000000000; 	
 //parameter STDP_neg     = 32'b00000000000001110000000000000000;
   
   ////#3700;
   parameter STDP_neg     = 32'b00000000000000111100000000000000; 
       
   parameter STDP_pos     = 32'b00000000000001111010000000000000; 
         
   parameter Inh          = 32'b11000000000000000000000000000000; 

//////////////////////////////////////////////////////////////////
////////    Learning phase

  // parameter I_sensory_R   = 32'b00000001101111000000000000000000;    

   //parameter I_hippo_R     = 32'b00000001100001000000000000000000; 

  // parameter I_motor_R     = 32'b00000001011000000000000000000000; 

  // parameter I_sensory_NR  = 32'b00000001011000000000000000000000;

  // parameter I_hippo_NR    = 32'b00000001100001000000000000000000; 

  // parameter I_motor_NR    = 32'b00000001101111000000000000000000; 
   
   
   
   
   parameter I_sensory_R   = 32'b00000000001101111000000000000000;//0.045e-3
   
   parameter I_hippo_R     = 32'b00000000001100001000000000000000;  //0.043e-3
   
   parameter I_motor_R     = 32'b00000000001011000000001000000000;   //0.040e-3
   
   parameter I_sensory_NR  = 32'b00000000001011000000001000000000; //0.011e-3
   
   parameter I_hippo_NR    = 32'b00000000001100001000000000000000;  //0.013e-3
   
   parameter I_motor_NR    = 32'b00000000001101111000000000000000;   //0.015e-3
   
   //parameter nTimeReplay=32'b00000000101010000000000000000000;//

    



