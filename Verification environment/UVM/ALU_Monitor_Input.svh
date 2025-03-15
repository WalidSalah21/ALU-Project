class ALU_Monitor_Input extends uvm_monitor;
`uvm_component_utils(ALU_Monitor_Input)
//======================================
//declare your interface here
//======================================
virtual ALU_Interface intf;
//======================================
//declare mailboxs
//======================================
uvm_analysis_port #(ALU_Trans) mon_inp_port;
//======================================
//declare properties
//======================================
ALU_Trans trans;
//======================================
//declare constructor
//======================================
function new (string name = "ALU_Monitor_Output",uvm_component parent =null);
super.new(name,parent);
mon_inp_port =new("mon_inp_port",this);
endfunction:new
//======================================
//external methods 
//======================================
extern virtual function void build_phase(uvm_phase phase);
extern virtual task reset_phase (uvm_phase phase);
extern virtual task main_phase (uvm_phase phase);
endclass:ALU_Monitor_Input

//======================================
//class methods
//======================================
function void ALU_Monitor_Input::build_phase(uvm_phase phase);
super.build_phase(phase);
//=======================================================
if(!uvm_config_db#(virtual ALU_Interface)::get(this,"","agent2mon_inp",intf))
`uvm_fatal(get_full_name(),"Error on interface connectivity");
endfunction:build_phase

task  ALU_Monitor_Input::reset_phase(uvm_phase phase);
int trans_ID =0;
super.reset_phase(phase);
trans =ALU_Trans::type_id::create("trans");
`uvm_info(get_type_name(),$sformatf("wait reset transaction form driver"),UVM_NONE);
forever begin
 @(posedge intf.clk iff (!intf.rst_n))
    `uvm_info(get_type_name(),$sformatf("Get reset transaction form driver with trans_ID -->[%0d]",trans_ID),UVM_MEDIUM);
	trans.a_op   = intf.a_op;
	trans.b_op   = intf.b_op;
	trans.a_en   = intf.a_en;
	trans.b_en   = intf.b_en;
	trans.ALU_en = intf.ALU_en;
	trans.rst_n  = intf.rst_n;
	trans.A 	 = intf.A;
	trans.B      = intf.B;
    mon_inp_port.write(trans);
    `uvm_info(get_type_name(),$sformatf("Send reset response to coverage collector and golden model with trans_ID -->[%0d]",trans_ID),UVM_MEDIUM);                              
	trans_ID++;
end
   `uvm_info(get_type_name(),$sformatf("***finish send reset transaction to coverage collector and golden model***"),UVM_NONE);
endtask:reset_phase

task  ALU_Monitor_Input::main_phase(uvm_phase phase);
int trans_ID =0;
super.main_phase(phase);
trans =ALU_Trans::type_id::create("trans");
`uvm_info(get_type_name(),$sformatf("Waiting for data from driver"),UVM_NONE);
forever begin
@(posedge intf.clk iff (intf.ALU_en))
`uvm_info(get_type_name(),$sformatf("Get data transaction form driver with trans_ID -->[%0d]",trans_ID),UVM_MEDIUM);
trans.a_op   = intf.a_op;
trans.b_op   = intf.b_op;
trans.a_en   = intf.a_en;
trans.b_en   = intf.b_en;
trans.ALU_en = intf.ALU_en;
trans.rst_n  = intf.rst_n;
trans.A 	 = intf.A;
trans.B      = intf.B;
mon_inp_port.write(trans);
//if(trans.a_op == 7 ) $stop; //stop the simulation if the operation is 7
`uvm_info(get_type_name(),$sformatf("Send data to golden model and coverage collector with trans_ID -->[%0d]",trans_ID),UVM_MEDIUM);                              
trans_ID++;
end
`uvm_info(get_type_name(),$sformatf("***finish send data transaction to coverage collector and golden model***"),UVM_NONE);
endtask:main_phase