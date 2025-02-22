`timescale 1ns/1ps
//==============================================================================
//Discription: include interface file
//==============================================================================
`include "ALU_Interface.svh"

module ALU_TOP();
//==============================================================================
// Description: Parameters
//==============================================================================
    parameter ClkPeriod = 10;
	parameter WIDTH = 5;     //parameter for the width of the data
//parameter enum {Normal_senario1,Normal_senario2,Corner_case1,Corner_case2,Fault_injection1} senarios = Normal_senario1;
//==============================================================================
// Description: Include the package file
//==============================================================================
import ALU_Package::*;	
//==============================================================================
// Description: Clock
//==============================================================================
	bit           clk_tb;
	bit           stop_flag;
//==============================================================================
// Description: Random number of transactions
//==============================================================================
int rand_num_trans;
//==============================================================================
// Declare the scenario variable
//parameter senarios senario_case[5] = '{Normal_senario1,Normal_senario2,Corner_case1,Corner_case2,Fault_injection1};
//==============================================================================
//Description: Clock generator
//==============================================================================
	initial begin:clk_gen
	forever begin
	#(ClkPeriod/2) clk_tb = ~ clk_tb;
	if(stop_flag) begin  //to collect coverage right
		break;
	end
	end 
	end
//==============================================================================
//Description: Interface
//==============================================================================
ALU_Interface  intf1(clk_tb);
//==============================================================================
//Description: DUT
//==============================================================================
    ALU #(WIDTH) ALU_DUT(
		.A(intf1.A),
		.B(intf1.B),
		.clk(intf1.clk),
		.rst_n(intf1.rst_n),
		.ALU_en(intf1.ALU_en),
		.a_en(intf1.a_en),
		.b_en(intf1.b_en),
		.a_op(intf1.a_op),
		.b_op(intf1.b_op),
		.C(intf1.C),
		.error_flag(intf1.error_flag)
		);
//==============================================================================
//Description: Environment
//==============================================================================
ALU_ENV env; 
//==============================================================================
//Description: Build Environment
//==============================================================================
	function void build_env ();
	   env = new(intf1);
	   rand_num_trans = 1000;
	endfunction : build_env
	
//==============================================================================
//Description: Main block
//==============================================================================
	initial begin
		build_env();
		env.ENV_run(rand_num_trans,all);
		#120us;
		stop_flag = 1;
		#10;
		$finish();
        // case(senario)
		// Normal_senario1:begin
		// 	env.ENV_run(rand_num_trans,Normal_senario1);
		// 	$display("[TOP]Normal_senario1");
		// end
		// Normal_senario2:begin
		// 	env.ENV_run(rand_num_trans,Normal_senario2);
		// 	$display("[TOP]Normal_senario2");
		// end
		// Corner_case1:begin
		// 	env.ENV_run(rand_num_trans,Corner_case1);
		// 	$display("[TOP]Corner_case1");
		// end
		// Corner_case2:begin
		// 	env.ENV_run(rand_num_trans,Corner_case2);
		// 	$display("[TOP]Corner_case2");
		// end
		// Fault_injection1:begin
		// 	env.ENV_run(rand_num_trans,Fault_injection1);
		// 	$display("[TOP]Fault_injection1");
		// end
		// endcase
		
		//repeat(1000) @(posedge intf1.clk);
		//$stop;
	end
//==============================================================================
//Description: End of module
//==============================================================================
	initial begin
		//$fsdbDumpfile("waves.fsdb");
        //$fsdbDumpvars(0,simpleadder_directtb_driver);	
	end
//==============================================================================
//Description: final block 
//==============================================================================
	final begin
		$display("**********************************************************************************");
		$display("[Final Block] The Number of CORRECT Operation: %0d,and of INCORRECT Operation: %0d ",env.ch.CORRECT,env.ch.INCORRECT);
		$display("**********************************************************************************");
		$display("-------------Simulation has ended-------------");
	end
endmodule: ALU_TOP





// vsim ALU_TOP -coverage -c -do "run -all; coverage save -onexit _three.ucdb;" -gsenario_case=Corner_case1
// vcover report -details _three.ucdb > Corner_case1.txt


