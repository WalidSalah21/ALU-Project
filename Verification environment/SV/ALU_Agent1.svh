class ALU_Agent1;
//======================================
//declare the components
//======================================
ALU_Generator gen;
ALU_Driver drv;
ALU_Monitor_Output mon_out;
ALU_Monitor_Input  mon_inp;
//======================================
//declare mailbox
//======================================
mailbox #(ALU_Trans) mon_OUT2chk_mb ,mon_OUT2cov_collect_mb ,gen2drv_mb ,
                    mon_INP2GoldenModel_mb,mon_INP2cov_collect_mb;
//======================================
//declare the interface
//======================================
virtual ALU_Interface intf;
//======================================
//External Methods
//======================================
	extern task ALU_Agent1_run(int rand_num_trans,senarios senario);
    extern function new(virtual ALU_Interface intf,mailbox #(ALU_Trans) mon_INP2GoldenModel_mb,mon_INP2cov_collect_mb,mon_OUT2cov_collect_mb,mon_OUT2chk_mb);
endclass:ALU_Agent1

//======================================
//New function
//======================================
function  ALU_Agent1::new(virtual ALU_Interface intf,mailbox #(ALU_Trans) mon_INP2GoldenModel_mb,
													mon_INP2cov_collect_mb,mon_OUT2cov_collect_mb,mon_OUT2chk_mb);
this.intf = intf;
this.mon_INP2GoldenModel_mb = mon_INP2GoldenModel_mb;
this.mon_INP2cov_collect_mb = mon_INP2cov_collect_mb;
this.mon_OUT2cov_collect_mb = mon_OUT2cov_collect_mb;
this.mon_OUT2chk_mb = mon_OUT2chk_mb;

if (!this.intf) begin   //check if the interface is assigned
	$fatal("[ALU_Driver]Interface is not properly assigned.");
end


gen2drv_mb = new(1);  //mailbox size is 1 to store only one transaction for blocking the generator instate of using event for blocking the generator
gen = new(gen2drv_mb);
drv = new(intf,gen2drv_mb);
mon_out = new(intf,mon_OUT2chk_mb,mon_OUT2cov_collect_mb);
mon_inp =new(intf,mon_INP2GoldenModel_mb,mon_INP2cov_collect_mb);
if (!intf) begin
			$fatal("Interface is not properly assigned.");
		end
if (!gen || !drv || !mon_out || !mon_inp) begin
	$fatal("One or more components are not properly initialized.");
end
endfunction:new
//======================================
//task to monitor the output
//======================================
task ALU_Agent1::ALU_Agent1_run(int rand_num_trans,senarios senario);
	   fork
		gen.generator_run(rand_num_trans,senario);
		drv.Driver_run();
		mon_out.monitor_run();
		mon_inp.monitor_run();
	   join_any
endtask:ALU_Agent1_run
