class ALU_Coverage_Collector;
//==============================================================================
//Description: Declare my mailboxes here
//==============================================================================
mailbox #(ALU_Trans) mon_OUT2cov_collect_mb,mon_INP2cov_collect_mb;
//==============================================================================
//Description: Declare my transactions here
//==============================================================================
ALU_Trans inp_trans,out_trans;
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
//External Methods
//======================================
	extern function new(mailbox #(ALU_Trans) mon_OUT2cov_collect_mb,mon_INP2cov_collect_mb);
	extern task Coverage_Collector_run();
	
endclass:ALU_Coverage_Collector

//======================================
//task to monitor the output
//======================================
function ALU_Coverage_Collector::new(mailbox #(ALU_Trans) mon_OUT2cov_collect_mb,mon_INP2cov_collect_mb);
			this.mon_OUT2cov_collect_mb = mon_OUT2cov_collect_mb;
			this.mon_INP2cov_collect_mb = mon_INP2cov_collect_mb;
			//create the coverage collector
			ALU_coverage_outputs = new();
			ALU_coverage_inputs = new();
		endfunction:new
//===================================================
task ALU_Coverage_Collector::Coverage_Collector_run();
	    forever begin
			fork
				//wait for the transaction to be available
				begin
				mon_OUT2cov_collect_mb.get(out_trans);
				//sample the coverage
				ALU_coverage_outputs.sample();
				end
				
				begin
				mon_INP2cov_collect_mb.get(inp_trans);
				if(inp_trans.a_op == 7 ) $stop; //stop the simulation if the operation is 7

				if(inp_trans.rst_n && inp_trans.ALU_en && inp_trans.a_en && !inp_trans.b_en)begin
                    A_OPERATION_flag = 1;
					B_OPERATION1_flag = 0;
					B_OPERATION2_flag = 0;
				end
				else if(inp_trans.rst_n && inp_trans.ALU_en && !inp_trans.a_en && inp_trans.b_en)begin
					A_OPERATION_flag = 0;
					B_OPERATION1_flag = 1;
					B_OPERATION2_flag = 0;
				end
				else if(inp_trans.rst_n && inp_trans.ALU_en && inp_trans.a_en && inp_trans.b_en)begin
					A_OPERATION_flag = 0;
					B_OPERATION1_flag = 0;
					B_OPERATION2_flag = 1;
				end 
				//sample the coverage
				ALU_coverage_inputs.sample();
				end
			join_any
			disable fork;  //disable the fork to avoid the infinite loop and reiterate the process
		end
	endtask:Coverage_Collector_run