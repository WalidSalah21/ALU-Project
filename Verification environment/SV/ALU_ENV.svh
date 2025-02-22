class ALU_ENV;
//================================================================
//declare the components
//================================================================
Golden_Model gm;
ALU_Agent1 ag1;
ALU_Checker ch;
ALU_Coverage_Collector cov;
//================================================================
//declare the Mailboxs
//================================================================
mailbox #(ALU_Trans) mon_INP2cov_collect_mb, G_model2chk_mb,
                     Agent2G_Model_mb,mon_OUT2chk_mb,mon_OUT2cov_collect_mb;
//================================================================
//External Methods
//======================================
    extern function new(virtual ALU_Interface intf);
	extern task ENV_run(int rand_num_trans,senarios senario);
endclass:ALU_ENV
//======================================
//function new
//======================================
function ALU_ENV::new(virtual ALU_Interface intf);
	//================================================================
	G_model2chk_mb = new();
	Agent2G_Model_mb = new();
	mon_OUT2chk_mb = new();
	mon_OUT2cov_collect_mb = new();
	mon_INP2cov_collect_mb = new();
	//================================================================
	//initialize the components
	ag1 = new(intf,Agent2G_Model_mb,mon_INP2cov_collect_mb,mon_OUT2cov_collect_mb,mon_OUT2chk_mb);
	gm  = new(Agent2G_Model_mb,G_model2chk_mb);
	cov = new(mon_OUT2cov_collect_mb,mon_INP2cov_collect_mb);
	ch  = new(mon_OUT2chk_mb,G_model2chk_mb);
	
	if (!intf) begin
					$fatal("[at env]Interface is not properly assigned.");
				end
endfunction:new
//======================================
//task to monitor the output
//======================================
task ALU_ENV::ENV_run(int rand_num_trans,senarios senario);
		
	   fork
		ag1.ALU_Agent1_run(rand_num_trans,senario);
		gm.G_Model_run();
		cov.Coverage_Collector_run();
		ch.checker_run();
	   join_any
	endtask:ENV_run
