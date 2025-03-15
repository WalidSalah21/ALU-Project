package ALU_Package;
import uvm_pkg::*;
	  parameter WIDTH = 5;
	  `include "uvm_macros.svh"
	  `include "ALU_Trans.svh"
      `include "ALU_Generator.svh"
	  `include "ALU_Driver.svh"
      `include "ALU_Monitor_Output.svh"
	  `include "ALU_Monitor_Input.svh"
	  `include "ALU_Agent1.svh"
      `include "Coverage_Collector.svh"
	  `include "Golden_Model.svh"
	  `include "ALU_Checker.svh"
	  `include "ALU_ENV.svh"
	  `include "base_sequence.svh" //add good command on the sequences
	  `include "Normal_Sequence.svh"
	  `include "corner_case1_Sequence.svh"
	  `include "corner_case2_Sequence.svh"
	  `include "fault_injection_Sequence.svh"
	  `include "directed_sequence.svh"
	  `include "ALU_base_test.svh"
	  `include "ALU_Normal_Test.svh"
	  `include "ALU_Corner_case1_Test.svh"
	  `include "ALU_Corner_case2_Test.svh"
	  `include "ALU_Fault_injection_Test.svh"
	  `include "ALU_directed_Test.svh"
	  `include "ALU_ALL_Test.svh"
endpackage:ALU_Package
	

	