class ALU_Driver;
//=================================
//declare the interface
//=================================
virtual ALU_Interface intf;
//=================================
//declare the transaction
//=================================
 ALU_Trans  trans;
//=================================
//declare mailbox
//=================================
mailbox #(ALU_Trans) gen2drv_mb;
//=================================
//Extern Methods
//=================================
extern task Driver_run();
extern function new(virtual ALU_Interface intf,mailbox #(ALU_Trans) gen2drv_mb);
endclass:ALU_Driver
//=================================
//Methods
//=================================
function ALU_Driver::new(virtual ALU_Interface intf,mailbox #(ALU_Trans) gen2drv_mb);
this.intf = intf;
this.gen2drv_mb = gen2drv_mb;
if (!this.intf) begin   //check if the interface is assigned
			$fatal("[ALU_Driver]Interface is not properly assigned.");
end
endfunction:new
//================================================================
task ALU_Driver::Driver_run();
int trans_ID =0;
	forever begin
		$display("[ALU_Driver] Waiting for data from generator with trans_ID -->[%0d]",trans_ID);
		gen2drv_mb.get(trans);
		$display("[ALU_Driver] get data from generator before sending to DUT with trans_ID -->[%0d]",trans_ID);
		@(posedge intf.clk)
		if(trans.rst_n) intf.cb.rst_n  <= trans.rst_n;
		else 		 intf.rst_n  <= trans.rst_n;  //if reset is active then assign to the interface as the clocking block do some problem in this case so we assign the rst directly to the interface
		intf.cb.rst_n  <= trans.rst_n;
		intf.cb.A      <= trans.A;
		intf.cb.B      <= trans.B;
		intf.cb.ALU_en <= trans.ALU_en;
		intf.cb.a_op   <= trans.a_op;
		intf.cb.b_op   <= trans.b_op;
		intf.cb.a_en   <= trans.a_en;
		intf.cb.b_en   <= trans.b_en;	
		$display("[ALU_Drive] Success Send to DUT with trans_ID -->[%0d]",trans_ID);
		trans_ID++;
	end
endtask:Driver_run
