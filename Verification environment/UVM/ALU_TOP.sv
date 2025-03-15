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
//==============================================================================
// Description: Include the packages
//==============================================================================
import uvm_pkg::*;
import ALU_Package::*;	
//==============================================================================
// Description: Clock
//==============================================================================
bit           clk_tb;
//==============================================================================
//Description: Clock generator
//==============================================================================
	initial begin:clk_gen
	forever begin
	#(ClkPeriod/2) clk_tb = ~ clk_tb;
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
//Description: Main block
//==============================================================================
	initial begin
    uvm_config_db#(virtual ALU_Interface)::set(null,"uvm_test_top","top2test",intf1);
    run_test();		
	end
endmodule: ALU_TOP






// vsim ALU_TOP -coverage -c -do "run -all; coverage save -onexit _three.ucdb;" -gsenario_case=Corner_case1
// vcover report -details _three.ucdb > Corner_case1.txt
//vlog *.sv +cover;vsim ALU_TOP +UVM_TESTNAME=ALU_ALL_Test +UVM_VERBOSITY=UVM_NONE -coverage;run -all

