class ALU_ENV extends uvm_env;
`uvm_component_utils(ALU_ENV)
//======================================
//declare the components
//======================================
Golden_Model gm;
ALU_Agent ag;
ALU_Checker ch;
ALU_Coverage_Collector cov;
//======================================
//declare the constructor
//======================================
function new(string name = "ALU_ENV",uvm_component parent =null);
super.new(name,parent);
endfunction:new
//======================================
//declare virtual interface
//======================================
virtual ALU_Interface intf;
//======================================
//declare extern methods
//======================================
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass:ALU_ENV

function void ALU_ENV::build_phase(uvm_phase phase);
super.build_phase(phase);
gm  = Golden_Model::type_id::create("gm",this);
ag  = ALU_Agent::type_id::create("ag",this);
cov = ALU_Coverage_Collector::type_id::create("cov",this);
ch  = ALU_Checker::type_id::create("ch",this);
//=======================================================
if(!uvm_config_db#(virtual ALU_Interface)::get(this,"","test2env",intf))
`uvm_fatal(get_full_name(),"Error on interface connectivity");
//=======================================================
uvm_config_db#(virtual ALU_Interface)::set(this,"ag","env2agent",intf);
endfunction:build_phase

function void ALU_ENV::connect_phase(uvm_phase phase);
super.connect_phase(phase);
ag.mon_inp_port.connect(cov.mon_inp2cov);  //note:must do new for both sides
ag.mon_inp_port.connect(gm.mon_inp2g_model);
ag.mon_out_port.connect(ch.mon_out2chk);
ag.mon_out_port.connect(cov.mon_out2cov);
gm.g_model2chk.connect(ch.g_model2chk);
endfunction:connect_phase




















// class ALU_ENV;
// //================================================================
// //declare the components
// //================================================================
// Golden_Model gm;
// ALU_Agent1 ag1;
// ALU_Checker ch;
// ALU_Coverage_Collector cov;
// //================================================================
// //declare the Mailboxs
// //================================================================
// mailbox #(ALU_Trans) mon_INP2cov_collect_mb, G_model2chk_mb,
//                      Agent2G_Model_mb,mon_OUT2chk_mb,mon_OUT2cov_collect_mb;
// //================================================================
// //External Methods
// //======================================
//     extern function new(virtual ALU_Interface intf);
// 	extern task ENV_run(int rand_num_trans,senarios senario);
// endclass:ALU_ENV
// //======================================
// //function new
// //======================================
// function ALU_ENV::new(virtual ALU_Interface intf);
// 	//================================================================
// 	G_model2chk_mb = new();
// 	Agent2G_Model_mb = new();
// 	mon_OUT2chk_mb = new();
// 	mon_OUT2cov_collect_mb = new();
// 	mon_INP2cov_collect_mb = new();
// 	//================================================================
// 	//initialize the components
// 	ag1 = new(intf,Agent2G_Model_mb,mon_INP2cov_collect_mb,mon_OUT2cov_collect_mb,mon_OUT2chk_mb);
// 	gm  = new(Agent2G_Model_mb,G_model2chk_mb);
// 	cov = new(mon_OUT2cov_collect_mb,mon_INP2cov_collect_mb);
// 	ch  = new(mon_OUT2chk_mb,G_model2chk_mb);
	
// 	if (!intf) begin
// 					$fatal("[at env]Interface is not properly assigned.");
// 				end
// endfunction:new
// //======================================
// //task to monitor the output
// //======================================
// task ALU_ENV::ENV_run(int rand_num_trans,senarios senario);
		
// 	   fork
// 		ag1.ALU_Agent1_run(rand_num_trans,senario);
// 		gm.G_Model_run();
// 		cov.Coverage_Collector_run();
// 		ch.checker_run();
// 	   join_any
// 	endtask:ENV_run
