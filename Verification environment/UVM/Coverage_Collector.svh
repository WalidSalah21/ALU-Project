`uvm_analysis_imp_decl(_mon_out)
`uvm_analysis_imp_decl(_mon_inp)
class ALU_Coverage_Collector extends uvm_scoreboard;
`uvm_component_utils(ALU_Coverage_Collector)
//==============================================================================
//Description: Declare my transactions here
//==============================================================================
ALU_Trans inp_trans,out_trans;
//==============================================================================
//Description: Declare mailboxs
//==============================================================================
uvm_analysis_imp_mon_inp  #(ALU_Trans,ALU_Coverage_Collector) mon_inp2cov;
uvm_analysis_imp_mon_out  #(ALU_Trans,ALU_Coverage_Collector) mon_out2cov;
//==============================================================================
//Description: Declare flags here
//==============================================================================
bit B_OPERATION1_flag,B_OPERATION2_flag,A_OPERATION_flag;  //thus flags to check the sampled data are that executed in the design
//==============================================================================
//Description: Declare my output coverage collector here
//==============================================================================
	covergroup ALU_coverage_outputs;
		//declare your coverage bins here
		out_point: coverpoint out_trans.C {
        bins out_zero       = {0};
		bins Max_Arth_Value = {30};
		bins Min_Arth_Value = {-30};
		bins out_positive   = {[1:29],31};
		bins out_negative   = {[-29:-1],-31};
        illegal_bins out_illegal = {-32};
		}

	error_point: coverpoint out_trans.error_flag {
		bins error_zero = {0};
		bins error_one  = {1};
		bins error_conseq_ones = (1[*2:4]);       // 1 for 2 to 4 times
	  }

		//cross coverage
	//cross_point
	endgroup:ALU_coverage_outputs
//==============================================================================
//Description: Declare my input coverage collector here
//Note: the conditions on the coverpoins represent the cross between the inputs
//==============================================================================
	covergroup ALU_coverage_inputs;
		//declare your coverage bins here	
		RST_Point: coverpoint inp_trans.rst_n {
		bins rst_n_zero = {0};  
		bins rst_n_one  = {1};           
		bins rst_n_conseq_ones = (1[*2:4]);       // 1 for 2 to 4 times    
		}

		ALU_EN: coverpoint inp_trans.ALU_en {
		bins ALU_en_zero = {0};  //
		bins ALU_en_one = {1};
		bins ALU_en_transitionL2H   = (0=>1);      //transition from 0 to 1 
		bins ALU_en_transitionH2H[] = (1[*2:4]);   //transition from 1 to 1 more than one time to check correctness of sampling in the ENV
		}

        A_OPERATION: coverpoint  inp_trans.a_op iff(A_OPERATION_flag) {
			bins a_op_add 	  		  = {0};
			bins a_op_sub 	  		  = {1};
			bins a_op_XOR 	  		  = {2}; 
			bins a_op_AND1 	  		  = {3};
			bins a_op_and2 	  		  = {4};
			bins a_op_OR  	  		  = {5};
			bins a_op_XNOR 			  = {6};
	        illegal_bins a_op_illegal = {7};
			bins a_op_More1_add       =(0[*2:3]);
			bins a_op_More1_sub       =(1[*2:3]);
			bins a_op_More1_XOR       =(2[*2:3]);
			bins a_op_More1_AND1      =(3[*2:3]);
			bins a_op_More1_AND2      =(4[*2:3]);
			bins a_op_More1_OR        =(5[*2:3]);
			bins a_op_More1_XNOR      =(6[*2:3]);
		}

		B_OPERATION1: coverpoint inp_trans.b_op iff (B_OPERATION1_flag){
		    bins b_op_NAND  = {0}; 
			bins b_op_ADD1  = {1};
			bins b_op_ADD2  = {2};
			illegal_bins b_op_illegal = {3};
			bins b_op1_More1_NAND = (0[*2]);
			bins b_op1_More1_ADD1 = (1[*2]);
			bins b_op1_More1_ADD2 = (2[*2]);
		}

		B_OPERATION2: coverpoint inp_trans.b_op iff (B_OPERATION2_flag){
			bins b_op_XOR    = {0};
			bins b_op_XNOR   = {1};
			bins b_op_SUB_1  = {2}; 
			bins b_op_ADD_2  = {3};
			bins b_op2_More1_XOR   = (0[*2:3]);
			bins b_op2_More1_XNOR  = (1[*2:3]);
			bins b_op2_More1_SUB_1 = (2[*2:3]);
			bins b_op2_More1_ADD_2 = (3[*2:3]); //
		}

		A_EN: coverpoint inp_trans.a_en iff(inp_trans.rst_n && inp_trans.ALU_en){
         bins a_en_zero = {0};
		 bins a_en_one  = {1};
		 bins a_en_transitionL2H = (0=>1);          //transition from 0 to 1
		 bins a_en_transitionH2L = (1=>0);          //transition from 1 to 0
		}
		B_EN: coverpoint inp_trans.b_en  iff(inp_trans.rst_n && inp_trans.ALU_en){
		 bins b_en_zero = {0};
		 bins b_en_one  = {1};
		 bins b_en_transitionL2H = (0=>1);          //transition from 0 to 1
		 bins b_en_transitionH2L = (1=>0);          //transition from 1 to 0 	
		}
		 endgroup:ALU_coverage_inputs
//======================================
//declare constructor
//======================================
function new (string name = "ALU_Coverage_Collector",uvm_component parent =null);
super.new(name,parent);
ALU_coverage_outputs = new();
ALU_coverage_inputs = new();
mon_inp2cov =new("mon_inp2cov",this);
mon_out2cov =new("mon_out2cov",this);
inp_trans = ALU_Trans::type_id::create("inp_trans");
out_trans = ALU_Trans::type_id::create("out_trans");
endfunction:new
//======================================
//declare extern methods
//======================================
extern function void write_mon_inp(ALU_Trans m_inp_pkt);
extern function void write_mon_out(ALU_Trans m_out_pkt);
endclass:ALU_Coverage_Collector
//======================================
//extern methods
//======================================
function void ALU_Coverage_Collector::write_mon_inp(ALU_Trans m_inp_pkt);
inp_trans = m_inp_pkt;
`uvm_info(get_type_name(),$sformatf("get the monitor INP data from the DRIVER"),UVM_NONE);
 
		if(inp_trans.rst_n && inp_trans.ALU_en && inp_trans.a_en && !inp_trans.b_en)begin
			A_OPERATION_flag  = 1;
			B_OPERATION1_flag = 0;
			B_OPERATION2_flag = 0;
		end
		else if(inp_trans.rst_n && inp_trans.ALU_en && !inp_trans.a_en && inp_trans.b_en)begin
			A_OPERATION_flag  = 0;
			B_OPERATION1_flag = 1;
			B_OPERATION2_flag = 0;
		end
		else if(inp_trans.rst_n && inp_trans.ALU_en && inp_trans.a_en && inp_trans.b_en)begin
			A_OPERATION_flag  = 0;
			B_OPERATION1_flag = 0;
			B_OPERATION2_flag = 1;
		end 
		//sample the coverage
		ALU_coverage_inputs.sample();

endfunction:write_mon_inp

function void ALU_Coverage_Collector::write_mon_out(ALU_Trans m_out_pkt);
out_trans = m_out_pkt;
ALU_coverage_outputs.sample();
`uvm_info(get_type_name(),$sformatf("get the monitor out data from the DUT"),UVM_NONE);
endfunction:write_mon_out
