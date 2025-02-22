class ALU_Checker;
//==========================================
//declare your mailbox here
//==========================================
mailbox #(ALU_Trans) mon_OUT2chk_mb,G_Model2chk_mb;
//==========================================
//declare properties
//==========================================
int CORRECT ,INCORRECT;
//==========================================
//==========================================
//declare External Tasks
//==========================================
 extern task checker_run();
 extern function new(mailbox #(ALU_Trans) mon_OUT2chk_mb,G_Model2chk_mb);
endclass: ALU_Checker
//==========================================
//declare ALU_Checker Tasks
//==========================================
function ALU_Checker::new(mailbox #(ALU_Trans) mon_OUT2chk_mb,G_Model2chk_mb);
this.mon_OUT2chk_mb = mon_OUT2chk_mb;
this.G_Model2chk_mb = G_Model2chk_mb;
endfunction:new
//==========================================
task ALU_Checker::checker_run();
int trans_ID =0;
    //transaction object
    ALU_Trans Model_PKT,Output_PKT;
	forever begin
		Model_PKT = new();
		Output_PKT = new();
		//$display("[ALU_Checker] get data from monitor_output with trans_ID -->[%0d]",trans_ID);
	    G_Model2chk_mb.get(Model_PKT);
		$display("[ALU_Checker]Wait data from G_Model2chk_mb with trans_ID -->[%0d],Model_PKT.C  ->[%0d]",trans_ID,Model_PKT.C );
	    mon_OUT2chk_mb.get(Output_PKT);
		$display("[ALU_Checker] get data from mon_OUT2chk_mb with trans_ID -->[%0d],Model_PKT.C ->[%0d]",trans_ID,Output_PKT.C );

	  if((Output_PKT.C == Model_PKT.C) && (Output_PKT.error_flag == Model_PKT.error_flag))begin
		$display("[Checker task] At Time(%0d)Output is CORRECT Output_PKT.C =%0d,Model_PKT.C=%0d", $time,Output_PKT.C,Model_PKT.C);
		CORRECT = CORRECT + 1;
		$display("****************Checker CORRECT***************");
	  end
	  else begin
		$display("[Checker task] At Time(%0d)Output is ******INCORRECT*******", $time);
		$display("the value of the output from DUT -> [%0d], and from The Golden_Model -> [%0d]",Output_PKT.C,Model_PKT.C);
		$display("the value of the error  from DUT -> [%0d], and from The Golden_Model -> [%0d]",Output_PKT.error_flag,Model_PKT.error_flag);
		INCORRECT = INCORRECT + 1;
		$display("****************Checker INCORRECT***************");
		#10ns
		$stop;
	  end
	  trans_ID++;
	end
endtask: checker_run