package ALU_Package;
typedef enum logic [2:0] {
        Normal_senario1,
        Corner_case1,
        Corner_case2,
        Fault_injection1,
		all
    } senarios;
	  parameter WIDTH = 5;
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
endpackage:ALU_Package
	