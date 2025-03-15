class ALU_Agent extends uvm_agent;
`uvm_component_utils(ALU_Agent)
//======================================
//declare the interface
//======================================
virtual ALU_Interface inf;
//======================================
//declare intermeidate ports
//======================================
uvm_analysis_port #(ALU_Trans) mon_inp_port,mon_out_port;
//======================================
//declare the components
//======================================
ALU_Sequencer      ALU_seqr;
ALU_Driver         ALU_drv;
ALU_Monitor_Input  ALU_mon_inp;
ALU_Monitor_Output ALU_mon_out;
//======================================
//declare the constructor
//======================================
function new(string name = "ALU_Agent",uvm_component parent =null);
super.new(name,parent);
mon_inp_port = new("mon_inp_port",this);
mon_out_port = new("mon_out_port",this);
endfunction:new

//======================================
//declare extern methods
//======================================
extern virtual function void build_phase(uvm_phase phase);
extern virtual function void connect_phase(uvm_phase phase);
endclass:ALU_Agent

function void ALU_Agent::build_phase(uvm_phase phase);
super.build_phase(phase);
ALU_seqr = ALU_Sequencer::type_id::create("ALU_seqr",this);
ALU_drv = ALU_Driver::type_id::create("ALU_drv",this);
ALU_mon_inp = ALU_Monitor_Input::type_id::create("ALU_mon_inp",this);
ALU_mon_out = ALU_Monitor_Output::type_id::create("ALU_mon_out",this);
//=======================================================
if(!uvm_config_db#(virtual ALU_Interface)::get(this,"","env2agent",inf))
`uvm_fatal(get_full_name(),"Error on interface connectivity");
//=======================================================
uvm_config_db#(virtual ALU_Interface)::set(this,"ALU_drv","agent2drv",inf);
uvm_config_db#(virtual ALU_Interface)::set(this,"ALU_mon_inp","agent2mon_inp",inf);
uvm_config_db#(virtual ALU_Interface)::set(this,"ALU_mon_out","agent2mon_out",inf);
endfunction:build_phase

function void ALU_Agent::connect_phase(uvm_phase phase);
super.connect_phase(phase);
 ALU_mon_inp.mon_inp_port.connect(mon_inp_port);
 ALU_mon_out.mon_out_port.connect(mon_out_port);
 ALU_drv.seq_item_port.connect(ALU_seqr.seq_item_export);
endfunction:connect_phase