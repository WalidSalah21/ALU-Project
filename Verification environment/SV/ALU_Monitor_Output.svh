class ALU_Monitor_Output;
//======================================
//declare your interface here
//======================================
virtual ALU_Interface intf;
//======================================
//declare your mailbox here
//======================================
mailbox #(ALU_Trans) mon_OUT2chk_mb,mon_OUT2cov_collect_mb;
//======================================
//Properties
//======================================
bit [1:0] counter = 0;  //this counter to solve the problem of the multiple consequitive transactions with ALU_en = 1 [env problem for sampling the correctdata] 
//======================================
//Extern Methods
//======================================
extern task monitor_run();
extern function new(virtual ALU_Interface intf,mailbox#(ALU_Trans) mon_OUT2chk_mb,mon_OUT2cov_collect_mb);
endclass:ALU_Monitor_Output
//======================================
//new function
//======================================
function  ALU_Monitor_Output::new(virtual ALU_Interface intf,mailbox #(ALU_Trans) mon_OUT2chk_mb,mon_OUT2cov_collect_mb);
	this.intf = intf;
	this.mon_OUT2chk_mb = mon_OUT2chk_mb;
	this.mon_OUT2cov_collect_mb = mon_OUT2cov_collect_mb;
	if (!this.intf) begin   //check if the interface is assigned
				$fatal("[ALU_Monitor_Output]Interface is not properly assigned.");
	end
endfunction:new
//======================================
//task to monitor the output
//======================================
task ALU_Monitor_Output::monitor_run();
int trans_ID =0;
ALU_Trans trans;
		forever begin
		$display("[ALU_Monitor_Output] waiting for data from driver with trans_ID -->[%0d]",trans_ID);
		@(posedge intf.clk iff (intf.ALU_en || !intf.rst_n  || (counter == 2))) 
		//using the fork join to solve the problem of the multiple consequitive transactions with ALU_en = 1 [env problem for sampling the correctdata]
		fork
			begin
				if(intf.ALU_en && intf.rst_n) begin
				#0	counter += 1;
				end
			    else if (!intf.rst_n) counter = 0; 
			end
			begin
				if (counter == 2 || !intf.rst_n)begin
							trans   = new();
							trans.C = intf.C;
							trans.error_flag = intf.error_flag;
							mon_OUT2chk_mb.put(trans);
							mon_OUT2cov_collect_mb.put(trans);
							$display("[ALU_Monitor_Output] send data to checker and coverage collector with trans_ID -->[%0d]",trans_ID);
							trans_ID++;
							if(!intf.rst_n) counter = 0;
							else counter -= 1;
							 
				end
				else if(intf.ALU_en)begin
					#0
					if (counter == 1)begin
							@(posedge intf.clk);
								if (!intf.rst_n) begin
									trans   = new();
									trans.C = intf.C;
									trans.error_flag = intf.error_flag;
									mon_OUT2chk_mb.put(trans);
									mon_OUT2cov_collect_mb.put(trans);
									$display("[ALU_Monitor_Output] send data to checker and coverage collector with trans_ID counter == 2 -->[%0d]",trans_ID);
									trans_ID++;
									counter = 0;
								end
								else if(intf.ALU_en) counter += 1;
								else counter -= 1;
								trans   = new();
								trans.C = intf.C;
								trans.error_flag = intf.error_flag;
								mon_OUT2chk_mb.put(trans);
								mon_OUT2cov_collect_mb.put(trans);
								$display("[ALU_Monitor_Output] send data to checker and coverage collector with trans_ID counter == 2 -->[%0d]",trans_ID);
								trans_ID++; 
					end
				      
				end
			end
		join
	 end 
	endtask:monitor_run