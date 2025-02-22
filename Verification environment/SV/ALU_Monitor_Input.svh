class ALU_Monitor_Input;
//======================================
//declare your interface here
//======================================
virtual ALU_Interface intf;
//======================================
//declare your mailbox here
//======================================
mailbox#(ALU_Trans) mon_INP2GoldenModel_mb,mon_INP2cov_collect_mb;
//======================================
//Extern Methods
//======================================
  extern task monitor_run();
  extern function new(virtual ALU_Interface intf,mailbox #(ALU_Trans) mon_INP2GoldenModel_mb,mon_INP2cov_collect_mb);
endclass: ALU_Monitor_Input
//======================================
//task to monitor the input
//======================================
function  ALU_Monitor_Input::new(virtual ALU_Interface intf,mailbox#(ALU_Trans) mon_INP2GoldenModel_mb,mon_INP2cov_collect_mb);
this.intf = intf;
this.mon_INP2GoldenModel_mb = mon_INP2GoldenModel_mb;
this.mon_INP2cov_collect_mb = mon_INP2cov_collect_mb;
if (!this.intf) begin   //check if the interface is assigned
			$fatal("[ALU_Monitor_Input]Interface is not properly assigned.");
end
endfunction:new

task ALU_Monitor_Input::monitor_run();
int trans_ID =0;
ALU_Trans trans;
	forever begin
	$display("[ALU_Monitor_Input ]Waiting for data from generator with trans_ID -->[%0d]",trans_ID);
	@(posedge intf.clk iff (intf.ALU_en || !intf.rst_n))
	$display("[ALU_Monitor_Input]Get data from generator before sending to golden model and coverage collector with trans_ID -->[%0d]",trans_ID);
	trans = new();
	trans.a_op   = intf.a_op;
	trans.b_op   = intf.b_op;
	trans.a_en   = intf.a_en;
	trans.b_en   = intf.b_en;
	trans.ALU_en = intf.ALU_en;
	trans.rst_n  = intf.rst_n;
	trans.A 	 = intf.A;
	trans.B      = intf.B;
	//if(trans.a_op == 7 ) $stop; //stop the simulation if the operation is 7
	mon_INP2cov_collect_mb.put(trans);
    mon_INP2GoldenModel_mb.put(trans);
	$display("[ALU_Monitor_Input]Send Data to golden model and coverage collector with trans_ID -->[%0d],[%p]",trans_ID,trans);
	trans_ID++;
	end
endtask:monitor_run
